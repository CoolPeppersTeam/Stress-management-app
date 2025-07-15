import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import '../main.dart';
import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final Color mintColor = const Color(0xFF7FC6A6);
  final Color lightMint = const Color(0xFFA3D9C9);

  String? userName;
  int? totalSessions;
  double? averageStress;
  bool loading = true;
  String? error;
  List<dynamic> recentSessions = [];
  bool isWsConnected = false;
  WebSocketChannel? _channel;
  StreamSubscription? _wsSubscription;

  @override
  void initState() {
    super.initState();
    _loadData();
    _connectWebSocket();
  }

  @override
  void dispose() {
    _wsSubscription?.cancel();
    _channel?.sink.close();
    super.dispose();
  }

  void _connectWebSocket() {
    final url = 'ws://localhost:8080/ws';
    _channel = WebSocketChannel.connect(Uri.parse(url));
    _wsSubscription = _channel!.stream.listen((event) {
      setState(() => isWsConnected = true);
    }, onDone: () {
      setState(() => isWsConnected = false);
      Future.delayed(const Duration(seconds: 5), _connectWebSocket);
    }, onError: (e) {
      setState(() => isWsConnected = false);
      Future.delayed(const Duration(seconds: 5), _connectWebSocket);
    });
  }

  Future<void> _loadData() async {
    setState(() { loading = true; error = null; });
    try {
      final auth = AuthService();
      final name = await auth.fetchNicknameFromBackend();
      final token = await auth.savedToken;
      if (token == null) throw Exception('Not authorized');

      final resp = await http.get(
        Uri.parse('${AuthService.baseUrl}/stats'),
        headers: {'Authorization': 'Bearer $token'},
      );
      final sessionsResp = await http.get(
        Uri.parse('${AuthService.baseUrl}/sessions'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (resp.statusCode == 200 && sessionsResp.statusCode == 200) {
        final data = json.decode(resp.body);
        final sessionsData = json.decode(sessionsResp.body) as List;
        setState(() {
          userName = name ?? 'User';
          totalSessions = data['total_sessions'] as int? ?? 0;
          averageStress = (data['average_stress'] as num?)?.toDouble() ?? 0.0;
          recentSessions = sessionsData.take(4).toList();
          loading = false;
        });
      } else if (resp.statusCode == 401 || sessionsResp.statusCode == 401) {
        if (mounted) Navigator.of(context).pushReplacementNamed('/login');
      } else {
        setState(() { error = 'Error with data loading'; loading = false; });
      }
    } catch (e) {
      if (e.toString().contains('Not authorized') && mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
        return;
      }
      setState(() { error = e.toString(); loading = false; });
    }
  }

  String _formatDate(DateTime date) {
    final months = ['January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'];
    final weekdays = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
    return '${weekdays[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}';
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Необходимо для AutomaticKeepAliveClientMixin
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color darkButtonColor = Color(0xFF23272F);
    final Color unfilledTrackColor = isDark ? Color(0xFF23272F) : Colors.grey[300]!;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : error != null
          ? Center(child: Text(error!, style: const TextStyle(color: Colors.red)))
          : SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 28),
                _buildStressIndicator(),
                const SizedBox(height: 28),
                _buildNewButtonsSection(context),
                const SizedBox(height: 24),
                _buildHistorySection(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello, $userName',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Theme.of(context).colorScheme.onBackground),
              ),
              const SizedBox(height: 8),
              Text(
                'Sunday, July 14',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onBackground),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStressIndicator() {
    final avg = averageStress ?? 0.0;
    final percent = (avg / 10).clamp(0.0, 1.0); // если шкала 0-10
    String levelText;
    Color indicatorColor;
    if (avg < 3) {
      levelText = 'Low';
      indicatorColor = const Color(0xFF8BC34A); // зелёный
    } else if (avg < 7) {
      levelText = 'Moderate';
      indicatorColor = const Color(0xFFFFB74D); // оранжевый
    } else {
      levelText = 'High';
      indicatorColor = const Color(0xFFE57373); // красный
    }
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Column(
        children: [
          Text(
            'Your Stress Level',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 18),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 200,
                height: 200,
                child: CircularProgressIndicator(
                  value: percent,
                  strokeWidth: 12,
                  backgroundColor: Colors.grey[100],
                  valueColor: AlwaysStoppedAnimation<Color>(indicatorColor),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${(percent * 100).toInt()}%',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: indicatorColor,
                      )),
                  const SizedBox(height: 4),
                  Text(levelText,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[600],
                      )),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildLevelIndicator('Low', '0-30%', const Color(0xFF8BC34A)),
              _buildLevelIndicator('Moderate', '31-70%', const Color(0xFFFFB74D)),
              _buildLevelIndicator('High', '71-100%', const Color(0xFFE57373)),
            ],
          ),
          const SizedBox(height: 16),
          Text('Total sessions: ${totalSessions ?? 0}', style: TextStyle(color: Colors.grey[700], fontSize: 15)),
        ],
      ),
    );
  }

  Widget _buildLevelIndicator(String title, String range, Color color) {
    return Column(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(height: 4),
        Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
        Text(range, style: TextStyle(fontSize: 10, color: Colors.grey[500])),
      ],
    );
  }


  Widget _buildNewButtonsSection(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color darkButtonColor = Color(0xFF23272F); // Цвет для кнопок в тёмной теме
    final Color mintColor = Color(0xFF7AC7A6); // Цвет текста на кнопке
    final Color unfilledTrackColor = isDark ? Color(0xFF23272F) : Colors.grey[300]!;
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark ? darkButtonColor : Colors.white,
                    foregroundColor: isDark ? mintColor : Theme.of(context).colorScheme.primary,
                    side: BorderSide(color: isDark ? darkButtonColor : Theme.of(context).colorScheme.primary, width: 2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => Navigator.pushNamed(context, '/add_session'),
                  child: Text('Add Session', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark ? darkButtonColor : Colors.white,
                    foregroundColor: isDark ? mintColor : Theme.of(context).colorScheme.primary,
                    side: BorderSide(color: isDark ? darkButtonColor : Theme.of(context).colorScheme.primary, width: 2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => Navigator.pushNamed(context, '/sessions'),
                  child: Text('View Sessions', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // "Recommendations for relax"
        ElevatedButton(
          onPressed: () => Navigator.pushNamed(context, '/recommendations'),
          style: ElevatedButton.styleFrom(
            backgroundColor: mintColor,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.spa, size: 20),
              SizedBox(width: 8),
              Text(
                'Recommendations for Relax',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHistorySection(BuildContext context) {
    if (recentSessions.isEmpty) {
      return const Center(
        child: Text('There are no records, add the first session!'),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent History',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Theme.of(context).colorScheme.onBackground),
            ),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/sessions'),
              child: Text(
                'View All',
                style: TextStyle(
                  color: mintColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...recentSessions.asMap().entries.map((entry) {
          final i = entry.key;
          final s = entry.value;
          final date = DateTime.parse(s['date'] as String? ?? '');
          final now = DateTime.now();
          final diff = now.difference(date).inDays;
          String dateLabel = diff == 0 ? 'Today' : '$diff days ago';
          final stressLevel = s['stress_level'] as int? ?? 0;
          final description = s['description'] as String? ?? '';
          final percent = (stressLevel / 10).clamp(0.0, 1.0);
          final bool isDark = Theme.of(context).brightness == Brightness.dark;
          final Color unfilledTrackColor = isDark ? Color(0xFF23272F) : Colors.grey[300]!;
          final Color mintColor = Color(0xFF7AC7A6);
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.insights, color: mintColor, size: 20),
              ),
              title: Text(
                dateLabel,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (description.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(description, style: const TextStyle(fontSize: 13)),
                    ),
                  LinearProgressIndicator(
                    value: percent,
                    minHeight: 6,
                    backgroundColor: unfilledTrackColor,
                    valueColor: AlwaysStoppedAnimation<Color>(mintColor),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ],
              ),
              trailing: Text(
                '${(percent * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: mintColor,
                ),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildHistoryItem(int index, double value) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color unfilledTrackColor = isDark ? Color(0xFF23272F) : Colors.grey[300]!;
    final Color mintColor = const Color(0xFF7AC7A6); // Цвет текста на кнопке
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F5E9),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(Icons.insights, color: mintColor, size: 20),
        ),
        title: Text(
          '${index == 0 ? "Today" : "$index days ago"}',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 6,
            backgroundColor: unfilledTrackColor,
            valueColor: AlwaysStoppedAnimation<Color>(mintColor),
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        trailing: Text(
          '${(value * 100).toInt()}%',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: mintColor,
          ),
        ),
      ),
    );
  }
}
