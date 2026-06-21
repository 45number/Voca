import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'auth_service.dart';

class AuthController extends ChangeNotifier {
  final AuthService _service = AuthService();

  User? get user => _service.currentUser;

  bool isLoading = false;

  String? error;

  Future<bool> login(String email, String password) async {
    try {
      isLoading = true;
      error = null;

      notifyListeners();

      await _service.login(email: email, password: password);

      notifyListeners();

      return true;
    } on FirebaseAuthException catch (e) {
      error = e.message;

      return false;
    } finally {
      isLoading = false;

      notifyListeners();
    }
  }

  Future<bool> register(String email, String password) async {
    try {
      isLoading = true;

      error = null;

      notifyListeners();

      await _service.register(email: email, password: password);

      return true;
    } on FirebaseAuthException catch (e) {
      error = e.message;

      return false;
    } finally {
      isLoading = false;

      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _service.logout();

    notifyListeners();
  }
}
