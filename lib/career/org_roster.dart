import 'package:drift/drift.dart';

import 'package:wballmgr/data/database.dart';
import 'package:wballmgr/data/enums.dart';

import 'free_agents.dart';

/// Org-wide roster cap (Phase 7, direct user decision): major (6 active +
/// DL) + minor (6 active + DL) + org-depth bench room for draft picks and
/// signings not yet assigned to a tier. At full 6+6 active rosters with
/// nobody on DL, this leaves ~8 bench slots — generous enough that a couple
/// of simultaneous injuries plus a fresh draft class don't force an
/// emergency release, but bounded so org depth can't grow unbounded season
/// over season.
const int orgRosterCap = 20;

/// Every player currently affiliated with [organizationId], regardless of
/// team/tier or roster slot (major active/DL, minor active/DL, and
/// unassigned org-depth bench alike).
Future<List<Player>> orgPlayers(AppDatabase db, {required int organizationId}) {
  return (db.select(db.players)..where((p) => p.organizationId.equals(organizationId))).get();
}

/// If [organizationId] is over [orgRosterCap], releases org-depth bench
/// players (unassigned to any team — never an active/DL rostered player;
/// those are never touched, and never a player in [protectedPlayerIds|])
/// back to true free agency, oldest first, until back at or under the cap.
/// A no-op if the org has no eligible bench players left to trim even
/// though it's still over cap — a real, if rare, possibility (a season's
/// worth of unrecovered DL/free-agent-backfill pairs can alone push an org
/// past the cap with zero bench players involved — see
/// lib/career/injuries_engine.dart), left as a temporary over-cap state
/// rather than touching a protected/active/DL player, same "legal,
/// predictably rough" philosophy as lib/league/game_runner.dart's
/// availability fallbacks.
///
/// [protectedPlayerIds] exists so a caller adding several org-depth players
/// in one batch (lib/draft/draft_manager.dart — every pick in a draft) can
/// guarantee this call never evicts a player the very same batch just
/// legitimately added; only *pre-existing* bench players are ever eligible
/// for eviction in that case.
///
/// Intended to run right after anything that can add org-depth players —
/// currently just lib/draft/draft_manager.dart, one call per pick.
Future<void> enforceOrgRosterCap(
  AppDatabase db, {
  required int organizationId,
  Set<int> protectedPlayerIds = const {},
}) async {
  final players = await orgPlayers(db, organizationId: organizationId);
  var over = players.length - orgRosterCap;
  if (over <= 0) return;

  final bench = players.where((p) => p.teamId == null && !protectedPlayerIds.contains(p.id)).toList()
    ..sort((a, b) => a.id.compareTo(b.id));
  for (final p in bench) {
    if (over <= 0) break;
    await releaseToFreeAgency(db, playerId: p.id);
    over--;
  }
}

/// Swaps [playerAId] onto [playerBId]'s team and vice versa — the
/// fundamental call-up/send-down primitive (Phase 7). Promoting a
/// minor-roster player to the majors always requires designating who comes
/// down to fill the vacated minor spot (both tiers' rosters are always
/// exactly 6 active — see roster_rules.dart), so this models that as a
/// single atomic swap rather than two independent moves that could
/// transiently leave either side short. Doesn't hard-code major/minor
/// specifically — it only requires both players to be active on two
/// different teams within the same org — but that's the only case the
/// caller (lib/ai/callup_ai.dart, the Roster screen) ever actually uses.
///
/// Callers are responsible for refreshing any AI-controlled team's saved
/// lineup afterward (lib/ai/team_manager.dart's `refreshAiLineup`) — this
/// function only does the roster mutation, same separation
/// lib/trade/trade_manager.dart's `proposeTrade` already uses.
Future<void> swapActiveAssignment(
  AppDatabase db, {
  required int organizationId,
  required int playerAId,
  required int playerBId,
}) async {
  final playerA = await (db.select(db.players)..where((p) => p.id.equals(playerAId))).getSingle();
  final playerB = await (db.select(db.players)..where((p) => p.id.equals(playerBId))).getSingle();

  if (playerA.organizationId != organizationId || playerB.organizationId != organizationId) {
    throw ArgumentError('Both players must belong to organization $organizationId.');
  }
  if (playerA.rosterSlot != RosterSlot.active || playerB.rosterSlot != RosterSlot.active) {
    throw ArgumentError('Both players must currently be active on a roster to swap assignments.');
  }
  if (playerA.teamId == null || playerB.teamId == null || playerA.teamId == playerB.teamId) {
    throw ArgumentError('Both players must be active on two different teams.');
  }

  await db.transaction(() async {
    await (db.update(db.players)..where((p) => p.id.equals(playerAId)))
        .write(PlayersCompanion(teamId: Value(playerB.teamId)));
    await (db.update(db.players)..where((p) => p.id.equals(playerBId)))
        .write(PlayersCompanion(teamId: Value(playerA.teamId)));
  });
}
