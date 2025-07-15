import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:html' as html;

class RecommendationService {
  static const String _baseUrl = 'http://localhost:8080';
  final _storage = const FlutterSecureStorage();

  Future<String?> _getToken() async {
    if (kIsWeb) {
      return html.window.localStorage['jwt_token'];
    } else {
      return _storage.read(key: 'jwt_token');
    }
  }

  Future<List<Recommendation>> fetchRecommendations() async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Not authorized');
    }
    final response = await http.get(
      Uri.parse('$_baseUrl/recommendations'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Recommendation.fromJson(json)).toList();
    } else {
      throw Exception('Error with recomendations loading');
    }
  }
}
