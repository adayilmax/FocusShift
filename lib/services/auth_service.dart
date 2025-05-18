import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;

  /// Stream of auth‐state changes (null = signed out)
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Email/password sign-in
  Future<User?> signIn(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    return cred.user;
  }

  /// Email/password sign-up
  Future<User?> signUp(String email, String password) async {
    final cred = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    return cred.user;
  }

  /// Sign out
  Future<void> signOut() => _auth.signOut();
}
