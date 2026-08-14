import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:wballmgr/data/database.dart';
import 'package:wballmgr/main.dart';

void main() {
  testWidgets('app shell navigates between tabs', (WidgetTester tester) async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    await tester.pumpWidget(WballmgrApp(db: db));

    expect(find.text('Home'), findsWidgets);

    await tester.tap(find.text('Roster'));
    await tester.pumpAndSettle();

    expect(find.text('Roster'), findsWidgets);

    await db.close();
  });
}
