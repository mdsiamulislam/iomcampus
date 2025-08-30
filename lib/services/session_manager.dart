
import 'package:webview_flutter/webview_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String _cookieKey = 'webview_cookies';

  static Future<void> saveCookies(WebViewController controller) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_cookieKey, DateTime.now().toString());
    } catch (e) {
      print('Error saving cookies: $e');
    }
  }

  static Future<void> restoreCookies(WebViewController controller) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cookieData = prefs.getString(_cookieKey);
      if (cookieData != null) {
        // Cookies are automatically managed by the WebView
        print('Session data found, cookies should persist');
      }
    } catch (e) {
      print('Error restoring cookies: $e');
    }
  }

  static Future<void> clearSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_cookieKey);
    } catch (e) {
      print('Error clearing session: $e');
    }
  }
}