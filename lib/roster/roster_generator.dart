import 'dart:math';

import 'package:wballmgr/data/enums.dart';
import 'package:wballmgr/sim/sim_player.dart';

import 'name_pool.dart';

/// Talent bands new players' ratings are drawn from — 0-99 scale per
/// context/player-ratings.md. Weighted skewed toward [average] so most
/// generated players are unremarkable, with rarer standouts and duds at
/// the extremes (matches the calibration doc's noted wide variance).
enum TalentTier {
  poor(min: 5, max: 30, weight: 10),
  belowAverage(min: 25, max: 45, weight: 20),
  average(min: 40, max: 60, weight: 40),
  aboveAverage(min: 55, max: 75, weight: 20),
  elite(min: 70, max: 99, weight: 10);

  const TalentTier({required this.min, required this.max, required this.weight});

  final int min;
  final int max;
  final int weight;

  /// [weights] overrides the default distribution — used by free-agent
  /// generation to draw from a below-average-skewed table instead.
  static TalentTier roll(Random rng, {Map<TalentTier, int>? weights}) {
    final effective = weights ?? {for (final t in values) t: t.weight};
    final totalWeight = effective.values.fold<int>(0, (sum, w) => sum + w);
    var roll = rng.nextInt(totalWeight);
    for (final tier in values) {
      final w = effective[tier] ?? 0;
      if (roll < w) return tier;
      roll -= w;
    }
    return average;
  }

  int rollRating(Random rng) => min + rng.nextInt(max - min + 1);

  /// The tier [bump] tiers above this one, clamped at [elite].
  TalentTier bumpedBy(int bump) {
    final idx = (values.indexOf(this) + bump).clamp(0, values.length - 1);
    return values[idx];
  }
}

/// Below-average-skewed tier weights for the standing free-agent pool
/// (context/player-ratings.md: weaker than real rostered players).
const Map<TalentTier, int> freeAgentTierWeights = {
  TalentTier.poor: 30,
  TalentTier.belowAverage: 35,
  TalentTier.average: 25,
  TalentTier.aboveAverage: 8,
  TalentTier.elite: 2,
};

/// Chance/size of a potential ceiling bump above the rolled current tier,
/// keyed by age band — younger players have more headroom. Weights are for
/// bumps of 0/1/2 tiers, in that order.
List<int> _potentialBumpWeights(int age) {
  if (age <= 23) return [20, 40, 40];
  if (age <= 27) return [40, 45, 15];
  return [70, 25, 5];
}

int _rollPotentialBump(Random rng, int age) {
  final weights = _potentialBumpWeights(age);
  final total = weights.fold<int>(0, (a, b) => a + b);
  var roll = rng.nextInt(total);
  for (var i = 0; i < weights.length; i++) {
    if (roll < weights[i]) return i;
    roll -= weights[i];
  }
  return 0;
}

/// Rolls a per-cluster potential ceiling: a tier bump above [currentTier]
/// (shrinking with [age]), then a rating within that tier, floored at
/// [currentValue] so the ceiling can never sit below the current roll.
int _rollClusterPotential(
  Random rng, {
  required TalentTier currentTier,
  required int currentValue,
  required int age,
}) {
  final bump = _rollPotentialBump(rng, age);
  final potentialTier = currentTier.bumpedBy(bump);
  final potentialValue = potentialTier.rollRating(rng);
  return potentialValue > currentValue ? potentialValue : currentValue;
}

/// A newly-generated player's full rating set, mirroring every field
/// Players/PlayerPitches store — plain Dart, decoupled from drift so
/// generation can be unit-tested without a database (same shape as
/// lib/sim/'s SimPlayer/SimPitch).
class GeneratedPlayer {
  final String firstName;
  final String lastName;
  final int age;

  final int contact;
  final int power;
  final int discipline;

  final int speed;

  final int control;
  final int stamina;
  final List<SimPitch> repertoire;

  final int range;
  final int hands;
  final int arm;

  /// Hidden per-cluster ceilings (0-99) — see context/player-ratings.md
  /// "Career Progression: Potential & Aging". Always >= the corresponding
  /// current-rating composite.
  final int battingPotential;
  final int pitchingPotential;
  final int fieldingPotential;
  final int speedPotential;

  const GeneratedPlayer({
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.contact,
    required this.power,
    required this.discipline,
    required this.speed,
    required this.control,
    required this.stamina,
    required this.repertoire,
    required this.range,
    required this.hands,
    required this.arm,
    required this.battingPotential,
    required this.pitchingPotential,
    required this.fieldingPotential,
    required this.speedPotential,
  });

  /// Simple composite used only to pick a sensible default lineup — not a
  /// stored rating.
  double get battingScore => (contact + power + discipline) / 3;
  double get pitchingScore => (control + stamina) / 2;
  double get fieldingScore => (range + hands + arm) / 3;
}

/// Chooses a repertoire size skewed toward 2-3 pitch types (a 1-pitch
/// pitcher is legal but rare; 4 is the ruleset's max).
int _rollRepertoireSize(Random rng) {
  const weights = [15, 35, 35, 15]; // sizes 1..4
  final total = weights.fold<int>(0, (a, b) => a + b);
  var roll = rng.nextInt(total);
  for (var i = 0; i < weights.length; i++) {
    if (roll < weights[i]) return i + 1;
    roll -= weights[i];
  }
  return 2;
}

