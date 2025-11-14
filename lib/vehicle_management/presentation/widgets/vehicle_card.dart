import 'package:flutter/material.dart';
import 'package:safecar_mobile_app/shared/theme/app_colors.dart';
import 'package:safecar_mobile_app/vehicle_management/domain/model/vehicle_model.dart';

/// Tarjeta de vehículo utilizada en la lista de "My Vehicles"
/// Soporta acciones:
/// - tap en la tarjeta [onTap]
/// - ver detalles [onViewDetails]
/// - editar [onEdit]
/// - eliminar [onDelete]
class VehicleCard extends StatelessWidget {
  final VehicleModel vehicle;

  final VoidCallback? onTap;
  final VoidCallback? onViewDetails;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const VehicleCard({
    super.key,
    required this.vehicle,
    this.onTap,
    this.onViewDetails,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen del vehículo
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                vehicle.imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Image.asset(
                  'assets/images/vehicle_placeholder.png',
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Texto y menú
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Marca + modelo
                      Expanded(
                        child: Text(
                          '${vehicle.make} ${vehicle.model}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      // Menú de 3 puntos
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert),
                        onSelected: (value) {
                          if (value == 'details' && onViewDetails != null) {
                            onViewDetails!();
                          } else if (value == 'edit' && onEdit != null) {
                            onEdit!();
                          } else if (value == 'delete' && onDelete != null) {
                            onDelete!();
                          }
                        },
                        itemBuilder: (context) => const [
                          PopupMenuItem(
                            value: 'details',
                            child: Text('View details'),
                          ),
                          PopupMenuItem(
                            value: 'edit',
                            child: Text('Edit vehicle'),
                          ),
                          PopupMenuItem(
                            value: 'delete',
                            child: Text('Delete'),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  // Año
                  Text(
                    '${vehicle.year}',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),

                  // Badge "Default" si es el vehículo principal
                  if (vehicle.isPrimary) ...[
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.success.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Default',
                        style: TextStyle(
                          color: AppColors.success,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
