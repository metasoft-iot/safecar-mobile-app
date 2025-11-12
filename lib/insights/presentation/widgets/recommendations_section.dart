import 'package:flutter/material.dart';
import 'package:safecar_mobile_app/insights/domain/models/vehicle_insight.dart';
import 'package:safecar_mobile_app/shared/theme/app_colors.dart';

class RecommendationsSection extends StatelessWidget {
  final String maintenanceSummary;
  final String maintenanceWindow;
  final String drivingSummary;
  final List<VehicleRecommendation> recommendations;

  const RecommendationsSection({
    super.key,
    required this.maintenanceSummary,
    required this.maintenanceWindow,
    required this.drivingSummary,
    required this.recommendations,
  });

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
            'Recommended Actions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          _ActionSummaryCard(
            icon: Icons.build,
            title: 'Maintenance',
            subtitle: maintenanceWindow,
            description: maintenanceSummary,
            color: AppColors.primary,
          ),
          const SizedBox(height: 12),
          _ActionSummaryCard(
            icon: Icons.alt_route,
            title: 'Driving Habits',
            subtitle: 'Driving score insights',
            description: drivingSummary,
            color: AppColors.secondary,
          ),
          if (recommendations.isNotEmpty) ...[
            const SizedBox(height: 20),
            const Text(
              'Personalized Recommendations',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            ...recommendations.map(
              (item) => _RecommendationTile(recommendation: item),
            ),
          ],
        ],
      ),
    );
  }
}

class _ActionSummaryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String description;
  final Color color;

  const _ActionSummaryCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: color.darken(),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RecommendationTile extends StatelessWidget {
  final VehicleRecommendation recommendation;

  const _RecommendationTile({required this.recommendation});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            recommendation.title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            recommendation.detail,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

extension on Color {
  Color darken([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }
}
