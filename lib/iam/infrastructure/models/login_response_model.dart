class LoginResponseModel {
  final int id;
  final String username;
  final String token;

  LoginResponseModel({
    required this.id,
    required this.username,
    required this.token,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      id: json["id"],
      username: json["username"],
      token: json["token"],
    );
  }
}
