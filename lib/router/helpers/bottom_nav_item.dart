library;

import 'package:flutter/material.dart';

/// Model for bottom navigation bar items
class BottomNavItem {
  final String label;
  final IconData icon;
  final String route;

  const BottomNavItem({
    required this.label,
    required this.icon,
    required this.route,
  });
}

/// Configuration for bottom navigation bar
class BottomNavConfig {
  static const List<BottomNavItem> items = [
    BottomNavItem(
      label: 'Vehicles',
      icon: Icons.directions_car,
      route: '/vehicles',
    ),
    BottomNavItem(
      label: 'Status',
      icon: Icons.format_list_bulleted,
      route: '/status',
    ),
    BottomNavItem(
      label: 'Workshop',
      icon: Icons.calendar_today,
      route: '/workshop',
    ),
    BottomNavItem(
      label: 'Dashboard',
      icon: Icons.dashboard,
      route: '/dashboard',
    ),
  ];

  /// Get the index of a route in the bottom navigation
  static int getIndexForRoute(String route) {
    final index = items.indexWhere((item) => route.startsWith(item.route));
    return index >= 0 ? index : 0;
  }

  /// Get the route for a given index
  static String getRouteForIndex(int index) {
    if (index >= 0 && index < items.length) {
      return items[index].route;
    }
    return items[0].route;
  }
}
