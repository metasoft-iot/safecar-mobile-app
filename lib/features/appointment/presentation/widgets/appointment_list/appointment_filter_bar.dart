import 'package:flutter/material.dart';
import 'package:safecar_mobile_app/core/theme/app_colors.dart';

/// SafeCar Mobile App - Appointment Filter Bar Widget
/// Displays filter chips to filter appointments by status
class AppointmentFilterBar extends StatelessWidget {
  final String selectedFilter;
  final ValueChanged<String> onFilterChanged;

  const AppointmentFilterBar({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        children: [
          _FilterChip(
            label: 'All',
            isSelected: selectedFilter == 'All',
            onTap: () => onFilterChanged('All'),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Pending',
            isSelected: selectedFilter == 'Pending',
            onTap: () => onFilterChanged('Pending'),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Filled',
            isSelected: selectedFilter == 'Filled',
            onTap: () => onFilterChanged('Filled'),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Canceled',
            isSelected: selectedFilter == 'Canceled',
            onTap: () => onFilterChanged('Canceled'),
          ),
        ],
      ),
    );
  }
}

/// Private widget for individual filter chip
class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.white : AppColors.textSecondary,
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
