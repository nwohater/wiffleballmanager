import 'package:flutter_test/flutter_test.dart';

import 'package:wballmgr/ai/lineup_ai.dart';
import 'package:wballmgr/ai/observed_stats.dart';
import 'package:wballmgr/data/enums.dart';
import 'package:wballmgr/roster/roster_rules.dart';

ObservedPlayerStats _line(
  int playerId, {
  double obp = 0.34,
  double slg = 0.36,
  double era = 3.0,
  double whip = 2.3,
  double fpct = 0.95,
}) =>
    ObservedPlayerStats(
      playerId: playerId,
      pa: 20,
      obp: obp,
      slg: slg,
      outsRecorded: 30,
      era: era,
      whip: whip,
      chances: 10,
      fpct: fpct,
    );

void main() {
  test('picks the best pitching score as the sole starter, ranks the rest by batting score,'
      ' and picks the top 2 fielding scores among them for fielder2/3', () {
    final roster = [for (var i = 1; i <= 6; i++) RosterMember(playerId: i, slot: RosterSlot.active)];

    // Player 1 is clearly the best pitcher (lowest era+whip).
    final stats = {
      1: _line(1, era: 0.5, whip: 0.5),
      2: _line(2, obp: 0.5, slg: 0.5, fpct: 0.99), // best batter, 2nd-best fielder
      3: _line(3, obp: 0.45, slg: 0.45, fpct: 1.0), // 2nd-best batter, best fielder
      4: _line(4, obp: 0.40, slg: 0.40),
      5: _line(5, obp: 0.35, slg: 0.35),
      6: _line(6, obp: 0.30, slg: 0.30),
    };

    final choice = chooseLineup(roster: roster, stats: stats);

    expect(choice.pitcherRotation, [1]);
    expect(choice.battingOrder, [2, 3, 4, 5, 6]);
    expect({choice.fielder2Id, choice.fielder3Id}, unorderedEquals([2, 3]));

    // Legal by construction: verify against the actual validators rather
    // than assuming.
    expect(validateRosterComposition(roster), isEmpty);
    expect(validateBattingOrder(choice.battingOrder, roster), isEmpty);
    expect(validatePitcherRotation(choice.pitcherRotation, choice.battingOrder, roster), isEmpty);
    expect(validateFielders(choice.fielder2Id, choice.fielder3Id, choice.pitcherRotation, roster), isEmpty);
  });

  test('an unproven player with neutral placeholder stats is not auto-benched to the bottom', () {
    final roster = [for (var i = 1; i <= 6; i++) RosterMember(playerId: i, slot: RosterSlot.active)];

    // Player 6 is unproven (neutral defaults); players 2-5 are established
    // but below-average batters. Player 6's neutral score should outrank
    // them, landing near the top of the batting order rather than the
    // bottom.
    final stats = {
      1: _line(1, era: 0.5, whip: 0.5),
      2: _line(2, obp: 0.20, slg: 0.20),
      3: _line(3, obp: 0.22, slg: 0.22),
      4: _line(4, obp: 0.24, slg: 0.24),
      5: _line(5, obp: 0.26, slg: 0.26),
      6: _line(6), // neutral placeholders: obp .34 + slg .36 = .70
    };

    final choice = chooseLineup(roster: roster, stats: stats);

    expect(choice.battingOrder.first, 6);
  });

  test('throws if the roster does not have exactly 6 active members', () {
    final roster = [for (var i = 1; i <= 5; i++) RosterMember(playerId: i, slot: RosterSlot.active)];
    expect(() => chooseLineup(roster: roster, stats: const {}), throwsArgumentError);
  });
}
