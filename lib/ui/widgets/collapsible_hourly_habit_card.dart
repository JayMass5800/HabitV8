import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/model/habit.dart';
import '../../data/database_isar.dart';
import '../screens/edit_habit_screen.dart';

class CollapsibleHourlyHabitCard extends ConsumerStatefulWidget {
  final Habit habit;
  final DateTime selectedDate;
  final Function(Habit, TimeOfDay) onToggleHourlyCompletion;
  final Function(Habit, DateTime, TimeOfDay) isHourlyHabitCompletedAtTime;
  final String Function(Habit, DateTime) getHabitStatus;
  final Color Function(String) getStatusColor;

  const CollapsibleHourlyHabitCard({
    super.key,
    required this.habit,
    required this.selectedDate,
    required this.onToggleHourlyCompletion,
    required this.isHourlyHabitCompletedAtTime,
    required this.getHabitStatus,
    required this.getStatusColor,
  });

  @override
  ConsumerState<CollapsibleHourlyHabitCard> createState() =>
      _CollapsibleHourlyHabitCardState();
}

class _CollapsibleHourlyHabitCardState
    extends ConsumerState<CollapsibleHourlyHabitCard>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  List<TimeOfDay> _getTimeSlots() {
    return widget.habit.hourlyTimes.map((timeStr) {
      final timeParts = timeStr.split(':');
      if (timeParts.length == 2) {
        final hour = int.tryParse(timeParts[0]);
        final minute = int.tryParse(timeParts[1]);
        if (hour != null && minute != null) {
          return TimeOfDay(hour: hour, minute: minute);
        }
      }
      return TimeOfDay.now(); // fallback
    }).toList()
      ..sort((a, b) {
        if (a.hour != b.hour) return a.hour.compareTo(b.hour);
        return a.minute.compareTo(b.minute);
      });
  }

  int _getCompletedCount() {
    final timeSlots = _getTimeSlots();
    return timeSlots
        .where(
          (timeSlot) => widget.isHourlyHabitCompletedAtTime(
            widget.habit,
            widget.selectedDate,
            timeSlot,
          ),
        )
        .length;
  }

  double _getCompletionPercentage() {
    final timeSlots = _getTimeSlots();
    if (timeSlots.isEmpty) return 0.0;
    return _getCompletedCount() / timeSlots.length;
  }

  @override
  Widget build(BuildContext context) {
    final timeSlots = _getTimeSlots();
    final completedCount = _getCompletedCount();
    final totalCount = timeSlots.length;
    final completionPercentage = _getCompletionPercentage();
    final status = widget.getHabitStatus(widget.habit, widget.selectedDate);
    final statusColor = widget.getStatusColor(status);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          // Main card header
          InkWell(
            onTap: _toggleExpanded,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Color indicator
                  Container(
                    width: 4,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Color(widget.habit.colorValue),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Habit info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.habit.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                            // Completion indicator
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: statusColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '$completedCount/$totalCount',
                                style: TextStyle(
                                  color: statusColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),

                        if (widget.habit.description != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            widget.habit.description!,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: Colors.grey[600]),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],

                        const SizedBox(height: 8),

                        // Progress bar and category
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Progress bar
                                  LinearProgressIndicator(
                                    value: completionPercentage,
                                    backgroundColor: Colors.grey[300],
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Color(widget.habit.colorValue),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  // Category and frequency info
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Color(
                                            widget.habit.colorValue,
                                          ).withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Text(
                                          widget.habit.category,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                color: Color(
                                                  widget.habit.colorValue,
                                                ),
                                                fontWeight: FontWeight.w500,
                                              ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.purple.withValues(
                                            alpha: 0.1,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Text(
                                          'Hourly',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                color: Colors.purple,
                                                fontWeight: FontWeight.w500,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Actions menu
                  PopupMenuButton<String>(
                    onSelected: (value) => _handleAction(context, value),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 20),
                            SizedBox(width: 8),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 20, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Delete', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Expand/collapse icon
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: Icon(Icons.expand_more, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ),

          // Expandable time slots section
          SizeTransition(
            sizeFactor: _expandAnimation,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(12),
                ),
              ),
              child: Column(
                children: [
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Time Slots',
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[700],
                                  ),
                        ),
                        const SizedBox(height: 12),

                        // Time slots grid
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: timeSlots.map((timeSlot) {
                            final isCompleted =
                                widget.isHourlyHabitCompletedAtTime(
                              widget.habit,
                              widget.selectedDate,
                              timeSlot,
                            );

                            return InkWell(
                              onTap: () => widget.onToggleHourlyCompletion(
                                widget.habit,
                                timeSlot,
                              ),
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: isCompleted
                                      ? Color(widget.habit.colorValue)
                                      : Colors.white,
                                  border: Border.all(
                                    color: isCompleted
                                        ? Color(widget.habit.colorValue)
                                        : Colors.grey[300]!,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      isCompleted
                                          ? Icons.check_circle
                                          : Icons.radio_button_unchecked,
                                      size: 16,
                                      color: isCompleted
                                          ? Colors.white
                                          : Colors.grey[600],
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      timeSlot.format(context),
                                      style: TextStyle(
                                        color: isCompleted
                                            ? Colors.white
                                            : Colors.grey[800],
                                        fontWeight: isCompleted
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),

                        // Summary at bottom
                        if (timeSlots.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: completionPercentage == 1.0
                                  ? Colors.green.withValues(alpha: 0.1)
                                  : Colors.blue.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  completionPercentage == 1.0
                                      ? Icons.check_circle
                                      : Icons.schedule,
                                  size: 16,
                                  color: completionPercentage == 1.0
                                      ? Colors.green
                                      : Colors.blue,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    completionPercentage == 1.0
                                        ? 'All time slots completed!'
                                        : '$completedCount of $totalCount time slots completed',
                                    style: TextStyle(
                                      color: completionPercentage == 1.0
                                          ? Colors.green[700]
                                          : Colors.blue[700],
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                                Text(
                                  '${(completionPercentage * 100).toInt()}%',
                                  style: TextStyle(
                                    color: completionPercentage == 1.0
                                        ? Colors.green[700]
                                        : Colors.blue[700],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleAction(BuildContext context, String action) {
    switch (action) {
      case 'edit':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => EditHabitScreen(habit: widget.habit),
          ),
        );
        break;
      case 'delete':
        _showDeleteConfirmation(context);
        break;
    }
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Habit'),
          content: Text(
            'Are you sure you want to delete "${widget.habit.name}"? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _deleteHabit();
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteHabit() async {
    try {
      final habitServiceAsync = ref.read(habitServiceIsarProvider);
      await habitServiceAsync.when(
        data: (habitService) async {
          await habitService.deleteHabit(widget.habit.id);
          // Force UI refresh by invalidating the provider
          ref.invalidate(habitServiceIsarProvider);

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${widget.habit.name} deleted successfully'),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        loading: () {},
        error: (error, stack) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error deleting habit: $error'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting habit: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
