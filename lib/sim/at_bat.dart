import 'dart:math';

import 'fatigue.dart';
import 'pitch_selection.dart';
import 'probability.dart';
import 'sim_player.dart';

enum AtBatOutcome { walk, strikeout, ballInPlay }

class AtBatResult {
  final AtBatOutcome outcome;
  final int pitches;

  const AtBatResult({required this.outcome, required this.pitches});
}

// Baseline log-odds at rating 50 vs 50 (no fatigue), derived by
// tool/calibrate_at_bat.dart so that two average opponents reproduce the
// per-PA split from rules-mlw-cultz-field.md's Statistical Calibration
// section: BB 28.3%, K 40.9%, BIP 30.8% (DP-verified: 28.30%/40.90%/30.80%).
const double _zoneLogitBase = 0.000583;
const double _whiffLogitBase = 1.766826;

// Sensitivity of each probability to a rating moving away from 50. Weight
// 1.0 means a maximal rating swing (0 or 99) shifts the logit by ~+/-2.45,
// which is enough to push the corresponding probability from ~50% to the
// 8-92% range — a wide, non-linear spread toward the extremes, per
// context/player-ratings.md's calibration note. Exact values are tunable;
// not a product-level decision.
const double _controlWeight = 1.0;
const double _disciplineWeight = 1.0;
const double _movementWeight = 1.0;
const double _contactWeight = 1.0;

/// Simulates one plate appearance pitch-by-pitch: each pitch is drawn from
/// the pitcher's repertoire (see selectPitch) and resolves to a ball,
/// strike, or ball put in play, until the count reaches a walk (4 balls),
/// strikeout (3 strikes), or the first in-play pitch. There's no modeled
/// foul-ball state — rules-mlw-cultz-field.md doesn't specify one, so a
/// contacted strike always ends the at-bat (goes to ball-in-play
/// resolution) rather than fouling off.
AtBatResult simulateAtBat({
  required SimPlayer batter,
  required SimPlayer pitcher,
  required int pitcherBattersFacedSoFar,
  required Random rng,
}) {
  var balls = 0;
  var strikes = 0;
  var pitches = 0;

  final fatigueDecay = Fatigue.decay(pitcher.stamina, pitcherBattersFacedSoFar);
  final effectiveControl = max(1, pitcher.control - fatigueDecay);

  while (true) {
    pitches++;
    final pitch = selectPitch(pitcher, rng);
    final effectiveMovement = max(1, pitch.movement - fatigueDecay);

    // P(this pitch becomes a "strike-pool" event — called strike or
    // contact — rather than a ball): rises with pitcher Control, falls
    // with batter Discipline (laying off borderline pitches).
    final pStrikeEvent = clampProbability(sigmoid(
      _zoneLogitBase +
          _controlWeight * ratingEdge(effectiveControl) -
          _disciplineWeight * ratingEdge(batter.discipline),
    ));

    // P(whiff | strike-pool event): rises with the thrown pitch's
    // Movement, falls with batter Contact.
    final pWhiffGivenStrike = clampProbability(sigmoid(
      _whiffLogitBase +
          _movementWeight * ratingEdge(effectiveMovement) -
          _contactWeight * ratingEdge(batter.contact),
    ));

    final roll = rng.nextDouble();
    if (roll >= pStrikeEvent) {
      balls++;
      if (balls == 4) {
        return AtBatResult(outcome: AtBatOutcome.walk, pitches: pitches);
      }
    } else if (roll < pStrikeEvent * pWhiffGivenStrike) {
      strikes++;
      if (strikes == 3) {
        return AtBatResult(outcome: AtBatOutcome.strikeout, pitches: pitches);
      }
    } else {
      return AtBatResult(outcome: AtBatOutcome.ballInPlay, pitches: pitches);
    }
  }
}
