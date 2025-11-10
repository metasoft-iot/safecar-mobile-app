
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class VehicleDetailsScreen extends StatelessWidget {
  const VehicleDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF333366),
        title: const Text('Vehicle Details', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        actions: const [Icon(Icons.edit, color: Colors.white)],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.network(
                'https://www.motortrend.com/uploads/2022/03/2022-Toyota-RAV4-XLE-front-view-2.jpg',
                height: 200,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  'Toyota RAV4',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const Center(child: Text('SUV • 2023')),
              const SizedBox(height: 8),
              const Center(
                child: Chip(
                  label: Text('Default Vehicle'),
                  backgroundColor: Color(0xFFE6F9E6),
                  avatar: Icon(Icons.star, color: Color(0xFF4CAF50)),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildDetailRow('License Plate', 'ABC-1234'),
                      const Divider(),
                      _buildDetailRow('Color', 'Midnight Black'),
                      const Divider(),
                      _buildDetailRow('VIN', 'JN1AZ00Z123456'),
                      const Divider(),
                      _buildDetailRow('Mileage', '15,430 mi'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.star_border),
                      title: const Text('Set as default vehicle'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {},
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.delete_outline, color: Colors.red),
                      title: const Text('Delete Vehicle', style: TextStyle(color: Colors.red)),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/add-vehicle'),
        backgroundColor: const Color(0xFF333366),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car),
            label: 'Vehicles',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sync),
            label: 'Status',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Appointment',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
        ],
        currentIndex: 0,
        selectedItemColor: const Color(0xFF333366),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/vehicles');
              break;
            case 1:
              context.go('/status?vehicleId=1');
              break;
            case 3:
              context.go('/dashboard');
              break;
          }
        },
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(title), Text(value)],
      ),
    );
  }
}
