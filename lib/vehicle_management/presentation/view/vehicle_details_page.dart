import 'package:flutter/material.dart';
import 'package:safecar_mobile_app/shared/theme/app_colors.dart';
import 'package:safecar_mobile_app/shared/widgets/custom_app_bar.dart';
import 'package:safecar_mobile_app/vehicle_management/domain/model/vehicle_model.dart';
import 'package:safecar_mobile_app/vehicle_management/infrastructure/in_memory_vehicle_repository.dart';
import 'package:safecar_mobile_app/vehicle_management/presentation/widgets/delete_vehicle_dialog.dart';

class VehicleDetailsPage extends StatefulWidget {
  final String vehicleId;
  const VehicleDetailsPage({super.key, required this.vehicleId});

  @override
  State<VehicleDetailsPage> createState() => _VehicleDetailsPageState();
}

class _VehicleDetailsPageState extends State<VehicleDetailsPage> {
  VehicleModel? _vehicle;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final v = await vehicleRepository.getById(widget.vehicleId);
    setState(() {
      _vehicle = v;
      _loading = false;
    });
  }

  Future<void> _setDefault() async {
    if (_vehicle == null) return;
    await vehicleRepository.setPrimary(_vehicle!.id);
    await _load();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Default vehicle updated')),
      );
    }
  }

  Future<void> _delete() async {
    final confirmed = await DeleteVehicleDialog.show(context);
    if (confirmed == true && _vehicle != null) {
      await vehicleRepository.delete(_vehicle!.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vehicle deleted')),
      );
      Navigator.of(context).pop(); // vuelve a la lista
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.withBackButton(
        title: 'Vehicle Details',
        backgroundColor: AppColors.primary,
        titleStyle: const TextStyle(
          color: AppColors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        actions: [
          IconButton(
            onPressed: () {/* TODO: Navegar a editar */},
            icon: const Icon(Icons.edit, color: AppColors.white),
            tooltip: 'Edit',
          )
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : (_vehicle == null)
          ? const Center(child: Text('Vehicle not found'))
          : _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    final v = _vehicle!;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Imagen
        AspectRatio(
          aspectRatio: 16 / 9,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(v.imageUrl, fit: BoxFit.cover),
          ),
        ),
        const SizedBox(height: 16),

        // Título + chip default
        Text('${v.make} ${v.model}',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
        Text('SUV • ${v.year}',
            style: TextStyle(color: Colors.grey.shade700)),
        const SizedBox(height: 8),
        if (v.isPrimary)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Default Vehicle',
              style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600),
            ),
          ),
        const SizedBox(height: 16),

        // Card info
        _infoCard([
          _infoRow('License Plate', v.licensePlate),
          _infoRow('Color', v.color),
          if (v.vin != null) _infoRow('VIN', v.vin!),
          _infoRow('Mileage', '${v.mileage.toStringAsFixed(0)} ${'mi'}'),
        ]),

        const SizedBox(height: 16),

        // Acciones
        _actionTile(
          icon: Icons.star_rate_rounded,
          color: Colors.amber.shade700,
          title: 'Set as default vehicle',
          onTap: _setDefault,
        ),
        const SizedBox(height: 8),
        _actionTile(
          icon: Icons.delete_outline,
          color: const Color(0xFFDC2626),
          title: 'Delete Vehicle',
          onTap: _delete,
        ),
      ],
    );
  }

  Widget _infoCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(children: children),
    );
  }

  Widget _infoRow(String label, String value) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      title: Text(label, style: TextStyle(color: Colors.grey.shade600)),
      trailing: Text(value,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
    );
  }

  Widget _actionTile({
    required IconData icon,
    required Color color,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      tileColor: AppColors.white,
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.12),
        foregroundColor: color,
        child: Icon(icon),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing: const Icon(Icons.chevron_right),
    );
  }
}
