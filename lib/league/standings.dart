import 'package:drift/drift.dart';

import 'package:wballmgr/data/database.dart';

enum _Outcome { win, loss, tie }

/// Upserts both teams' `Standings` rows after a completed regular-season
/// game (W/L/T + PF/PA). Requires zeroed rows to already exist for
/// [seasonId]/[homeTeamId]/[awayTeamId] (created at league seeding /
/// season rollover time).
Future<void> recordGameResult(
  AppDatabase db, {
  required int seasonId,
  required int homeTeamId,
  required int awayTeamId,
  required int homeScore,
  required int awayScore,
}) async {
  final homeOutcome = homeScore > awayScore
      ? _Outcome.win
      : (homeScore < awayScore ? _Outcome.loss : _Outcome.tie);
  final awayOutcome = awayScore > homeScore
      ? _Outcome.win
      : (awayScore < homeScore ? _Outcome.loss : _Outcome.tie);

  await _applyResult(db, seasonId: seasonId, teamId: homeTeamId, pf: homeScore, pa: awayScore, outcome: homeOutcome);
  await _applyResult(db, seasonId: seasonId, teamId: awayTeamId, pf: awayScore, pa: homeScore, outcome: awayOutcome);
}

Future<void> _applyResult(
  AppDatabase db, {
  required int seasonId,
  required int teamId,
  required int pf,
  required int pa,
  required _Outcome outcome,
}) async {
  final row = await (db.select(db.standings)
        ..where((s) => s.seasonId.equals(seasonId) & s.teamId.equals(teamId)))
      .getSingle();

  final companion = StandingsCompanion(
    w: Value(row.w + (outcome == _Outcome.win ? 1 : 0)),
    l: Value(row.l + (outcome == _Outcome.loss ? 1 : 0)),
    t: Value(row.t + (outcome == _Outcome.tie ? 1 : 0)),
    pf: Value(row.pf + pf),
    pa: Value(row.pa + pa),
  );
  await (db.update(db.standings)
        ..where((s) => s.seasonId.equals(seasonId) & s.teamId.equals(teamId)))
      .write(companion);
}

double _pct(Standing s) {
  final games = s.w + s.l + s.t;
  return games == 0 ? 0 : s.w / games;
}

/// Tiebreaker order per the PRD: Pct > PA > PF. Direction isn't spelled out
/// there — interpreted as the natural reading: fewer PA (runs against) is
/// better, more PF (runs for) is better.
int compareStandings(Standing a, Standing b) {
  final pctCompare = _pct(b).compareTo(_pct(a));
  if (pctCompare != 0) return pctCompare;
  final paCompare = a.pa.compareTo(b.pa);
  if (paCompare != 0) return paCompare;
  return b.pf.compareTo(a.pf);
}
