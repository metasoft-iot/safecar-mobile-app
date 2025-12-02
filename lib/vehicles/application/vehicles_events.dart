import 'package:equatable/equatable.dart';

/// Base class for all vehicle events
abstract class VehiclesEvent extends Equatable {
  const VehiclesEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load vehicles for the current driver
class LoadVehicles extends VehiclesEvent {
  const LoadVehicles();
}

/// Event to create a new vehicle
class CreateVehicle extends VehiclesEvent {
  final String licensePlate;
  final String brand;
  final String model;
  final int? year;
  final String? vin;
  final String? color;
  final int? mileage;

  const CreateVehicle({
    required this.licensePlate,
    required this.brand,
    required this.model,
    this.year,
    this.vin,
    this.color,
    this.mileage,
  });

  @override
  List<Object?> get props => [licensePlate, brand, model, year, vin, color, mileage];
}

/// Event to load insights for a vehicle
class LoadInsights extends VehiclesEvent {
  final int vehicleId;

  const LoadInsights({required this.vehicleId});

  @override
  List<Object?> get props => [vehicleId];
}

/// Event to generate insights for a vehicle
class GenerateInsights extends VehiclesEvent {
  final int vehicleId;

  const GenerateInsights({required this.vehicleId});

  @override
  List<Object?> get props => [vehicleId];
}

/// Event to load telemetry for a vehicle
class LoadTelemetry extends VehiclesEvent {
  final int vehicleId;
  final int limit;

  const LoadTelemetry({required this.vehicleId, this.limit = 5});

  @override
  List<Object?> get props => [vehicleId, limit];
}

/// Event to refresh vehicles list
class RefreshVehicles extends VehiclesEvent {
  const RefreshVehicles();
}

