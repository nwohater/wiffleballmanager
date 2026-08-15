import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:wballmgr/ai/observed_stats.dart';
import 'package:wballmgr/data/database.dart';
import 'package:wballmgr/data/enums.dart';

import '../league/harness.dart';

void main() {
  late AppDatabase db;
  late int seasonId;
  late int teamId;
  late int gameId;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    seasonId = await db.into(db.seasons).insert(SeasonsCompanion.insert(number: 1));
    final teamIds = await makeTeamsWithRosters(db, count: 2);
    teamId = teamIds[0];
    gameId = await db.into(db.games).insert(GamesCompanion.insert(
          seasonId: seasonId,
          tier: Tier.major,
          homeTeamId: teamIds[0],
          awayTeamId: teamIds[1],
          gameNumber: 1,
        ));
  });

  tearDown(() async => db.close());

  test('derives OBP/SLG/ERA/WHIP/FPct from raw counting stats', () async {
    final players = await (db.select(db.players)..where((p) => p.teamId.equals(teamId))).get();
    final batterId = players[0].id;
    final pitcherId = players[1].id;
    final fielderId = players[2].id;

    // ab=8, h=3 (1 double, rest singles), bb=2, hbp=0, sf=0
    // OBP = (h+bb+hbp)/(ab+bb+hbp+sf) = (3+2)/(8+2) = 0.5
    // TB = h + doubles + 2*triples + 3*hr = 3 + 1 = 4; SLG = TB/ab = 4/8 = 0.5
    await db.into(db.battingStats).insert(BattingStatsCompanion.insert(
          gameId: gameId,
          playerId: batterId,
          teamId: teamId,
          pa: const Value(10),
          ab: const Value(8),
          h: const Value(3),
          doubles: const Value(1),
          bb: const Value(2),
        ));

    // outsRecorded=9 (3 IP), er=1, bb=1, h=2
    // ERA (ER*3/IP convention) = 1*3/3 = 1.0; WHIP = (1+2)/3 = 1.0
    await db.into(db.pitchingStats).insert(PitchingStatsCompanion.insert(
          gameId: gameId,
          playerId: pitcherId,
          teamId: teamId,
          outsRecorded: const Value(9),
          er: const Value(1),
          bb: const Value(1),
          h: const Value(2),
        ));

    // tc=5, e=1 -> FPct = (5-1)/5 = 0.8
    await db.into(db.fieldingStats).insert(FieldingStatsCompanion.insert(
          gameId: gameId,
          playerId: fielderId,
          teamId: teamId,
          outsPlayed: const Value(9),
          tc: const Value(5),
          e: const Value(1),
        ));

    final stats = await loadObservedStats(db, playerIds: [batterId, pitcherId, fielderId], seasonId: seasonId);

    expect(stats[batterId]!.pa, 10);
    expect(stats[batterId]!.obp, closeTo(0.5, 1e-9));
    expect(stats[batterId]!.slg, closeTo(0.5, 1e-9));

    expect(stats[pitcherId]!.outsRecorded, 9);
    expect(stats[pitcherId]!.era, closeTo(1.0, 1e-9));
    expect(stats[pitcherId]!.whip, closeTo(1.0, 1e-9));

    expect(stats[fielderId]!.chances, 5);
    expect(stats[fielderId]!.fpct, closeTo(0.8, 1e-9));
  });

  test('a player with no rows this season gets neutral placeholder scores, not zero', () async {
    final players = await (db.select(db.players)..where((p) => p.teamId.equals(teamId))).get();
    final unprovenId = players.first.id;

    final stats = await loadObservedStats(db, playerIds: [unprovenId], seasonId: seasonId);
    final line = stats[unprovenId]!;

    expect(line.pa, 0);
    expect(line.outsRecorded, 0);
    expect(line.chances, 0);
    // Neutral, not the worst-possible score a zero-PA/zero-IP player would
    // get if placeholders were 0 (which would auto-bench every rookie).
    expect(line.battingScore, greaterThan(0.5));
    expect(line.pitchingScore, greaterThan(-6.0));
    expect(line.fieldingScore, greaterThan(0.9));
  });
}
