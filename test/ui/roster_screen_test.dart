import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:wballmgr/data/database.dart';
import 'package:wballmgr/data/enums.dart';
import 'package:wballmgr/league/league_seed.dart';
import 'package:wballmgr/main.dart';

void main() {
  testWidgets('roster screen shows the seeded roster, an empty DL section, and persists an edited lineup',
      (tester) async {
    // The roster screen's content is taller than the default test surface;
    // make the surface tall enough that everything is built (no scrolling
    // needed to find widgets by key/text below the fold).
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

    final before =
        await (db.select(db.teamLineups)..where((l) => l.teamId.equals(playerTeam.id))).getSingle();
    final battingIds = before.battingOrder.split(',').map(int.parse).toList();
    final removedBatterId = battingIds.first;

    final teamPlayers = await (db.select(db.players)..where((p) => p.teamId.equals(playerTeam.id))).get();
    final newFielder2 =
        teamPlayers.firstWhere((p) => p.id != before.fielder2Id && p.id != before.fielder3Id);

    await tester.pumpWidget(WballmgrApp(db: db));
    await tester.tap(find.text('Roster'));
    await tester.pumpAndSettle();

    expect(find.text('Roster (6 active)'), findsOneWidget);
    // A freshly seeded league has nobody hurt — the DL section shouldn't
    // render at all.
    expect(find.text('Disabled List'), findsNothing);

    // Drop a batter, then add them straight back — a round trip through
    // the remove/add controls that should leave the same 5 players but in
    // a different order (the re-added player moves to the end).
    final battingTile = find.byKey(ValueKey('bat-$removedBatterId'));
    expect(battingTile, findsOneWidget);
    await tester.tap(find.descendant(of: battingTile, matching: find.byIcon(Icons.remove_circle_outline)));
    await tester.pump();

    final readdChip = find.byKey(ValueKey('addBat-$removedBatterId'));
    expect(readdChip, findsOneWidget);
    await tester.tap(readdChip);
    await tester.pump();

    // Swap Fielder 2 to a different active player.
    await tester.tap(find.byKey(const ValueKey('fielder2Dropdown')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(ValueKey('fielder2Option-${newFielder2.id}')).last);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Save Lineup'));
    await tester.pumpAndSettle();

    expect(find.text('Lineup saved.'), findsOneWidget);

    final after =
        await (db.select(db.teamLineups)..where((l) => l.teamId.equals(before.teamId))).getSingle();
    final afterBattingIds = after.battingOrder.split(',').map(int.parse).toList();

    expect(afterBattingIds.length, 5);
    expect(afterBattingIds.toSet(), battingIds.toSet(), reason: 'same 5 batters, re-added after removal');
    expect(afterBattingIds.last, removedBatterId, reason: 'the re-added player moved to the end');
    expect(after.fielder2Id, newFielder2.id, reason: 'fielder 2 swap persisted');

    await db.close();
  });
}
