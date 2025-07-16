// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  static String m0(date) => "Date: ${date}";

  static String m1(days) => "${days} days ago";

  static String m2(e) => "Error while savig or recieving sessions: ${e}";

  static String m3(userName) => "Hello, ${userName}";

  static String m4(level) => "Average stress level: ${level}";

  static String m5(count) => "Total sessions: ${count}";

  static String m6(weekday, month, day) => "${weekday}, ${month} ${day}";

  static String m7(count) => "Total sessions: ${count}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "addSession": MessageLookupByLibrary.simpleMessage("Add Session"),
    "addSessionTitle": MessageLookupByLibrary.simpleMessage("Add Session"),
    "appTitle": MessageLookupByLibrary.simpleMessage("Stress Management App"),
    "backToLogin": MessageLookupByLibrary.simpleMessage("Back to Log in"),
    "backToRegister": MessageLookupByLibrary.simpleMessage("Back to Log in"),
    "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "changeDate": MessageLookupByLibrary.simpleMessage("Change date"),
    "confirmPasswordLabel": MessageLookupByLibrary.simpleMessage(
      "Repeat Password",
    ),
    "darkMode": MessageLookupByLibrary.simpleMessage("Dark Mode"),
    "dateLabel": m0,
    "daysAgo": m1,
    "descriptionLabel": MessageLookupByLibrary.simpleMessage("Description"),
    "emailLabel": MessageLookupByLibrary.simpleMessage("Email"),
    "error": MessageLookupByLibrary.simpleMessage("Error"),
    "errorEmailEmpty": MessageLookupByLibrary.simpleMessage(
      "Email cannot be empty",
    ),
    "errorEmailInvalid": MessageLookupByLibrary.simpleMessage(
      "Enter a valid email address",
    ),
    "errorEmptyDescription": MessageLookupByLibrary.simpleMessage(
      "Please enter a description",
    ),
    "errorNicknameEmpty": MessageLookupByLibrary.simpleMessage(
      "Nickname cannot be empty",
    ),
    "errorPasswordEmpty": MessageLookupByLibrary.simpleMessage(
      "Password cannot be empty",
    ),
    "errorPasswordInvalid": MessageLookupByLibrary.simpleMessage(
      "Password must be at least 5 characters and contain a letter",
    ),
    "errorPasswordsDontMatch": MessageLookupByLibrary.simpleMessage(
      "Passwords do not match",
    ),
    "errorSaveRecieve": m2,
    "errorUsernameEmpty": MessageLookupByLibrary.simpleMessage(
      "Username cannot be empty",
    ),
    "helloUser": m3,
    "high": MessageLookupByLibrary.simpleMessage("High"),
    "homeTitle": MessageLookupByLibrary.simpleMessage("Home"),
    "languageLabel": MessageLookupByLibrary.simpleMessage("Language"),
    "lightMode": MessageLookupByLibrary.simpleMessage("Light Mode"),
    "loading": MessageLookupByLibrary.simpleMessage("Loading…"),
    "loginButton": MessageLookupByLibrary.simpleMessage("Login"),
    "loginError": MessageLookupByLibrary.simpleMessage("Login failed"),
    "loginTitle": MessageLookupByLibrary.simpleMessage("Welcome back!"),
    "low": MessageLookupByLibrary.simpleMessage("Low"),
    "moderate": MessageLookupByLibrary.simpleMessage("Moderate"),
    "nicknameLabel": MessageLookupByLibrary.simpleMessage("Nickname"),
    "noRecommendations": MessageLookupByLibrary.simpleMessage(
      "No recommendations",
    ),
    "noRecords": MessageLookupByLibrary.simpleMessage(
      "There are no records, add the first session!",
    ),
    "noSessions": MessageLookupByLibrary.simpleMessage(
      "There are no records, add the first session!",
    ),
    "ok": MessageLookupByLibrary.simpleMessage("OK"),
    "passwordLabel": MessageLookupByLibrary.simpleMessage("Password"),
    "pleaseWait": MessageLookupByLibrary.simpleMessage("Please wait..."),
    "recentHistory": MessageLookupByLibrary.simpleMessage("Recent History"),
    "recommendationsForRelax": MessageLookupByLibrary.simpleMessage(
      "Recommendations for Relax",
    ),
    "recommendationsTitle": MessageLookupByLibrary.simpleMessage(
      "Recommendations",
    ),
    "registrationError": MessageLookupByLibrary.simpleMessage(
      "Registration failed",
    ),
    "registrationSuccess": MessageLookupByLibrary.simpleMessage(
      "Registration successful",
    ),
    "registrationTitle": MessageLookupByLibrary.simpleMessage(
      "Creating an account",
    ),
    "save": MessageLookupByLibrary.simpleMessage("Save"),
    "sessionSaved": MessageLookupByLibrary.simpleMessage(
      "Session saved successfully",
    ),
    "sessionsListTitle": MessageLookupByLibrary.simpleMessage(
      "List of sessions",
    ),
    "settingsTitle": MessageLookupByLibrary.simpleMessage("Settings"),
    "signUpButton": MessageLookupByLibrary.simpleMessage("Sign Up"),
    "smartRecs": MessageLookupByLibrary.simpleMessage("Smart recommendations"),
    "splashLoading": MessageLookupByLibrary.simpleMessage("Loading…"),
    "statsAverageStress": m4,
    "statsTitle": MessageLookupByLibrary.simpleMessage("Statistics"),
    "statsTotalSessions": m5,
    "stressLevelLabel": MessageLookupByLibrary.simpleMessage("Stress level:"),
    "successTitle": MessageLookupByLibrary.simpleMessage("Done"),
    "supportMessageHigh": MessageLookupByLibrary.simpleMessage(
      "You seem a bit stressed. Try taking a moment to unwind.",
    ),
    "supportMessageLow": MessageLookupByLibrary.simpleMessage(
      "Excellent stress level — keep up the good work!",
    ),
    "supportMessageModerate": MessageLookupByLibrary.simpleMessage(
      "Great job! Take some time to relax when you can.",
    ),
    "supportMessageVeryHigh": MessageLookupByLibrary.simpleMessage(
      "High stress detected. Consider deep breathing or a short meditation.",
    ),
    "themeLabel": MessageLookupByLibrary.simpleMessage("Theme"),
    "today": MessageLookupByLibrary.simpleMessage("Today"),
    "todayDate": m6,
    "totalSessions": m7,
    "usernameLabel": MessageLookupByLibrary.simpleMessage("Username"),
    "viewAll": MessageLookupByLibrary.simpleMessage("View All"),
    "viewSessions": MessageLookupByLibrary.simpleMessage("View Sessions"),
    "yourStressLevel": MessageLookupByLibrary.simpleMessage(
      "Your Stress Level",
    ),
  };
}
