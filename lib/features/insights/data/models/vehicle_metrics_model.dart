import '../../domain/entities/vehicle_metrics.dart';

class VehicleMetricsModel extends VehicleMetrics {
  const VehicleMetricsModel({
    super.rpm,
    super.coolantTemp,
    super.oilPressure,
    super.oilTemp,
    super.speedKmh,
    super.tirePressure,
    super.cabinGas,
    super.acceleration,
  });

  factory VehicleMetricsModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const VehicleMetricsModel();
    }

    return VehicleMetricsModel(
      rpm: _toDouble(json['rpm']),
      coolantTemp: _toDouble(json['coolantTemp']),
      oilPressure: _toDouble(json['oilPressure']),
      oilTemp: _toDouble(json['oilTemp']),
      speedKmh: _toDouble(json['speedKmh']),
      tirePressure: TirePressureModel.fromJson(json['tirePressure'] as Map<String, dynamic>?),
      cabinGas: CabinGasModel.fromJson(json['cabinGas'] as Map<String, dynamic>?),
      acceleration: AccelerationModel.fromJson(json['acceleration'] as Map<String, dynamic>?),
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'rpm': rpm,
      'coolantTemp': coolantTemp,
      'oilPressure': oilPressure,
      'oilTemp': oilTemp,
      'speedKmh': speedKmh,
      'tirePressure': (tirePressure as TirePressureModel?)?.toJson() ?? _tirePressureToJson(tirePressure),
      'cabinGas': (cabinGas as CabinGasModel?)?.toJson() ?? _cabinGasToJson(cabinGas),
      'acceleration': (acceleration as AccelerationModel?)?.toJson() ?? _accelerationToJson(acceleration),
    };

    data.removeWhere((key, value) => value == null);
    return data;
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    return (value is int) ? value.toDouble() : value as double?;
  }

  Map<String, dynamic>? _tirePressureToJson(TirePressure? pressure) {
    if (pressure == null) return null;
    return TirePressureModel(
      frontLeft: pressure.frontLeft,
      frontRight: pressure.frontRight,
      rearLeft: pressure.rearLeft,
      rearRight: pressure.rearRight,
    ).toJson();
  }

  Map<String, dynamic>? _cabinGasToJson(CabinGas? gas) {
    if (gas == null) return null;
    return CabinGasModel(type: gas.type, ppm: gas.ppm).toJson();
  }

  Map<String, dynamic>? _accelerationToJson(Acceleration? acceleration) {
    if (acceleration == null) return null;
    return AccelerationModel(
      lateralG: acceleration.lateralG,
      longitudinalG: acceleration.longitudinalG,
      verticalG: acceleration.verticalG,
    ).toJson();
  }
}

class TirePressureModel extends TirePressure {
  const TirePressureModel({super.frontLeft, super.frontRight, super.rearLeft, super.rearRight});

  factory TirePressureModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const TirePressureModel();
    }

    return TirePressureModel(
      frontLeft: VehicleMetricsModel._toDouble(json['frontLeft']),
      frontRight: VehicleMetricsModel._toDouble(json['frontRight']),
      rearLeft: VehicleMetricsModel._toDouble(json['rearLeft']),
      rearRight: VehicleMetricsModel._toDouble(json['rearRight']),
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'frontLeft': frontLeft,
      'frontRight': frontRight,
      'rearLeft': rearLeft,
      'rearRight': rearRight,
    };
    data.removeWhere((key, value) => value == null);
    return data;
  }
}

class CabinGasModel extends CabinGas {
  const CabinGasModel({super.type, super.ppm});

  factory CabinGasModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const CabinGasModel();
    }

    return CabinGasModel(
      type: json['type'] as String?,
      ppm: VehicleMetricsModel._toDouble(json['ppm']),
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'type': type,
      'ppm': ppm,
    };
    data.removeWhere((key, value) => value == null);
    return data;
  }
}

class AccelerationModel extends Acceleration {
  const AccelerationModel({super.lateralG, super.longitudinalG, super.verticalG});

  factory AccelerationModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const AccelerationModel();
    }

    return AccelerationModel(
      lateralG: VehicleMetricsModel._toDouble(json['lateralG']),
      longitudinalG: VehicleMetricsModel._toDouble(json['longitudinalG']),
      verticalG: VehicleMetricsModel._toDouble(json['verticalG']),
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'lateralG': lateralG,
      'longitudinalG': longitudinalG,
      'verticalG': verticalG,
    };
    data.removeWhere((key, value) => value == null);
    return data;
  }
}

class VehicleLocationModel extends VehicleLocation {
  const VehicleLocationModel({required super.latitude, required super.longitude});

  factory VehicleLocationModel.fromJson(Map<String, dynamic> json) {
    return VehicleLocationModel(
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
