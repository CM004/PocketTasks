import 'package:flutter/material.dart';
import '../services/task_manager.dart';

class FilterChips extends StatelessWidget {
  final TaskFilter currentFilter;
  final ValueChanged<TaskFilter> onFilterChanged;

  const FilterChips({
    super.key,
    required this.currentFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildFilterChip(
          context,
          label: 'All',
          filter: TaskFilter.all,
          isSelected: currentFilter == TaskFilter.all,
        ),
        const SizedBox(width: 8),
        _buildFilterChip(
          context,
          label: 'Active',
          filter: TaskFilter.active,
          isSelected: currentFilter == TaskFilter.active,
        ),
        const SizedBox(width: 8),
        _buildFilterChip(
          context,
          label: 'Done',
          filter: TaskFilter.done,
          isSelected: currentFilter == TaskFilter.done,
        ),
      ],
    );
  }

  Widget _buildFilterChip(
    BuildContext context, {
    required String label,
    required TaskFilter filter,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => onFilterChanged(filter),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
} 