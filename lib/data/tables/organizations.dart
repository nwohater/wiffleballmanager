import 'package:drift/drift.dart';

/// A franchise — the shared identity between a major-league team and its
/// minor-league affiliate (PRD: "Each of the 12 organizations fields a full
/// minor-league affiliate").
class Organizations extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text().withLength(min: 1, max: 64)();

  /// True for exactly one org — the human player's franchise. Everything
  /// else is AI-controlled (PRD: Hidden Ratings / AI team management).
  BoolColumn get isPlayerControlled =>
      boolean().withDefault(const Constant(false))();
}
