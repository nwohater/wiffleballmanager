import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:wballmgr/career/aging.dart';

void main() {
  group('playingTimeFactor', () {
    test('clamps at the low end for little/no usage', () {
      expect(playingTimeFactor(actualUsage: 0, fullSeasonBaseline: 100), 0.2);
      expect(playingTimeFactor(actualUsage: 5, fullSeasonBaseline: 100), 0.2);
    });

    test('clamps at the high end for heavy usage', () {
      expect(playingTimeFactor(actualUsage: 500, fullSeasonBaseline: 100), 1.1);
    });

    test('scales linearly in between', () {
      expect(playingTimeFactor(actualUsage: 50, fullSeasonBaseline: 100), 0.5);
    });

    test('degenerate zero baseline floors at the low clamp', () {
      expect(playingTimeFactor(actualUsage: 10, fullSeasonBaseline: 0), 0.2);
    });
  });

  group('applyAging', () {
    test('growth (age < 26) moves toward potential on average over many seasons', () {
      final rng = Random(1);
      var rating = 40;
      const potential = 90;
      for (var i = 0; i < 30; i++) {
        rating = applyAging(rating: rating, potential: potential, age: 22, playingTimeFactor: 1.0, rng: rng);
        expect(rating, inInclusiveRange(0, potential));
      }
      expect(rating, greaterThan(40));
    });

    test('growth never exceeds potential', () {
      final rng = Random(2);
      var rating = 88;
      const potential = 90;
      for (var i = 0; i < 50; i++) {
        rating = applyAging(rating: rating, potential: potential, age: 21, playingTimeFactor: 1.0, rng: rng);
        expect(rating, lessThanOrEqualTo(potential));
      }
    });

    test('plateau (26-29) stays roughly flat modulo jitter', () {
      final rng = Random(3);
      var rating = 60;
      const potential = 80;
      final samples = <int>[];
      for (var i = 0; i < 200; i++) {
        rating = applyAging(rating: rating, potential: potential, age: 27, playingTimeFactor: 1.0, rng: rng);
        samples.add(rating);
      }
      final mean = samples.reduce((a, b) => a + b) / samples.length;
      expect(mean, closeTo(60, 8), reason: 'no systematic drift during the plateau band');
    });

    test('decline (age > 29) moves down and accelerates further past peak', () {
      final rng = Random(4);
      var rating = 70;
      const potential = 90;
      for (var i = 0; i < 20; i++) {
        rating = applyAging(rating: rating, potential: potential, age: 32, playingTimeFactor: 1.0, rng: rng);
      }
      final after32 = rating;

      rating = 70;
      for (var i = 0; i < 20; i++) {
        rating = applyAging(rating: rating, potential: potential, age: 38, playingTimeFactor: 1.0, rng: rng);
      }
      final after38 = rating;

      expect(after32, lessThan(70));
      expect(after38, lessThan(after32), reason: 'decay accelerates further past peak');
    });

    test('result never drops below 0', () {
      final rng = Random(5);
      var rating = 5;
      const potential = 20;
      for (var i = 0; i < 50; i++) {
        rating = applyAging(rating: rating, potential: potential, age: 40, playingTimeFactor: 1.1, rng: rng);
        expect(rating, greaterThanOrEqualTo(0));
      }
    });

    test('low playing time dampens the magnitude of the season move', () {
      final fullTimeRng = Random(6);
      final benchRng = Random(6);
      const potential = 99;

      var fullTime = 30;
      var bench = 30;
      for (var i = 0; i < 10; i++) {
        fullTime = applyAging(
            rating: fullTime, potential: potential, age: 22, playingTimeFactor: 1.1, rng: fullTimeRng);
        bench =
            applyAging(rating: bench, potential: potential, age: 22, playingTimeFactor: 0.2, rng: benchRng);
      }
      expect(fullTime - 30, greaterThan(bench - 30));
    });
  });
}
