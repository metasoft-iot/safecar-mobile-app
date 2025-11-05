
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyVehiclesScreen extends StatelessWidget {
  const MyVehiclesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data for vehicles
    final vehicles = [
      {"id": "1", "name": "Toyota Camry", "year": "2021 - Gas", "isDefault": true},
      {"id": "2", "name": "Ford Explorer", "year": "2020 - Gas", "isDefault": false},
      {"id": "3", "name": "Chevrolet Silverado", "year": "2019 - Diesel", "isDefault": false},
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF333366),
        title: const Text('My Vehicles', style: TextStyle(color: Colors.white)),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            color: const Color(0xFF333366),
            child: Column(
              children: [
                TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search vehicles...',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                    prefixIcon: const Icon(Icons.search, color: Colors.white),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.filter_list, color: Colors.white),
                      label: const Text('Filters', style: TextStyle(color: Colors.white)),
                    ),
                    DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: 'Last used',
                        icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                        style: const TextStyle(color: Colors.white),
                        dropdownColor: const Color(0xFF333366),
                        items: <String>['Last used', 'Make', 'Model']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            color: const Color(0xFFFFFBE6),
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                const Icon(Icons.sync_problem, color: Colors.amber),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Sync pending', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('Your latest changes are waiting to be synced.', style: TextStyle(color: Colors.grey[700])),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: vehicles.length,
              itemBuilder: (context, index) {
                final vehicle = vehicles[index];
                return GestureDetector(
                  onTap: () => context.go('/vehicles/${vehicle["id"]}'),
                  child: Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Icon(Icons.directions_car, size: 40, color: Colors.grey),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(vehicle['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                    if (vehicle['isDefault'] as bool) ...[
                                      const SizedBox(width: 8),
                                      const Chip(
                                        label: Text('Default', style: TextStyle(fontSize: 10)),
                                        backgroundColor: Color(0xFFE6F9E6),
                                        padding: EdgeInsets.zero,
                                      ),
                                    ],
                                  ],
                                ),
                                Text(vehicle['year'] as String, style: const TextStyle(color: Colors.grey)),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.more_vert),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/add-vehicle'),
        backgroundColor: const Color(0xFF333366),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.directions_car), label: 'Vehicles'),
          BottomNavigationBarItem(icon: Icon(Icons.sync), label: 'Status'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Appointment'),
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
        ],
        currentIndex: 0,
        selectedItemColor: const Color(0xFF333366),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
      ),
    );
  }
}
