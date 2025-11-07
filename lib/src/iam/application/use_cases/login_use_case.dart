import '../../domain/entities/auth_credentials.dart';
import '../../domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _repository;


  LoginUseCase(this._repository);


  Future<AuthCredentials> call(String email, String password) async {

    return _repository.login(email, password);
  }
}