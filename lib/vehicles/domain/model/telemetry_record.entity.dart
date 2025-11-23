/// Telemetry record entity representing vehicle telemetry data.
class TelemetryRecord {
  final int id;
  final int vehicleId;
  final String type;
  final String severity;
  final DateTime ingestedAt;
  final Map<String, dynamic> sample;

  TelemetryRecord({
    required this.id,
    required this.vehicleId,
    required this.type,
    required this.severity,
    required this.ingestedAt,
    required this.sample,
  });
}

