import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../data/database_isar.dart';
import '../../domain/model/habit.dart';
import '../../services/insights_service.dart';
import '../../services/enhanced_insights_service.dart';
import '../../services/achievements_service.dart';
import '../../services/subscription_service.dart';
import '../widgets/smooth_transitions.dart';
import '../widgets/ai_status_banner.dart';
import '../widgets/enhanced_empty_insights_state.dart';
import '../widgets/ai_insights_onboarding.dart';
import '../widgets/ai_insights_debug_panel.dart';
import '../widgets/premium_feature_guard.dart';
import 'ai_settings_screen.dart';
import 'edit_habit_screen.dart';

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

  // State for lazy loading AI insights to avoid unnecessary API calls
  // AI insights are only loaded when the AI Insights tab is accessed
  bool _aiInsightsRequested = false;
  Future<List<Map<String, dynamic>>>? _aiInsightsFuture;

  // AI Status state for conditional visibility
  bool _isAIEnabled = false;
  bool _isAIAvailable = false;

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

    // Listen for tab changes to show onboarding and load AI insights
    _tabController.addListener(() {
      if (_tabController.index == 1) {
        // AI Insights tab
        if (!_aiInsightsRequested) {
          // Load AI insights automatically on first access
          _loadAIInsights();
        }
        // Show onboarding after a delay
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) {
            AIInsightsOnboarding.showIfNeeded(context);
          }
        });
      }
    });

    // Initialize AI status and start animations
    // IMPORTANT: Initialize AI status synchronously to prevent race conditions
    _initializeAIStatus();
    _fadeController.forward();
    _slideController.forward();

    // Show AI onboarding after a delay if on AI insights tab
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted && _tabController.index == 1) {
          _loadAIInsights();
          AIInsightsOnboarding.showIfNeeded(context);
        }
      });
    });
  }

  /// Initialize and monitor AI status
  Future<void> _initializeAIStatus() async {
    await _updateAIStatus();
  }

  /// Update AI status from settings
  Future<void> _updateAIStatus() async {
    try {
      final isAIAvailable = await _enhancedInsightsService.isAIAvailableAsync;

      // Check if AI is enabled in settings
      const secureStorage = FlutterSecureStorage();
      final enableAI =
          await secureStorage.read(key: 'enable_ai_insights') == 'true';

      if (mounted) {
        setState(() {
          _isAIEnabled = enableAI;
          _isAIAvailable = isAIAvailable;
        });
      }
    } catch (e) {
      // If there's an error, default to disabled
      if (mounted) {
        setState(() {
          _isAIEnabled = false;
          _isAIAvailable = false;
        });
      }
    }
  }

  /// Load AI insights only when requested (lazy loading)
  void _loadAIInsights() {
    if (!_aiInsightsRequested && mounted) {
      setState(() {
        _aiInsightsRequested = true;
      });
    }
  }

  /// Reset AI insights to force reload (useful when habits data changes)
  void _resetAIInsights() {
    if (mounted) {
      setState(() {
        _aiInsightsRequested = false;
        _aiInsightsFuture = null;
      });
    }
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
            onPressed: () async {
              final result = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AISettingsScreen(),
                ),
              );
              // Update AI status when returning from settings
              if (result != null || mounted) {
                await _updateAIStatus();
              }
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
          // 🔔 REACTIVE: Watch habits stream for instant insights updates!
          // AI insights, analytics, and gamification now update automatically
          final habitsAsync = ref.watch(habitsStreamIsarProvider);

          return habitsAsync.when(
            data: (habits) {
              return FadeTransition(
                opacity: _fadeController,
                child: RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(habitsStreamIsarProvider);
                    _resetAIInsights(); // Reset AI insights on refresh
                    await _updateAIStatus(); // Update AI status on refresh
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

          // Note: Volatility and Time-of-Day charts moved to AI Insights tab

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildAIInsightsTab(List<Habit> habits, ThemeData theme) {
    final activeHabits = habits.where((h) => h.isActive).toList();
    final totalCompletions =
        activeHabits.fold<int>(0, (sum, h) => sum + h.completions.length);

    return PremiumFeatureGuard(
      feature: PremiumFeature.aiInsights,
      child: SingleChildScrollView(
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

            // Show AI insights if enabled and available, otherwise show backup analysis
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _isAIEnabled && _isAIAvailable
                  ? _buildAIInsights(habits, theme)
                  : _buildBackupAnalysis(habits, theme),
            ),

            // Debug panel (only in debug mode)
            AIInsightsDebugPanel(
              habitCount: activeHabits.length,
              completionCount: totalCompletions,
            ),
          ],
        ),
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

      // Check for new achievements before getting stats
      final newAchievements = await AchievementsService.checkForNewAchievements(
        habits: habitData,
        completions: completionData,
      );

      // Show achievement notifications if any new achievements were earned
      if (newAchievements.isNotEmpty && mounted) {
        for (final achievement in newAchievements) {
          _showAchievementNotification(achievement);
        }
      }

      return await AchievementsService.getGamificationStats(
        habits: habitData,
        completions: completionData,
      );
    } catch (e) {
      debugPrint('Error getting gamification data: $e');
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
    final stats = _insightsService.calculateOverallCompletionRate(habits);
    final completionRate = stats['rate'] as double? ?? 0.0;
    final trendText = stats['trendText'] as String? ?? '';

    return _buildPerformanceCard(
      title: 'Overall Completion',
      value: '${(completionRate * 100).toStringAsFixed(0)}%',
      subtitle: trendText,
      icon: Icons.check_circle,
      gradient: LinearGradient(
        colors: [
          theme.colorScheme.primary,
          theme.colorScheme.primary.withValues(alpha: 0.7),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      theme: theme,
      sparkline: stats['sparkline'] as List<double>?,
    );
  }

  Widget _buildCurrentStreakCard(List<Habit> habits, ThemeData theme) {
    final stats = _insightsService.calculateCurrentStreak(habits);
    final currentStreak = stats['days'] as int? ?? 0;
    final comparison = stats['comparison'] as String? ?? '';

    return _buildPerformanceCard(
      title: 'Current Streak',
      value: '$currentStreak days',
      subtitle: comparison,
      icon: Icons.local_fire_department,
      gradient: LinearGradient(
        colors: [
          Colors.orange.shade600,
          Colors.deepOrange.shade400,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      theme: theme,
    );
  }

  Widget _buildConsistencyScoreCard(List<Habit> habits, ThemeData theme) {
    final stats = _insightsService.calculateConsistencyScore(habits);
    final consistencyScore = stats['score'] as int? ?? 0;
    final label = stats['label'] as String? ?? '';

    return _buildPerformanceCard(
      title: 'Consistency Score',
      value: '$consistencyScore',
      subtitle: label,
      icon: Icons.trending_up,
      gradient: LinearGradient(
        colors: [
          Colors.green.shade600,
          Colors.teal.shade400,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      theme: theme,
      showProgressIndicator: true,
      progressValue: consistencyScore / 100.0,
    );
  }

  Widget _buildMostPowerfulDayCard(List<Habit> habits, ThemeData theme) {
    // Calculate most powerful day from completion data
    final dayCompletions = <int, int>{};
    for (final habit in habits) {
      for (final completion in habit.completions) {
        final dayOfWeek = completion.weekday;
        dayCompletions[dayOfWeek] = (dayCompletions[dayOfWeek] ?? 0) + 1;
      }
    }

    int bestDay = 1;
    int bestDayCount = 0;
    dayCompletions.forEach((day, count) {
      if (count > bestDayCount) {
        bestDay = day;
        bestDayCount = count;
      }
    });

    final dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final bestDayName = dayCompletions.isEmpty ? 'N/A' : dayNames[bestDay - 1];

    return _buildPerformanceCard(
      title: 'Most Powerful Day',
      value: bestDayName,
      subtitle: '$bestDayCount completions',
      icon: Icons.calendar_today,
      gradient: LinearGradient(
        colors: [
          Colors.purple.shade600,
          Colors.deepPurple.shade400,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
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
                try {
                  final index = value.toInt();
                  if (index >= 0 && index < trendData.length) {
                    final weekStart =
                        trendData[index]['weekStart'] as DateTime?;
                    if (weekStart != null) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          '${weekStart.month}/${weekStart.day}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.6),
                          ),
                        ),
                      );
                    }
                  }
                } catch (e) {
                  debugPrint('Error formatting date label: $e');
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

    // If AI insights haven't been requested yet, show a helpful message
    if (!_aiInsightsRequested) {
      return Column(
        children: [
          _buildAIInsightsHeader(theme),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                Icon(
                  Icons.psychology_outlined,
                  size: 64,
                  color: theme.colorScheme.primary.withValues(alpha: 0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  'Tap here to load AI insights',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'AI insights are loaded on-demand to save API usage',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _loadAIInsights,
                  icon: const Icon(Icons.psychology),
                  label: const Text('Load AI Insights'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    // Initialize the future if not already done
    _aiInsightsFuture ??=
        _enhancedInsightsService.generateComprehensiveInsights(habits);

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _aiInsightsFuture,
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

                // Advanced Analytics Charts Section
                _buildAdvancedAnalyticsSection(habits, theme),
                const SizedBox(height: 24),

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
    final action = insight['action'] as String?;
    final ctaLabel = insight['ctaLabel'] as String?;
    final habitId = insight['habitId'] as String?;

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
                  // Add CTA button if action and ctaLabel are provided
                  if (action != null && ctaLabel != null) ...[
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _handleInsightAction(action, habitId),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white.withValues(alpha: 0.2),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(
                              color: Colors.white.withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _getActionIcon(action),
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              ctaLabel,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
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
    final level = (data['level'] as int?) ?? 1;
    final xp = (data['xp'] as int?) ?? 0;
    final nextLevelXP = (data['nextLevelXP'] as int?) ?? 100;
    final progress = (data['levelProgress'] as num?)?.toDouble() ?? 0.0;
    final rank = (data['rank'] as String?) ?? 'Novice';

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
    final unlockedCount = (data['achievementsUnlocked'] as int?) ?? 0;
    final totalCount = (data['totalAchievements'] as int?) ?? 0;

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
              if (snapshot.hasError) {
                debugPrint('Error loading achievements: ${snapshot.error}');
              }
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

        if (snapshot.hasError) {
          debugPrint('Error loading achievements progress: ${snapshot.error}');
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Text(
                'Error loading progress',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ),
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
      case AchievementCategory.special:
        return '🏆';
    }
  }

  Future<Map<String, double>> _getAchievementsProgress() async {
    try {
      // Access the habit service through the provider
      final habitServiceAsync = ref.read(habitServiceIsarProvider);
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

  void _showAchievementNotification(Achievement achievement) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        content: Row(
          children: [
            Text(
              achievement.icon,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Achievement Unlocked!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                  Text(
                    '${achievement.title} (+${achievement.xpReward} XP)',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  /// Build Advanced Analytics Section for AI Insights Tab
  Widget _buildAdvancedAnalyticsSection(List<Habit> habits, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primaryContainer,
                theme.colorScheme.primaryContainer.withValues(alpha: 0.7),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Icon(
                Icons.analytics,
                color: theme.colorScheme.onPrimaryContainer,
                size: 28,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Advanced Analytics',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Deep insights into your habit patterns and consistency',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer
                            .withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Volatility Analysis
        _buildVolatilityAnalysisSection(habits, theme),

        const SizedBox(height: 24),

        // Time-of-Day Patterns
        _buildTimeOfDayPatternsSection(habits, theme),
      ],
    );
  }

  /// Build Volatility Analysis Section
  Widget _buildVolatilityAnalysisSection(List<Habit> habits, ThemeData theme) {
    final activeHabits = habits.where((h) => h.isActive).toList();
    final volatilityData = _generateVolatilityData(activeHabits);

    return Card(
      elevation: 4,
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
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.show_chart,
                    color: theme.colorScheme.onPrimaryContainer,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Habit Consistency Analysis',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Measures how consistent you are with each habit over time',
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
            const SizedBox(height: 16),

            // Explanatory text
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 20,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Understanding Consistency Scores',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Higher values indicate more inconsistent patterns (more volatile). Lower values show steady, consistent habit performance. This helps identify which habits need more attention to build consistency.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            if (volatilityData.isNotEmpty) ...[
              Row(
                children: [
                  // Y-axis label
                  RotatedBox(
                    quarterTurns: 3,
                    child: Text(
                      'Consistency Score',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.7),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: SizedBox(
                      height: 280,
                      child: _buildVolatilityChart(volatilityData, theme),
                    ),
                  ),
                ],
              ),
            ] else ...[
              Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.timeline_outlined,
                      size: 48,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Not enough data for consistency analysis',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Complete habits for at least 2 weeks to see this analysis',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
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

  /// Build Time-of-Day Patterns Section
  Widget _buildTimeOfDayPatternsSection(List<Habit> habits, ThemeData theme) {
    final activeHabits = habits.where((h) => h.isActive).toList();
    final timePatternData = _generateTimeOfDayPatternData(activeHabits);

    return Card(
      elevation: 4,
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
                    color: theme.colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.access_time,
                    color: theme.colorScheme.onSecondaryContainer,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Daily Activity Patterns',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Discover your most productive hours for habit completion',
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
            const SizedBox(height: 16),

            // Explanatory text
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.schedule,
                        size: 20,
                        color: theme.colorScheme.secondary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Your Peak Performance Hours',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'This heatmap shows when you\'re most likely to complete habits. Taller bars indicate higher activity. Use this to schedule new habits during your most productive hours.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            if (timePatternData.isNotEmpty) ...[
              SizedBox(
                height: 240,
                child: _buildTimeOfDayHeatmap(timePatternData, theme),
              ),
            ] else ...[
              Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.access_time_outlined,
                      size: 48,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Not enough completion data for time analysis',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Complete more habits to see your daily activity patterns',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
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

  /// Generate volatility data for charts
  List<Map<String, dynamic>> _generateVolatilityData(List<Habit> habits) {
    final data = <Map<String, dynamic>>[];

    for (final habit in habits) {
      if (habit.completions.length < 14) {
        continue; // Need at least 2 weeks of data
      }

      // Calculate weekly completion counts over last 8 weeks
      final now = DateTime.now();
      final weeklyData = <double>[];

      for (int i = 7; i >= 0; i--) {
        final weekStart = now.subtract(Duration(days: i * 7 + now.weekday - 1));
        final weekEnd = weekStart.add(const Duration(days: 6));

        final weekCompletions = habit.completions
            .where((c) =>
                c.isAfter(weekStart.subtract(const Duration(days: 1))) &&
                c.isBefore(weekEnd.add(const Duration(days: 1))))
            .length
            .toDouble();

        weeklyData.add(weekCompletions);
      }

      if (weeklyData.length >= 4) {
        // Calculate variance
        final mean = weeklyData.reduce((a, b) => a + b) / weeklyData.length;
        final variance = weeklyData
                .map((v) => (v - mean) * (v - mean))
                .reduce((a, b) => a + b) /
            weeklyData.length;

        data.add({
          'habitName': habit.name,
          'variance': variance,
          'mean': mean,
          'weeklyData': weeklyData,
        });
      }
    }

    // Sort by variance (highest first)
    data.sort(
        (a, b) => (b['variance'] as double).compareTo(a['variance'] as double));
    return data.take(10).toList(); // Show up to 10 habits for better overview
  }

  /// Generate time-of-day pattern data
  List<Map<String, dynamic>> _generateTimeOfDayPatternData(List<Habit> habits) {
    final hourlyCompletions = List.filled(24, 0);
    int totalCompletions = 0;

    for (final habit in habits) {
      for (final completion in habit.completions) {
        hourlyCompletions[completion.hour]++;
        totalCompletions++;
      }
    }

    if (totalCompletions == 0) return [];

    final data = <Map<String, dynamic>>[];
    for (int hour = 0; hour < 24; hour++) {
      final percentage = (hourlyCompletions[hour] / totalCompletions) * 100;
      data.add({
        'hour': hour,
        'completions': hourlyCompletions[hour],
        'percentage': percentage,
      });
    }

    return data;
  }

  /// Build volatility chart
  Widget _buildVolatilityChart(
      List<Map<String, dynamic>> data, ThemeData theme) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: data.isNotEmpty
            ? data
                    .map((d) => d['variance'] as double)
                    .reduce((a, b) => a > b ? a : b) *
                1.2
            : 1.0,
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() < data.length) {
                  final habitName = data[value.toInt()]['habitName'] as String;
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      habitName.length > 8
                          ? '${habitName.substring(0, 8)}...'
                          : habitName,
                      style: theme.textTheme.bodySmall,
                    ),
                  );
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 50,
              getTitlesWidget: (value, meta) {
                // Show cleaner labels with context
                if (value == 0) {
                  return Text('0', style: theme.textTheme.bodySmall);
                }
                if (value < 1) {
                  return Text(
                    value.toStringAsFixed(2),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  );
                }
                return Text(
                  value.toStringAsFixed(1),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                );
              },
            ),
          ),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        barGroups: data.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: item['variance'] as double,
                color: theme.colorScheme.primary,
                width: 16,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          );
        }).toList(),
        gridData: FlGridData(
          show: true,
          horizontalInterval: 1,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
              strokeWidth: 1,
            );
          },
        ),
        borderData: FlBorderData(show: false),
      ),
    );
  }

  /// Build time-of-day heatmap
  Widget _buildTimeOfDayHeatmap(
      List<Map<String, dynamic>> data, ThemeData theme) {
    final maxPercentage = data.isNotEmpty
        ? data
            .map((d) => d['percentage'] as double)
            .reduce((a, b) => a > b ? a : b)
        : 1.0;

    return Column(
      children: [
        // Hour labels with improved styling
        Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            children: List.generate(24, (hour) {
              final shouldShowLabel =
                  hour % 4 == 0; // Show every 4th hour for cleaner look
              return Expanded(
                child: Center(
                  child: shouldShowLabel
                      ? Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 4),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHighest
                                .withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            hour == 0
                                ? '12 AM'
                                : hour < 12
                                    ? '$hour AM'
                                    : hour == 12
                                        ? '12 PM'
                                        : '${hour - 12} PM',
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.8),
                            ),
                          ),
                        )
                      : const SizedBox(),
                ),
              );
            }),
          ),
        ),

        const SizedBox(height: 8),

        // Heatmap bars with improved styling
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: data.map((item) {
                final percentage = item['percentage'] as double;
                final intensity =
                    maxPercentage > 0 ? percentage / maxPercentage : 0.0;
                final hour = item['hour'] as int;

                return Expanded(
                  child: Container(
                    height: 140 * intensity,
                    margin: const EdgeInsets.symmetric(horizontal: 1.5),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          theme.colorScheme.primary.withValues(alpha: 0.8),
                          theme.colorScheme.primary
                              .withValues(alpha: 0.4 + (intensity * 0.4)),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: intensity > 0.3
                          ? [
                              BoxShadow(
                                color: theme.colorScheme.primary
                                    .withValues(alpha: 0.2),
                                blurRadius: 2,
                                offset: const Offset(0, 1),
                              ),
                            ]
                          : null,
                    ),
                    child: percentage >
                            3 // Show tooltip for hours with >3% activity
                        ? Tooltip(
                            message:
                                '${hour == 0 ? '12 AM' : hour < 12 ? '$hour AM' : hour == 12 ? '12 PM' : '${hour - 12} PM'}\n${percentage.toStringAsFixed(1)}% of completions',
                            child: const SizedBox.expand(),
                          )
                        : null,
                  ),
                );
              }).toList(),
            ),
          ),
        ),

        const SizedBox(height: 8),

        // Enhanced Legend
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest
                .withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.trending_down,
                size: 16,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              const SizedBox(width: 6),
              Text(
                'Low',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 60,
                height: 10,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary.withValues(alpha: 0.3),
                      theme.colorScheme.primary.withValues(alpha: 0.9),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'High',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 6),
              Icon(
                Icons.trending_up,
                size: 16,
                color: theme.colorScheme.primary,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Handle actions when CTA buttons are pressed
  void _handleInsightAction(String action, String? habitId) async {
    if (habitId == null) return;

    try {
      // Get the habit service and find the habit by ID
      final habitServiceAsync = ref.read(habitServiceIsarProvider);

      // Handle the AsyncValue properly
      await habitServiceAsync.when(
        data: (habitService) async {
          final habit = await habitService.getHabitById(habitId);

          if (habit == null) {
            // Show error message if habit not found
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Habit not found'),
                  backgroundColor: Colors.red,
                ),
              );
            }
            return;
          }

          switch (action) {
            case 'open_habit':
              _navigateToHabitDetail(habit);
              break;
            case 'adjust_reminder':
              _navigateToHabitDetail(
                  habit); // Edit screen also handles reminders
              break;
            default:
              // Unknown action, do nothing
              break;
          }
        },
        loading: () {
          // Show loading indicator
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Loading...'),
              ),
            );
          }
        },
        error: (error, stackTrace) {
          // Show error message
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error loading habit service: $error'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
      );
    } catch (e) {
      // Show error message if something goes wrong
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Navigate to habit detail screen for editing
  void _navigateToHabitDetail(Habit habit) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditHabitScreen(habit: habit),
      ),
    );
  }

  /// Get appropriate icon for the action type
  IconData _getActionIcon(String action) {
    switch (action) {
      case 'open_habit':
        return Icons.edit;
      case 'adjust_reminder':
        return Icons.schedule;
      default:
        return Icons.touch_app;
    }
  }

  /// Build backup analysis when AI is not available
  Widget _buildBackupAnalysis(List<Habit> habits, ThemeData theme) {
    // Use rule-based insights from the insights service
    final allInsights = _insightsService.generateAIInsights(habits);

    // Filter out insights with CTA actions when AI is disabled
    // Only show basic pattern insights without actionable recommendations
    final ruleBasedInsights = allInsights.where((insight) {
      final action = insight['action'] as String?;
      final ctaLabel = insight['ctaLabel'] as String?;
      // Only include insights that don't have actionable CTAs
      return action == null && ctaLabel == null;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header showing this is backup analysis
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.insights,
                color: theme.colorScheme.secondary,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Smart Insights',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Pattern-based insights and recommendations',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Show rule-based insights (without CTA actions)
        if (ruleBasedInsights.isNotEmpty) ...[
          ...ruleBasedInsights.asMap().entries.map((entry) {
            final index = entry.key;
            final insight = entry.value;

            return Padding(
              padding: EdgeInsets.only(
                  bottom: index < ruleBasedInsights.length - 1 ? 16 : 0),
              child: SmoothTransitions.slideTransition(
                show: true,
                duration: Duration(milliseconds: 600 + (index * 200)),
                child: _buildInsightCard(insight, theme),
              ),
            );
          }),
        ] else ...[
          // Empty state for rule-based insights
          Container(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                Icon(
                  Icons.insights_outlined,
                  size: 64,
                  color: theme.colorScheme.secondary.withValues(alpha: 0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  'Build more habits to unlock insights',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.secondary,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Start tracking habits consistently to discover patterns and receive personalized recommendations',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
