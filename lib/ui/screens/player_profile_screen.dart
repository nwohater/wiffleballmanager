import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';

import 'package:wballmgr/data/database.dart';
import 'package:wballmgr/data/enums.dart';

import '../app_scope.dart';

class _BattingTotals {
  int pa = 0, ab = 0, r = 0, h = 0, doubles = 0, triples = 0, hr = 0, rbi = 0, bb = 0, k = 0, sb = 0;

  double get avg => ab == 0 ? 0 : h / ab;
  double get obp {
    final denom = ab + bb;
    return denom == 0 ? 0 : (h + bb) / denom;
  }

  double get slg => ab == 0 ? 0 : (h + doubles + 2 * triples + 3 * hr) / ab;
  double get ops => obp + slg;
}

class _PitchingTotals {
  int outsRecorded = 0, h = 0, r = 0, er = 0, bb = 0, k = 0, w = 0, l = 0, s = 0;

  double get innings => outsRecorded / 3;
  double get era => outsRecorded == 0 ? 0 : (er * 3) / innings;
  double get whip => outsRecorded == 0 ? 0 : (bb + h) / innings;
}

class _FieldingTotals {
  int tc = 0, po = 0, a = 0, e = 0;

  double get fpct => tc == 0 ? 1 : (tc - e) / tc;
}

class _ProfileData {
  final Player player;
  final String? teamName;
  final int seasonNumber;
  final _BattingTotals batting;
  final _PitchingTotals pitching;
  final _FieldingTotals fielding;

  const _ProfileData({
    required this.player,
    required this.teamName,
    required this.seasonNumber,
    required this.batting,
    required this.pitching,
    required this.fielding,
  });
}

/// A single player's current-season observed stats — batting/pitching/
/// fielding counting stats and derived rates, summed directly from
/// BattingStats/PitchingStats/FieldingStats. Deliberately never surfaces
/// any of the Players row's true-rating columns (Contact/Power/Control/
/// etc.), per the Hidden Ratings model.
class PlayerProfileScreen extends StatefulWidget {
  const PlayerProfileScreen({super.key, required this.playerId});

  final int playerId;

  @override
  State<PlayerProfileScreen> createState() => _PlayerProfileScreenState();
}

