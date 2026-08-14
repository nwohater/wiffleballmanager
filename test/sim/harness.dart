import 'package:wballmgr/data/enums.dart';
import 'package:wballmgr/sim/lineup.dart';
import 'package:wballmgr/sim/sim_player.dart';

/// A player with every rating at [rating] (50 = league average) and a
/// simple 3-pitch repertoire, all at the same Movement — used to build
/// synthetic "league average" rosters for the validation harness and
/// engine tests, per rules-mlw-cultz-field.md's calibration anchor.
SimPlayer averagePlayer(int id, {int rating = 50, int stamina = 50}) {
  return SimPlayer(
    id: id,
    name: 'Player $id',
    contact: rating,
    power: rating,
    discipline: rating,
    speed: rating,
    control: rating,
    stamina: stamina,
    range: rating,
    hands: rating,
    arm: rating,
    repertoire: [
      SimPitch(type: PitchType.fastball, movement: rating),
      SimPitch(type: PitchType.riser, movement: rating),
      SimPitch(type: PitchType.curveball, movement: rating),
    ],
  );
}

class SyntheticTeam {
  final int teamId;
  final List<SimPlayer> players;
  final Lineup lineup;

  SyntheticTeam(this.teamId, this.players, this.lineup);
}

/// 6 average players: the first 5 bat (batting order), players 0-2 field,
/// player 0 pitches the whole game (single stint — the common case a
/// full-season sim will mostly use until Phase 5's bullpen AI exists).
SyntheticTeam buildSyntheticTeam(int teamId, int startId, {int rating = 50, int stamina = 50}) {
  final players = List.generate(6, (i) => averagePlayer(startId + i, rating: rating, stamina: stamina));
  final lineup = Lineup(
    teamId: teamId,
    battingOrder: [for (var i = 0; i < 5; i++) players[i].id],
    pitcherPlan: [PitcherStint(playerId: players[0].id)],
    fielder2Id: players[1].id,
    fielder3Id: players[2].id,
  );
  return SyntheticTeam(teamId, players, lineup);
}
