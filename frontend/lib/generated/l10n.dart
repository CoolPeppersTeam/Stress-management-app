// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Stress Management App`
  String get appTitle {
    return Intl.message(
      'Stress Management App',
      name: 'appTitle',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get ok {
    return Intl.message('OK', name: 'ok', desc: '', args: []);
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Loading…`
  String get loading {
    return Intl.message('Loading…', name: 'loading', desc: '', args: []);
  }

  /// `Error`
  String get error {
    return Intl.message('Error', name: 'error', desc: '', args: []);
  }

  /// `Loading…`
  String get splashLoading {
    return Intl.message('Loading…', name: 'splashLoading', desc: '', args: []);
  }

  /// `Please wait...`
  String get pleaseWait {
    return Intl.message(
      'Please wait...',
      name: 'pleaseWait',
      desc: '',
      args: [],
    );
  }

  /// `Welcome back!`
  String get loginTitle {
    return Intl.message(
      'Welcome back!',
      name: 'loginTitle',
      desc: '',
      args: [],
    );
  }

  /// `Username`
  String get usernameLabel {
    return Intl.message('Username', name: 'usernameLabel', desc: '', args: []);
  }

  /// `Password`
  String get passwordLabel {
    return Intl.message('Password', name: 'passwordLabel', desc: '', args: []);
  }

  /// `Login`
  String get loginButton {
    return Intl.message('Login', name: 'loginButton', desc: '', args: []);
  }

  /// `Back to Log in`
  String get backToLogin {
    return Intl.message(
      'Back to Log in',
      name: 'backToLogin',
      desc: '',
      args: [],
    );
  }

  /// `Username cannot be empty`
  String get errorUsernameEmpty {
    return Intl.message(
      'Username cannot be empty',
      name: 'errorUsernameEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Password cannot be empty`
  String get errorPasswordEmpty {
    return Intl.message(
      'Password cannot be empty',
      name: 'errorPasswordEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Password must be at least 5 characters and contain a letter`
  String get errorPasswordInvalid {
    return Intl.message(
      'Password must be at least 5 characters and contain a letter',
      name: 'errorPasswordInvalid',
      desc: '',
      args: [],
    );
  }

  /// `Login failed`
  String get loginError {
    return Intl.message('Login failed', name: 'loginError', desc: '', args: []);
  }

  /// `Creating an account`
  String get registrationTitle {
    return Intl.message(
      'Creating an account',
      name: 'registrationTitle',
      desc: '',
      args: [],
    );
  }

  /// `Nickname`
  String get nicknameLabel {
    return Intl.message('Nickname', name: 'nicknameLabel', desc: '', args: []);
  }

  /// `Email`
  String get emailLabel {
    return Intl.message('Email', name: 'emailLabel', desc: '', args: []);
  }

  /// `Repeat Password`
  String get confirmPasswordLabel {
    return Intl.message(
      'Repeat Password',
      name: 'confirmPasswordLabel',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get signUpButton {
    return Intl.message('Sign Up', name: 'signUpButton', desc: '', args: []);
  }

  /// `Back to Log in`
  String get backToRegister {
    return Intl.message(
      'Back to Log in',
      name: 'backToRegister',
      desc: '',
      args: [],
    );
  }

  /// `Nickname cannot be empty`
  String get errorNicknameEmpty {
    return Intl.message(
      'Nickname cannot be empty',
      name: 'errorNicknameEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Email cannot be empty`
  String get errorEmailEmpty {
    return Intl.message(
      'Email cannot be empty',
      name: 'errorEmailEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Enter a valid email address`
  String get errorEmailInvalid {
    return Intl.message(
      'Enter a valid email address',
      name: 'errorEmailInvalid',
      desc: '',
      args: [],
    );
  }

  /// `Passwords do not match`
  String get errorPasswordsDontMatch {
    return Intl.message(
      'Passwords do not match',
      name: 'errorPasswordsDontMatch',
      desc: '',
      args: [],
    );
  }

  /// `Registration successful`
  String get registrationSuccess {
    return Intl.message(
      'Registration successful',
      name: 'registrationSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Registration failed`
  String get registrationError {
    return Intl.message(
      'Registration failed',
      name: 'registrationError',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get homeTitle {
    return Intl.message('Home', name: 'homeTitle', desc: '', args: []);
  }

  /// `Hello, {userName}`
  String helloUser(Object userName) {
    return Intl.message(
      'Hello, $userName',
      name: 'helloUser',
      desc: '',
      args: [userName],
    );
  }

  /// `{weekday}, {month} {day}`
  String todayDate(Object weekday, Object month, Object day) {
    return Intl.message(
      '$weekday, $month $day',
      name: 'todayDate',
      desc: '',
      args: [weekday, month, day],
    );
  }

  /// `Your Stress Level`
  String get yourStressLevel {
    return Intl.message(
      'Your Stress Level',
      name: 'yourStressLevel',
      desc: '',
      args: [],
    );
  }

  /// `Low`
  String get low {
    return Intl.message('Low', name: 'low', desc: '', args: []);
  }

  /// `Moderate`
  String get moderate {
    return Intl.message('Moderate', name: 'moderate', desc: '', args: []);
  }

  /// `High`
  String get high {
    return Intl.message('High', name: 'high', desc: '', args: []);
  }

  /// `Total sessions: {count}`
  String totalSessions(Object count) {
    return Intl.message(
      'Total sessions: $count',
      name: 'totalSessions',
      desc: '',
      args: [count],
    );
  }

  /// `Add Session`
  String get addSession {
    return Intl.message('Add Session', name: 'addSession', desc: '', args: []);
  }

  /// `View Sessions`
  String get viewSessions {
    return Intl.message(
      'View Sessions',
      name: 'viewSessions',
      desc: '',
      args: [],
    );
  }

  /// `Recommendations for Relax`
  String get recommendationsForRelax {
    return Intl.message(
      'Recommendations for Relax',
      name: 'recommendationsForRelax',
      desc: '',
      args: [],
    );
  }

  /// `Recent History`
  String get recentHistory {
    return Intl.message(
      'Recent History',
      name: 'recentHistory',
      desc: '',
      args: [],
    );
  }

  /// `View All`
  String get viewAll {
    return Intl.message('View All', name: 'viewAll', desc: '', args: []);
  }

  /// `There are no records, add the first session!`
  String get noRecords {
    return Intl.message(
      'There are no records, add the first session!',
      name: 'noRecords',
      desc: '',
      args: [],
    );
  }

  /// `Today`
  String get today {
    return Intl.message('Today', name: 'today', desc: '', args: []);
  }

  /// `{days} days ago`
  String daysAgo(Object days) {
    return Intl.message(
      '$days days ago',
      name: 'daysAgo',
      desc: '',
      args: [days],
    );
  }

  /// `Add Session`
  String get addSessionTitle {
    return Intl.message(
      'Add Session',
      name: 'addSessionTitle',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get descriptionLabel {
    return Intl.message(
      'Description',
      name: 'descriptionLabel',
      desc: '',
      args: [],
    );
  }

  /// `Stress level:`
  String get stressLevelLabel {
    return Intl.message(
      'Stress level:',
      name: 'stressLevelLabel',
      desc: '',
      args: [],
    );
  }

  /// `Date: {date}`
  String dateLabel(Object date) {
    return Intl.message(
      'Date: $date',
      name: 'dateLabel',
      desc: '',
      args: [date],
    );
  }

  /// `Change date`
  String get changeDate {
    return Intl.message('Change date', name: 'changeDate', desc: '', args: []);
  }

  /// `Save`
  String get save {
    return Intl.message('Save', name: 'save', desc: '', args: []);
  }

  /// `Please enter a description`
  String get errorEmptyDescription {
    return Intl.message(
      'Please enter a description',
      name: 'errorEmptyDescription',
      desc: '',
      args: [],
    );
  }

  /// `Error while savig or recieving sessions: {e}`
  String errorSaveRecieve(Object e) {
    return Intl.message(
      'Error while savig or recieving sessions: $e',
      name: 'errorSaveRecieve',
      desc: '',
      args: [e],
    );
  }

  /// `Done`
  String get successTitle {
    return Intl.message('Done', name: 'successTitle', desc: '', args: []);
  }

  /// `Session saved successfully`
  String get sessionSaved {
    return Intl.message(
      'Session saved successfully',
      name: 'sessionSaved',
      desc: '',
      args: [],
    );
  }

  /// `Smart recommendations`
  String get smartRecs {
    return Intl.message(
      'Smart recommendations',
      name: 'smartRecs',
      desc: '',
      args: [],
    );
  }

  /// `Recommendations`
  String get recommendationsTitle {
    return Intl.message(
      'Recommendations',
      name: 'recommendationsTitle',
      desc: '',
      args: [],
    );
  }

  /// `No recommendations`
  String get noRecommendations {
    return Intl.message(
      'No recommendations',
      name: 'noRecommendations',
      desc: '',
      args: [],
    );
  }

  /// `List of sessions`
  String get sessionsListTitle {
    return Intl.message(
      'List of sessions',
      name: 'sessionsListTitle',
      desc: '',
      args: [],
    );
  }

  /// `There are no records, add the first session!`
  String get noSessions {
    return Intl.message(
      'There are no records, add the first session!',
      name: 'noSessions',
      desc: '',
      args: [],
    );
  }

  /// `Statistics`
  String get statsTitle {
    return Intl.message('Statistics', name: 'statsTitle', desc: '', args: []);
  }

  /// `Total sessions: {count}`
  String statsTotalSessions(Object count) {
    return Intl.message(
      'Total sessions: $count',
      name: 'statsTotalSessions',
      desc: '',
      args: [count],
    );
  }

  /// `Average stress level: {level}`
  String statsAverageStress(Object level) {
    return Intl.message(
      'Average stress level: $level',
      name: 'statsAverageStress',
      desc: '',
      args: [level],
    );
  }

  /// `Excellent stress level — keep up the good work!`
  String get supportMessageLow {
    return Intl.message(
      'Excellent stress level — keep up the good work!',
      name: 'supportMessageLow',
      desc: '',
      args: [],
    );
  }

  /// `Great job! Take some time to relax when you can.`
  String get supportMessageModerate {
    return Intl.message(
      'Great job! Take some time to relax when you can.',
      name: 'supportMessageModerate',
      desc: '',
      args: [],
    );
  }

  /// `You seem a bit stressed. Try taking a moment to unwind.`
  String get supportMessageHigh {
    return Intl.message(
      'You seem a bit stressed. Try taking a moment to unwind.',
      name: 'supportMessageHigh',
      desc: '',
      args: [],
    );
  }

  /// `High stress detected. Consider deep breathing or a short meditation.`
  String get supportMessageVeryHigh {
    return Intl.message(
      'High stress detected. Consider deep breathing or a short meditation.',
      name: 'supportMessageVeryHigh',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settingsTitle {
    return Intl.message('Settings', name: 'settingsTitle', desc: '', args: []);
  }

  /// `Language`
  String get languageLabel {
    return Intl.message('Language', name: 'languageLabel', desc: '', args: []);
  }

  /// `Theme`
  String get themeLabel {
    return Intl.message('Theme', name: 'themeLabel', desc: '', args: []);
  }

  /// `Dark Mode`
  String get darkMode {
    return Intl.message('Dark Mode', name: 'darkMode', desc: '', args: []);
  }

  /// `Light Mode`
  String get lightMode {
    return Intl.message('Light Mode', name: 'lightMode', desc: '', args: []);
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ru'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
