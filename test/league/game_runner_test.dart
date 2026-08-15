import 'dart:math';

import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:wballmgr/career/free_agents.dart';
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

  test('playGame keeps an AI team\'s saved lineup fully resupplied after a mid-game roster swap', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final seasonId = await db.into(db.seasons).insert(SeasonsCompanion.insert(number: 1));
    final teamIds = await makeTeamsWithRosters(db, count: 2);
    final teamId = teamIds[0];
    for (final id in teamIds) {
      await db.into(db.standings).insert(StandingsCompanion.insert(seasonId: seasonId, teamId: id));
    }

    final lineupRowBefore = await (db.select(db.teamLineups)..where((l) => l.teamId.equals(teamId))).getSingle();
    final battingIdsBefore = lineupRowBefore.battingOrder.split(',').map(int.parse).toList();
    final injuredId = battingIdsBefore.first;

    // Reproduce, directly, the exact roster shape checkForInjuries'
    // moderate-injury path leaves behind (player moved to dl, a free agent
    // backfilled onto the active roster) — the gap refreshAiLineup exists
    // to close is that the saved TeamLineups row never picks the
    // replacement up on its own.
    await (db.update(db.players)..where((p) => p.id.equals(injuredId))).write(
      const PlayersCompanion(rosterSlot: Value(RosterSlot.dl), gamesUnavailable: Value(5)),
    );
    final team = await (db.select(db.teams)..where((t) => t.id.equals(teamId))).getSingle();
    final replacementId = await signFreeAgent(db, teamId: teamId, organizationId: team.organizationId);

    final gameId = await db.into(db.games).insert(GamesCompanion.insert(
          seasonId: seasonId,
          tier: Tier.major,
          homeTeamId: teamIds[0],
          awayTeamId: teamIds[1],
          gameNumber: 1,
        ));

    await playGame(db, gameId, random: Random(7));

    final lineupRowAfter = await (db.select(db.teamLineups)..where((l) => l.teamId.equals(teamId))).getSingle();
    final battingIdsAfter = lineupRowAfter.battingOrder.split(',').map(int.parse).toList();
    final pitcherIdsAfter = lineupRowAfter.pitcherRotation.split(',').map(int.parse).toList();

    // Phase 5's smarter (true-rating) AI picks a 2-deep pitcher rotation +
    // 4-player batting order (not the old 1 + 5) — the replacement could
    // rank into either slot depending on their true ratings, so check
    // presence across the whole resolved lineup rather than assuming
    // they land specifically in the batting order.
    expect(battingIdsAfter, isNot(contains(injuredId)));
    expect(pitcherIdsAfter, isNot(contains(injuredId)));
    expect([...battingIdsAfter, ...pitcherIdsAfter], contains(replacementId));
    expect(battingIdsAfter, hasLength(4));
    expect(pitcherIdsAfter, hasLength(2));

    await db.close();
  });

  test('resolveEffectiveLineup drops an unavailable batter, producing a shorter legal order', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final seasonId = await db.into(db.seasons).insert(SeasonsCompanion.insert(number: 1));
    final teamIds = await makeTeamsWithRosters(db, count: 2);
    final teamId = teamIds[0];
    final gameId = await db.into(db.games).insert(GamesCompanion.insert(
          seasonId: seasonId,
          tier: Tier.major,
          homeTeamId: teamIds[0],
          awayTeamId: teamIds[1],
          gameNumber: 1,
        ));
    final game = await (db.select(db.games)..where((g) => g.id.equals(gameId))).getSingle();
    final lineupRow = await (db.select(db.teamLineups)..where((l) => l.teamId.equals(teamId))).getSingle();
    final battingIds = lineupRow.battingOrder.split(',').map(int.parse).toList();
    final unavailableId = battingIds.first;

    await (db.update(db.players)..where((p) => p.id.equals(unavailableId))).write(
      const PlayersCompanion(gamesUnavailable: Value(2)),
    );

    final resolved = await resolveEffectiveLineup(db, lineupRow, game: game);

    expect(resolved.battingOrder.contains(unavailableId), isFalse);
    expect(resolved.battingOrder.length, battingIds.length - 1);
    expect(resolved.battingOrder.length, greaterThanOrEqualTo(3));

    await db.close();
  });

  test('resolveEffectiveLineup falls through the pitcher rotation to the next available entry', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final seasonId = await db.into(db.seasons).insert(SeasonsCompanion.insert(number: 1));
    final teamIds = await makeTeamsWithRosters(db, count: 2);
    final teamId = teamIds[0];
    final gameId = await db.into(db.games).insert(GamesCompanion.insert(
          seasonId: seasonId,
          tier: Tier.major,
          homeTeamId: teamIds[0],
          awayTeamId: teamIds[1],
          gameNumber: 1,
        ));
    final game = await (db.select(db.games)..where((g) => g.id.equals(gameId))).getSingle();
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
    final resolved = await resolveEffectiveLineup(db, updatedLineupRow, game: game);

    expect(resolved.pitcherPlan.first.playerId, backupId);

    await db.close();
  });

  test('resolveEffectiveLineup prefers rotation[0] for games 1 & 3 of a series, rotation[1] for game 2', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final seasonId = await db.into(db.seasons).insert(SeasonsCompanion.insert(number: 1));
    final teamIds = await makeTeamsWithRosters(db, count: 2);
    final teamId = teamIds[0];

    final teamPlayers = await (db.select(db.players)..where((p) => p.teamId.equals(teamId))).get();
    final ace = teamPlayers[0].id;
    final secondArm = teamPlayers[1].id;
    await (db.update(db.teamLineups)..where((l) => l.teamId.equals(teamId))).write(
      TeamLineupsCompanion(pitcherRotation: Value('$ace,$secondArm')),
    );
    final lineupRow = await (db.select(db.teamLineups)..where((l) => l.teamId.equals(teamId))).getSingle();

    Future<int> starterForGame(int gameNumber) async {
      final gameId = await db.into(db.games).insert(GamesCompanion.insert(
            seasonId: seasonId,
            tier: Tier.major,
            homeTeamId: teamIds[0],
            awayTeamId: teamIds[1],
            gameNumber: gameNumber,
          ));
      final game = await (db.select(db.games)..where((g) => g.id.equals(gameId))).getSingle();
      final resolved = await resolveEffectiveLineup(db, lineupRow, game: game);
      return resolved.pitcherPlan.first.playerId;
    }

    expect(await starterForGame(1), ace);
    expect(await starterForGame(2), secondArm);
    expect(await starterForGame(3), ace);

    await db.close();
  });

  test('resolveEffectiveLineup caps a pitcher at their remaining series-innings budget, handing off to the'
      ' rotation\'s other arm', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final seasonId = await db.into(db.seasons).insert(SeasonsCompanion.insert(number: 1));
    final teamIds = await makeTeamsWithRosters(db, count: 2);
    final teamId = teamIds[0];

    final teamPlayers = await (db.select(db.players)..where((p) => p.teamId.equals(teamId))).get();
    final ace = teamPlayers[0].id;
    final secondArm = teamPlayers[1].id;
    await (db.update(db.teamLineups)..where((l) => l.teamId.equals(teamId))).write(
      TeamLineupsCompanion(pitcherRotation: Value('$ace,$secondArm')),
    );

    // Game 1 of the series: the ace already threw 4 innings (12 outs) —
    // leaves only 2 innings of their 6-inning series budget for game 3.
    final game1Id = await db.into(db.games).insert(GamesCompanion.insert(
          seasonId: seasonId,
          tier: Tier.major,
          homeTeamId: teamIds[0],
          awayTeamId: teamIds[1],
          gameNumber: 1,
          status: const Value(GameStatus.completed),
        ));
    await db.into(db.pitchingStats).insert(PitchingStatsCompanion.insert(
          gameId: game1Id,
          playerId: ace,
          teamId: teamId,
          outsRecorded: const Value(12),
        ));

    // Game 3 of the series: gameInSeries == 2, so the ace (rotation[0]) is
    // preferred again — but only has budget for 2 more innings.
    final game3Id = await db.into(db.games).insert(GamesCompanion.insert(
          seasonId: seasonId,
          tier: Tier.major,
          homeTeamId: teamIds[0],
          awayTeamId: teamIds[1],
          gameNumber: 3,
        ));
    final game3 = await (db.select(db.games)..where((g) => g.id.equals(game3Id))).getSingle();
    final lineupRow = await (db.select(db.teamLineups)..where((l) => l.teamId.equals(teamId))).getSingle();

    final resolved = await resolveEffectiveLineup(db, lineupRow, game: game3);

    expect(resolved.pitcherPlan.length, 2);
    expect(resolved.pitcherPlan[0].playerId, ace);
    expect(resolved.pitcherPlan[0].throughInning, 2);
    expect(resolved.pitcherPlan[1].playerId, secondArm);
    expect(resolved.pitcherPlan[1].throughInning, isNull);

    await db.close();
  });

  test('resolveEffectiveLineup does not enforce the series-innings cap for playoff games', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final seasonId = await db.into(db.seasons).insert(SeasonsCompanion.insert(number: 1));
    final teamIds = await makeTeamsWithRosters(db, count: 2);
    final teamId = teamIds[0];

    final teamPlayers = await (db.select(db.players)..where((p) => p.teamId.equals(teamId))).get();
    final ace = teamPlayers[0].id;
    final secondArm = teamPlayers[1].id;
    await (db.update(db.teamLineups)..where((l) => l.teamId.equals(teamId))).write(
      TeamLineupsCompanion(pitcherRotation: Value('$ace,$secondArm')),
    );
    final lineupRow = await (db.select(db.teamLineups)..where((l) => l.teamId.equals(teamId))).getSingle();

    final seriesId = await db.into(db.playoffSeries).insert(PlayoffSeriesCompanion.insert(
          seasonId: seasonId,
          round: PlayoffRound.semifinal,
          higherSeedTeamId: teamIds[0],
          higherSeedRank: 1,
          lowerSeedTeamId: teamIds[1],
          lowerSeedRank: 4,
          bestOf: 5,
        ));
    final gameId = await db.into(db.games).insert(GamesCompanion.insert(
          seasonId: seasonId,
          tier: Tier.major,
          homeTeamId: teamIds[0],
          awayTeamId: teamIds[1],
          gameNumber: 1,
          seriesId: Value(seriesId),
        ));
    final game = await (db.select(db.games)..where((g) => g.id.equals(gameId))).getSingle();

    final resolved = await resolveEffectiveLineup(db, lineupRow, game: game);

    // Playoff series don't follow the regular season's 3-game cadence the
    // cap's "games 1 and 3" framing assumes — unrestricted single stint,
    // same as pre-cap behavior (see context/rules-mlw-cultz-field.md's
    // Known Deviations note).
    expect(resolved.pitcherPlan, hasLength(1));
    expect(resolved.pitcherPlan.single.playerId, ace);
    expect(resolved.pitcherPlan.single.throughInning, isNull);

    await db.close();
  });
}
