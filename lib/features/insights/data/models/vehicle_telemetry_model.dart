import '../../domain/entities/vehicle_telemetry.dart';
import 'vehicle_metrics_model.dart';

class VehicleTelemetryModel extends VehicleTelemetry {
  const VehicleTelemetryModel({
    required super.driverId,
    required super.driverFullName,
    required super.vehicleId,
    required super.plateNumber,
    required super.capturedAt,
    required super.severity,
    required super.speedKmh,
    required super.location,
    required super.tirePressure,
    required super.cabinGas,
    required super.acceleration,
    super.rpm,
    super.coolantTemp,
    super.oilPressure,
    super.oilTemp,
  });

  factory VehicleTelemetryModel.fromEntity(VehicleTelemetry telemetry) {
    return VehicleTelemetryModel(
      driverId: telemetry.driverId,
      driverFullName: telemetry.driverFullName,
      vehicleId: telemetry.vehicleId,
      plateNumber: telemetry.plateNumber,
      capturedAt: telemetry.capturedAt,
      severity: telemetry.severity,
      speedKmh: telemetry.speedKmh,
      location: telemetry.location,
      tirePressure: telemetry.tirePressure,
      cabinGas: telemetry.cabinGas,
      acceleration: telemetry.acceleration,
      rpm: telemetry.rpm,
      coolantTemp: telemetry.coolantTemp,
      oilPressure: telemetry.oilPressure,
      oilTemp: telemetry.oilTemp,
    );
  }

  Map<String, dynamic> toJson() {
    final metricsModel = VehicleMetricsModel(
      rpm: rpm,
      coolantTemp: coolantTemp,
      oilPressure: oilPressure,
      oilTemp: oilTemp,
      speedKmh: speedKmh,
      tirePressure: tirePressure,
      cabinGas: cabinGas,
      acceleration: acceleration,
    );

    final payload = <String, dynamic>{
      'driverId': driverId,
      'driverFullName': driverFullName,
      'vehicleId': vehicleId,
      'plateNumber': plateNumber,
      'capturedAt': capturedAt.toIso8601String(),
      'severity': severity,
      'speedKmh': speedKmh,
      'location': VehicleLocationModel(
        latitude: location.latitude,
        longitude: location.longitude,
      ).toJson(),
    };

    payload.addAll(metricsModel.toJson());
    return payload;
  }
}
