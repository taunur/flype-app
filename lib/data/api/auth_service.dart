import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flype/data/model/user_model.dart';
import 'package:flype/data/utils/app_constants.dart';

class AuthServices {
  /// login
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse(AppConstants.login),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Connection': 'keep-alive',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final Map<String, dynamic> loginResultData = responseData['loginResult'];

      final String userId = loginResultData['userId'];
      final String name = loginResultData['name'];
      final String token = loginResultData['token'];
    
      return UserModel(userId: userId, name: name, token: token);
    } else {
      throw Exception('Failed to Login');
    }
  }

  /// register
  Future<AuthModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse(AppConstants.register),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Connection': 'keep-alive',
      },
      body: jsonEncode(<String, String>{
        'name': name,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      return AuthModel.fromJson(responseData);
    } else {
      throw Exception('Failed to Register');
    }
  }
}
