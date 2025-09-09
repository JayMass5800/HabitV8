import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../services/notification_service.dart';
import '../data/database.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HabitV8'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Welcome header
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.track_changes,
                      size: 48,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Welcome to HabitV8',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your comprehensive habit tracking companion',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.color
                            ?.withValues(alpha: 0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Quick Actions Section
            const Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Main feature buttons
            Row(
              children: [
                Expanded(
                  child: _buildFeatureCard(
                    context,
                    icon: Icons.add_circle,
                    title: 'Create Habit',
                    subtitle: 'Start tracking a new habit',
                    onTap: () => context.push('/create-habit'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildFeatureCard(
                    context,
                    icon: Icons.timeline,
                    title: 'Timeline',
                    subtitle: 'View today\'s habits',
                    onTap: () => context.go('/timeline'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _buildFeatureCard(
                    context,
                    icon: Icons.list_alt,
                    title: 'All Habits',
                    subtitle: 'Manage your habits',
                    onTap: () => context.go('/all-habits'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildFeatureCard(
                    context,
                    icon: Icons.analytics,
                    title: 'Statistics',
                    subtitle: 'View your progress',
                    onTap: () => context.go('/stats'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Habit Overview Section
            const Text(
              'Habit Overview',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Habit stats card
            Consumer(
              builder: (context, ref, child) {
                return ref.watch(habitServiceProvider).when(
                      data: (habitService) => FutureBuilder(
                        future: habitService.getAllHabits(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Card(
                              child: Padding(
                                padding: EdgeInsets.all(20.0),
                                child:
                                    Center(child: CircularProgressIndicator()),
                              ),
                            );
                          }

                          final habits = snapshot.data ?? [];
                          final activeHabits =
                              habits.where((h) => h.isActive).length;
                          final completedToday = habits.where((h) {
                            final today = DateTime.now();
                            return h.completions.any((completion) {
                              return completion.year == today.year &&
                                  completion.month == today.month &&
                                  completion.day == today.day;
                            });
                          }).length;

                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      _buildStatItem(
                                        'Total Habits',
                                        habits.length.toString(),
                                        Icons.track_changes,
                                      ),
                                      _buildStatItem(
                                        'Active',
                                        activeHabits.toString(),
                                        Icons.play_circle,
                                      ),
                                      _buildStatItem(
                                        'Done Today',
                                        completedToday.toString(),
                                        Icons.check_circle,
                                      ),
                                    ],
                                  ),
                                  if (habits.isEmpty) ...[
                                    const SizedBox(height: 16),
                                    const Divider(),
                                    const SizedBox(height: 16),
                                    Text(
                                      'No habits yet. Create your first habit to get started!',
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.color
                                            ?.withValues(alpha: 0.7),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 12),
                                    ElevatedButton.icon(
                                      onPressed: () =>
                                          context.push('/create-habit'),
                                      icon: const Icon(Icons.add),
                                      label: const Text('Create First Habit'),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      loading: () => const Card(
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Center(child: CircularProgressIndicator()),
                        ),
                      ),
                      error: (error, stack) => Card(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              const Icon(Icons.error,
                                  color: Colors.red, size: 48),
                              const SizedBox(height: 8),
                              const Text('Error loading habits'),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: () => setState(() {}),
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
              },
            ),

            const SizedBox(height: 24),

            // Additional features
            const Text(
              'More Features',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _buildFeatureCard(
                    context,
                    icon: Icons.calendar_month,
                    title: 'Calendar',
                    subtitle: 'Monthly view',
                    onTap: () => context.go('/calendar'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildFeatureCard(
                    context,
                    icon: Icons.insights,
                    title: 'Insights',
                    subtitle: 'AI-powered insights',
                    onTap: () => context.go('/insights'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _buildFeatureCard(
                    context,
                    icon: Icons.health_and_safety,
                    title: 'Health Integration',
                    subtitle: 'Connect health data',
                    onTap: () => context.go('/health-integration'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildFeatureCard(
                    context,
                    icon: Icons.settings,
                    title: 'Settings',
                    subtitle: 'App preferences',
                    onTap: () => context.go('/settings'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Debug section (can be removed in production)
            if (const bool.fromEnvironment('dart.vm.product') == false) ...[
              const Divider(),
              const SizedBox(height: 16),
              const Text(
                'Debug Tools',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final messenger = ScaffoldMessenger.of(context);
                        await NotificationService.showTestNotification();
                        if (mounted) {
                          messenger.showSnackBar(
                            const SnackBar(
                                content: Text('Test notification sent!')),
                          );
                        }
                      },
                      icon: const Icon(Icons.notifications),
                      label: const Text('Test Notification'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final messenger = ScaffoldMessenger.of(context);
                        await NotificationService.testScheduledNotification();
                        if (mounted) {
                          messenger.showSnackBar(
                            const SnackBar(
                              content: Text('Scheduled notification in 10s!'),
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.schedule),
                      label: const Text('Test Scheduled'),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 32,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.color
                      ?.withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          size: 24,
          color: Theme.of(context).primaryColor,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context)
                .textTheme
                .bodySmall
                ?.color
                ?.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}
