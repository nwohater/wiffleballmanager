import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';

import 'package:wballmgr/data/database.dart';
import 'package:wballmgr/data/enums.dart';
import 'package:wballmgr/league/standings.dart';

import '../app_scope.dart';

class _TeamSummary {
  final Team team;
  final String divisionName;
  final int divisionRank;
  final int divisionSize;
  final Standing standing;
  final Game? nextGame;
  final String? opponentName;
  final bool nextGameIsHome;

  const _TeamSummary({
    required this.team,
    required this.divisionName,
    required this.divisionRank,
    required this.divisionSize,
    required this.standing,
    required this.nextGame,
    required this.opponentName,
    required this.nextGameIsHome,
  });
}

class _HomeData {
  final int seasonNumber;
  final _TeamSummary? major;
  final _TeamSummary? minor;

  const _HomeData({required this.seasonNumber, required this.major, required this.minor});
}

/// Dashboard for the player's org: each tier's team record, division rank,
/// and next scheduled game — a quick "where do things stand" landing page,
/// per Phase 8's "Team home / roster screen" bullet (roster editing itself
/// already lives on the Roster tab).
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<_HomeData?>? _future;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _future ??= _load(AppScope.of(context).db);
  }

  Future<_HomeData?> _load(AppDatabase db) async {
    final org = await (db.select(db.organizations)..where((o) => o.isPlayerControlled.equals(true)))
        .getSingleOrNull();
    if (org == null) return null;

    final season = await (db.select(db.seasons)..where((s) => s.isActive.equals(true))).getSingle();
    final divisions = await db.select(db.divisions).get();
    final divisionById = {for (final d in divisions) d.id: d};
    final allTeams = await db.select(db.teams).get();
    final standings = await (db.select(db.standings)..where((s) => s.seasonId.equals(season.id))).get();
    final standingByTeamId = {for (final s in standings) s.teamId: s};
    final orgTeams = allTeams.where((t) => t.organizationId == org.id).toList();

    Future<_TeamSummary?> summarize(Tier tier) async {
      Team? team;
      for (final t in orgTeams) {
        if (divisionById[t.divisionId]?.tier == tier) team = t;
      }
      if (team == null) return null;
      final resolvedTeam = team;
      final standing = standingByTeamId[resolvedTeam.id];
      if (standing == null) return null;

      final divisionTeams = allTeams.where((t) => t.divisionId == resolvedTeam.divisionId).map((t) => t.id).toSet();
      final divisionStandings = standings.where((s) => divisionTeams.contains(s.teamId)).toList()
        ..sort(compareStandings);
      final rank = divisionStandings.indexWhere((s) => s.teamId == resolvedTeam.id) + 1;

      final nextGame = await (db.select(db.games)
            ..where((g) =>
                g.seasonId.equals(season.id) &
                g.status.equalsValue(GameStatus.scheduled) &
                (g.homeTeamId.equals(resolvedTeam.id) | g.awayTeamId.equals(resolvedTeam.id)))
            ..orderBy([(g) => OrderingTerm(expression: g.gameNumber)])
            ..limit(1))
          .getSingleOrNull();

      String? opponentName;
      bool nextGameIsHome = false;
      if (nextGame != null) {
        nextGameIsHome = nextGame.homeTeamId == resolvedTeam.id;
        final opponentId = nextGameIsHome ? nextGame.awayTeamId : nextGame.homeTeamId;
        opponentName = allTeams.firstWhere((t) => t.id == opponentId).name;
      }

      return _TeamSummary(
        team: resolvedTeam,
        divisionName: divisionById[resolvedTeam.divisionId]?.name ?? 'Unknown',
        divisionRank: rank,
        divisionSize: divisionStandings.length,
        standing: standing,
        nextGame: nextGame,
        opponentName: opponentName,
        nextGameIsHome: nextGameIsHome,
      );
    }

    return _HomeData(
      seasonNumber: season.number,
      major: await summarize(Tier.major),
      minor: await summarize(Tier.minor),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_HomeData?>(
      future: _future,
      builder: (context, snapshot) {
        if (!snapshot.hasData && snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        final data = snapshot.data;
        if (data == null) {
          return const Center(child: Text('No team yet.'));
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Season ${data.seasonNumber}', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            if (data.major != null) _TeamCard(summary: data.major!, tierLabel: 'Major League'),
            if (data.major != null) const SizedBox(height: 16),
            if (data.minor != null) _TeamCard(summary: data.minor!, tierLabel: 'Minor League'),
          ],
        );
      },
    );
  }
}

class _TeamCard extends StatelessWidget {
  final _TeamSummary summary;
  final String tierLabel;

  const _TeamCard({required this.summary, required this.tierLabel});

  @override
  Widget build(BuildContext context) {
    final s = summary.standing;
    final games = s.w + s.l + s.t;
    final pct = games == 0 ? 0.0 : s.w / games;
    final nextGame = summary.nextGame;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(tierLabel, style: Theme.of(context).textTheme.labelMedium),
            Text(summary.team.name, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('${s.w}-${s.l}-${s.t}  (${pct.toStringAsFixed(3)})'),
            Text('${_ordinal(summary.divisionRank)} in ${summary.divisionName} (${summary.divisionSize} teams)'),
            const SizedBox(height: 8),
            Text(
              nextGame == null
                  ? 'No games remaining this season.'
                  : 'Next: ${summary.nextGameIsHome ? 'vs' : '@'} ${summary.opponentName} '
                      '(${nextGame.seriesId != null ? 'Playoffs' : 'Day ${nextGame.gameNumber}'})',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  String _ordinal(int n) {
    if (n % 100 >= 11 && n % 100 <= 13) return '${n}th';
    switch (n % 10) {
      case 1:
        return '${n}st';
      case 2:
        return '${n}nd';
      case 3:
        return '${n}rd';
      default:
        return '${n}th';
    }
  }
}
