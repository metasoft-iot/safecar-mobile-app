import 'package:flutter/material.dart';
import 'package:safecar_mobile_app/vehicle_management/domain/model/vehicle_model.dart';
import 'package:safecar_mobile_app/shared/theme/app_colors.dart';

class VehicleCard extends StatelessWidget {
  final VehicleModel vehicle;
  final VoidCallback? onTap;

  const VehicleCard({
    super.key,
    required this.vehicle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: AppColors.white,
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        leading: SizedBox(
          width: 56,
          height: 56,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              vehicle.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Image.asset(
                'assets/images/vehicle_placeholder.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        title: Text(
          '${vehicle.make} ${vehicle.model}',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text('${vehicle.year} • ${vehicle.fuelType.name}'),
        trailing: vehicle.isPrimary
            ? Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.appointmentConfirmed.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            'Default',
            style: TextStyle(
              color: AppColors.appointmentConfirmed,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        )
            : null,
      ),
    );
  }
}
