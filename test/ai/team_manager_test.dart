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
    test('rebuilds an AI team lineup from observed stats, ignoring true ratings', () async {
      final teamId = teamIds[0];
      final players = (await (db.select(db.players)..where((p) => p.teamId.equals(teamId))).get())
          .map((p) => p.id)
          .toList();
      final starter = players[0];
      final batters = players.sublist(1); // 5 remaining

      // Make `starter` the clear best pitcher by observed stats regardless
      // of true ratings.
      await db.into(db.pitchingStats).insert(PitchingStatsCompanion.insert(
            gameId: gameId,
            playerId: starter,
            teamId: teamId,
            outsRecorded: const Value(9),
            er: const Value(0),
            bb: const Value(0),
            h: const Value(0),
          ));

      // Give the 5 batters a strict, distinct batting-score ranking.
      for (var i = 0; i < batters.length; i++) {
        final ab = 10;
        final hits = 5 - i; // strictly decreasing hit total -> decreasing OBP/SLG
        await db.into(db.battingStats).insert(BattingStatsCompanion.insert(
              gameId: gameId,
              playerId: batters[i],
              teamId: teamId,
              pa: Value(ab),
              ab: Value(ab),
              h: Value(hits),
            ));
      }

      // The two lowest-ranked batters get clearly-best fielding, so
      // fielder2/3 should be picked from them, not from the top batters.
      final fielderA = batters[3];
      final fielderB = batters[4];
      await db.into(db.fieldingStats).insert(FieldingStatsCompanion.insert(
            gameId: gameId,
            playerId: fielderA,
            teamId: teamId,
            outsPlayed: const Value(9),
            tc: const Value(20),
            e: const Value(0),
          ));
      // fpct 24/25 = 0.96 — clearly above the neutral 0.95 the other
      // (fielding-stats-less) batters get, but below fielderA's 1.0, so the
      // fielder2/3 ranking is unambiguous.
      await db.into(db.fieldingStats).insert(FieldingStatsCompanion.insert(
            gameId: gameId,
            playerId: fielderB,
            teamId: teamId,
            outsPlayed: const Value(9),
            tc: const Value(25),
            e: const Value(1),
          ));

      await refreshAiLineup(db, teamId: teamId, seasonId: seasonId);

      final row = await (db.select(db.teamLineups)..where((l) => l.teamId.equals(teamId))).getSingle();
      expect(row.pitcherRotation, '$starter');
      expect(row.battingOrder.split(',').map(int.parse).toList(), batters);
      expect(row.fielder2Id, fielderA);
      expect(row.fielder3Id, fielderB);
    });

    test('is a no-op for the player-controlled team', () async {
      final teamId = teamIds[1];
      final before = await (db.select(db.teamLineups)..where((l) => l.teamId.equals(teamId))).getSingle();

      // Seed stats that would clearly change the lineup if this weren't
      // skipped, so the no-op is actually being exercised.
      final players =
          (await (db.select(db.players)..where((p) => p.teamId.equals(teamId))).get()).map((p) => p.id).toList();
      await db.into(db.pitchingStats).insert(PitchingStatsCompanion.insert(
            gameId: gameId,
            playerId: players.last,
            teamId: teamId,
            outsRecorded: const Value(30),
            er: const Value(0),
            bb: const Value(0),
            h: const Value(0),
          ));

      await refreshAiLineup(db, teamId: teamId, seasonId: seasonId);

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
