import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../data/database_isar.dart';
import '../../domain/model/habit.dart';
import '../../services/calendar_service.dart';
import '../../services/rrule_service.dart';
import '../../services/time_service.dart';
import '../../utils/date_utils.dart';
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
  DateTime _focusedDay = TimeService.instance.nowLocal();
  DateTime? _selectedDay;
  String _selectedCategory = 'All';
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  void _onDaySelected(
      DateTime selectedDay, DateTime focusedDay, List<Habit> habits) {
    // Normalize the date to start of day to avoid timezone issues
    final normalizedDay = DateTimeUtils.startOfDay(selectedDay);
    final dayHabits = _getEventsForDay(normalizedDay, habits);

    setState(() {
      _selectedDay = normalizedDay;
      _focusedDay = focusedDay;
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DayDetailSheet(
        selectedDay: normalizedDay,
        habits: dayHabits,
        onHabitToggle: (habit) => _toggleHabitCompletion(habit, normalizedDay),
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
    // Normalize dates to start of day for consistent comparisons
    final habitDate = DateTimeUtils.startOfDay(habit.createdAt);
    final checkDate = DateTimeUtils.startOfDay(date);

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
    // Use DateTimeUtils.isSameDay for consistent date comparison
    return habit.completions
        .any((completedDate) => DateTimeUtils.isSameDay(completedDate, date));
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
          // 🔔 REACTIVE: Watch habits stream for instant calendar updates!
          // Calendar now updates automatically when habits are added/completed/deleted
          final habitsAsync = ref.watch(habitsStreamIsarProvider);

          return habitsAsync.when(
            data: (allHabits) {
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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) {
                return _selectedDay != null && isSameDay(_selectedDay!, day);
              },
              calendarFormat: _calendarFormat,
              startingDayOfWeek: StartingDayOfWeek.sunday,
              availableCalendarFormats: const {
                CalendarFormat.month: 'Month',
                CalendarFormat.twoWeeks: '2 weeks',
                CalendarFormat.week: 'Week',
              },
              calendarStyle: CalendarStyle(
                // Today's date styling - improved visibility for dark theme
                todayDecoration: BoxDecoration(
                  color: isDarkMode
                      ? primaryColor.withValues(alpha: 0.4)
                      : primaryColor.withValues(alpha: 0.25),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDarkMode
                        ? primaryColor.withValues(alpha: 0.9)
                        : primaryColor,
                    width: 2.5,
                  ),
                ),
                todayTextStyle: TextStyle(
                  color: isDarkMode ? Colors.white : primaryColor,
                  fontWeight: FontWeight.bold,
                ),
                // Selected day styling
                selectedDecoration: BoxDecoration(
                  color: primaryColor,
                  shape: BoxShape.circle,
                ),
                selectedTextStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                // Default day styling
                defaultTextStyle: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
                // Weekend styling
                weekendTextStyle: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
                // Outside month styling
                outsideTextStyle: TextStyle(
                  color: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.color
                      ?.withValues(alpha: 0.3),
                ),
                // Marker styling
                markerDecoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                ),
                markersMaxCount: 1,
                cellMargin: const EdgeInsets.all(4),
                cellPadding: const EdgeInsets.all(0),
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: true,
                titleCentered: true,
                formatButtonShowsNext: false,
                formatButtonDecoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                formatButtonTextStyle: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w600,
                ),
                leftChevronIcon: Icon(
                  Icons.chevron_left,
                  color: Theme.of(context).primaryColor,
                ),
                rightChevronIcon: Icon(
                  Icons.chevron_right,
                  color: Theme.of(context).primaryColor,
                ),
                titleTextStyle:
                    Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ) ??
                        const TextStyle(fontWeight: FontWeight.bold),
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: TextStyle(
                  color: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.color
                      ?.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w600,
                ),
                weekendStyle: TextStyle(
                  color: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.color
                      ?.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w600,
                ),
              ),
              // Event loader for showing markers
              eventLoader: (day) {
                return _getEventsForDay(day, habits);
              },
              // Custom builders for day cells
              calendarBuilders: CalendarBuilders(
                // Custom day cell builder with completion counts and color indicators
                defaultBuilder: (context, day, focusedDay) {
                  return _buildTableCalendarDay(day, habits, false, false);
                },
                selectedBuilder: (context, day, focusedDay) {
                  return _buildTableCalendarDay(day, habits, true, false);
                },
                todayBuilder: (context, day, focusedDay) {
                  return _buildTableCalendarDay(day, habits, false, true);
                },
                outsideBuilder: (context, day, focusedDay) {
                  return _buildTableCalendarDay(day, habits, false, false,
                      isOutside: true);
                },
              ),
              onDaySelected: (selectedDay, focusedDay) {
                _onDaySelected(selectedDay, focusedDay, habits);
              },
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              onPageChanged: (focusedDay) {
                setState(() {
                  _focusedDay = focusedDay;
                });
              },
            ),
            const SizedBox(height: 16),
            _buildLegend(),
          ],
        ),
      ),
    );
  }

  Widget _buildTableCalendarDay(
    DateTime day,
    List<Habit> habits,
    bool isSelected,
    bool isToday, {
    bool isOutside = false,
  }) {
    final events = _getEventsForDay(day, habits);
    final completedCount =
        events.where((habit) => _isHabitCompletedOnDate(habit, day)).length;
    final totalCount = events.length;

    Color backgroundColor = Colors.transparent;
    Color textColor =
        Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black87;
    Color? indicatorColor;

    if (isOutside) {
      textColor = textColor.withValues(alpha: 0.3);
    } else if (totalCount > 0) {
      if (completedCount == totalCount) {
        indicatorColor = Colors.green;
        backgroundColor = Colors.green.withValues(alpha: 0.1);
      } else if (completedCount > 0) {
        indicatorColor = Colors.orange;
        backgroundColor = Colors.orange.withValues(alpha: 0.1);
      } else {
        indicatorColor = Colors.red.shade300;
        backgroundColor = Colors.red.shade300.withValues(alpha: 0.1);
      }
    }

    // Determine if we're in dark mode for better contrast adjustments
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;

    if (isToday) {
      // Use a more visible background for today in both themes
      backgroundColor = isDarkMode
          ? primaryColor.withValues(alpha: 0.4)
          : primaryColor.withValues(alpha: 0.25);
      // Use a contrasting text color that's visible in both themes
      textColor = isDarkMode ? Colors.white : primaryColor;
    }

    if (isSelected) {
      // Selected day should be most prominent
      backgroundColor = primaryColor.withValues(alpha: isDarkMode ? 0.5 : 0.35);
      textColor = isDarkMode ? Colors.white : primaryColor;
    }

    return Container(
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: isToday
            ? Border.all(
                color: isDarkMode
                    ? primaryColor.withValues(alpha: 0.9)
                    : primaryColor,
                width: 2.5,
              )
            : null,
      ),
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${day.day}',
                  style: TextStyle(
                    color: textColor,
                    fontWeight: isToday || isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    fontSize: 16,
                  ),
                ),
                if (totalCount > 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      '$completedCount/$totalCount',
                      style: TextStyle(
                        fontSize: 10,
                        color: textColor.withValues(alpha: 0.7),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
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
        ],
      ),
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
              'Tap on any date to view and manage your habits for that day. Use the format button to switch between month, 2-week, and week views.',
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
}
