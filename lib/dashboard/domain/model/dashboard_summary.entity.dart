/// Dashboard summary entity containing aggregated data.
class DashboardSummary {
  final int totalVehicles;
  final String? lastAlert;
  final String? lastAlertTime;
  final String? nextService;

  DashboardSummary({
    required this.totalVehicles,
    this.lastAlert,
    this.lastAlertTime,
    this.nextService,
  });
}

