import 'package:flutter/material.dart';
import 'package:safecar_mobile_app/insights/domain/models/vehicle_insight.dart';
import 'package:safecar_mobile_app/shared/theme/app_colors.dart';

class LiveMetricsSection extends StatelessWidget {
  final VehicleSnapshot snapshot;

  const LiveMetricsSection({super.key, required this.snapshot});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Live Metrics',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final itemWidth = (constraints.maxWidth - 12) / 2;
              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _MetricCard(
                    width: itemWidth,
                    label: 'Speed',
                    value: '${snapshot.speedKmh.toStringAsFixed(1)} km/h',
                    icon: Icons.speed,
                  ),
                  _MetricCard(
                    width: itemWidth,
                    label: 'Cabin ${snapshot.cabinGas.type}',
                    value: '${snapshot.cabinGas.ppm.toStringAsFixed(0)} ppm',
                    statusColor: snapshot.cabinGas.ppm > 600 ? AppColors.warning : AppColors.success,
                    icon: Icons.air,
                  ),
                  _MetricCard(
                    width: itemWidth,
                    label: 'Front Right Tire',
                    value: '${snapshot.tirePressure.frontRight.toStringAsFixed(1)} PSI',
                    statusColor: snapshot.tirePressure.frontRight > 34
                        ? AppColors.warning
                        : AppColors.textPrimary,
                    icon: Icons.tire_repair,
                  ),
                  _MetricCard(
                    width: itemWidth,
                    label: 'Lateral Accel',
                    value: '${snapshot.acceleration.lateralG.toStringAsFixed(2)} g',
                    icon: Icons.multiline_chart,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? statusColor;
  final double width;

  const _MetricCard({
    required this.label,
    required this.value,
    required this.icon,
    this.statusColor,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.textSecondary, size: 20),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: statusColor ?? AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
