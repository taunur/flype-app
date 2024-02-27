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
