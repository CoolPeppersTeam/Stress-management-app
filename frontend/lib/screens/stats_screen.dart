import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../services/auth_service.dart';

// Model for statistics data
class Stats {
  final int totalSessions;
  final double averageStress;
  
  Stats({required this.totalSessions, required this.averageStress});

  factory Stats.fromJson(Map<String, dynamic> json) {
    return Stats(
      totalSessions: json['total_sessions'],
      averageStress: (json['average_stress'] as num).toDouble(),
    );
  }
}

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  _StatsScreenState createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  final _secureStorage = const FlutterSecureStorage();
  final _authService = AuthService();
  late Future<Stats> _statsFuture;

  // Color palette matching HomeScreen style
  final Color mintColor = const Color(0xFF7FC6A6);
  final Color lightMint = const Color(0xFFA3D9C9);

  @override
  void initState() {
    super.initState();
    _statsFuture = _loadStats();
  }

  Future<Stats> _loadStats() async {
    final token = await _secureStorage.read(key: 'jwt_token');
    if (token == null) throw Exception('Token not found');

    final response = await http.get(
    Uri.parse('${AuthService.baseUrl}/stats'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Stats.fromJson(data);
    } else {
      throw Exception('Failed to load statistics: ${response.statusCode}');
    }
  }

  String _supportMessage(double stress) {
    if (stress < 3) return 'Excellent stress level — keep up the good work!';
    if (stress < 6) return 'Great job! Take some time to relax when you can.';
    if (stress < 8) return 'You seem a bit stressed. Try taking a moment to unwind.';
    return 'High stress detected. Consider deep breathing or a short meditation.';
  }

  String _formatDate(DateTime date) {
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    final weekdays = [
      'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'
    ];
    return '${weekdays[date.weekday]}, ${months[date.month - 1]} ${date.day}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightMint,
      appBar: AppBar(
        title: const Text('Statistics', style: TextStyle(
          color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500
        )),
        backgroundColor: mintColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: FutureBuilder<Stats>(
          future: _statsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final stats = snapshot.data!;
              final double percent = (stats.averageStress / 10).clamp(0, 1).toDouble();
              final percentText = (percent * 100).toInt();

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Hello, User',
                          style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          )),
                      const SizedBox(height: 6),
                      Text(_formatDate(DateTime.now()),
                          style: TextStyle(
                            color: Colors.grey[600], fontSize: 14,
                          )),
                      const SizedBox(height: 28),

                      Text('Total sessions: ${stats.totalSessions}',
                          style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500,
                            color: Colors.grey[800],
                          )),
                      const SizedBox(height: 8),
                      Text('Average stress level: ${stats.averageStress.toStringAsFixed(1)}',
                          style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500,
                            color: Colors.grey[800],
                          )),
                      const SizedBox(height: 28),

                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.05),
                                spreadRadius: 1, blurRadius: 8, offset: const Offset(0, 3),
                              )
                            ],
                          ),
                          child: Column(
                            children: [
                              Text('Your Stress Level',
                                  style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500,
                                    color: Colors.grey[700],
                                  )),
                              const SizedBox(height: 18),
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    width: 200, height: 200,
                                    child: CircularProgressIndicator(
                                      value: percent,
                                      strokeWidth: 12,
                                      backgroundColor: Colors.grey[100],
                                      valueColor: AlwaysStoppedAnimation<Color>(mintColor),
                                    ),
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('$percentText%',
                                          style: TextStyle(
                                            fontSize: 30, fontWeight: FontWeight.w700,
                                            color: mintColor,
                                          )),
                                      const SizedBox(height: 4),
                                      Text(
                                        percent < 0.3 ? 'Low' : percent < 0.7 ? 'Moderate' : 'High',
                                        style: TextStyle(
                                          fontSize: 15, color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Text(_supportMessage(stats.averageStress),
                                  style: TextStyle(
                                    fontSize: 14, color: Colors.grey[700],
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
