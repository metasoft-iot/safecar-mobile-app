import '../entities/vehicle_insight.dart';
import '../entities/vehicle_telemetry.dart';
import '../repositories/vehicle_insight_repository.dart';

class AnalyzeVehicleTelemetryUseCase {
  const AnalyzeVehicleTelemetryUseCase(this._repository);

  final VehicleInsightRepository _repository;

  Future<VehicleInsight> call(VehicleTelemetry telemetry) {
    return _repository.analyzeVehicleTelemetry(telemetry);
  }
}
