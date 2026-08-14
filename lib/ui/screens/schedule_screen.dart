import 'package:drift/drift.dart' show OrderingTerm;
import 'package:flutter/material.dart';

import 'package:wballmgr/data/database.dart';
import 'package:wballmgr/data/enums.dart';
import 'package:wballmgr/league/game_runner.dart';
import 'package:wballmgr/league/playoffs.dart';

import '../app_scope.dart';

class _ScheduleData {
  final int seasonId;
  final Map<int, String> teamNames;
  final List<Game> games;
  final List<PlayoffSeriesRow> series;

  const _ScheduleData({
    required this.seasonId,
    required this.teamNames,
    required this.games,
    required this.series,
  });
}

/// The active season's schedule: regular-season games grouped by day (every
/// team plays at most once per day, per schedule.dart's design), plus a
/// Playoffs section once the bracket starts. Three simulate granularities:
/// a single game, a whole day, or the rest of the season.
class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  Future<_ScheduleData>? _future;
  bool _busy = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _future ??= _load(AppScope.of(context).db);
  }

  Future<_ScheduleData> _load(AppDatabase db) async {
    final season = await (db.select(db.seasons)..where((s) => s.isActive.equals(true))).getSingle();
    final teams = await db.select(db.teams).get();
    final teamNames = {for (final t in teams) t.id: t.name};
    final games = await (db.select(db.games)
          ..where((g) => g.seasonId.equals(season.id))
          ..orderBy([
            (g) => OrderingTerm(expression: g.gameNumber),
            (g) => OrderingTerm(expression: g.id),
          ]))
        .get();
    final series = await (db.select(db.playoffSeries)..where((s) => s.seasonId.equals(season.id))).get();
    return _ScheduleData(seasonId: season.id, teamNames: teamNames, games: games, series: series);
  }

  Future<void> _run(Future<void> Function() action) async {
    setState(() => _busy = true);
    await action();
    if (!mounted) return;
    setState(() {
      _future = _load(AppScope.of(context).db);
      _busy = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_ScheduleData>(
      future: _future,
      builder: (context, snapshot) {
        final data = snapshot.data;
        if (data == null) {
          return const Center(child: CircularProgressIndicator());
        }
        final db = AppScope.of(context).db;

        final regularGames = data.games.where((g) => g.seriesId == null).toList();
        final byDay = <int, List<Game>>{};
        for (final g in regularGames) {
          byDay.putIfAbsent(g.gameNumber, () => []).add(g);
        }
        final days = byDay.keys.toList()..sort();

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: FilledButton(
                onPressed: _busy ? null : () => _run(() => simulateRestOfSeason(db, seasonId: data.seasonId)),
                child: Text(_busy ? 'Simulating...' : 'Simulate Rest of Season'),
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  for (final day in days) ...[
                    _DayHeader(
                      day: day,
                      hasScheduled: byDay[day]!.any((g) => g.status == GameStatus.scheduled),
                      busy: _busy,
                      onSimulate: () => _run(() => simulateDay(db, seasonId: data.seasonId, dayNumber: day)),
                    ),
                    for (final g in byDay[day]!)
                      _GameTile(
                        game: g,
                        teamNames: data.teamNames,
                        busy: _busy,
                        onSimulate: () => _run(() async {
                          await playGame(db, g.id);
                        }),
                      ),
                  ],
                  if (data.series.isNotEmpty) ...[
                    const Divider(height: 32),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text('Playoffs', style: Theme.of(context).textTheme.titleLarge),
                    ),
                    for (final s in data.series)
                      _SeriesTile(
                        series: s,
                        teamNames: data.teamNames,
                        busy: _busy,
                        onSimulate: () => _run(() => simulatePlayoffGame(db, seriesId: s.id)),
                      ),
                  ],
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _DayHeader extends StatelessWidget {
  final int day;
  final bool hasScheduled;
  final bool busy;
  final VoidCallback onSimulate;

  const _DayHeader({
    required this.day,
    required this.hasScheduled,
    required this.busy,
    required this.onSimulate,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      title: Text('Day $day', style: Theme.of(context).textTheme.titleSmall),
      trailing: hasScheduled
          ? TextButton(onPressed: busy ? null : onSimulate, child: const Text('Simulate Day'))
          : null,
    );
  }
}

class _GameTile extends StatelessWidget {
  final Game game;
  final Map<int, String> teamNames;
  final bool busy;
  final VoidCallback onSimulate;

  const _GameTile({
    required this.game,
    required this.teamNames,
    required this.busy,
    required this.onSimulate,
  });

  @override
  Widget build(BuildContext context) {
    final away = teamNames[game.awayTeamId] ?? 'Unknown';
    final home = teamNames[game.homeTeamId] ?? 'Unknown';
    final isDone = game.status == GameStatus.completed;
    return ListTile(
      dense: true,
      title: Text('$away @ $home'),
      trailing: isDone
          ? Text('${game.awayScore}-${game.homeScore}')
          : TextButton(onPressed: busy ? null : onSimulate, child: const Text('Simulate')),
    );
  }
}

class _SeriesTile extends StatelessWidget {
  final PlayoffSeriesRow series;
  final Map<int, String> teamNames;
  final bool busy;
  final VoidCallback onSimulate;

  const _SeriesTile({
    required this.series,
    required this.teamNames,
    required this.busy,
    required this.onSimulate,
  });

  @override
  Widget build(BuildContext context) {
    final higher = teamNames[series.higherSeedTeamId] ?? 'Unknown';
    final lower = teamNames[series.lowerSeedTeamId] ?? 'Unknown';
    final roundLabel = series.round == PlayoffRound.semifinal ? 'Semifinal' : 'Championship';
    final decided = series.winnerTeamId != null;
    final subtitle = decided
        ? '${series.higherSeedWins}-${series.lowerSeedWins} — ${teamNames[series.winnerTeamId]} wins'
        : '${series.higherSeedWins}-${series.lowerSeedWins}';
    return ListTile(
      title: Text('$roundLabel: #${series.higherSeedRank} $higher vs #${series.lowerSeedRank} $lower'),
      subtitle: Text(subtitle),
      trailing:
          decided ? null : TextButton(onPressed: busy ? null : onSimulate, child: const Text('Simulate Next Game')),
    );
  }
}
