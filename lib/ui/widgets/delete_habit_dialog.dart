import 'package:flutter/material.dart';

/// Custom dialog for habit deletion with option to archive completion data
class DeleteHabitDialog extends StatefulWidget {
  final String habitName;
  final bool hasCompletions;

  const DeleteHabitDialog({
    super.key,
    required this.habitName,
    required this.hasCompletions,
  });

  @override
  State<DeleteHabitDialog> createState() => _DeleteHabitDialogState();
}

class _DeleteHabitDialogState extends State<DeleteHabitDialog> {
  bool _archiveCompletions = true;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Habit'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Are you sure you want to delete "${widget.habitName}"?'),
          if (widget.hasCompletions) ...[
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              children: [
                Checkbox(
                  value: _archiveCompletions,
                  onChanged: (value) {
                    setState(() {
                      _archiveCompletions = value ?? true;
                    });
                  },
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _archiveCompletions = !_archiveCompletions;
                      });
                    },
                    child: const Text(
                      'Keep completion history for analytics',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
            if (_archiveCompletions)
              Padding(
                padding: const EdgeInsets.only(left: 48, top: 4),
                child: Text(
                  'Your progress data will be preserved even after deletion',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(null),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(
            DeleteHabitResult(
              confirmed: true,
              archiveCompletions: _archiveCompletions,
            ),
          ),
          style: TextButton.styleFrom(foregroundColor: Colors.red),
          child: const Text('Delete'),
        ),
      ],
    );
  }
}

/// Result from the delete habit dialog
class DeleteHabitResult {
  final bool confirmed;
  final bool archiveCompletions;

  DeleteHabitResult({
    required this.confirmed,
    required this.archiveCompletions,
  });
}
