import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  AuthService._();

  static const _kCurrentUserEmail = 'auth.current_user_email';
  static const _kProfilePrefix = 'auth.profile.';

  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static Future<void> _ensureInit() async {
    if (_prefs == null) {
      await init();
    }
  }

  static Future<bool> isSignedIn() async {
    await _ensureInit();
    final email = _prefs?.getString(_kCurrentUserEmail);
    return email != null && email.isNotEmpty;
  }

  static Future<void> setCurrentUserEmail(String email) async {
    await _ensureInit();
    await _prefs?.setString(_kCurrentUserEmail, email);
  }

  static Future<void> clearCurrentUser() async {
    await _ensureInit();
    await _prefs?.remove(_kCurrentUserEmail);
  }

  static Future<bool> hasUserProfile(String email) async {
    await _ensureInit();
    return _prefs?.containsKey('$_kProfilePrefix$email') ?? false;
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
    final profile = {
      'email': email,
      'fullName': fullName,
      'role': role,
      'isAlumni': isAlumni,
      'intakeMonth': intakeMonth,
      'intakeYear': intakeYear,
      'graduationYear': graduationYear,
      'faculty': faculty,
    };
    await _prefs?.setString('$_kProfilePrefix$email', jsonEncode(profile));
  }

  static Future<Map<String, dynamic>?> getUserProfile(String email) async {
    await _ensureInit();
    final raw = _prefs?.getString('$_kProfilePrefix$email');
    if (raw == null) return null;
    return Map<String, dynamic>.from(jsonDecode(raw) as Map);
  }
}
