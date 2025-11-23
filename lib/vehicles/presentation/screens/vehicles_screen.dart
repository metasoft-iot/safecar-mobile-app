import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../application/vehicles_bloc.dart';
import '../../application/vehicles_events.dart';
import '../../application/vehicles_states.dart';
import 'add_vehicle_screen.dart';
import 'vehicle_detail_screen.dart';

/// Screen displaying list of vehicles associated with the driver
class VehiclesScreen extends StatefulWidget {
  const VehiclesScreen({super.key});

  @override
  State<VehiclesScreen> createState() => _VehiclesScreenState();
}

class _VehiclesScreenState extends State<VehiclesScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _vehicles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadVehicles();
  }

  void _loadVehicles() {
    context.read<VehiclesStore>().add(const LoadVehicles());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<VehiclesStore, VehiclesState>(
      listener: (context, state) {
        if (state is VehiclesLoaded) {
          setState(() {
            _vehicles = state.vehicles.map((v) => {
              'id': v.id.toString(),
              'brand': v.brand,
              'model': v.model,
              'licensePlate': v.licensePlate,
              'displayName': v.fullDisplayName,
            }).toList();
            _isLoading = false;
          });
        } else if (state is VehiclesLoading) {
          setState(() {
            _isLoading = true;
          });
        } else if (state is VehiclesError) {
          setState(() {
            _isLoading = false;
          });
        }
      },
      child: _isLoading
          ? const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : _vehicles.isEmpty
              ? _EmptyVehiclesView(
                  onRefresh: _loadVehicles,
                )
              : Scaffold(
      body: Column(
        children: [
          // Header section with search and filters
          Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'My Vehicles',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search vehicles...',
                            prefixIcon: const Icon(Icons.search),
                            filled: true,
                            fillColor: const Color(0xFF5C4FDB).withOpacity(0.05),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        height: 48,
                        width: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFF5C4FDB).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.filter_list,
                            color: Color(0xFF5C4FDB),
                          ),
                          onPressed: () {
                            // TODO: Show filter options
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Sync pending banner - removed as it's just for mockup
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Sort by:',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Last used',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Icon(Icons.arrow_drop_down, size: 20),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Vehicle list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _vehicles.length,
              itemBuilder: (context, index) {
                final vehicle = _vehicles[index];
                return _VehicleCard(
                  make: vehicle['brand'] ?? 'Unknown',
                  model: vehicle['model'] ?? 'Unknown',
                  licensePlate: vehicle['licensePlate'] ?? 'N/A',
                  isDefault: index == 0, // First vehicle is default
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const VehicleDetailScreen(),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddVehicleScreen(),
            ),
          );
          
          // Refresh vehicles list if a vehicle was added
          if (result == true) {
            _loadVehicles();
          }
        },
        backgroundColor: const Color(0xFF5C4FDB),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    ),
    );
  }
}

class _VehicleCard extends StatelessWidget {
  final String make;
  final String model;
  final String licensePlate;
  final bool isDefault;
  final VoidCallback onTap;

  const _VehicleCard({
    required this.make,
    required this.model,
    required this.licensePlate,
    required this.isDefault,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Vehicle image placeholder
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.directions_car,
                  size: 40,
                  color: Colors.grey.shade400,
                ),
              ),
              const SizedBox(width: 16),
              
              // Vehicle info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '$make $model',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isDefault) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'Default',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.green.shade700,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      licensePlate,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              
              // More options
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {
                  // TODO: Show vehicle options
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyVehiclesView extends StatelessWidget {
  final VoidCallback onRefresh;
  
  const _EmptyVehiclesView({required this.onRefresh});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Illustration placeholder
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Icon(
                Icons.no_transfer_outlined,
                size: 100,
                color: Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No Vehicles Found',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48.0),
              child: Text(
                'Add your first vehicle to get started.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddVehicleScreen(),
            ),
          );
          
          // Refresh vehicles list if a vehicle was added
          if (result == true) {
            onRefresh();
          }
        },
        backgroundColor: const Color(0xFF5C4FDB),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
