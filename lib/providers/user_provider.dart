import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firebase_service.dart';

class UserProvider extends ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  final FirebaseService _firebaseService = FirebaseService();

  User? get user => _user;
  bool get isLoading => _isLoading;

  UserProvider() {
    _init();
  }

  void _init() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _firebaseService.signUpWithEmailAndPassword(
        email: email,
        password: password,
        name: name,
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _firebaseService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _firebaseService.resetPassword(email);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    try {
      _isLoading = true;
      notifyListeners();

      await _firebaseService.signOut();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
