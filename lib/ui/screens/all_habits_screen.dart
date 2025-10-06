import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/database.dart';
import '../../domain/model/habit.dart';
import '../../services/logging_service.dart';
import '../../services/rrule_service.dart';

import '../widgets/loading_widget.dart';
import '../widgets/create_habit_fab.dart';
import '../widgets/category_filter_widget.dart';
import '../widgets/collapsible_hourly_habit_card.dart';
import 'edit_habit_screen.dart';

class AllHabitsScreen extends ConsumerStatefulWidget {
  const AllHabitsScreen({super.key});

  @override
  ConsumerState<AllHabitsScreen> createState() => _AllHabitsScreenState();
}

class _AllHabitsScreenState extends ConsumerState<AllHabitsScreen> {
  String _selectedCategory = 'All';
  String _selectedSort = 'Recent';
  Timer? _autoRefreshTimer;

  final List<String> _sortOptions = [
    'Recent',
    'Top Performers',
    'Bottom Performers',
    'Longest Streak',
    'Alphabetical',
    'Completion Rate',
  ];

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
        ref.invalidate(habitsProvider);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Habits'),
        actions: [
          // Category Filter
          CategoryFilterWidget(
            selectedCategory: _selectedCategory,
            onCategoryChanged: (value) {
              setState(() {
                _selectedCategory = value;
              });
            },
          ),
          // Sort Menu
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _selectedSort = value;
              });
              AppLogger.info('Sorting habits by: $value');
            },
            itemBuilder: (BuildContext context) {
              return _sortOptions.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Row(
                    children: [
                      Icon(_getSortIcon(choice), size: 20),
                      const SizedBox(width: 8),
                      Text(choice),
                      if (choice == _selectedSort) ...[
                        const Spacer(),
                        const Icon(Icons.check, size: 16, color: Colors.green),
                      ],
                    ],
                  ),
                );
              }).toList();
            },
            icon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(_getSortIcon(_selectedSort)),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
            tooltip: 'Sort habits',
          ),
        ],
        // Only show the current filters display, no filter chips
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: (_selectedCategory != 'All' || _selectedSort != 'Recent')
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                  child: Row(
                    children: [
                      if (_selectedCategory != 'All')
                        Chip(
                          label: Text(_selectedCategory),
                          deleteIcon: const Icon(Icons.close, size: 16),
                          onDeleted: () =>
                              setState(() => _selectedCategory = 'All'),
                        ),
                      if (_selectedCategory != 'All' &&
                          _selectedSort != 'Recent')
                        const SizedBox(width: 8),
                      if (_selectedSort != 'Recent')
                        Chip(
                          label: Text('Sort: $_selectedSort'),
                          deleteIcon: const Icon(Icons.close, size: 16),
                          onDeleted: () =>
                              setState(() => _selectedSort = 'Recent'),
                        ),
                      if (_selectedCategory != 'All' ||
                          _selectedSort != 'Recent')
                        const Spacer(),
                      if (_selectedCategory != 'All' ||
                          _selectedSort != 'Recent')
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedCategory = 'All';
                              _selectedSort = 'Recent';
                            });
                          },
                          child: const Text('Clear Filters'),
                        ),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ),
      body: Consumer(
        builder: (context, ref, child) {
          // Use habitsProvider for direct database access (auto-refreshes)
          final habitsAsync = ref.watch(habitsProvider);

          return habitsAsync.when(
            data: (allHabits) {
              if (allHabits.isEmpty) {
                return const EmptyStateWidget(
                  icon: Icons.track_changes,
                  title: 'No habits yet',
                  subtitle: 'Create your first habit to get started!',
                );
              }

              final filteredHabits = _filterAndSortHabits(allHabits);

              return RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(habitsProvider);
                  // Wait a bit for the provider to refresh
                  await Future.delayed(const Duration(milliseconds: 300));
                },
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredHabits.length,
                  itemBuilder: (context, index) {
                    final habit = filteredHabits[index];
                    final rank = _selectedSort == 'Top Performers' ||
                            _selectedSort == 'Bottom Performers' ||
                            _selectedSort == 'Longest Streak'
                        ? index + 1
                        : null;

                    // Check if this is an hourly habit with time slots
                    if (habit.frequency == HabitFrequency.hourly &&
                        habit.hourlyTimes.isNotEmpty) {
                      return CollapsibleHourlyHabitCard(
                        habit: habit,
                        selectedDate: DateTime.now(),
                        onToggleHourlyCompletion: (habit, timeSlot) =>
                            _toggleHourlyHabitCompletion(habit, timeSlot),
                        isHourlyHabitCompletedAtTime:
                            _isHourlyHabitCompletedAtTime,
                        getHabitStatus: _getHabitStatus,
                        getStatusColor: _getStatusColor,
                      );
                    }

                    return _HabitCard(
                      habit: habit,
                      rank: rank,
                      showPerformanceIndicator: _selectedSort.contains(
                        'Performers',
                      ),
                    );
                  },
                ),
              );
            },
            loading: () => const LoadingWidget(message: 'Loading habits...'),
            error: (error, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error loading habits: $error'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => ref.invalidate(habitsProvider),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: const CreateHabitFAB(),
    );
  }

  List<Habit> _filterAndSortHabits(List<Habit> habits) {
    List<Habit> filtered = List.from(habits);

    // Apply category filter
    if (_selectedCategory != 'All') {
      filtered = filtered
          .where((habit) => habit.category == _selectedCategory)
          .toList();
    }

    // Apply sort
    switch (_selectedSort) {
      case 'Alphabetical':
        filtered.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'Completion Rate':
        filtered.sort((a, b) => b.completionRate.compareTo(a.completionRate));
        break;
      case 'Top Performers':
        filtered.sort((a, b) => b.currentStreak.compareTo(a.currentStreak));
        break;
      case 'Bottom Performers':
        filtered.sort((a, b) => a.currentStreak.compareTo(b.currentStreak));
        break;
      case 'Longest Streak':
        filtered.sort((a, b) => b.longestStreak.compareTo(a.longestStreak));
        break;
      case 'Recent':
      default:
        filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
    }

    return filtered;
  }

  IconData _getSortIcon(String sortOption) {
    switch (sortOption) {
      case 'Top Performers':
        return Icons.trending_up;
      case 'Bottom Performers':
        return Icons.trending_down;
      case 'Longest Streak':
        return Icons.local_fire_department;
      case 'Alphabetical':
        return Icons.sort_by_alpha;
      case 'Completion Rate':
        return Icons.percent;
      case 'Recent':
      default:
        return Icons.access_time;
    }
  }

  void _toggleHourlyHabitCompletion(Habit habit, TimeOfDay timeSlot) async {
    final now = DateTime.now();
    final targetDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      timeSlot.hour,
      timeSlot.minute,
    );

    final isCompleted = _isHourlyHabitCompletedAtTime(habit, now, timeSlot);

    try {
      // Get habit service and fetch fresh habit from database
      final habitService = await ref.read(currentHabitServiceProvider.future);
      final freshHabit = await habitService.getHabitById(habit.id);
      
      if (freshHabit == null) {
        AppLogger.error('Habit not found in database: ${habit.id}');
        return;
      }

      if (isCompleted) {
        // Remove completion for this specific time slot
        freshHabit.completions.removeWhere((completion) {
          return completion.year == targetDateTime.year &&
              completion.month == targetDateTime.month &&
              completion.day == targetDateTime.day &&
              completion.hour == targetDateTime.hour &&
              completion.minute == targetDateTime.minute;
        });
      } else {
        // Add completion for this specific time slot
        freshHabit.completions.add(targetDateTime);
      }

      await habitService.updateHabit(freshHabit);
      
      // Invalidate provider to trigger refresh
      ref.invalidate(habitsProvider);
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error')),
        );
      }
    }
  }

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

  String _getHabitStatus(Habit habit, DateTime date) {
    // For all habits screen, we can show a general status
    if (habit.frequency == HabitFrequency.hourly) {
      final timeSlots = habit.hourlyTimes
          .map((timeStr) {
            final timeParts = timeStr.split(':');
            if (timeParts.length == 2) {
              final hour = int.tryParse(timeParts[0]);
              final minute = int.tryParse(timeParts[1]);
              if (hour != null && minute != null) {
                return TimeOfDay(hour: hour, minute: minute);
              }
            }
            return null;
          })
          .where((t) => t != null)
          .cast<TimeOfDay>()
          .toList();

      final completedCount = timeSlots
          .where(
            (timeSlot) => _isHourlyHabitCompletedAtTime(habit, date, timeSlot),
          )
          .length;

      if (completedCount == timeSlots.length) {
        return 'Completed';
      } else if (completedCount > 0) {
        return 'Partial';
      } else {
        return 'Pending';
      }
    }

    // For non-hourly habits, check if completed today
    final today = DateTime.now();
    final isCompletedToday = habit.completions.any((completion) {
      return completion.year == today.year &&
          completion.month == today.month &&
          completion.day == today.day;
    });

    return isCompletedToday ? 'Completed' : 'Pending';
  }

  Color _getStatusColor(String status) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    switch (status) {
      case 'Completed':
        return isDarkMode
            ? const Color(0xFF4CAF50)
            : const Color(0xFF2E7D32); // Darker green for better contrast
      case 'Partial':
        return isDarkMode
            ? const Color(0xFFFFB74D)
            : const Color(0xFFE65100); // Darker orange for better contrast
      case 'Pending':
      default:
        return isDarkMode
            ? const Color(0xFF9E9E9E)
            : const Color(0xFF424242); // Darker grey for better contrast
    }
  }
}

