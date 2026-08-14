import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:wballmgr/data/database.dart';
import 'package:wballmgr/data/enums.dart';
import 'package:wballmgr/league/playoffs.dart';

import 'harness.dart';

Standing _standing(int teamId, {required int w, required int l}) => Standing(
      id: teamId,
      seasonId: 1,
      teamId: teamId,
      w: w,
      l: l,
      t: 0,
      pf: 0,
      pa: 0,
    );

Future<void> _decideSeries(AppDatabase db, int seriesId) async {
  for (var i = 0; i < 7; i++) {
    final series = await (db.select(db.playoffSeries)..where((s) => s.id.equals(seriesId))).getSingle();
    if (series.winnerTeamId != null) return;
    await simulatePlayoffGame(db, seriesId: seriesId);
  }
  throw StateError('Series $seriesId did not decide within 7 games.');
}

void main() {
  group('seedsFromStandings', () {
    test('picks each division leader for seeds 1-3, best remaining team as the wildcard', () {
      final teamDivisionId = {
        for (var i = 1; i <= 4; i++) i: 1,
        for (var i = 5; i <= 8; i++) i: 2,
        for (var i = 9; i <= 12; i++) i: 3,
      };
      final standings = [
        _standing(1, w: 20, l: 13), _standing(2, w: 15, l: 18), _standing(3, w: 10, l: 23), _standing(4, w: 5, l: 28),
        _standing(5, w: 25, l: 8), _standing(6, w: 12, l: 21), _standing(7, w: 8, l: 25), _standing(8, w: 3, l: 30),
        _standing(9, w: 18, l: 15), _standing(10, w: 22, l: 11), _standing(11, w: 9, l: 24), _standing(12, w: 6, l: 27),
      ];

      final seeds = seedsFromStandings(standings, teamDivisionId);

      expect(seeds.length, 4);
      expect(seeds[0], 5); // div2 leader, .758
      expect(seeds[1], 10); // div3 leader, .667
      expect(seeds[2], 1); // div1 leader, .606
      expect(seeds[3], 9); // best non-leader, .545
    });
  });

  group('playoff series progression (drift-coupled)', () {
    test('simulatePlayoffGame clinches a best-of-5 at 3 wins, within 5 games', () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      final seasonId = await db.into(db.seasons).insert(SeasonsCompanion.insert(number: 1));
      final teamIds = await makeTeamsWithRosters(db, count: 2);
      final seriesId = await db.into(db.playoffSeries).insert(PlayoffSeriesCompanion.insert(
            seasonId: seasonId,
            round: PlayoffRound.semifinal,
            higherSeedTeamId: teamIds[0],
            higherSeedRank: 1,
            lowerSeedTeamId: teamIds[1],
            lowerSeedRank: 4,
            bestOf: 5,
          ));

      await _decideSeries(db, seriesId);

      final finalSeries = await (db.select(db.playoffSeries)..where((s) => s.id.equals(seriesId))).getSingle();
      expect(finalSeries.winnerTeamId, isNotNull);
      expect(finalSeries.higherSeedWins >= 3 || finalSeries.lowerSeedWins >= 3, isTrue);
      expect(finalSeries.higherSeedWins + finalSeries.lowerSeedWins, lessThanOrEqualTo(5));

      await db.close();
    });

    test('championship series is created once both semifinals decide, and reseeds by original rank', () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      final seasonId = await db.into(db.seasons).insert(SeasonsCompanion.insert(number: 1));
      final teamIds = await makeTeamsWithRosters(db, count: 4);

      final semi1Id = await db.into(db.playoffSeries).insert(PlayoffSeriesCompanion.insert(
            seasonId: seasonId,
            round: PlayoffRound.semifinal,
            higherSeedTeamId: teamIds[0],
            higherSeedRank: 1,
            lowerSeedTeamId: teamIds[3],
            lowerSeedRank: 4,
            bestOf: 5,
          ));
      final semi2Id = await db.into(db.playoffSeries).insert(PlayoffSeriesCompanion.insert(
            seasonId: seasonId,
            round: PlayoffRound.semifinal,
            higherSeedTeamId: teamIds[1],
            higherSeedRank: 2,
            lowerSeedTeamId: teamIds[2],
            lowerSeedRank: 3,
            bestOf: 5,
          ));

      await _decideSeries(db, semi1Id);
      await _decideSeries(db, semi2Id);

      final allSeries = await (db.select(db.playoffSeries)..where((s) => s.seasonId.equals(seasonId))).get();
      final championship = allSeries.where((s) => s.round == PlayoffRound.championship).toList();
      expect(championship.length, 1);
      expect(championship.first.bestOf, 7);

      // The championship's higherSeedRank must be the better (lower-numbered)
      // rank of the two semifinal winners, regardless of which bracket half
      // they came from.
      final finishedSemis =
          await (db.select(db.playoffSeries)..where((s) => s.round.equalsValue(PlayoffRound.semifinal))).get();
      final winnerRanks = [
        for (final s in finishedSemis)
          s.winnerTeamId == s.higherSeedTeamId ? s.higherSeedRank : s.lowerSeedRank,
      ]..sort();
      expect(championship.first.higherSeedRank, winnerRanks.first);
      expect(championship.first.lowerSeedRank, winnerRanks.last);

      await db.close();
    });

    test('championTeamId is null until the championship is decided', () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      final seasonId = await db.into(db.seasons).insert(SeasonsCompanion.insert(number: 1));
      expect(await championTeamId(db, seasonId), isNull);
      await db.close();
    });
  });
}
