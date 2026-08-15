// ignore_for_file: avoid_print
// Manual end-to-end sanity check for Phase 3 (League Structure), extended in
// Phase 7 to cover the mirrored minor tier: seeds a real 12-org league (12
// major + 12 minor teams), plays the entire regular season + both tiers'
// playoffs via simulateRestOfSeason, prints final standings and playoff
// bracket results for both tiers, then rolls over to season 2 and confirms
// it starts clean.
//
// Deliberately outside test/ (like tool/season_sanity_check.dart from
// Phase 1) so it doesn't run as part of the normal suite — this is a
// manual eyeball check, not a regression test. `lib/data/database.dart`
// pulls in Flutter (path_provider), so plain `dart run` can't compile it;
// run via the Flutter test runner instead:
//   flutter test tool/full_season_sanity_check.dart
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:wballmgr/data/database.dart';
import 'package:wballmgr/data/enums.dart';
import 'package:wballmgr/league/game_runner.dart';
import 'package:wballmgr/league/league_seed.dart';
import 'package:wballmgr/league/playoffs.dart';
import 'package:wballmgr/league/season_rollover.dart';
import 'package:wballmgr/league/standings.dart';

void main() {
  test('full season sanity check', () async {
    await _run();
  });
}

Future<void> _run() async {
  final db = AppDatabase.forTesting(NativeDatabase.memory());
  final seasonId = await seedNewLeague(db);
  print('Seeded league, season $seasonId.');

  final stopwatch = Stopwatch()..start();
  await simulateRestOfSeason(db, seasonId: seasonId);
  stopwatch.stop();
  print('Simulated full season + playoffs in ${stopwatch.elapsedMilliseconds}ms.');

  final games = await (db.select(db.games)..where((g) => g.seasonId.equals(seasonId))).get();
  final regular = games.where((g) => g.seriesId == null).toList();
  final playoff = games.where((g) => g.seriesId != null).toList();
  print('Regular season: ${regular.length} games, all completed: '
      '${regular.every((g) => g.status == GameStatus.completed)}');
  print('Playoff games played: ${playoff.length}');

  final teams = await db.select(db.teams).get();
  final teamNames = {for (final t in teams) t.id: t.name};
  final divisions = await db.select(db.divisions).get();
  final standings = await (db.select(db.standings)..where((s) => s.seasonId.equals(seasonId))).get();
  final allSeries = await (db.select(db.playoffSeries)..where((s) => s.seasonId.equals(seasonId))).get();

  for (final tier in Tier.values) {
    print('\n======= ${tier.name.toUpperCase()} =======');

    print('\n=== Final standings ===');
    for (final division in divisions.where((d) => d.tier == tier)) {
      print('-- ${division.name} --');
      final teamIds = teams.where((t) => t.divisionId == division.id).map((t) => t.id).toSet();
      final divStandings = standings.where((s) => teamIds.contains(s.teamId)).toList()..sort(compareStandings);
      for (final s in divStandings) {
        final games = s.w + s.l + s.t;
        final pct = games == 0 ? 0.0 : s.w / games;
        print('${teamNames[s.teamId]!.padRight(18)} W:${s.w} L:${s.l} T:${s.t} '
            'Pct:${pct.toStringAsFixed(3)} PF:${s.pf} PA:${s.pa}');
      }
    }

    print('\n=== Playoff bracket ===');
    for (final s in allSeries.where((s) => s.tier == tier)) {
      final roundLabel = s.round == PlayoffRound.semifinal ? 'Semifinal' : 'Championship';
      print('$roundLabel: #${s.higherSeedRank} ${teamNames[s.higherSeedTeamId]} vs '
          '#${s.lowerSeedRank} ${teamNames[s.lowerSeedTeamId]} -> '
          '${s.higherSeedWins}-${s.lowerSeedWins}, winner: ${teamNames[s.winnerTeamId]}');
    }

    final champion = await championTeamId(db, seasonId, tier: tier);
    print('\nChampion: ${teamNames[champion]}');
  }

  final newSeasonId = await rolloverSeason(db, completedSeasonId: seasonId);
  final newSeason = await (db.select(db.seasons)..where((s) => s.id.equals(newSeasonId))).getSingle();
  final newGames = await (db.select(db.games)..where((g) => g.seasonId.equals(newSeasonId))).get();
  final newStandings = await (db.select(db.standings)..where((s) => s.seasonId.equals(newSeasonId))).get();
  print('\nRolled over to season ${newSeason.number}: ${newGames.length} scheduled games, '
      '${newStandings.length} zeroed standings rows.');

  await db.close();
}
