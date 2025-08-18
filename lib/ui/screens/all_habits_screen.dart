import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/database.dart';
import '../../domain/model/habit.dart';
import '../../services/logging_service.dart';

import '../widgets/loading_widget.dart';
import '../widgets/create_habit_fab.dart';
import 'edit_habit_screen.dart';

class AllHabitsScreen extends ConsumerStatefulWidget {
  const AllHabitsScreen({super.key});

  @override
  ConsumerState<AllHabitsScreen> createState() => _AllHabitsScreenState();
}

class _AllHabitsScreenState extends ConsumerState<AllHabitsScreen> {
  String _selectedCategory = 'All';
  String _selectedSort = 'Recent';

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
                      const SizedBox(width: 8),
                      Text(choice),
                    ],
                  ),
                );
              }).toList();
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(_getSortIcon(_selectedSort)),
                  const SizedBox(width: 4),
                  Text(_selectedSort),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
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
                          onDeleted: () => setState(() => _selectedCategory = 'All'),
                        ),
                      if (_selectedCategory != 'All' && _selectedSort != 'Recent')
                        const SizedBox(width: 8),
                      if (_selectedSort != 'Recent')
                        Chip(
                          label: Text('Sort: $_selectedSort'),
                          deleteIcon: const Icon(Icons.close, size: 16),
                          onDeleted: () => setState(() => _selectedSort = 'Recent'),
                        ),
                      if (_selectedCategory != 'All' || _selectedSort != 'Recent')
                        const Spacer(),
                      if (_selectedCategory != 'All' || _selectedSort != 'Recent')
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

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredHabits.length,
                  itemBuilder: (context, index) {
                    final habit = filteredHabits[index];
                    final rank = _selectedSort == 'Top Performers' ||
                            _selectedSort == 'Bottom Performers' ||
                            _selectedSort == 'Longest Streak'
                        ? index + 1
                        : null;

                    return _HabitCard(
                      habit: habit,
                      rank: rank,
                      showPerformanceIndicator: _selectedSort.contains('Performers'),
                    );
                  },
                );
              },
            ),
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
                    onPressed: () => ref.invalidate(habitServiceProvider),
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
      filtered = filtered.where((habit) => habit.category == _selectedCategory).toList();
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
                    color: habit.currentStreak > 0 ? Colors.orange : Colors.grey,
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
                    color: habit.completionRate > 0.7 ? Colors.green : 
                           habit.completionRate > 0.4 ? Colors.orange : Colors.red,
                  ),
                ),
                Expanded(
                  child: _StatItem(
                    icon: Icons.calendar_today,
                    label: 'Total',
                    value: '${habit.completions.length}',
                    color: habit.completions.isNotEmpty ? Colors.blue : Colors.grey,
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
                habit.completionRate > 0.7 ? Colors.green : 
                habit.completionRate > 0.4 ? Colors.orange : Colors.red,
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
            content: Text('Are you sure you want to delete "${habit.name}"? This action cannot be undone.'),
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
                    SnackBar(content: Text('${habit.name} deleted successfully')),
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
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Loading...')),
                );
              }
            },
            error: (error, stack) async {
              AppLogger.error('Error accessing habit service', error);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Error accessing habit service')),
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