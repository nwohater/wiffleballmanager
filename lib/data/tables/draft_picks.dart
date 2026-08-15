import 'package:drift/drift.dart';

import 'players.dart';
import 'seasons.dart';
import 'teams.dart';

/// One selection in an annual rookie draft (Phase 6 —
/// context/rules-mlw-cultz-field.md's "Draft & Trades" section, adapted to
/// this sim's 12-team league: 2 rounds, one pick per team per round, same
/// worst-to-first team order repeated each round — see
/// lib/draft/draft_order.dart). Recorded purely for history/future UI; the
/// actual roster effect (the player becoming org depth) lives on the
/// `Players` row itself.
class DraftPicks extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get seasonId => integer().references(Seasons, #id)();

  IntColumn get round => integer()();

  /// 1-indexed pick number across the whole draft (not just within a round).
  IntColumn get overallPick => integer()();

  IntColumn get teamId => integer().references(Teams, #id)();

  IntColumn get playerId => integer().references(Players, #id)();
}
