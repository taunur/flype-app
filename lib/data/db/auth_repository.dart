import 'dart:convert';
import 'package:flype/data/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  final String stateKey = "state";
  final String userKey = "user";

  Future<bool> isLoggedIn() async {
    final preferences = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 2));
    return preferences.getBool(stateKey) ?? false;
  }

  Future<bool> login() async {
    final preferences = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 2));
    return preferences.setBool(stateKey, true);
  }

  Future<bool> logout() async {
    final preferences = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 2));
    return preferences.setBool(stateKey, false);
  }

  Future<bool> saveUser(UserModel user) async {
    final preferences = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 2));
    final userJsonString = jsonEncode(user.toJson());
    preferences.setString(userKey, userJsonString);
    preferences.setString("token", user.token.toString());
    return true;
  }

  Future<bool> deleteUser() async {
    final preferences = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 2));
    preferences.remove(userKey); // Menghapus data pengguna dari penyimpanan
    preferences.remove("token"); // Menghapus token dari penyimpanan
    return true;
  }

  Future<UserModel?> getUser() async {
    final preferences = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 2));

    final jsonString = preferences.getString(userKey) ?? "";
    UserModel? user;
    try {
      final json = jsonDecode(jsonString);
      user = UserModel.fromJson(json);
    } catch (e) {
      user = null;
    }
    return user;
  }

  Future<String?> getToken() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString("token");
  }

  Future<bool> saveToken(String token) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString("token", token);
    return true;
  }
}
