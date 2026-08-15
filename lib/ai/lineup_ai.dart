import 'package:wballmgr/data/enums.dart';
import 'package:wballmgr/roster/roster_rules.dart';
import 'package:wballmgr/sim/sim_player.dart';

/// A lineup/rotation choice produced by [chooseLineup] — same shape
/// lib/roster/roster_writer.dart's saveTeamLineup expects, so callers just
/// forward these fields straight into it.
class LineupChoice {
  final List<int> battingOrder;
  final List<int> pitcherRotation;
  final int fielder2Id;
  final int fielder3Id;

  const LineupChoice({
    required this.battingOrder,
    required this.pitcherRotation,
    required this.fielder2Id,
    required this.fielder3Id,
  });
}

/// AI lineup/rotation heuristic, ranked by true ratings ([SimPlayer]'s
/// battingScore/pitchingScore/fieldingScore) rather than observed stats —
/// the Phase 5 "smarter" AI variant. A deliberate, user-directed exception
/// to the Hidden Ratings model for exactly this decision (lineup and
/// pitching rotation): observed stats give no usable signal for this call
/// (an AI team's own true-talent gaps are exactly what good lineup-setting
/// needs to see), whereas roster-move cut/sign decisions
/// (lib/ai/team_manager.dart's evaluateRosterMoves) stay observed-stats-only
/// since that limitation was never the blocker there. Pure/no drift
/// import, same as roster_rules.dart, so it's unit-testable without a
/// database.
///
/// Picks the top 2 players by pitchingScore as a 2-deep pitcherRotation
/// (index 0 = the better arm) — sized specifically for
/// context/rules-mlw-cultz-field.md's per-series 6-inning cap, which
/// lib/league/game_runner.dart's `_resolvePitcherPlan` turns into an
/// alternating "ace starts games 1 and 3, second arm starts game 2"
/// pattern per 3-game series (2 starts x 3 innings = the cap, if both stay
/// in regulation). The remaining 4 players become the batting order, ranked
/// by battingScore; the best 2 fielders among those 4 fill fielder2/3.
///
/// Requires exactly 6 active roster members, matching
/// validateRosterComposition's rule — the result is legal by construction
/// against roster_rules.dart's validators (verified in tests, not just
/// assumed).
LineupChoice chooseLineup({
  required List<RosterMember> roster,
  required Map<int, SimPlayer> players,
}) {
  final active = roster.where((m) => m.slot == RosterSlot.active).map((m) => m.playerId).toList();
  if (active.length != 6) {
    throw ArgumentError('chooseLineup requires exactly 6 active roster members, got ${active.length}');
  }

  double pitchingScore(int id) => players[id]?.pitchingScore ?? 0;
  double battingScore(int id) => players[id]?.battingScore ?? 0;
  double fieldingScore(int id) => players[id]?.fieldingScore ?? 0;

  final byPitching = List.of(active)..sort((a, b) => pitchingScore(b).compareTo(pitchingScore(a)));
  final pitcherRotation = byPitching.take(2).toList();

  final battingOrder = active.where((id) => !pitcherRotation.contains(id)).toList()
    ..sort((a, b) => battingScore(b).compareTo(battingScore(a)));

  final fielderCandidates = List.of(battingOrder)
    ..sort((a, b) => fieldingScore(b).compareTo(fieldingScore(a)));

  return LineupChoice(
    battingOrder: battingOrder,
    pitcherRotation: pitcherRotation,
    fielder2Id: fielderCandidates[0],
    fielder3Id: fielderCandidates[1],
  );
}
