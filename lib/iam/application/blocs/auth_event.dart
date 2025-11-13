import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object> get props => [];
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;
  const LoginRequested({required this.email, required this.password});
  @override
  List<Object> get props => [email, password];
}

// --- ACTUALIZADO ---
class RegisterRequested extends AuthEvent {
  // Auth
  final String email;
  final String password;
  final String confirmPassword;
  final String role;
  // Profile
  final String fullName;
  final String city;
  final String country;
  final String phone;
  final String dni;

  const RegisterRequested({
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.role,
    required this.fullName,
    required this.city,
    required this.country,
    required this.phone,
    required this.dni,
  });

  @override
  List<Object> get props => [
    email, password, confirmPassword, role,
    fullName, city, country, phone, dni
  ];
}

class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}