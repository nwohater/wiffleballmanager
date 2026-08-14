import 'dart:math';

import 'package:drift/drift.dart';

import 'package:wballmgr/career/injuries_engine.dart' as injuries_engine;
import 'package:wballmgr/data/database.dart';
import 'package:wballmgr/data/enums.dart';
import 'package:wballmgr/sim/box_score.dart' as sim;
import 'package:wballmgr/sim/game_simulator.dart';
import 'package:wballmgr/sim/lineup.dart';
import 'package:wballmgr/sim/sim_player.dart';

import 'box_score_writer.dart';
import 'playoffs.dart';
import 'standings.dart';

List<int> _parseIds(String csv) => csv.isEmpty ? [] : csv.split(',').map(int.parse).toList();

/// Builds the sim-engine-facing [Lineup] a game should actually be played
/// with, given who's currently unavailable (`gamesUnavailable > 0`) on
/// [savedRow]'s team — a saved lineup may legally name an injured player
/// (see roster_rules.dart), so this is where that gets resolved at game
/// time. Drops unavailable batting-order entries (a shorter, still-legal
/// order), walks the pitcher rotation for the first available entry, and
/// reassigns fielder2/fielder3 from any other available active player if
/// the saved one is out — falling back to whoever's available at all if
/// truly nobody fits (the "legal, predictably rough" scenario
/// context/player-ratings.md already documents for exhausted rotations).
Future<Lineup> resolveEffectiveLineup(AppDatabase db, TeamLineup savedRow) async {
  final teamPlayers = await (db.select(db.players)..where((p) => p.teamId.equals(savedRow.teamId))).get();
  final availableIds = {for (final p in teamPlayers) if (p.gamesUnavailable == 0) p.id};
  final activeAvailableIds = {
    for (final p in teamPlayers)
      if (p.gamesUnavailable == 0 && p.rosterSlot == RosterSlot.active) p.id,
  };

  final savedPitchers = _parseIds(savedRow.pitcherRotation);
  final starterId = savedPitchers.firstWhere(
    availableIds.contains,
    orElse: () => activeAvailableIds.isNotEmpty ? activeAvailableIds.first : savedPitchers.first,
  );

  final battingOrder = _parseIds(savedRow.battingOrder).where(availableIds.contains).toList();

  int resolveFielder(int savedId, Set<int> taken) {
    if (availableIds.contains(savedId)) return savedId;
    return activeAvailableIds.firstWhere(
      (id) => id != starterId && !taken.contains(id),
      orElse: () => activeAvailableIds.isNotEmpty ? activeAvailableIds.first : savedId,
    );
  }

  final fielder2Id = resolveFielder(savedRow.fielder2Id, {});
  final fielder3Id = resolveFielder(savedRow.fielder3Id, {fielder2Id});

  return Lineup(
    teamId: savedRow.teamId,
    battingOrder: battingOrder,
    pitcherPlan: [PitcherStint(playerId: starterId)],
    fielder2Id: fielder2Id,
    fielder3Id: fielder3Id,
  );
}

/// Reads Players + PlayerPitches for [teamIds] and builds the
/// `Map<int, SimPlayer>` `simulateGame` needs — the missing piece that
/// converts a persisted roster back into the sim engine's plain-Dart shape
/// (the reverse of `lib/roster/roster_writer.dart`'s generation-time write).
Future<Map<int, SimPlayer>> loadSimPlayers(AppDatabase db, {required List<int> teamIds}) async {
  final playerRows = await (db.select(db.players)..where((p) => p.teamId.isIn(teamIds))).get();
  final playerIds = playerRows.map((p) => p.id).toList();

  final pitchRows = playerIds.isEmpty
      ? <PlayerPitche>[]
      : await (db.select(db.playerPitches)..where((pp) => pp.playerId.isIn(playerIds))).get();

  final repertoireByPlayer = <int, List<SimPitch>>{};
  for (final row in pitchRows) {
    repertoireByPlayer
        .putIfAbsent(row.playerId, () => [])
        .add(SimPitch(type: row.pitchType, movement: row.movement));
  }

  return {
    for (final p in playerRows)
      p.id: SimPlayer(
        id: p.id,
        name: '${p.firstName} ${p.lastName}',
        contact: p.contact,
        power: p.power,
        discipline: p.discipline,
        speed: p.speed,
        control: p.control,
        stamina: p.stamina,
        repertoire: repertoireByPlayer[p.id] ?? const [],
        range: p.range,
        hands: p.hands,
        arm: p.arm,
      ),
  };
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
    home: await resolveEffectiveLineup(db, homeLineupRow),
    away: await resolveEffectiveLineup(db, awayLineupRow),
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

/// Plays the rest of the season: remaining regular-season days in order,
/// then the playoff bracket (starting it if needed) until a champion is
/// decided.
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

  if (await championTeamId(db, seasonId) != null) return;

  var series = await activePlayoffSeries(db, seasonId);
  if (series.isEmpty) {
    await startPlayoffs(db, seasonId: seasonId);
    series = await activePlayoffSeries(db, seasonId);
  }

  while (series.isNotEmpty) {
    for (final s in series) {
      await simulatePlayoffGame(db, seriesId: s.id);
    }
    series = await activePlayoffSeries(db, seasonId);
  }
}