class _HabitCard extends ConsumerWidget {
  final Habit habit;
  final int? rank;
  final bool showPerformanceIndicator;

  const _HabitCard({
    required this.habit,
    this.rank,
    this.showPerformanceIndicator = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Rank indicator
                if (rank != null)
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: _getRankColor(rank!),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '#$rank',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                if (rank != null) const SizedBox(width: 12),

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
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                          // Performance indicator
                          if (showPerformanceIndicator)
                            Icon(
                              _getPerformanceIcon(),
                              color: _getPerformanceColor(),
                              size: 20,
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            _getCategoryIcon(habit.category),
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            habit.category,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                          // Add frequency type
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.purple.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _getFrequencyTypeDisplay(habit.frequency,
                                  habit: habit),
                              style: const TextStyle(
                                color: Colors.purple,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          // Add time display
                          if (_getHabitTimeDisplay(habit).isNotEmpty) ...[
                            const SizedBox(width: 8),
                            Icon(
                              Icons.access_time,
                              size: 14,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 2),
                            Text(
                              _getHabitTimeDisplay(habit),
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),

                // Actions
                PopupMenuButton<String>(
                  onSelected: (value) => _handleAction(context, value, ref),
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
              ],
            ),

            const SizedBox(height: 12),

            // Stats row
            Row(
              children: [
                Expanded(
                  child: _StatItem(
                    icon: Icons.local_fire_department,
                    label: 'Current',
                    value: '${habit.currentStreak}',
                    color:
                        habit.currentStreak > 0 ? Colors.orange : Colors.grey,
                  ),
                ),
                Expanded(
                  child: _StatItem(
                    icon: Icons.emoji_events,
                    label: 'Best',
                    value: '${habit.longestStreak}',
                    color: habit.longestStreak > 0 ? Colors.amber : Colors.grey,
                  ),
                ),
                Expanded(
                  child: _StatItem(
                    icon: Icons.percent,
                    label: 'Rate',
                    value: '${(habit.completionRate * 100).round()}%',
                    color: habit.completionRate > 0.7
                        ? Colors.green
                        : habit.completionRate > 0.4
                            ? Colors.orange
                            : Colors.red,
                  ),
                ),
                Expanded(
                  child: _StatItem(
                    icon: Icons.calendar_today,
                    label: 'Total',
                    value: '${habit.completions.length}',
                    color: habit.completions.isNotEmpty
                        ? Colors.blue
                        : Colors.grey,
                  ),
                ),
              ],
            ),

            // Progress bar
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: habit.completionRate,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                habit.completionRate > 0.7
                    ? Colors.green
                    : habit.completionRate > 0.4
                        ? Colors.orange
                        : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleAction(BuildContext context, String action, WidgetRef ref) async {
    switch (action) {
      case 'edit':
        // Navigate to edit screen
        final result = await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => EditHabitScreen(habit: habit),
          ),
        );

        if (result == true) {
          // Refresh the habits list
          ref.invalidate(habitServiceProvider);
        }
        break;

      case 'delete':
        // Show confirmation dialog
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete Habit'),
            content: Text(
              'Are you sure you want to delete "${habit.name}"? This action cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Delete'),
              ),
            ],
          ),
        );

