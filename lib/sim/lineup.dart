/// One pitcher's outing within a game's pitching plan. [throughInning] is
/// the last inning (1-based) this pitcher is scheduled to cover; null means
/// "rest of the game, including any extra innings."
class PitcherStint {
  final int playerId;
  final int? throughInning;

  const PitcherStint({required this.playerId, this.throughInning});
}

/// Sim-engine-facing lineup for one team in one game. Deliberately narrow:
/// it's what [simulateGame] needs to run, not a roster-management concept —
/// Phase 2 owns building these from a team's actual roster/UI.
///
/// Fielding is simplified to 3 constant defenders for the whole game
/// ([fielder2Id]/[fielder3Id] never change) plus whoever the pitcher plan
/// says is on the mound — the realistic in-game substitution case for a
/// 6+2 roster is a pitching change, not swapping the other two fielders.
class Lineup {
  final int teamId;

  /// 3-5 playerIds, per the ruleset's batting-lineup size (cycles through
  /// the whole game).
  final List<int> battingOrder;

  /// Non-empty, unique playerIds across stints (structurally enforces the
  /// no-re-entry rule — see rules-mlw-cultz-field.md), stints ordered by
  /// increasing [PitcherStint.throughInning] with the last stint open-ended
  /// (throughInning == null) so it covers extra innings.
  final List<PitcherStint> pitcherPlan;

  final int fielder2Id;
  final int fielder3Id;

  Lineup({
    required this.teamId,
    required this.battingOrder,
    required this.pitcherPlan,
    required this.fielder2Id,
    required this.fielder3Id,
  }) {
    if (battingOrder.length < 3 || battingOrder.length > 5) {
      throw ArgumentError(
        'battingOrder must have 3-5 players, got ${battingOrder.length}',
      );
    }
    if (pitcherPlan.isEmpty) {
      throw ArgumentError('pitcherPlan must not be empty');
    }
    final pitcherIds = pitcherPlan.map((s) => s.playerId).toList();
    if (pitcherIds.toSet().length != pitcherIds.length) {
      throw ArgumentError(
        'pitcherPlan has a repeated playerId — violates the no-re-entry rule',
      );
    }
    for (var i = 0; i < pitcherPlan.length - 1; i++) {
      if (pitcherPlan[i].throughInning == null) {
        throw ArgumentError(
          'Only the last pitcherPlan stint may have throughInning == null',
        );
      }
    }
    if (pitcherPlan.last.throughInning != null) {
      throw ArgumentError(
        'The last pitcherPlan stint must have throughInning == null '
        '(covers the rest of the game, including extra innings)',
      );
    }
    for (var i = 0; i < pitcherPlan.length - 1; i++) {
      final next = pitcherPlan[i + 1].throughInning;
      if (next != null && pitcherPlan[i].throughInning! >= next) {
        throw ArgumentError('pitcherPlan stints must have strictly increasing throughInning');
      }
    }
  }

  /// Which playerId is pitching during [inning], per the plan.
  int pitcherForInning(int inning) {
    for (final stint in pitcherPlan) {
      if (stint.throughInning == null || inning <= stint.throughInning!) {
        return stint.playerId;
      }
    }
    return pitcherPlan.last.playerId;
  }

  /// The 3 defenders on the field during [inning] (pitcher + the 2 constant
  /// fielders).
  List<int> fieldersForInning(int inning) => [
        pitcherForInning(inning),
        fielder2Id,
        fielder3Id,
      ];
}
