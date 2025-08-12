import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/database.dart';
import '../../domain/model/habit.dart';
import '../../services/trend_analysis_service.dart';
import '../../services/smart_recommendations_service.dart';
import '../../services/achievements_service.dart';
import '../../services/health_service.dart';
import '../../services/logging_service.dart';
import '../widgets/health_habit_dashboard_widget.dart';

class InsightsScreen extends ConsumerStatefulWidget {
  const InsightsScreen({super.key});

  @override
  ConsumerState<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends ConsumerState<InsightsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Map<String, dynamic>? _trendAnalysis;
  List<HabitRecommendation>? _recommendations;
  Map<String, dynamic>? _gamificationStats;
  Map<String, dynamic>? _healthSummary;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
          final habitsData = habits.map((h) => {
            'id': h.id,
            'name': h.name,
            'category': h.category,
            'currentStreak': h.currentStreak,
            'completionRate': h.completionRate,
            'reminderTime': h.reminderTime?.toString(),
            'difficulty': h.difficulty.name,
            'completions': h.completions.map((c) => {
              'id': DateTime.now().millisecondsSinceEpoch.toString(),
              'habitId': h.id,
              'completedAt': c,
            }).toList(),
          }).toList();

          final allCompletions = habits
              .expand((h) => h.completions.map((c) => {
                'id': DateTime.now().millisecondsSinceEpoch.toString(),
                'habitId': h.id,
                'completedAt': c,
              }))
              .toList();

          // Load trend analysis (only if enough data)
          _trendAnalysis = await TrendAnalysisService.analyzeHabitTrends(
            habits: habitsData,
            completions: allCompletions,
          );

          // Load smart recommendations
          _recommendations = await SmartRecommendationsService.generateRecommendations(
            existingHabits: habitsData,
            userPreferences: {'preferredTimeSlot': 'morning'},
            healthData: _healthSummary,
          );

          // Load gamification stats
          _gamificationStats = await AchievementsService.getGamificationStats(
            habits: habitsData,
            completions: allCompletions,
          );

          // Check for new achievements
          final newAchievements = await AchievementsService.checkForNewAchievements(
            habits: habitsData,
            completions: allCompletions,
          );

          if (newAchievements.isNotEmpty && mounted) {
            _showNewAchievements(newAchievements);
          }

