import 'package:safecar_mobile_app/insights/domain/models/vehicle_insight.dart';
import 'package:safecar_mobile_app/insights/domain/repositories/vehicle_insights_repository.dart';
import 'package:safecar_mobile_app/insights/infrastructure/datasources/vehicle_insights_remote_data_source.dart';
import 'package:safecar_mobile_app/insights/infrastructure/mappers/vehicle_insight_mapper.dart';

class VehicleInsightsRepositoryImpl implements VehicleInsightsRepository {
  final VehicleInsightsRemoteDataSource remoteDataSource;
  final Map<int, VehicleInsight> _cache = {};

  VehicleInsightsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<VehicleInsight> fetchVehicleInsight({
    required int vehicleId,
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh && _cache.containsKey(vehicleId)) {
      return _cache[vehicleId]!;
    }

    try {
      final json = await remoteDataSource.fetchVehicleInsight(vehicleId);
      final insight = VehicleInsightMapper.fromJson({
        ..._mockSnapshotPayload,
        ...json,
      });
      _cache[vehicleId] = insight;
      return insight;
    } catch (_) {
      if (_cache.containsKey(vehicleId)) {
        return _cache[vehicleId]!;
      }
      final fallback = VehicleInsightMapper.fromJson({
        ..._mockSnapshotPayload,
        ..._mockInsightResponse,
        'vehicleId': vehicleId,
      });
      _cache[vehicleId] = fallback;
      return fallback;
    }
  }
}

const Map<String, dynamic> _mockSnapshotPayload = {
  'speedKmh': 68.5,
  'location': {'latitude': -12.04, 'longitude': -77.03},
  'tirePressure': {
    'frontLeft': 31.5,
    'frontRight': 34.2,
    'rearLeft': 33.9,
    'rearRight': 33.5,
  },
  'cabinGas': {'type': 'CO2', 'ppm': 730},
  'acceleration': {'lateralG': 0.45, 'longitudinalG': -0.8, 'verticalG': 0.05},
};

const Map<String, dynamic> _mockInsightResponse = {
  'insightId': 1,
  'vehicleId': 1,
  'driverId': 1,
  'driverFullName': 'Juan Perez',
  'plateNumber': 'ABC-123',
  'severity': 'WARN',
  'riskLevel': 'Moderado',
  'maintenanceSummary':
      'Se recomienda revisar la presión de los neumáticos, especialmente el neumático delantero derecho que está por encima del rango óptimo. Además, los niveles de CO2 en la cabina son elevados.',
  'maintenanceWindow': 'Próximos 30 días',
  'drivingSummary':
      'El conductor mantiene una velocidad moderada, pero se observan aceleraciones laterales que podrían indicar maniobras bruscas.',
  'drivingScore': 65,
  'drivingAlerts': 'Velocidad superior a 60 km/h detectada en área urbana.',
  'generatedAt': '2025-11-09T18:08:29.089848Z',
  'recommendations': [
    {
      'title': 'Mantenimiento de Neumáticos',
      'detail':
          'Revisar y ajustar la presión de los neumáticos para asegurar un manejo seguro y eficiente.'
    },
    {
      'title': 'Mejorar Ventilación',
      'detail':
          'Instalar un sistema de ventilación o revisar el sistema actual para reducir los niveles de CO2 en la cabina.'
    },
    {
      'title': 'Mejorar Hábitos de Conducción',
      'detail':
          'Practicar técnicas de conducción más suaves para reducir aceleraciones bruscas y mejorar la eficiencia del combustible.'
    },
  ],
};
