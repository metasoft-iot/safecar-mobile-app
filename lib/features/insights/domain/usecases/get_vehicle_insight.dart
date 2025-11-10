import '../entities/vehicle_insight.dart';
import '../repositories/vehicle_insight_repository.dart';

class GetVehicleInsightUseCase {
  const GetVehicleInsightUseCase(this._repository);

  final VehicleInsightRepository _repository;

  Future<VehicleInsight> call(int vehicleId) {
    return _repository.fetchLatestInsight(vehicleId: vehicleId);
  }
}
