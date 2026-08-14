import 'dart:math';

import 'package:drift/drift.dart';

import 'package:wballmgr/data/database.dart';
import 'package:wballmgr/data/enums.dart';
import 'package:wballmgr/roster/roster_generator.dart';
import 'package:wballmgr/roster/roster_writer.dart';

/// Signs the first available unrostered player onto [teamId] as active,
/// generating one on the fly (via [generateFreeAgentPool]) if the standing
/// pool is unexpectedly empty. Returns the signed player's id.
Future<int> signFreeAgent(
  AppDatabase db, {
  required int teamId,
  required int organizationId,
  Random? random,
}) async {
  final existing =
      await (db.select(db.players)..where((p) => p.teamId.isNull())..limit(1)).getSingleOrNull();

  final playerId = existing?.id ??
      (await writeFreeAgentPool(db, generateFreeAgentPool(random ?? Random(), count: 1))).single;

  await (db.update(db.players)..where((p) => p.id.equals(playerId))).write(
    PlayersCompanion(
      teamId: Value(teamId),
      organizationId: Value(organizationId),
      rosterSlot: const Value(RosterSlot.active),
    ),
  );
  return playerId;
}

/// Cuts [playerId] loose back to the free-agent pool (null org/team/slot).
Future<void> releaseToFreeAgency(AppDatabase db, {required int playerId}) async {
  await (db.update(db.players)..where((p) => p.id.equals(playerId))).write(
    const PlayersCompanion(
      teamId: Value(null),
      organizationId: Value(null),
      rosterSlot: Value(null),
    ),
  );
}

/// Tops the standing unrostered pool back up to [targetSize], generating
/// only as many new players as needed.
Future<void> topUpFreeAgentPool(AppDatabase db, {Random? random, int targetSize = 25}) async {
  final current = await (db.select(db.players)..where((p) => p.teamId.isNull())).get();
  final needed = targetSize - current.length;
  if (needed <= 0) return;
  await writeFreeAgentPool(db, generateFreeAgentPool(random ?? Random(), count: needed));
}
