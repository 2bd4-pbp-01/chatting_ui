
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../helper/constant_app.dart';

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

  static Future<String?> _getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  static Future<Map<String, dynamic>?> fetchGroupDetails(int groupId) async {
    final token = await _getToken();
    if (token == null) return null;

    final response = await http.get(
      Uri.parse('https://api.corpachat.zrie.me/groups/$groupId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return null;
    }
  }

  static Future<Map<String, dynamic>?> fetchCompanyMembers() async {
    final token = await _getToken();
    if (token == null) return null;

    final response = await http.get(
      Uri.parse('https://api.corpachat.zrie.me/users'),
      headers: {
        // company member cuma bisa diliat operator njirrr
        'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MywiZW1haWwiOiJuZW9uZXR6QGdtYWlsLmNvbSIsInRpcGVfdXNlciI6Im9wZXJhdG9yIiwiaWF0IjoxNzMyODExNjA2LCJleHAiOjE3MzI4OTgwMDZ9.hKdr8_9sCJ4xDwzlGKgNeePuHc5Sj4a-3bZIHTV2gyI',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return null;
    }
  }

  static Future<bool> kickMember(int groupId, int userId) async {
    final token = await _getToken();
    if (token == null) return false;

    final response = await http.delete(
      Uri.parse('https://api.corpachat.zrie.me/groups/$groupId/kick/$userId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    return response.statusCode == 200;
  }

  static Future<bool> inviteMember(int groupId, int userId) async {
    final token = await _getToken();
    if (token == null) return false;

    final response = await http.post(
      Uri.parse('https://api.corpachat.zrie.me/groups/$groupId/invite'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'userId': userId}),
    );
    return response.statusCode == 200;
  }

}


