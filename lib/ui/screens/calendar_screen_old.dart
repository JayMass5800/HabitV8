import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../../data/database.dart';
import '../../domain/model/habit.dart';
import '../../services/calendar_service.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  late final ValueNotifier<List<Habit>> _selectedHabits;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  String _selectedCategory = 'All';
  bool _calendarSyncEnabled = false;

  final List<String> _categories = [
    'All',
    'Health',
    'Fitness',
    'Productivity',
    'Learning',
    'Personal',
    'Social',
    'Finance',
    'Mindfulness',
  ];

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _selectedHabits = ValueNotifier(_getHabitsForDay(_selectedDay!));
    _loadCalendarSyncStatus();
  }

  Future<void> _loadCalendarSyncStatus() async {
    try {
      final syncEnabled = await CalendarService.isCalendarSyncEnabled();
      if (mounted) {
        setState(() {
          _calendarSyncEnabled = syncEnabled;
        });
      }
    } catch (e) {
      // Ignore errors, just use default false value
    }
  }

  @override
  void dispose() {
    _selectedHabits.dispose();
    super.dispose();
  }

  List<Habit> _getHabitsForDay(DateTime day) {
    // This will be populated with actual habits from the database
    return [];
  }

  List<Habit> _getEventsForDay(DateTime day, List<Habit> allHabits) {
    return allHabits.where((habit) => _isHabitDueOnDate(habit, day)).toList();
  }

  bool _isHabitDueOnDate(Habit habit, DateTime date) {
    switch (habit.frequency) {
      case HabitFrequency.hourly:
        final weekday = date.weekday;
        // Check both old and new fields for backward compatibility
        return habit.selectedWeekdays.contains(weekday) ||
            habit.weeklySchedule.contains(weekday);
      case HabitFrequency.daily:
        return true;
      case HabitFrequency.weekly:
        final weekday = date.weekday;
        // Check both old and new fields for backward compatibility
        return habit.selectedWeekdays.contains(weekday) ||
            habit.weeklySchedule.contains(weekday);
      case HabitFrequency.monthly:
        final day = date.day;
        // Check both old and new fields for backward compatibility
        return habit.selectedMonthDays.contains(day) ||
            habit.monthlySchedule.contains(day);
      case HabitFrequency.yearly:
        return habit.selectedYearlyDates.any((dateStr) {
          final parts = dateStr.split('-');
          if (parts.length == 3) {
            final month = int.parse(parts[1]);
            final day = int.parse(parts[2]);
            return month == date.month && day == date.day;
          }
          return false;
        });
    }
  }

  bool _isHabitCompletedOnDate(Habit habit, DateTime date) {
    final dateOnly = DateTime(date.year, date.month, date.day);
    return habit.completions.any((completion) {
      final completionDate = DateTime(
        completion.year,
        completion.month,
        completion.day,
      );
      return completionDate == dateOnly;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('Habit Calendar'),
            if (_calendarSyncEnabled) ...[
              const SizedBox(width: 8),
              Tooltip(
                message: 'Calendar sync enabled',
                child: Icon(Icons.sync, size: 16, color: Colors.green.shade600),
              ),
            ],
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _selectedCategory = value;
              });
            },
            itemBuilder: (BuildContext context) {
              return _categories.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Row(
                    children: [
                      if (choice == _selectedCategory)
                        const Icon(Icons.check, size: 20),
                      if (choice == _selectedCategory) const SizedBox(width: 8),
                      Text(choice),
                    ],
                  ),
                );
              }).toList();
            },
            child: const Icon(Icons.filter_list),
          ),
        ],
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final habitServiceAsync = ref.watch(habitServiceProvider);

          return habitServiceAsync.when(
            data: (habitService) => FutureBuilder<List<Habit>>(
              future: habitService.getAllHabits(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData) {
                  return const Center(child: Text('No habits found'));
                }

                final allHabits = snapshot.data!;
                final filteredHabits = _selectedCategory == 'All'
                    ? allHabits
                    : allHabits
                          .where((habit) => habit.category == _selectedCategory)
                          .toList();

                return Column(
                  children: [
                    _buildCalendar(filteredHabits),
                    const SizedBox(height: 8.0),
                    Expanded(child: _buildHabitsList(filteredHabits)),
                  ],
                );
              },
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => Center(
              child: Text(
                'Error: $error',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCalendar(List<Habit> habits) {
    return Card(
      margin: const EdgeInsets.all(12.0),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildCalendarHeader(),
            const SizedBox(height: 16),
            _buildCustomCalendar(habits),
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
          icon: const Icon(Icons.chevron_left, size: 28),
        ),
        Column(
          children: [
            Text(
              DateFormat('MMMM yyyy').format(_focusedDay),
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildLegendItem(Colors.green, 'Completed'),
                const SizedBox(width: 16),
                _buildLegendItem(Colors.orange, 'Partial'),
                const SizedBox(width: 16),
                _buildLegendItem(Colors.red.shade300, 'Pending'),
              ],
            ),
          ],
        ),
        IconButton(
          onPressed: () {
            setState(() {
              _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + 1);
            });
          },
          icon: const Icon(Icons.chevron_right, size: 28),
        ),
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
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildCustomCalendar(List<Habit> habits) {
    final firstDayOfMonth = DateTime(_focusedDay.year, _focusedDay.month, 1);
    final startDate = firstDayOfMonth.subtract(
      Duration(days: firstDayOfMonth.weekday % 7),
    );

    return Column(
      children: [
        // Weekday headers
        Row(
          children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
              .map(
                (day) => Expanded(
                  child: Center(
                    child: Text(
                      day,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: day == 'Sun' || day == 'Sat'
                            ? Colors.red.shade600
                            : Colors.grey.shade700,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 8),
        // Calendar grid
        ...List.generate(6, (weekIndex) {
          final weekStart = startDate.add(Duration(days: weekIndex * 7));
          final weekDays = List.generate(
            7,
            (dayIndex) => weekStart.add(Duration(days: dayIndex)),
          );

          // Skip empty weeks
          if (weekDays.every(
            (day) =>
                day.month != _focusedDay.month &&
                (weekIndex == 0 || weekIndex == 5),
          )) {
            return const SizedBox.shrink();
          }

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
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
    final isSelected = isSameDay(day, _selectedDay);
    final events = _getEventsForDay(day, habits);
    final completedCount = events
        .where((habit) => _isHabitCompletedOnDate(habit, day))
        .length;
    final totalCount = events.length;

    Color? backgroundColor;
    Color textColor = Colors.black87;

    if (isSelected) {
      backgroundColor = Theme.of(context).primaryColor;
      textColor = Colors.white;
    } else if (isToday) {
      backgroundColor = Theme.of(context).primaryColor.withValues(alpha: 0.2);
    }

    return GestureDetector(
      onTap: () => _onDaySelected(day, day),
      child: Container(
        height: 56,
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: isToday && !isSelected
              ? Border.all(color: Theme.of(context).primaryColor, width: 2)
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${day.day}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: isToday ? FontWeight.bold : FontWeight.w500,
                color: isCurrentMonth ? textColor : Colors.grey.shade400,
              ),
            ),
            if (totalCount > 0) ...[
              const SizedBox(height: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 20,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _getCompletionColor(completedCount, totalCount),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Center(
                      child: Text(
                        '$completedCount/$totalCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ] else if (totalCount == 0 && isCurrentMonth) ...[
              const SizedBox(height: 2),
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getCompletionColor(int completed, int total) {
    if (completed == 0) return Colors.red.shade300;
    if (completed == total) return Colors.green;
    return Colors.orange;
  }

  Widget _buildHabitsList(List<Habit> habits) {
    if (_selectedDay == null) {
      return const Center(
        child: Text(
          'Select a day to view habits',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    final selectedDayHabits = _getEventsForDay(_selectedDay!, habits);

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Header for selected day
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  DateFormat('EEEE, MMMM d, y').format(_selectedDay!),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (selectedDayHabits.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    '${selectedDayHabits.where((h) => _isHabitCompletedOnDate(h, _selectedDay!)).length} of ${selectedDayHabits.length} habits completed',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ],
              ],
            ),
          ),
          // Habits list
          Expanded(
            child: selectedDayHabits.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.free_breakfast_outlined,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No habits scheduled',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Enjoy your free day!',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: selectedDayHabits.length,
                    itemBuilder: (context, index) {
                      final habit = selectedDayHabits[index];
                      final isCompleted = _isHabitCompletedOnDate(
                        habit,
                        _selectedDay!,
                      );

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () => _toggleHabitCompletion(habit),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  // Habit color indicator
                                  Container(
                                    width: 6,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Color(habit.colorValue),
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  // Habit details
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          habit.name,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            decoration: isCompleted
                                                ? TextDecoration.lineThrough
                                                : null,
                                            color: isCompleted
                                                ? Colors.grey.shade600
                                                : Colors.black87,
                                          ),
                                        ),
                                        if (habit.description != null) ...[
                                          const SizedBox(height: 4),
                                          Text(
                                            habit.description!,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                        ],
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 4,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Color(
                                                  habit.colorValue,
                                                ).withValues(alpha: 0.15),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Text(
                                                habit.category,
                                                style: TextStyle(
                                                  color: Color(
                                                    habit.colorValue,
                                                  ),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 2,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade100,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                _getFrequencyDisplayName(
                                                  habit.frequency,
                                                ),
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  color: Colors.grey.shade600,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Completion status
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: isCompleted
                                          ? Colors.green
                                          : Colors.grey.shade200,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      isCompleted
                                          ? Icons.check
                                          : Icons.circle_outlined,
                                      color: isCompleted
                                          ? Colors.white
                                          : Colors.grey.shade500,
                                      size: 22,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
    }
  }

  String _getFrequencyDisplayName(HabitFrequency frequency) {
    switch (frequency) {
      case HabitFrequency.hourly:
        return 'Hourly';
      case HabitFrequency.daily:
        return 'Daily';
      case HabitFrequency.weekly:
        return 'Weekly';
      case HabitFrequency.monthly:
        return 'Monthly';
      case HabitFrequency.yearly:
        return 'Yearly';
    }
  }

  Future<void> _toggleHabitCompletion(Habit habit) async {
    if (_selectedDay == null) return;

    final habitService = ref.read(habitServiceProvider).value;
    if (habitService == null) return;

    try {
      final isCompleted = _isHabitCompletedOnDate(habit, _selectedDay!);

      if (isCompleted) {
        await habitService.removeHabitCompletion(habit.id, _selectedDay!);
      } else {
        await habitService.markHabitComplete(habit.id, _selectedDay!);
      }

      setState(() {
        // Trigger rebuild to update UI
      });

      // Sync changes if calendar sync is enabled
      if (_calendarSyncEnabled) {
        await CalendarService.syncHabitChanges(habit);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isCompleted ? 'Habit completion removed' : 'Habit completed! 🎉',
            ),
            backgroundColor: isCompleted ? Colors.orange : Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
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
}
