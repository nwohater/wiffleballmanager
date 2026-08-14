import 'package:drift/drift.dart';

import 'package:wballmgr/career/free_agents.dart';
import 'package:wballmgr/career/season_progression.dart';
import 'package:wballmgr/data/database.dart';

import 'league_seed.dart';

/// Ends [completedSeasonId] and starts the next one: resolves any remaining
/// DL stints and ages every player one season (Phase 4), marks the old
/// season inactive, creates Season N+1 (active), regenerates a fresh
/// round-robin schedule for the same 12 teams, creates zeroed Standings
/// rows, and tops the free-agent pool back up. Returns the new season's id.
Future<int> rolloverSeason(AppDatabase db, {required int completedSeasonId}) async {
  final completedSeason =
      await (db.select(db.seasons)..where((s) => s.id.equals(completedSeasonId))).getSingle();

  await resolveEndOfSeasonDl(db, seasonId: completedSeasonId);
  await applySeasonDevelopment(db, seasonId: completedSeasonId);

  await (db.update(db.seasons)..where((s) => s.id.equals(completedSeasonId))).write(
    const SeasonsCompanion(isActive: Value(false)),
  );

  final newSeasonId = await db.into(db.seasons).insert(
        SeasonsCompanion.insert(number: completedSeason.number + 1, isActive: const Value(true)),
      );

  final teamRows = await db.select(db.teams).get();
  final teamIds = teamRows.map((t) => t.id).toList();

  await insertSeasonSchedule(db, seasonId: newSeasonId, teamIds: teamIds);
  await topUpFreeAgentPool(db);

  await db.batch((batch) {
    batch.insertAll(db.standings, [
      for (final teamId in teamIds) StandingsCompanion.insert(seasonId: newSeasonId, teamId: teamId),
    ]);
  });

  return newSeasonId;
}
