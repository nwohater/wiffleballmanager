import 'package:wballmgr/career/org_roster.dart';
import 'package:wballmgr/data/database.dart';
import 'package:wballmgr/data/enums.dart';
import 'package:wballmgr/roster/roster_writer.dart';

import 'observed_stats.dart';
import 'team_manager.dart' as team_manager;

/// Minimum season sample before a player's observed rate stats are trusted
/// enough to act on for a call-up/send-down decision — mirrors
/// lib/ai/team_manager.dart's `evaluateRosterMoves` thresholds (duplicated
/// rather than imported since those constants are private there; same
/// "small sample can mislead" reasoning). Uncalibrated starting points.
const int _minQualifyingPa = 15;
const int _minQualifyingPitchingOuts = 30;

/// A minor-roster player must out-value the major roster's weakest
/// qualified player by at least this much (on the same re-centered scale
/// [_playerValue] uses) before a call-up swap triggers — keeps this
/// conservative rather than churning the roster over marginal differences,
/// same philosophy as `evaluateRosterMoves`'s replacement-level gate.
/// Uncalibrated starting point.
const double _callUpMargin = 0.25;

/// Neutral (roughly-average, unproven-player) value baselines — mirrors
/// lib/trade/trade_manager.dart's `playerTradeValue` re-centering so a
/// call-up/send-down comparison and a trade evaluation judge a player the
/// same way. Duplicated rather than imported to avoid an ai/ -> trade/
/// dependency; see that file's doc comment for the full reasoning.
const double _neutralBattingValue = 0.34 + 0.36;
const double _neutralPitchingValue = -(3.0 + 2.3);

double _playerValue(ObservedPlayerStats? stats) {
  if (stats == null) return 0;
  if (stats.outsRecorded > 0) return stats.pitchingScore - _neutralPitchingValue;
  return stats.battingScore - _neutralBattingValue;
}

/// Baseline AI call-up/send-down pass for one org (Phase 7's "AI call-up
/// logic for AI orgs" — the todo doc's remaining Phase 7 AI bullet): if the
/// minor roster's best qualified active player clearly out-values the major
/// roster's worst qualified active player (see [_callUpMargin]), swaps them
/// (lib/career/org_roster.dart's `swapActiveAssignment`) — a genuine call-up
/// paired with the send-down that has to free the spot for it, same
/// "development actually feeds the big-league roster" idea the minor tier
/// exists for. Capped at one swap per call, same conservative-churn pattern
/// as `evaluateRosterMoves`. No-op for the human-controlled org, for an org
/// missing either tier's team (shouldn't happen post-Phase-7-seeding, but
/// defensive), or when neither roster has a qualified player to compare.
Future<void> evaluateCallUps(
  AppDatabase db, {
  required int organizationId,
  required int completedSeasonId,
}) async {
  final org = await (db.select(db.organizations)..where((o) => o.id.equals(organizationId))).getSingle();
  if (org.isPlayerControlled) return;

  final divisionRows = await db.select(db.divisions).get();
  final divisionTier = {for (final d in divisionRows) d.id: d.tier};
  final orgTeams = await (db.select(db.teams)..where((t) => t.organizationId.equals(organizationId))).get();

  Team? majorTeam, minorTeam;
  for (final t in orgTeams) {
    if (divisionTier[t.divisionId] == Tier.major) majorTeam = t;
    if (divisionTier[t.divisionId] == Tier.minor) minorTeam = t;
  }
  if (majorTeam == null || minorTeam == null) return;

  final majorActive = (await readTeamRoster(db, majorTeam.id))
      .where((m) => m.slot == RosterSlot.active)
      .map((m) => m.playerId)
      .toList();
  final minorActive = (await readTeamRoster(db, minorTeam.id))
      .where((m) => m.slot == RosterSlot.active)
      .map((m) => m.playerId)
      .toList();
  if (majorActive.isEmpty || minorActive.isEmpty) return;

  final stats = await loadObservedStats(db, playerIds: [...majorActive, ...minorActive], seasonId: completedSeasonId);
  bool qualifies(int id) {
    final s = stats[id];
    return s != null && (s.pa >= _minQualifyingPa || s.outsRecorded >= _minQualifyingPitchingOuts);
  }

  final qualifiedMajor = majorActive.where(qualifies).toList();
  final qualifiedMinor = minorActive.where(qualifies).toList();
  if (qualifiedMajor.isEmpty || qualifiedMinor.isEmpty) return;

  final worstMajor =
      qualifiedMajor.reduce((a, b) => _playerValue(stats[a]) <= _playerValue(stats[b]) ? a : b);
  final bestMinor =
      qualifiedMinor.reduce((a, b) => _playerValue(stats[a]) >= _playerValue(stats[b]) ? a : b);

  if (_playerValue(stats[bestMinor]) - _playerValue(stats[worstMajor]) < _callUpMargin) return;

  await swapActiveAssignment(db, organizationId: organizationId, playerAId: bestMinor, playerBId: worstMajor);
  await team_manager.refreshAiLineup(db, teamId: majorTeam.id);
  await team_manager.refreshAiLineup(db, teamId: minorTeam.id);
}

/// Runs [evaluateCallUps] for every org. Intended to run from
/// lib/league/season_rollover.dart alongside the rest of the Phase 5/7 AI
/// offseason pass.
Future<void> runAiCallUps(AppDatabase db, {required int completedSeasonId}) async {
  final orgIds = (await db.select(db.organizations).get()).map((o) => o.id).toList();
  for (final organizationId in orgIds) {
    await evaluateCallUps(db, organizationId: organizationId, completedSeasonId: completedSeasonId);
  }
}
