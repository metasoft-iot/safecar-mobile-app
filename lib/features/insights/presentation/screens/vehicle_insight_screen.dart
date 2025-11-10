import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/vehicle_insight.dart';
import '../../domain/entities/vehicle_metrics.dart';
import '../../domain/entities/vehicle_telemetry.dart';
import '../providers/vehicle_insight_notifier.dart';

class VehicleInsightScreen extends StatefulWidget {
  const VehicleInsightScreen({super.key, required this.vehicleId});

  final int vehicleId;

  @override
  State<VehicleInsightScreen> createState() => _VehicleInsightScreenState();
}

class _VehicleInsightScreenState extends State<VehicleInsightScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VehicleInsightNotifier>().loadInsight(widget.vehicleId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF333366),
        foregroundColor: Colors.white,
        title: const Text('Engine', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/dashboard');
            }
          },
        ),
      ),
      body: Consumer<VehicleInsightNotifier>(
        builder: (context, notifier, _) {
          switch (notifier.status) {
            case VehicleInsightStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case VehicleInsightStatus.error:
              if (notifier.insight == null) {
                return _ErrorState(
                  message: notifier.errorMessage ?? 'No pudimos obtener el estado del vehículo.',
                  onRetry: () => notifier.loadInsight(widget.vehicleId),
                );
              }
              break;
            case VehicleInsightStatus.initial:
              return const SizedBox.shrink();
            case VehicleInsightStatus.loaded:
              break;
          }

          final insight = notifier.insight;
          if (insight == null) {
            return const _ErrorState(
              message: 'No hay datos disponibles todavía.',
            );
          }

          return RefreshIndicator(
            onRefresh: () => notifier.loadInsight(widget.vehicleId),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              children: [
                _StatusCard(insight: insight),
                const SizedBox(height: 16),
                _LiveMetricsCard(insight: insight),
                const SizedBox(height: 16),
                _DtcCard(insight: insight),
                const SizedBox(height: 16),
                _RecommendationsCard(insight: insight),
                const SizedBox(height: 16),
                _DisclaimerCard(lastUpdated: insight.generatedAt),
                const SizedBox(height: 24),
                _AnalyzeButton(
                  isLoading: notifier.isAnalyzing,
                  onPressed: notifier.isAnalyzing
                      ? null
                      : () {
                          final telemetry = _buildTelemetryPayload(insight);
                          notifier.refreshAnalysis(telemetry);
                        },
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: _BottomNav(currentIndex: 1),
    );
  }

  VehicleTelemetry _buildTelemetryPayload(VehicleInsight insight) {
    final metrics = insight.liveMetrics;
    final location = insight.location ?? const VehicleLocation(latitude: -12.04, longitude: -77.03);

    return VehicleTelemetry(
      driverId: insight.driverId,
      driverFullName: insight.driverFullName,
      vehicleId: insight.vehicleId,
      plateNumber: insight.plateNumber,
      capturedAt: DateTime.now().toUtc(),
      severity: _mapRiskToSeverity(insight.riskLevel),
      speedKmh: metrics?.speedKmh ?? 60,
      location: location,
      tirePressure: metrics?.tirePressure ??
          const TirePressure(frontLeft: 32, frontRight: 32, rearLeft: 33, rearRight: 33),
      cabinGas: metrics?.cabinGas ?? const CabinGas(type: 'CO2', ppm: 500),
      acceleration: metrics?.acceleration ??
          const Acceleration(lateralG: 0.2, longitudinalG: 0.1, verticalG: 0.05),
      rpm: metrics?.rpm ?? 900,
      coolantTemp: metrics?.coolantTemp ?? 95,
      oilPressure: metrics?.oilPressure ?? 38,
      oilTemp: metrics?.oilTemp ?? 97,
    );
  }

  String _mapRiskToSeverity(String riskLevel) {
    switch (riskLevel.toLowerCase()) {
      case 'alto':
      case 'alto riesgo':
        return 'CRITICAL';
      case 'moderado':
        return 'WARN';
      default:
        return 'INFO';
    }
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.insight});

  final VehicleInsight insight;

  @override
  Widget build(BuildContext context) {
    final palette = _riskPalette(insight.riskLevel);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Status', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(palette.icon, color: palette.color),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(palette.title, style: TextStyle(color: palette.color, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(insight.maintenanceSummary, style: const TextStyle(color: Colors.black87)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text('Ventana de mantenimiento: ${insight.maintenanceWindow}', style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  _RiskPalette _riskPalette(String level) {
    switch (level.toLowerCase()) {
      case 'alto':
        return const _RiskPalette(
          title: 'Status Alert',
          color: Color(0xFFE65100),
          icon: Icons.warning_amber_rounded,
        );
      case 'moderado':
        return const _RiskPalette(
          title: 'Mantenimiento Recomendado',
          color: Color(0xFFFFA000),
          icon: Icons.report_problem,
        );
      default:
        return const _RiskPalette(
          title: 'All Systems Nominal',
          color: Color(0xFF2E7D32),
          icon: Icons.check_circle,
        );
    }
  }
}

class _LiveMetricsCard extends StatelessWidget {
  const _LiveMetricsCard({required this.insight});

  final VehicleInsight insight;

  @override
  Widget build(BuildContext context) {
    final metrics = insight.liveMetrics;
    final tiles = [
      _MetricTile(label: 'RPM', value: _formatMetric(metrics?.rpm)),
      _MetricTile(label: 'Coolant Temp', value: _formatMetric(metrics?.coolantTemp, suffix: '°C')),
      _MetricTile(
        label: 'Oil Pressure',
        value: _formatMetric(metrics?.oilPressure, suffix: ' PSI'),
        highlight: (metrics?.oilPressure ?? 0) < 30 && metrics?.oilPressure != null,
      ),
      _MetricTile(label: 'Oil Temp', value: _formatMetric(metrics?.oilTemp, suffix: '°C')),
      _MetricTile(label: 'Speed', value: _formatMetric(metrics?.speedKmh, suffix: ' km/h')),
      _MetricTile(
        label: 'CO₂',
        value: _formatMetric(metrics?.cabinGas?.ppm, suffix: ' ppm'),
        highlight: (metrics?.cabinGas?.ppm ?? 0) > 700 && metrics?.cabinGas?.ppm != null,
      ),
    ];

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Live Metrics', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: tiles.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2.4,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (context, index) => tiles[index],
            ),
          ],
        ),
      ),
    );
  }

  String _formatMetric(double? value, {String suffix = ''}) {
    if (value == null) {
      return '--';
    }
    final formatted = value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 1);
    return '$formatted$suffix';
  }
}

