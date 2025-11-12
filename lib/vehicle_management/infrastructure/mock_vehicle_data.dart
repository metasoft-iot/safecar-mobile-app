import '../domain/model/vehicle_model.dart';

class MockVehicleData {
  static final List<VehicleModel> vehicles = [
    VehicleModel(
      id: 'VH-001',
      make: 'Toyota',
      model: 'Camry',
      year: 2021,
      color: 'Silver',
      licensePlate: 'ABC-123',
      mileage: 35000,
      fuelType: FuelType.gas,
      isPrimary: true,
      imageUrl: 'https://www.shutterstock.com/image-photo/silver-car-standing-parking-lot-600nw-2462850863.jpg',
    ),
    VehicleModel(
      id: 'VH-002',
      make: 'Ford',
      model: 'Explorer',
      year: 2020,
      color: 'Gray',
      licensePlate: 'XYZ-789',
      mileage: 48000,
      fuelType: FuelType.gas,
      imageUrl: 'https://images.pexels.com/photos/29036735/pexels-photo-29036735/free-photo-of-todoterreno-rojo-en-un-entorno-natural-espectacular-en-sivas.jpeg',
    ),
  ];

  static VehicleModel? getById(String id) =>
      vehicles.firstWhere((v) => v.id == id, orElse: () => vehicles.first);

  static void delete(String id) {
    vehicles.removeWhere((v) => v.id == id);
  }

  static void add(VehicleModel vehicle) => vehicles.add(vehicle);
}
