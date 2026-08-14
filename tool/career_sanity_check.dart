// ignore_for_file: avoid_print
// Manual end-to-end sanity check for Phase 4 (Career Progression): seeds a
// real 12-team league and plays 5 full seasons back to back (regular season
// + playoffs + rollover each time), printing a handful of players' rating
// trajectories season over season plus league-wide injury/DL activity, for
// a human eyeball check that development/injuries feel sane over time —
// the kind of thing the unit test suite can't fully validate on its own.
//
// Deliberately outside test/ (same pattern as tool/full_season_sanity_check
// .dart from Phase 3), so it doesn't run as part of the normal suite.
// `lib/data/database.dart` pulls in Flutter (path_provider), so plain
// `dart run` can't compile it; run via the Flutter test runner instead:
//   flutter test tool/career_sanity_check.dart
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:wballmgr/data/database.dart';
import 'package:wballmgr/data/enums.dart';
import 'package:wballmgr/league/game_runner.dart';
import 'package:wballmgr/league/league_seed.dart';
import 'package:wballmgr/league/season_rollover.dart';

const int _seasonsToPlay = 5;
const int _samplePlayerCount = 5;

void main() {
  test('career sanity check', () async {
    await _run();
  });
}

String _line(Player p) {
  final battingComposite = ((p.contact + p.power + p.discipline) / 3).round();
  return '  #${p.id.toString().padLeft(4)} age ${p.age.toString().padLeft(2)}  '
      'batting $battingComposite/${p.battingPotential}  '
      'pitching ${((p.control + p.stamina) / 2).round()}/${p.pitchingPotential}  '
      'fielding ${((p.range + p.hands + p.arm) / 3).round()}/${p.fieldingPotential}  '
      'speed ${p.speed}/${p.speedPotential}  '
      '${p.rosterSlot == RosterSlot.dl ? '(DL, ${p.gamesUnavailable} games left)' : ''}';
}

Future<void> _run() async {
  final db = AppDatabase.forTesting(NativeDatabase.memory());
  var seasonId = await seedNewLeague(db);
  print('Seeded league, season $seasonId.');

  final firstTeam = (await db.select(db.teams).get()).first;
  final teamPlayers = await (db.select(db.players)..where((p) => p.teamId.equals(firstTeam.id))).get();
  final sampleIds = teamPlayers.take(_samplePlayerCount).map((p) => p.id).toList();

  print('\n=== Season $seasonId — starting ratings for ${firstTeam.name} sample players ===');
  for (final p in teamPlayers.where((p) => sampleIds.contains(p.id))) {
    print(_line(p));
  }

  final stopwatch = Stopwatch()..start();
  for (var season = 1; season <= _seasonsToPlay; season++) {
    await simulateRestOfSeason(db, seasonId: seasonId);

    final injuries = await (db.select(db.injuries)..where((i) => i.seasonId.equals(seasonId))).get();
    final bySeverity = {
      for (final severity in InjurySeverity.values)
        severity: injuries.where((i) => i.severity == severity).length,
    };
    // Every moderate/major injury triggers a DL move at the moment it
    // happens (see injuries_engine.checkForInjuries) — replacementPlayerId
    // may already be cleared here if the player recovered mid-season, so
    // count by severity rather than by whether that link is still open.
    final dlMoves = injuries.where((i) => i.severity != InjurySeverity.minor).length;

    final newSeasonId = await rolloverSeason(db, completedSeasonId: seasonId);

    print('\n=== After season $seasonId (rolled into season $newSeasonId) ===');
    print('Injuries: ${bySeverity[InjurySeverity.minor]} minor, '
        '${bySeverity[InjurySeverity.moderate]} moderate, '
        '${bySeverity[InjurySeverity.major]} major — $dlMoves triggered a DL move/backfill.');

    final samplePlayers = [
      for (final id in sampleIds)
        await (db.select(db.players)..where((p) => p.id.equals(id))).getSingle(),
    ];
    for (final p in samplePlayers) {
      print(_line(p));
    }

    seasonId = newSeasonId;
  }
  stopwatch.stop();
  print('\nSimulated $_seasonsToPlay seasons in ${stopwatch.elapsedMilliseconds}ms.');

  await db.close();
}
