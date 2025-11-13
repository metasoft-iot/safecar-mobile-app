
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository _repository;

  RegisterUseCase(this._repository);

  // --- ACTUALIZADO ---
  Future<User> call({
    required String email,
    required String password,
    required String confirmPassword,
    required List<String> roles,
    required String fullName,
    required String city,
    required String country,
    required String phone,
    required String dni,
  }) async {
    return _repository.register(
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      roles: roles,
      fullName: fullName,
      city: city,
      country: country,
      phone: phone,
      dni: dni,
    );
  }
}