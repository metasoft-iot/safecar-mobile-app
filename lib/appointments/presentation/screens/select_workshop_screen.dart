import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../workshops/application/workshops_bloc.dart';
import '../../../workshops/application/workshops_events.dart';
import '../../../workshops/application/workshops_states.dart';

/// Screen for selecting a workshop before creating an appointment
class SelectWorkshopScreen extends StatefulWidget {
  const SelectWorkshopScreen({super.key});

  @override
  State<SelectWorkshopScreen> createState() => _SelectWorkshopScreenState();
}

class _SelectWorkshopScreenState extends State<SelectWorkshopScreen> {
  List<Map<String, dynamic>> _workshops = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWorkshops();
  }

  void _loadWorkshops() {
    context.read<WorkshopsStore>().add(const LoadWorkshops());
    
    // Listen to state changes
    context.read<WorkshopsStore>().stream.listen((state) {
      if (state is WorkshopsLoaded) {
        setState(() {
          _workshops = state.workshops.map((w) => {
            'id': w.id.toString(),
            'name': w.name,
            'address': w.address,
            'phoneNumber': w.phoneNumber,
            'email': w.email,
            'totalMechanics': w.mechanicsCount,
          }).toList();
          _isLoading = false;
        });
      } else if (state is WorkshopsError) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Select Workshop',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: const Color(0xFF5C4FDB),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF5C4FDB),
              ),
            )
          : _workshops.isEmpty
              ? _buildEmptyState()
              : _buildWorkshopList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.store_outlined,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          const Text(
            'No workshops available',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Please try again later',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _loadWorkshops,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5C4FDB),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkshopList() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _workshops.length,
      itemBuilder: (context, index) {
        final workshop = _workshops[index];
        return _WorkshopCard(
          workshop: workshop,
          onTap: () async {
            final workshopId = workshop['id'];
            final workshopName = workshop['name'] ?? 'Workshop';
            
            if (workshopId == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Error: Workshop ID not available'),
                  backgroundColor: Colors.red,
                ),
              );
              return;
            }
            
            // Save selected workshop in SharedPreferences linked to driver
            final prefs = await SharedPreferences.getInstance();
            final driverId = prefs.getInt('driver_id');
            
            if (driverId != null) {
              await prefs.setString('selected_workshop_id_$driverId', workshopId);
              await prefs.setString('selected_workshop_name_$driverId', workshopName);
            } else {
              // Fallback for when driver ID is not available (should rarely happen)
              await prefs.setString('selected_workshop_id', workshopId);
              await prefs.setString('selected_workshop_name', workshopName);
            }
            
            if (!mounted) return;
            
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('✅ Workshop selected: $workshopName'),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );
            
            // Navigate back to appointments screen
            Navigator.pop(context, true);
          },
        );
      },
    );
  }
}

class _WorkshopCard extends StatelessWidget {
  final Map<String, dynamic> workshop;
  final VoidCallback onTap;

  const _WorkshopCard({
    required this.workshop,
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
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Workshop icon
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFF5C4FDB).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.store,
                  size: 32,
                  color: Color(0xFF5C4FDB),
                ),
              ),
              const SizedBox(width: 16),
              
              // Workshop info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      workshop['name'] ?? 'Workshop',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.engineering,
                          size: 16,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${workshop['totalMechanics'] ?? 0} mechanics',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Arrow icon
              Icon(
                Icons.arrow_forward_ios,
                size: 20,
                color: Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

