// ignore_for_file: avoid_print
// Manual season sanity check (todo/initial-build.md's sequencing note):
// simulates a season's worth of games (33, matching Phase 3's planned
// round-robin length) between two league-average synthetic teams and
// prints actual box scores, streaks, and season stat lines so a human can
// eyeball believability rather than just checking aggregate rates (which
// tool/validate_harness.dart already covers). Run with:
//   dart run tool/season_sanity_check.dart
import 'dart:math';

import 'package:wballmgr/sim/box_score.dart';
import 'package:wballmgr/sim/game_simulator.dart';

import '../test/sim/harness.dart';

String line(BattingLine b, Map<int, String> names) {
  final avg = b.ab == 0 ? '.---' : (b.h / b.ab).toStringAsFixed(3).substring(1);
  return '${names[b.playerId]!.padRight(10)} AB:${b.ab} R:${b.r} H:${b.h} 2B:${b.doubles} 3B:${b.triples} '
      'HR:${b.hr} RBI:${b.rbi} BB:${b.bb} K:${b.k} AVG:$avg';
}

String pline(PitchingLine p, Map<int, String> names) {
  final ip = '${p.outsRecorded ~/ 3}.${p.outsRecorded % 3}';
  final era = p.outsRecorded == 0 ? '-.--' : (p.er * 3 / (p.outsRecorded / 3)).toStringAsFixed(2);
  final decision = p.w > 0 ? 'W' : (p.l > 0 ? 'L' : (p.s > 0 ? 'S' : ''));
  return '${names[p.playerId]!.padRight(10)} IP:$ip H:${p.h} R:${p.r} ER:${p.er} BB:${p.bb} K:${p.k} '
      'ERA:$era $decision';
}

void printBoxScore(int gameNum, GameResult r, Map<int, String> names, Map<int, String> teamNames) {
  print('=== Game $gameNum: ${teamNames[r.awayTeamId]} @ ${teamNames[r.homeTeamId]} '
      '(${r.awayScore}-${r.homeScore}, ${r.inningsPlayed} innings) ===');
  print('Line: away ${r.awayInningRuns.join('-')}  home ${r.homeInningRuns.join('-')}');
  print('-- ${teamNames[r.awayTeamId]} batting --');
  for (final b in r.boxScore.batting.values.where((b) => b.teamId == r.awayTeamId)) {
    print(line(b, names));
  }
  print('-- ${teamNames[r.homeTeamId]} batting --');
  for (final b in r.boxScore.batting.values.where((b) => b.teamId == r.homeTeamId)) {
    print(line(b, names));
  }
  print('-- pitching --');
  for (final p in r.boxScore.pitching.values) {
    print(pline(p, names));
  }
  print('');
}

