import 'package:safecar_mobile_app/insights/domain/models/vehicle_insight.dart';

/// Abstraction for retrieving vehicle insights from any source
abstract class VehicleInsightsRepository {
  Future<VehicleInsight> fetchVehicleInsight({
    required int vehicleId,
    bool forceRefresh = false,
  });
}
