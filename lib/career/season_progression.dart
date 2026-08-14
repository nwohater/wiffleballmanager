import 'dart:math';

import 'package:drift/drift.dart';

import 'package:wballmgr/data/database.dart';
import 'package:wballmgr/data/enums.dart';

import 'aging.dart';
import 'injuries_engine.dart';

/// Full-season workload a true full-time starter would rack up across a
/// 33-game season (PRD schedule length), used as the [playingTimeFactor]
/// denominator. See context/player-ratings.md — uncalibrated starting
/// point.
const int _fullSeasonPa = 132; // ~4 PA/game
const int _fullSeasonOuts = 297; // 9 outs/game (3 regulation innings)

/// Growth/decline/jitter multiplier applied on top of the usual
/// [playingTimeFactor] for a season in which the player suffered a
/// moderate-or-worse injury — context/player-ratings.md "Career
/// Progression: Injuries".
const double _injuryDampening = 0.5;

/// Chance a single major injury leaves permanent damage: a small (1-5)
/// reduction to all 4 potential ceilings, with current ratings clamped
/// down to match. Rolled independently per major injury in the season.
const double _majorPermanentDamageChance = 0.15;

/// Ages every player (rostered or free agent — everyone ages) one season:
/// sums their BattingStats/PitchingStats/FieldingStats for [seasonId] into
/// per-cluster playing-time factors, applies any this-season injury
/// dampening/permanent damage, then runs [applyAging] per cluster and
/// writes the results back.
Future<void> applySeasonDevelopment(AppDatabase db, {required int seasonId, Random? random}) async {
  final rng = random ?? Random();

  final gameIds =
      (await (db.select(db.games)..where((g) => g.seasonId.equals(seasonId))).get()).map((g) => g.id).toSet();

  final paByPlayer = <int, int>{};
  if (gameIds.isNotEmpty) {
    for (final row in await (db.select(db.battingStats)..where((b) => b.gameId.isIn(gameIds))).get()) {
      paByPlayer.update(row.playerId, (v) => v + row.pa, ifAbsent: () => row.pa);
    }
  }
  final pitchOutsByPlayer = <int, int>{};
  if (gameIds.isNotEmpty) {
    for (final row in await (db.select(db.pitchingStats)..where((p) => p.gameId.isIn(gameIds))).get()) {
      pitchOutsByPlayer.update(row.playerId, (v) => v + row.outsRecorded, ifAbsent: () => row.outsRecorded);
    }
  }
  final fieldOutsByPlayer = <int, int>{};
  if (gameIds.isNotEmpty) {
    for (final row in await (db.select(db.fieldingStats)..where((f) => f.gameId.isIn(gameIds))).get()) {
      fieldOutsByPlayer.update(row.playerId, (v) => v + row.outsPlayed, ifAbsent: () => row.outsPlayed);
    }
  }

  final injuriesByPlayer = <int, List<Injury>>{};
  for (final row in await (db.select(db.injuries)..where((i) => i.seasonId.equals(seasonId))).get()) {
    injuriesByPlayer.putIfAbsent(row.playerId, () => []).add(row);
  }

  for (final player in await db.select(db.players).get()) {
    final battingFactor =
        playingTimeFactor(actualUsage: paByPlayer[player.id] ?? 0, fullSeasonBaseline: _fullSeasonPa);
    final pitchingFactor =
        playingTimeFactor(actualUsage: pitchOutsByPlayer[player.id] ?? 0, fullSeasonBaseline: _fullSeasonOuts);
    final fieldingFactor =
        playingTimeFactor(actualUsage: fieldOutsByPlayer[player.id] ?? 0, fullSeasonBaseline: _fullSeasonOuts);
    // Speed only shows up via baserunning off batting appearances — no
    // separate stat to derive its own playing-time factor from.
    final speedFactor = battingFactor;

    final injuries = injuriesByPlayer[player.id] ?? const <Injury>[];
    final worst = _worstSeverity(injuries);
    final dampening =
        (worst == InjurySeverity.moderate || worst == InjurySeverity.major) ? _injuryDampening : 1.0;

    var battingPotential = player.battingPotential;
    var pitchingPotential = player.pitchingPotential;
    var fieldingPotential = player.fieldingPotential;
    var speedPotential = player.speedPotential;
    for (final injury in injuries) {
      if (injury.severity == InjurySeverity.major && rng.nextDouble() < _majorPermanentDamageChance) {
        final damage = 1 + rng.nextInt(5);
        battingPotential = (battingPotential - damage).clamp(0, 99);
        pitchingPotential = (pitchingPotential - damage).clamp(0, 99);
        fieldingPotential = (fieldingPotential - damage).clamp(0, 99);
        speedPotential = (speedPotential - damage).clamp(0, 99);
      }
    }

    int age(int rating, int potential, double factor) => applyAging(
          rating: rating,
          potential: potential,
          age: player.age,
          playingTimeFactor: factor * dampening,
          rng: rng,
        );

    await (db.update(db.players)..where((p) => p.id.equals(player.id))).write(
      PlayersCompanion(
        age: Value(player.age + 1),
        contact: Value(age(player.contact, battingPotential, battingFactor)),
        power: Value(age(player.power, battingPotential, battingFactor)),
        discipline: Value(age(player.discipline, battingPotential, battingFactor)),
        speed: Value(age(player.speed, speedPotential, speedFactor)),
        control: Value(age(player.control, pitchingPotential, pitchingFactor)),
        stamina: Value(age(player.stamina, pitchingPotential, pitchingFactor)),
        range: Value(age(player.range, fieldingPotential, fieldingFactor)),
        hands: Value(age(player.hands, fieldingPotential, fieldingFactor)),
        arm: Value(age(player.arm, fieldingPotential, fieldingFactor)),
        battingPotential: Value(battingPotential),
        pitchingPotential: Value(pitchingPotential),
        fieldingPotential: Value(fieldingPotential),
        speedPotential: Value(speedPotential),
      ),
    );
  }
}

InjurySeverity? _worstSeverity(List<Injury> injuries) {
  InjurySeverity? worst;
  for (final injury in injuries) {
    if (worst == null || injury.severity.index > worst.index) {
      worst = injury.severity;
    }
  }
  return worst;
}

/// Forces every still-`dl` player back to active (reversing their specific
/// replacement, same as an in-season recovery) and zeroes `gamesUnavailable`
/// for everyone — every player starts the new season healthy, per the
/// design doc.
Future<void> resolveEndOfSeasonDl(AppDatabase db, {required int seasonId}) async {
  final dlPlayers = await (db.select(db.players)..where((p) => p.rosterSlot.equalsValue(RosterSlot.dl))).get();
  for (final player in dlPlayers) {
    await reverseDlStint(db, playerId: player.id);
  }
  await db.update(db.players).write(const PlayersCompanion(gamesUnavailable: Value(0)));
}