void main() {
  const games = 33; // Phase 3's planned regular-season length (round robin)
  final rng = Random(42);
  final home = buildSyntheticTeam(1, 1);
  final away = buildSyntheticTeam(2, 100);
  final players = {for (final p in [...home.players, ...away.players]) p.id: p};
  final names = {for (final p in players.values) p.id: p.name};
  final teamNames = {home.teamId: 'Home', away.teamId: 'Away'};

  final results = <GameResult>[];
  final seasonBatting = <int, BattingLine>{};
  final seasonPitching = <int, PitchingLine>{};

  var homeWins = 0, awayWins = 0;
  var curStreakTeam = 0, curStreakLen = 0;
  var longestStreakTeam = 0, longestStreakLen = 0;
  var extraInningGames = 0, mercyGames = 0, blowouts = 0;

  // consecutive-games-with-a-hit tracking per player
  final curHitStreak = <int, int>{};
  final longestHitStreak = <int, int>{};

  for (var g = 1; g <= games; g++) {
    // Alternate home/away each game, like a real series would.
    final isHomeHost = g.isOdd;
    final result = isHomeHost
        ? simulateGame(home: home.lineup, away: away.lineup, players: players, random: rng)
        : simulateGame(home: away.lineup, away: home.lineup, players: players, random: rng);
    results.add(result);

    final winner = result.homeScore > result.awayScore ? result.homeTeamId : result.awayTeamId;
    if (winner == home.teamId) {
      homeWins++;
    } else {
      awayWins++;
    }
    if (winner == curStreakTeam) {
      curStreakLen++;
    } else {
      curStreakTeam = winner;
      curStreakLen = 1;
    }
    if (curStreakLen > longestStreakLen) {
      longestStreakLen = curStreakLen;
      longestStreakTeam = curStreakTeam;
    }

    if (result.inningsPlayed > 3) extraInningGames++;
    if ((result.homeInningRuns.take(2).any((r) => r >= 6)) ||
        (result.awayInningRuns.take(2).any((r) => r >= 6))) {
      mercyGames++;
    }
    if ((result.homeScore - result.awayScore).abs() >= 8) blowouts++;

    for (final b in result.boxScore.batting.values) {
      final season = seasonBatting.putIfAbsent(b.playerId, () => BattingLine(playerId: b.playerId, teamId: b.teamId));
      season.pa += b.pa;
      season.ab += b.ab;
      season.r += b.r;
      season.h += b.h;
      season.doubles += b.doubles;
      season.triples += b.triples;
      season.hr += b.hr;
      season.rbi += b.rbi;
      season.bb += b.bb;
      season.k += b.k;

      if (b.h > 0) {
        curHitStreak[b.playerId] = (curHitStreak[b.playerId] ?? 0) + 1;
      } else {
        curHitStreak[b.playerId] = 0;
      }
      final cur = curHitStreak[b.playerId]!;
      if (cur > (longestHitStreak[b.playerId] ?? 0)) longestHitStreak[b.playerId] = cur;
    }
    for (final p in result.boxScore.pitching.values) {
      final season = seasonPitching.putIfAbsent(p.playerId, () => PitchingLine(playerId: p.playerId, teamId: p.teamId));
      season.outsRecorded += p.outsRecorded;
      season.r += p.r;
      season.er += p.er;
      season.h += p.h;
      season.bb += p.bb;
      season.k += p.k;
      season.w += p.w;
      season.l += p.l;
      season.s += p.s;
    }
  }

  // Print a sample of box scores: first, a middle game, last, plus the
  // first extra-innings game and first mercy-rule game found (if any).
  printBoxScore(1, results[0], names, teamNames);
  printBoxScore(17, results[16], names, teamNames);
  printBoxScore(games, results[games - 1], names, teamNames);

  final extraIdx = results.indexWhere((r) => r.inningsPlayed > 3);
  if (extraIdx != -1) printBoxScore(extraIdx + 1, results[extraIdx], names, teamNames);
  final mercyIdx = results.indexWhere((r) =>
      r.homeInningRuns.take(2).any((x) => x >= 6) || r.awayInningRuns.take(2).any((x) => x >= 6));
  if (mercyIdx != -1) printBoxScore(mercyIdx + 1, results[mercyIdx], names, teamNames);

  print('=== Season summary ($games games) ===');
  print('Home record: $homeWins-$awayWins   Away record: $awayWins-$homeWins');
  print('Longest win streak: $longestStreakLen games (${teamNames[longestStreakTeam]})');
  print('Extra-inning games: $extraInningGames / $games');
  print('Mercy-rule games (6+ runs in inn 1-2): $mercyGames / $games');
  print('Blowouts (margin >= 8): $blowouts / $games');
  print('');

  print('-- Season batting --');
  for (final b in seasonBatting.values) {
    final avg = b.ab == 0 ? '.---' : (b.h / b.ab).toStringAsFixed(3).substring(1);
    final obp = b.pa == 0 ? '.---' : ((b.h + b.bb) / b.pa).toStringAsFixed(3).substring(1);
    final tb = b.h + b.doubles + 2 * b.triples + 3 * b.hr;
    final slg = b.ab == 0 ? '.---' : (tb / b.ab).toStringAsFixed(3).substring(1);
    print('${names[b.playerId]!.padRight(10)} PA:${b.pa} AB:${b.ab} R:${b.r} H:${b.h} 2B:${b.doubles} '
        '3B:${b.triples} HR:${b.hr} RBI:${b.rbi} BB:${b.bb} K:${b.k} AVG:$avg OBP:$obp SLG:$slg '
        'longestHitStreak:${longestHitStreak[b.playerId] ?? 0}');
  }
  print('');
  print('-- Season pitching --');
  for (final p in seasonPitching.values) {
    final ip = '${p.outsRecorded ~/ 3}.${p.outsRecorded % 3}';
    final era = p.outsRecorded == 0 ? '-.--' : (p.er * 3 / (p.outsRecorded / 3)).toStringAsFixed(2);
    final whip = p.outsRecorded == 0 ? '-.--' : ((p.bb + p.h) / (p.outsRecorded / 3)).toStringAsFixed(2);
    print('${names[p.playerId]!.padRight(10)} IP:$ip W:${p.w} L:${p.l} S:${p.s} H:${p.h} R:${p.r} '
        'ER:${p.er} BB:${p.bb} K:${p.k} ERA:$era WHIP:$whip');
  }
}
