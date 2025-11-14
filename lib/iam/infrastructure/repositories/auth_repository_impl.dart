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
    final req = LoginRequestModel(email: email, password: password);
    final res = await authRemoteDataSource.login(req);

    final user = User(
      id: res.id,
      email: email,
      username: res.username,
      roles: const [], // si luego quieres roles, se pueden mapear aquí
    );

    final credentials = AuthCredentials(
      token: res.token,
      user: user,
    );

    await sessionService.saveToken(credentials.token);

    return credentials;
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
    // 1) Sign-up
    final regReq = RegisterRequestModel(
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      roles: roles,
    );
    final regRes = await authRemoteDataSource.register(regReq);

    // 2) Sign-in para obtener token
    final loginReq = LoginRequestModel(email: email, password: password);
    final loginRes = await authRemoteDataSource.login(loginReq);

    final user = User(
      id: loginRes.id,
      email: email,
      username: loginRes.username,
      roles: regRes.roles,
    );

    final credentials = AuthCredentials(
      token: loginRes.token,
      user: user,
    );

    // 3) Guardar token en sesión
    await sessionService.saveToken(credentials.token);

    // 4) Crear perfil usando el token
    final profileReq = CreateProfileRequestModel(
      fullName: fullName,
      city: city,
      country: country,
      phone: phone,
      dni: dni,
    );

    await profileRemoteDataSource.createProfile(
      userEmail: email,
      profileData: profileReq,
      bearerToken: credentials.token,
    );

    return user;
  }

  @override
  Future<void> logout() async {
    await sessionService.deleteToken();
  }
}
