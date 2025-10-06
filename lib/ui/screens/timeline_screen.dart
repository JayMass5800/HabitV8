import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../data/database.dart';
import '../../domain/model/habit.dart';
import '../../services/rrule_service.dart';
import '../../services/logging_service.dart';
import '../widgets/category_filter_widget.dart';
import '../widgets/create_habit_fab.dart';
import '../widgets/smooth_transitions.dart';
import '../widgets/collapsible_hourly_habit_card.dart';

// Helper class to represent a habit with an optional time slot (for hourly habits)
class HabitTimeSlot {
  final Habit habit;
  final TimeOfDay? timeSlot;

  HabitTimeSlot({required this.habit, this.timeSlot});
}

class TimelineScreen extends ConsumerStatefulWidget {
  const TimelineScreen({super.key});

  @override
  ConsumerState<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends ConsumerState<TimelineScreen> {
  String _selectedCategory = 'All';
  DateTime _selectedDate = DateTime.now();
  bool _isUpdatingHabit = false;
  final Map<String, bool> _optimisticCompletions = {};
  Timer? _autoRefreshTimer;

  @override
  void initState() {
    super.initState();
    _startAutoRefresh();
  }

  @override
  void dispose() {
    _autoRefreshTimer?.cancel();
    super.dispose();
  }

  /// Start automatic refresh to pick up changes from notifications
  void _startAutoRefresh() {
    _autoRefreshTimer?.cancel();
    _autoRefreshTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (mounted) {
        // Invalidate provider to trigger refresh from database
        // This ensures UI updates when habits are completed from notifications
        AppLogger.debug(
            '⏰ TIMELINE: Auto-refresh timer tick - invalidating habitsProvider');
        ref.invalidate(habitsProvider);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timeline'),
        actions: [
          CategoryFilterWidget(
            selectedCategory: _selectedCategory,
            onCategoryChanged: (value) {
              setState(() {
                _selectedCategory = value;
              });
            },
          ),
          // Manual refresh button (auto-refresh runs every 2 seconds)
          IconButton(
            onPressed: () {
              ref.invalidate(habitsProvider);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Refreshing...'),
                  duration: Duration(milliseconds: 800),
                ),
              );
            },
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh now',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildDateSelector(),
          Expanded(child: _buildHabitsList()),
        ],
      ),
      floatingActionButton: const CreateHabitFAB(),
    );
  }

  Widget _buildDateSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              setState(() {
                _selectedDate = _selectedDate.subtract(const Duration(days: 1));
              });
            },
            icon: const Icon(Icons.chevron_left),
          ),
          Expanded(
            child: GestureDetector(
              onTap: _selectDate,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  DateFormat('EEEE, MMMM d, y').format(_selectedDate),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _selectedDate = _selectedDate.add(const Duration(days: 1));
              });
            },
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }

  Widget _buildHabitsList() {
    return Consumer(
      builder: (context, ref, child) {
        // Watch habits directly from database (like widget does)
        final habitsAsync = ref.watch(habitsProvider);

        return habitsAsync.when(
          data: (allHabits) {
            if (allHabits.isEmpty) {
              return RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(habitsProvider);
                },
                child: ListView(
                  children: const [
                    SizedBox(height: 200),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.timeline, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'No habits yet',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Create your first habit to get started!',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }

            // Optimize filtering and sorting with single pass
            final hourlyHabits = <Habit>[];
            final regularHabits = <Habit>[];

            for (final habit in allHabits) {
              // Apply category filter and date filter in one pass
              if ((_selectedCategory == 'All' ||
                      habit.category == _selectedCategory) &&
                  _isHabitDueOnDate(habit, _selectedDate)) {
                if (habit.frequency == HabitFrequency.hourly &&
                    habit.hourlyTimes.isNotEmpty) {
                  hourlyHabits.add(habit);
                } else {
                  regularHabits.add(habit);
                }
              }
            }

            // Sort hourly habits by their earliest time slot
            hourlyHabits.sort((a, b) {
              final aEarliestTime = _getEarliestTimeSlot(a);
              final bEarliestTime = _getEarliestTimeSlot(b);

              if (aEarliestTime != null && bEarliestTime != null) {
                if (aEarliestTime.hour != bEarliestTime.hour) {
                  return aEarliestTime.hour.compareTo(bEarliestTime.hour);
                }
                return aEarliestTime.minute.compareTo(bEarliestTime.minute);
              }

              return a.createdAt.compareTo(b.createdAt);
            });

            // Sort regular habits by notification time or creation date
            regularHabits.sort((a, b) {
              if (a.notificationTime != null && b.notificationTime != null) {
                final timeA = a.notificationTime!;
                final timeB = b.notificationTime!;

                if (timeA.hour != timeB.hour) {
                  return timeA.hour.compareTo(timeB.hour);
                }
                return timeA.minute.compareTo(timeB.minute);
              }

              if (a.notificationTime != null && b.notificationTime == null) {
                return -1;
              }
              if (a.notificationTime == null && b.notificationTime != null) {
                return 1;
              }

              return b.createdAt.compareTo(a.createdAt);
            });

            if (hourlyHabits.isEmpty && regularHabits.isEmpty) {
              return RefreshIndicator(
                onRefresh: () async {
                  try {
                    await ref
                        .read(habitsNotifierProvider.notifier)
                        .refreshHabits();
                  } catch (e) {
                    // If provider not ready, just invalidate and retry
                    ref.invalidate(habitsNotifierProvider);
                  }
                },
                child: ListView(
                  children: [
                    const SizedBox(height: 200),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            size: 64,
                            color: Colors.green,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _selectedCategory == 'All'
                                ? 'No habits scheduled for this day'
                                : 'No $_selectedCategory habits for this day',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                try {
                  // Force immediate refresh for faster response
                  await ref
                      .read(habitsNotifierProvider.notifier)
                      .forceImmediateRefresh();
                } catch (e) {
                  // If provider not ready, just invalidate and retry
                  ref.invalidate(habitsNotifierProvider);
                }
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: hourlyHabits.length + regularHabits.length,
                itemBuilder: (context, index) {
                  if (index < hourlyHabits.length) {
                    // Render hourly habit with collapsible card
                    final habit = hourlyHabits[index];
                    return SmoothTransitions.slideTransition(
                      show: true,
                      duration: Duration(milliseconds: 300 + (index * 50)),
                      child: CollapsibleHourlyHabitCard(
                        habit: habit,
                        selectedDate: _selectedDate,
                        onToggleHourlyCompletion: _toggleHourlyHabitCompletion,
                        isHourlyHabitCompletedAtTime:
                            _isHourlyHabitCompletedAtTime,
                        getHabitStatus: _getHabitStatus,
                        getStatusColor: _getStatusColor,
                      ),
                    );
                  } else {
                    // Render regular habit with standard card
                    final habitIndex = index - hourlyHabits.length;
                    final habit = regularHabits[habitIndex];
                    return SmoothTransitions.slideTransition(
                      show: true,
                      duration: Duration(milliseconds: 300 + (index * 50)),
                      child: _buildHabitCard(HabitTimeSlot(habit: habit)),
                    );
                  }
                },
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Error loading habits',
                  style: const TextStyle(fontSize: 18, color: Colors.red),
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  style: const TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    ref.invalidate(habitsProvider);
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHabitCard(HabitTimeSlot habitTimeSlot) {
    final habit = habitTimeSlot.habit;
    final timeSlot = habitTimeSlot.timeSlot;

    // Check for optimistic completion first
    final optimisticKey =
        '${habit.id}_${_selectedDate.millisecondsSinceEpoch}${timeSlot != null ? '_${timeSlot.hour}_${timeSlot.minute}' : ''}';
    final hasOptimisticCompletion =
        _optimisticCompletions[optimisticKey] ?? false;

    final isCompleted = hasOptimisticCompletion ||
        (timeSlot != null
            ? _isHourlyHabitCompletedAtTime(habit, _selectedDate, timeSlot)
            : _isHabitCompletedOnDate(habit, _selectedDate));
    final status = _getHabitStatus(habit, _selectedDate);
    final statusColor = _getStatusColor(status);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: _isUpdatingHabit
            ? null
            : () => timeSlot != null
                ? _toggleHourlyHabitCompletion(habit, timeSlot)
                : _toggleHabitCompletion(habit),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 60,
                decoration: BoxDecoration(
                  color: Color(habit.colorValue),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      timeSlot != null
                          ? '${habit.name} (${timeSlot.format(context)})'
                          : habit.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            decoration:
                                isCompleted ? TextDecoration.lineThrough : null,
                          ),
                    ),
                    if (habit.description != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        habit.description!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Color(
                              habit.colorValue,
                            ).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            habit.category,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Color(habit.colorValue),
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
                            color: statusColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            status,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: statusColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                          ),
                        ),
                        // Add time display
                        if (_getHabitTimeDisplay(habit).isNotEmpty) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.access_time,
                                  size: 12,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _getHabitTimeDisplay(habit),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isCompleted
                      ? Colors.green
                      : statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isCompleted ? Colors.green : statusColor,
                    width: 2,
                  ),
                ),
                child: AnimatedSwitcher(
                  duration:
                      const Duration(milliseconds: 200), // Faster animation
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(
                      scale: animation,
                      child: FadeTransition(
                        opacity: animation,
                        child: child,
                      ),
                    );
                  },
                  child: Icon(
                    isCompleted ? Icons.check : Icons.circle_outlined,
                    key: ValueKey(isCompleted),
                    color: isCompleted ? Colors.white : statusColor,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isHabitDueOnDate(Habit habit, DateTime date) {
    // Phase 4: Use RRule if available, otherwise fall back to legacy frequency
    if (habit.usesRRule && habit.rruleString != null) {
      try {
        // Use dtStart if available, otherwise fall back to createdAt
        // This is critical for interval-based RRules (e.g., bi-weekly)
        final startDate = habit.dtStart ?? habit.createdAt;
        return RRuleService.isDueOnDate(
          rruleString: habit.rruleString!,
          startDate: startDate,
          checkDate: date,
        );
      } catch (e) {
        debugPrint('⚠️ RRule check failed, falling back to legacy: $e');
        // Fall through to legacy logic
      }
    }

    // Legacy frequency-based logic
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
        // For yearly habits, check if the selected date matches the habit's yearly schedule
        // Use selectedYearlyDates if available, otherwise fall back to creation date
        if (habit.selectedYearlyDates.isNotEmpty) {
          return habit.selectedYearlyDates.any((selectedDate) {
            final parts = selectedDate.split('-');
            if (parts.length == 3) {
              final month = int.tryParse(parts[1]);
              final day = int.tryParse(parts[2]);
              if (month != null && day != null) {
                return date.month == month && date.day == day;
              }
            }
            return false;
          });
        } else {
          // Fallback: use creation date but only show on or after the anniversary
          final habitCreationDate = habit.createdAt;
          final currentYear = date.year;

          // Only show if the date is the anniversary and it's on or after the creation year
          return date.month == habitCreationDate.month &&
              date.day == habitCreationDate.day &&
              currentYear >= habitCreationDate.year;
        }

      case HabitFrequency.single:
        if (habit.singleDateTime == null) return false;
        final singleDate = habit.singleDateTime!;
        return date.year == singleDate.year &&
            date.month == singleDate.month &&
            date.day == singleDate.day;
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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    switch (status) {
      case 'Completed':
        return isDarkMode
            ? const Color(0xFF4CAF50)
            : const Color(0xFF2E7D32); // Darker green for better contrast
      case 'Missed':
        return isDarkMode
            ? const Color(0xFFE57373)
            : const Color(0xFFC62828); // Darker red for better contrast
      case 'Due':
        return isDarkMode
            ? const Color(0xFFFFB74D)
            : const Color(0xFFE65100); // Darker orange for better contrast
      case 'Upcoming':
        return isDarkMode
            ? const Color(0xFF64B5F6)
            : const Color(0xFF1565C0); // Darker blue for better contrast
      default:
        return isDarkMode
            ? const Color(0xFF9E9E9E)
            : const Color(0xFF424242); // Darker grey for better contrast
    }
  }

  Future<void> _toggleHabitCompletion(Habit habit) async {
    if (_isUpdatingHabit) return;

    setState(() {
      _isUpdatingHabit = true;
    });

    final optimisticKey = '${habit.id}_${_selectedDate.millisecondsSinceEpoch}';
    final isCompleted = _isHabitCompletedOnDate(habit, _selectedDate);

    AppLogger.info(
        '🎯 TIMELINE: Toggling completion for habit "${habit.name}" (${habit.id}) on ${_selectedDate.toIso8601String()} - currently: ${isCompleted ? "completed" : "not completed"}');

    // Optimistic UI update with immediate visual feedback
    setState(() {
      _optimisticCompletions[optimisticKey] = !isCompleted;
    });

    try {
      // Get habit service
      final habitService = await ref.read(currentHabitServiceProvider.future);

      // Use service methods to handle completion (matches widget pattern)
      // This ensures we're always working with fresh database data
      if (isCompleted) {
        // Remove completion using service method
        AppLogger.debug(
            '🐛 TIMELINE: Removing completion via habitService.removeHabitCompletion()');
        await habitService.removeHabitCompletion(habit.id, _selectedDate);
        AppLogger.info('✅ TIMELINE: Completion removed successfully');
      } else {
        // Add completion using service method
        AppLogger.debug(
            '🐛 TIMELINE: Adding completion via habitService.markHabitComplete()');
        await habitService.markHabitComplete(habit.id, _selectedDate);
        AppLogger.info('✅ TIMELINE: Completion added successfully');
      }

      // Invalidate provider to trigger refresh from database
      AppLogger.debug('🐛 TIMELINE: Invalidating habitsProvider to refresh UI');
      ref.invalidate(habitsProvider);

      // Wait for provider to fetch fresh data before clearing optimistic state
      AppLogger.debug(
          '🐛 TIMELINE: Waiting for habitsProvider to fetch fresh data...');
      await ref.read(habitsProvider.future);
      AppLogger.info(
          '✅ TIMELINE: Fresh data loaded, clearing optimistic state');

      // Clear optimistic state after successful update and data refresh
      setState(() {
        _optimisticCompletions.remove(optimisticKey);
      });
    } catch (error) {
      // Revert optimistic update on error
      setState(() {
        _optimisticCompletions.remove(optimisticKey);
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error')),
        );
      }
    } finally {
      setState(() {
        _isUpdatingHabit = false;
      });
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  String _getHabitTimeDisplay(Habit habit) {
    // Phase 4: For RRule habits, show time information
    // (Summary is shown elsewhere in the UI)
    if (habit.usesRRule && habit.rruleString != null) {
      try {
        // For hourly habits, show times
        if (habit.frequency == HabitFrequency.hourly &&
            habit.hourlyTimes.isNotEmpty) {
          if (habit.hourlyTimes.length == 1) {
            return habit.hourlyTimes.first;
          } else if (habit.hourlyTimes.length <= 3) {
            return habit.hourlyTimes.join(', ');
          } else {
            return '${habit.hourlyTimes.first} +${habit.hourlyTimes.length - 1} more';
          }
        }
        // For other frequencies, show notification time if available
        if (habit.notificationTime != null) {
          final time = habit.notificationTime!;
          return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
        }
        return '';
      } catch (e) {
        debugPrint('⚠️ Failed to display RRule habit time: $e');
        // Fall through to legacy logic
      }
    }

    // Legacy frequency-based display
    switch (habit.frequency) {
      case HabitFrequency.hourly:
        if (habit.hourlyTimes.isNotEmpty) {
          if (habit.hourlyTimes.length == 1) {
            return habit.hourlyTimes.first;
          } else if (habit.hourlyTimes.length <= 3) {
            return habit.hourlyTimes.join(', ');
          } else {
            return '${habit.hourlyTimes.first} +${habit.hourlyTimes.length - 1} more';
          }
        }
        return 'Hourly';

      case HabitFrequency.daily:
      case HabitFrequency.weekly:
      case HabitFrequency.monthly:
      case HabitFrequency.yearly:
        if (habit.notificationTime != null) {
          final time = habit.notificationTime!;
          return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
        }
        return '';

      case HabitFrequency.single:
        if (habit.singleDateTime != null) {
          final dateTime = habit.singleDateTime!;
          final timeOfDay = TimeOfDay.fromDateTime(dateTime);
          final hour =
              timeOfDay.hourOfPeriod == 0 ? 12 : timeOfDay.hourOfPeriod;
          final period = timeOfDay.period == DayPeriod.am ? 'AM' : 'PM';
          return '$hour:${timeOfDay.minute.toString().padLeft(2, '0')} $period';
        }
        return '';
    }
  }

  // Check if an hourly habit is completed at a specific time slot
  bool _isHourlyHabitCompletedAtTime(
    Habit habit,
    DateTime date,
    TimeOfDay timeSlot,
  ) {
    final targetDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      timeSlot.hour,
      timeSlot.minute,
    );

    return habit.completions.any((completion) {
      return completion.year == targetDateTime.year &&
          completion.month == targetDateTime.month &&
          completion.day == targetDateTime.day &&
          completion.hour == targetDateTime.hour &&
          completion.minute == targetDateTime.minute;
    });
  }

  // Toggle completion for a specific hourly time slot
  Future<void> _toggleHourlyHabitCompletion(
    Habit habit,
    TimeOfDay timeSlot,
  ) async {
    if (_isUpdatingHabit) return;

    setState(() {
      _isUpdatingHabit = true;
    });

    final targetDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      timeSlot.hour,
      timeSlot.minute,
    );

    final optimisticKey =
        '${habit.id}_${_selectedDate.millisecondsSinceEpoch}_${timeSlot.hour}_${timeSlot.minute}';
    final isCompleted = _isHourlyHabitCompletedAtTime(
      habit,
      _selectedDate,
      timeSlot,
    );

    // Optimistic UI update with immediate visual feedback
    setState(() {
      _optimisticCompletions[optimisticKey] = !isCompleted;
    });

    try {
      // Get habit service
      final habitService = await ref.read(currentHabitServiceProvider.future);

      // Use service methods to handle completion (matches widget pattern)
      // This ensures we're always working with fresh database data
      if (isCompleted) {
        // Remove completion for this specific time slot using service method
        await habitService.removeHabitCompletion(habit.id, targetDateTime);
      } else {
        // Add completion for this specific time slot using service method
        await habitService.markHabitComplete(habit.id, targetDateTime);
      }

      // Invalidate provider to trigger refresh from database
      ref.invalidate(habitsProvider);

      // Clear optimistic state after successful update
      setState(() {
        _optimisticCompletions.remove(optimisticKey);
      });
    } catch (error) {
      // Revert optimistic update on error
      setState(() {
        _optimisticCompletions.remove(optimisticKey);
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error')),
        );
      }
    } finally {
      setState(() {
        _isUpdatingHabit = false;
      });
    }
  }

  TimeOfDay? _getEarliestTimeSlot(Habit habit) {
    if (habit.hourlyTimes.isEmpty) return null;

    TimeOfDay? earliest;
    for (final timeStr in habit.hourlyTimes) {
      final timeParts = timeStr.split(':');
      if (timeParts.length == 2) {
        final hour = int.tryParse(timeParts[0]);
        final minute = int.tryParse(timeParts[1]);
        if (hour != null && minute != null) {
          final timeSlot = TimeOfDay(hour: hour, minute: minute);
          if (earliest == null ||
              timeSlot.hour < earliest.hour ||
              (timeSlot.hour == earliest.hour &&
                  timeSlot.minute < earliest.minute)) {
            earliest = timeSlot;
          }
        }
      }
    }
    return earliest;
  }
}
