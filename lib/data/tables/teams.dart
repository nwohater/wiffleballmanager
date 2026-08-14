import 'package:drift/drift.dart';

import 'divisions.dart';
import 'organizations.dart';

/// A single roster/squad — either the major or minor side of an
/// [Organizations] row. Tier is implied by [divisionId] (each division
/// belongs to exactly one tier).
class Teams extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get organizationId =>
      integer().references(Organizations, #id)();

  IntColumn get divisionId => integer().references(Divisions, #id)();

  TextColumn get name => text().withLength(min: 1, max: 64)();
}
