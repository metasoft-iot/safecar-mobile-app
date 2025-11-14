import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:safecar_mobile_app/core/config/app_environment.dart';
import 'package:safecar_mobile_app/insights/infrastructure/exceptions/vehicle_insights_exception.dart';

/// Remote data source that talks to SafeCar Backend
class VehicleInsightsRemoteDataSource {
  final http.Client _client;

  VehicleInsightsRemoteDataSource({http.Client? client}) : _client = client ?? http.Client();

  Future<Map<String, dynamic>> fetchVehicleInsight(int vehicleId) async {
    final response = await _client.get(
      AppEnvironment.vehicleInsightsUri(vehicleId),
      headers: const {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }

    throw VehicleInsightsException(
      'Unable to load vehicle insights',
      statusCode: response.statusCode,
    );
  }

  Future<Map<String, dynamic>> submitVehicleSnapshot({
    required Map<String, dynamic> payload,
    String? bearerToken,
  }) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (bearerToken != null && bearerToken.isNotEmpty) {
      headers['Authorization'] = 'Bearer $bearerToken';
    }

    final response = await _client.post(
      AppEnvironment.submitVehicleSnapshotUri(),
      headers: headers,
      body: jsonEncode(payload),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }

    throw VehicleInsightsException(
      'Unable to submit vehicle snapshot',
      statusCode: response.statusCode,
    );
  }
}
