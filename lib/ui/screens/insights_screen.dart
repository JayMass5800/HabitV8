import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../data/database.dart';
import '../../domain/model/habit.dart';
import '../../services/habit_stats_service.dart';
import '../../services/trend_analysis_service.dart';
import '../../services/comprehensive_habit_suggestions_service.dart';
import '../../services/health_habit_analytics_service.dart';
import '../../services/health_service.dart';
import '../../services/achievements_service.dart';
import '../../services/health_habit_integration_service.dart';
import '../../services/logging_service.dart';
import '../../services/minimal_health_channel.dart';
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
  Map<String, dynamic>? _integrationStatus;

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

              // Load integration status
              try {
                _integrationStatus =
                    await HealthHabitIntegrationService.getIntegrationStatus(
                  habitService: habitService,
                );
                AppLogger.info('Integration status loaded successfully');
              } catch (integrationError) {
                AppLogger.error(
                    'Failed to load integration status', integrationError);
                _integrationStatus = null;
              }
            } else {
              AppLogger.info(
                  'Health permissions not granted, skipping health data load');
              _healthSummary = {
                'error': 'Health permissions not granted',
                'hasPermissions': false,
                'canRetry': true,
                'needsPermissions': true,
              };
              _integrationStatus = null;
            }
          } catch (e) {
            AppLogger.error('Failed to load health summary', e);
            _healthSummary = {
              'error': 'Failed to load health data',
              'errorDetails': e.toString(),
              'hasPermissions': false,
              'canRetry': true,
            };
            _integrationStatus = null;
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
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.bug_report),
            tooltip: 'Run Health Diagnostics',
            onPressed: _runHealthDiagnostics,
          ),
        ],
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
                        _buildBigFourPerformanceCards(habits),
                        const SizedBox(height: 24),
                        _buildHabitPerformanceChart(habits),
                        const SizedBox(height: 24),
                        _buildAIInsightsSection(habits),
                        const SizedBox(height: 24),
                        // Enhanced Health Integration
                        if (_integrationStatus != null) ...[
                          _buildEnhancedHealthIntegrationSection(),
                          const SizedBox(height: 24),
                        ],

                        // Health Debug Section - Always visible
                        _buildHealthDebugSection(),
                        const SizedBox(height: 24),

                        // Conditional Health Hub
                        _buildConditionalHealthHub(habits),
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

  Widget _buildOverviewCards(List<Habit> habits) {
    final overallCompletion = _calculateOverallCompletion(habits);
    final currentStreak = _calculateCurrentStreak(habits);
    final consistencyScore = _calculateConsistencyScore(habits);
    final mostPowerfulDay = _findMostPowerfulDay(habits);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Overview',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildOverviewCard(
                'Overall Completion',
                '${(overallCompletion * 100).toInt()}%',
                Icons.check_circle,
                Colors.green,
                overallCompletion,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildOverviewCard(
                'Current Streak',
                '$currentStreak days',
                Icons.local_fire_department,
                Colors.orange,
                (currentStreak / 30.0).clamp(0.0, 1.0),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildOverviewCard(
                'Consistency Score',
                '${consistencyScore.toInt()}%',
                Icons.timeline,
                Colors.blue,
                consistencyScore / 100.0,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildOverviewCard(
                'Most Powerful Day',
                mostPowerfulDay,
                Icons.star,
                Colors.purple,
                0.8,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOverviewCard(
      String title, String value, IconData icon, Color color, double progress) {
    return Card(
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              color.withValues(alpha: 0.1),
              color.withValues(alpha: 0.05)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const Spacer(),
                CircularProgressIndicator(
                  value: progress.clamp(0.0, 1.0),
                  backgroundColor: color.withValues(alpha: 0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  strokeWidth: 3,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
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
            ],
          ),
        );
      },
    );
  }

  // Helper methods for calculations
  double _calculateOverallCompletion(List<Habit> habits) {
    if (habits.isEmpty) return 0.0;

    double totalCompletion = 0.0;
    for (final habit in habits) {
      totalCompletion += _statsService.getCompletionRate(habit, days: 30);
    }
    return totalCompletion / habits.length;
  }

  int _calculateCurrentStreak(List<Habit> habits) {
    if (habits.isEmpty) return 0;

    int maxStreak = 0;
    for (final habit in habits) {
      final streakInfo = _statsService.getStreakInfo(habit);
      maxStreak =
          maxStreak > streakInfo.current ? maxStreak : streakInfo.current;
    }
    return maxStreak;
  }

  double _calculateConsistencyScore(List<Habit> habits) {
    if (habits.isEmpty) return 0.0;

    double totalConsistency = 0.0;
    for (final habit in habits) {
      totalConsistency += _statsService.getConsistencyScore(habit);
    }
    return totalConsistency / habits.length;
  }

  String _findMostPowerfulDay(List<Habit> habits) {
    final dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final dayCompletions = List<int>.filled(7, 0);

    for (final habit in habits) {
      for (final completion in habit.completions) {
        dayCompletions[completion.weekday - 1]++;
      }
    }

    int maxIndex = 0;
    for (int i = 1; i < dayCompletions.length; i++) {
      if (dayCompletions[i] > dayCompletions[maxIndex]) {
        maxIndex = i;
      }
    }

    return dayNames[maxIndex];
  }

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
          // Navigate to create habit with prefilled data
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

  Widget _buildAchievementsOverview() {
    return FutureBuilder<List<Achievement>>(
      future: AchievementsService.getUnlockedAchievements(),
      builder: (context, snapshot) {
        final unlockedAchievements = snapshot.data ?? [];
        final totalAchievements = AchievementsService.getAllAchievements();

        return Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Achievement Progress',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildAchievementStat(
                      'Unlocked',
                      '${unlockedAchievements.length}',
                      Icons.emoji_events,
                      Colors.amber,
                    ),
                    _buildAchievementStat(
                      'Total',
                      '${totalAchievements.length}',
                      Icons.flag,
                      Colors.blue,
                    ),
                    _buildAchievementStat(
                      'Progress',
                      '${totalAchievements.isEmpty ? 0 : ((unlockedAchievements.length / totalAchievements.length) * 100).toInt()}%',
                      Icons.trending_up,
                      Colors.green,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAchievementStat(
      String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
        ),
      ],
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

  // Health Integration Methods
  Widget _buildEnhancedHealthIntegrationSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.health_and_safety, color: Colors.green),
                const SizedBox(width: 8),
                Text(
                  'Health Integration',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border:
                        Border.all(color: Colors.green.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.auto_awesome,
                          size: 14, color: Colors.green.shade700),
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
    if (_healthSummary == null || _healthSummary!.containsKey('error')) {
      return const SizedBox.shrink();
    }

    final health = _healthSummary!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Today\'s Health Metrics',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildHealthMetricTile(
                'Steps',
                '${health['steps'] ?? 0}',
                Icons.directions_walk,
                Colors.blue,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildHealthMetricTile(
                'Calories',
                _formatCaloriesValue(health),
                Icons.local_fire_department,
                Colors.orange,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildHealthMetricTile(
                'Sleep',
                '${(health['sleepHours'] ?? 0).toStringAsFixed(1)}h',
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
      String label, String value, IconData icon, Color color) {
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
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
              fontSize: 16,
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
      ),
    );
  }

  String _formatCaloriesValue(Map<String, dynamic> health) {
    final active = health['activeCalories'] ?? 0.0;
    final total = health['totalCalories'] ?? 0.0;
    if (active > 0) {
      return '${active.toInt()}';
    } else if (total > 0) {
      return '${total.toInt()}';
    }
    return '0';
  }

  Widget _buildHealthHabitCorrelations() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Health-Habit Insights',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
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
              Icon(Icons.insights, color: Colors.blue.shade600, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Your habits are positively impacting your health metrics. Keep up the great work!',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blue.shade700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

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
            if (_healthSummary != null &&
                !_healthSummary!.containsKey('error')) ...[
              _buildSleepHabitModule(habits),
              const SizedBox(height: 20),
              _buildActivityEnergyModule(habits),
            ] else
              _buildHealthDataPlaceholder(),
          ],
        ),
      ),
    );
  }

  Widget _buildSleepHabitModule(List<Habit> habits) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final sleepHours = _healthSummary?['sleepHours'] ?? 0.0;

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
                      style: theme.textTheme.titleSmall?.copyWith(
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
      ],
    );
  }

  Widget _buildActivityEnergyModule(List<Habit> habits) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final steps = _healthSummary?['steps'] ?? 0;
    final calories = _healthSummary?['activeCalories'] ?? 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Activity & Energy Levels',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: isDark ? theme.colorScheme.primary : Colors.orange[700],
          ),
        ),
        const SizedBox(height: 12),
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
              Icon(Icons.directions_run, color: Colors.orange, size: 32),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Today: $steps steps, ${calories.toInt()} cal',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      steps >= 8000
                          ? 'Active lifestyle boosts habit motivation!'
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
      ],
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

  Widget _buildHealthDebugSection() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.health_and_safety,
                  color: isDark ? theme.colorScheme.primary : Colors.teal,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Health Integration Status',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? theme.colorScheme.primary
                        : Colors.teal.shade700,
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: _runHealthDiagnostics,
                  icon: const Icon(Icons.bug_report, size: 16),
                  label: const Text('Debug'),
                  style: TextButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Health Status Indicators
            _buildHealthStatusIndicators(),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthStatusIndicators() {
    return Column(
      children: [
        _buildStatusRow(
          'Health Permissions',
          _healthSummary != null &&
              !_healthSummary!.containsKey('needsPermissions'),
          'Granted',
          'Not granted',
        ),
        const SizedBox(height: 8),
        _buildStatusRow(
          'Health Data Available',
          _healthSummary != null && !_healthSummary!.containsKey('error'),
          'Available',
          'Unavailable',
        ),
        const SizedBox(height: 8),
        _buildStatusRow(
          'Integration Active',
          _integrationStatus != null,
          'Active',
          'Inactive',
        ),
      ],
    );
  }

  Widget _buildStatusRow(
      String label, bool isActive, String activeText, String inactiveText) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 14),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isActive
                ? Colors.green.withValues(alpha: 0.1)
                : Colors.red.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isActive
                  ? Colors.green.withValues(alpha: 0.3)
                  : Colors.red.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isActive ? Icons.check_circle : Icons.cancel,
                size: 14,
                color: isActive ? Colors.green.shade600 : Colors.red.shade600,
              ),
              const SizedBox(width: 4),
              Text(
                isActive ? activeText : inactiveText,
                style: TextStyle(
                  fontSize: 12,
                  color: isActive ? Colors.green.shade700 : Colors.red.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _runHealthDiagnostics() async {
    try {
      AppLogger.info(
          '🔍 Running Health Connect diagnostics from Insights screen...');

      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const AlertDialog(
          title: Text('Running Diagnostics'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Analyzing Health Connect integration...'),
            ],
          ),
        ),
      );

      // Run diagnostics
      final results =
          await MinimalHealthChannel.runNativeHealthConnectDiagnostics();

      // Close loading dialog
      if (mounted) Navigator.of(context).pop();

      // Show results dialog
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Health Connect Diagnostics'),
            content: SizedBox(
              width: double.maxFinite,
              height: 400,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        'Device: ${results['deviceInfo']?['manufacturer']} ${results['deviceInfo']?['model']}'),
                    Text(
                        'Android: ${results['deviceInfo']?['androidVersion']} (API ${results['deviceInfo']?['apiLevel']})'),
                    const SizedBox(height: 16),
                    Text(
                        'Health Connect Available: ${results['healthConnectAvailable']}'),
                    Text('Client Initialized: ${results['clientInitialized']}'),
                    Text(
                        'Permissions Granted: ${results['permissionCount'] ?? 0}'),
                    const SizedBox(height: 16),
                    const Text('Data Availability:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    if (results['dataAvailability'] != null)
                      ...((results['dataAvailability'] as Map<String, dynamic>)
                          .entries
                          .map((entry) {
                        final dataType = entry.key;
                        final ranges = entry.value as Map<String, dynamic>;
                        final hasAnyData = ranges.values.any((range) =>
                            (range as Map<String, dynamic>)['hasData'] == true);
                        return Text(
                            '$dataType: ${hasAnyData ? "✅ Has data" : "❌ No data"}');
                      })),
                    const SizedBox(height: 16),
                    if (results['recommendations'] != null) ...[
                      const Text('Recommendations:',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      ...(results['recommendations'] as List)
                          .map((rec) => Text('• $rec')),
                    ],
                    if (results['error'] != null) ...[
                      const Text('Error:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.red)),
                      Text(results['error'].toString(),
                          style: const TextStyle(color: Colors.red)),
                    ],
                  ],
                ),
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

      AppLogger.info('✅ Health diagnostics completed and displayed');
    } catch (e) {
      AppLogger.error('❌ Failed to run health diagnostics', e);

      // Close loading dialog if still open
      if (mounted) Navigator.of(context).pop();

      // Show error dialog
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Diagnostics Error'),
            content: Text('Failed to run health diagnostics: $e'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          ),
        );
      }
    }
  }
}
