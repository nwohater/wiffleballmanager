import 'dart:math';

import 'package:drift/drift.dart';

import 'package:wballmgr/ai/team_manager.dart' as ai_team_manager;
import 'package:wballmgr/career/injuries_engine.dart' as injuries_engine;
import 'package:wballmgr/data/database.dart';
import 'package:wballmgr/data/enums.dart';
import 'package:wballmgr/roster/sim_player_loader.dart';
import 'package:wballmgr/sim/box_score.dart' as sim;
import 'package:wballmgr/sim/game_simulator.dart';
import 'package:wballmgr/sim/lineup.dart';

import 'box_score_writer.dart';
import 'playoffs.dart';
import 'standings.dart';

List<int> _parseIds(String csv) => csv.isEmpty ? [] : csv.split(',').map(int.parse).toList();

/// Innings a single pitcher may throw across one regular-season 3-game
/// series (context/rules-mlw-cultz-field.md's per-series cap, added mid-
/// Phase-5 from direct user domain knowledge — not in the originally
/// scraped rules page). Not enforced for playoff series — see
/// [_resolvePitcherPlan]'s doc comment.
const int _seriesInningsCap = 6;

/// Builds this game's pitcher plan for [savedRow]'s team: which pitcher(s)
/// start and, if the series-innings cap forces a mid-game handoff, who
/// relieves. Two concerns, both scoped to regular-season games only
/// (`[game].seriesId == null` — playoff series don't follow the 3-game
/// cadence this logic assumes, so playoff games get the old unrestricted
/// "first available rotation entry, whole game" behavior):
///
/// 1. **Which rotation entry is "up" this game** — [savedRow]'s
///    pitcherRotation is an ordered list (1 entry for the pre-Phase-5
///    default/most manually-set human lineups, 2 for
///    lib/ai/lineup_ai.dart's true-rating AI). For a 2-deep rotation, index
///    0 ("the ace") is preferred for games 1 and 3 of the series and index
///    1 for game 2 — the "start your best arm twice, rest them in between"
///    pattern the cap is built around (2 starts x 3 innings = exactly the
///    6-inning cap, if both stay in regulation). A 1-entry rotation has no
///    game-2 alternative, so it's just that one entry every game, as
///    before.
/// 2. **The [_seriesInningsCap] itself** — whoever's up this game only gets
///    a stint through however many innings remain in their per-series
///    budget (prior regular-season games in this same 3-game block, summed
///    from PitchingStats); a second, open-ended stint stands by with the
///    next-best available/budgeted candidate in case the game runs past
///    that (only possible in extra innings, or if a prior series start
///    already ran long). In the ordinary case — nobody's near the cap —
///    this degrades to exactly the old single, open-ended-stint behavior,
///    since a stint's cap only ever matters if the game actually reaches
///    it.
Future<List<PitcherStint>> _resolvePitcherPlan(
  AppDatabase db, {
  required TeamLineup savedRow,
  required Game game,
  required Set<int> availableIds,
  required Set<int> activeAvailableIds,
}) async {
  final savedPitchers = _parseIds(savedRow.pitcherRotation);

  if (game.seriesId != null) {
    final starterId = savedPitchers.firstWhere(
      availableIds.contains,
      orElse: () => activeAvailableIds.isNotEmpty ? activeAvailableIds.first : savedPitchers.first,
    );
    return [PitcherStint(playerId: starterId)];
  }

  final gameInSeries = (game.gameNumber - 1) % 3; // 0/1/2 = game 1/2/3 of the series
  final seriesStartGameNumber = game.gameNumber - gameInSeries;

  final seriesGameIds = (await (db.select(db.games)
            ..where((g) =>
                g.seasonId.equals(game.seasonId) &
                g.seriesId.isNull() &
                g.gameNumber.isBetweenValues(seriesStartGameNumber, game.gameNumber - 1) &
                (g.homeTeamId.equals(savedRow.teamId) | g.awayTeamId.equals(savedRow.teamId))))
          .get())
      .map((g) => g.id)
      .toSet();

  final priorSeriesOuts = <int, int>{};
  if (seriesGameIds.isNotEmpty) {
    for (final row in await (db.select(db.pitchingStats)
          ..where((p) => p.gameId.isIn(seriesGameIds) & p.teamId.equals(savedRow.teamId)))
        .get()) {
      priorSeriesOuts[row.playerId] = (priorSeriesOuts[row.playerId] ?? 0) + row.outsRecorded;
    }
  }
  int remainingBudgetInnings(int playerId) =>
      (_seriesInningsCap * 3 - (priorSeriesOuts[playerId] ?? 0)) ~/ 3;

  final preferredIndex = gameInSeries == 1 && savedPitchers.length > 1 ? 1 : 0;
  final priorityOrder = [
    for (var i = 0; i < savedPitchers.length; i++) savedPitchers[(preferredIndex + i) % savedPitchers.length],
  ];

  final candidates = [
    for (final id in priorityOrder)
      if (availableIds.contains(id)) id,
    for (final id in activeAvailableIds)
      if (!priorityOrder.contains(id)) id,
    for (final id in availableIds)
      if (!priorityOrder.contains(id) && !activeAvailableIds.contains(id)) id,
  ];

  if (candidates.isEmpty) return [PitcherStint(playerId: savedPitchers.first)];

  final primaryId = candidates.firstWhere(
    (id) => remainingBudgetInnings(id) > 0,
    orElse: () => candidates.first,
  );
  final primaryBudget = remainingBudgetInnings(primaryId);
  if (primaryBudget <= 0) {
    // Every candidate is out of series budget (an extreme edge case —
    // e.g. an entire staff already ran deep into extras twice this
    // series) — same "legal, predictably rough" fallback philosophy as
    // the availability fallbacks below: ignore the cap rather than field
    // an empty pitcher plan.
    return [PitcherStint(playerId: primaryId)];
  }

  final fallbackId = candidates.firstWhere((id) => id != primaryId, orElse: () => primaryId);
  if (fallbackId == primaryId) {
    return [PitcherStint(playerId: primaryId)];
  }

  return [
    PitcherStint(playerId: primaryId, throughInning: primaryBudget),
    PitcherStint(playerId: fallbackId),
  ];
}

