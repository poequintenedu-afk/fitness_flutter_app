import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/fitness_provider.dart';
import 'screens/dashboard_screen.dart';
import 'screens/activity_log_screen.dart';
import 'screens/progress_tracking_screen.dart';
import 'screens/workout_planning_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FitnessProvider()),
      ],
      child: MaterialApp(
        title: 'Fitness Tracker',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          primaryColor: Color(0xFF6366F1),
          scaffoldBackgroundColor: Color(0xFFFAFAFA),
          appBarTheme: AppBarTheme(
            backgroundColor: Color(0xFF6366F1),
            elevation: 0,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF6366F1),
              foregroundColor: Colors.white,
            ),
          ),
        ),
        home: const MainApp(),
        routes: {
          '/dashboard': (context) => const DashboardScreen(),
          '/activity-log': (context) => const ActivityLogScreen(),
          '/progress': (context) => const ProgressTrackingScreen(),
          '/workout-planning': (context) => const WorkoutPlanningScreen(),
        },
      ),
    );
  }
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getScreen(_selectedIndex),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const <NavigationDestination>[
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.history),
            label: 'Activity Log',
          ),
          NavigationDestination(
            icon: Icon(Icons.trending_up),
            label: 'Progress',
          ),
          NavigationDestination(
            icon: Icon(Icons.fitness_center),
            label: 'Planning',
          ),
        ],
      ),
    );
  }

  Widget _getScreen(int index) {
    switch (index) {
      case 0:
        return const DashboardScreen();
      case 1:
        return const ActivityLogScreen();
      case 2:
        return const ProgressTrackingScreen();
      case 3:
        return const WorkoutPlanningScreen();
      default:
        return const DashboardScreen();
    }
  }
}
