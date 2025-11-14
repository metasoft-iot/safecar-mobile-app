import 'package:flutter/material.dart';
import 'package:safecar_mobile_app/insights/domain/models/vehicle_insight.dart';
import 'package:safecar_mobile_app/insights/domain/repositories/vehicle_insights_repository.dart';
import 'package:safecar_mobile_app/insights/infrastructure/datasources/vehicle_insights_remote_data_source.dart';
import 'package:safecar_mobile_app/insights/infrastructure/repositories/vehicle_insights_repository_impl.dart';
import 'package:safecar_mobile_app/insights/presentation/widgets/diagnostic_alerts_section.dart';
import 'package:safecar_mobile_app/insights/presentation/widgets/live_metrics_section.dart';
import 'package:safecar_mobile_app/insights/presentation/widgets/recommendations_section.dart';
import 'package:safecar_mobile_app/insights/presentation/widgets/vehicle_status_banner.dart';
import 'package:safecar_mobile_app/shared/theme/app_colors.dart';
import 'package:safecar_mobile_app/shared/widgets/custom_app_bar.dart';

class VehicleInsightsPage extends StatefulWidget {
  final int vehicleId;

  const VehicleInsightsPage({super.key, this.vehicleId = 1});

  @override
  State<VehicleInsightsPage> createState() => _VehicleInsightsPageState();
}

class _VehicleInsightsPageState extends State<VehicleInsightsPage> {
  late final VehicleInsightsRepository _repository;
  late Future<VehicleInsight> _future;

  @override
  void initState() {
    super.initState();
    _repository = VehicleInsightsRepositoryImpl(
      remoteDataSource: VehicleInsightsRemoteDataSource(),
    );
    _future = _repository.fetchVehicleInsight(vehicleId: widget.vehicleId);
  }

  Future<void> _refresh() async {
    final request = _repository.fetchVehicleInsight(
      vehicleId: widget.vehicleId,
      forceRefresh: true,
    );

    setState(() {
      _future = request;
    });

    await request;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar.simple(
        title: 'Engine',
        backgroundColor: AppColors.primary,
        titleStyle: const TextStyle(
          color: AppColors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: FutureBuilder<VehicleInsight>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return _ErrorState(onRetry: _refresh, message: snapshot.error.toString());
          }

          if (!snapshot.hasData) {
            return _ErrorState(onRetry: _refresh, message: 'No data received from backend');
          }

          final insight = snapshot.data!;

          return RefreshIndicator(
            onRefresh: _refresh,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  VehicleStatusBanner(insight: insight),
                  const SizedBox(height: 16),
                  LiveMetricsSection(snapshot: insight.snapshot),
                  const SizedBox(height: 16),
                  DiagnosticAlertsSection(
                    drivingAlerts: insight.drivingAlerts,
                    riskLevel: insight.riskLevel,
                  ),
                  const SizedBox(height: 16),
                  RecommendationsSection(
                    maintenanceSummary: insight.maintenanceSummary,
                    maintenanceWindow: insight.maintenanceWindow,
                    drivingSummary: insight.drivingSummary,
                    recommendations: insight.recommendations,
                  ),
                  const SizedBox(height: 12),
                  _Disclaimer(generatedAt: insight.generatedAt),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final Future<void> Function() onRetry;
  final String message;

  const _ErrorState({required this.onRetry, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_off, size: 64, color: AppColors.textDisabled),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                onRetry();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Try again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Disclaimer extends StatelessWidget {
  final DateTime generatedAt;

  const _Disclaimer({required this.generatedAt});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Text(
        'Disclaimer: This information is generated automatically and is for reference only. '
        'Last updated on ${generatedAt.toLocal()}. For critical issues consult a certified mechanic. '
        'Data is cached for offline use.',
        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.4),
      ),
    );
  }
}
