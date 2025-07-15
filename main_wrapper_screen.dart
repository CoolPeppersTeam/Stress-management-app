import 'package:flutter/material.dart';
import 'package:stress_management_app/screens/add_session_screen.dart';
import 'package:stress_management_app/screens/home_screen.dart';
import 'package:stress_management_app/screens/sessions_list_screen.dart';
import 'package:stress_management_app/screens/stats_screen.dart';
import 'package:stress_management_app/screens/recommendations_screen.dart';

class MainWrapperScreen extends StatefulWidget {
  const MainWrapperScreen({Key? key}) : super(key: key);

  @override
  _MainWrapperScreenState createState() => _MainWrapperScreenState();
}

class _MainWrapperScreenState extends State<MainWrapperScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    AddSessionScreen(),
    SessionsListScreen(),
  ];

  // Добавить навигацию в AppBar
  void _navigateToStats() => Navigator.pushNamed(context, '/stats');
  void _navigateToRecommendations() => Navigator.pushNamed(context, '/recommendations');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getAppBarTitle()),
        actions: [
          if (_currentIndex == 0) ...[
            IconButton(
              icon: Icon(Icons.bar_chart),
              onPressed: _navigateToStats,
            ),
            IconButton(
              icon: Icon(Icons.lightbulb_outline),
              onPressed: _navigateToRecommendations,
            ),
          ]
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
        ],
      ),
    );
  }

  // Метод для динамического заголовка
  String _getAppBarTitle() {
    switch (_currentIndex) {
      case 0: return 'Main';
      case 1: return 'New session';
      case 2: return 'Sessions history';
      default: return 'Stress Management';
    }
  }
}