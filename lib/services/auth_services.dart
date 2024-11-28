import 'package:chatting_ui/helper/constant_app.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  // Register User
  static Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
    required String confPassword,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(AppConstants.REGISTER),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
          'confPassword': confPassword,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 201) {
        await _storage.write(
          key: 'auth_token',
          value: responseData['data']['token'],
        );
        return {
          'success': true,
          'message': responseData['message'] ?? 'Registration successful',
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Registration failed',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: ${e.toString()}',
      };
    }
  }

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      // Login untuk mendapatkan token
      final response = await http.post(
        Uri.parse(AppConstants.LOGIN),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final token = responseData['data']['token'];

        // Simpan token ke storage
        await _storage.write(key: 'auth_token', value: token);

        // Ambil detail user dari endpoint /me
        final userResponse = await http.get(
          Uri.parse(AppConstants.PROFILE),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        );

        if (userResponse.statusCode == 200) {
          final userData = jsonDecode(userResponse.body)['data'];

          // Simpan detail user ke storage (simpan per atribut)
          await _storage.write(key: 'username', value: userData['username']);
          await _storage.write(key: 'email', value: userData['email']);
          await _storage.write(key: 'tipe_user', value: userData['tipe_user']);

          print("token : $token");
          print('User data saved: $userData');

          return {
            'success': true,
            'message': responseData['message'] ?? 'Login successful',
            'userData': userData,
          };
        } else {
          return {
            'success': false,
            'message': 'Failed to fetch user details',
          };
        }
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Login failed',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: ${e.toString()}',
      };
    }
  }


  // Logout User
  static Future<void> logout() async {
    try {
      final token = await _storage.read(key: 'auth_token');
      //print data in secure storage
      print(await _storage.readAll());
      await http.delete(
        Uri.parse(AppConstants.LOGOUT),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      await _storage.deleteAll();
    } catch (e) {
      print('Logout error: $e');
    }
  }

  // Get User Profile
  static Future<Map<String, dynamic>> getUserProfile() async {
    try {
      final token = await _storage.read(key: 'auth_token');
      final response = await http.get(
        Uri.parse(AppConstants.PROFILE),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'userData': responseData['data']};
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to fetch user profile',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: ${e.toString()}',
      };
    }
  }
}
