import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/auth_providers.dart';
import 'login_screen.dart';
import 'signup_screen.dart';
import 'dashboard_screen.dart';
import 'focus_screen.dart';
import 'schedule_screen.dart';

/// HomeScreen: landing page before authentication
class HomeScreen extends ConsumerWidget {
  static const routeName = '/home';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).value;
    if (user != null) {
      // Already signed in → Dashboard
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(
            context, DashboardScreen.routeName);
      });
      return const Scaffold();
    }

    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Home', style: theme.textTheme.headlineSmall),
        elevation: 0,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: theme.colorScheme.primary),
              child: Text(
                'Navigation',
                style: theme.textTheme.headlineLarge
                    ?.copyWith(color: theme.colorScheme.onPrimary),
              ),
            ),
            ListTile(
              leading: Icon(Icons.login,
                  color: theme.colorScheme.secondary),
              title: const Text('Login'),
              onTap: () => Navigator.pushNamed(
                  context, LoginScreen.routeName),
            ),
            ListTile(
              leading: Icon(Icons.person_add,
                  color: theme.colorScheme.secondary),
              title: const Text('Sign Up'),
              onTap: () => Navigator.pushNamed(
                  context, SignupScreen.routeName),
            ),
            ListTile(
              leading: Icon(Icons.list,
                  color: theme.colorScheme.secondary),
              title: const Text('Card List'),
              onTap: () => Navigator.pushNamed(context, '/list'),
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.bolt,
                  color: theme.colorScheme.secondary),
              title: const Text('Focus Mode'),
              onTap: () => Navigator.pushNamed(
                  context, FocusScreen.routeName),
            ),
            ListTile(
              leading: Icon(Icons.calendar_today,
                  color: theme.colorScheme.secondary),
              title: const Text('Schedule'),
              onTap: () => Navigator.pushNamed(
                  context, ScheduleScreen.routeName),
            ),
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(
                    context, LoginScreen.routeName),
                child: const Text('Login'),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(
                    context, SignupScreen.routeName),
                child: const Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}