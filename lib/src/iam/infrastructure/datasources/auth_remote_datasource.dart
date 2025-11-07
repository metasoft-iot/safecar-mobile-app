import 'package:dio/dio.dart';
// Asegúrate de que las rutas de importación de tus modelos sean correctas
import 'package:safecar_mobile_app/src/iam/infrastructure/models/login_request_model.dart';
import 'package:safecar_mobile_app/src/iam/infrastructure/models/login_response_model.dart';
import 'package:safecar_mobile_app/src/iam/infrastructure/models/register_request_model.dart';
import 'package:safecar_mobile_app/src/iam/infrastructure/models/register_response_model.dart';

class AuthRemoteDataSource {


  final Dio _dio;


  AuthRemoteDataSource(this._dio);

  Future<LoginResponseModel> login(LoginRequestModel requestModel) async {
    try {
      final response = await _dio.post(
        '/api/v1/authentication/sign-in', // Tu endpoint de login
        data: requestModel.toJson(),      // El DTO se convierte a JSON
      );


      return LoginResponseModel.fromJson(response.data);

    } on DioException catch (e) {
      String errorMessage = 'Error en el inicio de sesión. Intente de nuevo.';
      if (e.response?.statusCode == 401) {
        errorMessage = 'Credenciales incorrectas.';
      } else if (e.response?.data != null) {
        errorMessage = e.response?.data['message'] ?? errorMessage;
      }
      print("Error en login: $e");
      throw Exception(errorMessage);
    }
  }

  Future<RegisterResponseModel> register(RegisterRequestModel requestModel) async {
    try {
      final response = await _dio.post(
        '/api/v1/authentication/sign-up',
        data: requestModel.toJson(),
      );

      return RegisterResponseModel.fromJson(response.data);

    } on DioException catch (e) {
      String errorMessage = 'Error en el registro. Intente de nuevo.';
      if (e.response?.data != null) {
        errorMessage = e.response?.data['message'] ?? errorMessage;
      }
      print("Error en registro: $e");
      throw Exception(errorMessage);
    }
  }
}