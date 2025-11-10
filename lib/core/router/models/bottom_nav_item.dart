/// Represents a navigation item in the bottom navigation bar
/// Part of Core layer - Shared domain models
class BottomNavItem {
  final String route;
  final String name;
  final int index;

  const BottomNavItem({
    required this.route,
    required this.name,
    required this.index,
  });
}

/// Bottom navigation items configuration
class BottomNavConfig {
  BottomNavConfig._();

  static const List<BottomNavItem> items = [
    // TODO: Implement vehicles feature
    BottomNavItem(
      route: '/vehicles',
      name: 'vehicles',
      index: 0,
    ),
    // TODO: Implement status feature
    BottomNavItem(
      route: '/status',
      name: 'status',
      index: 1,
    ),
    // Active feature: Appointment
    BottomNavItem(
      route: '/appointment',
      name: 'appointment',
      index: 2,
    ),
    // TODO: Implement dashboard feature
    BottomNavItem(
      route: '/dashboard',
      name: 'dashboard',
      index: 3,
    ),
  ];

  /// Get the index of a route in the bottom navigation
  static int getIndexByRoute(String route) {
    final index = items.indexWhere((item) => item.route == route);
    return index >= 0 ? index : 0;
  }

  /// Get the route by index
  static String getRouteByIndex(int index) {
    if (index >= 0 && index < items.length) {
      return items[index].route;
    }
    return items[0].route;
  }

  /// Check if a route is a bottom navigation route
  static bool isBottomNavRoute(String route) {
    return items.any((item) => item.route == route);
  }
}
