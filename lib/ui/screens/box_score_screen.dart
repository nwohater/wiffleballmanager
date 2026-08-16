import 'package:flutter/material.dart';

import 'package:wballmgr/data/database.dart';
import 'package:wballmgr/data/enums.dart';

import '../app_scope.dart';
import 'player_profile_screen.dart';

class _BoxScoreData {
  final Game game;
  final Team homeTeam;
  final Team awayTeam;
  final Map<int, Player> players;
  final List<BattingStat> batting;
  final List<PitchingStat> pitching;

  const _BoxScoreData({
    required this.game,
    required this.homeTeam,
    required this.awayTeam,
    required this.players,
    required this.batting,
    required this.pitching,
  });
}

/// Full batting/pitching lines for a single completed game, per the
/// Statistics Model — reads directly off BattingStats/PitchingStats rows
/// keyed by gameId, so there's nothing to keep in sync beyond those tables.
class BoxScoreScreen extends StatefulWidget {
  const BoxScoreScreen({super.key, required this.gameId});

  final int gameId;

  @override
  State<BoxScoreScreen> createState() => _BoxScoreScreenState();
}

class _BoxScoreScreenState extends State<BoxScoreScreen> {
  Future<_BoxScoreData>? _future;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _future ??= _load(AppScope.of(context).db);
  }

  Future<_BoxScoreData> _load(AppDatabase db) async {
    final game = await (db.select(db.games)..where((g) => g.id.equals(widget.gameId))).getSingle();
    final homeTeam = await (db.select(db.teams)..where((t) => t.id.equals(game.homeTeamId))).getSingle();
    final awayTeam = await (db.select(db.teams)..where((t) => t.id.equals(game.awayTeamId))).getSingle();
    final batting = await (db.select(db.battingStats)..where((b) => b.gameId.equals(widget.gameId))).get();
    final pitching = await (db.select(db.pitchingStats)..where((p) => p.gameId.equals(widget.gameId))).get();

    final playerIds = {...batting.map((b) => b.playerId), ...pitching.map((p) => p.playerId)};
    final playerRows =
        playerIds.isEmpty ? <Player>[] : await (db.select(db.players)..where((p) => p.id.isIn(playerIds))).get();
    final players = {for (final p in playerRows) p.id: p};

    return _BoxScoreData(
      game: game,
      homeTeam: homeTeam,
      awayTeam: awayTeam,
      players: players,
      batting: batting,
      pitching: pitching,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Box Score')),
      body: FutureBuilder<_BoxScoreData>(
        future: _future,
        builder: (context, snapshot) {
          final data = snapshot.data;
          if (data == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final awayBatting = data.batting.where((b) => b.teamId == data.awayTeam.id).toList()
            ..sort((a, b) => a.playerId.compareTo(b.playerId));
          final homeBatting = data.batting.where((b) => b.teamId == data.homeTeam.id).toList()
            ..sort((a, b) => a.playerId.compareTo(b.playerId));
          final awayPitching = data.pitching.where((p) => p.teamId == data.awayTeam.id).toList()
            ..sort((a, b) => a.playerId.compareTo(b.playerId));
          final homePitching = data.pitching.where((p) => p.teamId == data.homeTeam.id).toList()
            ..sort((a, b) => a.playerId.compareTo(b.playerId));

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _ScoreHeader(game: data.game, homeTeam: data.homeTeam, awayTeam: data.awayTeam),
              const Divider(height: 32),
              Text('${data.awayTeam.name} Batting', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              _BattingTable(stats: awayBatting, players: data.players),
              const SizedBox(height: 24),
              Text('${data.homeTeam.name} Batting', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              _BattingTable(stats: homeBatting, players: data.players),
              const Divider(height: 32),
              Text('${data.awayTeam.name} Pitching', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              _PitchingTable(stats: awayPitching, players: data.players),
              const SizedBox(height: 24),
              Text('${data.homeTeam.name} Pitching', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              _PitchingTable(stats: homePitching, players: data.players),
            ],
          );
        },
      ),
    );
  }
}

class _ScoreHeader extends StatelessWidget {
  const _ScoreHeader({required this.game, required this.homeTeam, required this.awayTeam});

  final Game game;
  final Team homeTeam;
  final Team awayTeam;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                awayTeam.name,
                textAlign: TextAlign.right,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '${game.awayScore} - ${game.homeScore}',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            Expanded(
              child: Text(homeTeam.name, style: Theme.of(context).textTheme.titleLarge),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          '${game.tier == Tier.major ? 'MLB' : 'AAA'} · ${game.inningsPlayed} innings',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _BattingTable extends StatelessWidget {
  const _BattingTable({required this.stats, required this.players});

  final List<BattingStat> stats;
  final Map<int, Player> players;

  @override
  Widget build(BuildContext context) {
    if (stats.isEmpty) {
      return const Text('No batters recorded.');
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 20,
        columns: const [
          DataColumn(label: Text('Player')),
          DataColumn(label: Text('AB'), numeric: true),
          DataColumn(label: Text('R'), numeric: true),
          DataColumn(label: Text('H'), numeric: true),
          DataColumn(label: Text('2B'), numeric: true),
          DataColumn(label: Text('3B'), numeric: true),
          DataColumn(label: Text('HR'), numeric: true),
          DataColumn(label: Text('RBI'), numeric: true),
          DataColumn(label: Text('BB'), numeric: true),
          DataColumn(label: Text('K'), numeric: true),
        ],
        rows: [
          for (final b in stats)
            DataRow(cells: [
              DataCell(Text(_playerName(players, b.playerId)), onTap: () => _openProfile(context, b.playerId)),
              DataCell(Text('${b.ab}')),
              DataCell(Text('${b.r}')),
              DataCell(Text('${b.h}')),
              DataCell(Text('${b.doubles}')),
              DataCell(Text('${b.triples}')),
              DataCell(Text('${b.hr}')),
              DataCell(Text('${b.rbi}')),
              DataCell(Text('${b.bb}')),
              DataCell(Text('${b.k}')),
            ]),
        ],
      ),
    );
  }
}

class _PitchingTable extends StatelessWidget {
  const _PitchingTable({required this.stats, required this.players});

  final List<PitchingStat> stats;
  final Map<int, Player> players;

  @override
  Widget build(BuildContext context) {
    if (stats.isEmpty) {
      return const Text('No pitchers recorded.');
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 20,
        columns: const [
          DataColumn(label: Text('Player')),
          DataColumn(label: Text('IP'), numeric: true),
          DataColumn(label: Text('H'), numeric: true),
          DataColumn(label: Text('R'), numeric: true),
          DataColumn(label: Text('ER'), numeric: true),
          DataColumn(label: Text('BB'), numeric: true),
          DataColumn(label: Text('K'), numeric: true),
          DataColumn(label: Text('Dec')),
        ],
        rows: [
          for (final p in stats)
            DataRow(cells: [
              DataCell(Text(_playerName(players, p.playerId)), onTap: () => _openProfile(context, p.playerId)),
              DataCell(Text(_formatIp(p.outsRecorded))),
              DataCell(Text('${p.h}')),
              DataCell(Text('${p.r}')),
              DataCell(Text('${p.er}')),
              DataCell(Text('${p.bb}')),
              DataCell(Text('${p.k}')),
              DataCell(Text(_decision(p))),
            ]),
        ],
      ),
    );
  }

  String _decision(PitchingStat p) {
    if (p.w == 1) return 'W';
    if (p.l == 1) return 'L';
    if (p.s == 1) return 'S';
    return '';
  }
}

String _playerName(Map<int, Player> players, int playerId) {
  final p = players[playerId];
  return p == null ? 'Unknown' : '${p.firstName} ${p.lastName}';
}

void _openProfile(BuildContext context, int playerId) {
  Navigator.of(context).push(MaterialPageRoute(builder: (_) => PlayerProfileScreen(playerId: playerId)));
}

String _formatIp(int outsRecorded) {
  final innings = outsRecorded ~/ 3;
  final remainder = outsRecorded % 3;
  return '$innings.$remainder';
}
