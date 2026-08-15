import 'dart:math';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:wballmgr/career/org_roster.dart';
import 'package:wballmgr/data/database.dart';
import 'package:wballmgr/data/enums.dart';
import 'package:wballmgr/roster/roster_generator.dart';
import 'package:wballmgr/roster/roster_writer.dart';

/// Seeds one org with a major team and a minor team, each with a full
/// generated 6-active roster (Phase 7's mirrored-tier shape) — the fixture
/// [swapActiveAssignment] and [enforceOrgRosterCap] both need, since neither
/// concept makes sense for a single-team org.
Future<({int organizationId, int majorTeamId, int minorTeamId})> _makeOrgWithBothTiers(AppDatabase db) async {
  final rng = Random(1);
  final organizationId = await db.into(db.organizations).insert(OrganizationsCompanion.insert(name: 'Org'));
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
  group('swapActiveAssignment', () {
    test('swaps two active players between the org\'s two teams', () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      final org = await _makeOrgWithBothTiers(db);

      final majorPlayer =
          (await (db.select(db.players)..where((p) => p.teamId.equals(org.majorTeamId))).get()).first;
      final minorPlayer =
          (await (db.select(db.players)..where((p) => p.teamId.equals(org.minorTeamId))).get()).first;

      await swapActiveAssignment(
        db,
        organizationId: org.organizationId,
        playerAId: minorPlayer.id,
        playerBId: majorPlayer.id,
      );

      final majorPlayerAfter = await (db.select(db.players)..where((p) => p.id.equals(majorPlayer.id))).getSingle();
      final minorPlayerAfter = await (db.select(db.players)..where((p) => p.id.equals(minorPlayer.id))).getSingle();
      expect(majorPlayerAfter.teamId, org.minorTeamId, reason: 'sent down');
      expect(minorPlayerAfter.teamId, org.majorTeamId, reason: 'called up');
      expect(majorPlayerAfter.rosterSlot, RosterSlot.active, reason: 'slot unchanged, only team moved');
      expect(minorPlayerAfter.rosterSlot, RosterSlot.active);

      final majorTeamCount =
          await (db.select(db.players)..where((p) => p.teamId.equals(org.majorTeamId))).get();
      final minorTeamCount =
          await (db.select(db.players)..where((p) => p.teamId.equals(org.minorTeamId))).get();
      expect(majorTeamCount.length, 6, reason: 'swap keeps both rosters at exactly 6');
      expect(minorTeamCount.length, 6);

      await db.close();
    });

    test('throws if the two players belong to different orgs', () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      final orgA = await _makeOrgWithBothTiers(db);
      final orgB = await _makeOrgWithBothTiers(db);

      final playerA =
          (await (db.select(db.players)..where((p) => p.teamId.equals(orgA.majorTeamId))).get()).first;
      final playerB =
          (await (db.select(db.players)..where((p) => p.teamId.equals(orgB.majorTeamId))).get()).first;

      await expectLater(
        swapActiveAssignment(db, organizationId: orgA.organizationId, playerAId: playerA.id, playerBId: playerB.id),
        throwsArgumentError,
      );

      await db.close();
    });

    test('throws if a player is on the disabled list rather than active', () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      final org = await _makeOrgWithBothTiers(db);

      final majorPlayer =
          (await (db.select(db.players)..where((p) => p.teamId.equals(org.majorTeamId))).get()).first;
      await (db.update(db.players)..where((p) => p.id.equals(majorPlayer.id)))
          .write(const PlayersCompanion(rosterSlot: Value(RosterSlot.dl)));
      final minorPlayer =
          (await (db.select(db.players)..where((p) => p.teamId.equals(org.minorTeamId))).get()).first;

      await expectLater(
        swapActiveAssignment(
          db,
          organizationId: org.organizationId,
          playerAId: minorPlayer.id,
          playerBId: majorPlayer.id,
        ),
        throwsArgumentError,
      );

      await db.close();
    });
  });

  group('enforceOrgRosterCap', () {
    test('releases oldest bench (org-depth) players first, never touching active/DL', () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      final org = await _makeOrgWithBothTiers(db);

      // 12 active (6+6) + 10 bench = 22, 2 over the 20 cap.
      final benchIds = <int>[];
      for (var i = 0; i < 10; i++) {
        benchIds.add(
          await writeDraftedPlayer(db, organizationId: org.organizationId, player: generateDraftClass(Random(i), count: 1).single),
        );
      }

      await enforceOrgRosterCap(db, organizationId: org.organizationId);

      final remaining = await (db.select(db.players)..where((p) => p.organizationId.equals(org.organizationId))).get();
      expect(remaining.length, orgRosterCap);

      final remainingBenchIds = remaining.where((p) => p.teamId == null).map((p) => p.id).toSet();
      expect(remainingBenchIds.length, 8, reason: '10 bench - 2 evicted to get back to the cap');
      // Oldest (lowest id) bench players are the ones evicted.
      final sortedBench = List<int>.of(benchIds)..sort();
      expect(remainingBenchIds.contains(sortedBench.first), isFalse);
      expect(remainingBenchIds.contains(sortedBench[1]), isFalse);

      final activeAndDl = await (db.select(db.players)
            ..where((p) => p.organizationId.equals(org.organizationId) & p.teamId.isNotNull()))
          .get();
      expect(activeAndDl.length, 12, reason: 'active/DL rostered players are never touched by the cap');

      await db.close();
    });

    test('never evicts a protected (just-added) player, even if the org is still over cap afterward', () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      final org = await _makeOrgWithBothTiers(db);

      // 12 active + 9 pre-existing bench = 21, already 1 over cap with an
      // empty protected set.
      for (var i = 0; i < 9; i++) {
        await writeDraftedPlayer(db, organizationId: org.organizationId, player: generateDraftClass(Random(i), count: 1).single);
      }
      final freshPickId = await writeDraftedPlayer(
        db,
        organizationId: org.organizationId,
        player: generateDraftClass(Random(99), count: 1).single,
      );

      // 22 total now, 2 over cap — but the fresh pick is protected, so at
      // most 1 pre-existing bench player can be evicted to close the gap,
      // and the fresh pick must survive regardless.
      await enforceOrgRosterCap(db, organizationId: org.organizationId, protectedPlayerIds: {freshPickId});

      final freshPickAfter = await (db.select(db.players)..where((p) => p.id.equals(freshPickId))).getSingle();
      expect(freshPickAfter.organizationId, org.organizationId, reason: 'protected pick must survive');

      await db.close();
    });

    test('is a no-op at or under the cap', () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      final org = await _makeOrgWithBothTiers(db);

      await enforceOrgRosterCap(db, organizationId: org.organizationId);

      final remaining = await (db.select(db.players)..where((p) => p.organizationId.equals(org.organizationId))).get();
      expect(remaining.length, 12, reason: 'nothing to trim, well under cap');

      await db.close();
    });
  });
}
