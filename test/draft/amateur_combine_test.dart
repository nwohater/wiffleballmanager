import 'dart:math';

import 'package:flutter_test/flutter_test.dart';

import 'package:wballmgr/draft/amateur_combine.dart';
import 'package:wballmgr/trade/trade_manager.dart' show playerTradeValue;

void main() {
  group('runAmateurCombine', () {
    test('returns one prospect per pool slot, each with a non-trivial simulated sample', () {
      final prospects = runAmateurCombine(Random(1));

      expect(prospects.length, amateurTeamCount * playersPerAmateurTeam);

      // Every squad's sole pitcher (best pitchingScore) racks up innings;
      // every squad's 5 batters rack up plate appearances — across 30 games
      // per team this should never come out to a neutral/zero sample.
      final withInnings = prospects.where((p) => p.amateurStats.outsRecorded > 0);
      final withPa = prospects.where((p) => p.amateurStats.pa > 0);
      expect(withInnings.length, amateurTeamCount); // exactly one pitcher per squad
      expect(withPa.length, amateurTeamCount * 5); // exactly 5 batters per squad

      for (final p in withInnings) {
        expect(p.amateurStats.outsRecorded, greaterThan(50));
      }
      for (final p in withPa) {
        expect(p.amateurStats.pa, greaterThan(20));
      }
    });

    test('is deterministic for a fixed seed', () {
      final a = runAmateurCombine(Random(42));
      final b = runAmateurCombine(Random(42));

      expect(
        a.map((p) => '${p.player.firstName} ${p.player.lastName} ${p.amateurStats.pa} ${p.amateurStats.obp}'),
        b.map((p) => '${p.player.firstName} ${p.player.lastName} ${p.amateurStats.pa} ${p.amateurStats.obp}'),
      );
    });
  });

  group('rankProspectsByValue', () {
    test('sorts best-to-worst and never drops or duplicates a prospect', () {
      final prospects = runAmateurCombine(Random(2));
      final ranked = rankProspectsByValue(prospects);

      expect(ranked.length, prospects.length);
      expect(ranked.map((p) => p.player).toSet(), prospects.map((p) => p.player).toSet());

      final values = ranked.map((p) => playerTradeValue(p.amateurStats)).toList();
      for (var i = 0; i < values.length - 1; i++) {
        expect(values[i], greaterThanOrEqualTo(values[i + 1]));
      }
    });
  });
}