        if (confirmed == true) {
          // Use Riverpod to access the habitServiceProvider
          final habitServiceAsync = ref.watch(habitServiceProvider);

          await habitServiceAsync.when(
            data: (habitService) async {
              try {
                await habitService.deleteHabit(habit);

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${habit.name} deleted successfully'),
                    ),
                  );
                }

                // Refresh the habits list
                ref.invalidate(habitServiceProvider);
              } catch (e) {
                AppLogger.error('Error deleting habit', e);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Error deleting habit')),
                  );
                }
              }
            },
            loading: () async {
              // Show loading indicator
              if (context.mounted) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Loading...')));
              }
            },
            error: (error, stack) async {
              AppLogger.error('Error accessing habit service', error);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Error accessing habit service'),
                  ),
                );
              }
            },
          );
        }
        break;
    }
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return Colors.amber; // Gold
      case 2:
        return Colors.grey[400]!; // Silver
      case 3:
        return Colors.brown[400]!; // Bronze
      default:
        return Colors.blue;
    }
  }

  IconData _getPerformanceIcon() {
    if (habit.completionRate > 0.8) {
      return Icons.trending_up;
    } else if (habit.completionRate < 0.3) {
      return Icons.trending_down;
    } else {
      return Icons.trending_flat;
    }
  }

  Color _getPerformanceColor() {
    if (habit.completionRate > 0.8) {
      return Colors.green;
    } else if (habit.completionRate < 0.3) {
      return Colors.red;
    } else {
      return Colors.orange;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'health':
        return Icons.favorite;
      case 'fitness':
        return Icons.fitness_center;
      case 'productivity':
        return Icons.work;
      case 'learning':
        return Icons.school;
      case 'personal':
        return Icons.person;
      case 'social':
        return Icons.people;
      case 'finance':
        return Icons.attach_money;
      case 'mindfulness':
        return Icons.self_improvement;
      case 'all':
      default:
        return Icons.apps;
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

      case HabitFrequency.single:
        if (habit.singleDateTime != null) {
          final dateTime = habit.singleDateTime!;
          final timeOfDay = TimeOfDay.fromDateTime(dateTime);
          final hour =
              timeOfDay.hourOfPeriod == 0 ? 12 : timeOfDay.hourOfPeriod;
          final period = timeOfDay.period == DayPeriod.am ? 'AM' : 'PM';
          return '${dateTime.month}/${dateTime.day}/${dateTime.year.toString().substring(2)} $hour:${timeOfDay.minute.toString().padLeft(2, '0')} $period';
        }
        return '';
    }
  }

  String _getFrequencyTypeDisplay(HabitFrequency frequency, {Habit? habit}) {
    // Phase 4: Show RRule summary if available
    if (habit != null && habit.usesRRule && habit.rruleString != null) {
      try {
        final summary = RRuleService.getRRuleSummary(habit.rruleString!);
        // Make summary more concise for list view
        return summary.replaceAll('Repeats ', '').replaceAll('every ', '');
      } catch (e) {
        debugPrint('⚠️ Failed to get RRule summary: $e');
        // Fall through to legacy logic
      }
    }

    // Legacy frequency display
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
      case HabitFrequency.single:
        return 'Single';
    }
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(fontWeight: FontWeight.bold, color: color),
        ),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }
}
