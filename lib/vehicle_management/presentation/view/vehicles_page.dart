import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:safecar_mobile_app/shared/theme/app_colors.dart';
import 'package:safecar_mobile_app/shared/widgets/custom_app_bar.dart';

import 'package:safecar_mobile_app/vehicle_management/domain/model/vehicle_model.dart';
import 'package:safecar_mobile_app/vehicle_management/infrastructure/in_memory_vehicle_repository.dart';
import 'package:safecar_mobile_app/vehicle_management/presentation/widgets/vehicle_card.dart';
import 'package:safecar_mobile_app/vehicle_management/presentation/widgets/vehicle_empty_state.dart';
import 'package:safecar_mobile_app/vehicle_management/vehicle_routes.dart';

class VehiclesPage extends StatefulWidget {
  const VehiclesPage({super.key});

  @override
  State<VehiclesPage> createState() => _VehiclesPageState();
}

class _VehiclesPageState extends State<VehiclesPage> {
  /// Lista actual de vehículos a mostrar
  List<VehicleModel> vehicles = [];

  @override
  void initState() {
    super.initState();
    _loadVehicles();
  }

  /// Carga/recarga los vehículos desde el repositorio en memoria
  Future<void> _loadVehicles() async {
    final data = await vehicleRepository.getAll();
    if (!mounted) return;
    setState(() => vehicles = data);
  }

  /// Muestra un diálogo de confirmación y elimina el vehículo si el usuario acepta
  Future<void> _confirmDeleteVehicle(String vehicleId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Delete vehicle"),
        content: const Text("Are you sure you want to delete this vehicle?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await vehicleRepository.delete(vehicleId);
        await _loadVehicles();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Vehicle deleted')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error deleting vehicle: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.simple(
        title: 'My Vehicles',
        backgroundColor: AppColors.primary,
        titleStyle: const TextStyle(
          color: AppColors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),

      body: vehicles.isEmpty
          ? const VehicleEmptyState()
          : ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: vehicles.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, i) {
          final v = vehicles[i];

          return VehicleCard(
            vehicle: v,

            //detalles
            onTap: () async {
              await context.pushNamed(
                VehicleRouteNames.vehicleDetails,
                pathParameters: {'id': v.id},
              );
              _loadVehicles();
            },

            //View details
            onViewDetails: () async {
              await context.pushNamed(
                VehicleRouteNames.vehicleDetails,
                pathParameters: {'id': v.id},
              );
              _loadVehicles();
            },

            // 👉 Menú: Edit
            onEdit: () async {
              // Ruta tipo: /vehicles/:id/edit
              await context.push('/vehicles/${v.id}/edit');
              _loadVehicles();
            },

            // 👉 Menú: Delete
            onDelete: () {
              _confirmDeleteVehicle(v.id);
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await context.pushNamed(VehicleRouteNames.vehicleAdd);
          _loadVehicles(); // refrescar al volver
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: AppColors.white),
      ),
    );
  }
}
