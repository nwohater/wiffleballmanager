import 'package:wballmgr/data/database.dart';
import 'package:wballmgr/data/enums.dart';
import 'package:wballmgr/league/playoffs.dart';
import 'package:wballmgr/league/standings.dart';

/// One full round's 12-team draft order: the 8 non-playoff teams
/// worst-record-first, then the 4 playoff teams in reverse elimination
/// order — both semifinal losers (worse original seed first), then the
/// championship loser, then the champion last. Per
/// context/rules-mlw-cultz-field.md's "Draft & Trades" ordering rule,
/// adapted from the source's literal "8 picks" (which doesn't divide evenly
/// across a 12-team league) to one pick per team per round instead — see
/// [fullDraftOrder]. Pure — no drift dependency — built on
/// lib/league/playoffs.dart's [seedsFromStandings] and
/// lib/league/standings.dart's [compareStandings] so this can never drift
/// out of sync with how playoff seeding actually works.
///
/// Requires a fully decided playoff bracket (both semifinals and the
/// championship have a winner) — callers with incomplete playoff data
/// should check before calling this, not catch the resulting
/// [ArgumentError] (see lib/draft/draft_manager.dart's graceful skip).
List<int> draftOrder({
  required List<Standing> regularSeasonStandings,
  required Map<int, int> teamDivisionId,
  required List<PlayoffSeriesRow> playoffSeries,
}) {
  final playoffTeamIds = seedsFromStandings(regularSeasonStandings, teamDivisionId).toSet();

  final nonPlayoff = regularSeasonStandings.where((s) => !playoffTeamIds.contains(s.teamId)).toList()
    ..sort((a, b) => compareStandings(b, a)); // worst record first

  final semifinals = playoffSeries.where((s) => s.round == PlayoffRound.semifinal).toList();
  final championships = playoffSeries.where((s) => s.round == PlayoffRound.championship).toList();

  if (semifinals.length != 2 ||
      semifinals.any((s) => s.winnerTeamId == null) ||
      championships.length != 1 ||
      championships.single.winnerTeamId == null) {
    throw ArgumentError('draftOrder requires a fully decided playoff bracket.');
  }
  final championship = championships.single;

  final semifinalLosers = [
    for (final s in semifinals)
      s.winnerTeamId == s.higherSeedTeamId
          ? (teamId: s.lowerSeedTeamId, rank: s.lowerSeedRank)
          : (teamId: s.higherSeedTeamId, rank: s.higherSeedRank),
  ]..sort((a, b) => b.rank.compareTo(a.rank)); // worse seed (higher rank #) first

  final championshipLoserTeamId = championship.winnerTeamId == championship.higherSeedTeamId
      ? championship.lowerSeedTeamId
      : championship.higherSeedTeamId;

  return [
    ...nonPlayoff.map((s) => s.teamId),
    ...semifinalLosers.map((sl) => sl.teamId),
    championshipLoserTeamId,
    championship.winnerTeamId!,
  ];
}

/// Repeats [draftOrder]'s single-round order for [rounds] rounds — same
/// team order every round (not a snake draft), giving [rounds] picks per
/// team. Overall pick index in the returned list is 0-based; round is
/// `index ~/ teamCount`.
List<int> fullDraftOrder({
  required List<Standing> regularSeasonStandings,
  required Map<int, int> teamDivisionId,
  required List<PlayoffSeriesRow> playoffSeries,
  required int rounds,
}) {
  final oneRound = draftOrder(
    regularSeasonStandings: regularSeasonStandings,
    teamDivisionId: teamDivisionId,
    playoffSeries: playoffSeries,
  );
  return [for (var r = 0; r < rounds; r++) ...oneRound];
}
