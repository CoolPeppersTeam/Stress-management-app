import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stress_management_app/screens/add_session_screen.dart';

void main() {
  testWidgets('Add Session Screen has title', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: AddSessionScreen()));
    expect(find.text('Add Session'), findsOneWidget);
  });
}
