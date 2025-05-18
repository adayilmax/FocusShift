import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/auth_providers.dart';
import '../state/firestore_providers.dart';
import 'login_screen.dart';
import '../widgets/task_item.dart';

const Color _kPrimaryColor = Colors.greenAccent;

class DailySummaryScreen extends ConsumerWidget {
  const DailySummaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    return authState.when(
      data: (user) {
        if (user == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(
                context, LoginScreen.routeName);
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

  Widget _buildBody(
      BuildContext context, WidgetRef ref, String uid) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final generalTextColor = isDark ? Colors.white : Colors.black;
    final theme = Theme.of(context);

    final summaryAsync = ref.watch(dailySummaryProvider(uid));
    final tasksAsync = ref.watch(completedTasksProvider(uid));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: generalTextColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("Daily Summary",
            style: TextStyle(color: generalTextColor)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundColor: Colors.grey.shade300,
              child: Icon(Icons.person, color: Colors.grey.shade800),
            ),
          ),
        ],
      ),
      body: summaryAsync.when(
        data: (summary) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Summary for Today',
                style: theme.textTheme.headlineSmall
                    ?.copyWith(
                    color: generalTextColor,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            // Focus Time Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.timer_outlined,
                        color: theme.colorScheme.primary, size: 30),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text('Total Focus Time',
                            style: theme.textTheme.titleMedium
                                ?.copyWith(
                                color: generalTextColor)),
                        const SizedBox(height: 4),
                        Text('${summary.focusTime}',
                            style: theme.textTheme.headlineSmall
                                ?.copyWith(
                                color: generalTextColor,
                                fontWeight: FontWeight.bold)),
                      ],
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Tasks Completed Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.check_circle_outline,
                        color: Colors.green, size: 30),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text('Tasks Completed',
                            style: theme.textTheme.titleMedium
                                ?.copyWith(
                                color: generalTextColor)),
                        const SizedBox(height: 4),
                        Text('${summary.tasksCompleted}',
                            style: theme.textTheme.headlineSmall
                                ?.copyWith(
                                color: generalTextColor,
                                fontWeight: FontWeight.bold)),
                      ],
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            Text('Completed Tasks',
                style: theme.textTheme.titleMedium
                    ?.copyWith(
                    color: generalTextColor,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            // Task List from Firestore
            tasksAsync.when(
              data: (tasks) => Column(
                children: tasks
                    .map((t) => TaskItem(
                  time: t.time,
                  label: t.label,
                  profileCount: t.profileCount,
                  primaryColor: _kPrimaryColor,
                ))
                    .toList(),
              ),
              loading: () =>
              const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text('Error: $e',
                  style: TextStyle(color: generalTextColor)),
            ),
          ],
        ),
        loading: () =>
        const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