          // Load health summary if available
          try {
            if (await HealthService.hasPermissions()) {
              _healthSummary = await HealthService.getTodayHealthSummary();
            }
          } catch (e) {
            // Handle health service error quietly
            AppLogger.error('Failed to load health summary', e);
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
          children: achievements.map((achievement) => ListTile(
            leading: Text(achievement.icon, style: const TextStyle(fontSize: 24)),
            title: Text(achievement.title),
            subtitle: Text(achievement.description),
            trailing: Text('+${achievement.xpReward} XP'),
          )).toList(),
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
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Trends'),
            Tab(text: 'Achievements'),
            Tab(text: 'Recommendations'),
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
                _buildRecommendationsTab(),
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
                      Icon(Icons.lightbulb_outline, size: 64, color: Colors.grey),
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
                    // Gamification Stats Card
                    if (_gamificationStats != null) _buildGamificationCard(),
                    const SizedBox(height: 16),

                    // Quick Stats Grid
                    _buildQuickStatsGrid(habits),
                    const SizedBox(height: 16),

                    // Health-Habit Integration Dashboard
                    HealthHabitDashboardWidget(
                      showFullDetails: true,
                      onTap: () => context.push('/health-integration'),
                    ),
                    const SizedBox(height: 16),

                    // Recent Insights
                    _buildRecentInsightsCard(habits),
                  ],
                ),
              );
            },
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Text('Error loading data: $error'),
          ),
        );
      },
    );
  }

  Widget _buildGamificationCard() {
    final stats = _gamificationStats!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.emoji_events, color: Colors.amber),
                const SizedBox(width: 8),
                Text(
                  'Level ${stats['level']} ${stats['rank']}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: stats['levelProgress'],
              backgroundColor: Colors.grey[300],
            ),
            const SizedBox(height: 8),
            Text('${stats['xp']} / ${stats['nextLevelXP']} XP'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('Achievements', '${stats['achievementsUnlocked']}/${stats['totalAchievements']}'),
                _buildStatItem('Max Streak', '${stats['maxStreak']} days'),
                _buildStatItem('Completion Rate', '${(stats['completionRate'] * 100).toStringAsFixed(1)}%'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStatsGrid(List<Habit> habits) {
    final totalHabits = habits.length;
    final activeHabits = habits.where((h) => h.currentStreak > 0).length;
    final totalCompletions = habits.fold<int>(0, (sum, h) => sum + h.completions.length);
    final avgStreak = habits.isNotEmpty
        ? habits.fold<int>(0, (sum, h) => sum + h.currentStreak) / habits.length
        : 0.0;

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 1.5,
      children: [
        _buildQuickStatCard('Total Habits', totalHabits.toString(), Icons.list_alt),
        _buildQuickStatCard('Active Streaks', activeHabits.toString(), Icons.local_fire_department),
        _buildQuickStatCard('Total Completions', totalCompletions.toString(), Icons.check_circle),
        _buildQuickStatCard('Avg Streak', '${avgStreak.toStringAsFixed(1)} days', Icons.trending_up),
      ],
    );
  }

  Widget _buildQuickStatCard(String title, String value, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24, color: Theme.of(context).primaryColor),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthCard() {
    final health = _healthSummary!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.favorite, color: Colors.red),
                const SizedBox(width: 8),
                Text(
                  'Health Summary',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                if (health['steps'] != null)
                  _buildStatItem('Steps', '${health['steps']}'),
                if (health['exerciseMinutes'] != null)
                  _buildStatItem('Exercise', '${health['exerciseMinutes']} min'),
                if (health['waterIntake'] != null)
                  _buildStatItem('Water', '${health['waterIntake'].toStringAsFixed(1)}L'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentInsightsCard(List<Habit> habits) {
    final insights = <String>[];

    // Generate insights based on current data
    final completionRates = habits.map((h) => h.completionRate).toList();
    if (completionRates.isNotEmpty) {
      final avgRate = completionRates.reduce((a, b) => a + b) / completionRates.length;
      if (avgRate > 0.8) {
        insights.add('🎯 You\'re doing great! Your average completion rate is ${(avgRate * 100).toStringAsFixed(1)}%');
      } else if (avgRate < 0.5) {
        insights.add('💪 Focus on consistency. Your completion rate could improve.');
      }
    }

    final bestHabit = habits.where((h) => h.completions.isNotEmpty)
        .fold<Habit?>(null, (best, habit) =>
          best == null || habit.currentStreak > best.currentStreak ? habit : best);

    if (bestHabit != null && bestHabit.currentStreak > 7) {
      insights.add('🔥 ${bestHabit.name} is on fire with a ${bestHabit.currentStreak}-day streak!');
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Insights',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            if (insights.isEmpty)
              const Text('Keep tracking habits to unlock insights!')
            else
              ...insights.map((insight) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(insight),
              )),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildTrendsTab() {
    if (_trendAnalysis == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
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
          if (analysis['insights'] != null || analysis['recommendations'] != null)
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
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text('Worst Day'),
                    Text(
                      weeklyPatterns['worstDay'] ?? 'N/A',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
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
                trailing: Text('${(trendData['completionRate'] * 100).toStringAsFixed(1)}%'),
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
              const Text('💡 Insights:', style: TextStyle(fontWeight: FontWeight.bold)),
              ...insights.map((insight) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text('• $insight'),
              )),
              const SizedBox(height: 8),
            ],
            if (recommendations.isNotEmpty) ...[
              const Text('🎯 Recommendations:', style: TextStyle(fontWeight: FontWeight.bold)),
              ...recommendations.map((rec) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text('• $rec'),
              )),
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
              // Progress Overview Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Achievement Progress',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      LinearProgressIndicator(
                        value: unlockedAchievements.length / allAchievements.length,
                        backgroundColor: Colors.grey[300],
                      ),
                      const SizedBox(height: 8),
                      Text('${unlockedAchievements.length} / ${allAchievements.length} achievements unlocked'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Recent Achievements
              if (unlockedAchievements.isNotEmpty) ...[
                Text(
                  'Unlocked Achievements',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                ...unlockedAchievements.take(5).map((achievement) => Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.amber,
                      child: Text(achievement.icon, style: const TextStyle(fontSize: 20)),
                    ),
                    title: Text(achievement.title),
                    subtitle: Text(achievement.description),
                    trailing: Text('+${achievement.xpReward} XP'),
                  ),
                )),
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
                      final isUnlocked = unlockedAchievements.any((a) => a.id == achievement.id);
                      final achievementProgress = progress[achievement.id] ?? 0.0;

                      return Card(
                        color: isUnlocked ? Colors.amber[50] : null,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: isUnlocked ? Colors.amber : Colors.grey,
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
                                Text('Progress: ${(achievementProgress * 100).toStringAsFixed(0)}%'),
                              ],
                            ],
                          ),
                          trailing: Text(
                            isUnlocked ? 'Unlocked!' : '+${achievement.xpReward} XP',
                            style: TextStyle(
                              color: isUnlocked ? Colors.amber[700] : Colors.grey,
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

  Widget _buildRecommendationsTab() {
    if (_recommendations == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_recommendations!.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lightbulb_outline, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'No new recommendations',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            FutureBuilder<int>(
              future: SmartRecommendationsService.getDaysUntilRefresh(),
              builder: (context, snapshot) {
                final daysUntilRefresh = snapshot.data ?? 0;
                return Text(
                  daysUntilRefresh > 0
                      ? 'You\'ve used all available recommendations!\nNew ones will appear in $daysUntilRefresh day${daysUntilRefresh == 1 ? '' : 's'}, or you can refresh now.'
                      : 'You\'ve used all available recommendations!\nNew ones are ready, or you can refresh now.',
                  style: const TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                );
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _refreshRecommendations,
              icon: const Icon(Icons.refresh),
              label: const Text('Refresh Recommendations'),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Contextual Suggestions
          Consumer(
            builder: (context, ref, child) {
              final habitServiceAsync = ref.watch(habitServiceProvider);
              return habitServiceAsync.when(
                data: (habitService) => FutureBuilder<List<Habit>>(
                  future: habitService.getAllHabits(),
                  builder: (context, habitSnapshot) {
                    final habits = habitSnapshot.data ?? [];
                    final habitsData = habits.map((h) => {
                      'id': h.id,
                      'name': h.name,
                      'category': h.category,
                      'currentStreak': h.currentStreak,
                      'completionRate': h.completionRate,
                      'reminderTime': h.reminderTime?.toString(),
                      'difficulty': h.difficulty.name,
                    }).toList();

                    return FutureBuilder<List<HabitRecommendation>>(
                      future: Future.value(SmartRecommendationsService.getContextualSuggestions(
                        currentTime: DateTime.now(),
                        existingHabits: habitsData,
                      )),
                      builder: (context, contextSnapshot) {
                        final contextualSuggestions = contextSnapshot.data ?? [];

                        if (contextualSuggestions.isNotEmpty) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Perfect Time Suggestions',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              ...contextualSuggestions.map((suggestion) => Card(
                                color: Theme.of(context).colorScheme.primaryContainer,
                                child: ListTile(
                                  leading: Icon(
                                    Icons.access_time,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                  title: Text(
                                    suggestion.title,
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  subtitle: Text(
                                    suggestion.description,
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.8),
                                    ),
                                  ),
                                  trailing: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        suggestion.suggestedTime,
                                        style: TextStyle(
                                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        '${suggestion.estimatedDuration} min',
                                        style: TextStyle(
                                          color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.7),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                              const SizedBox(height: 16),
                            ],
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    );
                  },
                ),
                loading: () => const SizedBox.shrink(),
                error: (error, stack) => const SizedBox.shrink(),
              );
            },
          ),

          // Main Recommendations
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Personalized Recommendations',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              TextButton.icon(
                onPressed: _refreshRecommendations,
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Refresh'),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ..._recommendations!.map((recommendation) => Card(
            child: ExpansionTile(
              leading: CircleAvatar(
                backgroundColor: _getCategoryColor(recommendation.category),
                child: Icon(
                  _getCategoryIcon(recommendation.category),
                  color: Colors.white,
                ),
              ),
              title: Text(recommendation.title),
              subtitle: Text(recommendation.category),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(_getDifficultyIcon(recommendation.difficulty)),
                  Text('Priority: ${recommendation.priority}'),
                ],
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recommendation.description,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Why: ${recommendation.reason}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Duration: ${recommendation.estimatedDuration} min'),
                          Text('Best time: ${recommendation.suggestedTime}'),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _createHabitFromRecommendation(recommendation),
                          child: const Text('Create This Habit'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  void _createHabitFromRecommendation(HabitRecommendation recommendation) async {
    // Mark recommendation as used
    await SmartRecommendationsService.markRecommendationAsUsed(recommendation);
    
    // Navigate to create habit screen with pre-filled data using GoRouter
    if (mounted) {
      final result = await context.push('/create-habit', extra: {
        'name': recommendation.title,
        'description': recommendation.description,
        'category': recommendation.category,
        'difficulty': recommendation.difficulty,
        'suggestedTime': recommendation.suggestedTime,
        'estimatedDuration': recommendation.estimatedDuration,
        'recommendationId': SmartRecommendationsService.getRecommendationId(recommendation),
      });
      
      // Refresh recommendations when returning from create habit screen
      if (result == true || result == null) {
        _loadAllData();
      }
    }
  }

  Future<void> _refreshRecommendations() async {
    // Manually refresh recommendations
    await SmartRecommendationsService.refreshRecommendations();
    
    // Show loading indicator
    setState(() => _isLoading = true);
    
    // Reload all data
    await _loadAllData();
    
    // Show success message
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Recommendations refreshed!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'health':
        return Colors.red;
      case 'fitness':
        return Colors.orange;
      case 'mental health':
        return Colors.purple;
      case 'learning':
        return Colors.blue;
      case 'social':
        return Colors.green;
      case 'personal development':
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'health':
        return Icons.favorite;
      case 'fitness':
        return Icons.fitness_center;
      case 'mental health':
        return Icons.psychology;
      case 'learning':
        return Icons.school;
      case 'social':
        return Icons.people;
      case 'personal development':
        return Icons.self_improvement;
      default:
        return Icons.category;
    }
  }

  IconData _getDifficultyIcon(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'very easy':
        return Icons.sentiment_very_satisfied;
      case 'easy':
        return Icons.sentiment_satisfied;
      case 'medium':
        return Icons.sentiment_neutral;
      case 'hard':
        return Icons.sentiment_dissatisfied;
      default:
        return Icons.help;
    }
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
}
