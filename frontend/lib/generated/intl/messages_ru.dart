// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ru locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'ru';

  static String m0(date) => "Дата: ${date}";

  static String m1(days) => "${days} дней назад";

  static String m2(e) =>
      "Ошибка при сохранении или получении рекомендаций: ${e}";

  static String m3(userName) => "Привет, ${userName}";

  static String m4(level) => "Средний уровень стресса: ${level}";

  static String m5(count) => "Всего сессий: ${count}";

  static String m6(weekday, month, day) => "${weekday}, ${month} ${day}";

  static String m7(count) => "Всего сессий: ${count}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "addSession": MessageLookupByLibrary.simpleMessage("Добавить сессию"),
    "addSessionTitle": MessageLookupByLibrary.simpleMessage("Добавить сессию"),
    "appTitle": MessageLookupByLibrary.simpleMessage(
      "Приложение по управлению стрессом",
    ),
    "backToLogin": MessageLookupByLibrary.simpleMessage("Назад к входу"),
    "backToRegister": MessageLookupByLibrary.simpleMessage("Назад к входу"),
    "cancel": MessageLookupByLibrary.simpleMessage("Отмена"),
    "changeDate": MessageLookupByLibrary.simpleMessage("Изменить дату"),
    "confirmPasswordLabel": MessageLookupByLibrary.simpleMessage(
      "Повторите пароль",
    ),
    "darkMode": MessageLookupByLibrary.simpleMessage("Тёмная тема"),
    "dateLabel": m0,
    "daysAgo": m1,
    "descriptionLabel": MessageLookupByLibrary.simpleMessage("Описание"),
    "emailLabel": MessageLookupByLibrary.simpleMessage("Email"),
    "error": MessageLookupByLibrary.simpleMessage("Ошибка"),
    "errorEmailEmpty": MessageLookupByLibrary.simpleMessage(
      "Email не может быть пустым",
    ),
    "errorEmailInvalid": MessageLookupByLibrary.simpleMessage(
      "Введите корректный адрес электронной почты",
    ),
    "errorEmptyDescription": MessageLookupByLibrary.simpleMessage(
      "Пожалуйста, введите описание",
    ),
    "errorNicknameEmpty": MessageLookupByLibrary.simpleMessage(
      "Никнейм не может быть пустым",
    ),
    "errorPasswordEmpty": MessageLookupByLibrary.simpleMessage(
      "Пароль не может быть пустым",
    ),
    "errorPasswordInvalid": MessageLookupByLibrary.simpleMessage(
      "Пароль должен быть не менее 5 символов и содержать букву",
    ),
    "errorPasswordsDontMatch": MessageLookupByLibrary.simpleMessage(
      "Пароли не совпадают",
    ),
    "errorSaveRecieve": m2,
    "errorUsernameEmpty": MessageLookupByLibrary.simpleMessage(
      "Имя пользователя не может быть пустым",
    ),
    "helloUser": m3,
    "high": MessageLookupByLibrary.simpleMessage("Высокий"),
    "homeTitle": MessageLookupByLibrary.simpleMessage("Главная"),
    "languageLabel": MessageLookupByLibrary.simpleMessage("Язык"),
    "lightMode": MessageLookupByLibrary.simpleMessage("Светлая тема"),
    "loading": MessageLookupByLibrary.simpleMessage("Загрузка…"),
    "loginButton": MessageLookupByLibrary.simpleMessage("Войти"),
    "loginError": MessageLookupByLibrary.simpleMessage("Ошибка входа"),
    "loginTitle": MessageLookupByLibrary.simpleMessage("С возвращением!"),
    "low": MessageLookupByLibrary.simpleMessage("Низкий"),
    "moderate": MessageLookupByLibrary.simpleMessage("Средний"),
    "nicknameLabel": MessageLookupByLibrary.simpleMessage("Никнейм"),
    "noRecommendations": MessageLookupByLibrary.simpleMessage(
      "Нет рекомендаций",
    ),
    "noRecords": MessageLookupByLibrary.simpleMessage(
      "Записей нет, добавьте первую сессию!",
    ),
    "noSessions": MessageLookupByLibrary.simpleMessage(
      "Записей нет, добавьте первую сессию!",
    ),
    "ok": MessageLookupByLibrary.simpleMessage("ОК"),
    "passwordLabel": MessageLookupByLibrary.simpleMessage("Пароль"),
    "recentHistory": MessageLookupByLibrary.simpleMessage("Последние записи"),
    "recommendationsForRelax": MessageLookupByLibrary.simpleMessage(
      "Рекомендации для расслабления",
    ),
    "recommendationsTitle": MessageLookupByLibrary.simpleMessage(
      "Рекомендации",
    ),
    "registrationError": MessageLookupByLibrary.simpleMessage(
      "Ошибка регистрации",
    ),
    "registrationSuccess": MessageLookupByLibrary.simpleMessage(
      "Регистрация прошла успешно",
    ),
    "registrationTitle": MessageLookupByLibrary.simpleMessage(
      "Создание аккаунта",
    ),
    "save": MessageLookupByLibrary.simpleMessage("Сохранить"),
    "sessionSaved": MessageLookupByLibrary.simpleMessage(
      "Сессия успешно сохранена",
    ),
    "sessionsListTitle": MessageLookupByLibrary.simpleMessage("Список сессий"),
    "settingsTitle": MessageLookupByLibrary.simpleMessage("Настройки"),
    "signUpButton": MessageLookupByLibrary.simpleMessage("Зарегистрироваться"),
    "smartRecs": MessageLookupByLibrary.simpleMessage("Умные рекомендации"),
    "splashLoading": MessageLookupByLibrary.simpleMessage("Загрузка…"),
    "statsAverageStress": m4,
    "statsTitle": MessageLookupByLibrary.simpleMessage("Статистика"),
    "statsTotalSessions": m5,
    "stressLevelLabel": MessageLookupByLibrary.simpleMessage(
      "Уровень стресса:",
    ),
    "successTitle": MessageLookupByLibrary.simpleMessage("Готово"),
    "supportMessageHigh": MessageLookupByLibrary.simpleMessage(
      "Вы выглядите напряжённым. Попробуйте расслабиться.",
    ),
    "supportMessageLow": MessageLookupByLibrary.simpleMessage(
      "Отличный уровень стресса — так держать!",
    ),
    "supportMessageModerate": MessageLookupByLibrary.simpleMessage(
      "Хорошая работа! Найдите время для отдыха.",
    ),
    "supportMessageVeryHigh": MessageLookupByLibrary.simpleMessage(
      "Высокий уровень стресса. Попробуйте дыхательное упражнение.",
    ),
    "themeLabel": MessageLookupByLibrary.simpleMessage("Тема"),
    "today": MessageLookupByLibrary.simpleMessage("Сегодня"),
    "todayDate": m6,
    "totalSessions": m7,
    "usernameLabel": MessageLookupByLibrary.simpleMessage("Имя пользователя"),
    "viewAll": MessageLookupByLibrary.simpleMessage("Показать все"),
    "viewSessions": MessageLookupByLibrary.simpleMessage("Просмотреть сессии"),
    "yourStressLevel": MessageLookupByLibrary.simpleMessage(
      "Ваш уровень стресса",
    ),
  };
}
