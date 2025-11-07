
import 'package:flutter/material.dart';

class AddVehicleScreen extends StatelessWidget {
  const AddVehicleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF333366),
        title: const Text('Add Vehicle', style: TextStyle(color: Colors.white)),
        leading: const Icon(Icons.arrow_back, color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Required Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              _buildTextField('License Plate*', 'ABC-123'),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildDropdownField('Make*', ['Select Make'])),
                  const SizedBox(width: 16),
                  Expanded(child: _buildDropdownField('Model*', ['Select Model'])),
                ],
              ),
              const SizedBox(height: 16),
               Row(
                children: [
                  Expanded(child: _buildTextField('Model Year*', 'e.g., 2023')),
                  const SizedBox(width: 16),
                  Expanded(child: _buildColorField('Color*')),
                ],
              ),
              const SizedBox(height: 16),
              _buildTextField('Odometer*', 'e.g., 50000'),

              const SizedBox(height: 32),
              const Text('Optional Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              _buildTextField('VIN', '17-CHARACTER VIN'),
              const SizedBox(height: 16),
              _buildTextField('Vehicle Nickname', 'e.g., My Work Truck'),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Set as primary vehicle'),
                  Switch(value: false, onChanged: (value) {}),
                ],
              ),
              const SizedBox(height: 16),
              const Text('Photos'),
              const SizedBox(height: 8),
              Container(
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.camera_alt_outlined, size: 48, color: Colors.grey),
                    Text('Upload a file or drag and drop'),
                    Text('PNG, JPG up to 5MB', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildTextField('Notes', 'Add any notes about the vehicle...', maxLines: 3),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Save Vehicle',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
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
      ),
    );
  }

  Widget _buildTextField(String label, String hint, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 8),
        TextField(
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(String label, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 8),
        DropdownButtonFormField(
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
          value: items.first,
          items: items.map((String item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: (newValue) {},
        ),
      ],
    );
  }
    Widget _buildColorField(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 8),
        Container(
          height: 58,
          decoration: BoxDecoration(
            color: const Color(0xFF333366),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey)
          ),
        ),
      ],
    );
  }

}
