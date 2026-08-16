import 'dart:math';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:wballmgr/data/database.dart';
import 'package:wballmgr/data/enums.dart';
import 'package:wballmgr/draft/draft_manager.dart';
import 'package:wballmgr/league/game_runner.dart';
import 'package:wballmgr/league/league_seed.dart';
import 'package:wballmgr/league/season_rollover.dart';
import 'package:wballmgr/main.dart';

void main() {
  testWidgets('draft tab shows a completed season\'s picks', (tester) async {
    tester.view.physicalSize = const Size(1200, 3000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final seasonId = await seedNewLeague(db);
    await simulateRestOfSeason(db, seasonId: seasonId);
    await runDraft(db, seasonId: seasonId, random: Random(7));

    await tester.pumpWidget(WballmgrApp(db: db));
    await tester.tap(find.text('Draft/Trade'));
    await tester.pumpAndSettle();

    expect(find.text('Season 1 Draft'), findsOneWidget);
    expect(find.text('R1 #1'), findsOneWidget);

    await db.close();
  });

  testWidgets(
      'draft tab still shows the just-completed season\'s picks after "Start Next Season" rolls the active '
      'season forward', (tester) async {
    // Regression test: runDraft records picks against the *completed*
    // season (see draft_manager.dart/season_rollover.dart), but the screen
    // used to query DraftPicks for whichever season was currently active —
    // which, right after a rollover, is the brand-new season that hasn't
    // had its own draft yet. That made the draft look like it silently
    // didn't happen, even though it did.
    tester.view.physicalSize = const Size(1200, 3000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final seasonId = await seedNewLeague(db);
    await simulateRestOfSeason(db, seasonId: seasonId);
    final newSeasonId = await rolloverSeason(db, completedSeasonId: seasonId, random: Random(7));
    expect(newSeasonId, isNot(seasonId));

    final picks = await (db.select(db.draftPicks)..where((p) => p.seasonId.equals(seasonId))).get();
    expect(picks, isNotEmpty, reason: 'sanity check: rolloverSeason should have actually run the draft');

    await tester.pumpWidget(WballmgrApp(db: db));
    await tester.tap(find.text('Draft/Trade'));
    await tester.pumpAndSettle();

    expect(find.text('Season 1 Draft'), findsOneWidget);
    expect(find.text('R1 #1'), findsOneWidget);
    expect(find.textContaining('runs automatically'), findsNothing);

    await db.close();
  });

  testWidgets('draft tab explains the draft is automatic when no picks exist yet', (tester) async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    await seedNewLeagueIfEmpty(db);

    await tester.pumpWidget(WballmgrApp(db: db));
    await tester.tap(find.text('Draft/Trade'));
    await tester.pumpAndSettle();

    expect(find.textContaining('runs automatically'), findsOneWidget);

    await db.close();
  });

  testWidgets('trade tab lets the player select an opponent and propose a trade', (tester) async {
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
    final majorTeams = await (db.select(db.teams)..where((t) => t.divisionId.isIn(majorDivisionIds))).get();
    final myTeam = majorTeams.firstWhere((t) => t.organizationId == playerOrg.id);
    final opposingTeam = majorTeams.firstWhere((t) => t.organizationId != playerOrg.id);
    final myPlayer = (await (db.select(db.players)..where((p) => p.teamId.equals(myTeam.id))).get()).first;
    final theirPlayer =
        (await (db.select(db.players)..where((p) => p.teamId.equals(opposingTeam.id))).get()).first;

    await tester.pumpWidget(WballmgrApp(db: db));
    await tester.tap(find.text('Draft/Trade'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Trade'));
    await tester.pumpAndSettle();

    expect(find.text('The trade deadline has passed for this season.'), findsNothing);

    await tester.tap(find.byKey(const ValueKey('opposingTeamDropdown')));
    await tester.pumpAndSettle();
    await tester.tap(find.text(opposingTeam.name).last);
    await tester.pumpAndSettle();

    expect(find.text('They send:'), findsOneWidget);

    await tester.tap(find.byKey(ValueKey('mine-${myPlayer.id}')));
    await tester.pump();
    await tester.tap(find.byKey(ValueKey('theirs-${theirPlayer.id}')));
    await tester.pump();

    final proposeButton = find.widgetWithText(FilledButton, 'Propose Trade');
    expect(tester.widget<FilledButton>(proposeButton).onPressed, isNotNull, reason: 'button should be enabled');
    await tester.tap(proposeButton);
    await tester.pumpAndSettle();

    final accepted = find.text('Trade accepted and executed.');
    final declined = find.textContaining('declined the offer.');
    expect(accepted.evaluate().isNotEmpty || declined.evaluate().isNotEmpty, isTrue);

    await db.close();
  });
}
