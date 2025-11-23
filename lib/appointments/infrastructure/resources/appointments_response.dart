import '../../../core/infrastructure/base_response.dart';

/// Resource interface for appointment data.
class AppointmentResource implements BaseResource {
  final int id;
  final int workshopId;
  final int vehicleId;
  final int driverId;
  final String startAt;
  final String endAt;
  final String status;
  final String serviceType;
  final String? customServiceDescription;
  final int? mechanicId;
  final List<dynamic>? notes;

  AppointmentResource({
    required this.id,
    required this.workshopId,
    required this.vehicleId,
    required this.driverId,
    required this.startAt,
    required this.endAt,
    required this.status,
    required this.serviceType,
    this.customServiceDescription,
    this.mechanicId,
    this.notes,
  });

  factory AppointmentResource.fromJson(Map<String, dynamic> json) {
    return AppointmentResource(
      id: json['id'] as int,
      workshopId: json['workshopId'] as int,
      vehicleId: json['vehicleId'] as int,
      driverId: json['driverId'] as int,
      startAt: json['startAt'] as String,
      endAt: json['endAt'] as String,
      status: json['status'] as String,
      serviceType: json['serviceType'] as String,
      customServiceDescription: json['customServiceDescription'] as String?,
      mechanicId: json['mechanicId'] as int?,
      notes: json['notes'] as List<dynamic>?,
    );
  }
}

/// Response interface for appointments API calls.
class AppointmentsResponse implements BaseResponse {
  final List<AppointmentResource> appointments;

  AppointmentsResponse({required this.appointments});

  factory AppointmentsResponse.fromJson(List<dynamic> json) {
    return AppointmentsResponse(
      appointments: json.map((a) => AppointmentResource.fromJson(a as Map<String, dynamic>)).toList(),
    );
  }
}

