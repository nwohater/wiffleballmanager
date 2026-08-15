import 'dart:math';

import 'package:wballmgr/career/free_agents.dart';
import 'package:wballmgr/data/database.dart';
import 'package:wballmgr/data/enums.dart';
import 'package:wballmgr/roster/roster_writer.dart';
import 'package:wballmgr/roster/sim_player_loader.dart';

import 'lineup_ai.dart';
import 'observed_stats.dart';

/// Minimum season sample before a player's observed rate stats are trusted
/// enough to act on — below this, an unproven player is never cut, same
/// "small sample can mislead" reasoning as observed_stats.dart's neutral
/// placeholders. Uncalibrated starting points.
const int _minQualifyingPa = 15;
const int _minQualifyingPitchingOuts = 30;

/// Replacement-level thresholds a qualified player's score must fall below
/// to be cut — set just below observed_stats.dart's neutral (~average)
/// scores, so only a demonstrably below-average performance (not merely
/// "not great") triggers a move. Uncalibrated starting points, same
/// treatment as Phase 4's aging/injury constants.
const double _battingReplacementLevel = 0.55; // neutral obp+slg is ~0.70
const double _pitchingReplacementLevel = -5.3; // neutral -(era+whip) is ~-5.3

Future<bool> _isAiControlled(AppDatabase db, int teamId) async {
  final team = await (db.select(db.teams)..where((t) => t.id.equals(teamId))).getSingle();
  final org =
      await (db.select(db.organizations)..where((o) => o.id.equals(team.organizationId))).getSingle();
  return !org.isPlayerControlled;
}

/// Recomputes and saves an AI-controlled team's lineup/rotation from its
/// current active roster's true ratings, via lib/ai/lineup_ai.dart's
/// chooseLineup (Phase 5's "smarter" AI variant — see that function's doc
/// comment for why lineup/rotation is a deliberate exception to the
/// observed-stats-only baseline) + the same saveTeamLineup write path the
/// manual editing UI uses. No-op for the human-controlled team and for a
/// team whose active roster doesn't have exactly 6 players (shouldn't
/// happen, but defensive — chooseLineup would otherwise throw).
///
/// Intended to run after anything that can change an AI team's active
/// roster (an injury/DL backfill mid-season, a roster move at rollover) so
/// a newly-added player actually gets used instead of the saved lineup
/// silently shrinking around them.
Future<void> refreshAiLineup(AppDatabase db, {required int teamId}) async {
  if (!await _isAiControlled(db, teamId)) return;

  final roster = await readTeamRoster(db, teamId);
  if (roster.where((m) => m.slot == RosterSlot.active).length != 6) return;

  final players = await loadSimPlayers(db, teamIds: [teamId]);
  final choice = chooseLineup(roster: roster, players: players);

  await saveTeamLineup(
    db,
    teamId: teamId,
    battingOrder: choice.battingOrder,
    pitcherRotation: choice.pitcherRotation,
    fielder2Id: choice.fielder2Id,
    fielder3Id: choice.fielder3Id,
  );
}

/// Baseline AI roster-move pass for one AI-controlled team: looks at
/// [completedSeasonId]'s observed stats for the active roster and, if the
/// single worst *qualified* player (see the sample-size minimums above) is
/// below replacement level, releases them to free agency and blind-signs a
/// replacement (lib/career/free_agents.dart — free agents have no game
/// history, so there's no observed signal to prefer one over another; that
/// limitation is intentional for a baseline, observed-stats-only AI per the
/// PRD, not a bug). Capped at one move per call so this stays conservative
/// rather than churning the roster every season. No-op for the
/// human-controlled team.
///
/// A player pitching is judged on pitchingScore, a player batting on
/// battingScore — those two scores live on different scales (see
/// observed_stats.dart), so comparing "how far below replacement" across
/// roles to find the single worst is an approximation, not an exact
/// ranking, in the same spirit as Phase 4's documented W/L/S
/// approximations.
Future<void> evaluateRosterMoves(
  AppDatabase db, {
  required int teamId,
  required int completedSeasonId,
  Random? random,
}) async {
  final team = await (db.select(db.teams)..where((t) => t.id.equals(teamId))).getSingle();
  final org =
      await (db.select(db.organizations)..where((o) => o.id.equals(team.organizationId))).getSingle();
  if (org.isPlayerControlled) return;

  final roster = await readTeamRoster(db, teamId);
  final active = roster.where((m) => m.slot == RosterSlot.active).toList();
  if (active.isEmpty) return;

  final stats = await loadObservedStats(
    db,
    playerIds: active.map((m) => m.playerId).toList(),
    seasonId: completedSeasonId,
  );

  // Whoever pitched the most this season (if enough of a sample) is judged
  // as the pitcher; everyone else is judged as a batter.
  final pitcherId = active
      .map((m) => m.playerId)
      .reduce((a, b) => (stats[a]?.outsRecorded ?? 0) >= (stats[b]?.outsRecorded ?? 0) ? a : b);
  final pitcherQualifies = (stats[pitcherId]?.outsRecorded ?? 0) >= _minQualifyingPitchingOuts;

  int? worstPlayerId;
  double? worstMargin;

  if (pitcherQualifies) {
    final margin = stats[pitcherId]!.pitchingScore - _pitchingReplacementLevel;
    if (margin < 0) {
      worstPlayerId = pitcherId;
      worstMargin = margin;
    }
  }

  for (final member in active) {
    if (member.playerId == pitcherId && pitcherQualifies) continue;
    final line = stats[member.playerId];
    if (line == null || line.pa < _minQualifyingPa) continue;
    final margin = line.battingScore - _battingReplacementLevel;
    if (margin < 0 && (worstMargin == null || margin < worstMargin)) {
      worstPlayerId = member.playerId;
      worstMargin = margin;
    }
  }

  if (worstPlayerId == null) return;

  // Sign the replacement before releasing the cut player: signFreeAgent's
  // "first unrostered player" query has no explicit ordering, and a
  // just-released rostered player (an old, low id) would otherwise be
  // just as eligible as anyone actually sitting in the free-agent pool —
  // signing first, while the cut player still occupies their roster spot,
  // rules that out.
  await signFreeAgent(db, teamId: teamId, organizationId: team.organizationId, random: random);
  await releaseToFreeAgency(db, playerId: worstPlayerId);
}

/// Runs the AI offseason pass for every team (roster-move evaluation, then
/// a lineup refresh using [completedSeasonId]'s finalized stats to set the
/// next season's opening lineup) — both no-op for the human-controlled
/// team. Intended to run from lib/league/season_rollover.dart after the
/// free-agent pool has been topped back up.
Future<void> runAiOffseason(AppDatabase db, {required int completedSeasonId, Random? random}) async {
  final teamIds = (await db.select(db.teams).get()).map((t) => t.id).toList();
  for (final teamId in teamIds) {
    await evaluateRosterMoves(db, teamId: teamId, completedSeasonId: completedSeasonId, random: random);
    await refreshAiLineup(db, teamId: teamId);
  }
}
