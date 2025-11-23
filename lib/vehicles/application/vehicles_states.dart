import 'package:equatable/equatable.dart';
import '../domain/model/vehicle.entity.dart';
import '../domain/model/vehicle_insight.entity.dart';
import '../domain/model/telemetry_record.entity.dart';

/// Base class for all vehicle states
abstract class VehiclesState extends Equatable {
  const VehiclesState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class VehiclesInitial extends VehiclesState {
  const VehiclesInitial();
}

/// State when loading vehicles
class VehiclesLoading extends VehiclesState {
  const VehiclesLoading();
}

/// State when vehicles are loaded successfully
class VehiclesLoaded extends VehiclesState {
  final List<Vehicle> vehicles;

  const VehiclesLoaded({required this.vehicles});

  @override
  List<Object?> get props => [vehicles];
}

/// State when creating a vehicle
class VehicleCreating extends VehiclesState {
  final List<Vehicle> currentVehicles;

  const VehicleCreating({required this.currentVehicles});

  @override
  List<Object?> get props => [currentVehicles];
}

/// State when a vehicle is created successfully
class VehicleCreated extends VehiclesState {
  final Vehicle vehicle;
  final List<Vehicle> allVehicles;

  const VehicleCreated({required this.vehicle, required this.allVehicles});

  @override
  List<Object?> get props => [vehicle, allVehicles];
}

/// State when loading insights
class InsightsLoading extends VehiclesState {
  final List<Vehicle> vehicles;

  const InsightsLoading({required this.vehicles});

  @override
  List<Object?> get props => [vehicles];
}

/// State when insights are loaded
class InsightsLoaded extends VehiclesState {
  final List<Vehicle> vehicles;
  final VehicleInsight? insights;
  final List<TelemetryRecord> telemetry;

  const InsightsLoaded({
    required this.vehicles,
    this.insights,
    required this.telemetry,
  });

  @override
  List<Object?> get props => [vehicles, insights, telemetry];
}

/// State when generating insights
class InsightsGenerating extends VehiclesState {
  final List<Vehicle> vehicles;

  const InsightsGenerating({required this.vehicles});

  @override
  List<Object?> get props => [vehicles];
}

/// State when there's an error
class VehiclesError extends VehiclesState {
  final String message;
  final List<Vehicle>? vehicles;

  const VehiclesError({required this.message, this.vehicles});

  @override
  List<Object?> get props => [message, vehicles];
}

