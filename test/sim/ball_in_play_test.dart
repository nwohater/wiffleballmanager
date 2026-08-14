import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:wballmgr/sim/ball_in_play.dart';

import 'harness.dart';

void main() {
  test('elite power hits far more homers than a league-average batter', () {
    final rng = Random(3);
    final eliteBatter = averagePlayer(1, rating: 99);
    final avgBatter = averagePlayer(2, rating: 50);
    final defense = [averagePlayer(10), averagePlayer(11), averagePlayer(12)];

    var eliteHr = 0, avgHr = 0;
    const trials = 1000;
    for (var i = 0; i < trials; i++) {
      if (resolveBallInPlay(batter: eliteBatter, fielders: defense, rng: rng) == BipOutcome.homeRun) {
        eliteHr++;
      }
    }
    for (var i = 0; i < trials; i++) {
      if (resolveBallInPlay(batter: avgBatter, fielders: defense, rng: rng) == BipOutcome.homeRun) {
        avgHr++;
      }
    }

    expect(eliteHr, greaterThan(avgHr));
  });

  test('elite defense converts far more balls in play to outs', () {
    final rng = Random(4);
    final batter = averagePlayer(1, rating: 50);
    final eliteDefense = [averagePlayer(10, rating: 99), averagePlayer(11, rating: 99), averagePlayer(12, rating: 99)];
    final weakDefense = [averagePlayer(20, rating: 1), averagePlayer(21, rating: 1), averagePlayer(22, rating: 1)];

    var eliteOuts = 0, weakOuts = 0;
    const trials = 1000;
    for (var i = 0; i < trials; i++) {
      if (resolveBallInPlay(batter: batter, fielders: eliteDefense, rng: rng) == BipOutcome.out) eliteOuts++;
    }
    for (var i = 0; i < trials; i++) {
      if (resolveBallInPlay(batter: batter, fielders: weakDefense, rng: rng) == BipOutcome.out) weakOuts++;
    }

    expect(eliteOuts, greaterThan(weakOuts));
  });
}
