import 'package:flutter_test/flutter_test.dart';
import 'package:wballmgr/data/enums.dart';
import 'package:wballmgr/roster/roster_rules.dart';

List<RosterMember> _roster() => [
      for (var i = 1; i <= 6; i++) RosterMember(playerId: i, slot: RosterSlot.active),
      RosterMember(playerId: 7, slot: RosterSlot.dl),
      RosterMember(playerId: 8, slot: RosterSlot.dl),
    ];

void main() {
  group('validateRosterComposition', () {
    test('passes for exactly 6 active', () {
      expect(validateRosterComposition(_roster()), isEmpty);
    });

    test('flags wrong active count', () {
      final roster = [
        RosterMember(playerId: 1, slot: RosterSlot.active),
        RosterMember(playerId: 2, slot: RosterSlot.dl),
      ];
      final errors = validateRosterComposition(roster);
      expect(errors, hasLength(1));
    });

    test('dl count is uncapped and never affects validity', () {
      final noDl = [for (var i = 1; i <= 6; i++) RosterMember(playerId: i, slot: RosterSlot.active)];
      expect(validateRosterComposition(noDl), isEmpty);

      final manyDl = [
        for (var i = 1; i <= 6; i++) RosterMember(playerId: i, slot: RosterSlot.active),
        for (var i = 7; i <= 12; i++) RosterMember(playerId: i, slot: RosterSlot.dl),
      ];
      expect(validateRosterComposition(manyDl), isEmpty);
    });
  });

  group('validateBattingOrder', () {
    test('passes for 3-5 unique active players', () {
      expect(validateBattingOrder([1, 2, 3], _roster()), isEmpty);
      expect(validateBattingOrder([1, 2, 3, 4, 5], _roster()), isEmpty);
    });

    test('flags out-of-range size', () {
      expect(validateBattingOrder([1, 2], _roster()), isNotEmpty);
      expect(validateBattingOrder([1, 2, 3, 4, 5, 6], _roster()), isNotEmpty);
    });

    test('flags duplicates', () {
      expect(validateBattingOrder([1, 1, 2], _roster()), isNotEmpty);
    });

    test('flags a non-active player (dl or off-roster)', () {
      expect(validateBattingOrder([1, 2, 7], _roster()), isNotEmpty); // 7 is dl
      expect(validateBattingOrder([1, 2, 99], _roster()), isNotEmpty); // not on roster
    });
  });

  group('validatePitcherRotation', () {
    test('passes for roster members disjoint from the batting order', () {
      expect(validatePitcherRotation([6], [1, 2, 3, 4, 5], _roster()), isEmpty);
      expect(validatePitcherRotation([6, 7], [1, 2, 3, 4, 5], _roster()), isEmpty);
    });

    test('flags an empty rotation', () {
      expect(validatePitcherRotation([], [1, 2, 3], _roster()), isNotEmpty);
    });

    test('flags a pitcher who is also in the batting order (Always-DH)', () {
      expect(validatePitcherRotation([1], [1, 2, 3], _roster()), isNotEmpty);
    });

    test('flags a pitcher not on the roster', () {
      expect(validatePitcherRotation([99], [1, 2, 3], _roster()), isNotEmpty);
    });
  });

  group('validateFielders', () {
    test('passes for two distinct active non-pitcher players', () {
      expect(validateFielders(2, 3, [6], _roster()), isEmpty);
    });

    test('flags identical fielder2/fielder3', () {
      expect(validateFielders(2, 2, [6], _roster()), isNotEmpty);
    });

    test('flags a dl or off-roster fielder', () {
      expect(validateFielders(7, 2, [6], _roster()), isNotEmpty);
      expect(validateFielders(99, 2, [6], _roster()), isNotEmpty);
    });

    test('flags a fielder who is also in the pitcher rotation', () {
      expect(validateFielders(6, 2, [6], _roster()), isNotEmpty);
    });
  });
}
