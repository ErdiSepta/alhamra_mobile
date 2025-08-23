import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:alhamra_1/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';

enum AuthStatus {
  uninitialized,
  authenticating,
  authenticated,
  unauthenticated,
}

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  AuthStatus _status = AuthStatus.uninitialized;
  UserModel? _user;
  String _errorMessage = '';
  static const String _userKey = 'user_token';

  AuthProvider() {
    _checkCurrentUser();
  }

  AuthStatus get status => _status;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  UserModel? get user => _user;
  String get errorMessage => _errorMessage;

  void _checkCurrentUser() async {
    _status = AuthStatus.authenticating;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString(_userKey);

    if (userId != null) {
      final firebaseUser = _authService.getCurrentUser();
      if (firebaseUser != null && firebaseUser.uid == userId) {
        _user = await _authService.getUserData(firebaseUser.uid);
        if (_user != null) {
          _status = AuthStatus.authenticated;
        } else {
          // User data not found, clear session
          await logout();
          _status = AuthStatus.unauthenticated;
        }
      } else {
        // Mismatch or no Firebase user, clear session
        await logout();
        _status = AuthStatus.unauthenticated;
      }
    } else {
      _status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    try {
      final credential = await _authService.signInWithEmailAndPassword(
        email,
        password,
      );
      if (credential != null && credential.user != null) {
        _user = await _authService.getUserData(credential.user!.uid);
        if (_user != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(_userKey, credential.user!.uid);
          _status = AuthStatus.authenticated;
          _errorMessage = '';
          notifyListeners();
          return true;
        }
      }
      _errorMessage = "Gagal mendapatkan data pengguna.";
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = "Email dan password tidak terdaftar";
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _authService.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    _status = AuthStatus.unauthenticated;
    _user = null;
    notifyListeners();
  }
}