/// Builds the sim-engine-facing [Lineup] a game should actually be played
/// with, given who's currently unavailable (`gamesUnavailable > 0`) on
/// [savedRow]'s team — a saved lineup may legally name an injured player
/// (see roster_rules.dart), so this is where that gets resolved at game
/// time. Drops unavailable batting-order entries (a shorter, still-legal
/// order), builds the pitcher plan via [_resolvePitcherPlan], and
/// reassigns fielder2/fielder3 from any other available active player if
/// the saved one is out — falling back to whoever's available at all if
/// truly nobody fits (the "legal, predictably rough" scenario
/// context/player-ratings.md already documents for exhausted rotations).
Future<Lineup> resolveEffectiveLineup(AppDatabase db, TeamLineup savedRow, {required Game game}) async {
  final teamPlayers = await (db.select(db.players)..where((p) => p.teamId.equals(savedRow.teamId))).get();
  final availableIds = {for (final p in teamPlayers) if (p.gamesUnavailable == 0) p.id};
  final activeAvailableIds = {
    for (final p in teamPlayers)
      if (p.gamesUnavailable == 0 && p.rosterSlot == RosterSlot.active) p.id,
  };

  final pitcherPlan = await _resolvePitcherPlan(
    db,
    savedRow: savedRow,
    game: game,
    availableIds: availableIds,
    activeAvailableIds: activeAvailableIds,
  );
  final pitcherPlanIds = pitcherPlan.map((s) => s.playerId).toSet();

  final battingOrder = _parseIds(savedRow.battingOrder).where(availableIds.contains).toList();

  // Excludes every pitcher in the plan (not just the game's starter) —
  // with a 2-stint plan the reliever is just as real a mid-game pitcher as
  // the starter and can't also be a constant fielder2/3 for the whole game.
  int resolveFielder(int savedId, Set<int> taken) {
    if (availableIds.contains(savedId) && !pitcherPlanIds.contains(savedId)) return savedId;
    return activeAvailableIds.firstWhere(
      (id) => !pitcherPlanIds.contains(id) && !taken.contains(id),
      orElse: () => activeAvailableIds.isNotEmpty ? activeAvailableIds.first : savedId,
    );
  }

  final fielder2Id = resolveFielder(savedRow.fielder2Id, {});
  final fielder3Id = resolveFielder(savedRow.fielder3Id, {fielder2Id});

  return Lineup(
    teamId: savedRow.teamId,
    battingOrder: battingOrder,
    pitcherPlan: pitcherPlan,
    fielder2Id: fielder2Id,
    fielder3Id: fielder3Id,
  );
}

