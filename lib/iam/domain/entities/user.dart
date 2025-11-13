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
}