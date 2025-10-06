import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../data/database_isar.dart';
import '../../domain/model/habit.dart';
import '../../services/calendar_service.dart';
import '../../services/rrule_service.dart';
import '../widgets/day_detail_sheet.dart';
import '../widgets/category_filter_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/create_habit_fab.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
  }

  void _onDayTapped(DateTime day, List<Habit> habits) {
    final dayHabits = _getEventsForDay(day, habits);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DayDetailSheet(
        selectedDay: day,
        habits: dayHabits,
        onHabitToggle: (habit) => _toggleHabitCompletion(habit, day),
      ),
    );
  }

  Future<void> _toggleHabitCompletion(Habit habit, DateTime day) async {
    try {
      final habitService = ref.read(habitServiceIsarProvider).value;
      if (habitService != null) {
        final isCompleted = _isHabitCompletedOnDate(habit, day);
        if (isCompleted) {
          await habitService.removeHabitCompletion(habit.id, day);
        } else {
          await habitService.markHabitComplete(habit.id, day);
        }

        // Sync changes to calendar (syncHabitChanges handles the enabled check internally)
        await CalendarService.syncHabitChanges(habit);

        setState(() {}); // Refresh the calendar
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating habit: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  List<Habit> _getEventsForDay(DateTime day, List<Habit> habits) {
    return habits.where((habit) => _isHabitDueOnDate(habit, day)).toList();
  }

  bool _isHabitDueOnDate(Habit habit, DateTime date) {
    final habitDate = DateTime(
        habit.createdAt.year, habit.createdAt.month, habit.createdAt.day);
    final checkDate = DateTime(date.year, date.month, date.day);

    // Don't show habits before they were created
    if (checkDate.isBefore(habitDate)) return false;

    // Phase 4: Use RRule if available, otherwise fall back to legacy frequency
    if (habit.usesRRule && habit.rruleString != null) {
      try {
        // Use dtStart if available, otherwise fall back to createdAt
        // This is critical for interval-based RRules (e.g., bi-weekly)
        final startDate = habit.dtStart ?? habit.createdAt;
        return RRuleService.isDueOnDate(
          rruleString: habit.rruleString!,
          startDate: startDate,
          checkDate: checkDate,
        );
      } catch (e) {
        debugPrint(
            '⚠️ RRule check failed for calendar, falling back to legacy: $e');
        // Fall through to legacy logic
      }
    }

    // Legacy frequency-based logic
    switch (habit.frequency) {
      case HabitFrequency.daily:
        return true;

      case HabitFrequency.weekly:
        // Check if the day of week is in the selected weekdays
        if (habit.selectedWeekdays.isEmpty) {
          // Fallback: if no weekdays selected, use the creation day
          return checkDate.weekday == habitDate.weekday;
        }
        // Use DateTime.weekday directly (1=Monday, 7=Sunday) - matches storage format
        return habit.selectedWeekdays.contains(checkDate.weekday);

      case HabitFrequency.monthly:
        // Check if the day of month is in the selected month days
        if (habit.selectedMonthDays.isEmpty) {
          // Fallback: if no days selected, use the creation day
          return checkDate.day == habitDate.day;
        }
        return habit.selectedMonthDays.contains(checkDate.day);

      case HabitFrequency.hourly:
        // Hourly habits should only appear on days when they have scheduled times
        // and only if there are selected weekdays (days of week when hourly habit applies)
        if (habit.selectedWeekdays.isEmpty || habit.hourlyTimes.isEmpty) {
          return false; // No schedule set up
        }
        // Use DateTime.weekday directly (1=Monday, 7=Sunday) - matches storage format
        return habit.selectedWeekdays.contains(checkDate.weekday);

      case HabitFrequency.yearly:
        // Check if the date is in the selected yearly dates
        if (habit.selectedYearlyDates.isEmpty) {
          // Fallback: use creation date but only show on or after the anniversary
          final currentYear = checkDate.year;
          return checkDate.month == habitDate.month &&
              checkDate.day == habitDate.day &&
              currentYear >= habitDate.year;
        }
        // For yearly habits, we need to check if the month-day combination matches any selected date
        return habit.selectedYearlyDates.any((selectedDate) {
          final parts = selectedDate.split('-');
          if (parts.length == 3) {
            final selectedMonth = int.tryParse(parts[1]);
            final selectedDay = int.tryParse(parts[2]);
            final selectedYear = int.tryParse(parts[0]);
            if (selectedMonth != null &&
                selectedDay != null &&
                selectedYear != null) {
              // Only show if the date is on or after the selected year
              return selectedMonth == checkDate.month &&
                  selectedDay == checkDate.day &&
                  checkDate.year >= selectedYear;
            }
          }
          return false;
        });

      case HabitFrequency.single:
        // Single habits only appear on their specific date
        if (habit.singleDateTime == null) return false;
        final singleDate = habit.singleDateTime!;
        return checkDate.year == singleDate.year &&
            checkDate.month == singleDate.month &&
            checkDate.day == singleDate.day;
    }
  }

  bool _isHabitCompletedOnDate(Habit habit, DateTime date) {
    return habit.completions.any((completedDate) =>
        completedDate.year == date.year &&
        completedDate.month == date.month &&
        completedDate.day == date.day);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).textTheme.titleLarge?.color,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Calendar'),
            FutureBuilder<bool>(
              future: CalendarService.isCalendarSyncEnabled(),
              builder: (context, snapshot) {
                final syncEnabled = snapshot.data ?? false;
                if (syncEnabled) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: Colors.green.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.sync,
                              size: 14,
                              color: Colors.green.shade700,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Synced',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.green.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          CategoryFilterWidget(
            selectedCategory: _selectedCategory,
            onCategoryChanged: (value) {
              setState(() {
                _selectedCategory = value;
              });
            },
          ),
        ],
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final habitServiceAsync = ref.watch(habitServiceIsarProvider);

          return habitServiceAsync.when(
            data: (habitService) => FutureBuilder<List<Habit>>(
              future: habitService.getAllHabits(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingWidget(message: 'Loading calendar...');
                }

                if (!snapshot.hasData) {
                  return const Center(
                    child: Text('No habits found'),
                  );
                }

                final allHabits = snapshot.data!;
                final filteredHabits = _selectedCategory == 'All'
                    ? allHabits
                    : allHabits
                        .where((habit) => habit.category == _selectedCategory)
                        .toList();

                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _buildCalendar(filteredHabits),
                        const SizedBox(height: 24),
                        _buildInstructions(),
                      ],
                    ),
                  ),
                );
              },
            ),
            loading: () => const LoadingWidget(message: 'Loading calendar...'),
            error: (error, stackTrace) => Center(
              child: Text(
                'Error: $error',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        },
      ),
      floatingActionButton: const CreateHabitFAB(),
    );
  }

  Widget _buildCalendar(List<Habit> habits) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildCalendarHeader(),
            const SizedBox(height: 20),
            _buildCustomCalendar(habits),
            const SizedBox(height: 16),
            _buildLegend(),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {
            setState(() {
              _focusedDay = DateTime(_focusedDay.year, _focusedDay.month - 1);
            });
          },
          icon: Icon(
            Icons.chevron_left,
            size: 28,
            color: Theme.of(context).primaryColor,
          ),
        ),
        Text(
          DateFormat('MMMM yyyy').format(_focusedDay),
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + 1);
            });
          },
          icon: Icon(
            Icons.chevron_right,
            size: 28,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildLegendItem(Colors.green, 'All Complete'),
        _buildLegendItem(Colors.orange, 'Partial'),
        _buildLegendItem(Colors.red.shade300, 'Pending'),
        _buildLegendItem(Colors.grey.shade300, 'No Habits'),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
        ),
      ],
    );
  }

  Widget _buildCustomCalendar(List<Habit> habits) {
    final firstDayOfMonth = DateTime(_focusedDay.year, _focusedDay.month, 1);
    final startDate =
        firstDayOfMonth.subtract(Duration(days: firstDayOfMonth.weekday % 7));

    return Column(
      children: [
        // Weekday headers
        Row(
          children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
              .map((day) => Expanded(
                    child: Center(
                      child: Text(
                        day,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.color
                              ?.withValues(alpha: 0.7),
                        ),
                      ),
                    ),
                  ))
              .toList(),
        ),
        const SizedBox(height: 12),
        // Calendar grid
        ...List.generate(6, (weekIndex) {
          final weekStart = startDate.add(Duration(days: weekIndex * 7));
          final weekDays = List.generate(
              7, (dayIndex) => weekStart.add(Duration(days: dayIndex)));

          // Skip empty weeks
          if (weekDays.every((day) =>
              day.month != _focusedDay.month &&
              (weekIndex == 0 || weekIndex == 5))) {
            return const SizedBox.shrink();
          }

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: weekDays
                  .map((day) => Expanded(child: _buildCalendarDay(day, habits)))
                  .toList(),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildCalendarDay(DateTime day, List<Habit> habits) {
    final isCurrentMonth = day.month == _focusedDay.month;
    final isToday = isSameDay(day, DateTime.now());
    final events = _getEventsForDay(day, habits);
    final completedCount =
        events.where((habit) => _isHabitCompletedOnDate(habit, day)).length;
    final totalCount = events.length;

    Color backgroundColor = Colors.transparent;
    Color textColor =
        Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black87;
    Color? indicatorColor;

    if (!isCurrentMonth) {
      textColor = textColor.withValues(alpha: 0.3);
    } else if (totalCount > 0) {
      if (completedCount == totalCount) {
        indicatorColor = Colors.green;
      } else if (completedCount > 0) {
        indicatorColor = Colors.orange;
      } else {
        indicatorColor = Colors.red.shade300;
      }
    }

    if (isToday) {
      backgroundColor = Theme.of(context).primaryColor.withValues(alpha: 0.1);
      textColor = Theme.of(context).primaryColor;
    }

    return GestureDetector(
      onTap: isCurrentMonth ? () => _onDayTapped(day, habits) : null,
      child: Container(
        height: 48,
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: isToday
              ? Border.all(color: Theme.of(context).primaryColor, width: 2)
              : null,
        ),
        child: Stack(
          children: [
            Center(
              child: Text(
                '${day.day}',
                style: TextStyle(
                  color: textColor,
                  fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                  fontSize: 16,
                ),
              ),
            ),
            if (indicatorColor != null)
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: indicatorColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            if (totalCount > 0)
              Positioned(
                bottom: 2,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    '$completedCount/$totalCount',
                    style: TextStyle(
                      fontSize: 10,
                      color: textColor.withValues(alpha: 0.7),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: Theme.of(context).primaryColor,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Tap on any date to view and manage your habits for that day',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyMedium?.color,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
