import 'package:drift/drift.dart';

import 'games.dart';
import 'players.dart';
import 'teams.dart';

/// One player's fielding line for one game.
///
/// INN is stored as [outsPlayed] (outs, same convention as PitchingStats'
/// outsRecorded) so partial-inning defensive stints stay exact. FPct is
/// derived at query time from TC/E.
///
/// SB/CS are kept for stat-model completeness (they also appear on the
/// batting/pitching leaderboards) but will always be zero under the MLW
/// ruleset, which has no stealing.
class FieldingStats extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get gameId => integer().references(Games, #id)();
  IntColumn get playerId => integer().references(Players, #id)();
  IntColumn get teamId => integer().references(Teams, #id)();

  BoolColumn get gs => boolean().withDefault(const Constant(false))();

  IntColumn get outsPlayed => integer().withDefault(const Constant(0))();

  IntColumn get tc => integer().withDefault(const Constant(0))();
  IntColumn get po => integer().withDefault(const Constant(0))();
  IntColumn get a => integer().withDefault(const Constant(0))();
  IntColumn get e => integer().withDefault(const Constant(0))();
  IntColumn get dp => integer().withDefault(const Constant(0))();
  IntColumn get pb => integer().withDefault(const Constant(0))();
  IntColumn get sb => integer().withDefault(const Constant(0))();
  IntColumn get cs => integer().withDefault(const Constant(0))();

  @override
  List<Set<Column>> get uniqueKeys => [
        {gameId, playerId},
      ];
}
