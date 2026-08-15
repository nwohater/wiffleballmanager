import 'package:drift/drift.dart';

import 'package:wballmgr/data/database.dart';
import 'package:wballmgr/data/enums.dart';
import 'package:wballmgr/sim/lineup.dart';

import 'roster_generator.dart';
import 'roster_rules.dart';

/// Inserts a freshly generated roster (Players + PlayerPitches) for
/// [teamId]/[organizationId] and writes its default [TeamLineups] row
/// (see [defaultLineupFor]). Returns the inserted player ids in the same
/// order as [players].
Future<List<int>> writeGeneratedRoster(
  AppDatabase db, {
  required int teamId,
  required int organizationId,
  required List<GeneratedPlayer> players,
}) async {
  final selection = defaultLineupFor(players);

  return db.transaction(() async {
    final ids = <int>[];
    for (var i = 0; i < players.length; i++) {
      final p = players[i];
      final id = await db.into(db.players).insert(PlayersCompanion.insert(
            organizationId: Value(organizationId),
            teamId: Value(teamId),
            rosterSlot: const Value(RosterSlot.active),
            firstName: p.firstName,
            lastName: p.lastName,
            age: p.age,
            contact: p.contact,
            power: p.power,
            discipline: p.discipline,
            speed: p.speed,
            control: p.control,
            stamina: p.stamina,
            range: p.range,
            hands: p.hands,
            arm: p.arm,
            battingPotential: p.battingPotential,
            pitchingPotential: p.pitchingPotential,
            fieldingPotential: p.fieldingPotential,
            speedPotential: p.speedPotential,
          ));
      ids.add(id);
      for (final pitch in p.repertoire) {
        await db.into(db.playerPitches).insert(PlayerPitchesCompanion.insert(
              playerId: id,
              pitchType: pitch.type,
              movement: pitch.movement,
            ));
      }
    }

    await db.into(db.teamLineups).insert(TeamLineupsCompanion.insert(
          teamId: teamId,
          battingOrder: selection.battingOrderIndices.map((i) => ids[i]).join(','),
          pitcherRotation: selection.pitcherRotationIndices.map((i) => ids[i]).join(','),
          fielder2Id: ids[selection.fielder2Index],
          fielder3Id: ids[selection.fielder3Index],
        ));

    return ids;
  });
}

/// Inserts unrostered free agents (Players + PlayerPitches only — no
/// TeamLineups row, since they belong to no team) for the standing
/// free-agent pool. Returns the inserted player ids.
Future<List<int>> writeFreeAgentPool(AppDatabase db, List<GeneratedPlayer> players) {
  return db.transaction(() async {
    final ids = <int>[];
    for (final p in players) {
      final id = await db.into(db.players).insert(PlayersCompanion.insert(
            firstName: p.firstName,
            lastName: p.lastName,
            age: p.age,
            contact: p.contact,
            power: p.power,
            discipline: p.discipline,
            speed: p.speed,
            control: p.control,
            stamina: p.stamina,
            range: p.range,
            hands: p.hands,
            arm: p.arm,
            battingPotential: p.battingPotential,
            pitchingPotential: p.pitchingPotential,
            fieldingPotential: p.fieldingPotential,
            speedPotential: p.speedPotential,
          ));
      ids.add(id);
      for (final pitch in p.repertoire) {
        await db.into(db.playerPitches).insert(PlayerPitchesCompanion.insert(
              playerId: id,
              pitchType: pitch.type,
              movement: pitch.movement,
            ));
      }
    }
    return ids;
  });
}

