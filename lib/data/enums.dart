/// Major-league vs. minor-league affiliate tier (PRD: 12 orgs, each fielding
/// a full mirrored major + minor team).
enum Tier { major, minor }

/// A player's assignment within their team's 6-active-only roster (Phase 4
/// dropped the reserve slot — see context/player-ratings.md). `dl` members
/// are uncapped and don't count toward the 6-active limit.
/// Null on the Player row itself means unassigned (free agent).
enum RosterSlot { active, dl }

/// Severity band for an injury rolled after a completed game — see
/// context/player-ratings.md "Career Progression: Injuries".
enum InjurySeverity { minor, moderate, major }

/// Standard pitch-type pool a pitcher's repertoire is drawn from
/// (context/player-ratings.md — general-knowledge starting list).
enum PitchType {
  fastball,
  riser,
  curveball,
  screwball,
  dropBall,
  slider,
  sinker,
  knuckleball,
}

enum GameStatus { scheduled, inProgress, completed }

/// Playoff bracket round (PRD: 4-team bracket, best-of-5 first round,
/// best-of-7 championship).
enum PlayoffRound { semifinal, championship }
