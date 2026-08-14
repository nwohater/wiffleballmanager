import 'package:drift/drift.dart';

import '../enums.dart';
import 'playoff_series.dart';
import 'seasons.dart';
import 'teams.dart';

/// A single scheduled/played game between two teams of the same tier.
/// Box score detail lives in BattingStats/PitchingStats/FieldingStats,
/// keyed back to this row's id.
class Games extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get seasonId => integer().references(Seasons, #id)();

  IntColumn get tier => intEnum<Tier>()();

  @ReferenceName('homeGames')
  IntColumn get homeTeamId => integer().references(Teams, #id)();

  @ReferenceName('awayGames')
  IntColumn get awayTeamId => integer().references(Teams, #id)();

  /// For a regular-season game: the day number within the season (1-based
  /// — every team plays at most once per day, so this doubles as the
  /// "simulate this day" grouping key). For a playoff game (`seriesId` set):
  /// just a continuing incrementing value with no day semantics, since
  /// playoff series aren't simultaneous across the league the way the
  /// round-robin regular season is.
  IntColumn get gameNumber => integer()();

  /// Null for a regular-season game; set for a playoff game (see
  /// `lib/data/tables/playoff_series.dart`).
  IntColumn get seriesId => integer().nullable().references(PlayoffSeries, #id)();

  IntColumn get status =>
      intEnum<GameStatus>().withDefault(Constant(GameStatus.scheduled.index))();

  IntColumn get homeScore => integer().withDefault(const Constant(0))();

  IntColumn get awayScore => integer().withDefault(const Constant(0))();

  /// Innings actually played — 3 for regulation, more if it went extras
  /// (MLW ruleset: extra innings until a winner is determined).
  IntColumn get inningsPlayed => integer().withDefault(const Constant(0))();
}
