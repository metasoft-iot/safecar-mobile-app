/// Vehicle insight entity for AI-generated vehicle analysis.
/// Contains risk assessment, maintenance predictions, and recommendations.
class VehicleInsight {
  final int id;
  final int vehicleId;
  final String riskLevel;
  final MaintenancePrediction? maintenancePrediction;
  final DrivingHabits? drivingHabits;
  final List<Recommendation> recommendations;
  final DateTime generatedAt;

  VehicleInsight({
    required this.id,
    required this.vehicleId,
    required this.riskLevel,
    this.maintenancePrediction,
    this.drivingHabits,
    required this.recommendations,
    required this.generatedAt,
  });
}

/// Maintenance prediction for a vehicle
class MaintenancePrediction {
  final String summary;
  final String? maintenanceWindow;

  MaintenancePrediction({
    required this.summary,
    this.maintenanceWindow,
  });
}

/// Driving habits analysis
class DrivingHabits {
  final int score;
  final String summary;
  final List<String> alerts;

  DrivingHabits({
    required this.score,
    required this.summary,
    required this.alerts,
  });
}

/// AI-generated recommendation
class Recommendation {
  final String title;
  final String detail;

  Recommendation({
    required this.title,
    required this.detail,
  });
}

