import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:wballmgr/sim/game_simulator.dart';

import 'harness.dart';

void main() {
  test('league-average rosters land within calibration bands', () {
    // rules-mlw-cultz-field.md Statistical Calibration: BB 28.3%, K 40.9%,
    // BIP ~30.8%, Hit 15.6%, XBH 5.3%, HR 4.9% of PA — "a strong
    // directional target, not an exact spec" per that doc's own caveat, so
    // tolerances here are a few points wide rather than pinned exactly.
    const games = 3000;
    final rng = Random(20260813);
    final home = buildSyntheticTeam(1, 1);
    final away = buildSyntheticTeam(2, 100);
    final players = {for (final p in [...home.players, ...away.players]) p.id: p};

    var pa = 0, bb = 0, k = 0, h = 0, doubles = 0, triples = 0, hr = 0;

    for (var i = 0; i < games; i++) {
      final result = simulateGame(home: home.lineup, away: away.lineup, players: players, random: rng);
      for (final line in result.boxScore.batting.values) {
        pa += line.pa;
        bb += line.bb;
        k += line.k;
        h += line.h;
        doubles += line.doubles;
        triples += line.triples;
        hr += line.hr;
      }
    }

    final bbRate = bb / pa;
    final kRate = k / pa;
    final bipRate = 1 - bbRate - kRate;
    final hitRate = h / pa;
    final xbhRate = (doubles + triples + hr) / pa;
    final hrRate = hr / pa;

    expect(bbRate, closeTo(0.283, 0.03));
    expect(kRate, closeTo(0.409, 0.03));
    expect(bipRate, closeTo(0.308, 0.03));
    expect(hitRate, closeTo(0.156, 0.02));
    expect(xbhRate, closeTo(0.053, 0.02));
    expect(hrRate, closeTo(0.049, 0.02));
  });
}
