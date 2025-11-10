class VehicleMetrics {
  const VehicleMetrics({
    this.rpm,
    this.coolantTemp,
    this.oilPressure,
    this.oilTemp,
    this.speedKmh,
    this.tirePressure,
    this.cabinGas,
    this.acceleration,
  });

  final double? rpm;
  final double? coolantTemp;
  final double? oilPressure;
  final double? oilTemp;
  final double? speedKmh;
  final TirePressure? tirePressure;
  final CabinGas? cabinGas;
  final Acceleration? acceleration;

  VehicleMetrics copyWith({
    double? rpm,
    double? coolantTemp,
    double? oilPressure,
    double? oilTemp,
    double? speedKmh,
    TirePressure? tirePressure,
    CabinGas? cabinGas,
    Acceleration? acceleration,
  }) {
    return VehicleMetrics(
      rpm: rpm ?? this.rpm,
      coolantTemp: coolantTemp ?? this.coolantTemp,
      oilPressure: oilPressure ?? this.oilPressure,
      oilTemp: oilTemp ?? this.oilTemp,
      speedKmh: speedKmh ?? this.speedKmh,
      tirePressure: tirePressure ?? this.tirePressure,
      cabinGas: cabinGas ?? this.cabinGas,
      acceleration: acceleration ?? this.acceleration,
    );
  }
}

class TirePressure {
  const TirePressure({
    this.frontLeft,
    this.frontRight,
    this.rearLeft,
    this.rearRight,
  });

  final double? frontLeft;
  final double? frontRight;
  final double? rearLeft;
  final double? rearRight;
}

class CabinGas {
  const CabinGas({this.type, this.ppm});

  final String? type;
  final double? ppm;
}

class Acceleration {
  const Acceleration({this.lateralG, this.longitudinalG, this.verticalG});

  final double? lateralG;
  final double? longitudinalG;
  final double? verticalG;
}

class VehicleLocation {
  const VehicleLocation({required this.latitude, required this.longitude});

  final double latitude;
  final double longitude;
}
