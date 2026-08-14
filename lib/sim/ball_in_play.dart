import 'dart:math';

import 'probability.dart';
import 'sim_player.dart';

enum BipOutcome { out, single, twoBase, threeBase, homeRun }

// Baseline (rating 50 batter vs. rating-50-average 3-player defense)
// probabilities of each outcome given a ball is in play, derived from
// rules-mlw-cultz-field.md's Statistical Calibration section:
//   Hit rate 15.6% of PA, XBH (2B+3B+HR) rate 5.3% of PA, HR rate 4.9% of
//   PA, over a BIP rate of 30.8% of PA.
// -> P(Out|BIP)=0.4935, P(1B|BIP)=0.3344, P(2B+3B|BIP)=0.01299,
//    P(HR|BIP)=0.15909 (2B/3B split 85/15 is an assumption — the source
//    data doesn't break the combined 0.4%-of-PA figure down further).
const double _outLogitBase = -0.026005;
const double _hrLogitBase = -0.78103;
const double _xbhLogitBase = -3.24924;
const double _doubleShareOfXbh = 0.85;

const double _defenseWeight = 1.0;
const double _powerWeight = 1.0;
const double _armWeight = 1.0;

/// Aggregate fielding quality of the 3 defenders on the field for this
/// play. Only 3 defenders cover the whole field under this ruleset, so a
/// simple average (rather than positional assignment) is the Phase 1
/// approximation — see context/player-ratings.md.
class DefenseProfile {
  final int rangeHands;
  final int arm;

  const DefenseProfile({required this.rangeHands, required this.arm});

  factory DefenseProfile.fromFielders(List<SimPlayer> fielders) {
    assert(fielders.length == 3, 'Exactly 3 defenders are on the field');
    final rangeHands =
        fielders.map((f) => (f.range + f.hands) / 2).reduce((a, b) => a + b) / fielders.length;
    final arm = fielders.map((f) => f.arm).reduce((a, b) => a + b) / fielders.length;
    return DefenseProfile(rangeHands: rangeHands.round(), arm: arm.round());
  }
}

/// Resolves a ball put in play into an out or a hit type. Out-vs-hit is
/// driven by batter Power against the defense's Range/Hands; hit type
/// (single/double/triple/HR) is driven by Power against the defense's Arm
/// (a stand-in for outfield containment, since Arm can't stop a ball that
/// clears the fence but plausibly suppresses how often a well-hit ball
/// turns into extra bases rather than a single).
///
/// Batter Speed's role in stretching a hit into an extra base is not
/// modeled in Phase 1 — flagged as a deferred refinement, same as
/// tag-up/double-play mechanics.
BipOutcome resolveBallInPlay({
  required SimPlayer batter,
  required List<SimPlayer> fielders,
  required Random rng,
}) {
  final defense = DefenseProfile.fromFielders(fielders);

  final pOut = clampProbability(sigmoid(
    _outLogitBase + _defenseWeight * ratingEdge(defense.rangeHands) - _powerWeight * ratingEdge(batter.power),
  ));
  if (rng.nextDouble() < pOut) return BipOutcome.out;

  final pHrGivenHit = clampProbability(sigmoid(
    _hrLogitBase + _powerWeight * ratingEdge(batter.power) - _armWeight * ratingEdge(defense.arm),
  ));
  if (rng.nextDouble() < pHrGivenHit) return BipOutcome.homeRun;

  final pXbhGivenHitNotHr = clampProbability(sigmoid(
    _xbhLogitBase + _powerWeight * ratingEdge(batter.power) - _armWeight * ratingEdge(defense.arm),
  ));
  if (rng.nextDouble() < pXbhGivenHitNotHr) {
    return rng.nextDouble() < _doubleShareOfXbh ? BipOutcome.twoBase : BipOutcome.threeBase;
  }

  return BipOutcome.single;
}
