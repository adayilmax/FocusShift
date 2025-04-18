// main.dart
import 'package:flutter/material.dart';
import 'screens/todays_task_screen.dart';
import 'screens/daily_summary_screen.dart';
import 'utils/constants.dart';

void main() {
  runApp(FocusShiftApp());
}

class FocusShiftApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FocusShift',
      theme: ThemeData(
        fontFamily: 'Poppins',
        primaryColor: AppColors.primary,
      ),
      initialRoute: '/todays-task',
      routes: {
        '/todays-task': (context) => TodaysTaskScreen(),
        '/daily-summary': (context) => DailySummaryScreen(),
      },
    );
  }
}
