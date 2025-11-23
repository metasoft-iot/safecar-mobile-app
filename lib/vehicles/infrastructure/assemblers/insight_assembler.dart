import '../../../core/infrastructure/base_assembler.dart';
import '../../domain/model/vehicle_insight.entity.dart';
import '../../domain/model/telemetry_record.entity.dart';
import '../resources/insights_response.dart';

/// Assembler for converting between VehicleInsight entities and Insight resources.
class InsightAssembler implements BaseAssembler<VehicleInsight, VehicleInsightResource, InsightsResponse> {
  @override
  VehicleInsight toEntityFromResource(VehicleInsightResource resource) {
    return VehicleInsight(
      id: resource.id,
      vehicleId: resource.vehicleId,
      riskLevel: resource.riskLevel,
      maintenancePrediction: (resource.maintenanceSummary != null || resource.maintenanceWindow != null)
          ? MaintenancePrediction(
              summary: resource.maintenanceSummary ?? '',
              maintenanceWindow: resource.maintenanceWindow,
            )
          : null,
      drivingHabits: (resource.drivingSummary != null || resource.drivingScore != null)
          ? DrivingHabits(
              score: resource.drivingScore ?? 0,
              summary: resource.drivingSummary ?? '',
              alerts: resource.drivingAlerts != null 
                  ? resource.drivingAlerts!.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList()
                  : [],
            )
          : null,
      recommendations: _mapRecommendations(resource.recommendations),
      generatedAt: DateTime.parse(resource.generatedAt),
    );
  }

  @override
  VehicleInsightResource toResourceFromEntity(VehicleInsight entity) {
    return VehicleInsightResource(
      id: entity.id,
      vehicleId: entity.vehicleId,
      riskLevel: entity.riskLevel,
      maintenanceSummary: entity.maintenancePrediction?.summary,
      maintenanceWindow: entity.maintenancePrediction?.maintenanceWindow,
      drivingSummary: entity.drivingHabits?.summary,
      drivingScore: entity.drivingHabits?.score,
      drivingAlerts: entity.drivingHabits?.alerts.join(', '),
      recommendations: entity.recommendations
          .map((r) => {
                'title': r.title,
                'detail': r.detail,
              })
          .toList(),
      generatedAt: entity.generatedAt.toIso8601String(),
    );
  }

  @override
  List<VehicleInsight> toEntitiesFromResponse(InsightsResponse response) {
    return [toEntityFromResource(response.insight)];
  }

  // Helper methods
  List<Recommendation> _mapRecommendations(List<dynamic> data) {
    return data.map((r) {
      if (r is Map<String, dynamic>) {
        return Recommendation(
          title: r['title'] as String? ?? '',
          detail: r['detail'] as String? ?? '',
        );
      }
      return Recommendation(title: r.toString(), detail: '');
    }).toList();
  }
}

/// Assembler for converting between TelemetryRecord entities and Telemetry resources.
class TelemetryAssembler implements BaseAssembler<TelemetryRecord, TelemetryRecordResource, TelemetryResponse> {
  @override
  TelemetryRecord toEntityFromResource(TelemetryRecordResource resource) {
    return TelemetryRecord(
      id: resource.id,
      vehicleId: resource.vehicleId,
      type: resource.sample['type'] as String? ?? 'UNKNOWN',
      severity: resource.sample['severity'] as String? ?? 'INFO',
      ingestedAt: DateTime.parse(resource.ingestedAt),
      sample: resource.sample,
    );
  }

  @override
  TelemetryRecordResource toResourceFromEntity(TelemetryRecord entity) {
    return TelemetryRecordResource(
      id: entity.id,
      vehicleId: entity.vehicleId,
      ingestedAt: entity.ingestedAt.toIso8601String(),
      sample: entity.sample,
    );
  }

  @override
  List<TelemetryRecord> toEntitiesFromResponse(TelemetryResponse response) {
    return response.records.map((resource) => toEntityFromResource(resource)).toList();
  }
}

