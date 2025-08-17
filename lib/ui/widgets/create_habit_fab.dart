import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Standardized floating action button for creating habits
class CreateHabitFAB extends StatelessWidget {
  final Map<String, dynamic>? prefilledData;
  final String? tooltip;

  const CreateHabitFAB({
    super.key,
    this.prefilledData,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        context.push('/create-habit', extra: prefilledData);
      },
      tooltip: tooltip ?? 'Create New Habit',
      child: const Icon(Icons.add),
    );
  }
}

/// Extended floating action button variant for more prominent display
class CreateHabitExtendedFAB extends StatelessWidget {
  final Map<String, dynamic>? prefilledData;
  final String? label;

  const CreateHabitExtendedFAB({
    super.key,
    this.prefilledData,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        context.push('/create-habit', extra: prefilledData);
      },
      icon: const Icon(Icons.add),
      label: Text(label ?? 'Create Habit'),
    );
  }
}