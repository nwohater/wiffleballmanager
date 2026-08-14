import 'package:drift/drift.dart';

import 'games.dart';
import 'players.dart';
import 'teams.dart';

/// One player's batting line for one game. Rolls up into the observed
/// (player-visible) season stats per the Statistics Model in
/// rules-mlw-cultz-field.md. Rate stats (AVG/OBP/SLG/OPS) and TB are
/// derived at query time, not stored, since they're always computable from
/// the counting stats below and storing them would risk drift.
///
/// HBP is folded into ball outcomes per the ruleset ("HBP ruled a ball") —
/// the hbp column exists for stat-model completeness/display, not as a
/// distinct sim-engine outcome.
class BattingStats extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get gameId => integer().references(Games, #id)();
  IntColumn get playerId => integer().references(Players, #id)();
  IntColumn get teamId => integer().references(Teams, #id)();

  BoolColumn get gs => boolean().withDefault(const Constant(false))();

  IntColumn get pa => integer().withDefault(const Constant(0))();
  IntColumn get ab => integer().withDefault(const Constant(0))();
  IntColumn get r => integer().withDefault(const Constant(0))();
  IntColumn get h => integer().withDefault(const Constant(0))();
  IntColumn get doubles => integer().withDefault(const Constant(0))();
  IntColumn get triples => integer().withDefault(const Constant(0))();
  IntColumn get hr => integer().withDefault(const Constant(0))();
  IntColumn get rbi => integer().withDefault(const Constant(0))();
  IntColumn get bb => integer().withDefault(const Constant(0))();
  IntColumn get k => integer().withDefault(const Constant(0))();
  IntColumn get hbp => integer().withDefault(const Constant(0))();
  IntColumn get ibb => integer().withDefault(const Constant(0))();
  IntColumn get sb => integer().withDefault(const Constant(0))();
  IntColumn get cs => integer().withDefault(const Constant(0))();
  IntColumn get sh => integer().withDefault(const Constant(0))();
  IntColumn get sf => integer().withDefault(const Constant(0))();
  IntColumn get dp => integer().withDefault(const Constant(0))();
  IntColumn get roe => integer().withDefault(const Constant(0))();
  IntColumn get fc => integer().withDefault(const Constant(0))();
  IntColumn get lob => integer().withDefault(const Constant(0))();

  @override
  List<Set<Column>> get uniqueKeys => [
        {gameId, playerId},
      ];
}
