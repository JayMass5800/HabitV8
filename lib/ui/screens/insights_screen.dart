import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';
import '../../data/database.dart';
import '../../domain/model/habit.dart';
import '../../services/habit_stats_service.dart';
import '../../services/trend_analysis_service.dart';
import '../../services/comprehensive_habit_suggestions_service.dart';
import '../../services/health_habit_analytics_service.dart';
import '../../services/health_service.dart';
import '../../services/achievements_service.dart';

import '../../services/logging_service.dart';

import '../widgets/loading_widget.dart';
import '../widgets/progressive_disclosure.dart';

class InsightsScreen extends ConsumerStatefulWidget {
  const InsightsScreen({super.key});

  @override
  ConsumerState<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends ConsumerState<InsightsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final HabitStatsService _statsService = HabitStatsService();
  Map<String, dynamic>? _gamificationStats;
  Map<String, dynamic>? _healthSummary;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadGamificationData();
  }

  Future<void> _loadGamificationData() async {
    try {
      final habitServiceAsync = ref.read(habitServiceProvider);
      await habitServiceAsync.when(
        data: (habitService) async {
          final habits = await habitService.getAllHabits();
          final habitsData = habits
              .map((h) => {
                    'id': h.id,
                    'name': h.name,
                    'category': h.category,
                    'currentStreak': h.currentStreak,
                    'completionRate': h.completionRate,
                    'completions': h.completions
                        .map((c) => {
                              'id': DateTime.now()
                                  .millisecondsSinceEpoch
                                  .toString(),
                              'habitId': h.id,
                              'completedAt': c,
                            })
                        .toList(),
                  })
              .toList();

          final allCompletions = habits
              .expand((h) => h.completions.map((c) => {
                    'id': DateTime.now().millisecondsSinceEpoch.toString(),
                    'habitId': h.id,
                    'completedAt': c,
                  }))
              .toList();

          _gamificationStats = await AchievementsService.getGamificationStats(
            habits: habitsData,
            completions: allCompletions,
          );

          // Load health summary if available
          try {
            AppLogger.info('Checking health permissions...');
            final hasPermissions = await HealthService.hasPermissions().timeout(
              const Duration(seconds: 5),
              onTimeout: () {
                AppLogger.warning('Health permissions check timed out');
                return false;
              },
            );
            AppLogger.info('Health permissions status: $hasPermissions');

            if (hasPermissions) {
              AppLogger.info('Loading health summary...');
              _healthSummary =
                  await HealthService.getTodayHealthSummary().timeout(
                const Duration(seconds: 30),
                onTimeout: () {
                  AppLogger.warning('Health summary loading timed out');
                  return <String, dynamic>{
                    'error': 'Health data loading timed out',
                    'steps': 0,
                    'activeCalories': 0.0,
                    'totalCalories': 0.0,
                    'sleepHours': 0.0,
                    'waterIntake': 0.0,
                    'mindfulnessMinutes': 0.0,
                    'weight': null,
                    'medicationAdherence': 0.0,
                    'heartRate': null,
                    'restingHeartRate': null,
                    'timestamp': DateTime.now().toIso8601String(),
                  };
                },
              );
              AppLogger.info(
                  'Health summary loaded: ${_healthSummary?.keys.join(', ')}');

              // Integration status loading removed - no longer needed
            } else {
              AppLogger.info(
                  'Health permissions not granted, skipping health data load');
              _healthSummary = {
                'error': 'Health permissions not granted',
                'hasPermissions': false,
                'canRetry': true,
                'needsPermissions': true,
              };
            }
          } catch (e) {
            AppLogger.error('Failed to load health summary', e);
            _healthSummary = {
              'error': 'Failed to load health data',
              'errorDetails': e.toString(),
              'hasPermissions': false,
              'canRetry': true,
            };
          }
        },
        loading: () async {
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
        setState(() {});
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Insights'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.dashboard), text: 'Overview'),
            Tab(icon: Icon(Icons.trending_up), text: 'Trends'),
            Tab(icon: Icon(Icons.emoji_events), text: 'Achievements'),
          ],
        ),
      ),
      body: TabBarView(
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
        return ref.watch(habitServiceProvider).when(
              data: (habitService) => FutureBuilder<List<Habit>>(
                future: habitService.getAllHabits(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const LoadingWidget();
                  }

                  final habits = snapshot.data ?? [];
                  if (habits.isEmpty) {
                    return _buildEmptyState();
                  }

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Colorful Performance Cards (moved to top)
                        _buildBigFourPerformanceCards(habits),
                        const SizedBox(height: 24),

                        // Performance Metrics
                        _buildPerformanceMetrics(habits),
                        const SizedBox(height: 24),

                        _buildHabitPerformanceChart(habits),
                        const SizedBox(height: 24),
                        _buildAIInsightsSection(habits),
                        const SizedBox(height: 24),

                        // Health Data Integration
                        _buildHealthDataSection(habits),
                        const SizedBox(height: 24),

                        // Enhanced Health Hub with Line Graphs
                        _buildEnhancedHealthHub(habits),
                      ],
                    ),
                  );
                },
              ),
              loading: () => const LoadingWidget(),
              error: (error, stack) => _buildErrorState(error.toString()),
            );
      },
    );
  }

  Widget _buildHabitPerformanceChart(List<Habit> habits) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Habit Performance Deep Dive',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: _buildWeeklyCompletionChart(habits),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyCompletionChart(List<Habit> habits) {
    final weeklyData = _calculateWeeklyCompletionData(habits);

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text(
                  '${value.toInt()}%',
                  style: const TextStyle(fontSize: 12),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final weeks = ['W1', 'W2', 'W3', 'W4'];
                if (value.toInt() < weeks.length) {
                  return Text(weeks[value.toInt()]);
                }
                return const Text('');
              },
            ),
          ),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: true),
        lineBarsData: [
          LineChartBarData(
            spots: weeklyData.asMap().entries.map((entry) {
              return FlSpot(entry.key.toDouble(), entry.value);
            }).toList(),
            isCurved: true,
            color: Theme.of(context).primaryColor,
            barWidth: 3,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
            ),
          ),
        ],
        minY: 0,
        maxY: 100,
      ),
    );
  }

  Widget _buildAIInsightsSection(List<Habit> habits) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.psychology, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                const Text(
                  'AI-Generated Insights',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ..._generatePersonalizedInsights(habits),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            FutureBuilder<List<HabitSuggestion>>(
              future:
                  ComprehensiveHabitSuggestionsService.generateSuggestions(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Smart Habit Suggestions',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      ...snapshot.data!.take(3).map(
                          (suggestion) => _buildSuggestionTile(suggestion)),
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthDataSection(List<Habit> habits) {
    return FutureBuilder<bool>(
      future: HealthService.hasPermissions(),
      builder: (context, permissionSnapshot) {
        if (!permissionSnapshot.hasData || !permissionSnapshot.data!) {
          return const SizedBox.shrink();
        }

        return FutureBuilder<HealthHabitAnalyticsReport>(
          future: HealthHabitAnalyticsService.generateAnalyticsReport(
            habitService: ref.read(habitServiceProvider).value!,
          ),
          builder: (context, analyticsSnapshot) {
            if (!analyticsSnapshot.hasData ||
                analyticsSnapshot.data!.hasError) {
              return const SizedBox.shrink();
            }

            final report = analyticsSnapshot.data!;
            return Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.health_and_safety,
                            color: Theme.of(context).primaryColor),
                        const SizedBox(width: 8),
                        const Text(
                          'Health Data Integration',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ...report.overallInsights.take(3).map((insight) =>
                        _buildInsightTile(insight, Icons.health_and_safety)),
                    if (report.recommendations.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      const Divider(),
                      const SizedBox(height: 12),
                      const Text(
                        'Health-Based Recommendations',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      ...report.recommendations.take(2).map(
                          (rec) => _buildInsightTile(rec, Icons.lightbulb)),
                    ],
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTrendsTab() {
    return Consumer(
      builder: (context, ref, child) {
        return ref.watch(habitServiceProvider).when(
              data: (habitService) => FutureBuilder<List<Habit>>(
                future: habitService.getAllHabits(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const LoadingWidget();
                  }

                  final habits = snapshot.data ?? [];
                  if (habits.isEmpty) {
                    return _buildEmptyState();
                  }

                  return FutureBuilder<Map<String, dynamic>>(
                    future: _generateTrendsAnalysis(habits),
                    builder: (context, trendsSnapshot) {
                      if (trendsSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const LoadingWidget();
                      }

                      final trendsData = trendsSnapshot.data ?? {};

                      return SingleChildScrollView(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTrendsOverview(trendsData),
                            const SizedBox(height: 24),
                            _buildWeeklyPatterns(trendsData),
                            const SizedBox(height: 24),
                            _buildHabitTrendsBreakdown(trendsData),
                            const SizedBox(height: 24),
                            _buildProductivityInsights(trendsData),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
              loading: () => const LoadingWidget(),
              error: (error, stack) => _buildErrorState(error.toString()),
            );
      },
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
              // Motivational Header
              _buildMotivationalHeader(
                'Achievements & Rewards',
                'Celebrate your progress and unlock new milestones! 🏆',
              ),
              const SizedBox(height: 24),

              // Gamification Card
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
                ...unlockedAchievements.take(5).map(
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
                future: _getAchievementProgress(),
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
                            backgroundColor:
                                isUnlocked ? Colors.amber : Colors.grey,
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
                              color:
                                  isUnlocked ? Colors.amber[700] : Colors.grey,
                              fontWeight: isUnlocked ? FontWeight.bold : null,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),

              const SizedBox(height: 24),

              // All Achievements List
              _buildAchievementsList(),
            ],
          ),
        );
      },
    );
  }

  // Helper methods for calculations

  List<double> _calculateWeeklyCompletionData(List<Habit> habits) {
    final now = DateTime.now();
    final weeklyData = <double>[];

    for (int week = 3; week >= 0; week--) {
      final weekStart = now.subtract(Duration(days: (week + 1) * 7));
      final weekEnd = now.subtract(Duration(days: week * 7));

      int totalCompletions = 0;
      int totalPossible = 0;

      for (final habit in habits) {
        final weekCompletions = habit.completions
            .where((completion) =>
                completion.isAfter(weekStart) && completion.isBefore(weekEnd))
            .length;

        totalCompletions += weekCompletions;
        totalPossible += 7; // Assuming daily habits for simplicity
      }

      final completionRate =
          totalPossible > 0 ? (totalCompletions / totalPossible * 100) : 0.0;
      weeklyData.add(completionRate);
    }

    return weeklyData;
  }

  List<Widget> _generatePersonalizedInsights(List<Habit> habits) {
    final insights = <Widget>[];

    // Analyze completion patterns
    final morningHabits = habits
        .where(
            (h) => h.notificationTime != null && h.notificationTime!.hour < 12)
        .length;
    final eveningHabits = habits
        .where(
            (h) => h.notificationTime != null && h.notificationTime!.hour >= 18)
        .length;

    if (morningHabits > eveningHabits) {
      insights.add(_buildInsightTile(
        'You\'re a morning person! ${(morningHabits / habits.length * 100).toInt()}% of your habits are scheduled before noon.',
        Icons.wb_sunny,
      ));
    }

    // Analyze streak patterns
    final avgStreak = habits.isEmpty
        ? 0
        : habits
                .map((h) => _statsService.getStreakInfo(h).current)
                .reduce((a, b) => a + b) /
            habits.length;

    if (avgStreak > 7) {
      insights.add(_buildInsightTile(
        'Great consistency! Your average streak is ${avgStreak.toInt()} days. Keep up the momentum!',
        Icons.trending_up,
      ));
    } else if (avgStreak < 3) {
      insights.add(_buildInsightTile(
        'Focus on building consistency. Try starting with just one habit and maintaining it for a week.',
        Icons.lightbulb,
      ));
    }

    // Analyze habit difficulty
    final easyHabits =
        habits.where((h) => h.difficulty == HabitDifficulty.easy).length;
    if (easyHabits > habits.length * 0.7) {
      insights.add(_buildInsightTile(
        'Consider adding some challenging habits to accelerate your growth!',
        Icons.fitness_center,
      ));
    }

    return insights;
  }

  Widget _buildInsightTile(String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Theme.of(context).primaryColor),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionTile(HabitSuggestion suggestion) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              Theme.of(context).primaryColor.withValues(alpha: 0.1),
          child: Icon(
            Icons.add,
            color: Theme.of(context).primaryColor,
          ),
        ),
        title: Text(suggestion.name),
        subtitle: Text(suggestion.description),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // Navigate to create habit with prefilled data from the suggestion
          final prefilledData = {
            'name': suggestion.name,
            'description': suggestion.description,
            'category': suggestion.category,
            'frequency': suggestion.frequency.toString(),
            'icon': suggestion.icon,
            'type': suggestion.type,
            'isHealthBased': suggestion.isHealthBased,
            'healthDataType': suggestion.healthDataType,
            'suggestedThreshold': suggestion.suggestedThreshold,
          };

          AppLogger.info(
              'Navigating to create habit with suggestion: ${suggestion.name}');
          context.push('/create-habit', extra: prefilledData);
        },
      ),
    );
  }

  Future<Map<String, dynamic>> _generateTrendsAnalysis(
      List<Habit> habits) async {
    final completions = <Map<String, dynamic>>[];
    final habitsData = <Map<String, dynamic>>[];

    for (final habit in habits) {
      habitsData.add({
        'id': habit.id,
        'name': habit.name,
        'category': habit.category,
        'currentStreak': habit.currentStreak,
      });

      for (final completion in habit.completions) {
        completions.add({
          'habitId': habit.id,
          'completedAt': completion,
        });
      }
    }

    return await TrendAnalysisService.analyzeHabitTrends(
      habits: habitsData,
      completions: completions,
    );
  }

  Widget _buildTrendsOverview(Map<String, dynamic> trendsData) {
    if (!(trendsData['hasEnoughData'] ?? false)) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(Icons.hourglass_empty,
                  size: 48, color: Theme.of(context).primaryColor),
              const SizedBox(height: 16),
              Text(
                trendsData['message'] ?? 'Not enough data for trends analysis',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    final overallTrends = trendsData['overallTrends'] ?? {};

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Overall Trends',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildTrendIndicator(
              'Trend Direction',
              overallTrends['direction'] ?? 'neutral',
              overallTrends['trend'] ?? 'stable',
            ),
            const SizedBox(height: 12),
            Text(
              overallTrends['message'] ??
                  'Your habits are showing stable progress.',
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendIndicator(String label, String direction, String trend) {
    IconData icon;
    Color color;

    switch (direction) {
      case 'upward':
        icon = Icons.trending_up;
        color = Colors.green;
        break;
      case 'downward':
        icon = Icons.trending_down;
        color = Colors.red;
        break;
      default:
        icon = Icons.trending_flat;
        color = Colors.orange;
    }

    return Row(
      children: [
        Icon(icon, color: color),
        const SizedBox(width: 8),
        Text(
          '$label: ${trend.replaceAll('_', ' ').toUpperCase()}',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildWeeklyPatterns(Map<String, dynamic> trendsData) {
    final weeklyPatterns = trendsData['weeklyPatterns'] ?? {};
    final weekdayAverages = weeklyPatterns['weekdayAverages'] ?? {};

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Weekly Patterns',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (weekdayAverages.isNotEmpty) ...[
              Text('Best Day: ${weeklyPatterns['bestDay'] ?? 'Unknown'}'),
              Text('Worst Day: ${weeklyPatterns['worstDay'] ?? 'Unknown'}'),
              const SizedBox(height: 12),
              SizedBox(
                height: 200,
                child: _buildWeeklyPatternChart(weekdayAverages),
              ),
            ] else
              const Text('Not enough data for weekly pattern analysis.'),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyPatternChart(Map<String, dynamic> weekdayAverages) {
    final data = weekdayAverages.entries.map((entry) {
      final dayIndex = [
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday'
      ].indexOf(entry.key);
      return FlSpot(dayIndex.toDouble(), (entry.value as double) * 100);
    }).toList();

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text('${value.toInt()}%',
                    style: const TextStyle(fontSize: 10));
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                if (value.toInt() < days.length) {
                  return Text(days[value.toInt()]);
                }
                return const Text('');
              },
            ),
          ),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: true),
        lineBarsData: [
          LineChartBarData(
            spots: data,
            isCurved: true,
            color: Theme.of(context).primaryColor,
            barWidth: 3,
            dotData: const FlDotData(show: true),
          ),
        ],
      ),
    );
  }

  Widget _buildHabitTrendsBreakdown(Map<String, dynamic> trendsData) {
    final habitTrends = trendsData['habitTrends'] ?? {};

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Individual Habit Trends',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (habitTrends.isNotEmpty)
              ...habitTrends.entries.take(5).map((entry) {
                final habitData = entry.value;
                return _buildHabitTrendTile(
                  habitData['habitName'] ?? 'Unknown',
                  habitData['trend'] ?? 'stable',
                  habitData['direction'] ?? 'neutral',
                  habitData['completionRate'] ?? 0.0,
                );
              })
            else
              const Text('No individual habit trends available.'),
          ],
        ),
      ),
    );
  }

  Widget _buildHabitTrendTile(
      String habitName, String trend, String direction, double completionRate) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(habitName),
        subtitle: Text('${(completionRate * 100).toInt()}% completion rate'),
        trailing: _buildTrendIndicator('', direction, trend),
      ),
    );
  }

  Widget _buildProductivityInsights(Map<String, dynamic> trendsData) {
    final insights = trendsData['insights'] ?? [];

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Productivity Insights',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (insights.isNotEmpty)
              ...insights.take(3).map<Widget>((insight) =>
                  _buildInsightTile(insight.toString(), Icons.lightbulb))
            else
              const Text('Keep tracking to unlock productivity insights!'),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementsList() {
    final achievements = AchievementsService.getAllAchievements();

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'All Achievements',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...achievements
                .take(6)
                .map((achievement) => _buildAchievementTile(achievement)),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementTile(Achievement achievement) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Text(
          achievement.icon,
          style: const TextStyle(fontSize: 24),
        ),
        title: Text(achievement.title),
        subtitle: Text(achievement.description),
        trailing: Text(
          '${achievement.xpReward} XP',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildPerformanceMetrics(List<Habit> habits) {
    final totalCompletions =
        habits.fold<int>(0, (sum, habit) => sum + habit.completions.length);
    final avgStreak = habits.isEmpty
        ? 0.0
        : habits
                .map((h) => _statsService.getStreakInfo(h).current)
                .reduce((a, b) => a + b) /
            habits.length;

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Performance Metrics',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMetricCard('Total Completions',
                    totalCompletions.toString(), Icons.check_circle),
                _buildMetricCard('Average Streak', '${avgStreak.toInt()} days',
                    Icons.local_fire_department),
                _buildMetricCard(
                    'Active Habits',
                    '${habits.where((h) => h.isActive).length}',
                    Icons.play_circle),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Theme.of(context).primaryColor, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.insights,
            size: 64,
            color: Theme.of(context).primaryColor.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'No habits to analyze yet!',
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Navigate to create habit
            },
            child: const Text('Create Your First Habit'),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          const Text(
            'Error loading insights',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: const TextStyle(fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => setState(() {}),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  // Gamification methods
  Widget _buildMotivationalHeader(String title, String subtitle) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.black : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              color: isDarkMode ? Colors.white70 : Colors.black54,
              fontSize: 16,
            ),
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
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
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
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
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
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
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
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
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
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }

  Future<Map<String, double>> _getAchievementProgress() async {
    try {
      final habitServiceAsync = ref.read(habitServiceProvider);
      return await habitServiceAsync.when(
        data: (habitService) async {
          final habits = await habitService.getAllHabits();
          final habitsData = habits
              .map((h) => {
                    'id': h.id,
                    'name': h.name,
                    'category': h.category,
                    'currentStreak': h.currentStreak,
                    'completionRate': h.completionRate,
                  })
              .toList();

          final allCompletions = habits
              .expand((h) => h.completions.map((c) => {
                    'id': DateTime.now().millisecondsSinceEpoch.toString(),
                    'habitId': h.id,
                    'completedAt': c,
                  }))
              .toList();

          return await AchievementsService.getAchievementProgress(
            habits: habitsData,
            completions: allCompletions,
          );
        },
        loading: () async => <String, double>{},
        error: (error, stack) async => <String, double>{},
      );
    } catch (e) {
      return <String, double>{};
    }
  }

  // Big Four Performance Cards
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

  Widget _buildOverallCompletionRateCard(List<Habit> habits) {
    double totalCompletionRate = 0.0;
    double previousCompletionRate = 0.0;

    if (habits.isNotEmpty) {
      final completionRates = habits
          .map((h) => _statsService.getCompletionRate(h, days: 30))
          .toList();
      totalCompletionRate =
          completionRates.reduce((a, b) => a + b) / completionRates.length;

      // Calculate previous 30-day completion rate for comparison
      final now = DateTime.now();
      final previousPeriodHabits = habits.map((h) {
        final previousCompletions = h.completions
            .where((c) =>
                c.isBefore(now.subtract(const Duration(days: 30))) &&
                c.isAfter(now.subtract(const Duration(days: 60))))
            .toList();
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
            .map((h) => _statsService.getCompletionRate(h, days: 30))
            .toList();
        previousCompletionRate =
            previousRates.reduce((a, b) => a + b) / previousRates.length;
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
    );
  }

  Widget _buildCurrentStreakCard(List<Habit> habits) {
    int totalStreak = 0;
    int previousStreak = 0;

    if (habits.isNotEmpty) {
      totalStreak = habits.map((h) => h.currentStreak).reduce((a, b) => a + b);
      // For simplicity, assume previous streak was 90% of current (this could be more sophisticated)
      previousStreak = (totalStreak * 0.9).round();
    }

    final streakChange = totalStreak - previousStreak;

    return _buildPerformanceCard(
      title: 'Total Current Streak',
      value: '$totalStreak days',
      insight: '${streakChange >= 0 ? '+' : ''}$streakChange days this period',
      gradient: [Colors.orange.shade400, Colors.orange.shade600],
      icon: Icons.local_fire_department,
    );
  }

  Widget _buildConsistencyScoreCard(List<Habit> habits) {
    double consistencyScore = 0.0;

    if (habits.isNotEmpty) {
      final scores = habits.map((h) {
        final completionRate = _statsService.getCompletionRate(h, days: 30);
        final streakConsistency = h.currentStreak > 0 ? 1.0 : 0.5;
        return (completionRate + streakConsistency) / 2;
      }).toList();
      consistencyScore = scores.reduce((a, b) => a + b) / scores.length;
    }

    return _buildPerformanceCard(
      title: 'Consistency Score',
      value: '${(consistencyScore * 100).toStringAsFixed(0)}%',
      insight: 'Based on completion patterns',
      gradient: [Colors.blue.shade400, Colors.blue.shade600],
      icon: Icons.trending_up,
    );
  }

  Widget _buildMostPowerfulDayCard(List<Habit> habits) {
    String mostPowerfulDay = 'Monday';
    int maxCompletions = 0;

    if (habits.isNotEmpty) {
      final dayCompletions = <String, int>{};
      final dayNames = [
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday'
      ];

      for (final habit in habits) {
        for (final completion in habit.completions) {
          final dayName = dayNames[completion.weekday - 1];
          dayCompletions[dayName] = (dayCompletions[dayName] ?? 0) + 1;
        }
      }

      if (dayCompletions.isNotEmpty) {
        final maxEntry =
            dayCompletions.entries.reduce((a, b) => a.value > b.value ? a : b);
        mostPowerfulDay = maxEntry.key;
        maxCompletions = maxEntry.value;
      }
    }

    return _buildPerformanceCard(
      title: 'Most Powerful Day',
      value: mostPowerfulDay,
      insight: '$maxCompletions completions',
      gradient: [Colors.purple.shade400, Colors.purple.shade600],
      icon: Icons.star,
    );
  }

  Widget _buildPerformanceCard({
    required String title,
    required String value,
    required String insight,
    required List<Color> gradient,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white, size: 24),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.trending_up, color: Colors.white, size: 16),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            insight,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedHealthHub(List<Habit> habits) {
    return FutureBuilder<bool>(
      future: HealthService.hasPermissions(),
      builder: (context, snapshot) {
        final hasPermissions = snapshot.data ?? false;

        if (!hasPermissions) {
          return _buildHealthPermissionCard();
        } else {
          return _buildActiveHealthHubWithGraphs(habits);
        }
      },
    );
  }

  Widget _buildHealthPermissionCard() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [
                  theme.colorScheme.surface,
                  theme.colorScheme.surfaceContainerHighest
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
              'Grant permission to Health Connect / HealthKit to see how your habits impact key metrics like sleep, heart rate, and activity levels.',
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
                      _loadGamificationData(); // Reload data after permissions granted
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text('Health permissions granted successfully!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'Health permissions were not granted. Please try again or check your device settings.'),
                        backgroundColor: Colors.orange,
                      ),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error requesting permissions: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isDark ? theme.colorScheme.primary : Colors.teal,
                foregroundColor:
                    isDark ? theme.colorScheme.onPrimary : Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Grant Health Permissions'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthDataPlaceholder() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(Icons.health_and_safety, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 12),
          Text(
            'Health Data Loading...',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your health insights will appear here once data is available.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActiveHealthHubWithGraphs(List<Habit> habits) {
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

            // Health Data Modules with Line Graphs
            if (_healthSummary != null &&
                !_healthSummary!.containsKey('error')) ...[
              _buildSleepHabitModuleWithGraph(habits),
              const SizedBox(height: 24),
              _buildActivityEnergyModuleWithGraph(habits),
              const SizedBox(height: 24),
              _buildHeartRateModuleWithGraph(habits),
              const SizedBox(height: 24),
              _buildWaterIntakeModuleWithGraph(habits),
            ] else
              _buildHealthDataPlaceholder(),
          ],
        ),
      ),
    );
  }

  // Helper method to get real health data over time (7 days) from Health Connect
  Future<List<Map<String, dynamic>>> _getRealHealthDataOverTime(
      String metricType) async {
    final now = DateTime.now();
    final data = <Map<String, dynamic>>[];

    try {
      // Get health data for the past 7 days
      for (int i = 6; i >= 0; i--) {
        final date = now.subtract(Duration(days: i));
        final startOfDay = DateTime(date.year, date.month, date.day);
        final endOfDay = startOfDay.add(const Duration(days: 1));

        double value = 0.0;

        switch (metricType) {
          case 'sleep':
            // Get sleep data for this specific day
            value = await _getSleepHoursForDate(startOfDay, endOfDay);
            break;
          case 'steps':
            // Get steps data for this specific day
            value = (await _getStepsForDate(startOfDay, endOfDay)).toDouble();
            break;
          case 'heartRate':
            // Get average heart rate for this day
            value = await _getHeartRateForDate(startOfDay, endOfDay);
            break;
          case 'water':
            // Get water intake for this day
            value = await _getWaterIntakeForDate(startOfDay, endOfDay);
            break;
        }

        data.add({
          'date': date,
          'value': value.clamp(0, double.infinity),
        });
      }
    } catch (e) {
      AppLogger.error('Error getting real health data for $metricType', e);
      // Fallback to current day's data if available
      if (_healthSummary != null && !_healthSummary!.containsKey('error')) {
        for (int i = 6; i >= 0; i--) {
          final date = now.subtract(Duration(days: i));
          double value = 0.0;

          // Use current health summary data as fallback
          switch (metricType) {
            case 'sleep':
              value = (_healthSummary!['sleepHours'] as double? ?? 0.0);
              break;
            case 'steps':
              value = (_healthSummary!['steps'] as int? ?? 0).toDouble();
              break;
            case 'heartRate':
              value = (_healthSummary!['heartRate'] as double? ?? 0.0);
              break;
            case 'water':
              value = (_healthSummary!['waterIntake'] as double? ?? 0.0);
              break;
          }

          data.add({
            'date': date,
            'value': value.clamp(0, double.infinity),
          });
        }
      }
    }

    return data;
  }

  // Helper methods to get health data for specific dates using available HealthService methods
  Future<double> _getSleepHoursForDate(
      DateTime startOfDay, DateTime endOfDay) async {
    try {
      final data = await HealthService.getHealthDataFromTypes(
        types: ['SLEEP_IN_BED'],
        startTime: startOfDay,
        endTime: endOfDay,
      );

      if (data.isEmpty) return 0.0;

      // Calculate total sleep hours from sleep sessions
      double totalHours = 0.0;
      for (final record in data) {
        if (record['startTime'] != null && record['endTime'] != null) {
          final start = DateTime.parse(record['startTime']);
          final end = DateTime.parse(record['endTime']);
          final duration = end.difference(start);
          totalHours += duration.inMinutes / 60.0;
        }
      }

      return totalHours;
    } catch (e) {
      AppLogger.error('Error getting sleep hours for date', e);
      return 0.0;
    }
  }

  Future<int> _getStepsForDate(DateTime startOfDay, DateTime endOfDay) async {
    try {
      final data = await HealthService.getHealthDataFromTypes(
        types: ['STEPS'],
        startTime: startOfDay,
        endTime: endOfDay,
      );

      if (data.isEmpty) return 0;

      // Sum all step counts for the day
      int totalSteps = 0;
      for (final record in data) {
        if (record['count'] != null) {
          totalSteps += (record['count'] as num).toInt();
        }
      }

      return totalSteps;
    } catch (e) {
      AppLogger.error('Error getting steps for date', e);
      return 0;
    }
  }

  Future<double> _getHeartRateForDate(
      DateTime startOfDay, DateTime endOfDay) async {
    try {
      final data = await HealthService.getHealthDataFromTypes(
        types: ['HEART_RATE'],
        startTime: startOfDay,
        endTime: endOfDay,
      );

      if (data.isEmpty) return 0.0;

      // Calculate average heart rate for the day
      double totalBpm = 0.0;
      int count = 0;

      for (final record in data) {
        if (record['beatsPerMinute'] != null) {
          totalBpm += (record['beatsPerMinute'] as num).toDouble();
          count++;
        }
      }

      return count > 0 ? totalBpm / count : 0.0;
    } catch (e) {
      AppLogger.error('Error getting heart rate for date', e);
      return 0.0;
    }
  }

  Future<double> _getWaterIntakeForDate(
      DateTime startOfDay, DateTime endOfDay) async {
    try {
      final data = await HealthService.getHealthDataFromTypes(
        types: ['WATER'],
        startTime: startOfDay,
        endTime: endOfDay,
      );

      if (data.isEmpty) return 0.0;

      // Sum all water intake for the day (in liters)
      double totalLiters = 0.0;
      for (final record in data) {
        if (record['volume'] != null) {
          // Convert from milliliters to liters
          totalLiters += (record['volume'] as num).toDouble() / 1000.0;
        }
      }

      return totalLiters;
    } catch (e) {
      AppLogger.error('Error getting water intake for date', e);
      return 0.0;
    }
  }

  // Helper method to generate sample health data over time (7 days) - DEPRECATED
  // This method is kept for fallback purposes only
  List<Map<String, dynamic>> _generateHealthDataOverTime(String metricType) {
    final now = DateTime.now();
    final data = <Map<String, dynamic>>[];

    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      double value = 0.0;

      switch (metricType) {
        case 'sleep':
          value = 6.5 + (i * 0.3) + (i % 2 == 0 ? 0.5 : -0.2);
          break;
        case 'steps':
          value = 8000 + (i * 500) + (i % 3 == 0 ? 1000 : -200);
          break;
        case 'heartRate':
          value = 70 + (i * 2) + (i % 2 == 0 ? 5 : -3);
          break;
        case 'water':
          value = 1.8 + (i * 0.2) + (i % 2 == 0 ? 0.3 : -0.1);
          break;
      }

      data.add({
        'date': date,
        'value': value.clamp(0, double.infinity),
      });
    }

    return data;
  }

  // Helper method to generate habit completion data over time (7 days)
  List<Map<String, dynamic>> _generateHabitCompletionData(List<Habit> habits) {
    final now = DateTime.now();
    final data = <Map<String, dynamic>>[];

    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      int completed = 0;
      int total = 0;

      for (final habit in habits) {
        // Count habits that were due on this day
        total++;

        // Count habits that were completed on this day
        final completedOnDay = habit.completions
            .where((completion) =>
                completion.isAfter(startOfDay) && completion.isBefore(endOfDay))
            .length;

        if (completedOnDay > 0) completed++;
      }

      data.add({
        'date': date,
        'completed': completed,
        'total': total,
        'percentage': total > 0 ? (completed / total * 100) : 0.0,
      });
    }

    return data;
  }

  Widget _buildSleepHabitModuleWithGraph(List<Habit> habits) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final sleepHours = _healthSummary?['sleepHours'] ?? 0.0;

    final habitData = _generateHabitCompletionData(habits);

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _getRealHealthDataOverTime('sleep'),
      builder: (context, snapshot) {
        final sleepData = snapshot.data ?? _generateHealthDataOverTime('sleep');

        return _buildSleepModuleContent(
            theme, isDark, sleepHours, sleepData, habitData, habits);
      },
    );
  }

  Widget _buildSleepModuleContent(
    ThemeData theme,
    bool isDark,
    double sleepHours,
    List<Map<String, dynamic>> sleepData,
    List<Map<String, dynamic>> habitData,
    List<Habit> habits,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sleep & Habit Performance',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: isDark ? theme.colorScheme.primary : Colors.indigo[700],
          ),
        ),
        const SizedBox(height: 16),

        // Current sleep info
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark
                ? theme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.3)
                : Colors.indigo.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark
                  ? theme.colorScheme.outline.withValues(alpha: 0.3)
                  : Colors.indigo.shade200,
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.bedtime, color: Colors.indigo, size: 32),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Last Night: ${sleepHours.toStringAsFixed(1)} hours',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      sleepHours >= 7
                          ? 'Great sleep supports habit consistency!'
                          : 'Better sleep could improve habit performance',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: sleepHours >= 7 ? Colors.green : Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Line graph
        Container(
          height: 200,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? theme.colorScheme.surface : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: 2,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: theme.colorScheme.outline.withValues(alpha: 0.1),
                  strokeWidth: 1,
                ),
              ),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) => Text(
                      '${value.toInt()}h',
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() < sleepData.length) {
                        final date =
                            sleepData[value.toInt()]['date'] as DateTime;
                        return Text(
                          '${date.day}/${date.month}',
                          style: theme.textTheme.bodySmall,
                        );
                      }
                      return const Text('');
                    },
                  ),
                ),
                rightTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                // Sleep hours line
                LineChartBarData(
                  spots: sleepData.asMap().entries.map((entry) {
                    return FlSpot(entry.key.toDouble(), entry.value['value']);
                  }).toList(),
                  isCurved: true,
                  color: Colors.indigo,
                  barWidth: 3,
                  dotData: const FlDotData(show: true),
                  belowBarData: BarAreaData(
                    show: true,
                    color: Colors.indigo.withValues(alpha: 0.1),
                  ),
                ),
                // Habit completion percentage line (scaled to sleep range)
                LineChartBarData(
                  spots: habitData.asMap().entries.map((entry) {
                    final percentage = entry.value['percentage'] as double;
                    return FlSpot(entry.key.toDouble(),
                        percentage / 100 * 10); // Scale to 0-10 range
                  }).toList(),
                  isCurved: true,
                  color: Colors.green,
                  barWidth: 2,
                  dotData: const FlDotData(show: false),
                  dashArray: [5, 5],
                ),
              ],
              minY: 0,
              maxY: 10,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLegendItem('Sleep Hours', Colors.indigo),
            const SizedBox(width: 20),
            _buildLegendItem('Habit Completion %', Colors.green),
          ],
        ),
      ],
    );
  }

  Widget _buildActivityEnergyModuleWithGraph(List<Habit> habits) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final steps = _healthSummary?['steps'] ?? 0;
    final calories = _healthSummary?['activeCalories'] ?? 0.0;

    final habitData = _generateHabitCompletionData(habits);

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _getRealHealthDataOverTime('steps'),
      builder: (context, snapshot) {
        final stepsData = snapshot.data ?? _generateHealthDataOverTime('steps');

        return _buildActivityModuleContent(
            theme, isDark, steps, calories, stepsData, habitData, habits);
      },
    );
  }

  Widget _buildActivityModuleContent(
    ThemeData theme,
    bool isDark,
    int steps,
    double calories,
    List<Map<String, dynamic>> stepsData,
    List<Map<String, dynamic>> habitData,
    List<Habit> habits,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Activity & Energy Levels',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: isDark ? theme.colorScheme.primary : Colors.orange[700],
          ),
        ),
        const SizedBox(height: 16),

        // Current activity info
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark
                ? theme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.3)
                : Colors.orange.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark
                  ? theme.colorScheme.outline.withValues(alpha: 0.3)
                  : Colors.orange.shade200,
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.directions_walk, color: Colors.orange, size: 32),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Today: $steps steps • ${calories.toStringAsFixed(0)} cal',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      steps >= 8000
                          ? 'Great activity level boosts habit energy!'
                          : 'More activity could energize your habits',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: steps >= 8000 ? Colors.green : Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Line graph
        Container(
          height: 200,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? theme.colorScheme.surface : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: 2000,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: theme.colorScheme.outline.withValues(alpha: 0.1),
                  strokeWidth: 1,
                ),
              ),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 50,
                    getTitlesWidget: (value, meta) => Text(
                      '${(value / 1000).toInt()}k',
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() < stepsData.length) {
                        final date =
                            stepsData[value.toInt()]['date'] as DateTime;
                        return Text(
                          '${date.day}/${date.month}',
                          style: theme.textTheme.bodySmall,
                        );
                      }
                      return const Text('');
                    },
                  ),
                ),
                rightTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                // Steps line
                LineChartBarData(
                  spots: stepsData.asMap().entries.map((entry) {
                    return FlSpot(entry.key.toDouble(), entry.value['value']);
                  }).toList(),
                  isCurved: true,
                  color: Colors.orange,
                  barWidth: 3,
                  dotData: const FlDotData(show: true),
                  belowBarData: BarAreaData(
                    show: true,
                    color: Colors.orange.withValues(alpha: 0.1),
                  ),
                ),
                // Habit completion percentage line (scaled to steps range)
                LineChartBarData(
                  spots: habitData.asMap().entries.map((entry) {
                    final percentage = entry.value['percentage'] as double;
                    return FlSpot(entry.key.toDouble(),
                        percentage / 100 * 12000); // Scale to steps range
                  }).toList(),
                  isCurved: true,
                  color: Colors.green,
                  barWidth: 2,
                  dotData: const FlDotData(show: false),
                  dashArray: [5, 5],
                ),
              ],
              minY: 0,
              maxY: 12000,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLegendItem('Steps', Colors.orange),
            const SizedBox(width: 20),
            _buildLegendItem('Habit Completion %', Colors.green),
          ],
        ),
      ],
    );
  }

  Widget _buildHeartRateModuleWithGraph(List<Habit> habits) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final heartRate = _healthSummary?['heartRate'] ?? 0.0;

    final habitData = _generateHabitCompletionData(habits);

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _getRealHealthDataOverTime('heartRate'),
      builder: (context, snapshot) {
        final heartRateData =
            snapshot.data ?? _generateHealthDataOverTime('heartRate');

        return _buildHeartRateModuleContent(
            theme, isDark, heartRate, heartRateData, habitData, habits);
      },
    );
  }

  Widget _buildHeartRateModuleContent(
    ThemeData theme,
    bool isDark,
    double heartRate,
    List<Map<String, dynamic>> heartRateData,
    List<Map<String, dynamic>> habitData,
    List<Habit> habits,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Heart Rate & Habit Stress',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: isDark ? theme.colorScheme.primary : Colors.red[700],
          ),
        ),
        const SizedBox(height: 16),

        // Current heart rate info
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark
                ? theme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.3)
                : Colors.red.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark
                  ? theme.colorScheme.outline.withValues(alpha: 0.3)
                  : Colors.red.shade200,
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.favorite, color: Colors.red, size: 32),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current: ${heartRate.toStringAsFixed(0)} BPM',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      heartRate > 0 && heartRate < 80
                          ? 'Healthy heart rate supports habit consistency!'
                          : 'Monitor heart rate for optimal habit performance',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: heartRate > 0 && heartRate < 80
                            ? Colors.green
                            : Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Line graph
        Container(
          height: 200,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? theme.colorScheme.surface : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: 10,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: theme.colorScheme.outline.withValues(alpha: 0.1),
                  strokeWidth: 1,
                ),
              ),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) => Text(
                      '${value.toInt()}',
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() < heartRateData.length) {
                        final date =
                            heartRateData[value.toInt()]['date'] as DateTime;
                        return Text(
                          '${date.day}/${date.month}',
                          style: theme.textTheme.bodySmall,
                        );
                      }
                      return const Text('');
                    },
                  ),
                ),
                rightTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                // Heart rate line
                LineChartBarData(
                  spots: heartRateData.asMap().entries.map((entry) {
                    return FlSpot(entry.key.toDouble(), entry.value['value']);
                  }).toList(),
                  isCurved: true,
                  color: Colors.red,
                  barWidth: 3,
                  dotData: const FlDotData(show: true),
                  belowBarData: BarAreaData(
                    show: true,
                    color: Colors.red.withValues(alpha: 0.1),
                  ),
                ),
                // Habit completion percentage line (scaled to heart rate range)
                LineChartBarData(
                  spots: habitData.asMap().entries.map((entry) {
                    final percentage = entry.value['percentage'] as double;
                    return FlSpot(
                        entry.key.toDouble(),
                        60 +
                            (percentage /
                                100 *
                                40)); // Scale to 60-100 BPM range
                  }).toList(),
                  isCurved: true,
                  color: Colors.green,
                  barWidth: 2,
                  dotData: const FlDotData(show: false),
                  dashArray: [5, 5],
                ),
              ],
              minY: 50,
              maxY: 100,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLegendItem('Heart Rate (BPM)', Colors.red),
            const SizedBox(width: 20),
            _buildLegendItem('Habit Completion %', Colors.green),
          ],
        ),
      ],
    );
  }

  Widget _buildWaterIntakeModuleWithGraph(List<Habit> habits) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final waterIntake = _healthSummary?['waterIntake'] ?? 0.0;

    final habitData = _generateHabitCompletionData(habits);

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _getRealHealthDataOverTime('water'),
      builder: (context, snapshot) {
        final waterData = snapshot.data ?? _generateHealthDataOverTime('water');

        return _buildWaterIntakeModuleContent(
            theme, isDark, waterIntake, waterData, habitData, habits);
      },
    );
  }

  Widget _buildWaterIntakeModuleContent(
    ThemeData theme,
    bool isDark,
    double waterIntake,
    List<Map<String, dynamic>> waterData,
    List<Map<String, dynamic>> habitData,
    List<Habit> habits,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hydration & Habit Energy',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: isDark ? theme.colorScheme.primary : Colors.blue[700],
          ),
        ),
        const SizedBox(height: 16),

        // Current water intake info
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark
                ? theme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.3)
                : Colors.blue.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark
                  ? theme.colorScheme.outline.withValues(alpha: 0.3)
                  : Colors.blue.shade200,
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.water_drop, color: Colors.blue, size: 32),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Today: ${waterIntake.toStringAsFixed(1)} L',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      waterIntake >= 2.0
                          ? 'Great hydration supports habit focus!'
                          : 'Better hydration could improve habit performance',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            waterIntake >= 2.0 ? Colors.green : Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Line graph
        Container(
          height: 200,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? theme.colorScheme.surface : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: 0.5,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: theme.colorScheme.outline.withValues(alpha: 0.1),
                  strokeWidth: 1,
                ),
              ),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) => Text(
                      '${value.toStringAsFixed(1)}L',
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() < waterData.length) {
                        final date =
                            waterData[value.toInt()]['date'] as DateTime;
                        return Text(
                          '${date.day}/${date.month}',
                          style: theme.textTheme.bodySmall,
                        );
                      }
                      return const Text('');
                    },
                  ),
                ),
                rightTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                // Water intake line
                LineChartBarData(
                  spots: waterData.asMap().entries.map((entry) {
                    return FlSpot(entry.key.toDouble(), entry.value['value']);
                  }).toList(),
                  isCurved: true,
                  color: Colors.blue,
                  barWidth: 3,
                  dotData: const FlDotData(show: true),
                  belowBarData: BarAreaData(
                    show: true,
                    color: Colors.blue.withValues(alpha: 0.1),
                  ),
                ),
                // Habit completion percentage line (scaled to water range)
                LineChartBarData(
                  spots: habitData.asMap().entries.map((entry) {
                    final percentage = entry.value['percentage'] as double;
                    return FlSpot(entry.key.toDouble(),
                        percentage / 100 * 3); // Scale to 0-3L range
                  }).toList(),
                  isCurved: true,
                  color: Colors.green,
                  barWidth: 2,
                  dotData: const FlDotData(show: false),
                  dashArray: [5, 5],
                ),
              ],
              minY: 0,
              maxY: 3,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLegendItem('Water Intake (L)', Colors.blue),
            const SizedBox(width: 20),
            _buildLegendItem('Habit Completion %', Colors.green),
          ],
        ),
        const SizedBox(height: 12),

        // Informational message about hydration data
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest
                .withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 16,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Hydration data needs to be input manually or tracked through habit completion data',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
