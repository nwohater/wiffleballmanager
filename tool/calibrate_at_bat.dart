// ignore_for_file: avoid_print
// Offline calibration helper — not part of the app or test suite.
//
// Solves for the baseline per-pitch probabilities (at rating 50 vs 50,
// i.e. no rating-edge adjustment) that make the pitch-by-pitch count loop
// in lib/sim/at_bat.dart reproduce the league-average per-PA outcome
// split from rules-mlw-cultz-field.md's Statistical Calibration section:
// BB 28.3%, K 40.9%, BIP 30.8%.
//
// Model: each pitch is Ball (prob 1-Z), Strike (prob Z*W), or InPlay
// (prob Z*(1-W)), where Z = P(pitch is a "strike-pool" event) and W =
// P(whiff | strike-pool event). The count loop absorbs at 4 balls (BB),
// 3 strikes (K), or the first InPlay pitch (BIP). For constant per-pitch
// probabilities this is an exact absorbing Markov chain over the
// (balls 0-3, strikes 0-2) grid, computed here by backward DP — so Z and
// W can be grid-searched against the DP output rather than hand-derived.
//
// Run with: dart run tool/calibrate_at_bat.dart
import 'dart:math';

const targetBB = 0.283;
const targetK = 0.409;
const targetBIP = 0.308;

/// Returns (P(BB), P(K), P(BIP)) for constant per-pitch probabilities.
(double, double, double) absorb(double pBall, double pStrike, double pInPlay) {
  // f/g/h[balls][strikes] = P(eventually BB/K/BIP | currently at this count).
  final f = List.generate(5, (_) => List.filled(4, 0.0)); // BB
  final g = List.generate(5, (_) => List.filled(4, 0.0)); // K
  final h = List.generate(5, (_) => List.filled(4, 0.0)); // BIP

  for (var b = 3; b >= 0; b--) {
    for (var s = 2; s >= 0; s--) {
      final fBall = (b + 1 == 4) ? 1.0 : f[b + 1][s];
      final gBall = (b + 1 == 4) ? 0.0 : g[b + 1][s];
      final hBall = (b + 1 == 4) ? 0.0 : h[b + 1][s];

      final fStrike = (s + 1 == 3) ? 0.0 : f[b][s + 1];
      final gStrike = (s + 1 == 3) ? 1.0 : g[b][s + 1];
      final hStrike = (s + 1 == 3) ? 0.0 : h[b][s + 1];

      f[b][s] = pBall * fBall + pStrike * fStrike + pInPlay * 0.0;
      g[b][s] = pBall * gBall + pStrike * gStrike + pInPlay * 0.0;
      h[b][s] = pBall * hBall + pStrike * hStrike + pInPlay * 1.0;
    }
  }
  return (f[0][0], g[0][0], h[0][0]);
}

void main() {
  var bestZ = 0.5, bestW = 0.5, bestErr = double.infinity;

  // Coarse-to-fine grid search over Z (strike-pool rate) and W (whiff rate
  // given strike-pool) in (0,1).
  for (var pass = 0; pass < 4; pass++) {
    final steps = 400;
    final zCenter = bestZ, wCenter = bestW;
    final zRange = pass == 0 ? 0.98 : 0.05 / (pass * 3);
    final wRange = pass == 0 ? 0.98 : 0.05 / (pass * 3);

    for (var i = 0; i <= steps; i++) {
      final z = (zCenter - zRange / 2 + zRange * i / steps).clamp(0.001, 0.999);
      for (var j = 0; j <= steps; j++) {
        final w = (wCenter - wRange / 2 + wRange * j / steps).clamp(0.001, 0.999);
        final pBall = 1 - z;
        final pStrike = z * w;
        final pInPlay = z * (1 - w);
        final (bb, k, bip) = absorb(pBall, pStrike, pInPlay);
        final err = pow(bb - targetBB, 2) + pow(k - targetK, 2) + pow(bip - targetBIP, 2);
        if (err < bestErr) {
          bestErr = err.toDouble();
          bestZ = z;
          bestW = w;
        }
      }
    }
  }

  final pBall = 1 - bestZ;
  final pStrike = bestZ * bestW;
  final pInPlay = bestZ * (1 - bestW);
  final (bb, k, bip) = absorb(pBall, pStrike, pInPlay);

  double logit(double p) => log(p / (1 - p));

  print('Z (pStrikeEvent baseline)      = $bestZ');
  print('W (pWhiffGivenStrike baseline) = $bestW');
  print('per-pitch: pBall=$pBall pStrike=$pStrike pInPlay=$pInPlay');
  print('resulting per-PA: BB=$bb K=$k BIP=$bip  (targets: $targetBB $targetK $targetBIP)');
  print('squared error = $bestErr');
  print('');
  print('zoneLogitBase  = ${logit(bestZ)}');
  print('whiffLogitBase = ${logit(bestW)}');
}
