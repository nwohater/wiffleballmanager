import 'package:flutter/material.dart';

import 'package:wballmgr/data/database.dart';
import 'package:wballmgr/data/enums.dart';
import 'package:wballmgr/league/season_rollover.dart';
import 'package:wballmgr/league/standings.dart';

import '../app_scope.dart';

class _StandingsData {
  final int seasonId;
  final int seasonNumber;
  final List<Division> divisions;
  final Map<int, String> teamNames;
  final Map<int, int> teamDivisionId;
  final List<Standing> standings;
  final List<PlayoffSeriesRow> series;
  final int? championTeamId;

  const _StandingsData({
    required this.seasonId,
    required this.seasonNumber,
    required this.divisions,
    required this.teamNames,
    required this.teamDivisionId,
    required this.standings,
    required this.series,
    required this.championTeamId,
  });
}

/// Division standings (sorted by the Pct > PA > PF tiebreaker) plus the
/// playoff bracket once it's started, and a "Start Next Season" action once
/// a champion is decided.
class StandingsScreen extends StatefulWidget {
  const StandingsScreen({super.key});

  @override
  State<StandingsScreen> createState() => _StandingsScreenState();
}

class _StandingsScreenState extends State<StandingsScreen> {
  Future<_StandingsData>? _future;
  bool _busy = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _future ??= _load(AppScope.of(context).db);
  }

  Future<_StandingsData> _load(AppDatabase db) async {
    final season = await (db.select(db.seasons)..where((s) => s.isActive.equals(true))).getSingle();
    final divisions = await (db.select(db.divisions)..where((d) => d.tier.equalsValue(Tier.major))).get();
    final teams = await db.select(db.teams).get();
    final teamNames = {for (final t in teams) t.id: t.name};
    final teamDivisionId = {for (final t in teams) t.id: t.divisionId};
    final standings = await (db.select(db.standings)..where((s) => s.seasonId.equals(season.id))).get();
    final series = await (db.select(db.playoffSeries)..where((s) => s.seasonId.equals(season.id))).get();

    int? championTeamId;
    for (final s in series) {
      if (s.round == PlayoffRound.championship) {
        championTeamId = s.winnerTeamId;
      }
    }

    return _StandingsData(
      seasonId: season.id,
      seasonNumber: season.number,
      divisions: divisions,
      teamNames: teamNames,
      teamDivisionId: teamDivisionId,
      standings: standings,
      series: series,
      championTeamId: championTeamId,
    );
  }

  Future<void> _startNextSeason(_StandingsData data) async {
    setState(() => _busy = true);
    final db = AppScope.of(context).db;
    await rolloverSeason(db, completedSeasonId: data.seasonId);
    if (!mounted) return;
    setState(() {
      _future = _load(db);
      _busy = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_StandingsData>(
      future: _future,
      builder: (context, snapshot) {
        final data = snapshot.data;
        if (data == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Season ${data.seasonNumber}', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            for (final division in data.divisions) _DivisionTable(division: division, data: data),
            if (data.series.isNotEmpty) ...[
              const Divider(height: 32),
              Text('Playoffs', style: Theme.of(context).textTheme.titleLarge),
              for (final s in data.series) _SeriesSummary(series: s, teamNames: data.teamNames),
            ],
            if (data.championTeamId != null) ...[
              const SizedBox(height: 16),
              Text(
                '${data.teamNames[data.championTeamId]} wins the championship!',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              FilledButton(
                onPressed: _busy ? null : () => _startNextSeason(data),
                child: Text(_busy ? 'Starting...' : 'Start Next Season'),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _DivisionTable extends StatelessWidget {
  final Division division;
  final _StandingsData data;

  const _DivisionTable({required this.division, required this.data});

  @override
  Widget build(BuildContext context) {
    final teamStandings = data.standings.where((s) => data.teamDivisionId[s.teamId] == division.id).toList()
      ..sort(compareStandings);

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(division.name, style: Theme.of(context).textTheme.titleMedium),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Team')),
                DataColumn(label: Text('W')),
                DataColumn(label: Text('L')),
                DataColumn(label: Text('T')),
                DataColumn(label: Text('Pct')),
                DataColumn(label: Text('PF')),
                DataColumn(label: Text('PA')),
              ],
              rows: [
                for (final s in teamStandings)
                  DataRow(cells: [
                    DataCell(Text(data.teamNames[s.teamId] ?? 'Unknown')),
                    DataCell(Text('${s.w}')),
                    DataCell(Text('${s.l}')),
                    DataCell(Text('${s.t}')),
                    DataCell(Text(_pct(s).toStringAsFixed(3))),
                    DataCell(Text('${s.pf}')),
                    DataCell(Text('${s.pa}')),
                  ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double _pct(Standing s) {
    final games = s.w + s.l + s.t;
    return games == 0 ? 0 : s.w / games;
  }
}

class _SeriesSummary extends StatelessWidget {
  final PlayoffSeriesRow series;
  final Map<int, String> teamNames;

  const _SeriesSummary({required this.series, required this.teamNames});

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
      dense: true,
      title: Text('$roundLabel: #${series.higherSeedRank} $higher vs #${series.lowerSeedRank} $lower'),
      subtitle: Text(subtitle),
    );
  }
}
