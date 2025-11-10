import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/auth/token_provider.dart';
import '../../../../core/config/app_environment.dart';
import '../../../../core/error/exceptions.dart';
import '../models/vehicle_insight_model.dart';
import '../models/vehicle_telemetry_model.dart';

class VehicleInsightRemoteDataSource {
  VehicleInsightRemoteDataSource({
    required http.Client client,
    required AuthTokenProvider tokenProvider,
    String? baseUrl,
  })  : _client = client,
        _tokenProvider = tokenProvider,
        _baseUrl = baseUrl ?? AppEnvironment.baseUrl;

  final http.Client _client;
  final AuthTokenProvider _tokenProvider;
  final String _baseUrl;

  static const String _vehiclePath = '${AppEnvironment.insightsPath}/vehicle';

  Future<VehicleInsightModel> fetchLatestInsight(int vehicleId) async {
    final token = await _token();
    final uri = Uri.parse('$_baseUrl$_vehiclePath/$vehicleId');
    final response = await _client.get(uri, headers: _headers(token));
    return _mapResponse(response);
  }

  Future<VehicleInsightModel> analyzeVehicleTelemetry(
    VehicleTelemetryModel telemetry,
  ) async {
    final token = await _token();
    final uri = Uri.parse('$_baseUrl$_vehiclePath');
    final response = await _client.post(
      uri,
      headers: _headers(token),
      body: jsonEncode(telemetry.toJson()),
    );
    return _mapResponse(response);
  }

  Future<String> _token() async {
    final token = await _tokenProvider.getToken();
    if (token == null || token.isEmpty) {
      throw const MissingTokenException();
    }
    return token;
  }

  VehicleInsightModel _mapResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final jsonMap = jsonDecode(response.body) as Map<String, dynamic>;
      return VehicleInsightModel.fromJson(jsonMap);
    }

    throw ApiException(
      'Request failed with status ${response.statusCode}',
      statusCode: response.statusCode,
    );
  }

  Map<String, String> _headers(String token) {
    return {
      'accept': 'application/json',
      'content-type': 'application/json',
      'authorization': 'Bearer $token',
    };
  }
}
