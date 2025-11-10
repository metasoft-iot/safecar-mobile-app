import 'vehicle_metrics.dart';

class VehicleTelemetry {
  const VehicleTelemetry({
    required this.driverId,
    required this.driverFullName,
    required this.vehicleId,
    required this.plateNumber,
    required this.capturedAt,
    required this.severity,
    required this.speedKmh,
    required this.location,
    required this.tirePressure,
    required this.cabinGas,
    required this.acceleration,
    this.rpm,
    this.coolantTemp,
    this.oilPressure,
    this.oilTemp,
  });

  final int driverId;
  final String driverFullName;
  final int vehicleId;
  final String plateNumber;
  final DateTime capturedAt;
  final String severity;
  final double speedKmh;
  final VehicleLocation location;
  final TirePressure tirePressure;
  final CabinGas cabinGas;
  final Acceleration acceleration;
  final double? rpm;
  final double? coolantTemp;
  final double? oilPressure;
  final double? oilTemp;
}
