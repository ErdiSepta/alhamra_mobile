import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../app/config/odoo_config.dart';

class OdooApiService {
  final String baseUrl;
  final String database;
  String? _sessionId;
  
  OdooApiService({
    String? baseUrl,
    String? database,
  })  : baseUrl = baseUrl ?? OdooConfig.baseUrl,
        database = database ?? OdooConfig.database;

  /// Login ke Server Oddo
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final url = Uri.parse('$baseUrl${OdooConfig.loginEndpoint}');
      
      final response = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'jsonrpc': '2.0',
              'params': {
                'db': database,
                'login': email,
                'password': password,
              },
            }),
          )
          .timeout(
            Duration(seconds: OdooConfig.timeoutSeconds),
          );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        // cek jika ada respon eror
        if (data['error'] != null) {
          throw OdooException(
            message: data['error']['data']['message'] ?? 'Login failed',
            code: data['error']['code'],
          );
        }
        
        // Extract session ID dari cookies
        final cookies = response.headers['set-cookie'];
        if (cookies != null) {
          _sessionId = _extractSessionId(cookies);
        }
        
        return data['result'] as Map<String, dynamic>;
      } else {
        throw OdooException(
          message: 'Server error: ${response.statusCode}',
          code: response.statusCode,
        );
      }
    } catch (e) {
      if (e is OdooException) {
        rethrow;
      }
      throw OdooException(
        message: 'Connection error: ${e.toString()}',
        code: 0,
      );
    }
  }

  /// Logout dari server oddo
  Future<void> logout() async {
    try {
      // Jika tidak ada session, tidak perlu logout
      if (_sessionId == null) {
        print('OdooApiService: No session to logout');
        return;
      }

      final url = Uri.parse('$baseUrl${OdooConfig.logoutEndpoint}');
      
      print('OdooApiService: Logging out with session: ${_sessionId?.substring(0, 10)}...');
      
      final response = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Cookie': 'session_id=$_sessionId',
            },
            body: jsonEncode({
              'jsonrpc': '2.0',
              'params': {},
            }),
          )
          .timeout(
            Duration(seconds: OdooConfig.timeoutSeconds),
          );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        // Cek jika ada error (session expired is OK for logout)
        if (data['error'] != null) {
          final errorCode = data['error']['code'];
          final errorMessage = data['error']['message'];
          
          // Session expired adalah OK saat logout
          if (errorCode == 100 || errorMessage?.contains('Session') == true) {
            print('OdooApiService: Session already expired (OK for logout)');
          } else {
            print('OdooApiService: Logout error: $errorMessage');
          }
        } else {
          print('OdooApiService: Logout successful');
        }
      }
      
      _sessionId = null;
    } catch (e) {
      // Ignore logout errors, always clear session
      print('OdooApiService: Logout error (ignored): $e');
      _sessionId = null;
    }
  }

  /// Extract session ID from cookie string
  String? _extractSessionId(String cookies) {
    final sessionCookie = cookies.split(';').firstWhere(
          (cookie) => cookie.trim().startsWith('session_id='),
          orElse: () => '',
        );
    
    if (sessionCookie.isNotEmpty) {
      return sessionCookie.split('=')[1];
    }
    return null;
  }

  /// Get students by parent ID (orangtua_id)
  Future<List<Map<String, dynamic>>> getStudents(int orangtuaId) async {
    try {
      final url = Uri.parse('$baseUrl/web/dataset/call_kw');
      
      final response = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              if (_sessionId != null) 'Cookie': 'session_id=$_sessionId',
            },
            body: jsonEncode({
              'jsonrpc': '2.0',
              'method': 'call',
              'params': {
                'model': 'res.partner',
                'method': 'search_read',
                'args': [
                  [
                    ['parent_id', '=', orangtuaId],
                    ['is_student', '=', true],
                  ],
                ],
                'kwargs': {
                  'fields': ['id', 'name', 'nis', 'partner_id', 'gender', 'birth_date', 'class_name', 'avatar_128'],
                },
              },
            }),
          )
          .timeout(
            Duration(seconds: OdooConfig.timeoutSeconds),
          );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        // Check if there's an error in the response
        if (data['error'] != null) {
          throw OdooException(
            message: data['error']['data']['message'] ?? 'Failed to get students',
            code: data['error']['code'],
          );
        }
        
        // Return list of students
        final result = data['result'];
        if (result is List) {
          return List<Map<String, dynamic>>.from(result);
        }
        
        return [];
      } else {
        throw OdooException(
          message: 'Server error: ${response.statusCode}',
          code: response.statusCode,
        );
      }
    } catch (e) {
      if (e is OdooException) {
        rethrow;
      }
      throw OdooException(
        message: 'Connection error: ${e.toString()}',
        code: 0,
      );
    }
  }

  /// Get current session ID
  String? get sessionId => _sessionId;
  
  /// Check if user is logged in
  bool get isLoggedIn => _sessionId != null;
}

/// Custom exception for Odoo API errors
class OdooException implements Exception {
  final String message;
  final int code;
  
  OdooException({
    required this.message,
    required this.code,
  });
  
  @override
  String toString() => message;
}
