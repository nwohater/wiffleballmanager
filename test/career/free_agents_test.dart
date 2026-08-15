import 'dart:math';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:wballmgr/career/free_agents.dart';
import 'package:wballmgr/data/database.dart';
import 'package:wballmgr/roster/roster_generator.dart';
import 'package:wballmgr/roster/roster_writer.dart';

import '../league/harness.dart';

void main() {
  group('org-depth vs. true free agency', () {
    test('signFreeAgent never poaches another org\'s org-depth (drafted, team-unassigned) player', () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      final teamIds = await makeTeamsWithRosters(db, count: 2);
      final teamA = await (db.select(db.teams)..where((t) => t.id.equals(teamIds[0]))).getSingle();
      final teamB = await (db.select(db.teams)..where((t) => t.id.equals(teamIds[1]))).getSingle();

      // Simulates a drafted player: organizationId set, teamId/rosterSlot
      // null — see lib/roster/roster_writer.dart's writeDraftedPlayer.
      final orgDepthPlayerId =
          await writeDraftedPlayer(db, organizationId: teamA.organizationId, player: generateDraftClass(Random(1), count: 1).single);

      final signedId = await signFreeAgent(db, teamId: teamIds[1], organizationId: teamB.organizationId);

      expect(signedId, isNot(orgDepthPlayerId), reason: 'team B must not sign team A\'s org-depth player');

      final orgDepthPlayerAfter =
          await (db.select(db.players)..where((p) => p.id.equals(orgDepthPlayerId))).getSingle();
      expect(orgDepthPlayerAfter.teamId, null, reason: 'still unrostered org depth, untouched by the sign');
      expect(orgDepthPlayerAfter.organizationId, teamA.organizationId);

      await db.close();
    });

    test('topUpFreeAgentPool does not count org-depth players toward the pool size', () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      final teamIds = await makeTeamsWithRosters(db, count: 1);
      final team = await (db.select(db.teams)..where((t) => t.id.equals(teamIds[0]))).getSingle();

      for (var i = 0; i < 5; i++) {
        await writeDraftedPlayer(
          db,
          organizationId: team.organizationId,
          player: generateDraftClass(Random(i), count: 1).single,
        );
      }

      await topUpFreeAgentPool(db, random: Random(1), targetSize: 10);

      final trueFreeAgents =
          await (db.select(db.players)..where((p) => p.teamId.isNull() & p.organizationId.isNull())).get();
      expect(trueFreeAgents.length, 10, reason: 'pool topped up to target size, ignoring org-depth players');

      final orgDepth = await (db.select(db.players)
            ..where((p) => p.teamId.isNull() & p.organizationId.equals(team.organizationId)))
          .get();
      expect(orgDepth.length, 5, reason: 'org-depth players untouched');

      await db.close();
    });
  });
}
