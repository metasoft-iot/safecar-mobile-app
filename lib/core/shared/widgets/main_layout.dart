import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:safecar_mobile_app/core/shared/widgets/custom_bottom_navigation_bar.dart';

/// Main layout with bottom navigation bar
/// Uses StatefulNavigationShell from GoRouter for better navigation
class MainLayout extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainLayout({
    super.key,
    required this.navigationShell,
  });

  void _onTabTapped(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
