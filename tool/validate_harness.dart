// ignore_for_file: avoid_print
// Phase 1's validation harness (todo/initial-build.md): simulates a large
// number of games between two league-average synthetic rosters and
// reports aggregate rates against rules-mlw-cultz-field.md's Statistical
// Calibration targets. Run with: dart run tool/validate_harness.dart
import 'dart:math';

import 'package:wballmgr/sim/game_simulator.dart';

import '../test/sim/harness.dart';

void main() {
  const games = 5000;
  final rng = Random(1234);
  final home = buildSyntheticTeam(1, 1);
  final away = buildSyntheticTeam(2, 100);
  final players = {for (final p in [...home.players, ...away.players]) p.id: p};

  var pa = 0, bb = 0, k = 0, h = 0, doubles = 0, triples = 0, hr = 0;
  var teamGames = 0, runsTotal = 0, walksTotal = 0, ksTotal = 0, hitsTotal = 0;

  for (var i = 0; i < games; i++) {
    final result = simulateGame(home: home.lineup, away: away.lineup, players: players, random: rng);

    for (final side in [
      (result.boxScore.batting.values.where((l) => l.teamId == home.teamId), result.homeScore),
      (result.boxScore.batting.values.where((l) => l.teamId == away.teamId), result.awayScore),
    ]) {
      teamGames++;
      runsTotal += side.$2;
      var teamBB = 0, teamK = 0, teamH = 0;
      for (final line in side.$1) {
        pa += line.pa;
        bb += line.bb;
        k += line.k;
        h += line.h;
        doubles += line.doubles;
        triples += line.triples;
        hr += line.hr;
        teamBB += line.bb;
        teamK += line.k;
        teamH += line.h;
      }
      walksTotal += teamBB;
      ksTotal += teamK;
      hitsTotal += teamH;
    }
  }

  final bbRate = bb / pa;
  final kRate = k / pa;
  final hitRate = h / pa;
  final xbhRate = (doubles + triples + hr) / pa;
  final hrRate = hr / pa;
  final bipRate = 1 - bbRate - kRate;

  print('Games simulated: $games ($teamGames team-games)');
  print('Total PA: $pa');
  print('');
  print('Rate stat        | Sim      | Target   ');
  print('BB rate          | ${(bbRate * 100).toStringAsFixed(1)}%    | 28.3%');
  print('K rate           | ${(kRate * 100).toStringAsFixed(1)}%    | 40.9%');
  print('BIP rate         | ${(bipRate * 100).toStringAsFixed(1)}%    | 30.8%');
  print('Hit rate         | ${(hitRate * 100).toStringAsFixed(1)}%    | 15.6%');
  print('XBH rate         | ${(xbhRate * 100).toStringAsFixed(1)}%    | 5.3%');
  print('HR rate          | ${(hrRate * 100).toStringAsFixed(1)}%    | 4.9%');
  print('');
  print('Per team-game     | Sim      | Target (per calibration doc)');
  print('R  | ${(runsTotal / teamGames).toStringAsFixed(2)}     | ~2.98');
  print('BB | ${(walksTotal / teamGames).toStringAsFixed(2)}     | ~4.48');
  print('K  | ${(ksTotal / teamGames).toStringAsFixed(2)}     | ~6.56');
  print('H  | ${(hitsTotal / teamGames).toStringAsFixed(2)}     | ~2.40');
}
