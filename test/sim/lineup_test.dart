import 'package:flutter_test/flutter_test.dart';
import 'package:wballmgr/sim/lineup.dart';

void main() {
  Lineup build({
    List<int>? battingOrder,
    List<PitcherStint>? pitcherPlan,
  }) {
    return Lineup(
      teamId: 1,
      battingOrder: battingOrder ?? [1, 2, 3, 4, 5],
      pitcherPlan: pitcherPlan ?? [const PitcherStint(playerId: 1)],
      fielder2Id: 2,
      fielder3Id: 3,
    );
  }

  test('rejects a batting order outside 3-5 players', () {
    expect(() => build(battingOrder: [1, 2]), throwsArgumentError);
    expect(() => build(battingOrder: [1, 2, 3, 4, 5, 6]), throwsArgumentError);
  });

  test('rejects an empty pitcher plan', () {
    expect(() => build(pitcherPlan: []), throwsArgumentError);
  });

  test('enforces no-re-entry: a pitcher cannot appear in two stints', () {
    expect(
      () => build(pitcherPlan: [
        const PitcherStint(playerId: 1, throughInning: 2),
        const PitcherStint(playerId: 1),
      ]),
      throwsArgumentError,
    );
  });

  test('requires the last stint to be open-ended', () {
    expect(
      () => build(pitcherPlan: [const PitcherStint(playerId: 1, throughInning: 3)]),
      throwsArgumentError,
    );
  });

  test('requires strictly increasing throughInning across stints', () {
    expect(
      () => build(pitcherPlan: [
        const PitcherStint(playerId: 1, throughInning: 2),
        const PitcherStint(playerId: 2, throughInning: 2),
        const PitcherStint(playerId: 3),
      ]),
      throwsArgumentError,
    );
  });

  test('pitcherForInning resolves the right stint', () {
    final lineup = build(pitcherPlan: [
      const PitcherStint(playerId: 1, throughInning: 2),
      const PitcherStint(playerId: 2),
    ]);
    expect(lineup.pitcherForInning(1), 1);
    expect(lineup.pitcherForInning(2), 1);
    expect(lineup.pitcherForInning(3), 2);
    expect(lineup.pitcherForInning(5), 2);
  });

  test('fieldersForInning always includes the current pitcher plus the two constants', () {
    final lineup = build(pitcherPlan: [
      const PitcherStint(playerId: 1, throughInning: 2),
      const PitcherStint(playerId: 4),
    ]);
    expect(lineup.fieldersForInning(1), [1, 2, 3]);
    expect(lineup.fieldersForInning(3), [4, 2, 3]);
  });
}
