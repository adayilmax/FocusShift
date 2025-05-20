import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

// Screens
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/applock_screen.dart';
import 'screens/focus_screen.dart';
import 'screens/schedule_screen.dart';
import 'screens/todays_task_screen.dart';
import 'screens/daily_summary_screen.dart';
import 'screens/data_analytics.dart';

// Providers (oluşturulacak)
import 'providers/auth_provider.dart';
import 'providers/event_provider.dart';

// AuthGate widget (yeni bir dosyada yazacağız)
import 'screens/auth_gate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final app = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print('🔥 Firebase initialized: ${app.name}');
  runApp(const MyApp());
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

/// Root widget with Provider
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, EventProvider>(
          create: (_) => EventProvider(null),
          update: (_, authProvider, previous) =>
          previous!..updateUserId(authProvider.user?.uid),
        ),
      ],
      child: MaterialApp(
        title: 'Focus Shift',
        themeMode: ThemeMode.light,
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
          '/': (context) => const AuthGate(),
          '/login': (context) => LoginScreen(),
          '/signup': (context) => SignupScreen(),
          '/dashboard': (context) => MainDashboardScreen(),
          '/profile': (context) => ProfileScreen(
            onThemeChanged: (_) {}, // güncellenecek
          ),
          '/settings': (context) => SettingsScreen(
            onThemeChanged: (_) {}, // güncellenecek
          ),
          '/applock': (context) => AppLockScreen(),
          '/focus': (context) => FocusScreen(),
          '/schedule': (context) => ScheduleScreen(),
          '/todays_tasks': (context) => TodaysTaskScreen(),
          '/daily_summary': (context) => DailySummaryScreen(),
          '/data_analytics': (context) => DataAnalytics(),
        },
      ),
    );
  }
}
