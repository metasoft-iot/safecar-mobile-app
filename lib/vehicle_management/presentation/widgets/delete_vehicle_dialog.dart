import 'package:flutter/material.dart';

class DeleteVehicleDialog extends StatelessWidget {
  const DeleteVehicleDialog({super.key});

  static Future<bool?> show(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (_) => const DeleteVehicleDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Column(
        children: const [
          CircleAvatar(
            radius: 28,
            backgroundColor: Color(0xFFFFE2E2),
            child: Icon(Icons.delete_forever, color: Color(0xFFDC2626), size: 28),
          ),
          SizedBox(height: 12),
          Text('Delete Vehicle?'),
        ],
      ),
      content: const Text(
        'Deleting will hide this vehicle from your active list, '
            'but its data will be saved. You can restore it later. '
            'Are you sure you want to proceed?',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFDC2626)),
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Yes, Delete'),
        ),
      ],
    );
  }
}
