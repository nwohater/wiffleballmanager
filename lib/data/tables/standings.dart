import 'package:drift/drift.dart';

import 'seasons.dart';
import 'teams.dart';

/// Running W/L/T + PF/PA per team per season. Tiebreaker order per the PRD
/// is Pct > PA > PF; Pct is derived (not stored) from w/l/t.
class Standings extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get seasonId => integer().references(Seasons, #id)();
  IntColumn get teamId => integer().references(Teams, #id)();

  IntColumn get w => integer().withDefault(const Constant(0))();
  IntColumn get l => integer().withDefault(const Constant(0))();
  IntColumn get t => integer().withDefault(const Constant(0))();

  IntColumn get pf => integer().withDefault(const Constant(0))();
  IntColumn get pa => integer().withDefault(const Constant(0))();

  @override
  List<Set<Column>> get uniqueKeys => [
        {seasonId, teamId},
      ];
}
