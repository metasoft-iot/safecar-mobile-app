
import '../../application/services/session_service.dart';
import '../../domain/entities/auth_credentials.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/login_request_model.dart';
import '../models/register_request_model.dart';

class AuthRepositoryImpl implements AuthRepository {

  final AuthRemoteDataSource remoteDataSource;
  final SessionService sessionService;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.sessionService,
  });

  @override
  Future<AuthCredentials> login(String email, String password) async {
    final requestModel = LoginRequestModel(email: email, password: password);

    final responseModel = await remoteDataSource.login(requestModel);

    final userEntity = User(
      id: responseModel.id,
      username: responseModel.username,
      email: email,
      roles: [],
    );

    final credentialsEntity = AuthCredentials(
      token: responseModel.token,
      user: userEntity,
    );

    await sessionService.saveToken(credentialsEntity.token);

    return credentialsEntity;
  }

  @override
  Future<User> register({
    required String email,
    required String password,
    required String confirmPassword,
    required List<String> roles,
  }) async {
    final requestModel = RegisterRequestModel(
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      roles: roles,
    );

    final responseModel = await remoteDataSource.register(requestModel);

    final userEntity = User(
      id: responseModel.id,
      email: responseModel.email,
      username: '',
      roles: responseModel.roles,
    );

    return userEntity;
  }

  @override
  Future<void> logout() async {
    await sessionService.deleteToken();
  }
}