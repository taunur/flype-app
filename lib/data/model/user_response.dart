
import 'dart:convert';

UserResponse userResponseFromJson(String str) => UserResponse.fromJson(json.decode(str));

String userResponseToJson(UserResponse data) => json.encode(data.toJson());

class UserResponse {
    bool error;
    String message;

    UserResponse({
        required this.error,
        required this.message,
    });

    factory UserResponse.fromJson(Map<String, dynamic> json) => UserResponse(
        error: json["error"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
    };
}
