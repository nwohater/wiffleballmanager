/// Mutable per-game stat lines the game simulator accumulates into. Column
/// sets mirror BattingStats/PitchingStats/FieldingStats in lib/data/tables
/// (see rules-mlw-cultz-field.md's Statistics Model) so persisting a
/// finished game is a straight field-by-field copy — that wiring is a
/// later phase's job, this class only needs to be a faithful in-memory
/// shape for the simulator and the validation harness to fill in and read.
///
/// IP/INN are tracked as outs (outsRecorded/outsPlayed), matching the
/// drift schema, so ERA (this league's ER x3/IP convention)/WHIP/AVG/OBP
/// /SLG/FPct stay derived rather than stored.
library;

class BattingLine {
  final int playerId;
  final int teamId;
  bool gs = false;

  int pa = 0;
  int ab = 0;
  int r = 0;
  int h = 0;
  int doubles = 0;
  int triples = 0;
  int hr = 0;
  int rbi = 0;
  int bb = 0;
  int k = 0;
  int hbp = 0;
  int ibb = 0;
  int sb = 0;
  int cs = 0;
  int sh = 0;
  int sf = 0;
  int dp = 0;
  int roe = 0;
  int fc = 0;
  int lob = 0;

  BattingLine({required this.playerId, required this.teamId});
}

class PitchingLine {
  final int playerId;
  final int teamId;
  bool gs = false;
  bool cg = false;

  int outsRecorded = 0;
  int r = 0;
  int er = 0;
  int h = 0;
  int bb = 0;
  int hbp = 0;
  int ibb = 0;
  int k = 0;
  int w = 0;
  int l = 0;
  int s = 0;
  int hld = 0;
  int bs = 0;
  int wp = 0;

  PitchingLine({required this.playerId, required this.teamId});
}

class FieldingLine {
  final int playerId;
  final int teamId;
  bool gs = false;

  int outsPlayed = 0;
  int tc = 0;
  int po = 0;
  int a = 0;
  int e = 0;
  int dp = 0;
  int pb = 0;
  int sb = 0;
  int cs = 0;

  FieldingLine({required this.playerId, required this.teamId});
}

class BoxScore {
  final Map<int, BattingLine> batting = {};
  final Map<int, PitchingLine> pitching = {};
  final Map<int, FieldingLine> fielding = {};

  BattingLine battingFor(int playerId, int teamId) =>
      batting.putIfAbsent(playerId, () => BattingLine(playerId: playerId, teamId: teamId));

  PitchingLine pitchingFor(int playerId, int teamId) =>
      pitching.putIfAbsent(playerId, () => PitchingLine(playerId: playerId, teamId: teamId));

  FieldingLine fieldingFor(int playerId, int teamId) =>
      fielding.putIfAbsent(playerId, () => FieldingLine(playerId: playerId, teamId: teamId));
}

class GameResult {
  final int homeTeamId;
  final int awayTeamId;
  final int homeScore;
  final int awayScore;
  final int inningsPlayed;
  final BoxScore boxScore;
  final int? winningPitcherId;
  final int? losingPitcherId;
  final int? savePitcherId;

  /// Runs scored per half-inning, one entry per inning played — the
  /// line-score breakdown. Useful on its own (Phase 8's box score view)
  /// and precise enough to assert the mercy rule against directly (each
  /// entry for innings 1-2 should be at or just above the 6-run cap, never
  /// far beyond it).
  final List<int> homeInningRuns;
  final List<int> awayInningRuns;

  const GameResult({
    required this.homeTeamId,
    required this.awayTeamId,
    required this.homeScore,
    required this.awayScore,
    required this.inningsPlayed,
    required this.boxScore,
    required this.homeInningRuns,
    required this.awayInningRuns,
    this.winningPitcherId,
    this.losingPitcherId,
    this.savePitcherId,
  });
}
