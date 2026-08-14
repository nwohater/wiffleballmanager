import 'package:drift/drift.dart';

import 'package:wballmgr/data/database.dart';
import 'package:wballmgr/sim/box_score.dart';

/// Straight field-by-field copy from a finished game's in-memory [BoxScore]
/// (lib/sim/box_score.dart) into the drift BattingStats/PitchingStats/
/// FieldingStats tables — the wiring that doc comment anticipated as
/// "a later phase's job." One row per player per stat category; batched
/// for one round trip per table.
Future<void> writeBoxScore(AppDatabase db, {required int gameId, required BoxScore box}) async {
  await db.batch((batch) {
    batch.insertAll(db.battingStats, [
      for (final b in box.batting.values)
        BattingStatsCompanion.insert(
          gameId: gameId,
          playerId: b.playerId,
          teamId: b.teamId,
          gs: Value(b.gs),
          pa: Value(b.pa),
          ab: Value(b.ab),
          r: Value(b.r),
          h: Value(b.h),
          doubles: Value(b.doubles),
          triples: Value(b.triples),
          hr: Value(b.hr),
          rbi: Value(b.rbi),
          bb: Value(b.bb),
          k: Value(b.k),
          hbp: Value(b.hbp),
          ibb: Value(b.ibb),
          sb: Value(b.sb),
          cs: Value(b.cs),
          sh: Value(b.sh),
          sf: Value(b.sf),
          dp: Value(b.dp),
          roe: Value(b.roe),
          fc: Value(b.fc),
          lob: Value(b.lob),
        ),
    ]);

    batch.insertAll(db.pitchingStats, [
      for (final p in box.pitching.values)
        PitchingStatsCompanion.insert(
          gameId: gameId,
          playerId: p.playerId,
          teamId: p.teamId,
          gs: Value(p.gs),
          cg: Value(p.cg),
          outsRecorded: Value(p.outsRecorded),
          r: Value(p.r),
          er: Value(p.er),
          h: Value(p.h),
          bb: Value(p.bb),
          hbp: Value(p.hbp),
          ibb: Value(p.ibb),
          k: Value(p.k),
          w: Value(p.w),
          l: Value(p.l),
          s: Value(p.s),
          hld: Value(p.hld),
          bs: Value(p.bs),
          wp: Value(p.wp),
        ),
    ]);

    batch.insertAll(db.fieldingStats, [
      for (final f in box.fielding.values)
        FieldingStatsCompanion.insert(
          gameId: gameId,
          playerId: f.playerId,
          teamId: f.teamId,
          gs: Value(f.gs),
          outsPlayed: Value(f.outsPlayed),
          tc: Value(f.tc),
          po: Value(f.po),
          a: Value(f.a),
          e: Value(f.e),
          dp: Value(f.dp),
          pb: Value(f.pb),
          sb: Value(f.sb),
          cs: Value(f.cs),
        ),
    ]);
  });
}
