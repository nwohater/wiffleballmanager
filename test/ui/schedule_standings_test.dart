import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:wballmgr/data/database.dart';
import 'package:wballmgr/data/enums.dart';
import 'package:wballmgr/league/league_seed.dart';
import 'package:wballmgr/main.dart';

void main() {
  testWidgets('schedule screen simulates a day and standings reflect it', (tester) async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    await seedNewLeagueIfEmpty(db);

    await tester.pumpWidget(WballmgrApp(db: db));
    await tester.tap(find.text('Schedule'));
    await tester.pumpAndSettle();

    // Day 1 is the first item in the list, so it's built without scrolling.
    expect(find.text('Day 1'), findsOneWidget);
    expect(find.text('Simulate Day'), findsWidgets);

    await tester.tap(find.text('Simulate Day').first);
    await tester.pumpAndSettle();

    final day1Games = await (db.select(db.games)..where((g) => g.gameNumber.equals(1))).get();
    expect(day1Games, hasLength(12), reason: '6 major + 6 minor games share day 1');
    expect(day1Games.every((g) => g.status == GameStatus.completed), isTrue);

    await tester.tap(find.text('Standings'));
    await tester.pumpAndSettle();

    final standings = await db.select(db.standings).get();
    expect(standings.where((s) => s.w + s.l + s.t > 0).length, 24,
        reason: 'every major and minor team played exactly once on day 1');

    await db.close();
  });
}
