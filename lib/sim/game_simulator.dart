import 'dart:math';

import 'at_bat.dart';
import 'ball_in_play.dart';
import 'box_score.dart';
import 'lineup.dart';
import 'sim_player.dart';

class _TeamState {
  final Lineup lineup;
  int battingIndex = 0;
  int score = 0;

  _TeamState(this.lineup);
}

/// Simulates a full game between [home] and [away] under the MLW Cultz
/// Field ruleset (rules-mlw-cultz-field.md): 3 innings/3 outs, mercy rule
/// (half-inning ends once the batting team's 6th run of the inning scores,
/// innings 1-2 only), extra innings with standard walk-off handling, and
/// no-re-entry pitching (structurally enforced by [Lineup]).
///
/// Baserunning is deliberately simplified for Phase 1: hits advance every
/// runner a fixed number of bases (no stretch/hold decisions), BIP outs
/// never advance or score a runner (no sac flies), and there are no
/// errors, double plays, or tag-up plays yet — all flagged as later
/// refinements, not required for the engine to be believable per the PRD's
/// validation-harness bar.
GameResult simulateGame({
  required Lineup home,
  required Lineup away,
  required Map<int, SimPlayer> players,
  Random? random,
}) {
  final rng = random ?? Random();
  final box = BoxScore();
  final homeState = _TeamState(home);
  final awayState = _TeamState(away);
  final battersFaced = <int, int>{};

  int? leadTeamId;
  int? leadPitcherId;
  int? trailPitcherId;

  void trackLead(int inning) {
    int? newLeader;
    if (homeState.score > awayState.score) {
      newLeader = home.teamId;
    } else if (awayState.score > homeState.score) {
      newLeader = away.teamId;
    }
    if (newLeader != null && newLeader != leadTeamId) {
      leadTeamId = newLeader;
      if (newLeader == home.teamId) {
        leadPitcherId = home.pitcherForInning(inning);
        trailPitcherId = away.pitcherForInning(inning);
      } else {
        leadPitcherId = away.pitcherForInning(inning);
        trailPitcherId = home.pitcherForInning(inning);
      }
    } else if (newLeader == null) {
      leadTeamId = null;
    }
  }

  final homeInningRuns = <int>[];
  final awayInningRuns = <int>[];

  var inning = 1;
  while (true) {
    awayInningRuns.add(_playHalfInning(
      inning: inning,
      batting: awayState,
      fielding: homeState,
      players: players,
      box: box,
      battersFaced: battersFaced,
      rng: rng,
      mercyCap: inning <= 2 ? 6 : null,
      onScoreChange: () => trackLead(inning),
    ));

    if (inning >= 3 && homeState.score > awayState.score) {
      // Home already ahead after the top half — no need for the bottom.
      break;
    }

    homeInningRuns.add(_playHalfInning(
      inning: inning,
      batting: homeState,
      fielding: awayState,
      players: players,
      box: box,
      battersFaced: battersFaced,
      rng: rng,
      mercyCap: inning <= 2 ? 6 : null,
      onScoreChange: () => trackLead(inning),
      walkoffIfAhead: inning >= 3,
    ));

    if (inning >= 3 && homeState.score != awayState.score) {
      break;
    }
    inning++;
  }

  final winningTeamId = leadTeamId;
  final winningPitcherId = leadPitcherId;
  final losingPitcherId = trailPitcherId;
  int? savePitcherId;

  if (winningTeamId != null && winningPitcherId != null) {
    final winningLineup = winningTeamId == home.teamId ? home : away;
    final finisherId = winningLineup.pitcherForInning(inning);
    final margin = (homeState.score - awayState.score).abs();
    if (finisherId != winningPitcherId && margin >= 1 && margin <= 3) {
      savePitcherId = finisherId;
    }
  }

  if (winningPitcherId != null) {
    final winningTeamId0 = leadTeamId == home.teamId ? home.teamId : away.teamId;
    box.pitchingFor(winningPitcherId, winningTeamId0).w++;
  }
  if (losingPitcherId != null) {
    final losingTeamId = leadTeamId == home.teamId ? away.teamId : home.teamId;
    box.pitchingFor(losingPitcherId, losingTeamId).l++;
  }
  if (savePitcherId != null) {
    final winningTeamId0 = leadTeamId == home.teamId ? home.teamId : away.teamId;
    box.pitchingFor(savePitcherId, winningTeamId0).s++;
  }

  for (final lineup in [home, away]) {
    if (lineup.pitcherPlan.length == 1) {
      final line = box.pitching[lineup.pitcherPlan.first.playerId];
      if (line != null) line.cg = true;
    }
  }

  return GameResult(
    homeTeamId: home.teamId,
    awayTeamId: away.teamId,
    homeScore: homeState.score,
    awayScore: awayState.score,
    inningsPlayed: inning,
    boxScore: box,
    homeInningRuns: homeInningRuns,
    awayInningRuns: awayInningRuns,
    winningPitcherId: winningPitcherId,
    losingPitcherId: losingPitcherId,
    savePitcherId: savePitcherId,
  );
}

SimPlayer _pickFielder(List<SimPlayer> fielders, Random rng) {
  final totalWeight = fielders.fold<int>(0, (sum, f) => sum + f.range);
  if (totalWeight <= 0) return fielders[rng.nextInt(fielders.length)];
  var roll = rng.nextInt(totalWeight);
  for (final f in fielders) {
    if (roll < f.range) return f;
    roll -= f.range;
  }
  return fielders.last;
}

