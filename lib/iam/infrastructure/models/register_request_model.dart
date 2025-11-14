class RegisterRequestModel {
  final String email;
  final String password;
  final String confirmPassword;
  final List<String> roles;

  RegisterRequestModel({
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.roles,
  });

  Map<String, dynamic> toJson() => {
    "email": email,
    "password": password,
    "confirmPassword": confirmPassword,
    "roles": roles,
  };
}
