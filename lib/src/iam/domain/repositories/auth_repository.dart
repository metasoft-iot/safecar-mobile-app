import '../entities/auth_credentials.dart';
import '../../domain/entities/user.dart';



abstract class AuthRepository {

  Future<AuthCredentials> login(String email, String password);

  Future<User> register({
    required String email,
    required String password,
    required String confirmPassword,
    required List<String> roles,
  });

  Future<void> logout();

}