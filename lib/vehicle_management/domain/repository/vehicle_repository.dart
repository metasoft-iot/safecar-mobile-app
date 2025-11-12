import 'package:safecar_mobile_app/vehicle_management/domain/model/vehicle_model.dart';


abstract class VehicleRepository {
  Future<List<VehicleModel>> getAll();
  Future<VehicleModel?> getById(String id);
  Future<void> add(VehicleModel vehicle);
  Future<void> update(VehicleModel vehicle);
  Future<void> delete(String id);


  Future<void> setPrimary(String id);
}
