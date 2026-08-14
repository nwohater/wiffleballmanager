/// Pure Dart, decoupled from drift (mirrors lib/sim/ and lib/roster/'s
/// shape) — a full round-robin schedule for an even number of teams: every
/// team plays every other team once, as a 3-game series (PRD: 33 games per
/// team for 12 teams). Generated via the standard "circle method": fix one
/// team, rotate the rest each round; N-1 rounds, N/2 pairings per round,
/// every pairing occurs exactly once across all rounds.
///
/// [ScheduledGame.dayNumber] is a first-class scheduling unit, not just a
/// sequence counter: since every team plays at most once per day, a whole
/// day's games can be simulated together. Each round's pairing plays a
/// 3-day series (all 3 games at the same host — no 2-2-1 style split
/// modeling), so day = round*3 + gameInSeries, giving days 1..3*(N-1) with
/// N/2 games sharing each day. Host alternates by round parity for rough
/// home/away balance across the season.
library;

class ScheduledGame {
  final int homeTeamId;
  final int awayTeamId;
  final int dayNumber;

  const ScheduledGame({
    required this.homeTeamId,
    required this.awayTeamId,
    required this.dayNumber,
  });
}

List<ScheduledGame> generateRoundRobinSchedule({required List<int> teamIds}) {
  final n = teamIds.length;
  if (n < 2 || n.isOdd) {
    throw ArgumentError('generateRoundRobinSchedule requires an even number of teams >= 2, got $n');
  }

  final games = <ScheduledGame>[];
  final arr = List<int>.of(teamIds);
  final rounds = n - 1;

  for (var round = 0; round < rounds; round++) {
    for (var i = 0; i < n ~/ 2; i++) {
      final a = arr[i];
      final b = arr[n - 1 - i];
      final aHosts = round.isEven;
      final homeTeamId = aHosts ? a : b;
      final awayTeamId = aHosts ? b : a;
      for (var gameInSeries = 0; gameInSeries < 3; gameInSeries++) {
        games.add(ScheduledGame(
          homeTeamId: homeTeamId,
          awayTeamId: awayTeamId,
          dayNumber: round * 3 + gameInSeries + 1,
        ));
      }
    }

    // Rotate all but the fixed first team by one position.
    if (n > 2) {
      final last = arr[n - 1];
      for (var i = n - 1; i > 1; i--) {
        arr[i] = arr[i - 1];
      }
      arr[1] = last;
    }
  }

  return games;
}
