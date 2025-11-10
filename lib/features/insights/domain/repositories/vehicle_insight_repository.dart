import '../entities/vehicle_insight.dart';
import '../entities/vehicle_telemetry.dart';

abstract class VehicleInsightRepository {
  Future<VehicleInsight> fetchLatestInsight({required int vehicleId});

  Future<VehicleInsight> analyzeVehicleTelemetry(VehicleTelemetry telemetry);
}
