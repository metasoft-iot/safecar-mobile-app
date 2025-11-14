class RegisterResponseModel {
  final int id;
  final String email;
  final List<String> roles;

  RegisterResponseModel({
    required this.id,
    required this.email,
    required this.roles,
  });

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterResponseModel(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      roles: json['roles'] != null
          ? List<String>.from(json['roles'])
          : [],
    );
  }
}
