
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_options.dart';
import 'screens/home_screen.dart';
import 'screens/timetable_screen.dart';
import 'theme/app_theme.dart';
import 'services/firebase_service.dart' as schedule;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  String? startupError;

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.android,
    );

    await FirebaseAuth.instance.signInAnonymously();

    await schedule.FirebaseService().seedClasses();

    debugPrint('Firebase connected successfully!');
    debugPrint('Dummy schedules checked successfully!');
  } catch (e) {
    startupError = e.toString();
    debugPrint('Firebase Error: $e');
  }

  runApp(ClassScheduleApp(
    startupError: startupError,
  ));
}

class ClassScheduleApp extends StatelessWidget {
  final String? startupError;

  const ClassScheduleApp({
    super.key,
    this.startupError,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weekly Schedule',
      theme: AppTheme.theme,
      home: startupError == null
          ? const MainScreen()
          : Scaffold(
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    'Firebase Error:\n$startupError',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;

  final List<Widget> screens = const [
    HomeScreen(),
    TimetableScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: 'Schedule',
          ),
        ],
      ),
    );
  }
}
