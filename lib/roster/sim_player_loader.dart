import 'package:wballmgr/data/database.dart';
import 'package:wballmgr/sim/sim_player.dart';

/// Reads Players + PlayerPitches for [teamIds] and builds the
/// `Map<int, SimPlayer>` lib/sim/game_simulator.dart's `simulateGame` needs —
/// the reverse of this package's roster_writer.dart's generation-time write.
/// Lives in lib/roster/ (not lib/league/, where it was originally added)
/// so both lib/league/game_runner.dart (actually playing a game) and
/// lib/ai/ (true-rating-visibility lineup/rotation AI) can depend on it
/// without lib/ai/ importing lib/league/ and creating an import cycle
/// (lib/league/game_runner.dart already imports lib/ai/team_manager.dart).
Future<Map<int, SimPlayer>> loadSimPlayers(AppDatabase db, {required List<int> teamIds}) async {
  final playerRows = await (db.select(db.players)..where((p) => p.teamId.isIn(teamIds))).get();
  final playerIds = playerRows.map((p) => p.id).toList();

  final pitchRows = playerIds.isEmpty
      ? <PlayerPitche>[]
      : await (db.select(db.playerPitches)..where((pp) => pp.playerId.isIn(playerIds))).get();

  final repertoireByPlayer = <int, List<SimPitch>>{};
  for (final row in pitchRows) {
    repertoireByPlayer
        .putIfAbsent(row.playerId, () => [])
        .add(SimPitch(type: row.pitchType, movement: row.movement));
  }

  return {
    for (final p in playerRows)
      p.id: SimPlayer(
        id: p.id,
        name: '${p.firstName} ${p.lastName}',
        contact: p.contact,
        power: p.power,
        discipline: p.discipline,
        speed: p.speed,
        control: p.control,
        stamina: p.stamina,
        repertoire: repertoireByPlayer[p.id] ?? const [],
        range: p.range,
        hands: p.hands,
        arm: p.arm,
      ),
  };
}
