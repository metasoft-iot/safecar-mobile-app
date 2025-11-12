import 'package:safecar_mobile_app/insights/domain/models/vehicle_insight.dart';

class VehicleInsightMapper {
  const VehicleInsightMapper._();

  static VehicleInsight fromJson(Map<String, dynamic> json) {
    final severity = _mapSeverity(json['severity'] as String?);
    final generatedAtString = json['generatedAt'] as String?;

    return VehicleInsight(
      insightId: json['insightId'] as int? ?? 0,
      vehicleId: json['vehicleId'] as int? ?? json['id'] as int? ?? 0,
      driverId: json['driverId'] as int? ?? 0,
      driverFullName: json['driverFullName'] as String? ?? 'Unknown driver',
      plateNumber: json['plateNumber'] as String? ?? 'N/A',
      severity: severity,
      riskLevel: json['riskLevel'] as String? ?? 'Desconocido',
      maintenanceSummary: json['maintenanceSummary'] as String? ?? '',
      maintenanceWindow: json['maintenanceWindow'] as String? ?? '',
      drivingSummary: json['drivingSummary'] as String? ?? '',
      drivingScore: json['drivingScore'] as int? ?? 0,
      drivingAlerts: json['drivingAlerts'] as String? ?? '',
      generatedAt: generatedAtString != null ? DateTime.parse(generatedAtString) : DateTime.now(),
      snapshot: _snapshotFromJson(json),
      recommendations: _recommendationsFromJson(json['recommendations']),
    );
  }

  static VehicleSnapshot _snapshotFromJson(Map<String, dynamic> json) {
    final locationJson = json['location'] as Map<String, dynamic>? ?? {};
    final pressureJson = json['tirePressure'] as Map<String, dynamic>? ?? {};
    final gasJson = json['cabinGas'] as Map<String, dynamic>? ?? {};
    final accelJson = json['acceleration'] as Map<String, dynamic>? ?? {};

    return VehicleSnapshot(
      speedKmh: _toDouble(json['speedKmh']) ?? 0,
      location: VehicleLocation(
        latitude: _toDouble(locationJson['latitude']) ?? 0,
        longitude: _toDouble(locationJson['longitude']) ?? 0,
      ),
      tirePressure: TirePressure(
        frontLeft: _toDouble(pressureJson['frontLeft']) ?? 0,
        frontRight: _toDouble(pressureJson['frontRight']) ?? 0,
        rearLeft: _toDouble(pressureJson['rearLeft']) ?? 0,
        rearRight: _toDouble(pressureJson['rearRight']) ?? 0,
      ),
      cabinGas: CabinGas(
        type: gasJson['type'] as String? ?? 'CO2',
        ppm: _toDouble(gasJson['ppm']) ?? 0,
      ),
      acceleration: VehicleAcceleration(
        lateralG: _toDouble(accelJson['lateralG']) ?? 0,
        longitudinalG: _toDouble(accelJson['longitudinalG']) ?? 0,
        verticalG: _toDouble(accelJson['verticalG']) ?? 0,
      ),
    );
  }

  static List<VehicleRecommendation> _recommendationsFromJson(dynamic value) {
    if (value is List) {
      return value
          .whereType<Map<String, dynamic>>()
          .map(
            (item) => VehicleRecommendation(
              title: item['title'] as String? ?? 'Recomendación',
              detail: item['detail'] as String? ?? '',
            ),
          )
          .toList();
    }
    return const [];
  }

  static InsightSeverity _mapSeverity(String? value) {
    switch (value?.toUpperCase()) {
      case 'WARN':
      case 'WARNING':
        return InsightSeverity.warn;
      case 'ALERT':
      case 'CRITICAL':
        return InsightSeverity.alert;
      default:
        return InsightSeverity.nominal;
    }
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }
}
