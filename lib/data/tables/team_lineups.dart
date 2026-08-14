import 'package:drift/drift.dart';

import 'players.dart';
import 'teams.dart';

/// A team's manager-saved default lineup/rotation — one row per team, edited
/// via the Roster screen. This is distinct from `lib/sim/lineup.dart`'s
/// `Lineup`, which is the sim-engine-facing shape built fresh for a single
/// game; a later phase reads this row to build one.
///
/// [pitcherRotation] is order-only (who'd come in next, no innings cutoffs)
/// — turning it into a game's multi-stint pitcher plan with cutoffs is
/// bullpen management, deferred to Phase 5. Building a `Lineup` from this
/// row for now just uses a single open-ended stint for the first entry,
/// matching Phase 1's documented common case of one starter going the whole
/// game.
class TeamLineups extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get teamId => integer().references(Teams, #id).unique()();

  /// Ordered, comma-separated playerIds — 3-5 entries, per the ruleset's
  /// batting-lineup size. Always-DH: disjoint from [pitcherRotation].
  TextColumn get battingOrder => text()();

  /// Ordered, comma-separated playerIds — 1+ entries (starter first).
  TextColumn get pitcherRotation => text()();

  @ReferenceName('fielder2Lineups')
  IntColumn get fielder2Id => integer().references(Players, #id)();

  @ReferenceName('fielder3Lineups')
  IntColumn get fielder3Id => integer().references(Players, #id)();
}
