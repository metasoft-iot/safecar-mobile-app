import 'package:flutter/material.dart';
import '../../../../core/services/workshop_service.dart';
import 'new_appointment_screen.dart';

/// Screen for selecting a workshop before creating an appointment
class SelectWorkshopScreen extends StatefulWidget {
  const SelectWorkshopScreen({super.key});

  @override
  State<SelectWorkshopScreen> createState() => _SelectWorkshopScreenState();
}

class _SelectWorkshopScreenState extends State<SelectWorkshopScreen> {
  final _workshopService = WorkshopService();
  List<Map<String, dynamic>> _workshops = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWorkshops();
  }

  Future<void> _loadWorkshops() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final workshops = await _workshopService.getWorkshops();
      setState(() {
        _workshops = workshops;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error loading workshops: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Seleccionar Taller',
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
            'No hay talleres disponibles',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Por favor, intenta más tarde',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _loadWorkshops,
            icon: const Icon(Icons.refresh),
            label: const Text('Reintentar'),
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
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewAppointmentScreen(
                  workshopId: workshop['id']!,
                  workshopName: workshop['description']!,
                ),
              ),
            );
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
                      workshop['description'] ?? 'Taller',
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
                          '${workshop['totalMechanics'] ?? 0} mecánicos',
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

