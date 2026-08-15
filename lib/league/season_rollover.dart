import 'dart:math';

import 'package:drift/drift.dart';

import 'package:wballmgr/ai/callup_ai.dart' as callup_ai;
import 'package:wballmgr/ai/team_manager.dart' as ai_team_manager;
import 'package:wballmgr/career/free_agents.dart';
import 'package:wballmgr/career/season_progression.dart';
import 'package:wballmgr/data/database.dart';
import 'package:wballmgr/data/enums.dart';
import 'package:wballmgr/draft/draft_manager.dart' as draft_manager;

import 'league_seed.dart';

/// Ends [completedSeasonId] and starts the next one: resolves any remaining
/// DL stints and ages every player one season (Phase 4), marks the old
/// season inactive, creates Season N+1 (active), regenerates a fresh
/// round-robin schedule for both tiers (Phase 7: 12 major + 12 minor teams,
/// scheduled independently), creates zeroed Standings rows for all 24
/// teams, tops the free-agent pool back up, runs the annual rookie draft
/// (Phase 6, major-league-only — off [completedSeasonId]'s final major
/// standings/playoff results), runs the baseline AI offseason pass (Phase 5
/// — roster moves + lineup refresh for every AI-controlled team, off
/// [completedSeasonId]'s finalized stats), and runs the AI call-up/send-down
/// pass (Phase 7 — off the same finalized stats, after roster moves so
/// call-ups see each org's post-move rosters). Returns the new season's id.
Future<int> rolloverSeason(AppDatabase db, {required int completedSeasonId, Random? random}) async {
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

  final divisionRows = await db.select(db.divisions).get();
  final divisionTier = {for (final d in divisionRows) d.id: d.tier};
  final teamRows = await db.select(db.teams).get();
  final majorTeamIds = [
    for (final t in teamRows)
      if (divisionTier[t.divisionId] == Tier.major) t.id,
  ];
  final minorTeamIds = [
    for (final t in teamRows)
      if (divisionTier[t.divisionId] == Tier.minor) t.id,
  ];
  final teamIds = teamRows.map((t) => t.id).toList();

  await insertSeasonSchedule(db, seasonId: newSeasonId, tier: Tier.major, teamIds: majorTeamIds);
  await insertSeasonSchedule(db, seasonId: newSeasonId, tier: Tier.minor, teamIds: minorTeamIds);
  await topUpFreeAgentPool(db);
  await draft_manager.runDraft(db, seasonId: completedSeasonId, random: random);
  await ai_team_manager.runAiOffseason(db, completedSeasonId: completedSeasonId, random: random);
  await callup_ai.runAiCallUps(db, completedSeasonId: completedSeasonId);

  await db.batch((batch) {
    batch.insertAll(db.standings, [
      for (final teamId in teamIds) StandingsCompanion.insert(seasonId: newSeasonId, teamId: teamId),
    ]);
  });

  return newSeasonId;
}
