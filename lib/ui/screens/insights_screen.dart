import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../data/database.dart';
import '../../domain/model/habit.dart';
import '../../services/insights_service.dart';
import '../widgets/smooth_transitions.dart';

class InsightsScreen extends ConsumerStatefulWidget {
  const InsightsScreen({super.key});

  @override
  ConsumerState<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends ConsumerState<InsightsScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  final InsightsService _insightsService = InsightsService();

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

    // Start animations
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
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
                    child: SingleChildScrollView(
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

                          const SizedBox(height: 32),

                          // AI Insights Section
                          _buildAIInsights(habits, theme),

                          const SizedBox(height: 24),
                        ],
                      ),
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
    final insights = _insightsService.generateAIInsights(habits);

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
          Row(
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
                      'AI-Powered Insights',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Personalized recommendations and discoveries',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ...insights.asMap().entries.map((entry) {
            final index = entry.key;
            final insight = entry.value;

            return Padding(
              padding:
                  EdgeInsets.only(bottom: index < insights.length - 1 ? 16 : 0),
              child: SmoothTransitions.slideTransition(
                show: true,
                duration: Duration(milliseconds: 600 + (index * 200)),
                child: _buildInsightCard(insight, theme),
              ),
            );
          }),
          if (insights.isEmpty) _buildEmptyInsightsCard(theme),
        ],
      ),
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

  Widget _buildEmptyInsightsCard(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.lightbulb_outline,
            size: 64,
            color: theme.colorScheme.primary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Building Your Insights',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Keep tracking your habits and we\'ll start generating personalized insights and recommendations for you!',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
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
}