/// Inserts a single drafted player (Players + PlayerPitches) as "org
/// depth" — [organizationId] set, `teamId`/`rosterSlot` left null. Not yet on
/// a major roster: this sim has no minor-league tier to place them on yet
/// (Phase 7's todo note "Minor roster population: draft overflow + org
/// depth signings" is the intended eventual home). Distinct from a true free
/// agent (org null too) — see lib/career/free_agents.dart's org-unaffiliated
/// filtering. Returns the inserted player id.
Future<int> writeDraftedPlayer(
  AppDatabase db, {
  required int organizationId,
  required GeneratedPlayer player,
}) {
  return db.transaction(() async {
    final id = await db.into(db.players).insert(PlayersCompanion.insert(
          organizationId: Value(organizationId),
          firstName: player.firstName,
          lastName: player.lastName,
          age: player.age,
          contact: player.contact,
          power: player.power,
          discipline: player.discipline,
          speed: player.speed,
          control: player.control,
          stamina: player.stamina,
          range: player.range,
          hands: player.hands,
          arm: player.arm,
          battingPotential: player.battingPotential,
          pitchingPotential: player.pitchingPotential,
          fieldingPotential: player.fieldingPotential,
          speedPotential: player.speedPotential,
        ));
    for (final pitch in player.repertoire) {
      await db.into(db.playerPitches).insert(PlayerPitchesCompanion.insert(
            playerId: id,
            pitchType: pitch.type,
            movement: pitch.movement,
          ));
    }
    return id;
  });
}

/// Reads a team's full roster as [RosterMember]s (validation-facing shape).
Future<List<RosterMember>> readTeamRoster(AppDatabase db, int teamId) async {
  final rows = await (db.select(db.players)..where((p) => p.teamId.equals(teamId))).get();
  return [
    for (final row in rows)
      if (row.rosterSlot != null) RosterMember(playerId: row.id, slot: row.rosterSlot!),
  ];
}

List<int> _parseIds(String csv) => csv.isEmpty ? [] : csv.split(',').map(int.parse).toList();

/// Validates the proposed lineup against [roster_rules.dart] and, if valid,
/// upserts the team's [TeamLineups] row. Throws [ArgumentError] with the
/// joined violation messages if validation fails — callers that want live
/// inline feedback instead should run the roster_rules functions directly.
Future<void> saveTeamLineup(
  AppDatabase db, {
  required int teamId,
  required List<int> battingOrder,
  required List<int> pitcherRotation,
  required int fielder2Id,
  required int fielder3Id,
}) async {
  final roster = await readTeamRoster(db, teamId);

  final errors = [
    ...validateRosterComposition(roster),
    ...validateBattingOrder(battingOrder, roster),
    ...validatePitcherRotation(pitcherRotation, battingOrder, roster),
    ...validateFielders(fielder2Id, fielder3Id, pitcherRotation, roster),
  ];
  if (errors.isNotEmpty) {
    throw ArgumentError(errors.join(' '));
  }

  final companion = TeamLineupsCompanion.insert(
    teamId: teamId,
    battingOrder: battingOrder.join(','),
    pitcherRotation: pitcherRotation.join(','),
    fielder2Id: fielder2Id,
    fielder3Id: fielder3Id,
  );
  final existing = await (db.select(db.teamLineups)..where((t) => t.teamId.equals(teamId))).getSingleOrNull();
  if (existing == null) {
    await db.into(db.teamLineups).insert(companion);
  } else {
    await (db.update(db.teamLineups)..where((t) => t.teamId.equals(teamId))).write(companion);
  }
}

/// Builds a sim-engine-facing [Lineup] from a team's saved [TeamLineup] row.
/// The pitcher rotation is order-only (see team_lineups.dart) — for now
/// this uses a single open-ended stint for the first entry, matching Phase
/// 1's documented common case of one starter going the whole game. Turning
/// the rest of the rotation into innings-cutoff stints is bullpen
/// management, deferred to Phase 5.
Lineup buildSimLineup(TeamLineup row) {
  final pitcherIds = _parseIds(row.pitcherRotation);
  return Lineup(
    teamId: row.teamId,
    battingOrder: _parseIds(row.battingOrder),
    pitcherPlan: [PitcherStint(playerId: pitcherIds.first)],
    fielder2Id: row.fielder2Id,
    fielder3Id: row.fielder3Id,
  );
}
