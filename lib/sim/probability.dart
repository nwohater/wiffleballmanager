import 'dart:math';

/// Maps a 0-99 rating to a signed "edge" around the league-average anchor
/// of 50 for use as logistic-curve input. Dividing by 20 keeps a maximal
/// deviation (rating 0 or 99) at roughly +/-2.5, which — run through
/// [sigmoid] — produces the wide, non-linear spread toward the extremes
/// that context/player-ratings.md's calibration section calls for, rather
/// than a straight linear scaling.
double ratingEdge(int rating, {int baseline = 50}) => (rating - baseline) / 20.0;

double sigmoid(double x) => 1 / (1 + exp(-x));

/// Inverse of [sigmoid] — used offline to turn a target baseline
/// probability into the logit constant sigmoid() expects.
double logit(double p) => log(p / (1 - p));

/// Keeps a probability strictly inside (0,1) so downstream sampling never
/// hits a hard 0%/100% even at extreme ratings.
double clampProbability(double p) => p.clamp(0.001, 0.999);
