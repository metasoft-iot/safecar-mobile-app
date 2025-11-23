import '../../../core/infrastructure/base_assembler.dart';
import '../../domain/model/vehicle.entity.dart';
import '../resources/vehicles_response.dart';

/// Assembler for converting between Vehicle entities and Vehicle resources.
class VehicleAssembler implements BaseAssembler<Vehicle, VehicleResource, VehiclesResponse> {
  @override
  Vehicle toEntityFromResource(VehicleResource resource) {
    return Vehicle(
      id: resource.id,
      licensePlate: resource.licensePlate,
      brand: resource.brand,
      model: resource.model,
      year: resource.year,
      vin: resource.vin,
      driverId: resource.driverId,
    );
  }

  @override
  VehicleResource toResourceFromEntity(Vehicle entity) {
    return VehicleResource(
      id: entity.id,
      licensePlate: entity.licensePlate,
      brand: entity.brand,
      model: entity.model,
      year: entity.year,
      vin: entity.vin,
      driverId: entity.driverId,
    );
  }

  @override
  List<Vehicle> toEntitiesFromResponse(VehiclesResponse response) {
    return response.vehicles.map((resource) => toEntityFromResource(resource)).toList();
  }
}

