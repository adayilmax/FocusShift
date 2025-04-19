import 'package:flutter/material.dart';

// Screens
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/card_list_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/applock_screen.dart';
import 'screens/focus_screen.dart';
import 'screens/schedule_screen.dart';

void main() {
  runApp(MyApp());
}

/// App-wide theming and constants
class AppColors {
  static const primary = Colors.blue;
  static const accent = Colors.orange;
}

class AppTextStyles {
  static const header = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );
  static const subHeader = TextStyle(
    fontSize: 18,
    fontStyle: FontStyle.italic,
    color: Colors.black87,
  );
}

class AppDimens {
  static const padding = EdgeInsets.all(16.0);
}

/// Root widget with dynamic theme switching
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
        '/': (c) => HomeScreen(),
        '/login': (c) => LoginScreen(),
        '/signup': (c) => SignupScreen(),
        '/list': (c) => CardListScreen(),
        '/dashboard': (c) => MainDashboardScreen(),
        '/profile': (c) => ProfileScreen(onThemeChanged: _handleThemeChange),
        '/settings': (c) => SettingsScreen(onThemeChanged: _handleThemeChange),
        '/applock': (c) => AppLockScreen(),
        '/focus': (c) => FocusScreen(),
        '/schedule': (c) => ScheduleScreen(),
      },
    );
  }
}
