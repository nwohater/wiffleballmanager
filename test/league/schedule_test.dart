import 'package:flutter_test/flutter_test.dart';
import 'package:wballmgr/league/schedule.dart';

void main() {
  group('generateRoundRobinSchedule', () {
    final teamIds = List.generate(12, (i) => i + 1);

    test('generates 198 games for 12 teams', () {
      expect(generateRoundRobinSchedule(teamIds: teamIds).length, 198);
    });

    test('every team appears in exactly 33 games', () {
      final games = generateRoundRobinSchedule(teamIds: teamIds);
      for (final id in teamIds) {
        final count = games.where((g) => g.homeTeamId == id || g.awayTeamId == id).length;
        expect(count, 33, reason: 'team $id');
      }
    });

    test('every pairing occurs exactly 3 times (a real series, not scattered)', () {
      final games = generateRoundRobinSchedule(teamIds: teamIds);
      final pairCounts = <String, int>{};
      for (final g in games) {
        final pair = ([g.homeTeamId, g.awayTeamId]..sort()).join('-');
        pairCounts[pair] = (pairCounts[pair] ?? 0) + 1;
      }
      expect(pairCounts.length, 66); // C(12,2)
      expect(pairCounts.values.every((c) => c == 3), isTrue);
    });

    test('no team plays itself', () {
      final games = generateRoundRobinSchedule(teamIds: teamIds);
      expect(games.any((g) => g.homeTeamId == g.awayTeamId), isFalse);
    });

    test('exactly 6 games per day across days 1-33', () {
      final games = generateRoundRobinSchedule(teamIds: teamIds);
      final byDay = <int, int>{};
      for (final g in games) {
        byDay[g.dayNumber] = (byDay[g.dayNumber] ?? 0) + 1;
      }
      expect(byDay.keys.toSet(), Set<int>.of(List.generate(33, (i) => i + 1)));
      expect(byDay.values.every((c) => c == 6), isTrue);
    });

    test('no team hosts all or none of its series', () {
      final games = generateRoundRobinSchedule(teamIds: teamIds);
      for (final id in teamIds) {
        final hostedSeries = games.where((g) => g.homeTeamId == id).length ~/ 3;
        expect(hostedSeries, inInclusiveRange(1, 10), reason: 'team $id');
      }
    });

    test('throws for an odd number of teams', () {
      expect(() => generateRoundRobinSchedule(teamIds: [1, 2, 3]), throwsArgumentError);
    });

    test('throws for fewer than 2 teams', () {
      expect(() => generateRoundRobinSchedule(teamIds: [1]), throwsArgumentError);
    });
  });
}
