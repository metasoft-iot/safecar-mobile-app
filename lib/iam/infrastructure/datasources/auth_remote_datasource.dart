import 'package:dio/dio.dart';

import '../models/login_request_model.dart';
import '../models/login_response_model.dart';
import '../models/register_request_model.dart';
import '../models/register_response_model.dart';

class AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSource(this._dio);

  Future<LoginResponseModel> login(LoginRequestModel request) async {
    try {
      final response = await _dio.post(
        '/api/v1/authentication/sign-in',
        data: request.toJson(),
      );
      return LoginResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      String message = 'Error en el inicio de sesión.';
      if (e.response?.statusCode == 401) {
        message = 'Credenciales incorrectas.';
      } else if (e.response?.data is Map &&
          (e.response!.data as Map).containsKey('message')) {
        message = e.response!.data['message'] as String;
      }
      print('Error en login: $e');
      throw Exception(message);
    }
  }

  Future<RegisterResponseModel> register(RegisterRequestModel request) async {
    try {
      final response = await _dio.post(
        '/api/v1/authentication/sign-up',
        data: request.toJson(),
      );
      return RegisterResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      String message = 'Error en el registro.';
      if (e.response?.data is Map &&
          (e.response!.data as Map).containsKey('message')) {
        message = e.response!.data['message'] as String;
      }
      print('Error en registro: $e');
      throw Exception(message);
    }
  }
}
