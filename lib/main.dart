import 'package:flutter/material.dart';

// Screens
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/dashboard_screen.dart'; // contains MainDashboardScreen
import 'screens/profile_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/applock_screen.dart'; // contains AppLockScreen
import 'screens/focus_screen.dart';
import 'screens/schedule_screen.dart';
import 'screens/todays_task_screen.dart'; // contains TodaysTasksScreen
import 'screens/daily_summary_screen.dart';
import 'screens/data_analytics.dart'; // contains DataAnalytics

void main() {
  runApp(MyApp());
}

/// AppColors, TextStyles, Dimensions
class AppColors {
  static const primary = Colors.blue;
  static const accent = Colors.orange;
}

class AppTextStyles {
  static const header = TextStyle(
    fontSize: 24,
    color: AppColors.primary,
    fontWeight: FontWeight.bold,
  );
  static const subHeader = TextStyle(
    fontSize: 18,
    color: Colors.black87,
    fontStyle: FontStyle.italic,
  );
}

class AppDimens {
  static const padding = EdgeInsets.all(16.0);
}

/// MyApp manages the global theme state
class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _handleThemeChange(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Focus Shift',
      themeMode: _themeMode,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'CustomFont',
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'CustomFont',
        brightness: Brightness.dark,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/dashboard': (context) => MainDashboardScreen(),
        '/profile':
            (context) => ProfileScreen(onThemeChanged: _handleThemeChange),
        '/settings':
            (context) => SettingsScreen(onThemeChanged: _handleThemeChange),
        '/applock': (context) => AppLockScreen(), // ✅ App Lock added
        '/focus': (context) => FocusScreen(),
        '/schedule': (context) => ScheduleScreen(),
        '/todays_tasks': (context) => TodaysTaskScreen(),
        '/daily_summary': (context) => DailySummaryScreen(),
        '/data_analytics': (context) => DataAnalytics(),
      },
    );
  }
}
