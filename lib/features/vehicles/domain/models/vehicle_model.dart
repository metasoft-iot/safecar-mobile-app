/// Vehicle model representing a driver's vehicle
class VehicleModel {
  final int id;
  final String licensePlate;
  final String brand;
  final String model;
  final int year;
  final String? vin;
  final int driverId;

  VehicleModel({
    required this.id,
    required this.licensePlate,
    required this.brand,
    required this.model,
    required this.year,
    this.vin,
    required this.driverId,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: json['id'] as int,
      licensePlate: json['licensePlate'] as String,
      brand: json['brand'] as String,
      model: json['model'] as String,
      year: json['year'] as int,
      vin: json['vin'] as String?,
      driverId: json['driverId'] as int,
    );
  }

  String get displayName => '$brand $model ($year)';
}

