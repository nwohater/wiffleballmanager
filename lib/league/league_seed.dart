import 'dart:math';

import 'package:drift/drift.dart';

import 'package:wballmgr/career/free_agents.dart';
import 'package:wballmgr/data/database.dart';
import 'package:wballmgr/data/enums.dart';
import 'package:wballmgr/roster/roster_generator.dart';
import 'package:wballmgr/roster/roster_writer.dart';

import 'schedule.dart';
import 'team_names.dart';

/// Seeds a brand-new career (PRD: 3 divisions x 4 teams = 12, one
/// round-robin regular season) if none exists yet — the real replacement
/// for Phase 2's temporary `lib/dev/dev_seed.dart` single-team fixture.
/// Called once from `main.dart` before `runApp`.
Future<void> seedNewLeagueIfEmpty(AppDatabase db) async {
  final existingOrgs = await db.select(db.organizations).get();
  if (existingOrgs.isNotEmpty) return;
  await seedNewLeague(db);
}

/// Creates the 12-team league (divisions/organizations/teams + generated
/// rosters), Season #1, its round-robin schedule, and zeroed standings.
/// The first team is marked as the human player's org — deterministic and
/// simple, matching how Phase 2's dev fixture worked; no team-picker UI
/// exists yet. Returns the new season's id.
Future<int> seedNewLeague(AppDatabase db) async {
  final rng = Random();

  final divisionIds = <int>[];
  for (final name in divisionNames) {
    final id = await db.into(db.divisions).insert(
          DivisionsCompanion.insert(name: name, tier: Tier.major),
        );
    divisionIds.add(id);
  }

  const teamsPerDivision = 4;
  final teamIds = <int>[];
  for (var i = 0; i < teamNames.length; i++) {
    final divisionId = divisionIds[i ~/ teamsPerDivision];
    final organizationId = await db.into(db.organizations).insert(
          OrganizationsCompanion.insert(
            name: teamNames[i],
            isPlayerControlled: Value(i == 0),
          ),
        );
    final teamId = await db.into(db.teams).insert(
          TeamsCompanion.insert(
            organizationId: organizationId,
            divisionId: divisionId,
            name: teamNames[i],
          ),
        );
    teamIds.add(teamId);

    final players = generateRoster(rng);
    await writeGeneratedRoster(db, teamId: teamId, organizationId: organizationId, players: players);
  }

  final seasonId = await db.into(db.seasons).insert(
        SeasonsCompanion.insert(number: 1, isActive: const Value(true)),
      );

  await insertSeasonSchedule(db, seasonId: seasonId, teamIds: teamIds);

  for (final teamId in teamIds) {
    await db.into(db.standings).insert(
          StandingsCompanion.insert(seasonId: seasonId, teamId: teamId),
        );
  }

  await topUpFreeAgentPool(db, random: rng);

  return seasonId;
}

/// Generates and bulk-inserts a full round-robin `Games` schedule for
/// [teamIds] under [seasonId] (see `schedule.dart`). Shared by league
/// seeding and `season_rollover.dart`.
Future<void> insertSeasonSchedule(
  AppDatabase db, {
  required int seasonId,
  required List<int> teamIds,
}) async {
  final scheduled = generateRoundRobinSchedule(teamIds: teamIds);
  await db.batch((batch) {
    batch.insertAll(db.games, [
      for (final g in scheduled)
        GamesCompanion.insert(
          seasonId: seasonId,
          tier: Tier.major,
          homeTeamId: g.homeTeamId,
          awayTeamId: g.awayTeamId,
          gameNumber: g.dayNumber,
        ),
    ]);
  });
}
