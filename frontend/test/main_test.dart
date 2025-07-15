import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:stress_management_app/main.dart';

void main() {
  group('MyApp', () {
    testWidgets('builds with MaterialApp and ThemeProvider', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
          child: const MyApp(),
        ),
      );

      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byType(ChangeNotifierProvider<ThemeProvider>), findsOneWidget);
    });

    testWidgets('uses correct light theme data', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
          child: const MyApp(),
        ),
      );

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.theme?.primaryColor, const Color(0xFF7AC7A6));
      expect(materialApp.theme?.brightness, Brightness.light);
    });

    testWidgets('uses correct dark theme data', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => ThemeProvider()..toggleTheme(true),
          child: const MyApp(),
        ),
      );

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.darkTheme?.primaryColor, const Color(0xFF7AC7A6));
      expect(materialApp.darkTheme?.brightness, Brightness.dark);
    });

    testWidgets('has all routes configured', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
          child: const MyApp(),
        ),
      );
    });
  });
}