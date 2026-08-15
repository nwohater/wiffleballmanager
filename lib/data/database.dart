import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'enums.dart';
import 'tables/batting_stats.dart';
import 'tables/divisions.dart';
import 'tables/draft_picks.dart';
import 'tables/fielding_stats.dart';
import 'tables/games.dart';
import 'tables/injuries.dart';
import 'tables/organizations.dart';
import 'tables/pitching_stats.dart';
import 'tables/player_pitches.dart';
import 'tables/players.dart';
import 'tables/playoff_series.dart';
import 'tables/seasons.dart';
import 'tables/standings.dart';
import 'tables/team_lineups.dart';
import 'tables/teams.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    Organizations,
    Divisions,
    Teams,
    Seasons,
    Games,
    Players,
    PlayerPitches,
    BattingStats,
    PitchingStats,
    FieldingStats,
    Standings,
    TeamLineups,
    PlayoffSeries,
    Injuries,
    DraftPicks,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 6;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(organizations, organizations.isPlayerControlled);
            await m.createTable(teamLineups);
          }
          if (from < 3) {
            await m.createTable(playoffSeries);
            await m.addColumn(games, games.seriesId);
          }
          if (from < 4) {
            await m.addColumn(players, players.battingPotential);
            await m.addColumn(players, players.pitchingPotential);
            await m.addColumn(players, players.fieldingPotential);
            await m.addColumn(players, players.speedPotential);
            await m.addColumn(players, players.gamesUnavailable);
            await m.createTable(injuries);
          }
          if (from < 5) {
            await m.createTable(draftPicks);
          }
          if (from < 6) {
            await m.addColumn(playoffSeries, playoffSeries.tier);
          }
        },
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'wballmgr.sqlite'));

    return NativeDatabase.createInBackground(file);
  });
}
