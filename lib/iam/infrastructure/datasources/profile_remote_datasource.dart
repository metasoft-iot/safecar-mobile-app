import 'package:dio/dio.dart';

import '../models/create_profile_request_model.dart';
import '../models/profile_response_model.dart';

class ProfileRemoteDataSource {
  final Dio _dio;

  ProfileRemoteDataSource(this._dio);

  Future<ProfileResponseModel> createProfile({
    required String userEmail,
    required CreateProfileRequestModel profileData,
    required String bearerToken,
  }) async {
    try {
      final response = await _dio.post(
        '/api/v1/person-profiles',
        queryParameters: {
          'userEmail': userEmail,
        },
        data: profileData.toJson(),
        options: Options(
          headers: {
            'Authorization': 'Bearer $bearerToken',
          },
        ),
      );

      return ProfileResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      print('Error en createProfile: $e');
      String message = 'Error al crear el perfil.';
      if (e.response?.data is Map &&
          (e.response!.data as Map).containsKey('message')) {
        message = e.response!.data['message'] as String;
      }
      throw Exception(message);
    }
  }
}
