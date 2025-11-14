import 'package:flutter/material.dart';
import 'package:safecar_mobile_app/insights/domain/models/vehicle_insight.dart';
import 'package:safecar_mobile_app/shared/theme/app_colors.dart';

class VehicleStatusBanner extends StatelessWidget {
  final VehicleInsight insight;

  const VehicleStatusBanner({super.key, required this.insight});

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(insight.severity);
    final icon = _statusIcon(insight.severity);
    final title = _statusTitle(insight.severity);
    final subtitle = insight.isNominal
        ? 'All systems in ${insight.plateNumber} are nominal.'
        : insight.maintenanceSummary;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.15),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: color.withValues(alpha: 0.12),
                  ),
                  child: Text(
                    'Risk: ${insight.riskLevel}',
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _statusColor(InsightSeverity severity) {
    switch (severity) {
      case InsightSeverity.nominal:
        return AppColors.success;
      case InsightSeverity.warn:
        return AppColors.warning;
      case InsightSeverity.alert:
        return AppColors.error;
    }
  }

  IconData _statusIcon(InsightSeverity severity) {
    switch (severity) {
      case InsightSeverity.nominal:
        return Icons.check_circle;
      case InsightSeverity.warn:
        return Icons.warning_amber;
      case InsightSeverity.alert:
        return Icons.error_outline;
    }
  }

  String _statusTitle(InsightSeverity severity) {
    switch (severity) {
      case InsightSeverity.nominal:
        return 'All Systems Nominal';
      case InsightSeverity.warn:
        return 'Status Alert';
      case InsightSeverity.alert:
        return 'Critical Alert';
    }
  }
}
