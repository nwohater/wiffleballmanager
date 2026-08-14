import 'dart:math';

import 'sim_player.dart';

/// Picks which pitch a pitcher throws for one pitch event. Resolves the
/// open question in context/player-ratings.md with its own stated simplest
/// default: random, weighted by each repertoire pitch's Movement rating —
/// nastier pitches get thrown more often. Upgradeable later to
/// count-situational or manager-assigned selection without touching
/// callers, since they only see the returned [SimPitch].
SimPitch selectPitch(SimPlayer pitcher, Random rng) {
  final repertoire = pitcher.repertoire;
  assert(repertoire.isNotEmpty, 'Pitcher ${pitcher.id} has an empty repertoire');

  final totalWeight = repertoire.fold<int>(0, (sum, p) => sum + p.movement);
  if (totalWeight <= 0) {
    // Every pitch in the repertoire rated 0 Movement (degenerate case,
    // e.g. a position player pressed into pitching) — fall back to a
    // uniform pick rather than dividing by zero.
    return repertoire[rng.nextInt(repertoire.length)];
  }

  var roll = rng.nextInt(totalWeight);
  for (final pitch in repertoire) {
    if (roll < pitch.movement) return pitch;
    roll -= pitch.movement;
  }
  return repertoire.last;
}
