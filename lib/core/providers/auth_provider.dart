import 'package:flutter/material.dart';
import '../../../core/models/user_model.dart';
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

    // Initialize current user from SharedPreferences
    await _authService.initializeCurrentUser();

    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString(_userKey);

    if (userId != null) {
      final currentUser = _authService.getCurrentUser();
      if (currentUser != null && currentUser.uid == userId) {
        _user = await _authService.getUserData(currentUser.uid);
        if (_user != null) {
          _status = AuthStatus.authenticated;
        } else {
          // User data not found, clear session
          await logout();
          _status = AuthStatus.unauthenticated;
        }
      } else {
        // Mismatch or no current user, clear session
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
      _status = AuthStatus.authenticating;
      notifyListeners();

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
      _errorMessage = e.toString();
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

