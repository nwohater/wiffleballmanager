import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:wballmgr/data/enums.dart';
import 'package:wballmgr/sim/game_simulator.dart';
import 'package:wballmgr/sim/lineup.dart';
import 'package:wballmgr/sim/sim_player.dart';

import 'harness.dart';

SimPlayer _extremePlayer(int id, {required bool offense}) {
  // offense=true: a batter that reaches base far more often than average
  // (high Discipline/Contact/Power). offense=false: a pitcher/defense
  // that gets outs less often than average (low Control/Range/Hands/Arm).
  // Lopsided enough to blow past the mercy cap almost every time it bats,
  // but not so extreme that outs become pathologically rare — GameResult
  // now reports exact per-half-inning runs, so the mercy assertion below
  // checks innings 1-2 directly rather than needing to infer it from PA
  // counts across a whole game.
  return SimPlayer(
    id: id,
    name: 'Extreme $id',
    contact: offense ? 90 : 50,
    power: offense ? 90 : 50,
    discipline: offense ? 90 : 50,
    speed: 50,
    control: offense ? 50 : 15,
    stamina: 50,
    range: offense ? 50 : 15,
    hands: offense ? 50 : 15,
    arm: offense ? 50 : 15,
    repertoire: [SimPitch(type: PitchType.fastball, movement: offense ? 50 : 15)],
  );
}

void main() {
  test('mercy rule caps runs at (or just above) 6 per half-inning through inning 2', () {
    final awayBatters = List.generate(5, (i) => _extremePlayer(i + 1, offense: true));
    final homeDefenders = List.generate(3, (i) => _extremePlayer(100 + i, offense: false));

    final away = Lineup(
      teamId: 2,
      battingOrder: awayBatters.map((p) => p.id).toList(),
      pitcherPlan: [PitcherStint(playerId: awayBatters[0].id)],
      fielder2Id: awayBatters[1].id,
      fielder3Id: awayBatters[2].id,
    );
    final home = Lineup(
      teamId: 1,
      battingOrder: homeDefenders.map((p) => p.id).toList(),
      pitcherPlan: [PitcherStint(playerId: homeDefenders[0].id)],
      fielder2Id: homeDefenders[1].id,
      fielder3Id: homeDefenders[2].id,
    );
    final players = {for (final p in [...awayBatters, ...homeDefenders]) p.id: p};

    var sawMercyEngage = false;
    for (var seed = 0; seed < 50; seed++) {
      final result = simulateGame(home: home, away: away, players: players, random: Random(seed));

      // Innings 1-2: capped at 6, plus up to +4 overshoot from a single
      // bases-loaded-HR play that crosses the cap (max runs before that
      // play is 5, plus a 4-run play = 9).
      for (final runs in result.awayInningRuns.take(2)) {
        expect(runs, lessThanOrEqualTo(9));
        if (runs >= 6) sawMercyEngage = true;
      }
    }

    expect(sawMercyEngage, isTrue);
  });

  test('games are never tied at the final out (extra innings resolve it)', () {
    final rng = Random(99);
    final home = buildSyntheticTeam(1, 1);
    final away = buildSyntheticTeam(2, 100);
    final players = {for (final p in [...home.players, ...away.players]) p.id: p};

    var sawExtraInnings = false;
    for (var i = 0; i < 300; i++) {
      final result = simulateGame(home: home.lineup, away: away.lineup, players: players, random: rng);
      expect(result.homeScore, isNot(equals(result.awayScore)));
      expect(result.inningsPlayed, greaterThanOrEqualTo(3));
      if (result.inningsPlayed > 3) sawExtraInnings = true;
    }
    // League-average rosters score ~2.8 R/team-game — a 3-inning tie
    // should come up somewhere in 300 games.
    expect(sawExtraInnings, isTrue);
  });

  test('no-re-entry: a starter-then-reliever plan credits both pitchers and marks only the starter GS', () {
    final rng = Random(5);
    final away = buildSyntheticTeam(2, 100);
    final homePlayers = List.generate(6, (i) => averagePlayer(1 + i));
    final home = Lineup(
      teamId: 1,
      battingOrder: [for (var i = 0; i < 5; i++) homePlayers[i].id],
      pitcherPlan: [
        PitcherStint(playerId: homePlayers[0].id, throughInning: 1),
        PitcherStint(playerId: homePlayers[3].id),
      ],
      fielder2Id: homePlayers[1].id,
      fielder3Id: homePlayers[2].id,
    );
    final players = {for (final p in [...homePlayers, ...away.players]) p.id: p};

    final result = simulateGame(home: home, away: away.lineup, players: players, random: rng);

    final starterLine = result.boxScore.pitching[homePlayers[0].id];
    final relieverLine = result.boxScore.pitching[homePlayers[3].id];

    expect(starterLine, isNotNull);
    expect(starterLine!.gs, isTrue);
    expect(starterLine.outsRecorded, greaterThan(0));
    expect(relieverLine, isNotNull);
    expect(relieverLine!.gs, isFalse);
    expect(relieverLine.outsRecorded, greaterThan(0));
    expect(starterLine.cg, isFalse);
  });
}
