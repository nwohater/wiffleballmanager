import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:wballmgr/roster/roster_generator.dart';

double _mean(Iterable<num> values) {
  var sum = 0.0;
  var count = 0;
  for (final v in values) {
    sum += v;
    count++;
  }
  return sum / count;
}

void main() {
  group('generateRoster', () {
    test('generates 6 players by default', () {
      final players = generateRoster(Random(1));
      expect(players.length, 6);
    });

    test('every rating is within 0-99 and repertoire/age are sane', () {
      final rng = Random(2);
      for (var trial = 0; trial < 50; trial++) {
        for (final p in generateRoster(rng)) {
          for (final rating in [p.contact, p.power, p.discipline, p.speed, p.control, p.stamina, p.range, p.hands, p.arm]) {
            expect(rating, inInclusiveRange(0, 99));
          }
          expect(p.age, inInclusiveRange(20, 32));
          expect(p.repertoire.length, inInclusiveRange(1, 4));
          expect(p.repertoire.map((r) => r.type).toSet().length, p.repertoire.length,
              reason: 'no duplicate pitch types in one repertoire');
          for (final pitch in p.repertoire) {
            expect(pitch.movement, inInclusiveRange(0, 99));
          }
          expect(p.firstName, isNotEmpty);
          expect(p.lastName, isNotEmpty);
        }
      }
    });

    test('potentials are within 0-99 and never below the current rating composite', () {
      final rng = Random(5);
      for (var trial = 0; trial < 50; trial++) {
        for (final p in generateRoster(rng)) {
          for (final potential in [p.battingPotential, p.pitchingPotential, p.fieldingPotential, p.speedPotential]) {
            expect(potential, inInclusiveRange(0, 99));
          }
          expect(p.battingPotential, greaterThanOrEqualTo(((p.contact + p.power + p.discipline) / 3).round()));
          expect(p.pitchingPotential, greaterThanOrEqualTo(((p.control + p.stamina) / 2).round()));
          expect(p.fieldingPotential, greaterThanOrEqualTo(((p.range + p.hands + p.arm) / 3).round()));
          expect(p.speedPotential, greaterThanOrEqualTo(p.speed));
        }
      }
    });

    test('potential headroom shrinks as generation age climbs toward 32', () {
      // Statistical, not per-player: young players' potential should exceed
      // their current rating composite by more, on average, than old
      // players' — the age-banded bump weights in _rollPotentialBump.
      final rng = Random(6);
      final youngGaps = <int>[];
      final oldGaps = <int>[];
      for (var trial = 0; trial < 400; trial++) {
        for (final p in generateRoster(rng)) {
          final gap = p.battingPotential - ((p.contact + p.power + p.discipline) / 3).round();
          if (p.age <= 23) {
            youngGaps.add(gap);
          } else if (p.age >= 28) {
            oldGaps.add(gap);
          }
        }
      }
      expect(_mean(youngGaps), greaterThan(_mean(oldGaps)));
    });
  });

  group('generateFreeAgentPool', () {
    test('generates the requested count with sane fields', () {
      final players = generateFreeAgentPool(Random(7), count: 10);
      expect(players.length, 10);
      for (final p in players) {
        expect(p.age, inInclusiveRange(20, 32));
        expect(p.battingPotential, inInclusiveRange(0, 99));
      }
    });

    test('is skewed below the standard generator on average', () {
      final rng = Random(8);
      final standardScores = <double>[];
      final freeAgentScores = <double>[];
      for (var trial = 0; trial < 20; trial++) {
        for (final p in generateRoster(rng)) {
          standardScores.add(p.battingScore);
        }
        for (final p in generateFreeAgentPool(rng, count: 6)) {
          freeAgentScores.add(p.battingScore);
        }
      }
      expect(_mean(freeAgentScores), lessThan(_mean(standardScores)));
    });
  });

  group('defaultLineupFor', () {
    test('throws unless given exactly 6 players', () {
      expect(() => defaultLineupFor(generateRoster(Random(3), count: 7)), throwsArgumentError);
    });

    test('produces a valid, non-overlapping default lineup', () {
      final rng = Random(4);
      for (var trial = 0; trial < 20; trial++) {
        final players = generateRoster(rng);
        final selection = defaultLineupFor(players);

        expect(selection.battingOrderIndices.length, 5);
        expect(selection.pitcherRotationIndices.length, 1);

        // Always-DH: batting order and pitcher rotation are disjoint.
        final battingSet = selection.battingOrderIndices.toSet();
        final pitcherSet = selection.pitcherRotationIndices.toSet();
        expect(battingSet.intersection(pitcherSet), isEmpty);

        // Fielders are drawn from the batting order (so they're active).
        expect(battingSet.contains(selection.fielder2Index), isTrue);
        expect(battingSet.contains(selection.fielder3Index), isTrue);
        expect(selection.fielder2Index, isNot(selection.fielder3Index));

        // Active (batting order + starter) covers all 6, no reserves.
        final active = {...battingSet, ...pitcherSet};
        expect(active.length, 6);
        expect(active, {0, 1, 2, 3, 4, 5});
      }
    });
  });
}
