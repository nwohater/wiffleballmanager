import 'package:flutter/material.dart';

import 'data/database.dart';
import 'league/league_seed.dart';
import 'ui/app_scope.dart';
import 'ui/screens/home_screen.dart';
import 'ui/screens/roster_screen.dart';
import 'ui/screens/schedule_screen.dart';
import 'ui/screens/standings_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = AppDatabase();
  await seedNewLeagueIfEmpty(db);
  runApp(WballmgrApp(db: db));
}

class WballmgrApp extends StatelessWidget {
  const WballmgrApp({super.key, required this.db});

  final AppDatabase db;

  @override
  Widget build(BuildContext context) {
    return AppScope(
      db: db,
      child: MaterialApp(
        title: 'WiffleBallMGr',
        theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
        home: const AppShell(),
      ),
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  static const _screens = [
    HomeScreen(),
    RosterScreen(),
    ScheduleScreen(),
    StandingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('WiffleBallMGr')),
      body: _screens[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.groups), label: 'Roster'),
          NavigationDestination(icon: Icon(Icons.calendar_month), label: 'Schedule'),
          NavigationDestination(icon: Icon(Icons.leaderboard), label: 'Standings'),
        ],
      ),
    );
  }
}
