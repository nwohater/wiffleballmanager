import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:wballmgr/data/database.dart';
import 'package:wballmgr/data/enums.dart';
import 'package:wballmgr/league/league_seed.dart';
import 'package:wballmgr/main.dart';

void main() {
  testWidgets('home screen shows the player org\'s major/minor records and next game, updated after a sim',
      (tester) async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    await seedNewLeagueIfEmpty(db);

    final playerOrg =
        await (db.select(db.organizations)..where((o) => o.isPlayerControlled.equals(true))).getSingle();
    final orgTeams = await (db.select(db.teams)..where((t) => t.organizationId.equals(playerOrg.id))).get();
    final divisions = {for (final d in await db.select(db.divisions).get()) d.id: d};
    final majorTeam = orgTeams.firstWhere((t) => divisions[t.divisionId]!.tier == Tier.major);
    final minorTeam = orgTeams.firstWhere((t) => divisions[t.divisionId]!.tier == Tier.minor);

    // Home is the default tab.
    await tester.pumpWidget(WballmgrApp(db: db));
    await tester.pumpAndSettle();

    expect(find.text('Season 1'), findsOneWidget);
    expect(find.text(majorTeam.name), findsOneWidget);
    expect(find.text(minorTeam.name), findsOneWidget);
    expect(find.text('0-0-0  (0.000)'), findsNWidgets(2));
    expect(find.textContaining('Next: '), findsNWidgets(2));
    expect(find.textContaining('Day 1'), findsWidgets);

    await tester.tap(find.text('Schedule'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Simulate Day').first);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();

    expect(find.text('0-0-0  (0.000)'), findsNothing, reason: 'both teams played a game on day 1');
    expect(find.textContaining('Day 2'), findsWidgets);

    await db.close();
  });
}
