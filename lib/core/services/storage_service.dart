import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _userKey = 'logged_in_user';
  static const String _usersKey = 'registered_users';

  String _favoriteKeyByEmail(String email) =>
      'favorite_articles_${email.toLowerCase()}';

  Future<void> saveLoggedInUser(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user));
  }

  Future<Map<String, dynamic>?> getLoggedInUser() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_userKey);
    if (data == null || data.isEmpty) return null;
    return jsonDecode(data) as Map<String, dynamic>;
  }

  Future<void> clearLoggedInUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }

  Future<List<Map<String, dynamic>>> getRegisteredUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_usersKey);
    if (data == null || data.isEmpty) return [];
    final List<dynamic> decoded = jsonDecode(data);
    return decoded.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  Future<void> saveRegisteredUsers(List<Map<String, dynamic>> users) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usersKey, jsonEncode(users));
  }

  Future<List<int>> getFavoriteIds(String email) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _favoriteKeyByEmail(email);
    return prefs.getStringList(key)?.map(int.parse).toList() ?? [];
  }

  Future<void> saveFavoriteIds(String email, List<int> ids) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _favoriteKeyByEmail(email);
    await prefs.setStringList(
      key,
      ids.map((e) => e.toString()).toList(),
    );
  }
}