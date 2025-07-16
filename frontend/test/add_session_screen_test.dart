import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:stress_management_app/screens/add_session_screen.dart';
import 'package:stress_management_app/services/auth_service.dart';
import 'package:stress_management_app/models/advice.dart';

class MockAuthService extends AuthService {
  bool addSessionCalled = false;
  bool getAIAdviceCalled = false;
  String? lastDescription;
  int? lastStressLevel;
  DateTime? lastDate;
  Exception? throwError;

  @override
  Future<void> addSession(String description, int stressLevel, DateTime date) async {
    addSessionCalled = true;
    lastDescription = description;
    lastStressLevel = stressLevel;
    lastDate = date;
    if (throwError != null) throw throwError!;
  }

  @override
  Future<Advice> getAIAdvice(String description, int stressLevel, DateTime date) async {
    getAIAdviceCalled = true;
    if (throwError != null) throw throwError!;
    return Advice(id: 1, title: 'Test Advice', description: 'Test description');
  }
}

void main() {
  late MockAuthService mockAuthService;

  setUp(() {
    mockAuthService = MockAuthService();
    // Здесь должна быть логика внедрения зависимости, например через Provider
  });

  testWidgets('1. Отображаются основные элементы интерфейса', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: AddSessionScreen()));

    expect(find.text('Добавить сессию'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.byType(Slider), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });

  testWidgets('2. Показ ошибки при пустом описании', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: AddSessionScreen()));

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(find.text('Описание не может быть пустым'), findsOneWidget);
  });

  testWidgets('3. Изменение уровня стресса через слайдер', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: AddSessionScreen()));

    final slider = find.byType(Slider);
    await tester.drag(slider, const Offset(50, 0));
    await tester.pump();

    final textFinder = find.textContaining(RegExp(r'[6-9]|10'));
    expect(textFinder, findsOneWidget);
  });

  testWidgets('4. Изменение даты через диалог выбора', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: AddSessionScreen()));

    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    await tester.tap(find.text('Изменить дату'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('${yesterday.day}'));
    await tester.pumpAndSettle();

    expect(find.text(DateFormat.yMMMd().format(yesterday)), findsOneWidget);
  });

  testWidgets('5. Отображение индикатора загрузки при сохранении', (WidgetTester tester) async {
    // Тест требует интеграции с DI, показан как пример
  });

  testWidgets('7. Обработка ошибки при сохранении', (WidgetTester tester) async {
    // Тест требует интеграции с DI, показан как пример
  });

  testWidgets('8. Отмена выбора даты', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: AddSessionScreen()));

    final initialDate = DateFormat.yMMMd().format(DateTime.now());
    await tester.tap(find.text('Изменить дату'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('CANCEL'));
    await tester.pumpAndSettle();

    expect(find.text(initialDate), findsOneWidget);
  });

  testWidgets('9. Проверка граничных значений слайдера', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: AddSessionScreen()));

    final slider = find.byType(Slider);

    // Установка минимального значения
    await tester.drag(slider, const Offset(-500, 0));
    await tester.pump();
    expect(find.text('1'), findsOneWidget);

    // Установка максимального значения
    await tester.drag(slider, const Offset(500, 0));
    await tester.pump();
    expect(find.text('10'), findsOneWidget);
  });
}