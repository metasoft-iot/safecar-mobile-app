import '../../../core/infrastructure/base_response.dart';

/// Resource interface for vehicle data.
class VehicleResource implements BaseResource {
  final int id;
  final String licensePlate;
  final String brand;
  final String model;
  final int? year;
  final String? vin;
  final String? color;
  final int? mileage;
  final int driverId;

  VehicleResource({
    required this.id,
    required this.licensePlate,
    required this.brand,
    required this.model,
    this.year,
    this.vin,
    this.color,
    this.mileage,
    required this.driverId,
  });

  factory VehicleResource.fromJson(Map<String, dynamic> json) {
    return VehicleResource(
      id: json['id'] as int,
      licensePlate: json['licensePlate'] as String,
      brand: json['brand'] as String,
      model: json['model'] as String,
      year: json['year'] as int?,
      vin: json['vin'] as String?,
      color: json['color'] as String?,
      mileage: json['mileage'] as int?,
      driverId: json['driverId'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'licensePlate': licensePlate,
      'brand': brand,
      'model': model,
      'year': year,
      'vin': vin,
      'color': color,
      'mileage': mileage,
      'driverId': driverId,
    };
  }
}

/// Response interface for vehicles API calls.
class VehiclesResponse implements BaseResponse {
  final List<VehicleResource> vehicles;

  VehiclesResponse({required this.vehicles});

  factory VehiclesResponse.fromJson(List<dynamic> json) {
    return VehiclesResponse(
      vehicles: json.map((v) => VehicleResource.fromJson(v as Map<String, dynamic>)).toList(),
    );
  }
}

