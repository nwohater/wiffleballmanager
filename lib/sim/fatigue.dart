/// Pitcher fatigue: effective Control/Movement decay once a pitcher has
/// faced more batters in the game than their Stamina rating supports.
/// Deliberately simple/tunable — context/player-ratings.md flags Stamina
/// as mattering "a lot" via the no-re-entry rule, but leaves the exact
/// curve as an implementation detail.
class Fatigue {
  Fatigue._();

  /// Batters a pitcher can face before decay begins. A regulation 3-inning
  /// game runs ~16 batters faced per team at league-average PA outcomes
  /// (3 outs/inning at a ~56% out-per-PA rate, per the calibration doc's
  /// BB/K/BIP-out rates) — a single starter going the whole game is the
  /// normal Phase 1 case (bullpen management is Phase 5), so a 50-Stamina
  /// pitcher needs to comfortably clear that, with decay mainly biting in
  /// extra innings or for a weak-Stamina arm.
  static int thresholdBattersFaced(int stamina) => 14 + (stamina * 0.14).round();

  /// Rating points shaved off Control/Movement per batter faced beyond the
  /// threshold, capped so a badly fatigued arm never goes to zero.
  static int decay(int stamina, int battersFaced) {
    final threshold = thresholdBattersFaced(stamina);
    if (battersFaced <= threshold) return 0;
    final over = battersFaced - threshold;
    final raw = over * 3;
    return raw > 35 ? 35 : raw;
  }
}
