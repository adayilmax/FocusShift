import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/auth_providers.dart';
import '../state/firestore_providers.dart';
import 'login_screen.dart';

class AppLockScreen extends ConsumerWidget {
  const AppLockScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    return authState.when(
      data: (user) {
        if (user == null) {
          // Not signed in → back to Login
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(
                context, LoginScreen.routeName);
          });
          return const Scaffold();
        }
        return _buildScaffold(context, ref, user.uid);
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        body: Center(child: Text('Auth error: $e')),
      ),
    );
  }

  Widget _buildScaffold(
      BuildContext context, WidgetRef ref, String uid) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final barTextColor = isDark ? Colors.black : Colors.white;

    // Firestore streams—you’ll implement these providers
    final limitsAsync = ref.watch(appLockLimitsProvider(uid));
    final weekAsync = ref.watch(lastWeekUsageProvider(uid));

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("App Lock", style: TextStyle(color: textColor)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: textColor),
            onPressed: () => ref.read(authServiceProvider).signOut(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: () {
                // TODO: record a focus session in Firestore
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size.fromHeight(48),
              ),
              child:
              const Text("Focus Now", style: TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 24),
            Text("Hour Limits",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: textColor)),
            const Divider(color: Colors.green),
            const SizedBox(height: 12),

            // — LIMITS LIST —
            limitsAsync.when(
              data: (limits) => Column(
                children: limits.entries.map((entry) {
                  final iconMap = {
                    'instagram': 'assets/icons/instagram.png',
                    'twitter': 'assets/icons/twitter.png',
                    'youtube': 'assets/icons/youtube.png',
                    'games': 'assets/icons/controller.png',
                  };
                  final iconPath = iconMap[entry.key] ?? '';
                  return _horizontalLineItem(
                      iconPath, entry.value, barTextColor);
                }).toList(),
              ),
              loading: () =>
              const Center(child: CircularProgressIndicator()),
              error: (e, _) =>
                  Text('Error loading limits: $e',
                      style: TextStyle(color: textColor)),
            ),

            const SizedBox(height: 12),
            Row(
              children: [
                const SizedBox(width: 32),
                IconButton(
                  icon: const Icon(Icons.add_circle,
                      size: 36, color: Colors.greenAccent),
                  onPressed: () {
                    // TODO: push dialog to add a new limit
                  },
                ),
              ],
            ),

            const SizedBox(height: 32),
            Text("Last Week",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: textColor)),
            const Divider(color: Colors.green),
            const SizedBox(height: 12),

            // — LAST WEEK BARS —
            weekAsync.when(
              data: (data) =>
                  _verticalBarSectionFromData(data, textColor),
              loading: () =>
              const Center(child: CircularProgressIndicator()),
              error: (e, _) =>
                  Text('Error loading week data: $e',
                      style: TextStyle(color: textColor)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _horizontalLineItem(
      String iconPath, int hours, Color barTextColor) {
    const double maxWidth = 200;
    final double lineWidth = (hours / 5.0) * maxWidth;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(iconPath, width: 36, height: 36),
          const SizedBox(width: 16),
          Container(
            width: lineWidth,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.greenAccent,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Text('$hours',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: barTextColor)),
          ),
        ],
      ),
    );
  }

  Widget _verticalBarSectionFromData(
      List<Map<String, dynamic>> data, Color textColor) {
    return SizedBox(
      height: 240,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: data.map((item) {
          final int value = item['value'] as int;
          final String label = item['label'] as String;
          final double barHeight = value * 6.0;
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('$value',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor)),
              const SizedBox(height: 4),
              Container(
                height: barHeight,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.greenAccent,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(height: 8),
              Text(label,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: textColor)),
            ],
          );
        }).toList(),
      ),
    );
  }
}
