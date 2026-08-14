import 'dart:math';

/// Pure per-season rating progression — no drift/database dependency, so it
/// can be unit-tested in isolation. See context/player-ratings.md "Career
/// Progression: Potential & Aging" for the design this implements; numeric
/// constants below are flagged there as uncalibrated starting points.

/// Ages before this grow toward potential; ages after [peakEndAge] decline.
/// 26-29 inclusive is the plateau band in between.
const int peakStartAge = 26;
const int peakEndAge = 29;

/// Fraction of the (potential - rating) gap closed in a single growth
/// season, before playing-time modulation and jitter.
const double growthStepFraction = 0.20;

/// Per-year decay step past [peakEndAge], indexed by years past peak (index
/// 0 = age peakEndAge + 1). Increasing — further past peak declines faster.
const List<int> decaySchedule = [1, 1, 1, 2, 2, 2, 3, 3, 3, 4];

/// Random jitter applied every season, on top of any directional move —
/// uniformly drawn from [-jitterMagnitude, jitterMagnitude].
const int jitterMagnitude = 4;

/// How much of a full season's playing time a player actually got,
/// clamped to [0.2, 1.1] — a benched player still develops (never fully
/// frozen) but slower, and heavy usage can modestly outpace the baseline.
double playingTimeFactor({required int actualUsage, required int fullSeasonBaseline}) {
  if (fullSeasonBaseline <= 0) return 0.2;
  final raw = actualUsage / fullSeasonBaseline;
  return raw.clamp(0.2, 1.1);
}

int _decayStepFor(int age) {
  final yearsPastPeak = age - peakEndAge - 1;
  final idx = yearsPastPeak.clamp(0, decaySchedule.length - 1);
  return decaySchedule[idx];
}

/// Applies one season of aging to a single rating cluster. Growth moves
/// [rating] toward [potential] (age < [peakStartAge]), decline moves it down
/// (age > [peakEndAge]), and the plateau band in between only applies
/// jitter. Every phase is scaled by [playingTimeFactor]. Result is always
/// clamped to `[0, potential]` — a rating can never exceed its own ceiling.
int applyAging({
  required int rating,
  required int potential,
  required int age,
  required double playingTimeFactor,
  required Random rng,
}) {
  var next = rating.toDouble();

  if (age < peakStartAge) {
    final gap = potential - rating;
    if (gap > 0) {
      next += gap * growthStepFraction * playingTimeFactor;
    }
  } else if (age > peakEndAge) {
    next -= _decayStepFor(age) * playingTimeFactor;
  }

  final jitter = (rng.nextInt(jitterMagnitude * 2 + 1) - jitterMagnitude) * playingTimeFactor;
  next += jitter;

  return next.round().clamp(0, potential);
}
