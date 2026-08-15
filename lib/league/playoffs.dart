import 'package:drift/drift.dart';

import 'package:wballmgr/data/database.dart';
import 'package:wballmgr/data/enums.dart';

import 'game_runner.dart';
import 'standings.dart';

/// Picks the 4 playoff seeds from already-fetched standings + team→division
/// data (pure — no drift dependency, testable with synthetic rows): each
/// division's leader takes seeds 1-3 (ordered by [compareStandings]), and
/// the single best remaining team league-wide is seed 4 (the wildcard).
List<int> seedsFromStandings(List<Standing> standings, Map<int, int> teamDivisionId) {
  final byDivision = <int, List<Standing>>{};
  for (final s in standings) {
    final divisionId = teamDivisionId[s.teamId];
    if (divisionId == null) continue;
    byDivision.putIfAbsent(divisionId, () => []).add(s);
  }

  final leaders = <Standing>[];
  final nonLeaders = <Standing>[];
  for (final teams in byDivision.values) {
    final sorted = List<Standing>.of(teams)..sort(compareStandings);
    leaders.add(sorted.first);
    nonLeaders.addAll(sorted.skip(1));
  }
  leaders.sort(compareStandings);
  nonLeaders.sort(compareStandings);

  return [...leaders.map((s) => s.teamId), nonLeaders.first.teamId];
}

/// Drift-coupled wrapper around [seedsFromStandings]: fetches [tier]'s
/// standings and division data for the season, returns 4 team ids seeded
/// 1-4. Filtering to [tier] (Phase 7) is essential, not cosmetic — major and
/// minor divisions live in the same `Divisions`/`Standings` tables, so an
/// unfiltered query would mix both tiers' teams into one bogus bracket.
Future<List<int>> determinePlayoffSeeds(AppDatabase db, {required int seasonId, required Tier tier}) async {
  final divisionRows = await (db.select(db.divisions)..where((d) => d.tier.equalsValue(tier))).get();
  final divisionIds = divisionRows.map((d) => d.id).toSet();
  final teamRows = await (db.select(db.teams)..where((t) => t.divisionId.isIn(divisionIds))).get();
  final teamIds = teamRows.map((t) => t.id).toSet();
  final standingsRows = await (db.select(db.standings)
        ..where((s) => s.seasonId.equals(seasonId) & s.teamId.isIn(teamIds)))
      .get();
  final teamDivisionId = {for (final t in teamRows) t.id: t.divisionId};
  return seedsFromStandings(standingsRows, teamDivisionId);
}

/// Creates [tier]'s two semifinal series (seed1 v seed4, seed2 v seed3,
/// best-of-5) from the season's final regular-season standings. Major and
/// minor tiers each get their own independent bracket (Phase 7).
Future<void> startPlayoffs(AppDatabase db, {required int seasonId, required Tier tier}) async {
  final seeds = await determinePlayoffSeeds(db, seasonId: seasonId, tier: tier);
  await db.into(db.playoffSeries).insert(PlayoffSeriesCompanion.insert(
        seasonId: seasonId,
        tier: Value(tier),
        round: PlayoffRound.semifinal,
        higherSeedTeamId: seeds[0],
        higherSeedRank: 1,
        lowerSeedTeamId: seeds[3],
        lowerSeedRank: 4,
        bestOf: 5,
      ));
  await db.into(db.playoffSeries).insert(PlayoffSeriesCompanion.insert(
        seasonId: seasonId,
        tier: Value(tier),
        round: PlayoffRound.semifinal,
        higherSeedTeamId: seeds[1],
        higherSeedRank: 2,
        lowerSeedTeamId: seeds[2],
        lowerSeedRank: 3,
        bestOf: 5,
      ));
}

/// [tier]'s series without a winner decided yet, for the given season.
Future<List<PlayoffSeriesRow>> activePlayoffSeries(AppDatabase db, int seasonId, {required Tier tier}) {
  return (db.select(db.playoffSeries)
        ..where((s) => s.seasonId.equals(seasonId) & s.tier.equalsValue(tier) & s.winnerTeamId.isNull()))
      .get();
}

