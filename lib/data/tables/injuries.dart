import 'package:drift/drift.dart';

import '../enums.dart';
import 'games.dart';
import 'players.dart';
import 'seasons.dart';

/// A single injury event rolled after a completed game for a participant.
/// Moderate/major injuries carry a [replacementPlayerId] (the free agent
/// signed to backfill the roster spot) that's cleared on recovery — see
/// context/player-ratings.md "Career Progression: Injuries".
class Injuries extends Table {
  IntColumn get id => integer().autoIncrement()();

  @ReferenceName('injuries')
  IntColumn get playerId => integer().references(Players, #id)();

  IntColumn get seasonId => integer().references(Seasons, #id)();

  IntColumn get gameId => integer().references(Games, #id)();

  IntColumn get severity => intEnum<InjurySeverity>()();

  IntColumn get gamesMissed => integer()();

  @ReferenceName('injuryReplacements')
  IntColumn get replacementPlayerId =>
      integer().nullable().references(Players, #id)();
}
