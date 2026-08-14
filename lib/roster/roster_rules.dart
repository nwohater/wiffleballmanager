import 'package:wballmgr/data/enums.dart';

/// Minimal roster-membership view needed for validation — decoupled from
/// drift so these rules can be unit-tested without a database, and reused
/// by both the writer (lib/roster/roster_writer.dart) and the editing UI
/// for live feedback.
class RosterMember {
  final int playerId;
  final RosterSlot slot;

  const RosterMember({required this.playerId, required this.slot});
}

/// Ruleset: exactly 6 active per team, no reserve slot (Phase 4 rework —
/// see context/rules-mlw-cultz-field.md). `dl` is intentionally uncapped:
/// 0-N players on the disabled list is always valid and doesn't affect this
/// check.
List<String> validateRosterComposition(List<RosterMember> roster) {
  final errors = <String>[];
  final active = roster.where((m) => m.slot == RosterSlot.active).length;
  if (active != 6) {
    errors.add('Roster must have exactly 6 active players, has $active.');
  }
  return errors;
}

/// Ruleset: batting lineup is 3-5 players, all from the active roster.
List<String> validateBattingOrder(List<int> battingOrder, List<RosterMember> roster) {
  final errors = <String>[];
  if (battingOrder.length < 3 || battingOrder.length > 5) {
    errors.add('Batting order must have 3-5 players, has ${battingOrder.length}.');
  }
  if (battingOrder.toSet().length != battingOrder.length) {
    errors.add('Batting order has a duplicate player.');
  }
  final activeIds = roster.where((m) => m.slot == RosterSlot.active).map((m) => m.playerId).toSet();
  for (final id in battingOrder) {
    if (!activeIds.contains(id)) {
      errors.add('Player $id in the batting order is not on the active roster.');
    }
  }
  return errors;
}

/// Pitcher rotation: 1+ players drawn from the roster (active or dl — a
/// *saved* lineup may name a currently-injured player; the runtime lineup
/// resolver, not validation, is what skips them when actually unavailable).
/// Always-DH: disjoint from the batting order, since pitchers never bat
/// under that rule.
List<String> validatePitcherRotation(
  List<int> pitcherRotation,
  List<int> battingOrder,
  List<RosterMember> roster,
) {
  final errors = <String>[];
  if (pitcherRotation.isEmpty) {
    errors.add('Pitcher rotation must have at least 1 player.');
  }
  if (pitcherRotation.toSet().length != pitcherRotation.length) {
    errors.add('Pitcher rotation has a duplicate player.');
  }
  final rosterIds = roster.map((m) => m.playerId).toSet();
  for (final id in pitcherRotation) {
    if (!rosterIds.contains(id)) {
      errors.add('Player $id in the pitcher rotation is not on the roster.');
    }
  }
  final battingSet = battingOrder.toSet();
  for (final id in pitcherRotation) {
    if (battingSet.contains(id)) {
      errors.add('Player $id is in both the batting order and the pitcher rotation — DH is always on, so pitchers cannot also bat.');
    }
  }
  return errors;
}

/// Ruleset: defense is 3 players including the pitcher — fielder2/fielder3
/// are the other two, fixed for the whole game, drawn from the active
/// roster (they need to be in the game to field). Also disjoint from the
/// pitcher rotation: a player can't field a non-pitcher position while
/// also being one of the players who might be on the mound.
List<String> validateFielders(
  int fielder2Id,
  int fielder3Id,
  List<int> pitcherRotation,
  List<RosterMember> roster,
) {
  final errors = <String>[];
  if (fielder2Id == fielder3Id) {
    errors.add('Fielder 2 and Fielder 3 must be different players.');
  }
  final activeIds = roster.where((m) => m.slot == RosterSlot.active).map((m) => m.playerId).toSet();
  if (!activeIds.contains(fielder2Id)) {
    errors.add('Fielder 2 ($fielder2Id) is not on the active roster.');
  }
  if (!activeIds.contains(fielder3Id)) {
    errors.add('Fielder 3 ($fielder3Id) is not on the active roster.');
  }
  final pitcherSet = pitcherRotation.toSet();
  if (pitcherSet.contains(fielder2Id)) {
    errors.add('Fielder 2 ($fielder2Id) is also in the pitcher rotation.');
  }
  if (pitcherSet.contains(fielder3Id)) {
    errors.add('Fielder 3 ($fielder3Id) is also in the pitcher rotation.');
  }
  return errors;
}
