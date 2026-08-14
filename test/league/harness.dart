import 'dart:math';

import 'package:wballmgr/data/database.dart';
import 'package:wballmgr/data/enums.dart';
import 'package:wballmgr/roster/roster_generator.dart';
import 'package:wballmgr/roster/roster_writer.dart';

/// Creates [count] teams (all in one throwaway division — fine for tests
/// that don't exercise division-based logic) with full generated rosters
/// and default lineups, ready for `game_runner.playGame`/`playoffs
/// .simulatePlayoffGame` to actually simulate. Returns the team ids.
Future<List<int>> makeTeamsWithRosters(AppDatabase db, {required int count, int seed = 1}) async {
  final rng = Random(seed);
  final divisionId = await db.into(db.divisions).insert(
        DivisionsCompanion.insert(name: 'Test Division', tier: Tier.major),
      );

  final teamIds = <int>[];
  for (var i = 0; i < count; i++) {
    final orgId = await db.into(db.organizations).insert(
          OrganizationsCompanion.insert(name: 'Org $i'),
        );
    final teamId = await db.into(db.teams).insert(
          TeamsCompanion.insert(organizationId: orgId, divisionId: divisionId, name: 'Team $i'),
        );
    final players = generateRoster(rng);
    await writeGeneratedRoster(db, teamId: teamId, organizationId: orgId, players: players);
    teamIds.add(teamId);
  }
  return teamIds;
}
