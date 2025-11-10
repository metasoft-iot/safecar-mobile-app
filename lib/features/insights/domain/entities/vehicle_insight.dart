import 'insight_recommendation.dart';
import 'vehicle_metrics.dart';

class VehicleInsight {
  const VehicleInsight({
    required this.insightId,
    required this.vehicleId,
    required this.driverId,
    required this.driverFullName,
    required this.plateNumber,
    required this.riskLevel,
    required this.maintenanceSummary,
    required this.maintenanceWindow,
    required this.drivingSummary,
    required this.drivingScore,
    required this.drivingAlerts,
    required this.generatedAt,
    required this.recommendations,
    this.liveMetrics,
    this.location,
    this.diagnosticTroubleCodes = const [],
  });

  final int insightId;
  final int vehicleId;
  final int driverId;
  final String driverFullName;
  final String plateNumber;
  final String riskLevel;
  final String maintenanceSummary;
  final String maintenanceWindow;
  final String drivingSummary;
  final int drivingScore;
  final String drivingAlerts;
  final DateTime generatedAt;
  final List<InsightRecommendation> recommendations;
  final VehicleMetrics? liveMetrics;
  final VehicleLocation? location;
  final List<String> diagnosticTroubleCodes;
}
