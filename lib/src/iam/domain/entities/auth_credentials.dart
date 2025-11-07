import 'user.dart';


class AuthCredentials {
  final String token; // El JWT
  final User user;     // El usuario logueado

  AuthCredentials({required this.token, required this.user});
}