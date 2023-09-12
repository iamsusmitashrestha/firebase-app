import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/user.dart';

// class SharedPreferencesService {
//   final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

//   SharedPreferencesService();

//   Future<void> saveUserDataOffline(UserModel user) async {
//     final userJson = jsonEncode(user.toJson());
//     _prefs.then((pref) async => await pref.setString('userData', userJson));
//   }

//   Future<UserModel> getUserDataOffline() async {
//     return _prefs.then((pref) async => getUser(pref));
//   }

//   Future<UserModel> getUser(SharedPreferences pref) async {
//     final userData = pref.getString('userData');
//     pref.reload();
//     final userModel = UserModel.fromJson(jsonDecode(userData!));
//     return userModel;
//   }
// }

class SharedPreferencesService {
  static Future<void> saveUserDataOffline(UserModel user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final userJson = jsonEncode(user.toJson());
    await prefs.setString('userData', userJson);
  }

  static Future<UserModel?> getUserDataOffline() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      final userData = prefs.getString('userData') ?? '';

      if (userData.isNotEmpty) {
        final userModel = UserModel.fromJson(jsonDecode(userData));
        return userModel;
      } else {
        return null;
      }
    } catch (e) {
      print("get user data offline $e");
      return null;
    }
  }

  static Future<void> clearUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
