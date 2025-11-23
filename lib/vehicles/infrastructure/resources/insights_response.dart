import '../../../core/infrastructure/base_response.dart';

/// Resource interface for vehicle insights data.
class VehicleInsightResource implements BaseResource {
  final int id;
  final int vehicleId;
  final int? driverId;
  final String? driverFullName;
  final String? plateNumber;
  final String riskLevel;
  final String? maintenanceSummary;
  final String? maintenanceWindow;
  final String? drivingSummary;
  final int? drivingScore;
  final String? drivingAlerts;
  final List<dynamic> recommendations;
  final String generatedAt;

  VehicleInsightResource({
    required this.id,
    required this.vehicleId,
    this.driverId,
    this.driverFullName,
    this.plateNumber,
    required this.riskLevel,
    this.maintenanceSummary,
    this.maintenanceWindow,
    this.drivingSummary,
    this.drivingScore,
    this.drivingAlerts,
    required this.recommendations,
    required this.generatedAt,
  });

  factory VehicleInsightResource.fromJson(Map<String, dynamic> json) {
    // Helper function to safely convert to int
    int? toInt(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is num) return value.toInt();
      return null;
    }
    
    return VehicleInsightResource(
      id: toInt(json['insightId'])!,
      vehicleId: toInt(json['vehicleId'])!,
      driverId: toInt(json['driverId']),
      driverFullName: json['driverFullName'] as String?,
      plateNumber: json['plateNumber'] as String?,
      riskLevel: json['riskLevel'] as String,
      maintenanceSummary: json['maintenanceSummary'] as String?,
      maintenanceWindow: json['maintenanceWindow'] as String?,
      drivingSummary: json['drivingSummary'] as String?,
      drivingScore: toInt(json['drivingScore']),
      drivingAlerts: json['drivingAlerts'] as String?,
      recommendations: json['recommendations'] as List<dynamic>? ?? [],
      generatedAt: json['generatedAt'] as String,
    );
  }
}

/// Response interface for insights API calls.
class InsightsResponse implements BaseResponse {
  final VehicleInsightResource insight;

  InsightsResponse({required this.insight});

  factory InsightsResponse.fromJson(Map<String, dynamic> json) {
    return InsightsResponse(
      insight: VehicleInsightResource.fromJson(json),
    );
  }
}

/// Resource interface for telemetry record data.
class TelemetryRecordResource implements BaseResource {
  final int id;
  final int vehicleId;
  final String ingestedAt;
  final Map<String, dynamic> sample;

  TelemetryRecordResource({
    required this.id,
    required this.vehicleId,
    required this.ingestedAt,
    required this.sample,
  });

  factory TelemetryRecordResource.fromJson(Map<String, dynamic> json) {
    // Helper function to safely convert to int
    int toInt(dynamic value) {
      if (value is int) return value;
      if (value is num) return value.toInt();
      throw FormatException('Cannot convert $value to int');
    }
    
    // Extract vehicleId from nested structure: sample.vehicleId.vehicleId
    final sample = json['sample'] as Map<String, dynamic>;
    final vehicleIdObj = sample['vehicleId'] as Map<String, dynamic>;
    final vehicleId = toInt(vehicleIdObj['vehicleId']);
    
    return TelemetryRecordResource(
      id: toInt(json['id']),
      vehicleId: vehicleId,
      ingestedAt: json['ingestedAt'] as String,
      sample: sample,
    );
  }
}

/// Response interface for telemetry API calls.
class TelemetryResponse implements BaseResponse {
  final List<TelemetryRecordResource> records;

  TelemetryResponse({required this.records});

  factory TelemetryResponse.fromJson(List<dynamic> json) {
    return TelemetryResponse(
      records: json.map((r) => TelemetryRecordResource.fromJson(r as Map<String, dynamic>)).toList(),
    );
  }
}

