import 'package:wballmgr/data/enums.dart';
import 'package:wballmgr/roster/roster_rules.dart';

import 'observed_stats.dart';

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

/// Baseline AI lineup heuristic: partitions a 6-active roster the same way
/// lib/roster/roster_generator.dart's defaultLineupFor does at generation
/// time (single best pitcher as the sole rotation entry, the remaining 5 as
/// the batting order, the best 2 fielders among those 5), but ranks players
/// by [stats]' observed rate stats instead of true ratings — the whole
/// point of a baseline, Hidden-Ratings-respecting AI. Pure/no drift import,
/// same as roster_rules.dart, so it's unit-testable without a database.
///
/// Requires exactly 6 active roster members, matching
/// validateRosterComposition's rule — the result is legal by construction
/// against roster_rules.dart's validators (verified in tests, not just
/// assumed).
LineupChoice chooseLineup({
  required List<RosterMember> roster,
  required Map<int, ObservedPlayerStats> stats,
}) {
  final active = roster.where((m) => m.slot == RosterSlot.active).map((m) => m.playerId).toList();
  if (active.length != 6) {
    throw ArgumentError('chooseLineup requires exactly 6 active roster members, got ${active.length}');
  }

  double pitchingScore(int id) => stats[id]?.pitchingScore ?? 0;
  double battingScore(int id) => stats[id]?.battingScore ?? 0;
  double fieldingScore(int id) => stats[id]?.fieldingScore ?? 0;

  final byPitching = List.of(active)..sort((a, b) => pitchingScore(b).compareTo(pitchingScore(a)));
  final starterId = byPitching.first;

  final battingOrder = active.where((id) => id != starterId).toList()
    ..sort((a, b) => battingScore(b).compareTo(battingScore(a)));

  final fielderCandidates = List.of(battingOrder)
    ..sort((a, b) => fieldingScore(b).compareTo(fieldingScore(a)));

  return LineupChoice(
    battingOrder: battingOrder,
    pitcherRotation: [starterId],
    fielder2Id: fielderCandidates[0],
    fielder3Id: fielderCandidates[1],
  );
}
