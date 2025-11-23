import 'package:equatable/equatable.dart';

/// Base class for all authentication events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Event to initialize authentication state from stored token
class AuthInitializeRequested extends AuthEvent {
  const AuthInitializeRequested();
}

/// Event to sign in with email and password
class AuthSignInRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthSignInRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

/// Event to sign up as a new driver
class AuthSignUpRequested extends AuthEvent {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String phoneNumber;

  const AuthSignUpRequested({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
  });

  @override
  List<Object?> get props => [email, password, firstName, lastName, phoneNumber];
}

/// Event to sign out
class AuthSignOutRequested extends AuthEvent {
  const AuthSignOutRequested();
}

/// Event to clear error message
class AuthErrorCleared extends AuthEvent {
  const AuthErrorCleared();
}

