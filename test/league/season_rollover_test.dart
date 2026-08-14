import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:wballmgr/data/database.dart';
import 'package:wballmgr/data/enums.dart';
import 'package:wballmgr/league/league_seed.dart';
import 'package:wballmgr/league/season_rollover.dart';

void main() {
  test('rolloverSeason ends the old season and starts a fresh one', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final seasonId = await seedNewLeague(db);

    final newSeasonId = await rolloverSeason(db, completedSeasonId: seasonId);

    final oldSeason = await (db.select(db.seasons)..where((s) => s.id.equals(seasonId))).getSingle();
    expect(oldSeason.isActive, isFalse);

    final newSeason = await (db.select(db.seasons)..where((s) => s.id.equals(newSeasonId))).getSingle();
    expect(newSeason.isActive, isTrue);
    expect(newSeason.number, oldSeason.number + 1);

    final newGames = await (db.select(db.games)..where((g) => g.seasonId.equals(newSeasonId))).get();
    expect(newGames.length, 198);
    expect(newGames.every((g) => g.status == newGames.first.status), isTrue);

    final newStandings = await (db.select(db.standings)..where((s) => s.seasonId.equals(newSeasonId))).get();
    expect(newStandings.length, 12);
    expect(newStandings.every((s) => s.w == 0 && s.l == 0 && s.t == 0 && s.pf == 0 && s.pa == 0), isTrue);

    await db.close();
  });

  test('rolloverSeason ages players, clears DL/availability, and tops the free-agent pool back up',
      () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final seasonId = await seedNewLeague(db);

    final ratingsBefore = {for (final p in await db.select(db.players).get()) p.id: p.contact};

    final injuredPlayer = (await db.select(db.players).get()).first;
    await (db.update(db.players)..where((p) => p.id.equals(injuredPlayer.id))).write(
      const PlayersCompanion(rosterSlot: Value(RosterSlot.dl), gamesUnavailable: Value(5)),
    );

    final anyTeam = (await db.select(db.teams).get()).first;
    final freeAgentsBefore = await (db.select(db.players)..where((p) => p.teamId.isNull())).get();
    expect(freeAgentsBefore, isNotEmpty);
    for (final fa in freeAgentsBefore.take(5)) {
      await (db.update(db.players)..where((p) => p.id.equals(fa.id))).write(
        PlayersCompanion(teamId: Value(anyTeam.id), organizationId: Value(anyTeam.organizationId)),
      );
    }
    final poolAfterConsumption = await (db.select(db.players)..where((p) => p.teamId.isNull())).get();
    expect(poolAfterConsumption.length, freeAgentsBefore.length - 5);

    await rolloverSeason(db, completedSeasonId: seasonId);

    final playersAfter = await db.select(db.players).get();
    final changedRatings = playersAfter.where((p) => p.contact != ratingsBefore[p.id]);
    expect(changedRatings, isNotEmpty, reason: 'at least one player should develop (growth/decline/jitter)');

    final recoveredInjured =
        await (db.select(db.players)..where((p) => p.id.equals(injuredPlayer.id))).getSingle();
    expect(recoveredInjured.rosterSlot, RosterSlot.active, reason: 'DL forced back to active at season end');

    expect(playersAfter.every((p) => p.gamesUnavailable == 0), isTrue,
        reason: 'everyone starts the new season healthy');

    final poolAfterRollover = await (db.select(db.players)..where((p) => p.teamId.isNull())).get();
    expect(poolAfterRollover.length, freeAgentsBefore.length, reason: 'free-agent pool topped back up');

    await db.close();
  });
}