int _playHalfInning({
  required int inning,
  required _TeamState batting,
  required _TeamState fielding,
  required Map<int, SimPlayer> players,
  required BoxScore box,
  required Map<int, int> battersFaced,
  required Random rng,
  required int? mercyCap,
  required void Function() onScoreChange,
  bool walkoffIfAhead = false,
}) {
  var outs = 0;
  var runsThisHalfInning = 0;
  // bases[0]=1B, bases[1]=2B, bases[2]=3B; value is the occupying playerId.
  var bases = List<int?>.filled(3, null);

  void scoreRun(int runnerId, SimPlayer pitcher, {required bool rbi, required int? batterId}) {
    box.battingFor(runnerId, batting.lineup.teamId).r++;
    final pitchLine = box.pitchingFor(pitcher.id, fielding.lineup.teamId);
    pitchLine.r++;
    pitchLine.er++; // no error modeling yet in Phase 1 — every run is earned
    if (rbi && batterId != null) {
      box.battingFor(batterId, batting.lineup.teamId).rbi++;
    }
    batting.score++;
    runsThisHalfInning++;
    onScoreChange();
  }

  while (outs < 3) {
    final batterId = batting.lineup.battingOrder[batting.battingIndex % batting.lineup.battingOrder.length];
    batting.battingIndex++;
    final batter = players[batterId]!;

    final pitcherId = fielding.lineup.pitcherForInning(inning);
    final pitcher = players[pitcherId]!;
    final fielderIds = fielding.lineup.fieldersForInning(inning);
    final fielders = fielderIds.map((id) => players[id]!).toList();

    final facedSoFar = battersFaced[pitcherId] ?? 0;
    battersFaced[pitcherId] = facedSoFar + 1;

    final battingLine = box.battingFor(batterId, batting.lineup.teamId);
    battingLine.gs = true;
    battingLine.pa++;

    final pitchingLine = box.pitchingFor(pitcherId, fielding.lineup.teamId);
    pitchingLine.gs = pitchingLine.gs || pitcherId == fielding.lineup.pitcherPlan.first.playerId;

    final result = simulateAtBat(
      batter: batter,
      pitcher: pitcher,
      pitcherBattersFacedSoFar: facedSoFar,
      rng: rng,
    );

    switch (result.outcome) {
      case AtBatOutcome.walk:
        battingLine.bb++;
        pitchingLine.bb++;
        final onFirst = bases[0];
        final onSecond = bases[1];
        final onThird = bases[2];
        var newSecond = onSecond;
        var newThird = onThird;
        if (onFirst != null) {
          if (onSecond != null) {
            if (onThird != null) {
              scoreRun(onThird, pitcher, rbi: true, batterId: batterId);
            }
            newThird = onSecond;
          }
          newSecond = onFirst;
        }
        bases = [batterId, newSecond, newThird];

      case AtBatOutcome.strikeout:
        battingLine.ab++;
        battingLine.k++;
        pitchingLine.k++;
        pitchingLine.outsRecorded++;
        outs++;
        final pitcherFieldLine = box.fieldingFor(pitcherId, fielding.lineup.teamId);
        pitcherFieldLine.tc++;
        pitcherFieldLine.po++;
        for (final f in fielders) {
          box.fieldingFor(f.id, fielding.lineup.teamId).outsPlayed++;
        }

      case AtBatOutcome.ballInPlay:
        battingLine.ab++;
        final bip = resolveBallInPlay(batter: batter, fielders: fielders, rng: rng);

        if (bip == BipOutcome.out) {
          pitchingLine.outsRecorded++;
          outs++;
          final fielder = _pickFielder(fielders, rng);
          final fieldLine = box.fieldingFor(fielder.id, fielding.lineup.teamId);
          fieldLine.tc++;
          fieldLine.po++;
          for (final f in fielders) {
            box.fieldingFor(f.id, fielding.lineup.teamId).outsPlayed++;
          }
        } else {
          pitchingLine.h++;
          battingLine.h++;
          final basesToAdvance = switch (bip) {
            BipOutcome.single => 1,
            BipOutcome.twoBase => 2,
            BipOutcome.threeBase => 3,
            BipOutcome.homeRun => 4,
            BipOutcome.out => 0, // unreachable
          };
          switch (bip) {
            case BipOutcome.twoBase:
              battingLine.doubles++;
            case BipOutcome.threeBase:
              battingLine.triples++;
            case BipOutcome.homeRun:
              battingLine.hr++;
            case BipOutcome.single:
            case BipOutcome.out:
              break;
          }

          final runners = [bases[0], bases[1], bases[2]];
          bases = List<int?>.filled(3, null);
          for (var i = 0; i < 3; i++) {
            final runner = runners[i];
            if (runner == null) continue;
            final newBase = (i + 1) + basesToAdvance;
            if (newBase >= 4) {
              scoreRun(runner, pitcher, rbi: true, batterId: batterId);
            } else {
              bases[newBase - 1] = runner;
            }
          }
          if (basesToAdvance >= 4) {
            scoreRun(batterId, pitcher, rbi: true, batterId: batterId);
          } else {
            bases[basesToAdvance - 1] = batterId;
          }
        }
    }

    if (outs >= 3) break;
    if (mercyCap != null && runsThisHalfInning >= mercyCap) break;
    if (walkoffIfAhead && batting.score > fielding.score) break;
  }

  return runsThisHalfInning;
}