/// Plays one scheduled game: builds both teams' saved lineups, runs
/// `lib/sim/game_simulator.dart`, persists the final score + box score, and
/// — for regular-season games only (`seriesId == null`) — updates
/// Standings. Playoff games instead have their series win-count updated by
/// `playoffs.simulatePlayoffGame`, which calls this and handles that itself.
Future<sim.GameResult> playGame(AppDatabase db, int gameId, {Random? random}) async {
  final game = await (db.select(db.games)..where((g) => g.id.equals(gameId))).getSingle();
  if (game.status != GameStatus.scheduled) {
    throw StateError('Game $gameId is not scheduled (status: ${game.status}).');
  }

  final homeLineupRow =
      await (db.select(db.teamLineups)..where((l) => l.teamId.equals(game.homeTeamId))).getSingle();
  final awayLineupRow =
      await (db.select(db.teamLineups)..where((l) => l.teamId.equals(game.awayTeamId))).getSingle();

  final players = await loadSimPlayers(db, teamIds: [game.homeTeamId, game.awayTeamId]);

  final result = simulateGame(
    home: await resolveEffectiveLineup(db, homeLineupRow, game: game),
    away: await resolveEffectiveLineup(db, awayLineupRow, game: game),
    players: players,
    random: random,
  );

  await (db.update(db.games)..where((g) => g.id.equals(gameId))).write(
    GamesCompanion(
      status: const Value(GameStatus.completed),
      homeScore: Value(result.homeScore),
      awayScore: Value(result.awayScore),
      inningsPlayed: Value(result.inningsPlayed),
    ),
  );

  await writeBoxScore(db, gameId: gameId, box: result.boxScore);

  await injuries_engine.checkForInjuries(
    db,
    gameId: gameId,
    seasonId: game.seasonId,
    box: result.boxScore,
    random: random,
  );
  await injuries_engine.decrementAvailability(db, teamId: game.homeTeamId);
  await injuries_engine.decrementAvailability(db, teamId: game.awayTeamId);

  // Keeps AI teams' saved lineups resupplied after any injury/DL churn this
  // game caused — no-op for the human-controlled team and for AI teams
  // whose roster didn't change. See lib/ai/team_manager.dart.
  await ai_team_manager.refreshAiLineup(db, teamId: game.homeTeamId);
  await ai_team_manager.refreshAiLineup(db, teamId: game.awayTeamId);

  if (game.seriesId == null) {
    await recordGameResult(
      db,
      seasonId: game.seasonId,
      homeTeamId: game.homeTeamId,
      awayTeamId: game.awayTeamId,
      homeScore: result.homeScore,
      awayScore: result.awayScore,
    );
  }

  return result;
}

/// Plays every still-scheduled regular-season game sharing [dayNumber].
Future<void> simulateDay(AppDatabase db, {required int seasonId, required int dayNumber}) async {
  final scheduled = await (db.select(db.games)
        ..where((g) =>
            g.seasonId.equals(seasonId) &
            g.gameNumber.equals(dayNumber) &
            g.status.equalsValue(GameStatus.scheduled) &
            g.seriesId.isNull()))
      .get();
  for (final g in scheduled) {
    await playGame(db, g.id);
  }
}

/// Plays the rest of the season: remaining regular-season days in order
/// (major and minor share the same day-number range and are simulated
/// together as one league-wide slate per day — see
/// `league_seed.dart`'s `insertSeasonSchedule`), then each tier's playoff
/// bracket (starting it if needed) until both tiers have a champion
/// (Phase 7: majors and minors each run their own independent bracket).
Future<void> simulateRestOfSeason(AppDatabase db, {required int seasonId}) async {
  final remainingDays = await (db.select(db.games)
        ..where((g) =>
            g.seasonId.equals(seasonId) &
            g.status.equalsValue(GameStatus.scheduled) &
            g.seriesId.isNull()))
      .get();
  final days = remainingDays.map((g) => g.gameNumber).toSet().toList()..sort();
  for (final day in days) {
    await simulateDay(db, seasonId: seasonId, dayNumber: day);
  }

  for (final tier in Tier.values) {
    if (await championTeamId(db, seasonId, tier: tier) != null) continue;

    var series = await activePlayoffSeries(db, seasonId, tier: tier);
    if (series.isEmpty) {
      await startPlayoffs(db, seasonId: seasonId, tier: tier);
      series = await activePlayoffSeries(db, seasonId, tier: tier);
    }

    while (series.isNotEmpty) {
      for (final s in series) {
        await simulatePlayoffGame(db, seriesId: s.id);
      }
      series = await activePlayoffSeries(db, seasonId, tier: tier);
    }
  }
}
