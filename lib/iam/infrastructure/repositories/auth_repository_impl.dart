
import '../../application/services/session_service.dart';
import '../../domain/entities/auth_credentials.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../datasources/profile_remote_datasource.dart';
import '../models/create_profile_request_model.dart';
import '../models/login_request_model.dart';
import '../models/register_request_model.dart';

class AuthRepositoryImpl implements AuthRepository {

  final AuthRemoteDataSource authRemoteDataSource;
  final ProfileRemoteDataSource profileRemoteDataSource;
  final SessionService sessionService;

  AuthRepositoryImpl({
    required this.authRemoteDataSource,
    required this.profileRemoteDataSource,
    required this.sessionService,
  });

  @override
  Future<AuthCredentials> login(String email, String password) async {
    final requestModel = LoginRequestModel(email: email, password: password);
    final responseModel = await authRemoteDataSource.login(requestModel);

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
    required String fullName,
    required String city,
    required String country,
    required String phone,
    required String dni,
  }) async {

    final authRequestModel = RegisterRequestModel( // <-- Se define 'authRequestModel'
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      roles: roles,
    );

    final authResponseModel = await authRemoteDataSource.register(authRequestModel);
    final int userId = authResponseModel.id;

    final profileRequestModel = CreateProfileRequestModel(
      fullName: fullName,
      city: city,
      country: country,
      phone: phone,
      dni: dni,
    );
    await profileRemoteDataSource.createProfile(
      userEmail: email,
      profileData: profileRequestModel,
    );

    final userEntity = User(
      id: authResponseModel.id,
      email: authResponseModel.email,
      username: '',
      roles: authResponseModel.roles,
    );
    return userEntity;
  }

  @override
  Future<void> logout() async {
    await sessionService.deleteToken();
  }
}