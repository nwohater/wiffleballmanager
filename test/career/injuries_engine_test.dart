import 'dart:math';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:wballmgr/career/injuries_engine.dart';
import 'package:wballmgr/data/database.dart';
import 'package:wballmgr/data/enums.dart';
import 'package:wballmgr/sim/box_score.dart' as sim;

import '../league/harness.dart';

/// A [Random] whose every call is a deterministic, bounds-respecting
/// function of fixed seeds — lets a test force a specific injury severity
/// and games-missed roll instead of hoping a seeded PRNG lands there.
class _FixedRandom implements Random {
  final double doubleValue;
  final int intSeed;

  const _FixedRandom({required this.doubleValue, required this.intSeed});

  @override
  double nextDouble() => doubleValue;

  @override
  int nextInt(int max) => intSeed % max;

  @override
  bool nextBool() => false;
}

Future<int> _insertFreeAgent(AppDatabase db, {required String name}) {
  return db.into(db.players).insert(PlayersCompanion.insert(
        firstName: name,
        lastName: 'Agent',
        age: 25,
        contact: 50,
        power: 50,
        discipline: 50,
        speed: 50,
        control: 50,
        stamina: 50,
        range: 50,
        hands: 50,
        arm: 50,
        battingPotential: 70,
        pitchingPotential: 70,
        fieldingPotential: 70,
        speedPotential: 70,
      ));
}

Future<int> _insertGame(
  AppDatabase db, {
  required int seasonId,
  required int homeTeamId,
  required int awayTeamId,
  required int gameNumber,
}) {
  return db.into(db.games).insert(GamesCompanion.insert(
        seasonId: seasonId,
        tier: Tier.major,
        homeTeamId: homeTeamId,
        awayTeamId: awayTeamId,
        gameNumber: gameNumber,
      ));
}

