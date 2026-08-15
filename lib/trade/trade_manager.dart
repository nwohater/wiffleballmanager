import 'dart:math';

import 'package:drift/drift.dart';

import 'package:wballmgr/ai/observed_stats.dart';
import 'package:wballmgr/ai/team_manager.dart' as ai_team_manager;
import 'package:wballmgr/data/database.dart';
import 'package:wballmgr/data/enums.dart';
import 'package:wballmgr/roster/roster_rules.dart';
import 'package:wballmgr/roster/roster_writer.dart';

/// Neutral (roughly-average, unproven-player) trade-value baselines —
/// mirrors lib/ai/observed_stats.dart's neutral placeholder constants
/// (0.34 OBP + 0.36 SLG; -(3.0 ERA + 2.3 WHIP)) so an unproven player values
/// at 0 (neither an asset nor a liability) rather than being penalized.
const double _neutralBattingValue = 0.34 + 0.36;
const double _neutralPitchingValue = -(3.0 + 2.3);

/// A single player's trade value: [ObservedPlayerStats.pitchingScore] for a
/// player with any innings recorded this season, else
/// [ObservedPlayerStats.battingScore] — the always-DH rule
/// (roster_rules.dart) keeps a player's role cleanly disjoint per game, so
/// `outsRecorded > 0` reliably signals "this season's pitcher." Both are
/// re-centered on their own neutral baseline so a value of 0 always means
/// "average," making values comparable across roles despite living on very
/// different raw scales — the same cross-role approximation
/// lib/ai/team_manager.dart's `evaluateRosterMoves` already documents and
/// accepts, for the same reason (no single unified rating exists under the
/// Hidden Ratings model). Null/missing stats (shouldn't happen for a
/// rostered player) value as neutral.
double playerTradeValue(ObservedPlayerStats? stats) {
  if (stats == null) return 0;
  if (stats.outsRecorded > 0) return stats.pitchingScore - _neutralPitchingValue;
  return stats.battingScore - _neutralBattingValue;
}

/// True until the trade deadline: the regular season's final 3-game series
/// (its last 3 scheduled days) hasn't started yet. Per
/// context/rules-mlw-cultz-field.md's "deadline before final regular-season
/// games" (ambiguous singular/plural in the source), resolved as "the whole
/// final series," not just the last day. A season with no games scheduled
/// yet is treated as before the deadline.
Future<bool> isBeforeTradeDeadline(AppDatabase db, {required int seasonId}) async {
  final regularSeasonGames = await (db.select(db.games)
        ..where((g) => g.seasonId.equals(seasonId) & g.seriesId.isNull()))
      .get();
  if (regularSeasonGames.isEmpty) return true;

  final lastDay = regularSeasonGames.map((g) => g.gameNumber).reduce(max);
  final finalSeriesStartDay = lastDay - 2;
  return !regularSeasonGames
      .any((g) => g.gameNumber >= finalSeriesStartDay && g.status == GameStatus.completed);
}

/// Outcome of a [proposeTrade] call. A false [accepted] from an AI declining
/// the offer is an ordinary, expected result — not an error — so it's
/// returned here rather than thrown; illegal input (bad ownership, past the
/// deadline in a way the caller should have checked, an illegal resulting
/// roster) still throws [ArgumentError]/[StateError], matching
/// lib/roster/roster_writer.dart's `saveTeamLineup` convention.
class TradeResult {
  final bool accepted;
  final String? reason;

  const TradeResult({required this.accepted, this.reason});
}

bool _sideAccepts({
  required List<int> receiving,
  required List<int> givingUp,
  required Map<int, ObservedPlayerStats> stats,
}) {
  double totalValue(List<int> ids) => ids.fold(0.0, (sum, id) => sum + playerTradeValue(stats[id]));
  return totalValue(receiving) >= totalValue(givingUp);
}

