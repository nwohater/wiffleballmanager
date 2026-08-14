import 'package:drift/drift.dart';

/// One career-mode season. `number` is the sequential season counter that
/// advances on rollover (PRD: multi-season career progression).
class Seasons extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get number => integer().unique()();

  BoolColumn get isActive => boolean().withDefault(const Constant(false))();
}
