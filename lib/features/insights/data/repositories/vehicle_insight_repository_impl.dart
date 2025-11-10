import '../../domain/entities/vehicle_insight.dart';
import '../../domain/entities/vehicle_telemetry.dart';
import '../../domain/repositories/vehicle_insight_repository.dart';
import '../datasources/vehicle_insight_remote_data_source.dart';
import '../models/vehicle_telemetry_model.dart';

class VehicleInsightRepositoryImpl implements VehicleInsightRepository {
  VehicleInsightRepositoryImpl(this._remoteDataSource);

  final VehicleInsightRemoteDataSource _remoteDataSource;

  @override
  Future<VehicleInsight> fetchLatestInsight({required int vehicleId}) {
    return _remoteDataSource.fetchLatestInsight(vehicleId);
  }

  @override
  Future<VehicleInsight> analyzeVehicleTelemetry(VehicleTelemetry telemetry) {
    final model = VehicleTelemetryModel.fromEntity(telemetry);
    return _remoteDataSource.analyzeVehicleTelemetry(model);
  }
}
