import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/database.dart';
import '../../domain/model/habit.dart';
import '../../services/logging_service.dart';
import '../widgets/category_filter_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/create_habit_fab.dart';
import 'edit_habit_screen.dart';

class AllHabitsScreen extends ConsumerStatefulWidget {
  const AllHabitsScreen({super.key});

  @override
  ConsumerState<AllHabitsScreen> createState() => _AllHabitsScreenState();
}

class _AllHabitsScreenState extends ConsumerState<AllHabitsScreen> {
  String _selectedFilter = 'All';
  String _selectedCategory = 'All';
  String _selectedSort = 'Recent'; // New sorting option

  final List<String> _sortOptions = [
    'Recent',
    'Top Performers',
    'Bottom Performers',
    'Longest Streak',
    'Alphabetical',
    'Completion Rate',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Habits'),
        actions: [
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
                        onDeleted: () => setState(() => _selectedCategory = 'All'),
                      ),
                    if (_selectedCategory != 'All' && _selectedSort != 'Recent')
                      const SizedBox(width: 8),
                    if (_selectedSort != 'Recent')
                      Chip(
                        label: Text(_selectedSort),
                        deleteIcon: const Icon(Icons.close, size: 16),
                        onDeleted: () => setState(() => _selectedSort = 'Recent'),
                      ),
                    if (_selectedCategory != 'All' || _selectedSort != 'Recent')
                      const Spacer(),
                    if (_selectedCategory != 'All' || _selectedSort != 'Recent')
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _selectedFilter = 'All';
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
                          label: Text('Sort: $_selectedSort'),
                          deleteIcon: const Icon(Icons.close, size: 16),
                          onDeleted: () => setState(() => _selectedSort = 'Recent'),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final habitServiceAsync = ref.watch(habitServiceProvider);

          return habitServiceAsync.when(
            data: (habitService) => FutureBuilder<List<Habit>>(
              future: habitService.getAllHabits(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingWidget(message: 'Loading habits...');
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return EmptyStateWidget(
                    icon: Icons.track_changes,
                    title: 'No habits yet',
                    subtitle: 'Create your first habit to get started!',
                    action: ElevatedButton.icon(
                      onPressed: () => context.push('/create-habit'),
                      icon: const Icon(Icons.add),
                      label: const Text('Create Habit'),
                    ),
                  );
                }

                final allHabits = snapshot.data!;
                final filteredHabits = _filterAndSortHabits(allHabits);

                // ...existing code...
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
}

// Top-level helper classes

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
    // ...existing code...
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ...existing code...
          ],
        ),
      ),
    );
  }
  // ...existing code...
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
    // ...existing code...
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
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
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
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
                      value: 'complete',
                      child: Row(
                        children: [
                          Icon(Icons.check, size: 20),
                          SizedBox(width: 8),
                          Text('Mark Complete'),
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

            const SizedBox(height: 16),

            // Stats row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatItem(
                  icon: Icons.local_fire_department,
                  label: 'Streak',
                  value: '${habit.currentStreak}',
                  color: habit.currentStreak > 0 ? Colors.orange : Colors.grey,
                ),
                _StatItem(
                  icon: Icons.percent,
                  label: 'Success',
                  value: '${(habit.completionRate * 100).toStringAsFixed(0)}%',
                  color: _getCompletionRateColor(habit.completionRate),
                ),
                _StatItem(
                  icon: Icons.check_circle,
                  label: 'Total',
                  value: '${habit.completions.length}',
                  color: Colors.blue,
                ),
              ],
            ),

            // Progress bar
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: habit.completionRate,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                _getCompletionRateColor(habit.completionRate),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleAction(BuildContext context, String action, WidgetRef ref) {
    switch (action) {
      case 'edit':
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => EditHabitScreen(habit: habit),
          ),
        );
        break;
      case 'complete':
        // Handle marking habit as complete for the current period
        AppLogger.info('Marking habit as complete: ${habit.name}');
        _markHabitComplete(context, ref);
        break;
      case 'delete':
        _showDeleteDialog(context, ref);
        break;
    }
  }
  
  void _markHabitComplete(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    
    // Use Riverpod to access the habitServiceProvider
    final habitServiceAsync = ref.watch(habitServiceProvider);
    
    habitServiceAsync.when(
      data: (habitService) async {
        try {
          // Check if the habit is already completed today
          final isCompleted = habit.isCompletedToday;
          
          if (isCompleted) {
            // If already completed, show a confirmation dialog to remove completion
            _showRemoveCompletionDialog(context, habitService, ref);
          } else {
            // Mark the habit as complete for today
            await habitService.markHabitComplete(habit.id, now);
            
            // Refresh the UI
            ref.invalidate(habitServiceProvider);
            
            // Show success message
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${habit.name} marked as complete for today!'),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          }
        } catch (e) {
          // Show error message
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: $e'),
                backgroundColor: Colors.red,
              ),
            );
          }
          AppLogger.error('Error marking habit as complete', e);
        }
      },
      loading: () {
        // Show loading indicator
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Loading...')),
        );
      },
      error: (error, stack) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error')),
        );
        AppLogger.error('Error accessing habit service', error);
      },
    );
  }
  
  void _showRemoveCompletionDialog(BuildContext context, HabitService habitService, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Already Completed'),
        content: Text('${habit.name} is already marked as complete for today. Do you want to remove this completion?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final now = DateTime.now();
              
              try {
                // Remove the completion for today
                await habitService.removeHabitCompletion(habit.id, now);
                
                // Refresh the UI
                ref.invalidate(habitServiceProvider);
                
                // Show success message
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Removed completion for ${habit.name}'),
                      backgroundColor: Colors.orange,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              } catch (e) {
                // Show error message
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
                AppLogger.error('Error removing habit completion', e);
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Habit'),
        content: Text('Are you sure you want to delete "${habit.name}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Handle delete
              _deleteHabit(context, ref);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
  
  void _deleteHabit(BuildContext context, WidgetRef ref) {
    final habitServiceAsync = ref.watch(habitServiceProvider);
    
    habitServiceAsync.when(
      data: (habitService) async {
        try {
          AppLogger.info('Deleting habit: ${habit.name}');
          await habitService.deleteHabit(habit);
          
          // Refresh the UI
          ref.invalidate(habitServiceProvider);
          
          // Show success message
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${habit.name} has been deleted'),
                backgroundColor: Colors.blue,
                duration: const Duration(seconds: 2),
              ),
            );
          }
        } catch (e) {
          // Show error message
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error deleting habit: $e'),
                backgroundColor: Colors.red,
              ),
            );
          }
          AppLogger.error('Error deleting habit', e);
        }
      },
      loading: () {
        // Show loading indicator
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Loading...')),
        );
      },
      error: (error, stack) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error')),
        );
        AppLogger.error('Error accessing habit service', error);
      },
    );
  }

  Color _getRankColor(int rank) {
    if (rank == 1) return Colors.amber; // Gold
    if (rank == 2) return Colors.grey[400]!; // Silver
    if (rank == 3) return Colors.orange[400]!; // Bronze
    return Colors.blue;
  }

  IconData _getPerformanceIcon() {
    if (habit.completionRate >= 0.8) return Icons.trending_up;
    if (habit.completionRate >= 0.5) return Icons.trending_flat;
    return Icons.trending_down;
  }

  Color _getPerformanceColor() {
    if (habit.completionRate >= 0.8) return Colors.green;
    if (habit.completionRate >= 0.5) return Colors.orange;
    return Colors.red;
  }

  Color _getCompletionRateColor(double rate) {
    if (rate >= 0.8) return Colors.green;
    if (rate >= 0.6) return Colors.blue;
    if (rate >= 0.4) return Colors.orange;
    return Colors.red;
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
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}

// ...existing code...
