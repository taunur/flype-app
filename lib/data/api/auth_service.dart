import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flype/data/model/user_response.dart';
import 'package:http/http.dart' as http;
import 'package:flype/data/model/user_model.dart';
import 'package:flype/data/utils/app_constants.dart';

class AuthServices {
  /// login
  Future<dynamic> login({
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

      debugPrint("login 200 : $responseData");
      return UserModel(userId: userId, name: name, token: token);
    } else if (response.statusCode == 401) {
      final Map<String, dynamic> errorData = jsonDecode(response.body);
      debugPrint("login 401 : $errorData");
      return UserResponse.fromJson(errorData);
    } else {
      throw Exception('Failed to Login');
    }
  }

  /// register
  Future<UserResponse> register({
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

    if (response.statusCode == 201) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      debugPrint("register 201 : $responseData");
      return UserResponse.fromJson(responseData);
    } else if (response.statusCode == 400) {
      final Map<String, dynamic> errorData = jsonDecode(response.body);
      debugPrint("register 400 : $errorData");
      return UserResponse.fromJson(errorData);
    } else {
      throw Exception('Failed to Register');
    }
  }
}
