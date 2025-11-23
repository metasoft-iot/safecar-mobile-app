/// User model for authentication
class UserModel {
  final int id;
  final String username;
  final String email;
  final List<String> roles;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.roles,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      username: json['username'] as String,
      email: json['email'] as String? ?? '',
      roles: (json['roles'] as List<dynamic>?)
          ?.map((role) => role.toString())
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'roles': roles,
    };
  }
  
  bool get isDriver => roles.contains('ROLE_DRIVER');
}

/// Authentication response model
class AuthResponse {
  final int id;
  final String username;
  final String token;

  AuthResponse({
    required this.id,
    required this.username,
    required this.token,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      id: json['id'] as int,
      username: json['username'] as String,
      token: json['token'] as String,
    );
  }
}

