import 'package:flutter_test/flutter_test.dart';

import 'package:wballmgr/ai/lineup_ai.dart';
import 'package:wballmgr/data/enums.dart';
import 'package:wballmgr/roster/roster_rules.dart';
import 'package:wballmgr/sim/sim_player.dart';

SimPlayer _player(
  int id, {
  int contact = 50,
  int power = 50,
  int discipline = 50,
  int control = 50,
  int stamina = 50,
  int range = 50,
  int hands = 50,
  int arm = 50,
}) =>
    SimPlayer(
      id: id,
      name: 'Player $id',
      contact: contact,
      power: power,
      discipline: discipline,
      speed: 50,
      control: control,
      stamina: stamina,
      repertoire: const [],
      range: range,
      hands: hands,
      arm: arm,
    );

void main() {
  test('picks the best 2 pitching scores as the rotation, ranks the rest by batting score,'
      ' and picks the top 2 fielding scores among them for fielder2/3', () {
    final roster = [for (var i = 1; i <= 6; i++) RosterMember(playerId: i, slot: RosterSlot.active)];

    // Players 1 and 2 are clearly the two best pitchers (everyone else has
    // token pitching ratings).
    final players = {
      1: _player(1, control: 99, stamina: 99),
      2: _player(2, control: 90, stamina: 90),
      3: _player(3, control: 10, stamina: 10, contact: 80, power: 80, discipline: 80, range: 50, hands: 50, arm: 50),
      4: _player(4, control: 10, stamina: 10, contact: 99, power: 99, discipline: 99, range: 99, hands: 99, arm: 99),
      5: _player(5, control: 10, stamina: 10, contact: 70, power: 70, discipline: 70, range: 90, hands: 90, arm: 90),
      6: _player(6, control: 10, stamina: 10, contact: 60, power: 60, discipline: 60, range: 40, hands: 40, arm: 40),
    };

    final choice = chooseLineup(roster: roster, players: players);

    expect(choice.pitcherRotation, [1, 2]);
    expect(choice.battingOrder, [4, 3, 5, 6]);
    expect({choice.fielder2Id, choice.fielder3Id}, unorderedEquals([4, 5]));

    // Legal by construction: verify against the actual validators rather
    // than assuming.
    expect(validateRosterComposition(roster), isEmpty);
    expect(validateBattingOrder(choice.battingOrder, roster), isEmpty);
    expect(validatePitcherRotation(choice.pitcherRotation, choice.battingOrder, roster), isEmpty);
    expect(validateFielders(choice.fielder2Id, choice.fielder3Id, choice.pitcherRotation, roster), isEmpty);
  });

  test('throws if the roster does not have exactly 6 active members', () {
    final roster = [for (var i = 1; i <= 5; i++) RosterMember(playerId: i, slot: RosterSlot.active)];
    expect(() => chooseLineup(roster: roster, players: const {}), throwsArgumentError);
  });
}
