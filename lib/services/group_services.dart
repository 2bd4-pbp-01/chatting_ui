import 'package:chatting_ui/helper/constant_app.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class GroupServices {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static Future<Map<String, dynamic>> createGroup({
    required String groupName,
  }) async {
    try {
      final token = await _storage.read(key: 'auth_token');

      // Pastikan token tidak null
      if (token == null) {
        return {
          'success': false,
          'message': 'Authentication token is missing'
        };
      }

      // Cetak informasi debugging
      print('Token: $token');
      print('Group Name: $groupName');

      final response = await http.post(
        Uri.parse(AppConstants.GROUP),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'groupName': groupName  // Sesuaikan dengan key yang digunakan API
        }),
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      final responseData = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'message': responseData['message'] ?? 'Group created successfully',
          'data': responseData['data'],
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to create group',
        };
      }
    } catch (e) {
      print('Error creating group: $e');
      return {
        'success': false,
        'message': 'An error occurred: ${e.toString()}'
      };
    }
  }


  static Future<List<dynamic>> getGroups() async {
    try {
      final token = await _storage.read(key: 'auth_token');
      final response = await http.get(
        Uri.parse(AppConstants.GROUP),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);
        if (decodedResponse is Map<String, dynamic> && decodedResponse.containsKey('data')) {
          return decodedResponse['data'] as List<dynamic>;
        } else {
          throw Exception('Unexpected API response structure');
        }
      } else {
        throw Exception('Failed to load groups: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to fetch groups: ${e.toString()}');
    }
  }

}
