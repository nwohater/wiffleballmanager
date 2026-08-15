import 'package:drift/drift.dart';

import '../enums.dart';
import 'seasons.dart';
import 'teams.dart';

/// One playoff series (PRD: 4-team bracket seeded 1-4, #1v#4/#2v#3
/// semifinals best-of-5, best-of-7 championship). The higher seed hosts
/// every game of the series — same simplification the regular season's
/// 3-game series already use (no 2-2-1/2-3-2 home/away split modeling).
/// Individual games still land in `Games` (via its nullable `seriesId`),
/// so they show up in game history/box scores like any other game.
///
/// [higherSeedRank]/[lowerSeedRank] (1-4) store each side's *original*
/// bracket seed, not just "which team is favored in this matchup" — needed
/// to correctly reseed the championship after a semifinal upset (e.g. seed
/// 4 beating seed 1 means the other semifinal's winner, even if it's seed
/// 3, is the better remaining seed and should host the championship).
@DataClassName('PlayoffSeriesRow')
class PlayoffSeries extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get seasonId => integer().references(Seasons, #id)();

  /// Major and minor tiers each run their own independent bracket (Phase 7)
  /// — needed because [higherSeedTeamId]/[lowerSeedTeamId] alone don't
  /// disambiguate which tier's standings this series was seeded from.
  /// Existing rows (pre-Phase-7) default to major, which is correct — no
  /// minor tier existed when they were written.
  IntColumn get tier => intEnum<Tier>().withDefault(Constant(Tier.major.index))();

  IntColumn get round => intEnum<PlayoffRound>()();

  @ReferenceName('higherSeedSeries')
  IntColumn get higherSeedTeamId => integer().references(Teams, #id)();
  IntColumn get higherSeedRank => integer()();

  @ReferenceName('lowerSeedSeries')
  IntColumn get lowerSeedTeamId => integer().references(Teams, #id)();
  IntColumn get lowerSeedRank => integer()();

  /// 5 for a semifinal, 7 for the championship.
  IntColumn get bestOf => integer()();

  IntColumn get higherSeedWins => integer().withDefault(const Constant(0))();
  IntColumn get lowerSeedWins => integer().withDefault(const Constant(0))();

  /// Null until the series is clinched (wins reach ceil(bestOf/2)).
  @ReferenceName('wonSeries')
  IntColumn get winnerTeamId => integer().nullable().references(Teams, #id)();
}
