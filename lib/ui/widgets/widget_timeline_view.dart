import 'package:flutter/material.dart';
import '../../domain/model/habit.dart';

/// Widget UI component that represents a habit timeline suitable for home screen widgets
class WidgetTimelineView extends StatelessWidget {
  final List<Habit> habits;
  final DateTime selectedDate;
  final String themeMode;
  final Color primaryColor;
  final Habit? nextHabit;
  final VoidCallback? onRefresh;
  final Function(String habitId)? onHabitComplete;
  final Function(String route)? onNavigate;

  const WidgetTimelineView({
    super.key,
    required this.habits,
    required this.selectedDate,
    required this.themeMode,
    required this.primaryColor,
    this.nextHabit,
    this.onRefresh,
    this.onHabitComplete,
    this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = themeMode == 'dark';
    final backgroundColor = isDarkMode ? const Color(0xFF121212) : Colors.white;
    final surfaceColor =
        isDarkMode ? const Color(0xFF1E1E1E) : const Color(0xFFF5F5F5);
    final textColor = isDarkMode ? Colors.white : Colors.black87;

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(textColor, surfaceColor),
          if (nextHabit != null)
            _buildNextHabitSection(textColor, surfaceColor),
          Expanded(child: _buildHabitsList(textColor, surfaceColor)),
        ],
      ),
    );
  }

  Widget _buildHeader(Color textColor, Color surfaceColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.timeline,
            color: primaryColor,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Habit Timeline',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _formatDate(selectedDate),
                  style: TextStyle(
                    color: textColor.withValues(alpha: 0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          if (onRefresh != null)
            GestureDetector(
              onTap: onRefresh,
              child: Icon(
                Icons.refresh,
                color: primaryColor,
                size: 18,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNextHabitSection(Color textColor, Color surfaceColor) {
    if (nextHabit == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: primaryColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.schedule,
            color: primaryColor,
            size: 16,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Next: ${nextHabit!.name}',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (_getHabitTimeDisplay(nextHabit!).isNotEmpty)
                  Text(
                    _getHabitTimeDisplay(nextHabit!),
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHabitsList(Color textColor, Color surfaceColor) {
    if (habits.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              color: textColor.withValues(alpha: 0.5),
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              'No habits for today',
              style: TextStyle(
                color: textColor.withValues(alpha: 0.7),
                fontSize: 12,
              ),
            ),
            if (onNavigate != null)
              GestureDetector(
                onTap: () => onNavigate!('/create-habit'),
                child: Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Add Habit',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: habits.length,
      itemBuilder: (context, index) {
        final habit = habits[index];
        return _buildHabitItem(habit, textColor, surfaceColor);
      },
    );
  }

  Widget _buildHabitItem(Habit habit, Color textColor, Color surfaceColor) {
    final isCompleted = _isHabitCompletedOnDate(habit, selectedDate);
    final status = _getHabitStatus(habit, selectedDate);
    final statusColor = _getStatusColor(status);
    final timeDisplay = _getHabitTimeDisplay(habit);
    final canComplete = status == 'Due' && !isCompleted;

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Color(habit.colorValue).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Habit color indicator
          Container(
            width: 3,
            height: 24,
            decoration: BoxDecoration(
              color: Color(habit.colorValue),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),

          // Habit info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        habit.name,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          decoration:
                              isCompleted ? TextDecoration.lineThrough : null,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (timeDisplay.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Color(habit.colorValue).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          timeDisplay,
                          style: TextStyle(
                            color: Color(habit.colorValue),
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      habit.category,
                      style: TextStyle(
                        color: textColor.withValues(alpha: 0.6),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Action buttons
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (canComplete && onHabitComplete != null)
                GestureDetector(
                  onTap: () => onHabitComplete!(habit.id),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.green,
                      size: 16,
                    ),
                  ),
                ),
              const SizedBox(width: 4),
              if (onNavigate != null)
                GestureDetector(
                  onTap: () => onNavigate!('/edit-habit/${habit.id}'),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Icon(
                      Icons.edit,
                      color: primaryColor,
                      size: 16,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selectedDay = DateTime(date.year, date.month, date.day);

    if (selectedDay.isAtSameMomentAs(today)) {
      return 'Today';
    } else if (selectedDay
        .isAtSameMomentAs(today.add(const Duration(days: 1)))) {
      return 'Tomorrow';
    } else if (selectedDay
        .isAtSameMomentAs(today.subtract(const Duration(days: 1)))) {
      return 'Yesterday';
    } else {
      final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];
      return '${weekdays[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}';
    }
  }

  String _getHabitTimeDisplay(Habit habit) {
    switch (habit.frequency) {
      case HabitFrequency.hourly:
        if (habit.hourlyTimes.isNotEmpty) {
          if (habit.hourlyTimes.length == 1) {
            return habit.hourlyTimes.first;
          } else {
            return '${habit.hourlyTimes.first} +${habit.hourlyTimes.length - 1}';
          }
        }
        return 'Hourly';

      case HabitFrequency.single:
        if (habit.singleDateTime != null) {
          final hour = habit.singleDateTime!.hour.toString().padLeft(2, '0');
          final minute =
              habit.singleDateTime!.minute.toString().padLeft(2, '0');
          return '$hour:$minute';
        }
        return '';

      default:
        if (habit.notificationTime != null) {
          final hour = habit.notificationTime!.hour.toString().padLeft(2, '0');
          final minute =
              habit.notificationTime!.minute.toString().padLeft(2, '0');
          return '$hour:$minute';
        }
        return '';
    }
  }

  bool _isHabitCompletedOnDate(Habit habit, DateTime date) {
    return habit.completions.any((completion) {
      final completionDate = DateTime(
        completion.year,
        completion.month,
        completion.day,
      );
      return completionDate
          .isAtSameMomentAs(DateTime(date.year, date.month, date.day));
    });
  }

  String _getHabitStatus(Habit habit, DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selectedDay = DateTime(date.year, date.month, date.day);

    if (_isHabitCompletedOnDate(habit, date)) {
      return 'Completed';
    }

    if (selectedDay.isBefore(today)) {
      return 'Missed';
    } else if (selectedDay.isAfter(today)) {
      return 'Upcoming';
    } else {
      return 'Due';
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Completed':
        return Colors.green;
      case 'Missed':
        return Colors.red;
      case 'Due':
        return Colors.orange;
      case 'Upcoming':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}

/// Compact widget view for smaller widget sizes
class CompactWidgetTimelineView extends StatelessWidget {
  final List<Habit> habits;
  final DateTime selectedDate;
  final String themeMode;
  final Color primaryColor;
  final Habit? nextHabit;
  final VoidCallback? onRefresh;
  final Function(String habitId)? onHabitComplete;
  final Function(String route)? onNavigate;

  const CompactWidgetTimelineView({
    super.key,
    required this.habits,
    required this.selectedDate,
    required this.themeMode,
    required this.primaryColor,
    this.nextHabit,
    this.onRefresh,
    this.onHabitComplete,
    this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = themeMode == 'dark';
    final backgroundColor = isDarkMode ? const Color(0xFF121212) : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black87;

    final dueHabits = habits
        .where((habit) {
          final status = _getHabitStatus(habit, selectedDate);
          return status == 'Due' &&
              !_isHabitCompletedOnDate(habit, selectedDate);
        })
        .take(3)
        .toList();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.timeline, color: primaryColor, size: 16),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Habits',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (onNavigate != null)
                GestureDetector(
                  onTap: () => onNavigate!('/timeline'),
                  child: Icon(
                    Icons.open_in_new,
                    color: primaryColor,
                    size: 14,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          if (dueHabits.isEmpty)
            Center(
              child: Text(
                'All habits completed!',
                style: TextStyle(
                  color: textColor.withValues(alpha: 0.7),
                  fontSize: 11,
                ),
              ),
            )
          else
            ...dueHabits
                .map((habit) => _buildCompactHabitItem(habit, textColor)),
          if (dueHabits.length < habits.length)
            Text(
              '+${habits.length - dueHabits.length} more habits',
              style: TextStyle(
                color: textColor.withValues(alpha: 0.6),
                fontSize: 10,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCompactHabitItem(Habit habit, Color textColor) {
    final timeDisplay = _getHabitTimeDisplay(habit);

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Container(
            width: 2,
            height: 16,
            decoration: BoxDecoration(
              color: Color(habit.colorValue),
              borderRadius: BorderRadius.circular(1),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              habit.name,
              style: TextStyle(
                color: textColor,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (timeDisplay.isNotEmpty)
            Text(
              timeDisplay,
              style: TextStyle(
                color: Color(habit.colorValue),
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          const SizedBox(width: 4),
          if (onHabitComplete != null)
            GestureDetector(
              onTap: () => onHabitComplete!(habit.id),
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.green,
                  size: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _getHabitTimeDisplay(Habit habit) {
    switch (habit.frequency) {
      case HabitFrequency.hourly:
        if (habit.hourlyTimes.isNotEmpty) {
          return habit.hourlyTimes.first;
        }
        return '';

      case HabitFrequency.single:
        if (habit.singleDateTime != null) {
          final hour = habit.singleDateTime!.hour.toString().padLeft(2, '0');
          final minute =
              habit.singleDateTime!.minute.toString().padLeft(2, '0');
          return '$hour:$minute';
        }
        return '';

      default:
        if (habit.notificationTime != null) {
          final hour = habit.notificationTime!.hour.toString().padLeft(2, '0');
          final minute =
              habit.notificationTime!.minute.toString().padLeft(2, '0');
          return '$hour:$minute';
        }
        return '';
    }
  }

  bool _isHabitCompletedOnDate(Habit habit, DateTime date) {
    return habit.completions.any((completion) {
      final completionDate = DateTime(
        completion.year,
        completion.month,
        completion.day,
      );
      return completionDate
          .isAtSameMomentAs(DateTime(date.year, date.month, date.day));
    });
  }

  String _getHabitStatus(Habit habit, DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selectedDay = DateTime(date.year, date.month, date.day);

    if (_isHabitCompletedOnDate(habit, date)) {
      return 'Completed';
    }

    if (selectedDay.isBefore(today)) {
      return 'Missed';
    } else if (selectedDay.isAfter(today)) {
      return 'Upcoming';
    } else {
      return 'Due';
    }
  }
}
