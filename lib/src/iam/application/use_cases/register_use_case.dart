
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository _repository;

  RegisterUseCase(this._repository);

  Future<User> call({
    required String email,
    required String password,
    required String confirmPassword,
    required List<String> roles,
  }) async {
    return _repository.register(
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      roles: roles,
    );
  }
}