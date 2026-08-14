import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:wballmgr/data/database.dart';
import 'package:wballmgr/data/enums.dart';
import 'package:wballmgr/league/standings.dart';

Future<int> _makeTeam(AppDatabase db, {required int seasonId, required String name}) async {
  final divisionId = await db.into(db.divisions).insert(DivisionsCompanion.insert(name: 'D', tier: Tier.major));
  final orgId = await db.into(db.organizations).insert(OrganizationsCompanion.insert(name: name));
  final teamId = await db.into(db.teams).insert(
        TeamsCompanion.insert(organizationId: orgId, divisionId: divisionId, name: name),
      );
  await db.into(db.standings).insert(StandingsCompanion.insert(seasonId: seasonId, teamId: teamId));
  return teamId;
}

void main() {
  group('recordGameResult', () {
    late AppDatabase db;
    late int seasonId;

    setUp(() async {
      db = AppDatabase.forTesting(NativeDatabase.memory());
      seasonId = await db.into(db.seasons).insert(SeasonsCompanion.insert(number: 1));
    });

    tearDown(() => db.close());

    test('upserts W/L/PF/PA for both teams', () async {
      final home = await _makeTeam(db, seasonId: seasonId, name: 'Home');
      final away = await _makeTeam(db, seasonId: seasonId, name: 'Away');

      await recordGameResult(
        db,
        seasonId: seasonId,
        homeTeamId: home,
        awayTeamId: away,
        homeScore: 5,
        awayScore: 2,
      );

      final homeRow = await (db.select(db.standings)..where((s) => s.teamId.equals(home))).getSingle();
      final awayRow = await (db.select(db.standings)..where((s) => s.teamId.equals(away))).getSingle();

      expect(homeRow.w, 1);
      expect(homeRow.l, 0);
      expect(homeRow.pf, 5);
      expect(homeRow.pa, 2);
      expect(awayRow.w, 0);
      expect(awayRow.l, 1);
      expect(awayRow.pf, 2);
      expect(awayRow.pa, 5);
    });

    test('a second game accumulates rather than overwrites', () async {
      final home = await _makeTeam(db, seasonId: seasonId, name: 'Home');
      final away = await _makeTeam(db, seasonId: seasonId, name: 'Away');

      await recordGameResult(
          db, seasonId: seasonId, homeTeamId: home, awayTeamId: away, homeScore: 5, awayScore: 2);
      // Second game: away hosts and wins.
      await recordGameResult(
          db, seasonId: seasonId, homeTeamId: away, awayTeamId: home, homeScore: 3, awayScore: 1);

      final homeRow = await (db.select(db.standings)..where((s) => s.teamId.equals(home))).getSingle();
      expect(homeRow.w, 1);
      expect(homeRow.l, 1);
      expect(homeRow.pf, 6); // 5 + 1
      expect(homeRow.pa, 5); // 2 + 3
    });

    test('a tied score credits both teams a tie', () async {
      final home = await _makeTeam(db, seasonId: seasonId, name: 'Home');
      final away = await _makeTeam(db, seasonId: seasonId, name: 'Away');

      await recordGameResult(
          db, seasonId: seasonId, homeTeamId: home, awayTeamId: away, homeScore: 4, awayScore: 4);

      final homeRow = await (db.select(db.standings)..where((s) => s.teamId.equals(home))).getSingle();
      expect(homeRow.t, 1);
      expect(homeRow.w, 0);
      expect(homeRow.l, 0);
    });
  });

  group('compareStandings', () {
    test('orders by Pct desc, then PA asc, then PF desc', () {
      Standing s(int teamId, {required int w, required int l, required int pf, required int pa}) => Standing(
            id: teamId,
            seasonId: 1,
            teamId: teamId,
            w: w,
            l: l,
            t: 0,
            pf: pf,
            pa: pa,
          );

      final a = s(1, w: 5, l: 5, pf: 50, pa: 40); // .500
      final b = s(2, w: 6, l: 4, pf: 50, pa: 40); // .600 — best pct
      final c = s(3, w: 5, l: 5, pf: 60, pa: 30); // .500, fewer PA than a/d
      final d = s(4, w: 5, l: 5, pf: 55, pa: 40); // .500, same PA as a, more PF

      final sorted = [a, b, c, d]..sort(compareStandings);
      expect(sorted.map((x) => x.teamId).toList(), [2, 3, 4, 1]);
    });
  });
}
