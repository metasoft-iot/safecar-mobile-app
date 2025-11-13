import 'package:safecar_mobile_app/src/iam/domain/entities/auth_credentials.dart';
import 'package:safecar_mobile_app/src/iam/domain/entities/user.dart';

abstract class AuthRepository {

  Future<AuthCredentials> login(String email, String password);

  Future<User> register({
    // Auth
    required String email,
    required String password,
    required String confirmPassword,
    required List<String> roles,
    // Profile
    required String fullName,
    required String city,
    required String country,
    required String phone,
    required String dni,
  });

  Future<void> logout();
}