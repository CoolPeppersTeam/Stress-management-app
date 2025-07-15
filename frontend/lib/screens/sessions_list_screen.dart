import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../services/auth_service.dart';

class Session {
  final int id;
  final String description;
  final int stressLevel;
  final DateTime date;

  Session({
    required this.id,
    required this.description,
    required this.stressLevel,
    required this.date,
  });

  factory Session.fromJson(Map<String, dynamic> json) => Session(
    id: json['id'] ?? json['ID'] as int,
    description: json['description'] as String? ?? '',
    stressLevel: json['stress_level'] as int? ?? 0,
    date: DateTime.parse(json['date'] as String? ?? ''),
  );
}

class SessionsService {
  static Future<List<Session>> fetchSessions() async {
    final token = await AuthService().savedToken;
    if (token == null) throw Exception('The token was not found');

    final resp = await http.get(
      Uri.parse('${AuthService.baseUrl}/sessions'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (resp.statusCode == 200) {
      final List data = jsonDecode(resp.body) as List;
      return data.map((e) => Session.fromJson(e)).toList();
    }
    throw Exception('Download error: ${resp.statusCode}');
  }
}

class SessionsListScreen extends StatefulWidget {
  const SessionsListScreen({super.key});

  @override
  State<SessionsListScreen> createState() => _SessionsListScreenState();
}

class _SessionsListScreenState extends State<SessionsListScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late Future<List<Session>> _sessionsFut;

  @override
  void initState() {
    super.initState();
    _sessionsFut = SessionsService.fetchSessions();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Необходимо для AutomaticKeepAliveClientMixin
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Stack(
        children: [
          Positioned(
            top: -30,
            right: -10,
            child: Image.asset('assets/images/leaf_top.png', width: 180),
          ),
          Positioned(
            bottom: -20,
            left: -20,
            child: Image.asset('assets/images/leaf_bottom.png', width: 200),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    'List of sessions',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: FutureBuilder<List<Session>>(
                      future: _sessionsFut,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              snapshot.error.toString(),
                              style: const TextStyle(color: Colors.redAccent),
                              textAlign: TextAlign.center,
                            ),
                          );
                        }
                        final sessions = snapshot.data ?? [];
                        if (sessions.isEmpty) {
                          return const Center(
                            child: Text('There are no records, add the first session!'),
                          );
                        }
                        return ListView.builder(
                          itemCount: sessions.length,
                          itemBuilder: (context, i) {
                            final s = sessions[i];
                            return _SessionCard(session: s);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SessionCard extends StatelessWidget {
  const _SessionCard({required this.session});

  final Session session;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF7FC6A6),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Text(
              session.stressLevel.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session.description,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 6),
                Text(
                  _formatDate(session.date),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year}';
}
