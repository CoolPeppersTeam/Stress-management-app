import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/advice.dart';

class AuthService {
  static const String _baseUrl = 'http://localhost:8080';
  final _secureStorage = const FlutterSecureStorage();

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token);
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  Future<void> _removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
  }

  Future<void> _saveUserInfo({required String email, String? nickname}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_email', email);
    if (nickname != null) {
      await prefs.setString('user_nickname', nickname);
    }
  }

  Future<String?> getSavedNickname() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_nickname') ?? prefs.getString('user_email');
  }

  Future<String?> getSavedEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_email');
  }

  // Остальные методы остаются без изменений
  Future<String> login(String email, String password) async {
    final resp = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (resp.statusCode == 200) {
      final token = jsonDecode(resp.body)['token'] as String;
      await _saveToken(token);
      await _saveUserInfo(email: email);
      return token;
    }
    throw Exception('Ошибка входа (${resp.statusCode}): ${resp.body}');
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

    if (response.statusCode != 201) {
      throw Exception('Ошибка регистрации');
    }
    await _saveUserInfo(email: email, nickname: nickname);
  }

  Future<void> addSession(String description, int level, DateTime date) async {
    final token = await _getToken();
    if (token == null) throw Exception('Токен не найден');

    final response = await http.post(
      Uri.parse('$_baseUrl/sessions'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'description': description,
        'stress_level': level,
        'date': date.toUtc().toIso8601String(),
      }),
    );

    if (response.statusCode >= 300) {
      throw Exception('Ошибка создания сессии: ${response.body}');
    }
  }

  Future<Advice> getAIAdvice(String description, int level, DateTime date) async {
    final token = await _getToken();
    if (token == null) throw Exception('Токен не найден');

    final response = await http.post(
      Uri.parse('$_baseUrl/ai/advice'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'description': description,
        'stress_level': level,
        'date': date.toUtc().toIso8601String(),
      }),
    );

    if (response.statusCode == 200) {
      return Advice.fromJson(jsonDecode(response.body));
    }
    throw Exception('Ошибка AI-совета: ${response.body}');
  }
}
