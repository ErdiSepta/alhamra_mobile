import '../../../core/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // Static user data for testing
  static final List<Map<String, dynamic>> _staticUsers = [
    {
      'uid': 'user_001',
      'namaLengkap': 'Ahmad Santoso',
      'jenisKelamin': 'Laki-laki',
      'nomorHp': '081234567890',
      'alamatLengkap': 'Jl. Merdeka No. 123, Jakarta',
      'emailPengguna': 'ahmad@example.com',
      'password': 'flutte',
      
    },
    {
      'uid': 'user_002',
      'namaLengkap': 'Siti Nurhaliza',
      'jenisKelamin': 'Perempuan',
      'nomorHp': '081234567891',
      'alamatLengkap': 'Jl. Sudirman No. 456, Bandung',
      'emailPengguna': 'siti@example.com',
      'password': 'password456',
      
    },
    {
      'uid': 'user_003',
      'namaLengkap': 'Budi Prasetyo',
      'jenisKelamin': 'Laki-laki',
      'nomorHp': '081234567892',
      'alamatLengkap': 'Jl. Gatot Subroto No. 789, Surabaya',
      'emailPengguna': 'budi@example.com',
      'password': 'password789',
      
    },
  ];

  String? _currentUserId;
  static const String _currentUserKey = 'current_user_id';

  // Sign in with email and password using static data
  Future<UserCredential?> signInWithEmailAndPassword(
      String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    try {
      final userData = _staticUsers.firstWhere(
        (user) => user['emailPengguna'] == email && user['password'] == password,
      );
      
      _currentUserId = userData['uid'];
      
      // Save current user ID to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_currentUserKey, userData['uid']);
      
      await updateLastLogin(userData['uid']);
      
      return UserCredential(userData['uid']);
    } catch (e) {
      throw 'Email dan password tidak terdaftar';
    }
  }

  // Get user data from static data
  Future<UserModel?> getUserData(String uid) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    
    try {
      final userData = _staticUsers.firstWhere(
        (user) => user['uid'] == uid,
      );
      
      return UserModel.fromMap(userData, uid);
    } catch (e) {
      return null;
    }
  }

  // Update last login timestamp (simulate)
  Future<void> updateLastLogin(String uid) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 200));
    
    try {
      final userIndex = _staticUsers.indexWhere((user) => user['uid'] == uid);
      if (userIndex != -1) {
        _staticUsers[userIndex]['lastLogin'] = DateTime.now().toIso8601String();
      }
    } catch (e) {
      // Handle errors silently
    }
  }

  // Sign out
  Future<void> signOut() async {
    _currentUserId = null;
    
    // Remove current user ID from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserKey);
  }

  // Get current user
  User? getCurrentUser() {
    if (_currentUserId != null) {
      return User(_currentUserId!);
    }
    return null;
  }

  // Initialize current user from SharedPreferences
  Future<void> initializeCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    _currentUserId = prefs.getString(_currentUserKey);
  }
}

// Simple user credential class to replace Firebase UserCredential
class UserCredential {
  final User? user;
  
  UserCredential(String uid) : user = User(uid);
}

// Simple user class to replace Firebase User
class User {
  final String uid;
  
  User(this.uid);
}

