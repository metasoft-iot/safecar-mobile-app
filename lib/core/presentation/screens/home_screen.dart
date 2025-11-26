import 'package:flutter/material.dart';
import '../../../dashboard/presentation/screens/dashboard_screen.dart';
import '../../../appointments/presentation/screens/appointments_screen.dart';
import '../../../vehicles/presentation/screens/vehicles_screen.dart';
import '../../../vehicles/presentation/screens/vehicle_status_screen.dart';

/// Home screen with bottom navigation using BLoC
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0; // Start with Dashboard
  bool _showBackButton = false;

  void _navigateToTab(int index, {bool showBackButton = false}) {
    setState(() {
      _currentIndex = index;
      _showBackButton = showBackButton;
    });
  }

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      DashboardScreen(onNavigateToTab: _navigateToTab),
      const VehiclesScreen(),
      const VehicleStatusScreen(),
      const AppointmentsScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _currentIndex == 0 // No AppBar for Dashboard
          ? null
          : AppBar(
              title: Text(_getTitleForIndex(_currentIndex)),
              leading: _showBackButton
                  ? IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => _navigateToTab(0, showBackButton: false),
                    )
                  : null,
            ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          _navigateToTab(index, showBackButton: false);
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF5C4FDB),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car_outlined),
            activeIcon: Icon(Icons.directions_car),
            label: 'Vehicles',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics_outlined),
            activeIcon: Icon(Icons.analytics),
            label: 'Status',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            activeIcon: Icon(Icons.calendar_today),
            label: 'Appointment',
          ),
        ],
      ),
    );
  }

  String _getTitleForIndex(int index) {
    switch (index) {
      case 1:
        return 'My Vehicles';
      case 2:
        return 'Vehicle Status';
      case 3:
        return 'Appointment Report';
      default:
        return 'SafeCar';
    }
  }
}

