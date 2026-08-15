import 'dart:math';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:wballmgr/ai/callup_ai.dart';
import 'package:wballmgr/data/database.dart';
import 'package:wballmgr/data/enums.dart';
import 'package:wballmgr/roster/roster_generator.dart';
import 'package:wballmgr/roster/roster_writer.dart';

/// Seeds one org with a major team and a minor team, each with a full
/// generated 6-active roster — the shape [evaluateCallUps] needs (mirrors
/// test/career/org_roster_test.dart's identically-purposed fixture).
Future<({int organizationId, int majorTeamId, int minorTeamId})> _makeOrgWithBothTiers(
  AppDatabase db, {
  bool isPlayerControlled = false,
}) async {
  final rng = Random(1);
  final organizationId = await db.into(db.organizations).insert(
        OrganizationsCompanion.insert(name: 'Org', isPlayerControlled: Value(isPlayerControlled)),
      );
  final majorDivisionId =
      await db.into(db.divisions).insert(DivisionsCompanion.insert(name: 'Major Div', tier: Tier.major));
  final minorDivisionId =
      await db.into(db.divisions).insert(DivisionsCompanion.insert(name: 'Minor Div', tier: Tier.minor));

  final majorTeamId = await db.into(db.teams).insert(
        TeamsCompanion.insert(organizationId: organizationId, divisionId: majorDivisionId, name: 'Major'),
      );
  await writeGeneratedRoster(db, teamId: majorTeamId, organizationId: organizationId, players: generateRoster(rng));

  final minorTeamId = await db.into(db.teams).insert(
        TeamsCompanion.insert(organizationId: organizationId, divisionId: minorDivisionId, name: 'Minor'),
      );
  await writeGeneratedRoster(db, teamId: minorTeamId, organizationId: organizationId, players: generateRoster(rng));

  return (organizationId: organizationId, majorTeamId: majorTeamId, minorTeamId: minorTeamId);
}

