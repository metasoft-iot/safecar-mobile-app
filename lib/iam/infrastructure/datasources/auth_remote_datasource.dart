import 'package:dio/dio.dart';

import '../models/login_request_model.dart';
import '../models/login_response_model.dart';
import '../models/register_request_model.dart';
import '../models/register_response_model.dart';
// Asegúrate de que las rutas de importación de tus modelos sean correctas

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