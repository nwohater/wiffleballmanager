import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:wballmgr/data/database.dart';
import 'package:wballmgr/data/enums.dart';
import 'package:wballmgr/trade/trade_manager.dart';

import '../league/harness.dart';

Future<int> _activePlayerId(AppDatabase db, int teamId, {int index = 0}) async {
  final roster = await (db.select(db.players)
        ..where((p) => p.teamId.equals(teamId) & p.rosterSlot.equalsValue(RosterSlot.active)))
      .get();
  return roster[index].id;
}

/// Inserts an extra (7th) roster member directly onto the DL — DL is
/// uncapped and doesn't count toward the 6-active requirement, so this
/// doesn't disturb the team's existing 6 active players.
Future<int> _insertExtraDlPlayer(AppDatabase db, {required int teamId, required int organizationId}) {
  return db.into(db.players).insert(PlayersCompanion.insert(
        organizationId: Value(organizationId),
        teamId: Value(teamId),
        rosterSlot: const Value(RosterSlot.dl),
        firstName: 'Extra',
        lastName: 'DL',
        age: 25,
        contact: 40,
        power: 40,
        discipline: 40,
        speed: 40,
        control: 40,
        stamina: 40,
        range: 40,
        hands: 40,
        arm: 40,
        battingPotential: 40,
        pitchingPotential: 40,
        fieldingPotential: 40,
        speedPotential: 40,
      ));
}

