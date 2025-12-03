import 'package:flutter/material.dart';

/// Screen displaying workshop information
class WorkshopInfoScreen extends StatelessWidget {
  const WorkshopInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Implement workshop info from API
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.build_circle, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'My Workshop',
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Information about the workshop you are linked to',
              style: TextStyle(color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

