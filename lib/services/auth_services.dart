import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  static const String _baseUrl = 'https://api.corpachat.zrie.me';
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
    required String confPassword,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
          'confPassword': confPassword
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 201) {
        await _storage.write(key: 'auth_token', value: responseData['data']['token']);
        return {
          'success': true,
          'message': responseData['message'] ?? 'Registration successful'
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Registration failed'
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: ${e.toString()}'
      };
    }
  }

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        await _storage.write(key: 'auth_token', value: responseData['data']['token']);
        return {
          'success': true,
          'message': responseData['message'] ?? 'Login successful'
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Login failed'
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: ${e.toString()}'
      };
    }
  }

  static Future<void> logout() async {
    try {
      final token = await _storage.read(key: 'auth_token');
      await http.delete(
        Uri.parse('$_baseUrl/logout'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
      );
      await _storage.delete(key: 'auth_token');
    } catch (e) {
      print('Logout error: $e');
    }
  }

  static Future<Map<String, dynamic>> getUserProfile() async {
    try {
      final token = await _storage.read(key: 'auth_token');
      final response = await http.get(
        Uri.parse('$_baseUrl/me'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'userData': responseData['data']
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to fetch user profile'
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: ${e.toString()}'
      };
    }
  }
}