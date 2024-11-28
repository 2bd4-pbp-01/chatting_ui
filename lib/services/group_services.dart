import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class GroupServices {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

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