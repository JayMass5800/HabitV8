import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../data/database.dart';
import '../../domain/model/habit.dart';

class TimelineScreen extends ConsumerStatefulWidget {
  const TimelineScreen({super.key});

  @override
  ConsumerState<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends ConsumerState<TimelineScreen> {
  String _selectedCategory = 'All';
  DateTime _selectedDate = DateTime.now();

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timeline'),
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
                      if (choice == _selectedCategory) const Icon(Icons.check, size: 20),
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
      body: Column(
        children: [
          _buildDateSelector(),
          Expanded(child: _buildHabitsList()),
        ],
      ),
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
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
        final habitServiceAsync = ref.watch(habitServiceProvider);

        return habitServiceAsync.when(
          data: (habitService) => FutureBuilder<List<Habit>>(
            future: habitService.getAllHabits(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
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
                );
              }

              final allHabits = snapshot.data!;
              final filteredHabits = _selectedCategory == 'All'
                  ? allHabits
                  : allHabits.where((habit) => habit.category == _selectedCategory).toList();

              final todayHabits = filteredHabits.where((habit) => _isHabitDueOnDate(habit, _selectedDate)).toList();
              
              // Sort habits chronologically by notification time
              todayHabits.sort((a, b) {
                // If both habits have notification times, sort by time
                if (a.notificationTime != null && b.notificationTime != null) {
                  final timeA = a.notificationTime!;
                  final timeB = b.notificationTime!;
                  
                  // Compare by hour first, then by minute
                  if (timeA.hour != timeB.hour) {
                    return timeA.hour.compareTo(timeB.hour);
                  }
                  return timeA.minute.compareTo(timeB.minute);
                }
                
                // If only one has notification time, prioritize it
                if (a.notificationTime != null && b.notificationTime == null) {
                  return -1; // a comes first
                }
                if (a.notificationTime == null && b.notificationTime != null) {
                  return 1; // b comes first
                }
                
                // If neither has notification time, sort by creation date (newest first)
                return b.createdAt.compareTo(a.createdAt);
              });

              if (todayHabits.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle_outline, size: 64, color: Colors.green),
                      const SizedBox(height: 16),
                      Text(
                        _selectedCategory == 'All'
                            ? 'No habits scheduled for this day'
                            : 'No $_selectedCategory habits for this day',
                        style: const TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: todayHabits.length,
                itemBuilder: (context, index) {
                  final habit = todayHabits[index];
                  return _buildHabitCard(habit);
                },
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
    );
  }

  Widget _buildHabitCard(Habit habit) {
    final isCompleted = _isHabitCompletedOnDate(habit, _selectedDate);
    final status = _getHabitStatus(habit, _selectedDate);
    final statusColor = _getStatusColor(status);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _toggleHabitCompletion(habit),
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
                      habit.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        decoration: isCompleted ? TextDecoration.lineThrough : null,
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
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Color(habit.colorValue).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            habit.category,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Color(habit.colorValue),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            status,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: statusColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        // Add time display
                        if (_getHabitTimeDisplay(habit).isNotEmpty) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
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
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isCompleted ? Colors.green : statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isCompleted ? Colors.green : statusColor,
                    width: 2,
                  ),
                ),
                child: Icon(
                  isCompleted ? Icons.check : Icons.circle_outlined,
                  color: isCompleted ? Colors.white : statusColor,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isHabitDueOnDate(Habit habit, DateTime date) {
    switch (habit.frequency) {
      case HabitFrequency.hourly:
      case HabitFrequency.daily:
        return true;
      case HabitFrequency.weekly:
        final weekday = date.weekday;
        return habit.weeklySchedule.contains(weekday);
      case HabitFrequency.monthly:
        final day = date.day;
        return habit.monthlySchedule.contains(day);
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
    }
  }

  bool _isHabitCompletedOnDate(Habit habit, DateTime date) {
    final dateOnly = DateTime(date.year, date.month, date.day);
    return habit.completions.any((completion) {
      final completionDate = DateTime(completion.year, completion.month, completion.day);
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

  Future<void> _toggleHabitCompletion(Habit habit) async {
    final isCompleted = _isHabitCompletedOnDate(habit, _selectedDate);
    final habitServiceAsync = ref.read(habitServiceProvider);

    habitServiceAsync.when(
      data: (habitService) async {
        if (isCompleted) {
          // Remove completion
          habit.completions.removeWhere((completion) {
            final completionDate = DateTime(completion.year, completion.month, completion.day);
            final selectedDate = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
            return completionDate == selectedDate;
          });
        } else {
          // Add completion
          habit.completions.add(_selectedDate);
        }

        await habitService.updateHabit(habit);
        ref.invalidate(habitServiceProvider);
      },
      loading: () {},
      error: (error, stack) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $error')),
          );
        }
      },
    );
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
    }
  }
}
