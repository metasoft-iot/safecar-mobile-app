/// SafeCar Mobile App - Vehicle Insight Domain Models
/// Defines core entities used across the Insights bounded context
library;

enum InsightSeverity { nominal, warn, alert }

/// Recommendation shown to the driver/owner
class VehicleRecommendation {
  final String title;
  final String detail;

  const VehicleRecommendation({
    required this.title,
    required this.detail,
  });
}

/// Snapshot with live metrics that feed the UI cards
class VehicleSnapshot {
  final double speedKmh;
  final VehicleLocation location;
  final TirePressure tirePressure;
  final CabinGas cabinGas;
  final VehicleAcceleration acceleration;

  const VehicleSnapshot({
    required this.speedKmh,
    required this.location,
    required this.tirePressure,
    required this.cabinGas,
    required this.acceleration,
  });

  VehicleSnapshot copyWith({
    double? speedKmh,
    VehicleLocation? location,
    TirePressure? tirePressure,
    CabinGas? cabinGas,
    VehicleAcceleration? acceleration,
  }) {
    return VehicleSnapshot(
      speedKmh: speedKmh ?? this.speedKmh,
      location: location ?? this.location,
      tirePressure: tirePressure ?? this.tirePressure,
      cabinGas: cabinGas ?? this.cabinGas,
      acceleration: acceleration ?? this.acceleration,
    );
  }
}

class VehicleLocation {
  final double latitude;
  final double longitude;

  const VehicleLocation({
    required this.latitude,
    required this.longitude,
  });
}

class TirePressure {
  final double frontLeft;
  final double frontRight;
  final double rearLeft;
  final double rearRight;

  const TirePressure({
    required this.frontLeft,
    required this.frontRight,
    required this.rearLeft,
    required this.rearRight,
  });
}

class CabinGas {
  final String type;
  final double ppm;

  const CabinGas({required this.type, required this.ppm});
}

class VehicleAcceleration {
  final double lateralG;
  final double longitudinalG;
  final double verticalG;

  const VehicleAcceleration({
    required this.lateralG,
    required this.longitudinalG,
    required this.verticalG,
  });
}

class VehicleInsight {
  final int insightId;
  final int vehicleId;
  final int driverId;
  final String driverFullName;
  final String plateNumber;
  final InsightSeverity severity;
  final String riskLevel;
  final String maintenanceSummary;
  final String maintenanceWindow;
  final String drivingSummary;
  final int drivingScore;
  final String drivingAlerts;
  final DateTime generatedAt;
  final VehicleSnapshot snapshot;
  final List<VehicleRecommendation> recommendations;

  const VehicleInsight({
    required this.insightId,
    required this.vehicleId,
    required this.driverId,
    required this.driverFullName,
    required this.plateNumber,
    required this.severity,
    required this.riskLevel,
    required this.maintenanceSummary,
    required this.maintenanceWindow,
    required this.drivingSummary,
    required this.drivingScore,
    required this.drivingAlerts,
    required this.generatedAt,
    required this.snapshot,
    required this.recommendations,
  });

  bool get isCritical => severity == InsightSeverity.alert;

  bool get isWarning => severity == InsightSeverity.warn;

  bool get isNominal => severity == InsightSeverity.nominal;
}
