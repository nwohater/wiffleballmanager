import 'dart:math';

import 'package:drift/drift.dart';

import 'package:wballmgr/career/free_agents.dart';
import 'package:wballmgr/data/database.dart';
import 'package:wballmgr/data/enums.dart';
import 'package:wballmgr/roster/roster_generator.dart';
import 'package:wballmgr/roster/roster_writer.dart';

import 'schedule.dart';
import 'team_names.dart';

/// Seeds a brand-new career (PRD: 3 divisions x 4 teams = 12 per tier, one
/// round-robin regular season per tier) if none exists yet — the real
/// replacement for Phase 2's temporary `lib/dev/dev_seed.dart` single-team
/// fixture. Called once from `main.dart` before `runApp`.
Future<void> seedNewLeagueIfEmpty(AppDatabase db) async {
  final existingOrgs = await db.select(db.organizations).get();
  if (existingOrgs.isNotEmpty) return;
  await seedNewLeague(db);
}

/// Creates the 12-org league — each org fielding a full major team and its
/// mirrored minor affiliate (PRD "Minor League System": same league
/// structure at a second tier, 24 teams total) — Season #1, both tiers'
/// round-robin schedules, and zeroed standings for every team. The first
/// org is marked as the human player's org — deterministic and simple,
/// matching how Phase 2's dev fixture worked; no team-picker UI exists yet.
/// Returns the new season's id.
Future<int> seedNewLeague(AppDatabase db) async {
  final rng = Random();

  final majorDivisionIds = <int>[];
  final minorDivisionIds = <int>[];
  for (final name in divisionNames) {
    majorDivisionIds.add(await db.into(db.divisions).insert(
          DivisionsCompanion.insert(name: name, tier: Tier.major),
        ));
    minorDivisionIds.add(await db.into(db.divisions).insert(
          DivisionsCompanion.insert(name: name, tier: Tier.minor),
        ));
  }

  const teamsPerDivision = 4;
  final majorTeamIds = <int>[];
  final minorTeamIds = <int>[];
  for (var i = 0; i < teamNames.length; i++) {
    final organizationId = await db.into(db.organizations).insert(
          OrganizationsCompanion.insert(
            name: teamNames[i],
            isPlayerControlled: Value(i == 0),
          ),
        );

    final majorTeamId = await db.into(db.teams).insert(
          TeamsCompanion.insert(
            organizationId: organizationId,
            divisionId: majorDivisionIds[i ~/ teamsPerDivision],
            name: teamNames[i],
          ),
        );
    majorTeamIds.add(majorTeamId);
    await writeGeneratedRoster(
      db,
      teamId: majorTeamId,
      organizationId: organizationId,
      players: generateRoster(rng),
    );

    final minorTeamId = await db.into(db.teams).insert(
          TeamsCompanion.insert(
            organizationId: organizationId,
            divisionId: minorDivisionIds[i ~/ teamsPerDivision],
            name: '${teamNames[i]} (AAA)',
          ),
        );
    minorTeamIds.add(minorTeamId);
    await writeGeneratedRoster(
      db,
      teamId: minorTeamId,
      organizationId: organizationId,
      players: generateRoster(rng),
    );
  }

  final seasonId = await db.into(db.seasons).insert(
        SeasonsCompanion.insert(number: 1, isActive: const Value(true)),
      );

  await insertSeasonSchedule(db, seasonId: seasonId, tier: Tier.major, teamIds: majorTeamIds);
  await insertSeasonSchedule(db, seasonId: seasonId, tier: Tier.minor, teamIds: minorTeamIds);

  for (final teamId in [...majorTeamIds, ...minorTeamIds]) {
    await db.into(db.standings).insert(
          StandingsCompanion.insert(seasonId: seasonId, teamId: teamId),
        );
  }

  await topUpFreeAgentPool(db, random: rng);

  return seasonId;
}

/// Generates and bulk-inserts a full round-robin `Games` schedule for
/// [teamIds] (all the same [tier]) under [seasonId] (see `schedule.dart`).
/// Shared by league seeding and `season_rollover.dart`. Major and minor
/// schedules are generated independently but share the same day-number
/// range (both are 12-team round robins), which is intentional — it lets
/// `game_runner.simulateDay`/`simulateRestOfSeason` treat "day N" as a
/// single league-wide slate spanning both tiers without any extra
/// tier-aware grouping.
Future<void> insertSeasonSchedule(
  AppDatabase db, {
  required int seasonId,
  required Tier tier,
  required List<int> teamIds,
}) async {
  final scheduled = generateRoundRobinSchedule(teamIds: teamIds);
  await db.batch((batch) {
    batch.insertAll(db.games, [
      for (final g in scheduled)
        GamesCompanion.insert(
          seasonId: seasonId,
          tier: tier,
          homeTeamId: g.homeTeamId,
          awayTeamId: g.awayTeamId,
          gameNumber: g.dayNumber,
        ),
    ]);
  });
}
