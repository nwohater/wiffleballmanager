import 'package:flutter_test/flutter_test.dart';

import 'package:wballmgr/data/database.dart';
import 'package:wballmgr/data/enums.dart';
import 'package:wballmgr/draft/draft_order.dart';

Standing _standing(int teamId, {required int w, required int l}) => Standing(
      id: teamId,
      seasonId: 1,
      teamId: teamId,
      w: w,
      l: l,
      t: 0,
      pf: 0,
      pa: 0,
    );

PlayoffSeriesRow _series({
  required int id,
  required PlayoffRound round,
  required int higherSeedTeamId,
  required int higherSeedRank,
  required int lowerSeedTeamId,
  required int lowerSeedRank,
  required int? winnerTeamId,
}) =>
    PlayoffSeriesRow(
      id: id,
      seasonId: 1,
      tier: Tier.major,
      round: round,
      higherSeedTeamId: higherSeedTeamId,
      higherSeedRank: higherSeedRank,
      lowerSeedTeamId: lowerSeedTeamId,
      lowerSeedRank: lowerSeedRank,
      bestOf: round == PlayoffRound.championship ? 7 : 5,
      higherSeedWins: 0,
      lowerSeedWins: 0,
      winnerTeamId: winnerTeamId,
    );

void main() {
  // Same 12-team/standings fixture as test/league/playoffs_test.dart's
  // seedsFromStandings test, so the resulting seeds (5, 10, 1, 9) are known:
  // seed1=5 (.758), seed2=10 (.667), seed3=1 (.606), seed4=9 (.545, wildcard).
  final teamDivisionId = {
    for (var i = 1; i <= 4; i++) i: 1,
    for (var i = 5; i <= 8; i++) i: 2,
    for (var i = 9; i <= 12; i++) i: 3,
  };
  final standings = [
    _standing(1, w: 20, l: 13), _standing(2, w: 15, l: 18), _standing(3, w: 10, l: 23), _standing(4, w: 5, l: 28),
    _standing(5, w: 25, l: 8), _standing(6, w: 12, l: 21), _standing(7, w: 8, l: 25), _standing(8, w: 3, l: 30),
    _standing(9, w: 18, l: 15), _standing(10, w: 22, l: 11), _standing(11, w: 9, l: 24), _standing(12, w: 6, l: 27),
  ];

  group('draftOrder', () {
    test('non-playoff teams worst-first, then playoff teams in reverse elimination order, champ last', () {
      // Semifinal 1: seed1 (team 5) vs seed4 (team 9) — upset, team 9 wins.
      // Semifinal 2: seed2 (team 10) vs seed3 (team 1) — chalk, team 10 wins.
      // Championship: team 10 (better seed, rank 2) hosts team 9 (rank 4) —
      // team 9 wins it too.
      final playoffSeries = [
        _series(
          id: 1,
          round: PlayoffRound.semifinal,
          higherSeedTeamId: 5,
          higherSeedRank: 1,
          lowerSeedTeamId: 9,
          lowerSeedRank: 4,
          winnerTeamId: 9,
        ),
        _series(
          id: 2,
          round: PlayoffRound.semifinal,
          higherSeedTeamId: 10,
          higherSeedRank: 2,
          lowerSeedTeamId: 1,
          lowerSeedRank: 3,
          winnerTeamId: 10,
        ),
        _series(
          id: 3,
          round: PlayoffRound.championship,
          higherSeedTeamId: 10,
          higherSeedRank: 2,
          lowerSeedTeamId: 9,
          lowerSeedRank: 4,
          winnerTeamId: 9,
        ),
      ];

      final order = draftOrder(
        regularSeasonStandings: standings,
        teamDivisionId: teamDivisionId,
        playoffSeries: playoffSeries,
      );

      expect(
        order,
        [
          8, 4, 12, 7, 11, 3, 6, 2, // non-playoff teams, worst record first
          1, 5, // semifinal losers, worse original seed (higher rank #) first
          10, // championship loser
          9, // champion, picks last
        ],
      );
    });

    test('throws if the playoff bracket is not fully decided', () {
      expect(
        () => draftOrder(regularSeasonStandings: standings, teamDivisionId: teamDivisionId, playoffSeries: const []),
        throwsArgumentError,
      );
    });
  });

  group('fullDraftOrder', () {
    test('repeats the same team order every round', () {
      final playoffSeries = [
        _series(
          id: 1,
          round: PlayoffRound.semifinal,
          higherSeedTeamId: 5,
          higherSeedRank: 1,
          lowerSeedTeamId: 9,
          lowerSeedRank: 4,
          winnerTeamId: 5,
        ),
        _series(
          id: 2,
          round: PlayoffRound.semifinal,
          higherSeedTeamId: 10,
          higherSeedRank: 2,
          lowerSeedTeamId: 1,
          lowerSeedRank: 3,
          winnerTeamId: 1,
        ),
        _series(
          id: 3,
          round: PlayoffRound.championship,
          higherSeedTeamId: 5,
          higherSeedRank: 1,
          lowerSeedTeamId: 1,
          lowerSeedRank: 3,
          winnerTeamId: 5,
        ),
      ];

      final oneRound = draftOrder(
        regularSeasonStandings: standings,
        teamDivisionId: teamDivisionId,
        playoffSeries: playoffSeries,
      );
      final twoRounds = fullDraftOrder(
        regularSeasonStandings: standings,
        teamDivisionId: teamDivisionId,
        playoffSeries: playoffSeries,
        rounds: 2,
      );

      expect(twoRounds, [...oneRound, ...oneRound]);
    });
  });
}
