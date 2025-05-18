import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/auth_providers.dart';
import '../state/firestore_providers.dart';
import '../widgets/task_item.dart';
import 'login_screen.dart';

class DashboardScreen extends ConsumerWidget {
  static const routeName = '/dashboard';
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authAsync = ref.watch(authStateProvider);

    return authAsync.when(
      data: (user) {
        if (user == null) {
          // not logged in, redirect
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(context, LoginScreen.routeName);
          });
          return const Scaffold();
        }
        return _buildBody(context, ref, user.uid);
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        body: Center(child: Text('Auth error: $e')),
      ),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, String uid) {
    final theme = Theme.of(context);
    final textColor =
    theme.brightness == Brightness.dark ? Colors.white : Colors.black;

    final tasksAsync = ref.watch(completedTasksProvider(uid));

    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard', style: TextStyle(color: textColor)),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: textColor),
            onPressed: () => ref.read(authServiceProvider).signOut(),
          )
        ],
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: tasksAsync.when(
        data: (tasks) {
          if (tasks.isEmpty) {
            return Center(
              child: Text(
                'No completed tasks yet.',
                style: TextStyle(color: textColor),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: tasks.length,
            itemBuilder: (ctx, i) {
              final t = tasks[i];
              return TaskItem(
                time: t.time,
                label: t.label,
                profileCount: t.profileCount,
                primaryColor: theme.colorScheme.secondary,
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text('Error loading tasks: $e', style: TextStyle(color: textColor)),
        ),
      ),
    );
  }
}
