import 'package:drift/drift.dart';

import 'games.dart';
import 'players.dart';
import 'teams.dart';

/// One player's pitching line for one game.
///
/// IP is stored as [outsRecorded] (outs, not fractional innings) so partial
/// innings stay exact; convert to innings (outsRecorded / 3) for display.
/// ERA/WHIP are derived at query time — and per rules-mlw-cultz-field.md,
/// this league's ERA convention is ER x 3 / IP (per-3-inning-game), NOT the
/// standard x9 formula. Any aggregation code must replicate that, or
/// displayed stats won't match the source league.
class PitchingStats extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get gameId => integer().references(Games, #id)();
  IntColumn get playerId => integer().references(Players, #id)();
  IntColumn get teamId => integer().references(Teams, #id)();

  BoolColumn get gs => boolean().withDefault(const Constant(false))();
  BoolColumn get cg => boolean().withDefault(const Constant(false))();

  IntColumn get outsRecorded => integer().withDefault(const Constant(0))();

  IntColumn get r => integer().withDefault(const Constant(0))();
  IntColumn get er => integer().withDefault(const Constant(0))();
  IntColumn get h => integer().withDefault(const Constant(0))();
  IntColumn get bb => integer().withDefault(const Constant(0))();
  IntColumn get hbp => integer().withDefault(const Constant(0))();
  IntColumn get ibb => integer().withDefault(const Constant(0))();
  IntColumn get k => integer().withDefault(const Constant(0))();
  IntColumn get w => integer().withDefault(const Constant(0))();
  IntColumn get l => integer().withDefault(const Constant(0))();
  IntColumn get s => integer().withDefault(const Constant(0))();
  IntColumn get hld => integer().withDefault(const Constant(0))();
  IntColumn get bs => integer().withDefault(const Constant(0))();
  IntColumn get wp => integer().withDefault(const Constant(0))();

  @override
  List<Set<Column>> get uniqueKeys => [
        {gameId, playerId},
      ];
}
