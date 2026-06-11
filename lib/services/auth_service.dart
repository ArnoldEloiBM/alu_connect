import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  AuthService._();

  static const _kCurrentUserEmail = 'auth.current_user_email';
  static const _kProfilePrefix = 'auth.profile.';
  static const _kPasswordPrefix = 'auth.password.';

  static const emailDomain = 'alustudent.com';
  static const emailHint = 'you@alustudent.com';

  /// Demo account for local development and testing.
  static const demoEmail = 'student@alustudent.com';
  static const demoPassword = 'Password1';

  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
    await _seedDemoUserIfNeeded();
  }

  static Future<void> _ensureInit() async {
    if (_prefs == null) {
      await init();
    }
  }

  static Future<void> _seedDemoUserIfNeeded() async {
    if (await hasUserProfile(demoEmail)) return;
    await saveUserProfile(
      email: demoEmail,
      fullName: 'Kwame Mensah',
      role: 'student',
      isAlumni: false,
      intakeMonth: 'September',
      intakeYear: '2023',
      faculty: 'BSE',
    );
    await savePassword(demoEmail, demoPassword);
  }

  static String? validateAluStudentEmail(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required';
    final email = value.trim().toLowerCase();
    final re = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!re.hasMatch(email)) return 'Enter a valid email address';
    if (!email.endsWith('@$emailDomain')) {
      return 'Use your @$emailDomain email';
    }
    return null;
  }

  static String? validateStrongPassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 8) return 'Must be at least 8 characters';
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Include at least one uppercase letter';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Include at least one number';
    }
    return null;
  }

  static Future<bool> isSignedIn() async {
    await _ensureInit();
    final email = _prefs?.getString(_kCurrentUserEmail);
    return email != null && email.isNotEmpty;
  }

  static String _normalizeEmail(String email) => email.trim().toLowerCase();

  static Future<String?> getCurrentUserEmail() async {
    await _ensureInit();
    return _prefs?.getString(_kCurrentUserEmail);
  }

  static Future<Map<String, dynamic>?> getCurrentUserProfile() async {
    final email = await getCurrentUserEmail();
    if (email == null) return null;
    return getUserProfile(email);
  }

  static Future<void> setCurrentUserEmail(String email) async {
    await _ensureInit();
    await _prefs?.setString(_kCurrentUserEmail, _normalizeEmail(email));
  }

  static Future<void> clearCurrentUser() async {
    await _ensureInit();
    await _prefs?.remove(_kCurrentUserEmail);
  }

  static Future<void> savePassword(String email, String password) async {
    await _ensureInit();
    await _prefs?.setString(
      '$_kPasswordPrefix${_normalizeEmail(email)}',
      password,
    );
  }

  /// Returns true when email and password match a registered account.
  static Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    await _ensureInit();
    final normalizedEmail = _normalizeEmail(email);
    if (!await hasUserProfile(normalizedEmail)) {
      return false;
    }
    final stored = _prefs?.getString('$_kPasswordPrefix$normalizedEmail');
    return stored == password;
  }

  static Future<bool> hasUserProfile(String email) async {
    await _ensureInit();
    return _prefs?.containsKey('$_kProfilePrefix${_normalizeEmail(email)}') ??
        false;
  }

  static Future<void> saveUserProfile({
    required String email,
    required String fullName,
    required String role,
    required bool isAlumni,
    String? intakeMonth,
    String? intakeYear,
    String? graduationYear,
    String? faculty,
  }) async {
    await _ensureInit();
    final normalizedEmail = _normalizeEmail(email);
    final profile = {
      'email': normalizedEmail,
      'fullName': fullName,
      'role': role,
      'isAlumni': isAlumni,
      'intakeMonth': intakeMonth,
      'intakeYear': intakeYear,
      'graduationYear': graduationYear,
      'faculty': faculty,
    };
    await _prefs?.setString(
      '$_kProfilePrefix$normalizedEmail',
      jsonEncode(profile),
    );
  }

  static Future<Map<String, dynamic>?> getUserProfile(String email) async {
    await _ensureInit();
    final raw = _prefs?.getString('$_kProfilePrefix${_normalizeEmail(email)}');
    if (raw == null) return null;
    return Map<String, dynamic>.from(jsonDecode(raw) as Map);
  }

  static Future<bool> changePassword({
    required String email,
    required String currentPassword,
    required String newPassword,
  }) async {
    final approved = await signIn(email: email, password: currentPassword);
    if (!approved) return false;
    await savePassword(email, newPassword);
    return true;
  }
}
