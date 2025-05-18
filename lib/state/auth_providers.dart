import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

/// Provides a singleton AuthService (wraps FirebaseAuth).
final authServiceProvider =
Provider<AuthService>((ref) => AuthService());

/// Emits the current Firebase user (or null) whenever auth state changes.
final authStateProvider = StreamProvider<User?>((ref) {
  final auth = ref.watch(authServiceProvider);
  return auth.authStateChanges;
});