void main() {
  group('rollInjury', () {
    test('roughly 0.5% chance of any injury, split ~70/25/5', () {
      final rng = Random(1);
      var minor = 0, moderate = 0, major = 0;
      const trials = 400000;
      for (var i = 0; i < trials; i++) {
        final severity = rollInjury(rng);
        switch (severity) {
          case null:
            break;
          case InjurySeverity.minor:
            minor++;
          case InjurySeverity.moderate:
            moderate++;
          case InjurySeverity.major:
            major++;
        }
      }
      final anyRate = (minor + moderate + major) / trials;
      expect(anyRate, closeTo(0.005, 0.001));

      final totalInjuries = minor + moderate + major;
      expect(minor / totalInjuries, closeTo(0.70, 0.05));
      expect(moderate / totalInjuries, closeTo(0.25, 0.05));
      expect(major / totalInjuries, closeTo(0.05, 0.03));
    });
  });

  group('rollGamesMissed', () {
    test('minor stays within 1-3 and hits both ends over many trials', () {
      final rng = Random(2);
      final seen = <int>{};
      for (var i = 0; i < 1000; i++) {
        final games = rollGamesMissed(InjurySeverity.minor, rng);
        expect(games, inInclusiveRange(1, 3));
        seen.add(games);
      }
      expect(seen, {1, 2, 3});
    });

    test('moderate stays within 4-10 and hits both ends over many trials', () {
      final rng = Random(3);
      final seen = <int>{};
      for (var i = 0; i < 1000; i++) {
        final games = rollGamesMissed(InjurySeverity.moderate, rng);
        expect(games, inInclusiveRange(4, 10));
        seen.add(games);
      }
      expect(seen, {4, 5, 6, 7, 8, 9, 10});
    });

    test('major stays within 11-40 and hits both ends over many trials', () {
      final rng = Random(4);
      final seen = <int>{};
      for (var i = 0; i < 5000; i++) {
        final games = rollGamesMissed(InjurySeverity.major, rng);
        expect(games, inInclusiveRange(11, 40));
        seen.add(games);
      }
      expect(seen.contains(11), isTrue);
      expect(seen.contains(40), isTrue);
    });
  });

  group('checkForInjuries (drift-coupled)', () {
    late AppDatabase db;
    late int seasonId;
    late List<int> teamIds;

    setUp(() async {
      db = AppDatabase.forTesting(NativeDatabase.memory());
      seasonId = await db.into(db.seasons).insert(SeasonsCompanion.insert(number: 1));
      teamIds = await makeTeamsWithRosters(db, count: 2);
    });

    tearDown(() async => db.close());

    test('minor injury sets gamesUnavailable but makes no roster move', () async {
      final teamId = teamIds[0];
      final activeBefore =
          await (db.select(db.players)..where((p) => p.teamId.equals(teamId))).get();
      final target = activeBefore.first;

      final gameId =
          await _insertGame(db, seasonId: seasonId, homeTeamId: teamIds[0], awayTeamId: teamIds[1], gameNumber: 1);
      final box = sim.BoxScore()..battingFor(target.id, teamId).pa = 3;

      await checkForInjuries(
        db,
        gameId: gameId,
        seasonId: seasonId,
        box: box,
        random: const _FixedRandom(doubleValue: 0.0, intSeed: 10), // roll=10 -> minor
      );

      final after = await (db.select(db.players)..where((p) => p.id.equals(target.id))).getSingle();
      expect(after.rosterSlot, RosterSlot.active);
      expect(after.gamesUnavailable, greaterThan(0));

      final injuryRows = await (db.select(db.injuries)..where((i) => i.playerId.equals(target.id))).get();
      expect(injuryRows, hasLength(1));
      expect(injuryRows.single.severity, InjurySeverity.minor);
      expect(injuryRows.single.replacementPlayerId, isNull);
    });

    test('moderate injury moves the player to dl and backfills, keeping active roster at 6', () async {
      final teamId = teamIds[0];
      final rosterBefore = await (db.select(db.players)..where((p) => p.teamId.equals(teamId))).get();
      final target = rosterBefore.first;
      final faId = await _insertFreeAgent(db, name: 'Replacement');

      final gameId =
          await _insertGame(db, seasonId: seasonId, homeTeamId: teamIds[0], awayTeamId: teamIds[1], gameNumber: 1);
      final box = sim.BoxScore()..battingFor(target.id, teamId).pa = 3;

      await checkForInjuries(
        db,
        gameId: gameId,
        seasonId: seasonId,
        box: box,
        random: const _FixedRandom(doubleValue: 0.0, intSeed: 75), // roll=75 -> moderate
      );

      final injured = await (db.select(db.players)..where((p) => p.id.equals(target.id))).getSingle();
      expect(injured.rosterSlot, RosterSlot.dl);
      expect(injured.gamesUnavailable, greaterThan(0));

      final replacement = await (db.select(db.players)..where((p) => p.id.equals(faId))).getSingle();
      expect(replacement.teamId, teamId);
      expect(replacement.rosterSlot, RosterSlot.active);

      final injuryRow =
          (await (db.select(db.injuries)..where((i) => i.playerId.equals(target.id))).get()).single;
      expect(injuryRow.severity, InjurySeverity.moderate);
      expect(injuryRow.replacementPlayerId, faId);

      final teamRoster = await (db.select(db.players)..where((p) => p.teamId.equals(teamId))).get();
      final activeAfter = teamRoster.where((p) => p.rosterSlot == RosterSlot.active).toList();
      expect(activeAfter, hasLength(6));
    });

    test('recovery reverses the specific DL stint, not another player on the same team', () async {
      final teamId = teamIds[0];
      final rosterBefore = await (db.select(db.players)..where((p) => p.teamId.equals(teamId))).get();
      final playerA = rosterBefore[0];
      final playerB = rosterBefore[1];
      final faA = await _insertFreeAgent(db, name: 'ReplacementA');
      final faB = await _insertFreeAgent(db, name: 'ReplacementB');

      final game1 =
          await _insertGame(db, seasonId: seasonId, homeTeamId: teamIds[0], awayTeamId: teamIds[1], gameNumber: 1);
      final game2 =
          await _insertGame(db, seasonId: seasonId, homeTeamId: teamIds[0], awayTeamId: teamIds[1], gameNumber: 2);

      // roll=70 -> moderate, gamesMissed = 4 + 70%7 = 4
      await checkForInjuries(
        db,
        gameId: game1,
        seasonId: seasonId,
        box: sim.BoxScore()..battingFor(playerA.id, teamId).pa = 3,
        random: const _FixedRandom(doubleValue: 0.0, intSeed: 70),
      );
      // roll=76 -> moderate, gamesMissed = 4 + 76%7 = 10
      await checkForInjuries(
        db,
        gameId: game2,
        seasonId: seasonId,
        box: sim.BoxScore()..battingFor(playerB.id, teamId).pa = 3,
        random: const _FixedRandom(doubleValue: 0.0, intSeed: 76),
      );

      final injuryA =
          (await (db.select(db.injuries)..where((i) => i.playerId.equals(playerA.id))).get()).single;
      final injuryB =
          (await (db.select(db.injuries)..where((i) => i.playerId.equals(playerB.id))).get()).single;
      expect(injuryA.replacementPlayerId, faA);
      expect(injuryB.replacementPlayerId, faB);
      expect(injuryA.gamesMissed, 4);
      expect(injuryB.gamesMissed, 10);

      // Decrement 4 times: A should fully recover; B (needs 10) should not.
      for (var i = 0; i < 4; i++) {
        await decrementAvailability(db, teamId: teamId);
      }

      final aAfter4 = await (db.select(db.players)..where((p) => p.id.equals(playerA.id))).getSingle();
      final faAAfter4 = await (db.select(db.players)..where((p) => p.id.equals(faA))).getSingle();
      final bAfter4 = await (db.select(db.players)..where((p) => p.id.equals(playerB.id))).getSingle();
      final faBAfter4 = await (db.select(db.players)..where((p) => p.id.equals(faB))).getSingle();

      expect(aAfter4.rosterSlot, RosterSlot.active, reason: 'A recovered');
      expect(aAfter4.gamesUnavailable, 0);
      expect(faAAfter4.teamId, isNull, reason: 'A\'s specific replacement was released');
      expect(faAAfter4.rosterSlot, isNull);

      expect(bAfter4.rosterSlot, RosterSlot.dl, reason: 'B is still hurt — untouched by A\'s reversal');
      expect(bAfter4.gamesUnavailable, 6);
      expect(faBAfter4.teamId, teamId, reason: 'B\'s replacement is untouched');
      expect(faBAfter4.rosterSlot, RosterSlot.active);

      // Finish decrementing B's remaining 6 games.
      for (var i = 0; i < 6; i++) {
        await decrementAvailability(db, teamId: teamId);
      }

      final bAfter10 = await (db.select(db.players)..where((p) => p.id.equals(playerB.id))).getSingle();
      final faBAfter10 = await (db.select(db.players)..where((p) => p.id.equals(faB))).getSingle();
      expect(bAfter10.rosterSlot, RosterSlot.active, reason: 'B recovered');
      expect(faBAfter10.teamId, isNull, reason: 'B\'s specific replacement was released');
    });
  });
}
