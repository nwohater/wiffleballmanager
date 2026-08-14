import 'package:drift/drift.dart';

import '../enums.dart';
import 'players.dart';

/// A pitcher's repertoire: 1-4 rows per Player. A pitch type absent from a
/// player's repertoire means "doesn't throw it" (not a 0 Movement rating) —
/// the sim engine should never select a pitch type with no row here.
class PlayerPitches extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get playerId => integer().references(Players, #id)();

  IntColumn get pitchType => intEnum<PitchType>()();

  IntColumn get movement => integer()();

  @override
  List<Set<Column>> get uniqueKeys => [
        {playerId, pitchType},
      ];
}
