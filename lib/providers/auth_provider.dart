import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _user;
  User? get user => _user;

  AuthProvider() {
    // Dinleyici ekle, kullanıcı durumları değişince tetiklensin
    _auth.authStateChanges().listen((User? firebaseUser) {
      _user = firebaseUser;
      notifyListeners(); // Tüm dinleyicilere haber ver
    });
  }

  // Giriş yapma
  Future<void> signIn(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  // Kayıt olma
  Future<bool> signUp(String name, String email, String password) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = result.user!.uid;

      // Save to Firestore immediately
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'name': name,
        'email': email,
        'photoUrl': null,
      });

      return true;
    } on FirebaseAuthException catch (_) {
      rethrow;
    }
  }


  // Çıkış yapma
  Future<void> signOut() async {
    await _auth.signOut();
    notifyListeners();
  }
}