class _PlayerProfileScreenState extends State<PlayerProfileScreen> {
  Future<_ProfileData>? _future;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _future ??= _load(AppScope.of(context).db);
  }

  Future<_ProfileData> _load(AppDatabase db) async {
    final player = await (db.select(db.players)..where((p) => p.id.equals(widget.playerId))).getSingle();

    String? teamName;
    if (player.teamId != null) {
      final team = await (db.select(db.teams)..where((t) => t.id.equals(player.teamId!))).getSingleOrNull();
      teamName = team?.name;
    }

    final season = await (db.select(db.seasons)..where((s) => s.isActive.equals(true))).getSingle();
    final gameIds =
        (await (db.select(db.games)..where((g) => g.seasonId.equals(season.id))).get()).map((g) => g.id).toSet();

    final batting = _BattingTotals();
    final pitching = _PitchingTotals();
    final fielding = _FieldingTotals();

    if (gameIds.isNotEmpty) {
      for (final row in await (db.select(db.battingStats)
            ..where((b) => b.playerId.equals(widget.playerId) & b.gameId.isIn(gameIds)))
          .get()) {
        batting
          ..pa += row.pa
          ..ab += row.ab
          ..r += row.r
          ..h += row.h
          ..doubles += row.doubles
          ..triples += row.triples
          ..hr += row.hr
          ..rbi += row.rbi
          ..bb += row.bb
          ..k += row.k
          ..sb += row.sb;
      }
      for (final row in await (db.select(db.pitchingStats)
            ..where((p) => p.playerId.equals(widget.playerId) & p.gameId.isIn(gameIds)))
          .get()) {
        pitching
          ..outsRecorded += row.outsRecorded
          ..h += row.h
          ..r += row.r
          ..er += row.er
          ..bb += row.bb
          ..k += row.k
          ..w += row.w
          ..l += row.l
          ..s += row.s;
      }
      for (final row in await (db.select(db.fieldingStats)
            ..where((f) => f.playerId.equals(widget.playerId) & f.gameId.isIn(gameIds)))
          .get()) {
        fielding
          ..tc += row.tc
          ..po += row.po
          ..a += row.a
          ..e += row.e;
      }
    }

    return _ProfileData(
      player: player,
      teamName: teamName,
      seasonNumber: season.number,
      batting: batting,
      pitching: pitching,
      fielding: fielding,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Player Profile')),
      body: FutureBuilder<_ProfileData>(
        future: _future,
        builder: (context, snapshot) {
          final data = snapshot.data;
          if (data == null) {
            return const Center(child: CircularProgressIndicator());
          }
          final p = data.player;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text('${p.firstName} ${p.lastName}', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 4),
              Text(
                [
                  'Age ${p.age}',
                  if (data.teamName != null) data.teamName!,
                  if (p.rosterSlot == RosterSlot.dl) 'DL (${p.gamesUnavailable} games left)',
                ].join(' · '),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Text('Season ${data.seasonNumber} stats', style: Theme.of(context).textTheme.labelMedium),
              const Divider(height: 24),
              if (data.batting.pa > 0) ...[
                Text('Batting', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                _StatGrid(stats: {
                  'PA': '${data.batting.pa}',
                  'AB': '${data.batting.ab}',
                  'R': '${data.batting.r}',
                  'H': '${data.batting.h}',
                  '2B': '${data.batting.doubles}',
                  '3B': '${data.batting.triples}',
                  'HR': '${data.batting.hr}',
                  'RBI': '${data.batting.rbi}',
                  'BB': '${data.batting.bb}',
                  'K': '${data.batting.k}',
                  'SB': '${data.batting.sb}',
                  'AVG': data.batting.avg.toStringAsFixed(3),
                  'OBP': data.batting.obp.toStringAsFixed(3),
                  'SLG': data.batting.slg.toStringAsFixed(3),
                  'OPS': data.batting.ops.toStringAsFixed(3),
                }),
                const SizedBox(height: 24),
              ],
              if (data.pitching.outsRecorded > 0) ...[
                Text('Pitching', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                _StatGrid(stats: {
                  'IP': data.pitching.innings.toStringAsFixed(1),
                  'H': '${data.pitching.h}',
                  'R': '${data.pitching.r}',
                  'ER': '${data.pitching.er}',
                  'BB': '${data.pitching.bb}',
                  'K': '${data.pitching.k}',
                  'W': '${data.pitching.w}',
                  'L': '${data.pitching.l}',
                  'S': '${data.pitching.s}',
                  'ERA': data.pitching.era.toStringAsFixed(2),
                  'WHIP': data.pitching.whip.toStringAsFixed(2),
                }),
                const SizedBox(height: 24),
              ],
              if (data.fielding.tc > 0) ...[
                Text('Fielding', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                _StatGrid(stats: {
                  'TC': '${data.fielding.tc}',
                  'PO': '${data.fielding.po}',
                  'A': '${data.fielding.a}',
                  'E': '${data.fielding.e}',
                  'FPCT': data.fielding.fpct.toStringAsFixed(3),
                }),
              ],
              if (data.batting.pa == 0 && data.pitching.outsRecorded == 0 && data.fielding.tc == 0)
                const Text('No stats recorded yet this season.'),
            ],
          );
        },
      ),
    );
  }
}

class _StatGrid extends StatelessWidget {
  const _StatGrid({required this.stats});

  final Map<String, String> stats;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 20,
      runSpacing: 12,
      children: [
        for (final entry in stats.entries)
          SizedBox(
            width: 56,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.key, style: Theme.of(context).textTheme.labelSmall),
                Text(entry.value, style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
          ),
      ],
    );
  }
}