class _DtcCard extends StatelessWidget {
  const _DtcCard({required this.insight});

  final VehicleInsight insight;

  @override
  Widget build(BuildContext context) {
    final dtcCodes = insight.diagnosticTroubleCodes.isNotEmpty
        ? insight.diagnosticTroubleCodes
        : insight.drivingAlerts.split('.').where((code) => code.trim().isNotEmpty).toList();

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Diagnostic Trouble Codes (DTCs)',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            if (dtcCodes.isEmpty)
              Row(
                children: const [
                  Icon(Icons.assignment_turned_in_outlined, color: Color(0xFF2E7D32)),
                  SizedBox(width: 12),
                  Expanded(child: Text('No DTCs Found\nEl sistema no reportó códigos activos.')),
                ],
              )
            else
              Column(
                children: dtcCodes
                    .map((code) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.error_outline, color: Color(0xFFE65100)),
                              const SizedBox(width: 12),
                              Expanded(child: Text(code.trim(), style: const TextStyle(fontWeight: FontWeight.w600))),
                            ],
                          ),
                        ))
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }
}

class _RecommendationsCard extends StatelessWidget {
  const _RecommendationsCard({required this.insight});

  final VehicleInsight insight;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Recommended Actions',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ...insight.recommendations.map(
              (rec) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.check_circle, color: Theme.of(context).primaryColor),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(rec.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(rec.detail, style: const TextStyle(color: Colors.black87)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DisclaimerCard extends StatelessWidget {
  const _DisclaimerCard({required this.lastUpdated});

  final DateTime lastUpdated;

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('dd MMM yyyy, HH:mm').format(lastUpdated.toLocal());
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          'Última actualización: $formattedDate\nEsta data es referencial y no reemplaza un diagnóstico profesional. '
          'Los datos se almacenan localmente para uso offline.',
          style: const TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}

class _AnalyzeButton extends StatelessWidget {
  const _AnalyzeButton({required this.isLoading, required this.onPressed});

  final bool isLoading;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF333366),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: onPressed,
        icon: isLoading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
            : const Icon(Icons.refresh, color: Colors.white),
        label: Text(isLoading ? 'Analizando...' : 'Generar nuevo análisis',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({required this.label, required this.value, this.highlight = false});

  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: highlight ? const Color(0xFFFFEBEE) : const Color(0xFFF8F9FB),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: highlight ? Colors.red : Colors.black)),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off, size: 48, color: Colors.grey),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            if (onRetry != null) ...[
              const SizedBox(height: 12),
              ElevatedButton(onPressed: onRetry, child: const Text('Reintentar')),
            ],
          ],
        ),
      ),
    );
  }
}

class _RiskPalette {
  const _RiskPalette({required this.title, required this.color, required this.icon});

  final String title;
  final Color color;
  final IconData icon;
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({required this.currentIndex});

  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        switch (index) {
          case 0:
            context.go('/vehicles');
            break;
          case 1:
            context.go('/status?vehicleId=${context.read<VehicleInsightNotifier>().vehicleId ?? 1}');
            break;
          case 2:
            // Placeholder until appointment flow is ready.
            break;
          case 3:
            context.go('/dashboard');
            break;
        }
      },
      selectedItemColor: const Color(0xFF333366),
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.directions_car), label: 'Vehicles'),
        BottomNavigationBarItem(icon: Icon(Icons.sync), label: 'Status'),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Appointment'),
        BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
      ],
    );
  }
}
