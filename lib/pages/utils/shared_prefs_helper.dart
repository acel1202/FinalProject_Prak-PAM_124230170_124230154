// lib/pages/utils/shared_prefs_helper.dart

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  // KEY YANG BENAR
  static const String keyIsLoggedIn = 'is_logged_in';
  static const String keyUsername = 'username';
  static const String keyEmail = 'email';

  // ------------------------------
  // SIMPAN USERNAME BARU
  // ------------------------------
  static Future<void> setUsername(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyUsername, username); // <- SUDAH BENAR
  }

  // ------------------------------
  // SIMPAN EMAIL BARU
  // ------------------------------
  static Future<void> setEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyEmail, email); // <- SUDAH BENAR
  }

  // ------------------------------
  // SET LOGIN STATUS
  // ------------------------------
  static Future<void> setLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyIsLoggedIn, value);
  }

  // ------------------------------
  // GET LOGIN STATUS
  // ------------------------------
  static Future<bool> getIsLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyIsLoggedIn) ?? false;
  }

  // ------------------------------
  // SIMPAN USER INFO
  // ------------------------------
  static Future<void> setUserInfo({
    required String username,
    required String email,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyUsername, username);
    await prefs.setString(keyEmail, email);
  }

  // ------------------------------
  // GET USERNAME
  // ------------------------------
  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyUsername);
  }

  // ------------------------------
  // GET EMAIL
  // ------------------------------
  static Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyEmail);
  }

  // ------------------------------
  // CLEAR SEMUA DATA
  // ------------------------------
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
