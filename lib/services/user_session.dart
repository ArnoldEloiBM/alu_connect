import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Lightweight session for the logged-in student's display name.
///
/// Persists locally until a full auth module replaces this. Event organizers
/// are published under this name instead of a hard-coded default.
class UserSession extends ChangeNotifier {
  UserSession._();
  static final UserSession instance = UserSession._();

  static const _nameKey = 'logged_in_user_name';

  String _displayName = '';

  String get displayName =>
      _displayName.trim().isNotEmpty ? _displayName.trim() : 'ALU Student';

  bool get hasProfileName => _displayName.trim().isNotEmpty;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _displayName = prefs.getString(_nameKey) ?? '';
    notifyListeners();
  }

  Future<void> setDisplayName(String name) async {
    _displayName = name.trim();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_nameKey, _displayName);
    notifyListeners();
  }
}
