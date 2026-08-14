import 'package:flutter/widgets.dart';

import '../data/database.dart';

/// Makes the single app-wide [AppDatabase] instance reachable from any
/// widget via `AppScope.of(context).db`, without pulling in a DI package.
class AppScope extends InheritedWidget {
  const AppScope({super.key, required this.db, required super.child});

  final AppDatabase db;

  static AppScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'No AppScope found in context');
    return scope!;
  }

  @override
  bool updateShouldNotify(AppScope oldWidget) => db != oldWidget.db;
}