void main() {
  group('isBeforeTradeDeadline', () {
    test('true for a season with no games scheduled', () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      final seasonId = await db.into(db.seasons).insert(SeasonsCompanion.insert(number: 1));
      expect(await isBeforeTradeDeadline(db, seasonId: seasonId), isTrue);
      await db.close();
    });

    test('locks once a game in the final 3-day series has been completed', () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      final seasonId = await db.into(db.seasons).insert(SeasonsCompanion.insert(number: 1));
      final teamIds = await makeTeamsWithRosters(db, count: 2);

      Future<int> insertGame(int day, GameStatus status) => db.into(db.games).insert(GamesCompanion.insert(
            seasonId: seasonId,
            tier: Tier.major,
            homeTeamId: teamIds[0],
            awayTeamId: teamIds[1],
            gameNumber: day,
            status: Value(status),
          ));

      // A 9-day season (3 series of 3): final series is days 7-9.
      for (var day = 1; day <= 6; day++) {
        await insertGame(day, GameStatus.completed);
      }
      await insertGame(7, GameStatus.scheduled);
      await insertGame(8, GameStatus.scheduled);
      await insertGame(9, GameStatus.scheduled);

      expect(await isBeforeTradeDeadline(db, seasonId: seasonId), isTrue);

      await (db.update(db.games)..where((g) => g.seasonId.equals(seasonId) & g.gameNumber.equals(7)))
          .write(const GamesCompanion(status: Value(GameStatus.completed)));

      expect(await isBeforeTradeDeadline(db, seasonId: seasonId), isFalse);

      await db.close();
    });
  });

  group('proposeTrade', () {
    test('throws if a listed player does not belong to the team it is listed under', () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      final seasonId = await db.into(db.seasons).insert(SeasonsCompanion.insert(number: 1));
      final teamIds = await makeTeamsWithRosters(db, count: 2);
      final wrongPlayerId = await _activePlayerId(db, teamIds[1]);
      final otherPlayerId = await _activePlayerId(db, teamIds[1], index: 1);

      await expectLater(
        () => proposeTrade(
          db,
          seasonId: seasonId,
          teamAId: teamIds[0],
          playersFromA: [wrongPlayerId],
          teamBId: teamIds[1],
          playersFromB: [otherPlayerId],
        ),
        throwsArgumentError,
      );

      await db.close();
    });

    test('throws once the trade deadline has passed', () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      final seasonId = await db.into(db.seasons).insert(SeasonsCompanion.insert(number: 1));
      final teamIds = await makeTeamsWithRosters(db, count: 2);
      await db.into(db.games).insert(GamesCompanion.insert(
            seasonId: seasonId,
            tier: Tier.major,
            homeTeamId: teamIds[0],
            awayTeamId: teamIds[1],
            gameNumber: 1,
            status: const Value(GameStatus.completed),
          ));
      final playerA = await _activePlayerId(db, teamIds[0]);
      final playerB = await _activePlayerId(db, teamIds[1]);

      await expectLater(
        () => proposeTrade(
          db,
          seasonId: seasonId,
          teamAId: teamIds[0],
          playersFromA: [playerA],
          teamBId: teamIds[1],
          playersFromB: [playerB],
        ),
        throwsStateError,
      );

      await db.close();
    });

    test('a human-controlled team always accepts; a 1-for-1 trade swaps team/org and keeps rosters legal',
        () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      final seasonId = await db.into(db.seasons).insert(SeasonsCompanion.insert(number: 1));
      final teamIds = await makeTeamsWithRosters(db, count: 2);
      // Both teams AI-controlled by default (makeTeamsWithRosters doesn't
      // mark isPlayerControlled) — irrelevant here since it's a 1-for-1
      // swap of two zero-stat (neutral-value) players, which any AI
      // evaluator accepts (receiving value == giving-up value).
      final playerA = await _activePlayerId(db, teamIds[0]);
      final playerB = await _activePlayerId(db, teamIds[1]);

      final result = await proposeTrade(
        db,
        seasonId: seasonId,
        teamAId: teamIds[0],
        playersFromA: [playerA],
        teamBId: teamIds[1],
        playersFromB: [playerB],
      );

      expect(result.accepted, isTrue);

      final teamA = await (db.select(db.teams)..where((t) => t.id.equals(teamIds[0]))).getSingle();
      final teamB = await (db.select(db.teams)..where((t) => t.id.equals(teamIds[1]))).getSingle();
      final updatedA = await (db.select(db.players)..where((p) => p.id.equals(playerA))).getSingle();
      final updatedB = await (db.select(db.players)..where((p) => p.id.equals(playerB))).getSingle();

      expect(updatedA.teamId, teamIds[1]);
      expect(updatedA.organizationId, teamB.organizationId);
      expect(updatedA.rosterSlot, RosterSlot.active);
      expect(updatedB.teamId, teamIds[0]);
      expect(updatedB.organizationId, teamA.organizationId);
      expect(updatedB.rosterSlot, RosterSlot.active);

      final rosterA = await (db.select(db.players)..where((p) => p.teamId.equals(teamIds[0]))).get();
      final rosterB = await (db.select(db.players)..where((p) => p.teamId.equals(teamIds[1]))).get();
      expect(rosterA.where((p) => p.rosterSlot == RosterSlot.active).length, 6);
      expect(rosterB.where((p) => p.rosterSlot == RosterSlot.active).length, 6);

      await db.close();
    });

    test('throws if the resulting roster would be illegal (uneven active-player counts)', () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      final seasonId = await db.into(db.seasons).insert(SeasonsCompanion.insert(number: 1));
      final teamIds = await makeTeamsWithRosters(db, count: 2);
      final playerA1 = await _activePlayerId(db, teamIds[0], index: 0);
      final playerA2 = await _activePlayerId(db, teamIds[0], index: 1);
      final playerB1 = await _activePlayerId(db, teamIds[1], index: 0);

      await expectLater(
        () => proposeTrade(
          db,
          seasonId: seasonId,
          teamAId: teamIds[0],
          playersFromA: [playerA1, playerA2],
          teamBId: teamIds[1],
          playersFromB: [playerB1],
        ),
        throwsArgumentError,
      );

      await db.close();
    });

    test('an AI-controlled side rejects an offer that would leave it worse off, without throwing', () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      final seasonId = await db.into(db.seasons).insert(SeasonsCompanion.insert(number: 1));
      final teamIds = await makeTeamsWithRosters(db, count: 2);
      final gameId = await db.into(db.games).insert(GamesCompanion.insert(
            seasonId: seasonId,
            tier: Tier.major,
            homeTeamId: teamIds[0],
            awayTeamId: teamIds[1],
            gameNumber: 1,
          ));

      final playerA = await _activePlayerId(db, teamIds[0]); // stays neutral (0 value)
      final playerB1 = await _activePlayerId(db, teamIds[1], index: 0);
      final playerB2 = await _activePlayerId(db, teamIds[1], index: 1);

      // Give team B's two offered players real, well-above-neutral batting
      // value (obp .75 + slg .80 vs. the ~.70 neutral baseline) so team B
      // (AI) is giving up clear value for team A's neutral-value player —
      // an offer any value-based evaluator should decline.
      for (final playerId in [playerB1, playerB2]) {
        await db.into(db.battingStats).insert(BattingStatsCompanion.insert(
              gameId: gameId,
              playerId: playerId,
              teamId: teamIds[1],
              pa: const Value(20),
              ab: const Value(15),
              h: const Value(10),
              doubles: const Value(2),
              bb: const Value(5),
            ));
      }

      final result = await proposeTrade(
        db,
        seasonId: seasonId,
        teamAId: teamIds[0],
        playersFromA: [playerA],
        teamBId: teamIds[1],
        playersFromB: [playerB1, playerB2],
      );

      expect(result.accepted, isFalse);
      expect(result.reason != null, isTrue);

      // Nothing was actually moved.
      final untouchedA = await (db.select(db.players)..where((p) => p.id.equals(playerA))).getSingle();
      expect(untouchedA.teamId, teamIds[0]);

      await db.close();
    });

    test('a DL player carries its slot over to the new team (both sides trade an extra DL member, '
        'so active counts stay legal on both sides)', () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      final seasonId = await db.into(db.seasons).insert(SeasonsCompanion.insert(number: 1));
      final teamIds = await makeTeamsWithRosters(db, count: 2);
      final teamA = await (db.select(db.teams)..where((t) => t.id.equals(teamIds[0]))).getSingle();
      final teamB = await (db.select(db.teams)..where((t) => t.id.equals(teamIds[1]))).getSingle();

      final dlFromA =
          await _insertExtraDlPlayer(db, teamId: teamIds[0], organizationId: teamA.organizationId);
      final dlFromB =
          await _insertExtraDlPlayer(db, teamId: teamIds[1], organizationId: teamB.organizationId);

      final result = await proposeTrade(
        db,
        seasonId: seasonId,
        teamAId: teamIds[0],
        playersFromA: [dlFromA],
        teamBId: teamIds[1],
        playersFromB: [dlFromB],
      );

      expect(result.accepted, isTrue);
      final moved = await (db.select(db.players)..where((p) => p.id.equals(dlFromA))).getSingle();
      expect(moved.teamId, teamIds[1]);
      expect(moved.rosterSlot, RosterSlot.dl);

      final rosterA = await (db.select(db.players)..where((p) => p.teamId.equals(teamIds[0]))).get();
      expect(rosterA.where((p) => p.rosterSlot == RosterSlot.active).length, 6);

      await db.close();
    });
  });
}
