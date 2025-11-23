import 'dart:convert';
import '../../../core/infrastructure/api_service.dart';
import '../../../core/constants/api_constants.dart';
import '../resources/appointments_response.dart';

/// API service for appointment operations.
class AppointmentsApi {
  final ApiService _apiService;

  AppointmentsApi(this._apiService);

  /// Get all appointments for a driver
  Future<AppointmentsResponse> getAppointmentsByDriver({
    required int workshopId,
    required int driverId,
  }) async {
    print('[AppointmentsApi] 📅 Fetching appointments for driver $driverId');
    
    final response = await _apiService.get(
      ApiConstants.appointmentsByDriver(workshopId, driverId),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      print('[AppointmentsApi] 📅 Found ${data.length} appointments');
      return AppointmentsResponse.fromJson(data);
    } else if (response.statusCode == 404) {
      print('[AppointmentsApi] 📅 No appointments found');
      return AppointmentsResponse(appointments: []);
    } else {
      throw Exception('Failed to load appointments: ${response.statusCode}');
    }
  }

  /// Create a new appointment
  Future<AppointmentResource> createAppointment({
    required int workshopId,
    required int vehicleId,
    required int driverId,
    required DateTime startAt,
    required DateTime endAt,
    required String serviceType,
    String? customServiceDescription,
    int? mechanicId,
  }) async {
    print('[AppointmentsApi] 📅 Creating appointment');
    
    // Convert DateTime to UTC DateTime (keeps the same instant in time, but in UTC timezone)
    // Then format as ISO 8601 with Z suffix (required by java.time.Instant)
    final startAtUtc = DateTime.utc(
      startAt.year,
      startAt.month,
      startAt.day,
      startAt.hour,
      startAt.minute,
      startAt.second,
      startAt.millisecond,
    );
    
    final endAtUtc = DateTime.utc(
      endAt.year,
      endAt.month,
      endAt.day,
      endAt.hour,
      endAt.minute,
      endAt.second,
      endAt.millisecond,
    );
    
    final startAtStr = startAtUtc.toIso8601String();
    final endAtStr = endAtUtc.toIso8601String();
    
    print('[AppointmentsApi] 📅 Start: $startAtStr, End: $endAtStr');
    
    final payload = {
      'workshopId': workshopId,
      'vehicleId': vehicleId,
      'driverId': driverId,
      'startAt': startAtStr,
      'endAt': endAtStr,
      'serviceType': serviceType,
      if (customServiceDescription != null) 'customServiceDescription': customServiceDescription,
      if (mechanicId != null) 'mechanicId': mechanicId,
    };

    final response = await _apiService.post(
      '/workshops/$workshopId/appointments',
      payload,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      print('[AppointmentsApi] ✅ Appointment created successfully');
      return AppointmentResource.fromJson(data);
    } else {
      throw Exception('Failed to create appointment: ${response.statusCode} - ${response.body}');
    }
  }
}

