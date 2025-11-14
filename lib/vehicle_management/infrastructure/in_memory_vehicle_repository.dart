import 'package:safecar_mobile_app/vehicle_management/domain/model/vehicle_model.dart';
import 'package:safecar_mobile_app/vehicle_management/domain/repository/vehicle_repository.dart';
import 'package:safecar_mobile_app/vehicle_management/infrastructure/mock_vehicle_data.dart';


class InMemoryVehicleRepository implements VehicleRepository {
  @override
  Future<List<VehicleModel>> getAll() async {
    return List<VehicleModel>.from(MockVehicleData.vehicles);
  }

  @override
  Future<VehicleModel?> getById(String id) async {
    try {
      return MockVehicleData.vehicles.firstWhere((v) => v.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> add(VehicleModel vehicle) async {
    MockVehicleData.add(vehicle);
  }

  @override
  Future<void> update(VehicleModel vehicle) async {
    final i = MockVehicleData.vehicles.indexWhere((v) => v.id == vehicle.id);
    if (i >= 0) {
      MockVehicleData.vehicles[i] = vehicle;
    }
  }

  @override
  Future<void> delete(String id) async {
    MockVehicleData.delete(id);
  }

  @override
  Future<void> setPrimary(String id) async {

    for (var i = 0; i < MockVehicleData.vehicles.length; i++) {
      final v = MockVehicleData.vehicles[i];
      MockVehicleData.vehicles[i] = VehicleModel(
        id: v.id,
        make: v.make,
        model: v.model,
        year: v.year,
        color: v.color,
        licensePlate: v.licensePlate,
        vin: v.vin,
        mileage: v.mileage,
        fuelType: v.fuelType,
        nickname: v.nickname,
        isPrimary: v.id == id,
        imageUrl: v.imageUrl,
      );
    }
  }
}


final vehicleRepository = InMemoryVehicleRepository();
