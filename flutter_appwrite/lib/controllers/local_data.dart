import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LocalSavedData {

  static final LocalSavedData _appwriteController = LocalSavedData._internal();

  factory LocalSavedData() {
    return _appwriteController;
  }

  LocalSavedData._internal();

  static SharedPreferences? preferences;

  // initialize
  static Future<void> init() async {
    preferences = await SharedPreferences.getInstance();
  }

  // save the userId
  static Future<void> saveUserData(Map<String, dynamic> userData) async {
    try {
      final String data = json.encode(userData);
      preferences?.setString("userId", data);
    } catch (e) {
      print("saveUserData Error: $e");
    }
  }

  // save the userId
  static Future<String>  getUserData() async {
    final String userData = preferences?.getString("userId") ?? "";
    return userData;
  }
}