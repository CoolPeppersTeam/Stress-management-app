import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/model.dart';

class RecommendationService {
  static const String _baseUrl = 'http://localhost:8080';

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  Future<List<Recommendation>> fetchRecommendations() async {
    final token = await _getToken();
    if (token == null) throw Exception('Не авторизован');

    final response = await http.get(
      Uri.parse('$_baseUrl/recommendations'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return (json.decode(response.body) as List)
          .map((json) => Recommendation.fromJson(json))
          .toList();
    }
    throw Exception('Ошибка загрузки рекомендаций');
  }
}
