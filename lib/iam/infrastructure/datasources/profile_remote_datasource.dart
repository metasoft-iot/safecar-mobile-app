import 'package:dio/dio.dart';
import '../models/create_profile_request_model.dart';
import '../models/profile_response_model.dart';

class ProfileRemoteDataSource {
  final Dio _dio;

  ProfileRemoteDataSource(this._dio);

  /// Crea un nuevo perfil para un usuario existente
  Future<ProfileResponseModel> createProfile({
    required String userEmail, // Ahora pide el email
    required CreateProfileRequestModel profileData,
  }) async {
    try {
      final response = await _dio.post(
        '/api/v1/person-profiles', // Nuevo endpoint
        queryParameters: {
          'userEmail': userEmail, // Nuevo query parameter
        },
        data: profileData.toJson(),
      );

      return ProfileResponseModel.fromJson(response.data);

    } on DioException catch (e) {
      print("Error en createProfile: $e");
      String errorMessage = 'Error al crear el perfil.';
      if (e.response?.data != null) {
        errorMessage = e.response?.data['message'] ?? errorMessage;
      }
      throw Exception(errorMessage);
    }
  }
}