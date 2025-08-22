import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../data/database.dart';
import '../../domain/model/habit.dart';
import '../../services/trend_analysis_service.dart';
import '../../services/achievements_service.dart';
import '../../services/health_service.dart';
import '../../services/health_habit_integration_service.dart';
import '../../services/habit_stats_service.dart';
import '../../services/logging_service.dart';
import '../widgets/progressive_disclosure.dart';

class InsightsScreen extends ConsumerStatefulWidget {
  const InsightsScreen({super.key});

  @override
  ConsumerState<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends ConsumerState<InsightsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Map<String, dynamic>? _trendAnalysis;
  Map<String, dynamic>? _gamificationStats;
  Map<String, dynamic>? _healthSummary;

  Map<String, dynamic>? _integrationStatus;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Restore all three tabs: Overview, Trends, and Achievements
    _tabController = TabController(length: 3, vsync: this);
    _loadAllData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadAllData() async {
    setState(() => _isLoading = true);

    try {
      final habitServiceAsync = ref.read(habitServiceProvider);
      await habitServiceAsync.when(
        data: (habitService) async {
          final habits = await habitService.getAllHabits();
          final habitsData = habits
              .map(
                (h) => {
                  'id': h.id,
                  'name': h.name,
                  'category': h.category,
                  'currentStreak': h.currentStreak,
                  'completionRate': h.completionRate,
                  'reminderTime': h.reminderTime?.toString(),
                  'difficulty': h.difficulty.name,
                  'completions': h.completions
                      .map(
                        (c) => {
                          'id': DateTime.now().millisecondsSinceEpoch
                              .toString(),
                          'habitId': h.id,
                          'completedAt': c,
                        },
                      )
                      .toList(),
                },
              )
              .toList();

          final allCompletions = habits
              .expand(
                (h) => h.completions.map(
                  (c) => {
                    'id': DateTime.now().millisecondsSinceEpoch.toString(),
                    'habitId': h.id,
                    'completedAt': c,
                  },
                ),
              )
              .toList();

          // Load trend analysis (only if enough data)
          _trendAnalysis = await TrendAnalysisService.analyzeHabitTrends(
            habits: habitsData,
            completions: allCompletions,
          );

          // Load gamification stats
          _gamificationStats = await AchievementsService.getGamificationStats(
            habits: habitsData,
            completions: allCompletions,
          );

          // Check for new achievements
          final newAchievements =
              await AchievementsService.checkForNewAchievements(
                habits: habitsData,
                completions: allCompletions,
              );

          if (newAchievements.isNotEmpty && mounted) {
            _showNewAchievements(newAchievements);
          }

          // Load health summary if available
          try {
            AppLogger.info('Checking health permissions...');
            final hasPermissions = await HealthService.hasPermissions();
            AppLogger.info('Health permissions status: $hasPermissions');

            if (hasPermissions) {
              AppLogger.info('Loading health summary...');
              _healthSummary = await HealthService.getTodayHealthSummary();
              AppLogger.info(
                'Health summary loaded: ${_healthSummary?.keys.join(', ')}',
              );

              // Check if we got actual data
              if (_healthSummary != null &&
                  _healthSummary!.containsKey('error')) {
                AppLogger.warning(
                  'Health summary contains error: ${_healthSummary!['error']}',
                );
                // Still keep the summary to show the error state
              }

              // Load integration status
              try {
                _integrationStatus =
                    await HealthHabitIntegrationService.getIntegrationStatus(
                      habitService: habitService,
                    );
                AppLogger.info('Integration status loaded successfully');
              } catch (integrationError) {
                AppLogger.error(
                  'Failed to load integration status',
                  integrationError,
                );
                _integrationStatus = null;
              }
            } else {
              AppLogger.info(
                'Health permissions not granted, skipping health data load',
              );
              _healthSummary = null;
              _integrationStatus = null;
            }
          } catch (e) {
            // Handle health service error quietly
            AppLogger.error('Failed to load health summary', e);
            // Set empty health summary to show placeholder
            _healthSummary = null;
            _integrationStatus = null;
          }
        },
        loading: () async {
          // Wait for provider to load
          await Future.delayed(const Duration(milliseconds: 500));
        },
        error: (error, stack) {
          AppLogger.error('Error loading habit data for insights', error);
        },
      );
    } catch (e) {
      AppLogger.error('Error loading insights data', e);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showNewAchievements(List<Achievement> achievements) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🎉 New Achievement!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          // Keep achievement modal logic intact; only the Achievements tab UI was removed
          children: achievements
              .map(
                (achievement) => ListTile(
                  leading: Text(
                    achievement.icon,
                    style: const TextStyle(fontSize: 24),
                  ),
                  title: Text(achievement.title),
                  subtitle: Text(achievement.description),
                  trailing: Text('+${achievement.xpReward} XP'),
                ),
              )
              .toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Awesome!'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Insights'),
        // Three-tab layout: Overview, Trends, and Achievements
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Trends'),
            Tab(text: 'Achievements'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(),
                _buildTrendsTab(),
                _buildAchievementsTab(),
              ],
            ),
    );
  }

  Widget _buildOverviewTab() {
    return Consumer(
      builder: (context, ref, child) {
        final habitServiceAsync = ref.watch(habitServiceProvider);

        return habitServiceAsync.when(
          data: (habitService) => FutureBuilder<List<Habit>>(
            future: habitService.getAllHabits(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        size: 64,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No insights yet',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Start tracking habits to get personalized insights!',
                        style: TextStyle(color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }

              final habits = snapshot.data!;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // D. The "Big Four" Performance Cards - moved to top
                    _buildBigFourPerformanceCards(habits),
                    const SizedBox(height: 24),

                    // E. Habit Performance Deep Dive
                    _buildHabitPerformanceDeepDive(habits),
                    const SizedBox(height: 24),

                    // G. Enhanced Health Integration
                    if (_integrationStatus != null) ...[
                      _buildEnhancedHealthIntegrationSection(),
                      const SizedBox(height: 24),
                    ],

                    // Health Debug Section - Always visible
                    _buildHealthDebugSection(),
                    const SizedBox(height: 24),

                    // Moved: Conditional Health Hub (Your Health & Habit Connection)
                    _buildConditionalHealthHub(habits),
                  ],
                ),
              );
            },
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) =>
              Center(child: Text('Error loading data: $error')),
        );
      },
    );
  }

  Widget _buildMotivationalHeader(String title, String subtitle) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade400, Colors.purple.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildGamificationCard() {
    final stats = _gamificationStats!;
    return ProgressiveDisclosure(
      title: 'Level ${stats['level']} ${stats['rank']}',
      subtitle: 'View detailed achievements and progress',
      summary: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.emoji_events, color: Colors.amber, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: LinearProgressIndicator(
                  value: stats['levelProgress'],
                  backgroundColor: Colors.grey[300],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${stats['xp']} XP',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                'Achievements',
                '${stats['achievementsUnlocked']}',
              ),
              _buildStatItem('Max Streak', '${stats['maxStreak']}'),
              _buildStatItem(
                'Rate',
                '${(stats['completionRate'] * 100).toInt()}%',
              ),
            ],
          ),
        ],
      ),
      details: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Detailed Progress',
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildDetailRow('Current Level', 'Level ${stats['level']}'),
          _buildDetailRow('Rank', stats['rank']),
          _buildDetailRow(
            'Total XP',
            '${stats['xp']} / ${stats['nextLevelXP']}',
          ),
          _buildDetailRow(
            'Achievements Unlocked',
            '${stats['achievementsUnlocked']} / ${stats['totalAchievements']}',
          ),
          _buildDetailRow('Maximum Streak', '${stats['maxStreak']} days'),
          _buildDetailRow(
            'Overall Completion Rate',
            '${(stats['completionRate'] * 100).toStringAsFixed(1)}%',
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: stats['levelProgress'],
            backgroundColor: Colors.grey[300],
          ),
          const SizedBox(height: 8),
          Text(
            'Progress to next level: ${((stats['levelProgress'] as double) * 100).toInt()}%',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
          ),
        ],
      ),
      headerColor: Colors.amber,
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendsTab() {
    if (_trendAnalysis == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final analysis = _trendAnalysis!;

    if (analysis['hasEnoughData'] != true) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.trending_up, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              Text(
                analysis['message'] ?? 'Building trend data...',
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              if (analysis['daysUntilTrends'] != null)
                Text(
                  '${analysis['daysUntilTrends']} more days until trends are available',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Motivational Header
          _buildMotivationalHeader(
            'Trend Analysis',
            'Spot patterns and optimize your habit journey! 📈',
          ),
          const SizedBox(height: 24),

          // Overall Trends Card
          _buildOverallTrendsCard(analysis['overallTrends']),
          const SizedBox(height: 16),

          // Weekly Patterns Card
          _buildWeeklyPatternsCard(analysis['weeklyPatterns']),
          const SizedBox(height: 16),

          // Individual Habit Trends
          if (analysis['habitTrends'] != null)
            _buildIndividualTrendsCard(analysis['habitTrends']),

          // Insights and Recommendations
          if (analysis['insights'] != null ||
              analysis['recommendations'] != null)
            _buildTrendInsightsCard(analysis),
        ],
      ),
    );
  }

  Widget _buildOverallTrendsCard(Map<String, dynamic> overallTrends) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Overall Trend',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  _getTrendIcon(overallTrends['direction']),
                  color: _getTrendColor(overallTrends['direction']),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    overallTrends['message'] ?? 'Analyzing trends...',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (overallTrends['averageDailyCompletions'] != null)
              Text(
                'Average daily completions: ${overallTrends['averageDailyCompletions'].toStringAsFixed(1)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyPatternsCard(Map<String, dynamic> weeklyPatterns) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Weekly Patterns',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    const Text('Best Day'),
                    Text(
                      weeklyPatterns['bestDay'] ?? 'N/A',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text('Worst Day'),
                    Text(
                      weeklyPatterns['worstDay'] ?? 'N/A',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIndividualTrendsCard(Map<String, dynamic> habitTrends) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Individual Habit Trends',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            ...habitTrends.entries.map((entry) {
              final trendData = entry.value as Map<String, dynamic>;
              return ListTile(
                leading: Icon(
                  _getTrendIcon(trendData['direction']),
                  color: _getTrendColor(trendData['direction']),
                ),
                title: Text(trendData['habitName'] ?? 'Unknown Habit'),
                subtitle: Text(trendData['message'] ?? ''),
                trailing: Text(
                  '${(trendData['completionRate'] * 100).toStringAsFixed(1)}%',
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendInsightsCard(Map<String, dynamic> analysis) {
    final insights = analysis['insights'] as List<String>? ?? [];
    final recommendations = analysis['recommendations'] as List<String>? ?? [];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Insights & Recommendations',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            if (insights.isNotEmpty) ...[
              const Text(
                '💡 Insights:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ...insights.map(
                (insight) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text('• $insight'),
                ),
              ),
              const SizedBox(height: 8),
            ],
            if (recommendations.isNotEmpty) ...[
              const Text(
                '🎯 Recommendations:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ...recommendations.map(
                (rec) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text('• $rec'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementsTab() {
    if (_gamificationStats == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return FutureBuilder<List<Achievement>>(
      future: AchievementsService.getUnlockedAchievements(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final unlockedAchievements = snapshot.data ?? [];
        final allAchievements = AchievementsService.getAllAchievements();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Motivational Header - moved to top
              _buildMotivationalHeader(
                'Achievements & Rewards',
                'Celebrate your progress and unlock new milestones! 🏆',
              ),
              const SizedBox(height: 24),

              // Gamification Card below the banner
              if (_gamificationStats != null) ...[
                _buildGamificationCard(),
                const SizedBox(height: 24),
              ],

              // Recent Achievements
              if (unlockedAchievements.isNotEmpty) ...[
                Text(
                  'Unlocked Achievements',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                ...unlockedAchievements
                    .take(5)
                    .map(
                      (achievement) => Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.amber,
                            child: Text(
                              achievement.icon,
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                          title: Text(achievement.title),
                          subtitle: Text(achievement.description),
                          trailing: Text('+${achievement.xpReward} XP'),
                        ),
                      ),
                    ),
                const SizedBox(height: 16),
              ],

              // Available Achievements
              Text(
                'Available Achievements',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              FutureBuilder<Map<String, double>>(
                future: AchievementsService.getAchievementProgress(
                  habits: [],
                  completions: [],
                ),
                builder: (context, progressSnapshot) {
                  final progress = progressSnapshot.data ?? {};

                  return Column(
                    children: allAchievements.map((achievement) {
                      final isUnlocked = unlockedAchievements.any(
                        (a) => a.id == achievement.id,
                      );
                      final achievementProgress =
                          progress[achievement.id] ?? 0.0;

                      return Card(
                        color: isUnlocked ? Colors.amber[50] : null,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: isUnlocked
                                ? Colors.amber
                                : Colors.grey,
                            child: Text(
                              isUnlocked ? achievement.icon : '🔒',
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                          title: Text(
                            achievement.title,
                            style: TextStyle(
                              color: isUnlocked ? Colors.amber[700] : null,
                              fontWeight: isUnlocked ? FontWeight.bold : null,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(achievement.description),
                              if (!isUnlocked) ...[
                                const SizedBox(height: 4),
                                LinearProgressIndicator(
                                  value: achievementProgress,
                                  backgroundColor: Colors.grey[300],
                                ),
                                Text(
                                  'Progress: ${(achievementProgress * 100).toStringAsFixed(0)}%',
                                ),
                              ],
                            ],
                          ),
                          trailing: Text(
                            isUnlocked
                                ? 'Unlocked!'
                                : '+${achievement.xpReward} XP',
                            style: TextStyle(
                              color: isUnlocked
                                  ? Colors.amber[700]
                                  : Colors.grey,
                              fontWeight: isUnlocked ? FontWeight.bold : null,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEnhancedHealthIntegrationSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.health_and_safety, color: Colors.green),
                const SizedBox(width: 8),
                Text(
                  'Health Integration',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.green.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.auto_awesome,
                        size: 14,
                        color: Colors.green.shade700,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Active',
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
            ),
            const SizedBox(height: 16),

            // Health Analytics Overview
            _buildHealthAnalyticsOverview(),
            const SizedBox(height: 16),

            // Health-Habit Correlations
            _buildHealthHabitCorrelations(),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthAnalyticsOverview() {
    final health = _healthSummary!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Today\'s Health Metrics',
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildHealthMetricTile(
                'Steps',
                '${health['steps']}',
                Icons.directions_walk,
                Colors.blue,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildHealthMetricTile(
                'Calories',
                '${(health['activeCalories'] as double).round()}',
                Icons.local_fire_department,
                Colors.orange,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildHealthMetricTile(
                'Sleep',
                '${(health['sleepHours'] as double).toStringAsFixed(1)}h',
                Icons.bedtime,
                Colors.purple,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHealthMetricTile(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.bold, color: color),
          ),
          Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildHealthHabitCorrelations() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Health-Habit Insights',
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue.withValues(alpha: 0.2)),
          ),
          child: Row(
            children: [
              Icon(Icons.insights, color: Colors.blue, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Your health data is being used to automatically complete related habits and provide personalized insights.',
                  style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  IconData _getTrendIcon(String direction) {
    switch (direction.toLowerCase()) {
      case 'up':
      case 'improving':
        return Icons.trending_up;
      case 'down':
      case 'declining':
        return Icons.trending_down;
      case 'stable':
      case 'steady':
        return Icons.trending_flat;
      default:
        return Icons.help;
    }
  }

  Color _getTrendColor(String direction) {
    switch (direction.toLowerCase()) {
      case 'up':
      case 'improving':
        return Colors.green;
      case 'down':
      case 'declining':
        return Colors.red;
      case 'stable':
      case 'steady':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  // A. The "Big Four" Performance Cards
  Widget _buildBigFourPerformanceCards(List<Habit> habits) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildOverallCompletionRateCard(habits)),
            const SizedBox(width: 12),
            Expanded(child: _buildCurrentStreakCard(habits)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildConsistencyScoreCard(habits)),
            const SizedBox(width: 12),
            Expanded(child: _buildMostPowerfulDayCard(habits)),
          ],
        ),
      ],
    );
  }

  // Card 1: Overall Completion Rate (Vibrant Green Gradient)
  Widget _buildOverallCompletionRateCard(List<Habit> habits) {
    final statsService = HabitStatsService();
    double totalCompletionRate = 0.0;
    double previousCompletionRate = 0.0;
    List<double> sparklineData = [];

    if (habits.isNotEmpty) {
      // Calculate current 30-day completion rate
      final completionRates = habits
          .map((h) => statsService.getCompletionRate(h, days: 30))
          .toList();
      totalCompletionRate =
          completionRates.reduce((a, b) => a + b) / completionRates.length;

      // Calculate previous 30-day completion rate for comparison
      final now = DateTime.now();
      final previousPeriodHabits = habits.map((h) {
        final previousCompletions = h.completions
            .where(
              (c) =>
                  c.isBefore(now.subtract(const Duration(days: 30))) &&
                  c.isAfter(now.subtract(const Duration(days: 60))),
            )
            .toList();
        // Create a temporary habit with previous period completions for calculation
        final tempHabit = Habit.create(
          name: h.name,
          description: h.description,
          category: h.category,
          colorValue: h.colorValue,
          frequency: h.frequency,
          difficulty: h.difficulty,
        );
        tempHabit.completions = previousCompletions;
        tempHabit.createdAt = h.createdAt;
        return tempHabit;
      }).toList();

      if (previousPeriodHabits.isNotEmpty) {
        final previousRates = previousPeriodHabits
            .map((h) => statsService.getCompletionRate(h, days: 30))
            .toList();
        previousCompletionRate =
            previousRates.reduce((a, b) => a + b) / previousRates.length;
      }

      // Generate sparkline data for last 4 weeks
      for (int week = 3; week >= 0; week--) {
        final weekStart = now.subtract(Duration(days: (week + 1) * 7));
        final weekEnd = now.subtract(Duration(days: week * 7));
        final weekCompletions = habits
            .expand(
              (h) => h.completions.where(
                (c) => c.isAfter(weekStart) && c.isBefore(weekEnd),
              ),
            )
            .length;
        final expectedCompletions = habits.length * 7; // Assuming daily habits
        sparklineData.add(
          expectedCompletions > 0 ? weekCompletions / expectedCompletions : 0.0,
        );
      }
    }

    final percentageChange = previousCompletionRate > 0
        ? ((totalCompletionRate - previousCompletionRate) /
              previousCompletionRate *
              100)
        : 0.0;

    return _buildPerformanceCard(
      title: 'Overall Completion Rate',
      value: '${(totalCompletionRate * 100).toStringAsFixed(0)}%',
      insight:
          '${percentageChange >= 0 ? '+' : ''}${percentageChange.toStringAsFixed(1)}% vs. previous 30 days',
      gradient: [Colors.green.shade400, Colors.green.shade600],
      icon: Icons.check_circle,
      sparklineData: sparklineData,
    );
  }

  // Card 2: Current Streak (Fiery Orange Gradient)
  Widget _buildCurrentStreakCard(List<Habit> habits) {
    final statsService = HabitStatsService();
    int longestCurrentStreak = 0;
    String bestHabitName = '';
    int bestEverStreak = 0;

    if (habits.isNotEmpty) {
      Habit? bestHabit;
      for (final habit in habits) {
        final streakInfo = statsService.getStreakInfo(habit);
        if (streakInfo.current > longestCurrentStreak) {
          longestCurrentStreak = streakInfo.current;
          bestHabit = habit;
        }
        if (streakInfo.longest > bestEverStreak) {
          bestEverStreak = streakInfo.longest;
        }
      }
      if (bestHabit != null) {
        bestHabitName = bestHabit.name;
      }
    }

    return _buildPerformanceCard(
      title: 'Current Streak',
      value: '$longestCurrentStreak Days',
      insight: bestHabitName.isNotEmpty
          ? '(for \'$bestHabitName\')\nYour best streak ever is $bestEverStreak days'
          : 'Start a habit to build streaks!',
      gradient: [Colors.orange.shade400, Colors.deepOrange.shade600],
      icon: Icons.local_fire_department,
    );
  }

  // Card 3: Consistency Score (Deep Blue Gradient)
  Widget _buildConsistencyScoreCard(List<Habit> habits) {
    final statsService = HabitStatsService();
    double averageConsistency = 0.0;
    String consistencyLabel = 'Getting Started';

    if (habits.isNotEmpty) {
      final consistencyScores = habits
          .map((h) => statsService.getConsistencyScore(h))
          .toList();
      averageConsistency =
          consistencyScores.reduce((a, b) => a + b) / consistencyScores.length;

      if (averageConsistency >= 80) {
        consistencyLabel = 'Highly Consistent';
      } else if (averageConsistency >= 60) {
        consistencyLabel = 'Building Momentum';
      } else if (averageConsistency >= 40) {
        consistencyLabel = 'Finding Rhythm';
      } else {
        consistencyLabel = 'Getting Started';
      }
    }

    return _buildPerformanceCard(
      title: 'Consistency Score',
      value: averageConsistency.toStringAsFixed(0),
      insight: consistencyLabel,
      gradient: [Colors.blue.shade600, Colors.blue.shade800],
      icon: Icons.timeline,
    );
  }

  // Card 4: Most Powerful Day (Royal Purple Gradient)
  Widget _buildMostPowerfulDayCard(List<Habit> habits) {
    final statsService = HabitStatsService();
    String mostPowerfulDay = 'Monday';
    double improvementPercentage = 0.0;

    if (habits.isNotEmpty) {
      final dayCompletions = <int, int>{};
      final dayTotals = <int, int>{};

      // Initialize counters
      for (int i = 1; i <= 7; i++) {
        dayCompletions[i] = 0;
        dayTotals[i] = 0;
      }

      // Count completions by day of week
      for (final habit in habits) {
        final weeklyPattern = statsService.getWeeklyPattern(habit);
        for (int i = 0; i < 7; i++) {
          final dayOfWeek = i + 1; // Monday = 1, Sunday = 7
          dayCompletions[dayOfWeek] =
              (dayCompletions[dayOfWeek] ?? 0) +
              (weeklyPattern[i] * 100).round();
          dayTotals[dayOfWeek] = (dayTotals[dayOfWeek] ?? 0) + 100;
        }
      }

      // Find the day with highest completion rate
      double bestRate = 0.0;
      int bestDay = 1;
      for (int day = 1; day <= 7; day++) {
        final rate = dayTotals[day]! > 0
            ? dayCompletions[day]! / dayTotals[day]!
            : 0.0;
        if (rate > bestRate) {
          bestRate = rate;
          bestDay = day;
        }
      }

      // Calculate average rate for comparison
      final totalCompletions = dayCompletions.values.reduce((a, b) => a + b);
      final totalPossible = dayTotals.values.reduce((a, b) => a + b);
      final averageRate = totalPossible > 0
          ? totalCompletions / totalPossible
          : 0.0;

      improvementPercentage = averageRate > 0
          ? ((bestRate - averageRate) / averageRate * 100)
          : 0.0;

      final dayNames = [
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday',
      ];
      mostPowerfulDay = dayNames[bestDay - 1];
    }

    return _buildPerformanceCard(
      title: 'Most Powerful Day',
      value: mostPowerfulDay,
      insight:
          'You complete ${improvementPercentage.toStringAsFixed(0)}% more habits on this day than your average',
      gradient: [Colors.purple.shade600, Colors.purple.shade800],
      icon: Icons.star,
    );
  }

  // Helper method to build performance cards
  Widget _buildPerformanceCard({
    required String title,
    required String value,
    required String insight,
    required List<Color> gradient,
    required IconData icon,
    List<double>? sparklineData,
  }) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: gradient.first.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.white, size: 24),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (sparklineData != null && sparklineData.isNotEmpty)
                  SizedBox(
                    width: 60,
                    height: 20,
                    child: _buildSparkline(sparklineData),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              insight,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
                height: 1.2,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build sparkline charts
  Widget _buildSparkline(List<double> data) {
    if (data.isEmpty) return const SizedBox();

    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: data
                .asMap()
                .entries
                .map((e) => FlSpot(e.key.toDouble(), e.value))
                .toList(),
            isCurved: true,
            color: Colors.white,
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
        ],
        minX: 0,
        maxX: (data.length - 1).toDouble(),
        minY: data.reduce((a, b) => a < b ? a : b) * 0.8,
        maxY: data.reduce((a, b) => a > b ? a : b) * 1.2,
      ),
    );
  }

  // B. Habit Performance Deep Dive
  Widget _buildHabitPerformanceDeepDive(List<Habit> habits) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Habit Performance Deep Dive',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 20),

            // Trend Analysis Chart
            _buildTrendAnalysisChart(habits),
            const SizedBox(height: 24),

            // AI-Generated Insights
            _buildAIGeneratedInsights(habits),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendAnalysisChart(List<Habit> habits) {
    if (habits.isEmpty) {
      return Container(
        height: 200,
        alignment: Alignment.center,
        child: const Text('No habit data available for trend analysis'),
      );
    }

    // Generate weekly completion rate data for last 12 weeks
    final now = DateTime.now();
    final weeklyData = <FlSpot>[];
    final volumeData = <FlSpot>[];

    for (int week = 11; week >= 0; week--) {
      final weekStart = now.subtract(Duration(days: (week + 1) * 7));
      final weekEnd = now.subtract(Duration(days: week * 7));

      int totalCompletions = 0;
      int expectedCompletions = 0;

      for (final habit in habits) {
        final weekCompletions = habit.completions
            .where((c) => c.isAfter(weekStart) && c.isBefore(weekEnd))
            .length;
        totalCompletions += weekCompletions;

        // Calculate expected completions based on habit frequency
        switch (habit.frequency) {
          case HabitFrequency.daily:
            expectedCompletions += 7;
            break;
          case HabitFrequency.weekly:
            expectedCompletions += 1;
            break;
          case HabitFrequency.monthly:
            expectedCompletions += (week == 0)
                ? 1
                : 0; // Only count if it's the current week
            break;
          default:
            expectedCompletions += 7; // Default to daily
        }
      }

      final completionRate = expectedCompletions > 0
          ? (totalCompletions / expectedCompletions)
          : 0.0;
      weeklyData.add(FlSpot((11 - week).toDouble(), completionRate * 100));
      volumeData.add(
        FlSpot((11 - week).toDouble(), totalCompletions.toDouble()),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Weekly Completion Rate (%)',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: 20,
                getDrawingHorizontalLine: (value) {
                  return FlLine(color: Colors.grey[300]!, strokeWidth: 1);
                },
              ),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        '${value.toInt()}%',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    interval: 2,
                    getTitlesWidget: (value, meta) {
                      final weeksAgo = 11 - value.toInt();
                      return Text(
                        '${weeksAgo}w',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      );
                    },
                  ),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border(
                  left: BorderSide(color: Colors.grey[300]!),
                  bottom: BorderSide(color: Colors.grey[300]!),
                ),
              ),
              lineBarsData: [
                // Completion Rate Line
                LineChartBarData(
                  spots: weeklyData,
                  isCurved: true,
                  color: Colors.blue[600]!,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) {
                      return FlDotCirclePainter(
                        radius: 4,
                        color: Colors.blue[600]!,
                        strokeWidth: 2,
                        strokeColor: Colors.white,
                      );
                    },
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    color: Colors.blue[600]!.withValues(alpha: 0.1),
                  ),
                ),
              ],
              minX: 0,
              maxX: 11,
              minY: 0,
              maxY: 100,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: Colors.blue[600],
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            const Text('Weekly Completion Rate'),
          ],
        ),
      ],
    );
  }

  Widget _buildAIGeneratedInsights(List<Habit> habits) {
    final insights = _generateDynamicInsights(habits);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'AI-Generated Insights',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        ...insights.map(
          (insight) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  margin: const EdgeInsets.only(top: 6, right: 12),
                  decoration: BoxDecoration(
                    color: Colors.blue[600],
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(
                  child: Text(
                    insight,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(height: 1.4),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<String> _generateDynamicInsights(List<Habit> habits) {
    final insights = <String>[];
    final statsService = HabitStatsService();

    if (habits.isEmpty) {
      return ['Start tracking habits to unlock personalized insights!'];
    }

    // Analyze weekend vs weekday performance
    final weekendHabits = <String, double>{};
    final weekdayHabits = <String, double>{};

    for (final habit in habits) {
      final weeklyPattern = statsService.getWeeklyPattern(habit);
      final weekdayAvg =
          (weeklyPattern[0] +
              weeklyPattern[1] +
              weeklyPattern[2] +
              weeklyPattern[3] +
              weeklyPattern[4]) /
          5;
      final weekendAvg = (weeklyPattern[5] + weeklyPattern[6]) / 2;

      weekdayHabits[habit.name] = weekdayAvg;
      weekendHabits[habit.name] = weekendAvg;

      // Check for significant weekend drops
      if (weekdayAvg > 0.5 && weekendAvg < weekdayAvg * 0.6) {
        insights.add(
          "We've noticed a trend: Your completion rate for '${habit.name}' drops by ${((1 - weekendAvg / weekdayAvg) * 100).toStringAsFixed(0)}% on weekends. Consider scheduling it earlier in the day.",
        );
      }
    }

    // Find consistently successful habits
    final consistentHabits = habits.where((h) {
      final rate = statsService.getCompletionRate(h, days: 14);
      return rate >= 0.9;
    }).toList();

    if (consistentHabits.isNotEmpty) {
      final habit = consistentHabits.first;
      insights.add(
        "You've successfully completed '${habit.name}' consistently for the past 2 weeks. Amazing work!",
      );
    }

    // Analyze category performance
    final categoryPerformance = <String, List<double>>{};
    for (final habit in habits) {
      final rate = statsService.getCompletionRate(habit, days: 30);
      categoryPerformance.putIfAbsent(habit.category, () => []).add(rate);
    }

    String? bestCategory;
    double bestCategoryRate = 0.0;
    categoryPerformance.forEach((category, rates) {
      final avgRate = rates.reduce((a, b) => a + b) / rates.length;
      if (avgRate > bestCategoryRate) {
        bestCategoryRate = avgRate;
        bestCategory = category;
      }
    });

    if (bestCategory != null && bestCategoryRate > 0.8) {
      insights.add(
        "Your '$bestCategory' category has a ${(bestCategoryRate * 100).toStringAsFixed(0)}% completion rate, making it your most consistent category.",
      );
    }

    // Analyze momentum trends
    final momentumHabits = habits.where((h) {
      final momentum = statsService.getMomentum(h);
      return momentum > 0.2;
    }).toList();

    if (momentumHabits.isNotEmpty) {
      insights.add(
        "You're building great momentum! ${momentumHabits.length} of your habits show positive trends this week.",
      );
    }

    // Default insights if none generated
    if (insights.isEmpty) {
      insights.addAll([
        "Keep tracking your habits to unlock deeper insights about your patterns.",
        "Your habit journey is just beginning - consistency is key to building lasting change.",
        "Focus on completing one habit at a time to build sustainable routines.",
      ]);
    }

    return insights.take(3).toList(); // Limit to 3 insights as specified
  }

  // C. Conditional Health Hub: Correlating Effort with Wellness
  Widget _buildConditionalHealthHub(List<Habit> habits) {
    return FutureBuilder<bool>(
      future: HealthService.hasPermissions(),
      builder: (context, snapshot) {
        final hasPermissions = snapshot.data ?? false;

        if (!hasPermissions) {
          return _buildHealthPermissionCard();
        } else {
          return _buildActiveHealthHub(habits);
        }
      },
    );
  }

  // Default State (Permissions NOT Granted)
  Widget _buildHealthPermissionCard() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [
                  theme.colorScheme.surface,
                  theme.colorScheme.surfaceContainerHighest,
                ]
              : [Colors.teal.shade50, Colors.blue.shade50],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? theme.colorScheme.outline.withValues(alpha: 0.3)
              : Colors.teal.shade200,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: isDark
                    ? theme.colorScheme.primaryContainer
                    : Colors.teal.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.health_and_safety,
                size: 40,
                color: isDark
                    ? theme.colorScheme.onPrimaryContainer
                    : Colors.teal.shade600,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Unlock Deeper Insights into Your Health',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Grant permission to Health Connect / HealthKit to see how your habits impact key metrics like sleep, heart rate, and activity levels. Discover the direct link between your efforts and your well-being.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                try {
                  final result = await HealthService.requestPermissions();
                  if (result.granted && mounted) {
                    setState(() {
                      _loadAllData(); // Reload data after permissions granted
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                          'Health permissions granted successfully!',
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                          'Health permissions were not granted. Please try again or check your device settings.',
                        ),
                        backgroundColor: Colors.orange,
                      ),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to connect to health data: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Connect to Health Data',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Active State (Permissions GRANTED)
  Widget _buildActiveHealthHub(List<Habit> habits) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark
                        ? theme.colorScheme.primaryContainer
                        : Colors.teal.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.favorite,
                    color: isDark
                        ? theme.colorScheme.onPrimaryContainer
                        : Colors.teal.shade600,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Your Health & Habit Connection',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Health Data Modules
            if (_healthSummary != null) ..._buildHealthDataModules(habits),

            // Fallback if no health data available
            if (_healthSummary == null) _buildHealthDataPlaceholder(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildHealthDataModules(List<Habit> habits) {
    final modules = <Widget>[];

    // Module: Sleep & Habit Performance
    modules.add(_buildSleepHabitModule(habits));
    modules.add(const SizedBox(height: 20));

    // Module: Activity & Energy Levels
    modules.add(_buildActivityEnergyModule(habits));
    modules.add(const SizedBox(height: 20));

    // Module: Mindfulness & Heart Rate (if available)
    if (_healthSummary != null) {
      modules.add(_buildMindfulnessHeartRateModule(habits));
    }

    return modules;
  }

  Widget _buildSleepHabitModule(List<Habit> habits) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sleep & Habit Performance',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: isDark ? theme.colorScheme.primary : Colors.indigo[700],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          height: 150,
          decoration: BoxDecoration(
            color: isDark
                ? theme.colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.3,
                  )
                : Colors.indigo.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark
                  ? theme.colorScheme.outline.withValues(alpha: 0.3)
                  : Colors.indigo.shade200,
            ),
          ),
          child: _buildSleepCorrelationChart(habits),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark
                ? theme.colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.3,
                  )
                : Colors.indigo.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                Icons.lightbulb,
                color: isDark ? theme.colorScheme.primary : Colors.indigo[600],
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _generateSleepInsight(habits),
                  style: TextStyle(
                    color: isDark
                        ? theme.colorScheme.onSurface
                        : Colors.indigo[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActivityEnergyModule(List<Habit> habits) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Activity & Energy Levels',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: isDark ? theme.colorScheme.secondary : Colors.orange[700],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          height: 150,
          decoration: BoxDecoration(
            color: isDark
                ? theme.colorScheme.secondaryContainer.withValues(alpha: 0.3)
                : Colors.orange.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark
                  ? theme.colorScheme.outline.withValues(alpha: 0.3)
                  : Colors.orange.shade200,
            ),
          ),
          child: _buildActivityCorrelationChart(habits),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark
                ? theme.colorScheme.secondaryContainer.withValues(alpha: 0.3)
                : Colors.orange.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                Icons.lightbulb,
                color: isDark
                    ? theme.colorScheme.secondary
                    : Colors.orange[600],
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _generateActivityInsight(habits),
                  style: TextStyle(
                    color: isDark
                        ? theme.colorScheme.onSurface
                        : Colors.orange[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMindfulnessHeartRateModule(List<Habit> habits) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mindfulness & Heart Rate',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: isDark ? theme.colorScheme.tertiary : Colors.purple[700],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          height: 150,
          decoration: BoxDecoration(
            color: isDark
                ? theme.colorScheme.tertiaryContainer.withValues(alpha: 0.3)
                : Colors.purple.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark
                  ? theme.colorScheme.outline.withValues(alpha: 0.3)
                  : Colors.purple.shade200,
            ),
          ),
          child: _buildHeartRateTrendChart(habits),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark
                ? theme.colorScheme.tertiaryContainer.withValues(alpha: 0.3)
                : Colors.purple.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                Icons.lightbulb,
                color: isDark ? theme.colorScheme.tertiary : Colors.purple[600],
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _generateHeartRateInsight(habits),
                  style: TextStyle(
                    color: isDark
                        ? theme.colorScheme.onSurface
                        : Colors.purple[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHealthDataPlaceholder() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark
            ? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3)
            : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark
              ? theme.colorScheme.outline.withValues(alpha: 0.3)
              : Colors.grey.shade200,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.analytics,
            size: 48,
            color: isDark
                ? theme.colorScheme.onSurface.withValues(alpha: 0.6)
                : Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            _healthSummary == null
                ? 'Health Data Not Available'
                : 'Health Analytics Loading',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _healthSummary == null
                ? 'Connect to Health Connect to see personalized insights about how your habits impact your health metrics.'
                : 'Your health and habit correlations will appear here once data is processed.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          // Always show health debugging buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_healthSummary == null) ...[
                ElevatedButton.icon(
                  onPressed: () async {
                    try {
                      final result = await HealthService.requestPermissions();
                      if (result.granted && mounted) {
                        setState(() {
                          _loadAllData();
                        });
                      }
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Failed to connect: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  icon: const Icon(Icons.health_and_safety, size: 18),
                  label: const Text('Connect Health Data'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                  ),
                ),
                const SizedBox(width: 12),
              ],
              ElevatedButton.icon(
                onPressed: () async {
                  try {
                    final results =
                        await HealthService.testHealthConnectConnection();
                    if (mounted) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Health Connect Test Results'),
                          content: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: results.entries.map((entry) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 2,
                                  ),
                                  child: Text(
                                    '${entry.key}: ${entry.value}',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                      );
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Test failed: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
                icon: const Icon(Icons.bug_report, size: 18),
                label: const Text('Test Connection'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.secondary,
                  foregroundColor: theme.colorScheme.onSecondary,
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: () async {
                  setState(() {
                    _loadAllData();
                  });
                },
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Refresh Data'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.tertiary,
                  foregroundColor: theme.colorScheme.onTertiary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Chart builders for health modules
  Widget _buildSleepCorrelationChart(List<Habit> habits) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (_healthSummary == null) {
      return Center(
        child: Text(
          'Sleep data not available\nConnect your health app to see correlations',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      );
    }

    final sleepHours = _healthSummary!['sleepHours'] as double? ?? 0.0;
    final completionRate = habits.isNotEmpty
        ? habits.where((h) => h.isCompletedToday).length / habits.length
        : 0.0;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(
                    '${sleepHours.toStringAsFixed(1)}h',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isDark ? theme.colorScheme.primary : Colors.indigo,
                    ),
                  ),
                  Text(
                    'Last Night',
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.arrow_forward,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
              Column(
                children: [
                  Text(
                    '${(completionRate * 100).round()}%',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.greenAccent : Colors.green,
                    ),
                  ),
                  Text(
                    'Completion Rate',
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: sleepHours / 10.0, // Scale to 10 hours max
            backgroundColor: isDark
                ? theme.colorScheme.outline.withValues(alpha: 0.3)
                : Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(
              sleepHours >= 7
                  ? (isDark ? Colors.greenAccent : Colors.green)
                  : (isDark ? Colors.orangeAccent : Colors.orange),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCorrelationChart(List<Habit> habits) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (_healthSummary == null) {
      return Center(
        child: Text(
          'Activity data not available\nConnect your health app to see correlations',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      );
    }

    final steps = _healthSummary!['steps'] as int? ?? 0;
    final calories = _healthSummary!['activeCalories'] as double? ?? 0.0;
    final activityHabits = habits
        .where(
          (h) =>
              h.name.toLowerCase().contains('exercise') ||
              h.name.toLowerCase().contains('workout') ||
              h.name.toLowerCase().contains('run') ||
              h.name.toLowerCase().contains('walk'),
        )
        .toList();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(
                    '${(steps / 1000).toStringAsFixed(1)}k',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.orangeAccent : Colors.orange,
                    ),
                  ),
                  Text(
                    'Steps',
                    style: TextStyle(
                      fontSize: 11,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    '${calories.round()}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.redAccent : Colors.red,
                    ),
                  ),
                  Text(
                    'Calories',
                    style: TextStyle(
                      fontSize: 11,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    '${activityHabits.where((h) => h.isCompletedToday).length}/${activityHabits.length}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.greenAccent : Colors.green,
                    ),
                  ),
                  Text(
                    'Activity Habits',
                    style: TextStyle(
                      fontSize: 11,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  value: (steps / 10000).clamp(0.0, 1.0),
                  backgroundColor: Colors.grey[300],
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Colors.orange,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: LinearProgressIndicator(
                  value: (calories / 500).clamp(0.0, 1.0),
                  backgroundColor: Colors.grey[300],
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeartRateTrendChart(List<Habit> habits) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (_healthSummary == null) {
      return Center(
        child: Text(
          'Heart rate data not available\nConnect your fitness tracker to see trends',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      );
    }

    final heartRate = _healthSummary!['heartRate'] as double?;
    final restingHR = _healthSummary!['restingHeartRate'] as double?;
    final meditationHabits = habits
        .where(
          (h) =>
              h.name.toLowerCase().contains('meditat') ||
              h.name.toLowerCase().contains('mindful') ||
              h.name.toLowerCase().contains('breathe') ||
              h.name.toLowerCase().contains('relax'),
        )
        .toList();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(
                    heartRate != null ? '${heartRate.round()}' : '--',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? theme.colorScheme.tertiary
                          : Colors.purple,
                    ),
                  ),
                  Text(
                    'Current HR',
                    style: TextStyle(
                      fontSize: 11,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    restingHR != null ? '${restingHR.round()}' : '--',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.blueAccent : Colors.blue,
                    ),
                  ),
                  Text(
                    'Resting HR',
                    style: TextStyle(
                      fontSize: 11,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    '${meditationHabits.where((h) => h.isCompletedToday).length}/${meditationHabits.length}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.greenAccent : Colors.green,
                    ),
                  ),
                  Text(
                    'Mindfulness',
                    style: TextStyle(
                      fontSize: 11,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (restingHR != null)
            LinearProgressIndicator(
              value: ((80 - restingHR) / 20).clamp(0.0, 1.0), // Lower is better
              backgroundColor: isDark
                  ? theme.colorScheme.outline.withValues(alpha: 0.3)
                  : Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                restingHR < 60
                    ? (isDark ? Colors.greenAccent : Colors.green)
                    : restingHR < 70
                    ? (isDark ? Colors.orangeAccent : Colors.orange)
                    : (isDark ? Colors.redAccent : Colors.red),
              ),
            ),
        ],
      ),
    );
  }

  // Insight generators
  String _generateSleepInsight(List<Habit> habits) {
    if (_healthSummary == null) {
      return 'Connect your health app to see personalized sleep insights.';
    }

    final sleepHours = _healthSummary!['sleepHours'] as double? ?? 0.0;
    final completionRate = habits.isNotEmpty
        ? habits.where((h) => h.isCompletedToday).length / habits.length
        : 0.0;

    if (sleepHours >= 7.5) {
      return 'Great sleep! With ${sleepHours.toStringAsFixed(1)} hours last night, you\'re ${(completionRate * 100).round()}% more likely to complete your habits today.';
    } else if (sleepHours >= 6.5) {
      return 'Decent sleep at ${sleepHours.toStringAsFixed(1)} hours. Try for 7+ hours to boost your habit completion rate by up to 18%.';
    } else {
      return 'Only ${sleepHours.toStringAsFixed(1)} hours of sleep detected. Poor sleep can reduce habit completion by up to 25%. Prioritize rest tonight!';
    }
  }

  String _generateActivityInsight(List<Habit> habits) {
    if (_healthSummary == null) {
      return 'Connect your health app to see personalized activity insights.';
    }

    final steps = _healthSummary!['steps'] as int? ?? 0;
    final calories = _healthSummary!['activeCalories'] as double? ?? 0.0;
    final activityHabits = habits
        .where(
          (h) =>
              h.name.toLowerCase().contains('exercise') ||
              h.name.toLowerCase().contains('workout') ||
              h.category.toLowerCase().contains('fitness'),
        )
        .toList();

    if (steps >= 8000 || calories >= 300) {
      return 'Excellent activity today! High activity days like this typically boost focus and productivity habits by 35%.';
    } else if (steps >= 5000 || calories >= 150) {
      return 'Good activity level. You\'re ${activityHabits.where((h) => h.isCompletedToday).isNotEmpty ? 'on track' : 'likely'} to complete more habits with this energy level.';
    } else {
      return 'Low activity detected ($steps steps, ${calories.round()} cal). Even a 10-minute walk can improve habit completion rates by 15%.';
    }
  }

  String _generateHeartRateInsight(List<Habit> habits) {
    if (_healthSummary == null) {
      return 'Connect your fitness tracker to see personalized heart rate insights.';
    }

    final heartRate = _healthSummary!['heartRate'] as double?;
    final restingHR = _healthSummary!['restingHeartRate'] as double?;
    final meditationHabits = habits
        .where(
          (h) =>
              h.name.toLowerCase().contains('meditat') ||
              h.name.toLowerCase().contains('mindful') ||
              h.category.toLowerCase().contains('mental'),
        )
        .toList();

    if (restingHR != null) {
      if (restingHR < 60) {
        return 'Excellent resting heart rate of ${restingHR.round()} bpm! Your mindfulness practices are paying off with improved cardiovascular health.';
      } else if (restingHR < 70) {
        return 'Good resting heart rate at ${restingHR.round()} bpm. Regular meditation can help lower it further and improve stress resilience.';
      } else {
        return 'Resting HR of ${restingHR.round()} bpm suggests room for improvement. Completing ${meditationHabits.isNotEmpty ? 'your mindfulness habits' : 'meditation habits'} can help reduce stress.';
      }
    } else if (heartRate != null) {
      return 'Current heart rate: ${heartRate.round()} bpm. Track your resting heart rate to see how habits like meditation impact your cardiovascular health.';
    } else {
      return 'Heart rate data not available. Connect a fitness tracker to see how mindfulness habits affect your heart rate variability.';
    }
  }

  // Debug section for troubleshooting health data issues
  Widget _buildHealthDebugSection() {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.bug_report,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Health Data Debug',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Use these tools to diagnose health data connection issues:',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    try {
                      final results =
                          await HealthService.testHealthConnectConnection();
                      if (mounted) {
                        _showHealthDiagnosticsDialog(results);
                      }
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Test failed: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  icon: const Icon(Icons.search, size: 18),
                  label: const Text('Test Connection'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.secondary,
                    foregroundColor: theme.colorScheme.onSecondary,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    try {
                      final diagnostics =
                          await HealthService.runHealthConnectDiagnostics();
                      if (mounted) {
                        _showDetailedDiagnosticsDialog(diagnostics);
                      }
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Diagnostics failed: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  icon: const Icon(Icons.analytics, size: 18),
                  label: const Text('Full Diagnostics'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    try {
                      final debugResults =
                          await HealthService.debugHealthDataIssues();
                      if (mounted) {
                        _showHealthDataDebugDialog(debugResults);
                      }
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Debug failed: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  icon: const Icon(Icons.troubleshoot, size: 18),
                  label: const Text('Debug Sleep & Calories'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    setState(() {
                      _loadAllData();
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Refreshing health data...'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const Text('Refresh Data'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.tertiary,
                    foregroundColor: theme.colorScheme.onTertiary,
                  ),
                ),
                if (_healthSummary == null)
                  ElevatedButton.icon(
                    onPressed: () async {
                      try {
                        final result = await HealthService.requestPermissions();
                        if (result.granted && mounted) {
                          setState(() {
                            _loadAllData();
                          });
                        }
                      } catch (e) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Failed to connect: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
                    icon: const Icon(Icons.health_and_safety, size: 18),
                    label: const Text('Connect Health'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                    ),
                  ),
              ],
            ),
            if (_healthSummary != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Health Data Status:',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Heart Rate: ${_healthSummary!['heartRate'] ?? 'No data'}',
                      style: theme.textTheme.bodySmall,
                    ),
                    Text(
                      'Sleep: ${_healthSummary!['sleepHours'] ?? 'No data'} hours',
                      style: theme.textTheme.bodySmall,
                    ),
                    Text(
                      'Steps: ${_healthSummary!['steps'] ?? 'No data'}',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showHealthDiagnosticsDialog(Map<String, dynamic> results) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Health Connect Test Results'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDiagnosticItem(
                'Health Connect Available',
                results['healthConnectAvailable'],
              ),
              _buildDiagnosticItem(
                'Has Permissions',
                results['hasPermissions'],
              ),
              _buildDiagnosticItem('Steps Records', results['stepsRecords']),
              _buildDiagnosticItem(
                'Heart Rate Records',
                results['heartrateRecords'],
              ),
              _buildDiagnosticItem(
                'Sleep Records',
                results['sleepinbedRecords'],
              ),
              _buildDiagnosticItem(
                'Calories Records',
                results['activeenergyburnedRecords'],
              ),
              _buildDiagnosticItem('Water Records', results['waterRecords']),
              _buildDiagnosticItem('Weight Records', results['weightRecords']),
              const SizedBox(height: 16),
              if (results['stepsRecords'] != null &&
                  results['stepsRecords'] > 0) ...[
                Text(
                  '✅ Steps data is working correctly (${results['stepsRecords']} records)',
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.green.shade300
                        : Colors.green.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
              ],
              if (results['heartrateRecords'] == 0) ...[
                Text(
                  '❌ Heart Rate: No data found',
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.red.shade300
                        : Colors.red.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Troubleshooting:\n• Check if your smartwatch is syncing to Health Connect\n• Verify heart rate tracking is enabled on your device\n• Some devices may take time to sync data',
                  style: TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 8),
              ],
              if (results['sleepinbedRecords'] == 0) ...[
                Text(
                  '❌ Sleep: No data found',
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.red.shade300
                        : Colors.red.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Troubleshooting:\n• Enable sleep tracking on your smartwatch/phone\n• Check if sleep data is visible in Health Connect app\n• Sleep data may take 24-48 hours to appear',
                  style: TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 8),
              ],
              if (results['activeenergyburnedRecords'] == 0) ...[
                Text(
                  '❌ Calories: No data found',
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.red.shade300
                        : Colors.red.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Troubleshooting:\n• Enable activity tracking on your device\n• Check if your fitness app is connected to Health Connect\n• Some apps may not sync calorie data automatically',
                  style: TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 8),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showHealthConnectSetupGuide();
            },
            child: const Text('Setup Guide'),
          ),
        ],
      ),
    );
  }

  void _showDetailedDiagnosticsDialog(Map<String, dynamic> diagnostics) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Detailed Health Diagnostics'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Comprehensive Health Connect Analysis',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ...diagnostics.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text(
                    '${entry.key}: ${entry.value}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontFamily: 'monospace',
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  // Debug method - can be called manually for debugging calories data
  // ignore: unused_element
  void _showCaloriesDebugDialog(Map<String, dynamic> debugResults) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🔥 Calories Debug Results'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Active Calories Troubleshooting',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Permissions check
              _buildDebugSection(
                '🔐 Permissions',
                debugResults['hasPermissions'] == true
                    ? '✅ Granted'
                    : '❌ Missing',
                debugResults['hasPermissions'] == true
                    ? Colors.green
                    : Colors.red,
              ),

              // Time range results
              if (debugResults['todayRecords'] != null) ...[
                const SizedBox(height: 12),
                _buildDebugSection(
                  '📅 Today',
                  '${debugResults['todayRecords']} records, ${(debugResults['todayTotalCalories'] as double?)?.round() ?? 0} cal',
                  (debugResults['todayRecords'] as int?) != null &&
                          debugResults['todayRecords'] > 0
                      ? Colors.green
                      : Colors.orange,
                ),
              ],

              if (debugResults['yesterdayRecords'] != null) ...[
                const SizedBox(height: 8),
                _buildDebugSection(
                  '📅 Yesterday',
                  '${debugResults['yesterdayRecords']} records, ${(debugResults['yesterdayTotalCalories'] as double?)?.round() ?? 0} cal',
                  (debugResults['yesterdayRecords'] as int?) != null &&
                          debugResults['yesterdayRecords'] > 0
                      ? Colors.green
                      : Colors.orange,
                ),
              ],

              if (debugResults['last7daysRecords'] != null) ...[
                const SizedBox(height: 8),
                _buildDebugSection(
                  '📅 Last 7 Days',
                  '${debugResults['last7daysRecords']} records, ${(debugResults['last7daysTotalCalories'] as double?)?.round() ?? 0} cal',
                  (debugResults['last7daysRecords'] as int?) != null &&
                          debugResults['last7daysRecords'] > 0
                      ? Colors.green
                      : Colors.orange,
                ),
              ],

              // MinimalHealthChannel result
              if (debugResults['minimalChannelTodayCalories'] != null) ...[
                const SizedBox(height: 12),
                _buildDebugSection(
                  '🔧 Direct Channel Result',
                  '${(debugResults['minimalChannelTodayCalories'] as double).round()} cal',
                  debugResults['minimalChannelTodayCalories'] > 0
                      ? Colors.green
                      : Colors.orange,
                ),
              ],

              // Errors
              if (debugResults['todayError'] != null ||
                  debugResults['yesterdayError'] != null ||
                  debugResults['last7daysError'] != null ||
                  debugResults['minimalChannelError'] != null) ...[
                const SizedBox(height: 16),
                const Text(
                  '❌ Errors Found:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 8),
                if (debugResults['todayError'] != null)
                  Text(
                    'Today: ${debugResults['todayError']}',
                    style: const TextStyle(fontSize: 12, color: Colors.red),
                  ),
                if (debugResults['yesterdayError'] != null)
                  Text(
                    'Yesterday: ${debugResults['yesterdayError']}',
                    style: const TextStyle(fontSize: 12, color: Colors.red),
                  ),
                if (debugResults['last7daysError'] != null)
                  Text(
                    'Last 7 days: ${debugResults['last7daysError']}',
                    style: const TextStyle(fontSize: 12, color: Colors.red),
                  ),
                if (debugResults['minimalChannelError'] != null)
                  Text(
                    'Channel: ${debugResults['minimalChannelError']}',
                    style: const TextStyle(fontSize: 12, color: Colors.red),
                  ),
              ],

              // Troubleshooting tips
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '💡 Troubleshooting Tips:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '• Make sure your fitness app (Google Fit, Samsung Health, etc.) is connected to Health Connect',
                    ),
                    const Text(
                      '• Check that active calories/energy burned is enabled in your fitness app',
                    ),
                    const Text(
                      '• Try doing some physical activity and wait 15-30 minutes for data to sync',
                    ),
                    const Text(
                      '• Open Health Connect app and verify calories data is visible there',
                    ),
                    const Text(
                      '• Some apps only sync calories after completing a workout session',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () async {
              final navigator = Navigator.of(context);
              final scaffoldMessenger = ScaffoldMessenger.of(context);
              navigator.pop();
              // Open Health Connect settings
              try {
                await HealthService.openHealthConnectSettings();
              } catch (e) {
                if (mounted) {
                  scaffoldMessenger.showSnackBar(
                    SnackBar(content: Text('Could not open settings: $e')),
                  );
                }
              }
            },
            child: const Text('Open Health Connect'),
          ),
        ],
      ),
    );
  }

  void _showHealthDataDebugDialog(Map<String, dynamic> debugResults) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🩺 Health Data Debug Results'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Comprehensive Sleep & Calories Analysis',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Basic status
              _buildDebugSection(
                '🔧 Initialized',
                debugResults['isInitialized']?.toString() ?? 'Unknown',
                debugResults['isInitialized'] == true
                    ? Colors.green
                    : Colors.red,
              ),

              _buildDebugSection(
                '🔐 Permissions',
                debugResults['hasPermissions'] == true ? 'Granted' : 'Missing',
                debugResults['hasPermissions'] == true
                    ? Colors.green
                    : Colors.red,
              ),

              const SizedBox(height: 16),
              const Divider(),

              // Sleep Debug Section
              if (debugResults['sleepDebug'] != null) ...[
                const SizedBox(height: 8),
                Text(
                  '😴 Sleep Data Analysis',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 8),

                _buildDebugSection(
                  'Sleep Records',
                  '${debugResults['sleepDebug']['totalSleepRecords'] ?? 0}',
                  (debugResults['sleepDebug']['totalSleepRecords'] ?? 0) > 0
                      ? Colors.green
                      : Colors.orange,
                ),

                _buildDebugSection(
                  'Calculated Sleep',
                  '${(debugResults['sleepDebug']['calculatedSleepHours'] ?? 0).toStringAsFixed(1)} hours',
                  (debugResults['sleepDebug']['calculatedSleepHours'] ?? 0) >
                              0 &&
                          (debugResults['sleepDebug']['calculatedSleepHours'] ??
                                  0) <=
                              16
                      ? Colors.green
                      : Colors.red,
                ),

                // Show sleep analysis if available
                if (debugResults['sleepDebug']['sleepAnalysis'] != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Recent Sleep Sessions:',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 4),
                  ...((debugResults['sleepDebug']['sleepAnalysis']
                              as List<dynamic>?) ??
                          [])
                      .map(
                        (session) => Padding(
                          padding: const EdgeInsets.only(left: 16, bottom: 4),
                          child: Text(
                            '• ${(session['durationHours'] as double).toStringAsFixed(1)}h (${session['startTime'].toString().substring(11, 16)} - ${session['endTime'].toString().substring(11, 16)})',
                            style: TextStyle(
                              fontSize: 12,
                              color: session['isReasonableDuration'] == true
                                  ? (Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.green.shade300
                                        : Colors.green.shade700)
                                  : (Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.red.shade300
                                        : Colors.red.shade700),
                            ),
                          ),
                        ),
                      ),
                ],
              ],

              const SizedBox(height: 16),
              const Divider(),

              // Calories Debug Section
              if (debugResults['caloriesDebug'] != null) ...[
                const SizedBox(height: 8),
                Text(
                  '🔥 Calories Data Analysis',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(height: 8),

                _buildDebugSection(
                  'Today Records',
                  '${debugResults['caloriesDebug']['todayRecords'] ?? 0}',
                  (debugResults['caloriesDebug']['todayRecords'] ?? 0) > 0
                      ? Colors.green
                      : Colors.orange,
                ),

                _buildDebugSection(
                  'Today Calories',
                  '${(debugResults['caloriesDebug']['todayTotalCalories'] ?? 0).round()} cal',
                  (debugResults['caloriesDebug']['todayTotalCalories'] ?? 0) > 0
                      ? Colors.green
                      : Colors.orange,
                ),

                _buildDebugSection(
                  'Direct Channel',
                  '${(debugResults['caloriesDebug']['minimalChannelTodayCalories'] ?? 0).round()} cal',
                  (debugResults['caloriesDebug']['minimalChannelTodayCalories'] ??
                              0) >
                          0
                      ? Colors.green
                      : Colors.orange,
                ),
              ],

              const SizedBox(height: 16),
              const Divider(),

              // Data Type Summary
              const SizedBox(height: 8),
              Text(
                '📊 Data Type Summary',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              ),
              const SizedBox(height: 8),

              ...[
                'steps',
                'active_energy_burned',
                'sleep_in_bed',
                'water',
                'weight',
                'heart_rate',
              ].map((dataType) {
                final recordCount = debugResults['${dataType}RecordCount'] ?? 0;
                final hasError = debugResults['${dataType}Error'] != null;

                return _buildDebugSection(
                  dataType.replaceAll('_', ' ').toUpperCase(),
                  hasError ? 'Error' : '$recordCount records',
                  hasError
                      ? Colors.red
                      : (recordCount > 0 ? Colors.green : Colors.grey),
                );
              }),

              // Troubleshooting tips
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '💡 Key Findings & Next Steps:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    if ((debugResults['sleepDebug']?['calculatedSleepHours'] ??
                            0) >
                        16) ...[
                      const Text(
                        '⚠️ Sleep calculation issue detected - showing unrealistic hours',
                        style: TextStyle(color: Colors.red),
                      ),
                      const Text(
                        '• Fixed: Now using longest single session instead of summing all sessions',
                      ),
                    ],
                    if ((debugResults['caloriesDebug']?['todayRecords'] ?? 0) ==
                        0) ...[
                      const Text(
                        '⚠️ No calories data found',
                        style: TextStyle(color: Colors.orange),
                      ),
                      const Text(
                        '• Check if your watch app is syncing to Health Connect',
                      ),
                      const Text(
                        '• Verify active energy permissions in Health Connect',
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () async {
              final navigator = Navigator.of(context);
              final scaffoldMessenger = ScaffoldMessenger.of(context);
              navigator.pop();
              try {
                await HealthService.openHealthConnectSettings();
              } catch (e) {
                if (mounted) {
                  scaffoldMessenger.showSnackBar(
                    SnackBar(content: Text('Could not open settings: $e')),
                  );
                }
              }
            },
            child: const Text('Open Health Connect'),
          ),
        ],
      ),
    );
  }

  Widget _buildDebugSection(String title, String value, Color color) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Adjust colors for dark theme readability
    Color adjustedColor = color;
    if (isDark) {
      if (color == Colors.green) {
        adjustedColor = Colors.green.shade300;
      } else if (color == Colors.red) {
        adjustedColor = Colors.red.shade300;
      } else if (color == Colors.orange) {
        adjustedColor = Colors.orange.shade300;
      } else if (color == Colors.blue) {
        adjustedColor = Colors.blue.shade300;
      }
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(color: adjustedColor, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  void _showHealthConnectSetupGuide() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Health Connect Setup Guide'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'To get all health data working:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildSetupStep(
                '1',
                'Install Health Connect',
                'Make sure Health Connect is installed from Google Play Store',
              ),
              _buildSetupStep(
                '2',
                'Connect Your Apps',
                'Open Health Connect and connect your fitness apps (Google Fit, Samsung Health, Fitbit, etc.)',
              ),
              _buildSetupStep(
                '3',
                'Enable Data Types',
                'In Health Connect, make sure these data types are enabled:\n• Steps\n• Heart rate\n• Sleep\n• Active calories\n• Water intake',
              ),
              _buildSetupStep(
                '4',
                'Grant Permissions',
                'Return to this app and tap "Connect Health" to grant permissions',
              ),
              _buildSetupStep(
                '5',
                'Wait for Sync',
                'Some data may take 24-48 hours to appear, especially sleep data',
              ),
              const SizedBox(height: 16),
              const Text(
                'Common Issues & Solutions:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                '🔍 Steps Working But Other Data Missing:\n'
                '• Your device is connected to Health Connect\n'
                '• But specific data types need individual setup\n\n'
                '❤️ Heart Rate Data:\n'
                '• Enable "Continuous heart rate" on your smartwatch\n'
                '• Check if your watch app (Galaxy Watch, Fitbit, etc.) is connected to Health Connect\n'
                '• Some watches only sync heart rate during workouts\n\n'
                '😴 Sleep Data:\n'
                '• Enable sleep tracking on your smartwatch/phone\n'
                '• Sleep data often takes 24-48 hours to appear\n'
                '• Check if sleep data is visible in the Health Connect app first',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildSetupStep(String number, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(description, style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiagnosticItem(
    String label,
    String value, {
    bool isError = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isError ? Colors.red : null,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'monospace',
                color: isError ? Colors.red : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
