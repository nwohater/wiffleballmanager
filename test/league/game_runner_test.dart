import 'dart:math';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:wballmgr/data/database.dart';
import 'package:wballmgr/data/enums.dart';
import 'package:wballmgr/league/game_runner.dart';

import 'harness.dart';

void main() {
  test('playGame completes the game, persists a box score, and updates standings', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final seasonId = await db.into(db.seasons).insert(SeasonsCompanion.insert(number: 1));
    final teamIds = await makeTeamsWithRosters(db, count: 2);
    for (final teamId in teamIds) {
      await db.into(db.standings).insert(StandingsCompanion.insert(seasonId: seasonId, teamId: teamId));
    }
    final gameId = await db.into(db.games).insert(GamesCompanion.insert(
          seasonId: seasonId,
          tier: Tier.major,
          homeTeamId: teamIds[0],
          awayTeamId: teamIds[1],
          gameNumber: 1,
        ));

    final result = await playGame(db, gameId, random: Random(42));

    final gameRow = await (db.select(db.games)..where((g) => g.id.equals(gameId))).getSingle();
    expect(gameRow.status, GameStatus.completed);
    expect(gameRow.homeScore, result.homeScore);
    expect(gameRow.awayScore, result.awayScore);
    expect(gameRow.inningsPlayed, result.inningsPlayed);

    final battingRows = await (db.select(db.battingStats)..where((b) => b.gameId.equals(gameId))).get();
    final pitchingRows = await (db.select(db.pitchingStats)..where((p) => p.gameId.equals(gameId))).get();
    final fieldingRows = await (db.select(db.fieldingStats)..where((f) => f.gameId.equals(gameId))).get();
    expect(battingRows, isNotEmpty);
    expect(pitchingRows, isNotEmpty);
    expect(fieldingRows, isNotEmpty);

    final homeStanding = await (db.select(db.standings)..where((s) => s.teamId.equals(teamIds[0]))).getSingle();
    final awayStanding = await (db.select(db.standings)..where((s) => s.teamId.equals(teamIds[1]))).getSingle();
    expect(homeStanding.w + homeStanding.l, 1);
    expect(awayStanding.w + awayStanding.l, 1);
    expect(homeStanding.pf, result.homeScore);
    expect(homeStanding.pa, result.awayScore);

    await db.close();
  });

  test('playGame throws if the game is not scheduled', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final seasonId = await db.into(db.seasons).insert(SeasonsCompanion.insert(number: 1));
    final teamIds = await makeTeamsWithRosters(db, count: 2);
    final gameId = await db.into(db.games).insert(GamesCompanion.insert(
          seasonId: seasonId,
          tier: Tier.major,
          homeTeamId: teamIds[0],
          awayTeamId: teamIds[1],
          gameNumber: 1,
          status: const Value(GameStatus.completed),
        ));

    expect(() => playGame(db, gameId), throwsStateError);

    await db.close();
  });

  test('resolveEffectiveLineup drops an unavailable batter, producing a shorter legal order', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final teamIds = await makeTeamsWithRosters(db, count: 1);
    final teamId = teamIds[0];
    final lineupRow = await (db.select(db.teamLineups)..where((l) => l.teamId.equals(teamId))).getSingle();
    final battingIds = lineupRow.battingOrder.split(',').map(int.parse).toList();
    final unavailableId = battingIds.first;

    await (db.update(db.players)..where((p) => p.id.equals(unavailableId))).write(
      const PlayersCompanion(gamesUnavailable: Value(2)),
    );

    final resolved = await resolveEffectiveLineup(db, lineupRow);

    expect(resolved.battingOrder.contains(unavailableId), isFalse);
    expect(resolved.battingOrder.length, battingIds.length - 1);
    expect(resolved.battingOrder.length, greaterThanOrEqualTo(3));

    await db.close();
  });

  test('resolveEffectiveLineup falls through the pitcher rotation to the next available entry', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final teamIds = await makeTeamsWithRosters(db, count: 1);
    final teamId = teamIds[0];
    final lineupRow = await (db.select(db.teamLineups)..where((l) => l.teamId.equals(teamId))).getSingle();
    final starterId = lineupRow.pitcherRotation.split(',').map(int.parse).first;

    final teamPlayers = await (db.select(db.players)..where((p) => p.teamId.equals(teamId))).get();
    final backupId = teamPlayers.map((p) => p.id).firstWhere((id) => id != starterId);

    await (db.update(db.teamLineups)..where((l) => l.teamId.equals(teamId))).write(
      TeamLineupsCompanion(pitcherRotation: Value('$starterId,$backupId')),
    );
    await (db.update(db.players)..where((p) => p.id.equals(starterId))).write(
      const PlayersCompanion(gamesUnavailable: Value(2)),
    );

    final updatedLineupRow =
        await (db.select(db.teamLineups)..where((l) => l.teamId.equals(teamId))).getSingle();
    final resolved = await resolveEffectiveLineup(db, updatedLineupRow);

    expect(resolved.pitcherPlan.single.playerId, backupId);

    await db.close();
  });
}
