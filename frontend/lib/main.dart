import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/login_screen.dart';
import 'screens/registration_screen.dart';
import 'screens/home_screen.dart';
import 'screens/sessions_list_screen.dart';
import 'screens/add_session_screen.dart';
import 'screens/stats_screen.dart';
import 'screens/recommendations_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/main_wrapper_screen.dart';

final ThemeData customLightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Color(0xFF7AC7A6),
  scaffoldBackgroundColor: Color(0xFFF7F7F7),
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFF7AC7A6),
    foregroundColor: Colors.white,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.white),
  ),
  cardColor: Colors.white,
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Colors.black87),
    bodyMedium: TextStyle(color: Colors.black87),
    titleLarge: TextStyle(color: Colors.black87),
  ),
  colorScheme: ColorScheme.light(
    primary: Color(0xFF7AC7A6),
    secondary: Color(0xFF7AC7A6),
    background: Color(0xFFF7F7F7),
    surface: Colors.white,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onBackground: Colors.black87,
    onSurface: Colors.black87,
  ),
);

final ThemeData customDarkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Color(0xFF7AC7A6),
  scaffoldBackgroundColor: Color(0xFF181A20),
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFF23272F),
    foregroundColor: Colors.white,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.white),
  ),
  cardColor: Color(0xFF23272F),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white70),
    titleLarge: TextStyle(color: Colors.white),
  ),
  colorScheme: ColorScheme.dark(
    primary: Color(0xFF7AC7A6),
    secondary: Color(0xFF7AC7A6),
    background: Color(0xFF181A20),
    surface: Color(0xFF23272F),
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onBackground: Colors.white,
    onSurface: Colors.white,
  ),
);

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  ThemeProvider() {
    _loadTheme();
  }

  void toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    _saveTheme(isDark);
    notifyListeners();
  }

  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDarkMode') ?? false;
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void _saveTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', isDark);
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      title: 'Stress Management App',
      theme: customLightTheme,
      darkTheme: customDarkTheme,
      themeMode: themeProvider.themeMode,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegistrationScreen(),
        '/home': (context) => MainWrapperScreen(),
        '/sessions' : (context) => const SessionsListScreen(),
        '/add_session': (_) => const AddSessionScreen(),
        '/stats': (context) => const StatsScreen(),
        '/recommendations': (context) => const RecommendationsScreen(),
      },
    );
  }
}
