import 'dart:convert';

AuthModel userModelFromJson(String str) => AuthModel.fromJson(json.decode(str));

String userModelToJson(AuthModel data) => json.encode(data.toJson());

class AuthModel {
  bool error;
  String message;
  UserModel loginResult;

  AuthModel({
    required this.error,
    required this.message,
    required this.loginResult,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) => AuthModel(
        error: json["error"],
        message: json["message"],
        loginResult: UserModel.fromJson(json["loginResult"]),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "loginResult": loginResult.toJson(),
      };
}

class UserModel {
  String? userId;
  String? name;
  String? email;
  String? password;
  String? token;

  UserModel({
    this.userId,
    this.name,
    this.email,
    this.password,
    this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        userId: json["userId"],
        name: json["name"],
        email: json["email"],
        password: json["password"],
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "name": name,
        "email": email,
        "password": password,
        "token": token,
      };
}
