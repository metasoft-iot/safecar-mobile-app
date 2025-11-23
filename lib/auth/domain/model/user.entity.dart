/// User entity for the authentication domain.
/// This represents a user in the system with their core attributes.
class User {
  final int id;
  final String username;
  final String email;
  final List<String> roles;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.roles,
  });

  /// Check if user has driver role
  bool get isDriver => roles.contains('ROLE_DRIVER');

  /// Create a copy of this user with optional updated fields
  User copyWith({
    int? id,
    String? username,
    String? email,
    List<String>? roles,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      roles: roles ?? this.roles,
    );
  }
}

