import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/user.dart';

class SharedPreferencesService {
  SharedPreferences? _prefs;

  SharedPreferencesService() {
    _initPreferences();
  }

  Future<void> _initPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> saveUserDataOffline(UserModel user) async {
    if (_prefs == null) {
      await _initPreferences();
    }

    final userJson = jsonEncode(user.toJson());
    await _prefs!.setString('userData', userJson);
  }

  Future<UserModel> getUserDataOffline() async {
    if (_prefs == null) {
      await _initPreferences();
    }

    final userData = _prefs!.getString('userData') ?? '';

    final userModel = UserModel.fromJson(jsonDecode(userData));
    return userModel;
  }
}
