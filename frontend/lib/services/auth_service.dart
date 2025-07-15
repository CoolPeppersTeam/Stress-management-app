import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'package:intl/intl.dart';
// Для Web
import 'dart:html' as html;
// Для мобильных
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {

  static const String _baseUrl = 'http://localhost:8080'; // localhost из-под Web  
  static String get baseUrl => _baseUrl;

  final _storage = const FlutterSecureStorage();

  Future<void> _saveToken(String token) async {
    if (kIsWeb) {
      html.window.localStorage['jwt_token'] = token;
    } else {
      await _storage.write(key: 'jwt_token', value: token);
    }
  }

  Future<String?> _getToken() async {
    if (kIsWeb) {
      return html.window.localStorage['jwt_token'];
    } else {
      return _storage.read(key: 'jwt_token');
    }
  }

  Future<void> _removeToken() async {
    if (kIsWeb) {
      html.window.localStorage.remove('jwt_token');
    } else {
      await _storage.delete(key: 'jwt_token');
    }
  }

  Future<void> _saveUserInfo({required String email, String? nickname}) async {
    if (kIsWeb) {
      html.window.localStorage['user_email'] = email;
      if (nickname != null) html.window.localStorage['user_nickname'] = nickname;
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_email', email);
      if (nickname != null) await prefs.setString('user_nickname', nickname);
    }
  }

  Future<String?> getSavedNickname() async {
    if (kIsWeb) {
      return html.window.localStorage['user_nickname'] ?? html.window.localStorage['user_email'];
    } else {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('user_nickname') ?? prefs.getString('user_email');
    }
  }

  Future<String?> getSavedEmail() async {
    if (kIsWeb) {
      return html.window.localStorage['user_email'];
    } else {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('user_email');
    }
  }

  Future<String> login(String email, String password) async {
    final resp = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (resp.statusCode == 200) {
      final token = jsonDecode(resp.body)['token'] as String;
      await _saveToken(token);
      await _saveUserInfo(email: email); // сохраняем email
      return token;
    }

    throw Exception('Login error (${resp.statusCode}): ${resp.body}');
  }

  Future<void> register(String email, String password, String nickname) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/register'),
      body: json.encode({
        'email': email,
        'password': password,
        'nickname': nickname,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      await _saveUserInfo(email: email, nickname: nickname); // сохраняем nickname и email
    } else {
      throw Exception('Registration error');
    }
  }

  /// Просто помощник, если где-то нужно достать токен.
  Future<String?> get savedToken => _getToken();
  Future<void> logout() => _removeToken();

  /// Добавление новой стресс-сессии
  Future<void> addSession(String description, int level, DateTime date) async {
    final token = await savedToken;
    if (token == null) throw Exception('Token was not found');

    final payload = {
      'description': description,
      'stress_level': level,
      // полный ISO-стринг с временем и зоной:
      'date': date.toUtc().toIso8601String(),
    };
    print('>> sessions payload: ${jsonEncode(payload)}');  // для отладки
    final response = await http.post(
      Uri.parse('$_baseUrl/sessions'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(payload),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        'Error with session creation (${response.statusCode}): ${response.body}'
      );
    }
  }

  Future<String?> fetchNicknameFromBackend() async {
    final token = await savedToken;
    if (token == null) return null;
    final resp = await http.get(
      Uri.parse('$_baseUrl/me'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (resp.statusCode == 200) {
      final data = json.decode(resp.body);
      return data['nickname'] as String?;
    }
    return null;
  }

  Future<bool> isTokenValid() async {
    final token = await savedToken;
    if (token == null) return false;

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/sessions'),
        headers: {'Authorization': 'Bearer $token'},
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 401) {
        await _removeToken(); // Автоматически удаляем невалидный токен
      }

      return response.statusCode == 200;
    } on TimeoutException {
      return false; // Таймаут сети
    } catch (e) {
      return false; // Любая другая ошибка
    }
  }
}
