import 'package:shared_preferences/shared_preferences.dart';

class UserInfo {
  // Singleton
  static final UserInfo _instance = UserInfo._internal();
  factory UserInfo() => _instance;
  UserInfo._internal();

  SharedPreferences? _prefs;

  static const String _keyName = "user_name";
  static const String _keyEmail = "user_email";
  static const String _keyLoggedIn = "is_logged_in";

  /// Initialize SharedPreferences (call in main)
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Save user
  Future<void> saveUser({
    required String name,
    required String email,
    required bool loggedIn,
  }) async {
    if (_prefs == null) return;
    await _prefs!.setString(_keyName, name);
    await _prefs!.setString(_keyEmail, email);
    await _prefs!.setBool(_keyLoggedIn, loggedIn);
  }

  // Getters
  String get name => _prefs?.getString(_keyName) ?? "";
  String get email => _prefs?.getString(_keyEmail) ?? "";
  bool get isLoggedIn => _prefs?.getBool(_keyLoggedIn) ?? false;

  // Clear user
  Future<void> clearUser() async {
    if (_prefs == null) return;
    await _prefs!.remove(_keyName);
    await _prefs!.remove(_keyEmail);
    await _prefs!.remove(_keyLoggedIn);
  }
}
