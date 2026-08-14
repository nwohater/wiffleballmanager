import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:wballmgr/sim/at_bat.dart';

import 'harness.dart';

void main() {
  test('elite batter discipline/contact draws far more walks than strikeouts', () {
    final rng = Random(1);
    final batter = averagePlayer(1, rating: 99);
    final pitcher = averagePlayer(2, rating: 50);

    var walks = 0, strikeouts = 0;
    for (var i = 0; i < 500; i++) {
      final result = simulateAtBat(batter: batter, pitcher: pitcher, pitcherBattersFacedSoFar: 0, rng: rng);
      switch (result.outcome) {
        case AtBatOutcome.walk:
          walks++;
        case AtBatOutcome.strikeout:
          strikeouts++;
        case AtBatOutcome.ballInPlay:
          break;
      }
    }

    expect(walks, greaterThan(strikeouts));
  });

  test('elite pitcher control/movement draws far more strikeouts than walks', () {
    final rng = Random(2);
    final batter = averagePlayer(1, rating: 50);
    final pitcher = averagePlayer(2, rating: 99);

    var walks = 0, strikeouts = 0;
    for (var i = 0; i < 500; i++) {
      final result = simulateAtBat(batter: batter, pitcher: pitcher, pitcherBattersFacedSoFar: 0, rng: rng);
      switch (result.outcome) {
        case AtBatOutcome.walk:
          walks++;
        case AtBatOutcome.strikeout:
          strikeouts++;
        case AtBatOutcome.ballInPlay:
          break;
      }
    }

    expect(strikeouts, greaterThan(walks));
  });

  test('a fatigued pitcher walks batters more often than a fresh one', () {
    final batter = averagePlayer(1, rating: 50);
    final pitcher = averagePlayer(2, rating: 50);

    var freshWalks = 0, tiredWalks = 0;
    for (var i = 0; i < 800; i++) {
      final fresh = simulateAtBat(
        batter: batter,
        pitcher: pitcher,
        pitcherBattersFacedSoFar: 0,
        rng: Random(1000 + i),
      );
      if (fresh.outcome == AtBatOutcome.walk) freshWalks++;

      final tired = simulateAtBat(
        batter: batter,
        pitcher: pitcher,
        pitcherBattersFacedSoFar: 40,
        rng: Random(1000 + i),
      );
      if (tired.outcome == AtBatOutcome.walk) tiredWalks++;
    }

    expect(tiredWalks, greaterThan(freshWalks));
  });
}
