import 'dart:math';

import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:wballmgr/ai/team_manager.dart';
import 'package:wballmgr/career/free_agents.dart';
import 'package:wballmgr/data/database.dart';
import 'package:wballmgr/data/enums.dart';

import '../league/harness.dart';

Future<void> _markPlayerControlled(AppDatabase db, int teamId) async {
  final team = await (db.select(db.teams)..where((t) => t.id.equals(teamId))).getSingle();
  await (db.update(db.organizations)..where((o) => o.id.equals(team.organizationId))).write(
    const OrganizationsCompanion(isPlayerControlled: Value(true)),
  );
}

void main() {
  late AppDatabase db;
  late int seasonId;
  late List<int> teamIds;
  late int gameId;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    seasonId = await db.into(db.seasons).insert(SeasonsCompanion.insert(number: 1));
    teamIds = await makeTeamsWithRosters(db, count: 2);
    await _markPlayerControlled(db, teamIds[1]);
    // evaluateRosterMoves' cut-and-sign needs a real standing pool to draw
    // from — without one, the only "unrostered" player right after a
    // release is the just-cut player themselves, and they'd be re-signed
    // straight back on. makeTeamsWithRosters doesn't seed a pool (unlike
    // the real league-seeding/rollover flow, which always does).
    await topUpFreeAgentPool(db);
    gameId = await db.into(db.games).insert(GamesCompanion.insert(
          seasonId: seasonId,
          tier: Tier.major,
          homeTeamId: teamIds[0],
          awayTeamId: teamIds[1],
          gameNumber: 1,
        ));
  });

  tearDown(() async => db.close());

  group('refreshAiLineup', () {
    test('rebuilds an AI team lineup from true ratings (Phase 5 smarter AI)', () async {
      final teamId = teamIds[0];
      final players = (await (db.select(db.players)..where((p) => p.teamId.equals(teamId))).get())
          .map((p) => p.id)
          .toList();
      final ace = players[0];
      final secondArm = players[1];
      final batters = players.sublist(2); // 4 remaining

      // Make ace/secondArm the clear top 2 pitchers by true ratings.
      await (db.update(db.players)..where((p) => p.id.equals(ace))).write(
        const PlayersCompanion(control: Value(99), stamina: Value(99)),
      );
      await (db.update(db.players)..where((p) => p.id.equals(secondArm))).write(
        const PlayersCompanion(control: Value(90), stamina: Value(90)),
      );

      // Give the 4 remaining batters a strict, distinct batting-rating
      // ranking (and low pitching ratings, so they never outrank the two
      // arms above).
      for (var i = 0; i < batters.length; i++) {
        final battingRating = 80 - i * 10; // strictly decreasing
        await (db.update(db.players)..where((p) => p.id.equals(batters[i]))).write(
          PlayersCompanion(
            contact: Value(battingRating),
            power: Value(battingRating),
            discipline: Value(battingRating),
            control: const Value(5),
            stamina: const Value(5),
          ),
        );
      }

      // The two lowest-ranked batters get clearly-best fielding, so
      // fielder2/3 should be picked from them, not from the top batters.
      final fielderA = batters[2];
      final fielderB = batters[3];
      await (db.update(db.players)..where((p) => p.id.equals(fielderA))).write(
        const PlayersCompanion(range: Value(95), hands: Value(95), arm: Value(95)),
      );
      await (db.update(db.players)..where((p) => p.id.equals(fielderB))).write(
        const PlayersCompanion(range: Value(85), hands: Value(85), arm: Value(85)),
      );

      await refreshAiLineup(db, teamId: teamId);

      final row = await (db.select(db.teamLineups)..where((l) => l.teamId.equals(teamId))).getSingle();
      expect(row.pitcherRotation.split(',').map(int.parse).toList(), [ace, secondArm]);
      expect(row.battingOrder.split(',').map(int.parse).toList(), batters);
      expect(row.fielder2Id, fielderA);
      expect(row.fielder3Id, fielderB);
    });

    test('is a no-op for the player-controlled team', () async {
      final teamId = teamIds[1];
      final before = await (db.select(db.teamLineups)..where((l) => l.teamId.equals(teamId))).getSingle();

      // Seed ratings that would clearly change the lineup if this weren't
      // skipped, so the no-op is actually being exercised.
      final players =
          (await (db.select(db.players)..where((p) => p.teamId.equals(teamId))).get()).map((p) => p.id).toList();
      await (db.update(db.players)..where((p) => p.id.equals(players.last))).write(
        const PlayersCompanion(control: Value(99), stamina: Value(99)),
      );

      await refreshAiLineup(db, teamId: teamId);

      final after = await (db.select(db.teamLineups)..where((l) => l.teamId.equals(teamId))).getSingle();
      expect(after.battingOrder, before.battingOrder);
      expect(after.pitcherRotation, before.pitcherRotation);
      expect(after.fielder2Id, before.fielder2Id);
      expect(after.fielder3Id, before.fielder3Id);
    });
  });

  group('evaluateRosterMoves', () {
    test('cuts a qualified, well-below-replacement pitcher and signs a replacement', () async {
      final teamId = teamIds[0];
      final players = (await (db.select(db.players)..where((p) => p.teamId.equals(teamId))).get())
          .map((p) => p.id)
          .toList();
      final badPitcher = players[0];

      // 10 IP, ERA 6.0 / WHIP 3.0 (this league's ER*3/IP convention) —
      // clearly below the -5.3 replacement level, and qualifies (30+ outs).
      await db.into(db.pitchingStats).insert(PitchingStatsCompanion.insert(
            gameId: gameId,
            playerId: badPitcher,
            teamId: teamId,
            outsRecorded: const Value(30),
            er: const Value(20),
            bb: const Value(15),
            h: const Value(15),
          ));
      // Everyone else has decent, qualified batting lines so they aren't
      // candidates.
      for (final id in players.sublist(1)) {
        await db.into(db.battingStats).insert(BattingStatsCompanion.insert(
              gameId: gameId,
              playerId: id,
              teamId: teamId,
              pa: const Value(20),
              ab: const Value(20),
              h: const Value(8),
              bb: const Value(2),
            ));
      }

      await evaluateRosterMoves(db, teamId: teamId, completedSeasonId: seasonId, random: Random(1));

      final released = await (db.select(db.players)..where((p) => p.id.equals(badPitcher))).getSingle();
      expect(released.teamId, isNull);
      expect(released.organizationId, isNull);
      expect(released.rosterSlot, isNull);

      final activeAfter =
          await (db.select(db.players)..where((p) => p.teamId.equals(teamId) & p.rosterSlot.equalsValue(RosterSlot.active)))
              .get();
      expect(activeAfter, hasLength(6));
      expect(activeAfter.map((p) => p.id), isNot(contains(badPitcher)));
    });

    test('does not cut a below-replacement pitcher who has not thrown enough innings to qualify', () async {
      final teamId = teamIds[0];
      final players = (await (db.select(db.players)..where((p) => p.teamId.equals(teamId))).get())
          .map((p) => p.id)
          .toList();
      final badButUnqualified = players[0];

      // Same terrible rate stats as above, but only 15 outs (5 IP) — below
      // the 30-out qualifying minimum.
      await db.into(db.pitchingStats).insert(PitchingStatsCompanion.insert(
            gameId: gameId,
            playerId: badButUnqualified,
            teamId: teamId,
            outsRecorded: const Value(15),
            er: const Value(10),
            bb: const Value(8),
            h: const Value(8),
          ));

      await evaluateRosterMoves(db, teamId: teamId, completedSeasonId: seasonId, random: Random(1));

      final stillThere = await (db.select(db.players)..where((p) => p.id.equals(badButUnqualified))).getSingle();
      expect(stillThere.teamId, teamId);
    });

    test('is a no-op for the player-controlled team', () async {
      final teamId = teamIds[1];
      final players = (await (db.select(db.players)..where((p) => p.teamId.equals(teamId))).get())
          .map((p) => p.id)
          .toList();
      final badPitcher = players[0];

      await db.into(db.pitchingStats).insert(PitchingStatsCompanion.insert(
            gameId: gameId,
            playerId: badPitcher,
            teamId: teamId,
            outsRecorded: const Value(30),
            er: const Value(20),
            bb: const Value(15),
            h: const Value(15),
          ));

      await evaluateRosterMoves(db, teamId: teamId, completedSeasonId: seasonId, random: Random(1));

      final stillThere = await (db.select(db.players)..where((p) => p.id.equals(badPitcher))).getSingle();
      expect(stillThere.teamId, teamId);
    });
  });
}
