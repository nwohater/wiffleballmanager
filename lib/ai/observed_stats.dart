import 'package:drift/drift.dart';

import 'package:wballmgr/data/database.dart';

/// League-average-ish placeholders used when a player has no [seasonId]
/// track record yet (a rookie, a fresh free-agent signing, etc.) — an
/// unproven player is scored as roughly average rather than penalized to
/// the bottom of the pack, matching context/player-ratings.md's "small
/// sample can mislead" theme. Uncalibrated starting points, same treatment
/// as Phase 4's aging/injury constants.
const double _neutralObp = 0.34;
const double _neutralSlg = 0.36;
const double _neutralEra = 3.0;
const double _neutralWhip = 2.3;
const double _neutralFpct = 0.95;

/// One player's season-to-date observed (player-visible) rate stats —
/// deliberately excludes every true-rating field, mirroring how
/// lib/roster/roster_rules.dart's RosterMember stays decoupled from true
/// ratings. This is the only signal baseline AI decision logic (lib/ai/) is
/// allowed to see, per the Hidden Ratings model.
class ObservedPlayerStats {
  final int playerId;

  final int pa;
  final double obp;
  final double slg;

  final int outsRecorded;
  final double era;
  final double whip;

  final int chances;
  final double fpct;

  const ObservedPlayerStats({
    required this.playerId,
    required this.pa,
    required this.obp,
    required this.slg,
    required this.outsRecorded,
    required this.era,
    required this.whip,
    required this.chances,
    required this.fpct,
  });

  /// Higher is better. Neutral for an unproven (zero-PA) player.
  double get battingScore => obp + slg;

  /// Higher is better (unlike raw ERA/WHIP, where lower is better) — easier
  /// to compare against battingScore/fieldingScore's "higher is better"
  /// convention. Neutral for an unproven (zero-outs) player.
  double get pitchingScore => -(era + whip);

  /// Higher is better. Neutral for a player with no fielding chances yet.
  double get fieldingScore => fpct;
}

/// Sums BattingStats/PitchingStats/FieldingStats for [seasonId] per player
/// (same query shape as lib/career/season_progression.dart's
/// applySeasonDevelopment) and derives the rate stats lib/ai/ decision logic
/// needs. Players in [playerIds] with no rows for the season get the
/// neutral placeholder scores above rather than being omitted.
Future<Map<int, ObservedPlayerStats>> loadObservedStats(
  AppDatabase db, {
  required List<int> playerIds,
  required int seasonId,
}) async {
  if (playerIds.isEmpty) return {};

  final gameIds = (await (db.select(db.games)..where((g) => g.seasonId.equals(seasonId))).get())
      .map((g) => g.id)
      .toSet();

  final battingByPlayer = <int, List<BattingStat>>{};
  final pitchingByPlayer = <int, List<PitchingStat>>{};
  final fieldingByPlayer = <int, List<FieldingStat>>{};

  if (gameIds.isNotEmpty) {
    for (final row in await (db.select(db.battingStats)
          ..where((b) => b.gameId.isIn(gameIds) & b.playerId.isIn(playerIds)))
        .get()) {
      battingByPlayer.putIfAbsent(row.playerId, () => []).add(row);
    }
    for (final row in await (db.select(db.pitchingStats)
          ..where((p) => p.gameId.isIn(gameIds) & p.playerId.isIn(playerIds)))
        .get()) {
      pitchingByPlayer.putIfAbsent(row.playerId, () => []).add(row);
    }
    for (final row in await (db.select(db.fieldingStats)
          ..where((f) => f.gameId.isIn(gameIds) & f.playerId.isIn(playerIds)))
        .get()) {
      fieldingByPlayer.putIfAbsent(row.playerId, () => []).add(row);
    }
  }

  return {
    for (final playerId in playerIds)
      playerId: _statsFor(
        playerId,
        battingByPlayer[playerId] ?? const [],
        pitchingByPlayer[playerId] ?? const [],
        fieldingByPlayer[playerId] ?? const [],
      ),
  };
}

ObservedPlayerStats _statsFor(
  int playerId,
  List<BattingStat> batting,
  List<PitchingStat> pitching,
  List<FieldingStat> fielding,
) {
  var pa = 0, ab = 0, h = 0, doubles = 0, triples = 0, hr = 0, bb = 0, hbp = 0, sf = 0;
  for (final row in batting) {
    pa += row.pa;
    ab += row.ab;
    h += row.h;
    doubles += row.doubles;
    triples += row.triples;
    hr += row.hr;
    bb += row.bb;
    hbp += row.hbp;
    sf += row.sf;
  }
  final obpDenominator = ab + bb + hbp + sf;
  final obp = obpDenominator == 0 ? _neutralObp : (h + bb + hbp) / obpDenominator;
  final totalBases = h + doubles + 2 * triples + 3 * hr;
  final slg = ab == 0 ? _neutralSlg : totalBases / ab;

  var outsRecorded = 0, er = 0, pBb = 0, pH = 0;
  for (final row in pitching) {
    outsRecorded += row.outsRecorded;
    er += row.er;
    pBb += row.bb;
    pH += row.h;
  }
  // This league's ERA convention is ER x3 / IP, not the standard x9 — see
  // lib/data/tables/pitching_stats.dart.
  final era = outsRecorded == 0 ? _neutralEra : (er * 3) / (outsRecorded / 3);
  final whip = outsRecorded == 0 ? _neutralWhip : (pBb + pH) / (outsRecorded / 3);

  var chances = 0, e = 0;
  for (final row in fielding) {
    chances += row.tc;
    e += row.e;
  }
  final fpct = chances == 0 ? _neutralFpct : (chances - e) / chances;

  return ObservedPlayerStats(
    playerId: playerId,
    pa: pa,
    obp: obp,
    slg: slg,
    outsRecorded: outsRecorded,
    era: era,
    whip: whip,
    chances: chances,
    fpct: fpct,
  );
}