/// Proposes a trade between [teamAId] and [teamBId] ([playersFromA] for
/// [playersFromB]) and, if accepted, executes it immediately — this is a
/// single-player-context simplification of the source ruleset's "captain +
/// verbal commissioner approval" (context/rules-mlw-cultz-field.md): a
/// human-controlled side always "accepts" (they proposed it), and any
/// AI-controlled side evaluates via [playerTradeValue] — same
/// observed-stats-only, Hidden-Ratings-respecting baseline
/// lib/ai/team_manager.dart already uses — rejecting if it would come out
/// behind on total value. Rejection is a normal outcome (see [TradeResult]),
/// not an error.
///
/// Throws [ArgumentError] if either player list is empty, a listed player
/// doesn't currently belong to the team it's listed under, or the resulting
/// roster on either side would violate roster_rules.dart's composition rule
/// (checked *before* any write, same pattern as `saveTeamLineup`). Throws
/// [StateError] if the trade deadline has already passed for [seasonId]
/// (see [isBeforeTradeDeadline]) — deliberately an error, not a silent
/// rejection, since a caller should be checking the deadline before even
/// offering a trade UI.
Future<TradeResult> proposeTrade(
  AppDatabase db, {
  required int seasonId,
  required int teamAId,
  required List<int> playersFromA,
  required int teamBId,
  required List<int> playersFromB,
}) async {
  if (teamAId == teamBId) {
    throw ArgumentError('A team cannot trade with itself.');
  }
  if (playersFromA.isEmpty || playersFromB.isEmpty) {
    throw ArgumentError('Both sides of a trade must send at least one player.');
  }
  if (!await isBeforeTradeDeadline(db, seasonId: seasonId)) {
    throw StateError('The trade deadline has passed for season $seasonId.');
  }

  final teamA = await (db.select(db.teams)..where((t) => t.id.equals(teamAId))).getSingle();
  final teamB = await (db.select(db.teams)..where((t) => t.id.equals(teamBId))).getSingle();

  final playersA = await (db.select(db.players)..where((p) => p.id.isIn(playersFromA))).get();
  final playersB = await (db.select(db.players)..where((p) => p.id.isIn(playersFromB))).get();
  if (playersA.length != playersFromA.length || playersA.any((p) => p.teamId != teamAId)) {
    throw ArgumentError('Every player in playersFromA must currently belong to team $teamAId.');
  }
  if (playersB.length != playersFromB.length || playersB.any((p) => p.teamId != teamBId)) {
    throw ArgumentError('Every player in playersFromB must currently belong to team $teamBId.');
  }

  final orgA =
      await (db.select(db.organizations)..where((o) => o.id.equals(teamA.organizationId))).getSingle();
  final orgB =
      await (db.select(db.organizations)..where((o) => o.id.equals(teamB.organizationId))).getSingle();

  final stats = await loadObservedStats(db, playerIds: [...playersFromA, ...playersFromB], seasonId: seasonId);

  if (!orgA.isPlayerControlled &&
      !_sideAccepts(receiving: playersFromB, givingUp: playersFromA, stats: stats)) {
    return const TradeResult(accepted: false, reason: 'Team A (AI-controlled) declined the offer.');
  }
  if (!orgB.isPlayerControlled &&
      !_sideAccepts(receiving: playersFromA, givingUp: playersFromB, stats: stats)) {
    return const TradeResult(accepted: false, reason: 'Team B (AI-controlled) declined the offer.');
  }

  final rosterA = await readTeamRoster(db, teamAId);
  final rosterB = await readTeamRoster(db, teamBId);
  final slotByPlayerId = {for (final m in [...rosterA, ...rosterB]) m.playerId: m.slot};

  RosterMember carryOverSlot(int playerId) => RosterMember(playerId: playerId, slot: slotByPlayerId[playerId]!);

  final newRosterA = [
    ...rosterA.where((m) => !playersFromA.contains(m.playerId)),
    ...playersFromB.map(carryOverSlot),
  ];
  final newRosterB = [
    ...rosterB.where((m) => !playersFromB.contains(m.playerId)),
    ...playersFromA.map(carryOverSlot),
  ];

  final errors = [...validateRosterComposition(newRosterA), ...validateRosterComposition(newRosterB)];
  if (errors.isNotEmpty) {
    throw ArgumentError('Trade would leave an illegal roster: ${errors.join(' ')}');
  }

  await db.transaction(() async {
    for (final id in playersFromA) {
      await (db.update(db.players)..where((p) => p.id.equals(id))).write(
        PlayersCompanion(teamId: Value(teamBId), organizationId: Value(teamB.organizationId)),
      );
    }
    for (final id in playersFromB) {
      await (db.update(db.players)..where((p) => p.id.equals(id))).write(
        PlayersCompanion(teamId: Value(teamAId), organizationId: Value(teamA.organizationId)),
      );
    }
  });

  // Keeps AI teams' saved lineups resupplied with newly-acquired players
  // (and clear of traded-away ones) — same post-roster-change hygiene as
  // lib/league/game_runner.dart's injury handling and season_rollover.dart's
  // AI offseason pass. No-op for the human-controlled team, same as always.
  await ai_team_manager.refreshAiLineup(db, teamId: teamAId);
  await ai_team_manager.refreshAiLineup(db, teamId: teamBId);

  return const TradeResult(accepted: true);
}
