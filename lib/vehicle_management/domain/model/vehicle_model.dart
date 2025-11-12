enum FuelType { gas, diesel, hybrid, electric }

class VehicleModel {
  final String id;
  final String make;
  final String model;
  final int year;
  final String color;
  final String licensePlate;
  final String? vin;
  final double mileage;
  final FuelType fuelType;
  final String? nickname;
  final bool isPrimary;
  final String imageUrl;

  const VehicleModel({
    required this.id,
    required this.make,
    required this.model,
    required this.year,
    required this.color,
    required this.licensePlate,
    this.vin,
    required this.mileage,
    required this.fuelType,
    this.nickname,
    this.isPrimary = false,
    required this.imageUrl,
  });
}
