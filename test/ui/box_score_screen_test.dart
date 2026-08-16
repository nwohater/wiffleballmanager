import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:wballmgr/data/database.dart';
import 'package:wballmgr/data/enums.dart';
import 'package:wballmgr/league/league_seed.dart';
import 'package:wballmgr/main.dart';

void main() {
  testWidgets('tapping a completed game on the Schedule screen opens its box score', (tester) async {
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

    expect(find.text('Box Score'), findsOneWidget);
    expect(find.text('${game.awayScore} - ${game.homeScore}'), findsOneWidget);

    final batting = await (db.select(db.battingStats)..where((b) => b.gameId.equals(game.id))).get();
    expect(batting, isNotEmpty);
    final firstBatter = await (db.select(db.players)..where((p) => p.id.equals(batting.first.playerId))).getSingle();
    expect(find.text('${firstBatter.firstName} ${firstBatter.lastName}'), findsWidgets);

    final pitching = await (db.select(db.pitchingStats)..where((p) => p.gameId.equals(game.id))).get();
    expect(pitching, isNotEmpty);

    await db.close();
  });
}
