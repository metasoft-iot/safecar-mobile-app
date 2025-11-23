/// Vehicle entity for the vehicles domain.
/// Represents a vehicle in the system with its core attributes.
class Vehicle {
  final int id;
  final String licensePlate;
  final String brand;
  final String model;
  final int? year;
  final String? vin;
  final int driverId;

  Vehicle({
    required this.id,
    required this.licensePlate,
    required this.brand,
    required this.model,
    this.year,
    this.vin,
    required this.driverId,
  });

  /// Get a display name for the vehicle
  String get displayName => year != null ? '$brand $model ($year)' : '$brand $model';

  /// Get a full display name with license plate
  String get fullDisplayName => '$brand $model ($licensePlate)';

  /// Create a copy of this vehicle with optional updated fields
  Vehicle copyWith({
    int? id,
    String? licensePlate,
    String? brand,
    String? model,
    int? year,
    String? vin,
    int? driverId,
  }) {
    return Vehicle(
      id: id ?? this.id,
      licensePlate: licensePlate ?? this.licensePlate,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      year: year ?? this.year,
      vin: vin ?? this.vin,
      driverId: driverId ?? this.driverId,
    );
  }
}

