import 'dart:convert';
import '../../../core/infrastructure/api_service.dart';
import '../../../core/constants/api_constants.dart';
import '../resources/workshops_response.dart';

/// API service for workshop operations.
class WorkshopsApi {
  final ApiService _apiService;

  WorkshopsApi(this._apiService);

  /// Get all workshops
  Future<WorkshopsResponse> getWorkshops() async {
    print('[WorkshopsApi] 🏪 Fetching workshops');
    
    final response = await _apiService.get(ApiConstants.workshops);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      print('[WorkshopsApi] 🏪 Found ${data.length} workshops');
      return WorkshopsResponse.fromJson(data);
    } else {
      throw Exception('Failed to load workshops: ${response.statusCode}');
    }
  }

  /// Get a single workshop by ID
  Future<WorkshopResource> getWorkshopById(int workshopId) async {
    print('[WorkshopsApi] 🏪 Fetching workshop ID: $workshopId');
    
    final response = await _apiService.get(
      ApiConstants.workshopById(workshopId),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return WorkshopResource.fromJson(data);
    } else {
      throw Exception('Failed to load workshop: ${response.statusCode}');
    }
  }
}

