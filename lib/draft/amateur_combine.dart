import 'dart:math';

import 'package:wballmgr/ai/observed_stats.dart';
import 'package:wballmgr/roster/roster_generator.dart';
import 'package:wballmgr/sim/box_score.dart';
import 'package:wballmgr/sim/game_simulator.dart';
import 'package:wballmgr/sim/lineup.dart';
import 'package:wballmgr/sim/sim_player.dart';
import 'package:wballmgr/trade/trade_manager.dart' show playerTradeValue;

/// How many scrimmage squads the draft pool is split into, and how many
/// prospects per squad — 6 is [defaultLineupFor]'s required roster size, so
/// each squad can use the same starter/battingOrder/fielder selection a real
/// roster's opening lineup would. Pool size (36) comfortably exceeds the
/// draft's 24 total picks (lib/draft/draft_manager.dart's `draftRounds` x
/// 12 teams), so "best prospect available" is a real choice, not a
/// rubber-stamp.
const int amateurTeamCount = 6;
const int playersPerAmateurTeam = 6;

/// Each pair of amateur teams scrimmages this many times — with
/// [amateurTeamCount] teams, every squad faces the other 5 this many times
/// each, for `gamesPerPairing * (amateurTeamCount - 1)` games per team (6 x 5
/// = 30) — a large enough sample that the resulting stats are a meaningful
/// signal rather than small-sample noise (same concern
/// lib/ai/observed_stats.dart's neutral-placeholder handling exists for).
const int gamesPerPairing = 6;

/// One prospect available to be drafted: the true-rating [GeneratedPlayer]
/// (only ever persisted to the database if actually picked — see
/// lib/roster/roster_writer.dart's `writeDraftedPlayer`) plus the stat line
/// they produced in the pre-draft scrimmage slate, scored the same
/// observed-stats-only way lib/ai/team_manager.dart's baseline AI already
/// scores established players — "amateur stats" standing in for a season's
/// worth of pro track record that doesn't exist yet.
class Prospect {
  final GeneratedPlayer player;
  final ObservedPlayerStats amateurStats;

  const Prospect({required this.player, required this.amateurStats});
}

class _ProspectTotals {
  int pa = 0, ab = 0, h = 0, doubles = 0, triples = 0, hr = 0, bb = 0, hbp = 0, sf = 0;
  int outsRecorded = 0, er = 0, pBb = 0, pH = 0;
  int chances = 0, e = 0;

  void addBatting(BattingLine l) {
    pa += l.pa;
    ab += l.ab;
    h += l.h;
    doubles += l.doubles;
    triples += l.triples;
    hr += l.hr;
    bb += l.bb;
    hbp += l.hbp;
    sf += l.sf;
  }

  void addPitching(PitchingLine l) {
    outsRecorded += l.outsRecorded;
    er += l.er;
    pBb += l.bb;
    pH += l.h;
  }

  void addFielding(FieldingLine l) {
    chances += l.tc;
    e += l.e;
  }

  ObservedPlayerStats toObservedStats(int playerId) => statsFromTotals(
        playerId: playerId,
        pa: pa,
        ab: ab,
        h: h,
        doubles: doubles,
        triples: triples,
        hr: hr,
        bb: bb,
        hbp: hbp,
        sf: sf,
        outsRecorded: outsRecorded,
        er: er,
        pitchingBb: pBb,
        pitchingH: pH,
        chances: chances,
        e: e,
      );
}

/// Generates a fresh draft pool ([generateDraftClass]), splits it into
/// [amateurTeamCount] 6-player scrimmage squads (each squad's
/// starter/lineup/fielders picked via [defaultLineupFor], same as a real
/// roster's opening day default), and simulates a full round-robin slate
/// between them purely in memory via [simulateGame] — no Games/Standings/
/// Players rows are ever written for this (it's a pre-draft "combine," not a
/// real season; see [Prospect]'s doc comment). Returns every prospect with
/// their simulated stat line, in no particular order — callers rank them.
List<Prospect> runAmateurCombine(Random rng) {
  final pool = generateDraftClass(rng, count: amateurTeamCount * playersPerAmateurTeam);

  final simPlayers = <int, SimPlayer>{};
  final teamLineups = <Lineup>[];

  int idFor(int teamIndex, int localIndex) => teamIndex * playersPerAmateurTeam + localIndex;

  for (var t = 0; t < amateurTeamCount; t++) {
    final squad = pool.sublist(t * playersPerAmateurTeam, (t + 1) * playersPerAmateurTeam);
    final selection = defaultLineupFor(squad);

    for (var i = 0; i < squad.length; i++) {
      final p = squad[i];
      simPlayers[idFor(t, i)] = SimPlayer(
        id: idFor(t, i),
        name: '${p.firstName} ${p.lastName}',
        contact: p.contact,
        power: p.power,
        discipline: p.discipline,
        speed: p.speed,
        control: p.control,
        stamina: p.stamina,
        repertoire: p.repertoire,
        range: p.range,
        hands: p.hands,
        arm: p.arm,
      );
    }

    teamLineups.add(Lineup(
      teamId: t,
      battingOrder: selection.battingOrderIndices.map((i) => idFor(t, i)).toList(),
      pitcherPlan: [PitcherStint(playerId: idFor(t, selection.pitcherRotationIndices.single))],
      fielder2Id: idFor(t, selection.fielder2Index),
      fielder3Id: idFor(t, selection.fielder3Index),
    ));
  }

  final totals = {for (final id in simPlayers.keys) id: _ProspectTotals()};

  for (var a = 0; a < amateurTeamCount; a++) {
    for (var b = a + 1; b < amateurTeamCount; b++) {
      for (var g = 0; g < gamesPerPairing; g++) {
        final result = simulateGame(
          home: teamLineups[a],
          away: teamLineups[b],
          players: simPlayers,
          random: rng,
        );
        for (final line in result.boxScore.batting.values) {
          totals[line.playerId]!.addBatting(line);
        }
        for (final line in result.boxScore.pitching.values) {
          totals[line.playerId]!.addPitching(line);
        }
        for (final line in result.boxScore.fielding.values) {
          totals[line.playerId]!.addFielding(line);
        }
      }
    }
  }

  return [
    for (var t = 0; t < amateurTeamCount; t++)
      for (var i = 0; i < playersPerAmateurTeam; i++)
        Prospect(
          player: pool[idFor(t, i)],
          amateurStats: totals[idFor(t, i)]!.toObservedStats(idFor(t, i)),
        ),
  ];
}

/// [prospects] ranked best-to-worst by [playerTradeValue] on their
/// [Prospect.amateurStats] — the same stat-based value function AI trade
/// evaluation uses (lib/trade/trade_manager.dart), applied here to amateur
/// scrimmage stats instead of a season's real ones. This is the "AI draft
/// logic" itself: stat-oriented, not true-rating scouting. Pure — kept
/// separate from lib/draft/draft_manager.dart's `runDraft` so the ranking
/// rule is unit-testable without a database.
List<Prospect> rankProspectsByValue(List<Prospect> prospects) => List<Prospect>.of(prospects)
  ..sort((a, b) => playerTradeValue(b.amateurStats).compareTo(playerTradeValue(a.amateurStats)));
