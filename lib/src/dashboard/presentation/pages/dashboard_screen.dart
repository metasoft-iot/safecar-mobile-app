import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:safecar_mobile_app/src/iam/application/blocs/auth_bloc.dart';
import 'package:safecar_mobile_app/src/iam/application/blocs/auth_event.dart';
import 'package:safecar_mobile_app/src/iam/application/blocs/auth_state.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF333366),
        title: const Text('Dashboard',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          // Añadido botón de Logout
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              // Enviar evento de Logout al BLoC
              context.read<AuthBloc>().add(const LogoutRequested());
            },
          )
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            // 1. Usar BlocBuilder para obtener el nombre del usuario
            child: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                String username = 'User'; // Valor por defecto
                if (state is Authenticated) {
                  // 2. Usar el username o email del estado
                  username = state.user.username.isNotEmpty
                      ? state.user.username
                      : state.user.email;
                }
                return Chip(
                  label: Text('Hello, "$username"'),
                  backgroundColor: Colors.white,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                );
              },
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildDashboardButton(
                      context, Icons.directions_car, 'Vehicle\nstatus'),
                  _buildDashboardButton(
                      context, Icons.calendar_today, 'Next\nappointment'),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildDashboardButton(
                      context, Icons.notifications_active, 'Active\nreminders'),
                  _buildDashboardButton(context, Icons.build, 'Maintenance'),
                ],
              ),
              const SizedBox(height: 32),
              const Text(
                'General summary',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildSummaryItem('Last alert received', 'Low Tire Pressure',
                  'October 20st, 2:30 PM'),
              const SizedBox(height: 16),
              _buildSummaryItem(
                  'Current mileage', '52,480 km', 'Last synced 10:30 AM'),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.directions_car), label: 'Vehicles'),
          BottomNavigationBarItem(icon: Icon(Icons.sync), label: 'Status'),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), label: 'Appointment'),
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard), label: 'Dashboard'),
        ],
        currentIndex: 3,
        onTap: (index) {
          switch (index) {
            case 0:
            // context.go('/vehicles');
              break;
            case 3:
              context.go('/dashboard');
              break;
          }
        },
        selectedItemColor: const Color(0xFF333366),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
      ),
    );
  }

  Widget _buildDashboardButton(
      BuildContext context, IconData icon, String label) {
    return Expanded(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: const Color(0xFFFDF6F6),
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 40, color: Colors.black87),
                const SizedBox(height: 8),
                Text(label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String title, String value, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 16)),
        Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 14)),
      ],
    );
  }
}