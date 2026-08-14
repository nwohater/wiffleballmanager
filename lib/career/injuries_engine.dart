import 'dart:math';

import 'package:drift/drift.dart';

import 'package:wballmgr/data/database.dart';
import 'package:wballmgr/data/enums.dart';
import 'package:wballmgr/sim/box_score.dart' as sim;

import 'free_agents.dart';

/// ~0.5% chance of any injury per participant per game, split 70/25/5
/// across minor/moderate/major. See context/player-ratings.md "Career
/// Progression: Injuries" — uncalibrated starting point.
InjurySeverity? rollInjury(Random rng) {
  const injuryChance = 0.005;
  if (rng.nextDouble() >= injuryChance) return null;

  final roll = rng.nextInt(100);
  if (roll < 70) return InjurySeverity.minor;
  if (roll < 95) return InjurySeverity.moderate;
  return InjurySeverity.major;
}

/// Games missed for a given [severity]: 1-3 minor, 4-10 moderate, 11-40
/// major.
int rollGamesMissed(InjurySeverity severity, Random rng) {
  switch (severity) {
    case InjurySeverity.minor:
      return 1 + rng.nextInt(3);
    case InjurySeverity.moderate:
      return 4 + rng.nextInt(7);
    case InjurySeverity.major:
      return 11 + rng.nextInt(30);
  }
}

/// Rolls injuries for every player who appeared in [box] (batting,
/// pitching, or fielding) after a completed game, called right after
/// `writeBoxScore` from `game_runner.playGame`. Minor injuries just set
/// `gamesUnavailable` — the player stays on the active roster and sits out
/// via the runtime lineup resolver. Moderate/major injuries additionally
/// move the player to `dl` and atomically backfill the roster spot from
/// free agency in the same transaction as the [Injuries] row insert.
Future<void> checkForInjuries(
  AppDatabase db, {
  required int gameId,
  required int seasonId,
  required sim.BoxScore box,
  Random? random,
}) async {
  final rng = random ?? Random();

  final participantTeams = <int, int>{};
  for (final line in box.batting.values) {
    participantTeams[line.playerId] = line.teamId;
  }
  for (final line in box.pitching.values) {
    participantTeams[line.playerId] = line.teamId;
  }
  for (final line in box.fielding.values) {
    participantTeams[line.playerId] = line.teamId;
  }

  for (final entry in participantTeams.entries) {
    final playerId = entry.key;
    final teamId = entry.value;

    final severity = rollInjury(rng);
    if (severity == null) continue;
    final gamesMissed = rollGamesMissed(severity, rng);

    await db.transaction(() async {
      int? replacementId;
      if (severity != InjurySeverity.minor) {
        final player = await (db.select(db.players)..where((p) => p.id.equals(playerId))).getSingle();
        replacementId = await signFreeAgent(
          db,
          teamId: teamId,
          organizationId: player.organizationId!,
          random: rng,
        );
        await (db.update(db.players)..where((p) => p.id.equals(playerId))).write(
          const PlayersCompanion(rosterSlot: Value(RosterSlot.dl)),
        );
      }

      await (db.update(db.players)..where((p) => p.id.equals(playerId))).write(
        PlayersCompanion(gamesUnavailable: Value(gamesMissed)),
      );

      await db.into(db.injuries).insert(InjuriesCompanion.insert(
            playerId: playerId,
            seasonId: seasonId,
            gameId: gameId,
            severity: severity,
            gamesMissed: gamesMissed,
            replacementPlayerId: Value(replacementId),
          ));
    });
  }
}

/// Decrements `gamesUnavailable` for every currently-unavailable player on
/// [teamId] (floor 0), called once per team per completed game. Anyone who
/// just hit 0 while on `dl` triggers the reversal of their own DL stint —
/// releasing their specific replacement back to free agency and restoring
/// them to active.
Future<void> decrementAvailability(AppDatabase db, {required int teamId}) async {
  final unavailable = await (db.select(db.players)
        ..where((p) => p.teamId.equals(teamId) & p.gamesUnavailable.isBiggerThanValue(0)))
      .get();

  for (final player in unavailable) {
    final remaining = player.gamesUnavailable - 1;
    await (db.update(db.players)..where((p) => p.id.equals(player.id))).write(
      PlayersCompanion(gamesUnavailable: Value(remaining)),
    );

    if (remaining == 0 && player.rosterSlot == RosterSlot.dl) {
      await reverseDlStint(db, playerId: player.id);
    }
  }
}

/// Reverses the most recent still-open DL stint for [playerId]: releases
/// that stint's specific replacement to free agency and restores the
/// recovered player to active. Public so `season_progression.dart` can
/// reuse it to force end-of-season DL reversals.
Future<void> reverseDlStint(AppDatabase db, {required int playerId}) async {
  final openInjury = await (db.select(db.injuries)
        ..where((i) => i.playerId.equals(playerId) & i.replacementPlayerId.isNotNull())
        ..orderBy([(i) => OrderingTerm.desc(i.id)])
        ..limit(1))
      .getSingleOrNull();

  await db.transaction(() async {
    await (db.update(db.players)..where((p) => p.id.equals(playerId))).write(
      const PlayersCompanion(rosterSlot: Value(RosterSlot.active)),
    );
    final replacementId = openInjury?.replacementPlayerId;
    if (openInjury != null && replacementId != null) {
      await releaseToFreeAgency(db, playerId: replacementId);
      await (db.update(db.injuries)..where((i) => i.id.equals(openInjury.id))).write(
        const InjuriesCompanion(replacementPlayerId: Value(null)),
      );
    }
  });
}
