import '../../domain/entities/insight_recommendation.dart';
import '../../domain/entities/vehicle_insight.dart';
import '../../domain/entities/vehicle_metrics.dart';
import 'insight_recommendation_model.dart';
import 'vehicle_metrics_model.dart';

class VehicleInsightModel extends VehicleInsight {
  const VehicleInsightModel({
    required super.insightId,
    required super.vehicleId,
    required super.driverId,
    required super.driverFullName,
    required super.plateNumber,
    required super.riskLevel,
    required super.maintenanceSummary,
    required super.maintenanceWindow,
    required super.drivingSummary,
    required super.drivingScore,
    required super.drivingAlerts,
    required super.generatedAt,
    required super.recommendations,
    super.liveMetrics,
    super.location,
    super.diagnosticTroubleCodes,
  });

  factory VehicleInsightModel.fromJson(Map<String, dynamic> json) {
    final recommendationsJson = json['recommendations'] as List<dynamic>? ?? [];
    final diagnosticTroubleCodes =
        (json['diagnosticTroubleCodes'] as List<dynamic>?)?.cast<String>() ?? const [];

    final metricsPayload = _extractMetricsPayload(json);
    final locationJson = json['location'] as Map<String, dynamic>?;

    return VehicleInsightModel(
      insightId: json['insightId'] as int? ?? 0,
      vehicleId: json['vehicleId'] as int? ?? 0,
      driverId: json['driverId'] as int? ?? 0,
      driverFullName: json['driverFullName'] as String? ?? 'Conductor',
      plateNumber: json['plateNumber'] as String? ?? '---',
      riskLevel: json['riskLevel'] as String? ?? 'Moderado',
      maintenanceSummary: json['maintenanceSummary'] as String? ?? '',
      maintenanceWindow: json['maintenanceWindow'] as String? ?? '',
      drivingSummary: json['drivingSummary'] as String? ?? '',
      drivingScore: json['drivingScore'] as int? ?? 0,
      drivingAlerts: json['drivingAlerts'] as String? ?? '',
      generatedAt: DateTime.tryParse(json['generatedAt'] as String? ?? '') ?? DateTime.now(),
      recommendations: recommendationsJson
          .map((item) => InsightRecommendationModel.fromJson(item as Map<String, dynamic>))
          .toList(growable: false),
      liveMetrics: metricsPayload.isEmpty ? null : VehicleMetricsModel.fromJson(metricsPayload),
      location: locationJson == null ? null : VehicleLocationModel.fromJson(locationJson),
      diagnosticTroubleCodes: diagnosticTroubleCodes,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'insightId': insightId,
      'vehicleId': vehicleId,
      'driverId': driverId,
      'driverFullName': driverFullName,
      'plateNumber': plateNumber,
      'riskLevel': riskLevel,
      'maintenanceSummary': maintenanceSummary,
      'maintenanceWindow': maintenanceWindow,
      'drivingSummary': drivingSummary,
      'drivingScore': drivingScore,
      'drivingAlerts': drivingAlerts,
      'generatedAt': generatedAt.toIso8601String(),
      'recommendations': recommendations
          .map((item) => (item is InsightRecommendationModel)
              ? item.toJson()
              : InsightRecommendationModel(title: item.title, detail: item.detail).toJson())
          .toList(),
      'diagnosticTroubleCodes': diagnosticTroubleCodes,
    };

    if (liveMetrics != null) {
      data['liveMetrics'] = (liveMetrics is VehicleMetricsModel)
          ? (liveMetrics! as VehicleMetricsModel).toJson()
          : VehicleMetricsModel(
              rpm: liveMetrics!.rpm,
              coolantTemp: liveMetrics!.coolantTemp,
              oilPressure: liveMetrics!.oilPressure,
              oilTemp: liveMetrics!.oilTemp,
              speedKmh: liveMetrics!.speedKmh,
              tirePressure: liveMetrics!.tirePressure,
              cabinGas: liveMetrics!.cabinGas,
              acceleration: liveMetrics!.acceleration,
            ).toJson();
    }

    if (location != null) {
      data['location'] = (location is VehicleLocationModel)
          ? (location! as VehicleLocationModel).toJson()
          : VehicleLocationModel(latitude: location!.latitude, longitude: location!.longitude).toJson();
    }

    return data;
  }

  static Map<String, dynamic> _extractMetricsPayload(Map<String, dynamic> json) {
    if (json['liveMetrics'] is Map<String, dynamic>) {
      return (json['liveMetrics'] as Map<String, dynamic>);
    }

    final keys = {
      'rpm',
      'coolantTemp',
      'oilPressure',
      'oilTemp',
      'speedKmh',
      'tirePressure',
      'cabinGas',
      'acceleration',
    };

    final extracted = <String, dynamic>{};
    for (final key in keys) {
      if (json[key] != null) {
        extracted[key] = json[key];
      }
    }
    return extracted;
  }
}