Future<int> _nextGameNumber(AppDatabase db, int seasonId) async {
  final maxColumn = db.games.gameNumber.max();
  final query = db.selectOnly(db.games)
    ..addColumns([maxColumn])
    ..where(db.games.seasonId.equals(seasonId));
  final row = await query.getSingle();
  return (row.read(maxColumn) ?? 0) + 1;
}

/// Plays one game in the series (higher seed always hosts — see
/// `playoff_series.dart`'s doc comment), updates the series' win counts,
/// decides the series at the clinch threshold (ceil(bestOf/2)), and starts
/// the championship once both semifinals are decided.
Future<void> simulatePlayoffGame(AppDatabase db, {required int seriesId}) async {
  final series = await (db.select(db.playoffSeries)..where((s) => s.id.equals(seriesId))).getSingle();
  if (series.winnerTeamId != null) {
    throw StateError('Playoff series $seriesId is already decided.');
  }

  final gameId = await db.into(db.games).insert(GamesCompanion.insert(
        seasonId: series.seasonId,
        tier: series.tier,
        homeTeamId: series.higherSeedTeamId,
        awayTeamId: series.lowerSeedTeamId,
        gameNumber: await _nextGameNumber(db, series.seasonId),
        seriesId: Value(seriesId),
      ));

  final result = await playGame(db, gameId);
  final higherSeedWon = result.homeScore > result.awayScore;

  final higherSeedWins = series.higherSeedWins + (higherSeedWon ? 1 : 0);
  final lowerSeedWins = series.lowerSeedWins + (higherSeedWon ? 0 : 1);
  final clinchAt = (series.bestOf / 2).ceil();
  final winnerTeamId = higherSeedWins >= clinchAt
      ? series.higherSeedTeamId
      : (lowerSeedWins >= clinchAt ? series.lowerSeedTeamId : null);

  await (db.update(db.playoffSeries)..where((s) => s.id.equals(seriesId))).write(
    PlayoffSeriesCompanion(
      higherSeedWins: Value(higherSeedWins),
      lowerSeedWins: Value(lowerSeedWins),
      winnerTeamId: Value(winnerTeamId),
    ),
  );

  if (winnerTeamId != null) {
    await _maybeStartChampionship(db, series.seasonId, series.tier);
  }
}

/// Once both of [tier]'s semifinals are decided, creates its championship
/// series (best-of-7). The finalist with the better *original* seed rank
/// hosts — not necessarily the winner of the 1v4 bracket half, since a
/// semifinal upset can leave a worse-ranked team standing on that side.
Future<void> _maybeStartChampionship(AppDatabase db, int seasonId, Tier tier) async {
  final allSeries = await (db.select(db.playoffSeries)
        ..where((s) => s.seasonId.equals(seasonId) & s.tier.equalsValue(tier)))
      .get();
  final semifinals = allSeries.where((s) => s.round == PlayoffRound.semifinal).toList();
  if (semifinals.length != 2 || semifinals.any((s) => s.winnerTeamId == null)) return;
  if (allSeries.any((s) => s.round == PlayoffRound.championship)) return;

  final finalists = [
    for (final s in semifinals)
      s.winnerTeamId == s.higherSeedTeamId
          ? (teamId: s.higherSeedTeamId, rank: s.higherSeedRank)
          : (teamId: s.lowerSeedTeamId, rank: s.lowerSeedRank),
  ]..sort((a, b) => a.rank.compareTo(b.rank));

  await db.into(db.playoffSeries).insert(PlayoffSeriesCompanion.insert(
        seasonId: seasonId,
        tier: Value(tier),
        round: PlayoffRound.championship,
        higherSeedTeamId: finalists[0].teamId,
        higherSeedRank: finalists[0].rank,
        lowerSeedTeamId: finalists[1].teamId,
        lowerSeedRank: finalists[1].rank,
        bestOf: 7,
      ));
}

/// The champion of [seasonId]'s [tier] playoffs, or null if that tier's
/// championship series hasn't been decided (or started) yet.
Future<int?> championTeamId(AppDatabase db, int seasonId, {required Tier tier}) async {
  final championship = await (db.select(db.playoffSeries)
        ..where((s) =>
            s.seasonId.equals(seasonId) &
            s.tier.equalsValue(tier) &
            s.round.equalsValue(PlayoffRound.championship)))
      .getSingleOrNull();
  return championship?.winnerTeamId;
}
