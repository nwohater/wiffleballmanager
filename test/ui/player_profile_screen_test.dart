import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:wballmgr/data/database.dart';
import 'package:wballmgr/data/enums.dart';
import 'package:wballmgr/league/league_seed.dart';
import 'package:wballmgr/main.dart';

void main() {
  testWidgets('tapping a roster player opens their profile with this season\'s stats', (tester) async {
    tester.view.physicalSize = const Size(1200, 3000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final db = AppDatabase.forTesting(NativeDatabase.memory());
    await seedNewLeagueIfEmpty(db);

    final playerOrg =
        await (db.select(db.organizations)..where((o) => o.isPlayerControlled.equals(true))).getSingle();
    final majorDivisionIds = (await (db.select(db.divisions)..where((d) => d.tier.equalsValue(Tier.major))).get())
        .map((d) => d.id)
        .toSet();
    final playerTeam = await (db.select(db.teams)
          ..where((t) => t.organizationId.equals(playerOrg.id) & t.divisionId.isIn(majorDivisionIds)))
        .getSingle();
    final rosterPlayer =
        (await (db.select(db.players)..where((p) => p.teamId.equals(playerTeam.id))).get()).first;

    await tester.pumpWidget(WballmgrApp(db: db));
    await tester.tap(find.text('Roster'));
    await tester.pumpAndSettle();

    expect(find.text('No stats recorded yet this season.'), findsNothing);

    await tester.tap(find.text('${rosterPlayer.firstName} ${rosterPlayer.lastName}').first);
    await tester.pumpAndSettle();

    expect(find.text('Player Profile'), findsOneWidget);
    expect(find.text('${rosterPlayer.firstName} ${rosterPlayer.lastName}'), findsOneWidget);
    expect(find.textContaining('Age ${rosterPlayer.age}'), findsOneWidget);
    expect(find.text('No stats recorded yet this season.'), findsOneWidget);

    await db.close();
  });

  testWidgets('tapping a batter in a box score opens their profile with recorded stats', (tester) async {
    tester.view.physicalSize = const Size(1200, 3000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final db = AppDatabase.forTesting(NativeDatabase.memory());
    await seedNewLeagueIfEmpty(db);

    await tester.pumpWidget(WballmgrApp(db: db));
    await tester.tap(find.text('Schedule'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Simulate Day').first);
    await tester.pumpAndSettle();

    final game = (await (db.select(db.games)..where((g) => g.status.equalsValue(GameStatus.completed))).get()).first;
    final teamNames = {for (final t in await db.select(db.teams).get()) t.id: t.name};
    final tileText = '${teamNames[game.awayTeamId]} @ ${teamNames[game.homeTeamId]}';
    await tester.tap(find.text(tileText).first);
    await tester.pumpAndSettle();

    final batting = await (db.select(db.battingStats)..where((b) => b.gameId.equals(game.id))).get();
    final batter = await (db.select(db.players)..where((p) => p.id.equals(batting.first.playerId))).getSingle();

    await tester.tap(find.text('${batter.firstName} ${batter.lastName}').first);
    await tester.pumpAndSettle();

    expect(find.text('Player Profile'), findsOneWidget);
    expect(find.text('${batter.firstName} ${batter.lastName}'), findsOneWidget);
    expect(find.text('Batting'), findsOneWidget);

    await db.close();
  });
}
