import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';

class AuthService {
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:8080';
    } else {
      return 'http://10.0.2.2:8080';
    }
  }

  final _storage = const FlutterSecureStorage();
  Future<String> login(String email, String password) async {
    final resp = await http.post(
      Uri.parse('${baseUrl}/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (resp.statusCode == 200) {
      final token = jsonDecode(resp.body)['token'] as String;
      await _storage.write(key: 'jwt_token', value: token);
      return token;
    }

    throw Exception('Ошибка входа (${resp.statusCode}): ${resp.body}');
  }

  Future<void> register(String email, String password, String nickname) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      body: json.encode({
        'email': email,
        'password': password,
        'nickname': nickname,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 201) {
      throw Exception('Ошибка регистрации');
    }
  }

  /// Просто помощник, если где-то нужно достать токен.
  Future<String?> get savedToken =>
      _storage.read(key: 'jwt_token');

  Future<void> logout() => _storage.delete(key: 'jwt_token');
}