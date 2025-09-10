import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../data/database.dart';
import '../../domain/model/habit.dart';
import '../../services/insights_service.dart';
import '../../services/enhanced_insights_service.dart';
import '../../services/achievements_service.dart';
import '../widgets/smooth_transitions.dart';
import '../widgets/ai_status_banner.dart';
import '../widgets/enhanced_empty_insights_state.dart';
import '../widgets/ai_insights_onboarding.dart';
import '../widgets/ai_insights_debug_panel.dart';
import 'ai_settings_screen.dart';

class InsightsScreen extends ConsumerStatefulWidget {
  const InsightsScreen({super.key});

  @override
  ConsumerState<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends ConsumerState<InsightsScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late TabController _tabController;
  final InsightsService _insightsService = InsightsService();
  final EnhancedInsightsService _enhancedInsightsService =
      EnhancedInsightsService();

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _tabController = TabController(length: 3, vsync: this);

    // Listen for tab changes to show onboarding
    _tabController.addListener(() {
      if (_tabController.index == 1) {
        // AI Insights tab
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) {
            AIInsightsOnboarding.showIfNeeded(context);
          }
        });
      }
    });

    // Start animations
    _fadeController.forward();
    _slideController.forward();

    // Show AI onboarding after a delay if on AI insights tab
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted && _tabController.index == 1) {
          AIInsightsOnboarding.showIfNeeded(context);
        }
      });
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Insights',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AISettingsScreen(),
                ),
              );
            },
            tooltip: 'AI Settings',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.analytics), text: 'Analytics'),
            Tab(icon: Icon(Icons.psychology), text: 'AI Insights'),
            Tab(icon: Icon(Icons.emoji_events), text: 'Gamification'),
          ],
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
                  return const Center(child: CircularProgressIndicator());
                }

                final habits = snapshot.data ?? [];

                return FadeTransition(
                  opacity: _fadeController,
                  child: RefreshIndicator(
                    onRefresh: () async {
                      ref.invalidate(habitServiceProvider);
                    },
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildAnalyticsTab(habits, theme),
                        _buildAIInsightsTab(habits, theme),
                        _buildGamificationTab(habits, theme),
                      ],
                    ),
                  ),
                );
              },
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: theme.colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Unable to load insights',
                    style: theme.textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Error: $error',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAnalyticsTab(List<Habit> habits, ThemeData theme) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Big Four Performance Cards
          _buildBigFourCards(habits, theme),

          const SizedBox(height: 32),

          // Performance Deep Dive Section
          _buildPerformanceDeepDive(habits, theme),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildAIInsightsTab(List<Habit> habits, ThemeData theme) {
    final activeHabits = habits.where((h) => h.isActive).toList();
    final totalCompletions =
        activeHabits.fold<int>(0, (sum, h) => sum + h.completions.length);

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status banner for guidance
          AIStatusBanner(
            isAIAvailable: _enhancedInsightsService.isAIAvailable,
            habitCount: activeHabits.length,
            completionCount: totalCompletions,
          ),

          // AI Insights content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildAIInsights(habits, theme),
          ),

          // Debug panel (only in debug mode)
          AIInsightsDebugPanel(
            habitCount: activeHabits.length,
            completionCount: totalCompletions,
          ),
        ],
      ),
    );
  }

  Widget _buildGamificationTab(List<Habit> habits, ThemeData theme) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: FutureBuilder<Map<String, dynamic>>(
        future: _getGamificationData(habits),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final gamificationData = snapshot.data ?? {};

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Player Level & XP
              _buildPlayerLevelCard(gamificationData, theme),

              const SizedBox(height: 24),

              // Achievement Grid
              _buildAchievementsSection(gamificationData, theme),

              const SizedBox(height: 24),

              // Streak & Stats Overview
              _buildGamificationStats(gamificationData, habits, theme),

              const SizedBox(height: 24),

              // All Achievements Overview
              _buildAllAchievementsSection(gamificationData, theme),

              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }

  Future<Map<String, dynamic>> _getGamificationData(List<Habit> habits) async {
    try {
      // Convert habits to the format expected by AchievementsService
      final habitData = habits
          .map((h) => {
                'id': h.id,
                'name': h.name,
                'category': h.category,
                'currentStreak': h.streakInfo.current,
                'longestStreak': h.streakInfo.longest,
                'completionRate': h.completionRate,
                'completions': h.completions
                    .map((c) => {
                          'timestamp': c.millisecondsSinceEpoch,
                          'hour': c.hour,
                        })
                    .toList(),
              })
          .toList();

      final completionData = habits
          .expand((h) => h.completions)
          .map((c) => {
                'timestamp': c.millisecondsSinceEpoch,
                'habitId':
                    habits.firstWhere((h) => h.completions.contains(c)).id,
                'hour': c.hour,
              })
          .toList();

      return await AchievementsService.getGamificationStats(
        habits: habitData,
        completions: completionData,
      );
    } catch (e) {
      return {
        'level': 1,
        'xp': 0,
        'nextLevelXP': 100,
        'levelProgress': 0.0,
        'achievementsUnlocked': 0,
        'totalAchievements': AchievementsService.getAllAchievements().length,
        'rank': 'Novice',
      };
    }
  }

  Widget _buildBigFourCards(List<Habit> habits, ThemeData theme) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.5),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _slideController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutCubic),
      )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Performance Overview',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),

          // First row - Overall Completion & Current Streak
          Row(
            children: [
              Expanded(
                child: _buildOverallCompletionCard(habits, theme),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildCurrentStreakCard(habits, theme),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Second row - Consistency Score & Most Powerful Day
          Row(
            children: [
              Expanded(
                child: _buildConsistencyScoreCard(habits, theme),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMostPowerfulDayCard(habits, theme),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOverallCompletionCard(List<Habit> habits, ThemeData theme) {
    final data = _insightsService.calculateOverallCompletionRate(habits);
    final rate = ((data['rate'] as double) * 100).round();
    final sparklineData = data['sparkline'] as List<double>;

    return _buildPerformanceCard(
      title: 'Overall Completion',
      value: '$rate%',
      subtitle: data['trendText'] as String,
      icon: Icons.analytics_rounded,
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF4CAF50),
          Color(0xFF8BC34A),
        ],
      ),
      sparkline: sparklineData,
      theme: theme,
    );
  }

  Widget _buildCurrentStreakCard(List<Habit> habits, ThemeData theme) {
    final data = _insightsService.calculateCurrentStreak(habits);
    final days = data['days'] as int;
    final habitName = data['habitName'] as String;
    final comparison = data['comparison'] as String;

    return _buildPerformanceCard(
      title: 'Current Streak',
      value: '$days Days',
      subtitle: habitName.length > 20
          ? '${habitName.substring(0, 17)}...'
          : habitName,
      additionalInfo: comparison,
      icon: Icons.local_fire_department_rounded,
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFFF9800),
          Color(0xFFFFB74D),
        ],
      ),
      theme: theme,
    );
  }

  Widget _buildConsistencyScoreCard(List<Habit> habits, ThemeData theme) {
    final data = _insightsService.calculateConsistencyScore(habits);
    final score = data['score'] as int;
    final label = data['label'] as String;

    return _buildPerformanceCard(
      title: 'Consistency Score',
      value: '$score',
      subtitle: label,
      icon: Icons.insights_rounded,
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF2196F3),
          Color(0xFF64B5F6),
        ],
      ),
      theme: theme,
      showProgressIndicator: true,
      progressValue: score / 100,
    );
  }

  Widget _buildMostPowerfulDayCard(List<Habit> habits, ThemeData theme) {
    final data = _insightsService.calculateMostPowerfulDay(habits);
    final day = data['day'] as String;
    final percentage = data['percentage'] as int;
    final insight = data['insight'] as String;

    return _buildPerformanceCard(
      title: 'Most Powerful Day',
      value: day.length > 10 ? day.substring(0, 7) : day,
      subtitle:
          percentage > 0 ? '+$percentage% boost' : 'Consistent performance',
      additionalInfo:
          insight.length > 50 ? '${insight.substring(0, 47)}...' : insight,
      icon: Icons.star_rounded,
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF9C27B0),
          Color(0xFFBA68C8),
        ],
      ),
      theme: theme,
    );
  }

  Widget _buildPerformanceCard({
    required String title,
    required String value,
    required String subtitle,
    String? additionalInfo,
    required IconData icon,
    required Gradient gradient,
    required ThemeData theme,
    List<double>? sparkline,
    bool showProgressIndicator = false,
    double? progressValue,
  }) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: gradient.colors.first.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Background pattern
            Positioned(
              right: -20,
              top: -20,
              child: Icon(
                icon,
                size: 100,
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Header
                  Row(
                    children: [
                      Icon(
                        icon,
                        color: Colors.white,
                        size: 24,
                      ),
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
                    ],
                  ),

                  // Main value
                  Text(
                    value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // Subtitle and additional info
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (additionalInfo != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          additionalInfo,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 10,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],

                      // Progress indicator for consistency score
                      if (showProgressIndicator && progressValue != null) ...[
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: progressValue,
                          backgroundColor: Colors.white.withValues(alpha: 0.3),
                          valueColor:
                              const AlwaysStoppedAnimation<Color>(Colors.white),
                          minHeight: 3,
                        ),
                      ],

                      // Sparkline for completion rate
                      if (sparkline != null && sparkline.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 30,
                          child: _buildSparkline(sparkline, Colors.white),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSparkline(List<double> data, Color color) {
    if (data.isEmpty) return const SizedBox.shrink();

    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: data.asMap().entries.map((e) {
              return FlSpot(e.key.toDouble(), e.value);
            }).toList(),
            isCurved: true,
            color: color,
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: color.withValues(alpha: 0.3),
            ),
          ),
        ],
        minY: 0,
        maxY: 1,
      ),
    );
  }

  Widget _buildPerformanceDeepDive(List<Habit> habits, ThemeData theme) {
    final trendData = _insightsService.generateWeeklyTrendData(habits);

    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.5),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _slideController,
        curve: const Interval(0.3, 0.8, curve: Curves.easeOutCubic),
      )),
      child: Card(
        elevation: 8,
        shadowColor: theme.colorScheme.primary.withValues(alpha: 0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.trending_up_rounded,
                      color: theme.colorScheme.primary,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Habit Performance Deep Dive',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Weekly completion trends over the last 3 months',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Trend Chart
              SizedBox(
                height: 300,
                child: _buildTrendChart(trendData, theme),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrendChart(
      List<Map<String, dynamic>> trendData, ThemeData theme) {
    if (trendData.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bar_chart,
              size: 64,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No trend data available',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Complete some habits to see your progress trends!',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    final spots = trendData.asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;
      return FlSpot(
        index.toDouble(),
        (data['completionRate'] as double).clamp(0.0, 100.0),
      );
    }).toList();

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: 25,
          verticalInterval: 1,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
              strokeWidth: 1,
            );
          },
          getDrawingVerticalLine: (value) {
            return FlLine(
              color: theme.colorScheme.outline.withValues(alpha: 0.1),
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 25,
              getTitlesWidget: (value, meta) {
                return Text(
                  '${value.toInt()}%',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                );
              },
              reservedSize: 40,
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 2,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index >= 0 && index < trendData.length) {
                  final weekStart = trendData[index]['weekStart'] as DateTime;
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      '${weekStart.month}/${weekStart.day}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  );
                }
                return const Text('');
              },
              reservedSize: 30,
            ),
          ),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: theme.colorScheme.primary,
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: theme.colorScheme.primary,
                  strokeWidth: 2,
                  strokeColor: theme.colorScheme.surface,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  theme.colorScheme.primary.withValues(alpha: 0.3),
                  theme.colorScheme.primary.withValues(alpha: 0.1),
                ],
              ),
            ),
          ),
        ],
        minY: 0,
        maxY: 100,
      ),
    );
  }

  Widget _buildAIInsights(List<Habit> habits, ThemeData theme) {
    final activeHabits = habits.where((h) => h.isActive).toList();
    final totalCompletions =
        activeHabits.fold<int>(0, (sum, h) => sum + h.completions.length);

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _enhancedInsightsService.generateComprehensiveInsights(habits),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Column(
            children: [
              _buildAIInsightsHeader(theme),
              const SizedBox(height: 24),
              const Center(child: CircularProgressIndicator()),
              const SizedBox(height: 16),
              Text(
                'Analyzing your habits...',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
          );
        }

        final insights = snapshot.data ?? [];

        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.5),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: _slideController,
            curve: const Interval(0.5, 1.0, curve: Curves.easeOutCubic),
          )),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAIInsightsHeader(theme),
              const SizedBox(height: 24),
              if (insights.isNotEmpty) ...[
                // Show loading status if AI is working
                if (snapshot.connectionState == ConnectionState.waiting)
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border:
                          Border.all(color: Colors.blue.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        const SizedBox(width: 12),
                        const Text('Generating AI insights...'),
                      ],
                    ),
                  ),
                ...insights.asMap().entries.map((entry) {
                  final index = entry.key;
                  final insight = entry.value;

                  return Padding(
                    padding: EdgeInsets.only(
                        bottom: index < insights.length - 1 ? 16 : 0),
                    child: SmoothTransitions.slideTransition(
                      show: true,
                      duration: Duration(milliseconds: 600 + (index * 200)),
                      child: _buildInsightCard(insight, theme),
                    ),
                  );
                }),
              ] else
                EnhancedEmptyInsightsState(
                  habitCount: activeHabits.length,
                  completionCount: totalCompletions,
                  theme: theme,
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAIInsightsHeader(ThemeData theme) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.secondary,
                theme.colorScheme.secondary.withValues(alpha: 0.7),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.auto_awesome,
            color: Colors.white,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _enhancedInsightsService.isAIAvailable
                    ? 'AI-Powered Insights'
                    : 'Smart Insights',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                _enhancedInsightsService.isAIAvailable
                    ? 'Personalized AI recommendations and discoveries'
                    : 'Pattern-based insights and recommendations',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
        PopupMenuButton<String>(
          icon: Icon(
            Icons.more_vert,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
          onSelected: (value) {
            switch (value) {
              case 'settings':
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AISettingsScreen(),
                  ),
                );
                break;
              case 'help':
                AIInsightsOnboarding.show(context);
                break;
              case 'refresh':
                setState(() {});
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'settings',
              child: Row(
                children: [
                  Icon(Icons.settings),
                  SizedBox(width: 12),
                  Text('AI Settings'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'help',
              child: Row(
                children: [
                  Icon(Icons.help_outline),
                  SizedBox(width: 12),
                  Text('How it Works'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'refresh',
              child: Row(
                children: [
                  Icon(Icons.refresh),
                  SizedBox(width: 12),
                  Text('Refresh Insights'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInsightCard(Map<String, dynamic> insight, ThemeData theme) {
    final type = insight['type'] as String;
    final title = insight['title'] as String;
    final description = insight['description'] as String;
    final iconName = insight['icon'] as String;

    final icon = _getIconFromName(iconName);
    final colors = _getColorsForInsightType(type, theme);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colors['primary']!,
            colors['secondary']!,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colors['primary']!.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Background decoration
            Positioned(
              right: -10,
              top: -10,
              child: Icon(
                icon,
                size: 80,
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          icon,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    description,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconFromName(String iconName) {
    switch (iconName) {
      case 'rocket_launch':
        return Icons.rocket_launch;
      case 'weekend':
        return Icons.weekend;
      case 'local_fire_department':
        return Icons.local_fire_department;
      case 'celebration':
        return Icons.celebration;
      case 'wb_sunny':
        return Icons.wb_sunny;
      case 'emoji_events':
        return Icons.emoji_events;
      case 'trending_up':
        return Icons.trending_up;
      default:
        return Icons.lightbulb;
    }
  }

  Map<String, Color> _getColorsForInsightType(String type, ThemeData theme) {
    switch (type) {
      case 'motivational':
        return {
          'primary': const Color(0xFF4CAF50),
          'secondary': const Color(0xFF8BC34A),
        };
      case 'pattern':
        return {
          'primary': const Color(0xFFFF9800),
          'secondary': const Color(0xFFFFB74D),
        };
      case 'motivation':
        return {
          'primary': const Color(0xFFE91E63),
          'secondary': const Color(0xFFF06292),
        };
      case 'celebration':
        return {
          'primary': const Color(0xFF9C27B0),
          'secondary': const Color(0xFFBA68C8),
        };
      case 'insight':
        return {
          'primary': const Color(0xFF2196F3),
          'secondary': const Color(0xFF64B5F6),
        };
      case 'strength':
        return {
          'primary': const Color(0xFF607D8B),
          'secondary': const Color(0xFF90A4AE),
        };
      case 'achievement':
        return {
          'primary': const Color(0xFF795548),
          'secondary': const Color(0xFFA1887F),
        };
      default:
        return {
          'primary': theme.colorScheme.primary,
          'secondary': theme.colorScheme.primary.withValues(alpha: 0.7),
        };
    }
  }

  // Gamification Tab Widgets

  Widget _buildPlayerLevelCard(Map<String, dynamic> data, ThemeData theme) {
    final level = data['level'] ?? 1;
    final xp = data['xp'] ?? 0;
    final nextLevelXP = data['nextLevelXP'] ?? 100;
    final progress = data['levelProgress'] ?? 0.0;
    final rank = data['rank'] ?? 'Novice';

    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.3),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _slideController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeOutCubic),
      )),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.primary,
              theme.colorScheme.primary.withValues(alpha: 0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    Icons.person_rounded,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Level $level',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        rank,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$xp XP',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Progress to Level ${level + 1}',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              minHeight: 8,
            ),
            const SizedBox(height: 8),
            Text(
              '${((progress * 100).round())}% complete - ${nextLevelXP - xp} XP to next level',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementsSection(Map<String, dynamic> data, ThemeData theme) {
    final unlockedCount = data['achievementsUnlocked'] ?? 0;
    final totalCount = data['totalAchievements'] ?? 0;

    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.3),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _slideController,
        curve: const Interval(0.2, 0.5, curve: Curves.easeOutCubic),
      )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.emoji_events,
                color: theme.colorScheme.primary,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Achievements',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$unlockedCount / $totalCount',
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          FutureBuilder<List<Achievement>>(
            future: AchievementsService.getUnlockedAchievements(),
            builder: (context, snapshot) {
              final achievements = snapshot.data ?? [];
              final allAchievements = AchievementsService.getAllAchievements();

              return Column(
                children: [
                  // Unlocked achievements
                  if (achievements.isNotEmpty) ...[
                    _buildAchievementGrid(
                      achievements.take(6).toList(),
                      'Recent Achievements',
                      theme,
                      true,
                    ),
                    const SizedBox(height: 16),
                  ],
                  // Next available achievements
                  _buildAchievementGrid(
                    allAchievements
                        .where((a) => !achievements
                            .any((unlocked) => unlocked.id == a.id))
                        .take(4)
                        .toList(),
                    'Next to Unlock',
                    theme,
                    false,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementGrid(
    List<Achievement> achievements,
    String title,
    ThemeData theme,
    bool isUnlocked,
  ) {
    if (achievements.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        // Use a more flexible layout approach
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: achievements.map((achievement) {
            return SizedBox(
              width: (MediaQuery.of(context).size.width - 48) /
                  2, // Half screen minus padding
              child: _buildAchievementCard(achievement, theme, isUnlocked),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAchievementCard(
      Achievement achievement, ThemeData theme, bool isUnlocked) {
    return Container(
      constraints: const BoxConstraints(minHeight: 80), // Ensure minimum height
      padding:
          const EdgeInsets.all(12), // Reduced padding to fit content better
      decoration: BoxDecoration(
        color: isUnlocked
            ? theme.colorScheme.primaryContainer
            : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isUnlocked
              ? theme.colorScheme.primary.withValues(alpha: 0.3)
              : theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start, // Align to top for better text wrapping
        children: [
          Container(
            padding: const EdgeInsets.all(6), // Reduced padding for icon
            decoration: BoxDecoration(
              color: isUnlocked
                  ? theme.colorScheme.primary.withValues(alpha: 0.1)
                  : theme.colorScheme.outline.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              achievement.icon,
              style: TextStyle(
                fontSize: 18, // Slightly reduced icon size
                color: isUnlocked ? null : theme.colorScheme.outline,
              ),
            ),
          ),
          const SizedBox(width: 8), // Reduced spacing
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // Use minimum space needed
              children: [
                Text(
                  achievement.title,
                  style: theme.textTheme.bodySmall?.copyWith(
                    // Changed to bodySmall for better fit
                    fontWeight: FontWeight.w600,
                    color: isUnlocked ? null : theme.colorScheme.outline,
                  ),
                  maxLines: 2, // Allow up to 2 lines for title
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2), // Reduced spacing
                Text(
                  achievement.description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 11, // Smaller font for description
                    color: isUnlocked
                        ? theme.colorScheme.onSurface.withValues(alpha: 0.7)
                        : theme.colorScheme.outline.withValues(alpha: 0.7),
                    height: 1.2, // Tighter line height
                  ),
                  maxLines: 3, // Allow up to 3 lines for description
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGamificationStats(
      Map<String, dynamic> data, List<Habit> habits, ThemeData theme) {
    final totalStreak = data['totalStreak'] ?? 0;
    final maxStreak = data['maxStreak'] ?? 0;
    final perfectDays = data['perfectDays'] ?? 0;
    final completionRate = ((data['completionRate'] ?? 0.0) * 100).round();

    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.3),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _slideController,
        curve: const Interval(0.4, 0.7, curve: Curves.easeOutCubic),
      )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Performance Statistics',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total Streak',
                  '$totalStreak',
                  Icons.local_fire_department,
                  Colors.orange,
                  theme,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Best Streak',
                  '$maxStreak',
                  Icons.trending_up,
                  Colors.green,
                  theme,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Perfect Days',
                  '$perfectDays',
                  Icons.star,
                  Colors.amber,
                  theme,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Completion',
                  '$completionRate%',
                  Icons.check_circle,
                  Colors.blue,
                  theme,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
    ThemeData theme,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: theme.textTheme.bodySmall?.copyWith(
              color: color.withValues(alpha: 0.8),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAllAchievementsSection(
      Map<String, dynamic> data, ThemeData theme) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.3),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _slideController,
        curve: const Interval(0.6, 1.0, curve: Curves.easeOutCubic),
      )),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.emoji_events,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'All Achievements',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  '${data['achievementsUnlocked'] ?? 0} / ${data['totalAchievements'] ?? 0}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Expandable achievements list
            Theme(
              data: theme.copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                title: Text(
                  'View All Achievements Progress',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  'Tap to see detailed progress on all ${data['totalAchievements'] ?? 0} achievements',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                leading: Icon(
                  Icons.list_alt,
                  color: theme.colorScheme.primary,
                ),
                children: [
                  const SizedBox(height: 8),
                  _buildAchievementsList(theme),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementsList(ThemeData theme) {
    return FutureBuilder<Map<String, double>>(
      future: _getAchievementsProgress(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final progressData = snapshot.data ?? {};
        final allAchievements = AchievementsService.getAllAchievements();

        // Group achievements by category
        final groupedAchievements = <AchievementCategory, List<Achievement>>{};
        for (final achievement in allAchievements) {
          groupedAchievements
              .putIfAbsent(achievement.category, () => [])
              .add(achievement);
        }

        return Container(
          constraints: const BoxConstraints(maxHeight: 400),
          child: SingleChildScrollView(
            child: Column(
              children: groupedAchievements.entries.map((entry) {
                return _buildAchievementCategorySection(
                  entry.key,
                  entry.value,
                  progressData,
                  theme,
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAchievementCategorySection(
    AchievementCategory category,
    List<Achievement> achievements,
    Map<String, double> progressData,
    ThemeData theme,
  ) {
    final categoryName = _getCategoryDisplayName(category);
    final categoryIcon = _getCategoryIcon(category);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                Text(
                  categoryIcon,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 8),
                Text(
                  categoryName,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '(${achievements.length})',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Achievement items
          ...achievements.map((achievement) {
            final progress = progressData[achievement.id] ?? 0.0;
            final isUnlocked = progress >= 1.0;

            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isUnlocked
                    ? theme.colorScheme.primary.withValues(alpha: 0.1)
                    : theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isUnlocked
                      ? theme.colorScheme.primary.withValues(alpha: 0.3)
                      : theme.colorScheme.outline.withValues(alpha: 0.1),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        achievement.icon,
                        style: TextStyle(
                          fontSize: 20,
                          color: isUnlocked ? null : Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              achievement.title,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: isUnlocked
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.onSurface,
                              ),
                            ),
                            Text(
                              achievement.description,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${(progress * achievement.requirement).round()} / ${achievement.requirement}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: isUnlocked
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.onSurface
                                      .withValues(alpha: 0.6),
                            ),
                          ),
                          Text(
                            '+${achievement.xpReward} XP',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.secondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Progress bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor:
                          theme.colorScheme.outline.withValues(alpha: 0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isUnlocked
                            ? theme.colorScheme.primary
                            : theme.colorScheme.primary.withValues(alpha: 0.6),
                      ),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  String _getCategoryDisplayName(AchievementCategory category) {
    switch (category) {
      case AchievementCategory.streak:
        return 'Streak Achievements';
      case AchievementCategory.consistency:
        return 'Consistency Achievements';
      case AchievementCategory.variety:
        return 'Variety Achievements';
      case AchievementCategory.dedication:
        return 'Dedication Achievements';
      case AchievementCategory.health:
        return 'Health & Fitness';
      case AchievementCategory.mentalHealth:
        return 'Mental Health';
      case AchievementCategory.special:
        return 'Special Achievements';
    }
  }

  String _getCategoryIcon(AchievementCategory category) {
    switch (category) {
      case AchievementCategory.streak:
        return '🔥';
      case AchievementCategory.consistency:
        return '⭐';
      case AchievementCategory.variety:
        return '🌟';
      case AchievementCategory.dedication:
        return '💪';
      case AchievementCategory.health:
        return '❤️';
      case AchievementCategory.mentalHealth:
        return '🧘';
      case AchievementCategory.special:
        return '🏆';
    }
  }

  Future<Map<String, double>> _getAchievementsProgress() async {
    try {
      // Access the habit service through the provider
      final habitServiceAsync = ref.read(habitServiceProvider);
      final habitService = await habitServiceAsync.maybeWhen(
        data: (service) => Future.value(service),
        orElse: () => throw Exception('Habit service not available'),
      );

      // Get current habits data
      final habits = await habitService.getAllHabits();

      // Convert to the format expected by AchievementsService
      final habitData = habits
          .map((h) => {
                'id': h.id,
                'name': h.name,
                'category': h.category,
                'currentStreak': h.streakInfo.current,
                'longestStreak': h.streakInfo.longest,
                'completionRate': h.completionRate,
              })
          .toList();

      final completionData = habits
          .expand((h) => h.completions)
          .map((c) => {
                'completedAt': c,
                'habitId':
                    habits.firstWhere((h) => h.completions.contains(c)).id,
              })
          .toList();

      return await AchievementsService.getAchievementProgress(
        habits: habitData,
        completions: completionData,
      );
    } catch (e) {
      return {};
    }
  }
}
