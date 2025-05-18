import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/auth_providers.dart';
import '../state/firestore_providers.dart';
import 'login_screen.dart';

/// Focus Screen: toggle between focus/timer and record sessions to Firestore
class FocusScreen extends ConsumerStatefulWidget {
  static const routeName = '/focus';
  const FocusScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<FocusScreen> createState() => _FocusScreenState();
}

class _FocusScreenState extends ConsumerState<FocusScreen> {
  bool _isFocusMode = true;
  double _minutes = 25;
  String _topic = 'Topic';

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    return authState.when(
      data: (user) {
        if (user == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(context, LoginScreen.routeName);
          });
          return const Scaffold();
        }
        return _buildScaffold(context, user.uid);
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        body: Center(child: Text('Auth error: $e')),
      ),
    );
  }

  Widget _buildScaffold(BuildContext context, String uid) {
    final theme = Theme.of(context);
    final accent = theme.colorScheme.secondary;
    final grey300 = Colors.grey.shade300;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          _isFocusMode ? 'Focus Mode' : 'Timer Mode',
          style: theme.textTheme.titleLarge,
        ),
        iconTheme: theme.iconTheme,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: accent),
            onPressed: () => ref.read(authServiceProvider).signOut(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Toggle focus/timer mode
            ToggleButtons(
              isSelected: [_isFocusMode, !_isFocusMode],
              borderRadius: BorderRadius.circular(30),
              selectedBorderColor: accent,
              fillColor: accent.withAlpha((0.1 * 255).round()),
              children: [
                Icon(Icons.hourglass_empty,
                    color: _isFocusMode ? accent : grey300),
                Icon(Icons.access_time,
                    color: !_isFocusMode ? accent : grey300),
              ],
              onPressed: (idx) => setState(() => _isFocusMode = (idx == 0)),
            ),
            const SizedBox(height: 32),

            // Timer display
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: accent, width: 5),
              ),
              child: Center(
                child: Text(
                  '${_minutes.toInt().toString().padLeft(2, '0')}:00',
                  style: theme.textTheme.headlineMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Duration slider
            Slider(
              value: _minutes,
              min: 1,
              max: 120,
              divisions: 119,
              label: '${_minutes.round()}m',
              onChanged: (v) => setState(() => _minutes = v),
            ),
            const SizedBox(height: 16),

            // Topic chip
            Chip(
              label: Text(_topic, style: theme.textTheme.bodyLarge),
              backgroundColor: _isFocusMode ? accent : grey300,
            ),

            const Spacer(),

            // Start focus session
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () async {
                  // TODO: Implement addFocusSession in FirestoreService
                  await ref
                      .read(firestoreServiceProvider)
                      .addFocusSession(uid, _minutes.toInt(), _topic, DateTime.now());
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: accent),
                  shape: const StadiumBorder(),
                ),
                child: Text('FOCUS', style: theme.textTheme.labelLarge),
              ),
            ),
          ],
        ),
      ),
    );
  }
}