import '../data/enums.dart';

/// One entry in a pitcher's repertoire (context/player-ratings.md). A pitch
/// type not present in [SimPlayer.repertoire] is a pitch that player
/// doesn't throw at all — never a 0-Movement entry.
class SimPitch {
  final PitchType type;
  final int movement;

  const SimPitch({required this.type, required this.movement});
}

/// Plain-Dart mirror of the true ratings a Player row carries, deliberately
/// decoupled from the drift persistence layer so the sim engine has no
/// database dependency and can be unit-tested with synthetic rosters.
/// Every player carries all three rating groups regardless of how they're
/// actually used on a given play (Hidden Ratings model) — a "one-way"
/// player just has weak numbers in the groups they don't play.
class SimPlayer {
  final int id;
  final String name;

  // Batting
  final int contact;
  final int power;
  final int discipline;

  // Baserunning
  final int speed;

  // Pitching (repertoire Movement lives on each SimPitch)
  final int control;
  final int stamina;
  final List<SimPitch> repertoire;

  // Fielding
  final int range;
  final int hands;
  final int arm;

  const SimPlayer({
    required this.id,
    required this.name,
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
  });

  /// Simple rating composites — same formulas as
  /// lib/roster/roster_generator.dart's GeneratedPlayer (a true-rating
  /// player before persistence), used by lib/ai/lineup_ai.dart's
  /// true-rating-visibility lineup/rotation AI. Not stored ratings
  /// themselves, just cheap rankings.
  double get battingScore => (contact + power + discipline) / 3;
  double get pitchingScore => (control + stamina) / 2;
  double get fieldingScore => (range + hands + arm) / 3;
}
