import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../helper/constant_app.dart';

  class ProfileServices {
    final _storage = const FlutterSecureStorage();

    Future<String?> getToken() async {
      try {
        return await _storage.read(key: 'auth_token');
      } catch (e) {
        throw Exception('Gagal membaca token: $e');
      }
    }

    Future<Map<String, dynamic>> fetchProfile(String token) async {
      const url = AppConstants.BASE_URL + AppConstants.PROFILE;

      try {
        final response = await http.get(
          Uri.parse(url),
          headers: {
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          final responseData = json.decode(response.body);
          return responseData['data'];
        } else {
          throw Exception('Gagal memuat data profil. Status: ${response.statusCode}');
        }
      } catch (e) {
        throw Exception('Error saat mengambil profil: $e');
      }
    }
  }