GeneratedPlayer _generatePlayer(Random rng, {Map<TalentTier, int>? tierWeights}) {
  final battingTier = TalentTier.roll(rng, weights: tierWeights);
  final pitchingTier = TalentTier.roll(rng, weights: tierWeights);
  final fieldingTier = TalentTier.roll(rng, weights: tierWeights);
  final speedTier = TalentTier.roll(rng, weights: tierWeights);

  final pitchTypes = List.of(PitchType.values)..shuffle(rng);
  final repertoireSize = _rollRepertoireSize(rng);
  final repertoire = [
    for (final type in pitchTypes.take(repertoireSize))
      SimPitch(type: type, movement: pitchingTier.rollRating(rng)),
  ];

  final age = 20 + rng.nextInt(13); // 20-32 inclusive
  final contact = battingTier.rollRating(rng);
  final power = battingTier.rollRating(rng);
  final discipline = battingTier.rollRating(rng);
  final speed = speedTier.rollRating(rng);
  final control = pitchingTier.rollRating(rng);
  final stamina = pitchingTier.rollRating(rng);
  final range = fieldingTier.rollRating(rng);
  final hands = fieldingTier.rollRating(rng);
  final arm = fieldingTier.rollRating(rng);

  return GeneratedPlayer(
    firstName: firstNamePool[rng.nextInt(firstNamePool.length)],
    lastName: lastNamePool[rng.nextInt(lastNamePool.length)],
    age: age,
    contact: contact,
    power: power,
    discipline: discipline,
    speed: speed,
    control: control,
    stamina: stamina,
    repertoire: repertoire,
    range: range,
    hands: hands,
    arm: arm,
    battingPotential: _rollClusterPotential(
      rng,
      currentTier: battingTier,
      currentValue: ((contact + power + discipline) / 3).round(),
      age: age,
    ),
    pitchingPotential: _rollClusterPotential(
      rng,
      currentTier: pitchingTier,
      currentValue: ((control + stamina) / 2).round(),
      age: age,
    ),
    fieldingPotential: _rollClusterPotential(
      rng,
      currentTier: fieldingTier,
      currentValue: ((range + hands + arm) / 3).round(),
      age: age,
    ),
    speedPotential: _rollClusterPotential(
      rng,
      currentTier: speedTier,
      currentValue: speed,
      age: age,
    ),
  );
}

/// Generates a full 6-active-only roster for one team, per Phase 4's
/// no-reserve rework (rules-mlw-cultz-field.md proposal).
List<GeneratedPlayer> generateRoster(Random rng, {int count = 6}) =>
    List.generate(count, (_) => _generatePlayer(rng));

/// Generates a below-average-skewed pool of unrostered free agents (see
/// [freeAgentTierWeights]), topped up each season rollover.
List<GeneratedPlayer> generateFreeAgentPool(Random rng, {int count = 25}) =>
    List.generate(count, (_) => _generatePlayer(rng, tierWeights: freeAgentTierWeights));

/// A default lineup/rotation for a freshly generated roster, expressed as
/// indices into the input list (roster_writer.dart maps these to the
/// actual inserted player ids). Not a recommendation engine — just a cheap
/// starting point the manual editing UI lets the user override.
class DefaultLineupSelection {
  final List<int> battingOrderIndices;
  final List<int> pitcherRotationIndices;
  final int fielder2Index;
  final int fielder3Index;

  const DefaultLineupSelection({
    required this.battingOrderIndices,
    required this.pitcherRotationIndices,
    required this.fielder2Index,
    required this.fielder3Index,
  });
}

/// Requires exactly 6 players (roster_rules.validateRosterComposition's
/// no-reserve, 6-active-only rule — Phase 4 rework). Picks the single best
/// pitcher by [pitchingScore] as the sole rotation entry (Phase 1's common
/// case: one starter goes the whole game), the remaining 5 as the batting
/// order (Always-DH: the starter is excluded, so active = the 5 batters +
/// the starter = 6), and the best 2 fielders among those 5 batters as
/// fielder2/fielder3.
DefaultLineupSelection defaultLineupFor(List<GeneratedPlayer> players) {
  if (players.length != 6) {
    throw ArgumentError('defaultLineupFor requires exactly 6 players, got ${players.length}');
  }

  final byPitching = List.generate(players.length, (i) => i)
    ..sort((a, b) => players[b].pitchingScore.compareTo(players[a].pitchingScore));
  final starterIndex = byPitching.first;

  final byBatting = List.generate(players.length, (i) => i)
    ..removeWhere((i) => i == starterIndex)
    ..sort((a, b) => players[b].battingScore.compareTo(players[a].battingScore));
  final battingOrderIndices = byBatting;

  final fielderCandidates = List.of(battingOrderIndices)
    ..sort((a, b) => players[b].fieldingScore.compareTo(players[a].fieldingScore));
  final fielder2Index = fielderCandidates[0];
  final fielder3Index = fielderCandidates[1];

  return DefaultLineupSelection(
    battingOrderIndices: battingOrderIndices,
    pitcherRotationIndices: [starterIndex],
    fielder2Index: fielder2Index,
    fielder3Index: fielder3Index,
  );
}
