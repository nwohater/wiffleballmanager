import 'dart:math';

import 'package:wballmgr/data/database.dart';

import 'package:wballmgr/roster/roster_writer.dart';

import 'amateur_combine.dart';
import 'draft_order.dart';

/// Number of rounds in the annual rookie draft — one pick per team per
/// round (see draft_order.dart's doc comment on adapting the source
/// ruleset's literal "8 picks" to this sim's 12-team league).
const int draftRounds = 2;

/// Runs [seasonId]'s annual rookie draft: computes the 12-team order (see
/// [draftOrder]), runs a pre-draft scrimmage slate over a fresh prospect pool
/// ([runAmateurCombine]) so every prospect has a stat line to be judged by,
/// then has each pick — in order — take the best remaining prospect
/// ([rankProspectsByValue]; stat-oriented "best player available," no
/// true-rating scouting) and assign them as org depth
/// (lib/roster/roster_writer.dart's `writeDraftedPlayer`) — recording each
/// pick in `DraftPicks` for history.
///
/// No-ops (returns an empty list, writes nothing) if the season's playoff
/// bracket isn't fully decided yet — draft order depends on final playoff
/// results. In real play this never happens (the UI only offers "Start Next
/// Season" once a champion is crowned — see
/// lib/ui/screens/standings_screen.dart); it matters for tests/callers that
/// invoke rollover directly without playing out playoffs. Returns the
/// drafted player ids in pick order.
Future<List<int>> runDraft(AppDatabase db, {required int seasonId, Random? random}) async {
  final standings = await (db.select(db.standings)..where((s) => s.seasonId.equals(seasonId))).get();
  final teamRows = await db.select(db.teams).get();
  final teamDivisionId = {for (final t in teamRows) t.id: t.divisionId};
  final playoffSeriesRows =
      await (db.select(db.playoffSeries)..where((s) => s.seasonId.equals(seasonId))).get();

  final List<int> oneRoundOrder;
  try {
    oneRoundOrder = draftOrder(
      regularSeasonStandings: standings,
      teamDivisionId: teamDivisionId,
      playoffSeries: playoffSeriesRows,
    );
  } on ArgumentError {
    return const [];
  }

  final teamCount = oneRoundOrder.length;
  final fullOrder = [for (var r = 0; r < draftRounds; r++) ...oneRoundOrder];
  final organizationIdByTeam = {for (final t in teamRows) t.id: t.organizationId};

  final rng = random ?? Random();
  final prospectPool = runAmateurCombine(rng);
  assert(
    prospectPool.length >= fullOrder.length,
    'Amateur combine pool (${prospectPool.length}) must cover every draft pick (${fullOrder.length}).',
  );
  final remainingProspects = rankProspectsByValue(prospectPool);

  final playerIds = <int>[];
  for (var i = 0; i < fullOrder.length; i++) {
    final teamId = fullOrder[i];
    final organizationId = organizationIdByTeam[teamId]!;
    final prospect = remainingProspects.removeAt(0); // best remaining by amateur stat value
    final playerId = await writeDraftedPlayer(db, organizationId: organizationId, player: prospect.player);
    await db.into(db.draftPicks).insert(DraftPicksCompanion.insert(
          seasonId: seasonId,
          round: (i ~/ teamCount) + 1,
          overallPick: i + 1,
          teamId: teamId,
          playerId: playerId,
        ));
    playerIds.add(playerId);
  }

  return playerIds;
}
