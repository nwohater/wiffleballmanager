import 'dart:math';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:wballmgr/data/database.dart';
import 'package:wballmgr/draft/draft_manager.dart';
import 'package:wballmgr/league/game_runner.dart';
import 'package:wballmgr/league/league_seed.dart';

void main() {
  group('runDraft', () {
    test('assigns 2 rounds x 12 picks as org depth, worst-to-first, and records DraftPicks', () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      final seasonId = await seedNewLeague(db);
      await simulateRestOfSeason(db, seasonId: seasonId);

      final playerIds = await runDraft(db, seasonId: seasonId, random: Random(7));
      expect(playerIds.length, 24);

      final picks = await (db.select(db.draftPicks)..where((p) => p.seasonId.equals(seasonId))).get();
      expect(picks.length, 24);
      expect(picks.map((p) => p.overallPick).toSet(), List.generate(24, (i) => i + 1).toSet());
      expect(picks.where((p) => p.round == 1).length, 12);
      expect(picks.where((p) => p.round == 2).length, 12);

      // Round 1 and round 2 use the same team order.
      final round1TeamOrder = picks.where((p) => p.round == 1).toList()
        ..sort((a, b) => a.overallPick.compareTo(b.overallPick));
      final round2TeamOrder = picks.where((p) => p.round == 2).toList()
        ..sort((a, b) => a.overallPick.compareTo(b.overallPick));
      expect(round2TeamOrder.map((p) => p.teamId).toList(), round1TeamOrder.map((p) => p.teamId).toList());

      // Every drafted player is org depth: organizationId set, no team/slot.
      final draftedPlayers = await (db.select(db.players)..where((p) => p.id.isIn(playerIds))).get();
      expect(draftedPlayers.length, 24);
      for (final p in draftedPlayers) {
        expect(p.organizationId, isNotNull);
        expect(p.teamId, isNull);
        expect(p.rosterSlot, isNull);
      }

      // The picking team on each DraftPicks row matches the org that now
      // owns the drafted player.
      final teamsById = {for (final t in await db.select(db.teams).get()) t.id: t};
      final playersById = {for (final p in draftedPlayers) p.id: p};
      for (final pick in picks) {
        expect(playersById[pick.playerId]!.organizationId, teamsById[pick.teamId]!.organizationId);
      }

      await db.close();
    });

    test('is a no-op if the playoff bracket is not fully decided', () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      final seasonId = await seedNewLeague(db);

      final playersBefore = await db.select(db.players).get();
      final playerIds = await runDraft(db, seasonId: seasonId);

      expect(playerIds, isEmpty);
      final playersAfter = await db.select(db.players).get();
      expect(playersAfter.length, playersBefore.length);
      final picks = await (db.select(db.draftPicks)..where((p) => p.seasonId.equals(seasonId))).get();
      expect(picks, isEmpty);

      await db.close();
    });
  });
}
