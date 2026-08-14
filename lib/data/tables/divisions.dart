import 'package:drift/drift.dart';

import '../enums.dart';

/// 3 divisions x 4 teams, mirrored at both tiers (6 divisions total).
class Divisions extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text().withLength(min: 1, max: 64)();

  IntColumn get tier => intEnum<Tier>()();
}
