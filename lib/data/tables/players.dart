import 'package:drift/drift.dart';

import '../enums.dart';
import 'organizations.dart';
import 'teams.dart';

/// True ratings (0-99) live here and drive the sim engine, but per the
/// Hidden Ratings model they are never shown to the player directly — the
/// UI only ever surfaces observed stats aggregated from BattingStats /
/// PitchingStats / FieldingStats rows. Every player carries all three
/// rating groups (batting, pitching, fielding); a "one-way" player is
/// simply weak in the groups they don't play, not missing them.
class Players extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Null when a free agent (unsigned / cut, per Draft & Trades rules).
  IntColumn get organizationId =>
      integer().nullable().references(Organizations, #id)();

  /// Null when not currently on a roster (free agent).
  IntColumn get teamId => integer().nullable().references(Teams, #id)();

  IntColumn get rosterSlot => intEnum<RosterSlot>().nullable()();

  TextColumn get firstName => text().withLength(min: 1, max: 64)();

  TextColumn get lastName => text().withLength(min: 1, max: 64)();

  IntColumn get age => integer()();

  // -- Batting --
  IntColumn get contact => integer()();
  IntColumn get power => integer()();
  IntColumn get discipline => integer()();

  // -- Speed (baserunning only; no stealing in this ruleset) --
  IntColumn get speed => integer()();

  // -- Pitching (repertoire/Movement lives in PlayerPitches) --
  IntColumn get control => integer()();
  IntColumn get stamina => integer()();

  // -- Fielding --
  IntColumn get range => integer()();
  IntColumn get hands => integer()();
  IntColumn get arm => integer()();

  // -- Career progression (Phase 4) --
  /// Hidden per-cluster ceilings (0-99) assigned at generation time; ratings
  /// grow toward these and never exceed them. See context/player-ratings.md
  /// "Career Progression: Potential & Aging".
  IntColumn get battingPotential => integer()();
  IntColumn get pitchingPotential => integer()();
  IntColumn get fieldingPotential => integer()();
  IntColumn get speedPotential => integer()();

  /// Games remaining before this player is available again (0 = healthy).
  IntColumn get gamesUnavailable => integer().withDefault(const Constant(0))();
}