void main() {
  late AppDatabase db;
  late int seasonId;
  late int gameId;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    seasonId = await db.into(db.seasons).insert(SeasonsCompanion.insert(number: 1));
  });

  tearDown(() async => db.close());

  Future<int> insertGame(int teamId) => db.into(db.games).insert(GamesCompanion.insert(
        seasonId: seasonId,
        tier: Tier.major,
        homeTeamId: teamId,
        awayTeamId: teamId,
        gameNumber: 1,
      ));

  group('evaluateCallUps', () {
    test('swaps a clearly-better minor batter up for a clearly-worse major batter', () async {
      final org = await _makeOrgWithBothTiers(db);
      gameId = await insertGame(org.majorTeamId);

      final majorPlayers =
          (await (db.select(db.players)..where((p) => p.teamId.equals(org.majorTeamId))).get()).map((p) => p.id).toList();
      final minorPlayers =
          (await (db.select(db.players)..where((p) => p.teamId.equals(org.minorTeamId))).get()).map((p) => p.id).toList();
      final weakMajor = majorPlayers[0];
      final strongMinor = minorPlayers[0];

      // Weak major batter: 20 PA, mostly outs.
      await db.into(db.battingStats).insert(BattingStatsCompanion.insert(
            gameId: gameId,
            playerId: weakMajor,
            teamId: org.majorTeamId,
            pa: const Value(20),
            ab: const Value(20),
            h: const Value(2),
            bb: const Value(0),
          ));
      // Everyone else on the major roster gets a decent, qualified line so
      // they're never mistaken for the worst.
      for (final id in majorPlayers.sublist(1)) {
        await db.into(db.battingStats).insert(BattingStatsCompanion.insert(
              gameId: gameId,
              playerId: id,
              teamId: org.majorTeamId,
              pa: const Value(20),
              ab: const Value(20),
              h: const Value(8),
              bb: const Value(2),
            ));
      }
      // Strong minor batter: 20 PA, mostly hits/walks.
      await db.into(db.battingStats).insert(BattingStatsCompanion.insert(
            gameId: gameId,
            playerId: strongMinor,
            teamId: org.minorTeamId,
            pa: const Value(20),
            ab: const Value(16),
            h: const Value(12),
            bb: const Value(4),
            hr: const Value(4),
          ));
      for (final id in minorPlayers.sublist(1)) {
        await db.into(db.battingStats).insert(BattingStatsCompanion.insert(
              gameId: gameId,
              playerId: id,
              teamId: org.minorTeamId,
              pa: const Value(20),
              ab: const Value(20),
              h: const Value(8),
              bb: const Value(2),
            ));
      }

      await evaluateCallUps(db, organizationId: org.organizationId, completedSeasonId: seasonId);

      final weakMajorAfter = await (db.select(db.players)..where((p) => p.id.equals(weakMajor))).getSingle();
      final strongMinorAfter = await (db.select(db.players)..where((p) => p.id.equals(strongMinor))).getSingle();
      expect(strongMinorAfter.teamId, org.majorTeamId, reason: 'called up');
      expect(weakMajorAfter.teamId, org.minorTeamId, reason: 'sent down to make room');

      final majorActive = await (db.select(db.players)
            ..where((p) => p.teamId.equals(org.majorTeamId) & p.rosterSlot.equalsValue(RosterSlot.active)))
          .get();
      final minorActive = await (db.select(db.players)
            ..where((p) => p.teamId.equals(org.minorTeamId) & p.rosterSlot.equalsValue(RosterSlot.active)))
          .get();
      expect(majorActive, hasLength(6), reason: 'swap keeps both rosters at exactly 6');
      expect(minorActive, hasLength(6));
    });

    test('is a no-op for the player-controlled org', () async {
      final org = await _makeOrgWithBothTiers(db, isPlayerControlled: true);
      gameId = await insertGame(org.majorTeamId);

      final majorPlayers =
          (await (db.select(db.players)..where((p) => p.teamId.equals(org.majorTeamId))).get()).map((p) => p.id).toList();
      final minorPlayers =
          (await (db.select(db.players)..where((p) => p.teamId.equals(org.minorTeamId))).get()).map((p) => p.id).toList();

      await db.into(db.battingStats).insert(BattingStatsCompanion.insert(
            gameId: gameId,
            playerId: majorPlayers[0],
            teamId: org.majorTeamId,
            pa: const Value(20),
            ab: const Value(20),
            h: const Value(0),
          ));
      await db.into(db.battingStats).insert(BattingStatsCompanion.insert(
            gameId: gameId,
            playerId: minorPlayers[0],
            teamId: org.minorTeamId,
            pa: const Value(20),
            ab: const Value(16),
            h: const Value(16),
            hr: const Value(6),
          ));

      await evaluateCallUps(db, organizationId: org.organizationId, completedSeasonId: seasonId);

      final stillMajor = await (db.select(db.players)..where((p) => p.id.equals(majorPlayers[0]))).getSingle();
      final stillMinor = await (db.select(db.players)..where((p) => p.id.equals(minorPlayers[0]))).getSingle();
      expect(stillMajor.teamId, org.majorTeamId);
      expect(stillMinor.teamId, org.minorTeamId);
    });

    test('is a no-op when nobody has a qualifying sample yet', () async {
      final org = await _makeOrgWithBothTiers(db);
      // No stats inserted at all this season.

      final majorPlayers =
          (await (db.select(db.players)..where((p) => p.teamId.equals(org.majorTeamId))).get()).map((p) => p.id).toList();

      await evaluateCallUps(db, organizationId: org.organizationId, completedSeasonId: seasonId);

      final stillMajor = await (db.select(db.players)..where((p) => p.id.equals(majorPlayers[0]))).getSingle();
      expect(stillMajor.teamId, org.majorTeamId);
    });
  });

  group('runAiCallUps', () {
    test('runs evaluateCallUps for every org', () async {
      final orgA = await _makeOrgWithBothTiers(db);
      final orgB = await _makeOrgWithBothTiers(db, isPlayerControlled: true);
      gameId = await insertGame(orgA.majorTeamId);

      final majorA =
          (await (db.select(db.players)..where((p) => p.teamId.equals(orgA.majorTeamId))).get()).map((p) => p.id).toList();
      final minorA =
          (await (db.select(db.players)..where((p) => p.teamId.equals(orgA.minorTeamId))).get()).map((p) => p.id).toList();

      await db.into(db.battingStats).insert(BattingStatsCompanion.insert(
            gameId: gameId,
            playerId: majorA[0],
            teamId: orgA.majorTeamId,
            pa: const Value(20),
            ab: const Value(20),
            h: const Value(0),
          ));
      await db.into(db.battingStats).insert(BattingStatsCompanion.insert(
            gameId: gameId,
            playerId: minorA[0],
            teamId: orgA.minorTeamId,
            pa: const Value(20),
            ab: const Value(16),
            h: const Value(16),
            hr: const Value(6),
          ));

      await runAiCallUps(db, completedSeasonId: seasonId);

      final swappedMajor = await (db.select(db.players)..where((p) => p.id.equals(minorA[0]))).getSingle();
      expect(swappedMajor.teamId, orgA.majorTeamId, reason: 'AI org A gets its call-up evaluated');

      // orgB is player-controlled and has no stats seeded — just confirming
      // this doesn't throw when mixed in with an AI org in the same pass.
      final orgBPlayers = await (db.select(db.players)..where((p) => p.organizationId.equals(orgB.organizationId))).get();
      expect(orgBPlayers, hasLength(12));
    });
  });
}
