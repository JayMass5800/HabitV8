import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../data/database_isar.dart';
import '../../domain/model/habit.dart';
import '../widgets/smooth_transitions.dart';
import '../widgets/progressive_disclosure.dart';

class StatsScreen extends ConsumerStatefulWidget {
  const StatsScreen({super.key});

  @override
  ConsumerState<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends ConsumerState<StatsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
        title: const Text('Statistics'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Weekly'),
            Tab(text: 'Monthly'),
            Tab(text: 'Yearly'),
          ],
        ),
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final habitServiceAsync = ref.watch(habitServiceIsarProvider);

          return habitServiceAsync.when(
            data: (habitService) => FutureBuilder<List<Habit>>(
              future: habitService.getAllHabits(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.analytics, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'No habit data yet',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Start completing habits to see your progress!',
                          style: TextStyle(color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                final habits = snapshot.data!;
                final hasData = habits.any(
                  (habit) => habit.completions.isNotEmpty,
                );

                if (!hasData) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.insights, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'Complete some habits to see statistics',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Your progress charts will appear here once you start tracking!',
                          style: TextStyle(color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                return TabBarView(
                  controller: _tabController,
                  children: [
                    _buildWeeklyStats(habits),
                    _buildMonthlyStats(habits),
                    _buildYearlyStats(habits),
                  ],
                );
              },
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(child: Text('Error: $error')),
          );
        },
      ),
    );
  }

  Widget _buildWeeklyStats(List<Habit> habits) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMotivationalHeader(
            'This Week\'s Progress',
            'You\'re building amazing habits! Keep up the great work! 🌟',
          ),
          const SizedBox(height: 24),
          _buildWeeklyCompletionChart(habits),
          const SizedBox(height: 24),
          _buildCategoryBreakdown(habits, 'week'),
          const SizedBox(height: 24),
          _buildHabitPerformanceRanking(habits, 'week'),
        ],
      ),
    );
  }

  Widget _buildMonthlyStats(List<Habit> habits) {
    final hasEnoughData = _hasEnoughDataForPeriod(habits, 14);

    if (!hasEnoughData) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_month, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Monthly Report Coming Soon!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Build two weeks of habit data to unlock your monthly insights.',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Icon(Icons.lock_outline, size: 32, color: Colors.grey),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMotivationalHeader(
            'Monthly Overview',
            'Your consistency is paying off! Look at those beautiful patterns! 📈',
          ),
          const SizedBox(height: 24),
          _buildMonthlyHeatmap(habits),
          const SizedBox(height: 24),
          _buildMonthlyCategoryTrendChart(habits),
          const SizedBox(height: 24),
          _buildHabitPerformanceRanking(habits, 'month'),
        ],
      ),
    );
  }

  Widget _buildYearlyStats(List<Habit> habits) {
    final hasEnoughData = _hasEnoughDataForPeriod(
      habits,
      60,
    ); // Changed from 90 to 60 days (2 months)

    if (!hasEnoughData) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_today, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Yearly Report Coming Soon!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Build two months of habit data to unlock your yearly insights.',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Icon(Icons.lock_outline, size: 32, color: Colors.grey),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMotivationalHeader(
            'Yearly Journey',
            'Incredible transformation! You\'ve built lasting habits! 🏆',
          ),
          const SizedBox(height: 24),
          _buildYearlyOverviewCards(habits),
          const SizedBox(height: 24),
          _buildYearlyTrendChart(habits),
          const SizedBox(height: 24),
          _buildYearlyCategoryAnalysis(habits),
          const SizedBox(height: 24),
          _buildYearlyConsistencyHeatmap(habits),
          const SizedBox(height: 24),
          _buildYearlyMilestones(habits),
          const SizedBox(height: 24),
          _buildHabitPerformanceRanking(habits, 'year'),
        ],
      ),
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

  Widget _buildWeeklyCompletionChart(List<Habit> habits) {
    final weekData = _getWeeklyCompletionData(habits);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Daily Completions This Week',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: weekData.values.isNotEmpty
                      ? weekData.values
                                .reduce((a, b) => a > b ? a : b)
                                .toDouble() +
                            2
                      : 10,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const days = [
                            'Mon',
                            'Tue',
                            'Wed',
                            'Thu',
                            'Fri',
                            'Sat',
                            'Sun',
                          ];
                          if (value.toInt() >= 0 &&
                              value.toInt() < days.length) {
                            return Text(days[value.toInt()]);
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          return Text(value.toInt().toString());
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: List.generate(7, (index) {
                    final dayName = [
                      'Monday',
                      'Tuesday',
                      'Wednesday',
                      'Thursday',
                      'Friday',
                      'Saturday',
                      'Sunday',
                    ][index];
                    final completions = weekData[dayName] ?? 0;
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: completions.toDouble(),
                          color: Colors.blue.shade400,
                          width: 20,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthlyHeatmap(List<Habit> habits) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Monthly Activity Heatmap',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildHeatmapGrid(habits),
          ],
        ),
      ),
    );
  }

  Widget _buildHeatmapGrid(List<Habit> habits) {
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: lastDayOfMonth.day,
      itemBuilder: (context, index) {
        final day = firstDayOfMonth.add(Duration(days: index));
        final completions = _getCompletionsForDate(habits, day);
        final intensity = completions / (habits.length + 1);

        return Container(
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: intensity.clamp(0.1, 1.0)),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: Text(
              '${day.day}',
              style: TextStyle(
                color: intensity > 0.5 ? Colors.white : Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildYearlyTrendChart(List<Habit> habits) {
    final monthlyData = _getMonthlyTrendData(habits);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Yearly Completion Trend',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: true),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const months = [
                            'Jan',
                            'Feb',
                            'Mar',
                            'Apr',
                            'May',
                            'Jun',
                            'Jul',
                            'Aug',
                            'Sep',
                            'Oct',
                            'Nov',
                            'Dec',
                          ];
                          if (value.toInt() >= 0 &&
                              value.toInt() < months.length) {
                            return Text(months[value.toInt()]);
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(value.toInt().toString());
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: monthlyData.asMap().entries.map((entry) {
                        return FlSpot(
                          entry.key.toDouble(),
                          entry.value.toDouble(),
                        );
                      }).toList(),
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 3,
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.blue.withValues(alpha: 0.3),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthlyCategoryTrendChart(List<Habit> habits) {
    final categoryTrendData = _getMonthlyCategoryTrendData(habits);
    final categories = categoryTrendData.keys.toList();
    final colors = [
      Colors.blue.shade400,
      Colors.green.shade400,
      Colors.orange.shade400,
      Colors.purple.shade400,
      Colors.red.shade400,
      Colors.teal.shade400,
      Colors.indigo.shade400,
      Colors.pink.shade400,
    ];

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.trending_up,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Monthly Category Performance',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Track how each habit category performs throughout the month',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 250,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    horizontalInterval: 1,
                    verticalInterval: 5,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey.shade300,
                        strokeWidth: 0.5,
                      );
                    },
                    getDrawingVerticalLine: (value) {
                      return FlLine(
                        color: Colors.grey.shade300,
                        strokeWidth: 0.5,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: 5,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() % 5 == 0 && value.toInt() <= 31) {
                            return Text(
                              value.toInt().toString(),
                              style: const TextStyle(fontSize: 12),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(fontSize: 12),
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  lineBarsData: categories.asMap().entries.map((entry) {
                    final categoryIndex = entry.key;
                    final category = entry.value;
                    final data = categoryTrendData[category]!;

                    return LineChartBarData(
                      spots: data.asMap().entries.map((dayEntry) {
                        return FlSpot(
                          dayEntry.key.toDouble() + 1,
                          dayEntry.value.toDouble(),
                        );
                      }).toList(),
                      isCurved: true,
                      color: colors[categoryIndex % colors.length],
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 3,
                            color: colors[categoryIndex % colors.length],
                            strokeWidth: 1,
                            strokeColor: Colors.white,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        color: colors[categoryIndex % colors.length].withValues(
                          alpha: 0.1,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Legend
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: categories.asMap().entries.map((entry) {
                final categoryIndex = entry.key;
                final category = entry.value;
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: colors[categoryIndex % colors.length],
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(category, style: const TextStyle(fontSize: 12)),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildYearlyCategoryAnalysis(List<Habit> habits) {
    final yearlyData = _getYearlyCategoryData(habits);
    final categories = yearlyData.keys.toList();
    final colors = [
      Colors.blue.shade400,
      Colors.green.shade400,
      Colors.orange.shade400,
      Colors.purple.shade400,
      Colors.red.shade400,
      Colors.teal.shade400,
      Colors.indigo.shade400,
      Colors.pink.shade400,
    ];

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.analytics,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Yearly Category Evolution',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'See how your habit categories have evolved throughout the year',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 280,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    horizontalInterval: 5,
                    verticalInterval: 1,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey.shade300,
                        strokeWidth: 0.5,
                      );
                    },
                    getDrawingVerticalLine: (value) {
                      return FlLine(
                        color: Colors.grey.shade300,
                        strokeWidth: 0.5,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          const months = [
                            'Jan',
                            'Feb',
                            'Mar',
                            'Apr',
                            'May',
                            'Jun',
                            'Jul',
                            'Aug',
                            'Sep',
                            'Oct',
                            'Nov',
                            'Dec',
                          ];
                          if (value.toInt() >= 0 &&
                              value.toInt() < months.length) {
                            return Text(
                              months[value.toInt()],
                              style: const TextStyle(fontSize: 11),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(fontSize: 12),
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  lineBarsData: categories.asMap().entries.map((entry) {
                    final categoryIndex = entry.key;
                    final category = entry.value;
                    final data = yearlyData[category]!;

                    return LineChartBarData(
                      spots: data.asMap().entries.map((monthEntry) {
                        return FlSpot(
                          monthEntry.key.toDouble(),
                          monthEntry.value.toDouble(),
                        );
                      }).toList(),
                      isCurved: true,
                      color: colors[categoryIndex % colors.length],
                      barWidth: 4,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: colors[categoryIndex % colors.length],
                            strokeWidth: 2,
                            strokeColor: Colors.white,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        color: colors[categoryIndex % colors.length].withValues(
                          alpha: 0.15,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Legend with stats
            Column(
              children: categories.asMap().entries.map((entry) {
                final categoryIndex = entry.key;
                final category = entry.value;
                final totalCompletions = yearlyData[category]!.fold(
                  0,
                  (sum, value) => sum + value,
                );
                final avgPerMonth = totalCompletions / 12;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: colors[categoryIndex % colors.length],
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          category,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Text(
                        '$totalCompletions total',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${avgPerMonth.toStringAsFixed(1)}/mo avg',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryBreakdown(List<Habit> habits, String period) {
    final categoryData = _getCategoryData(habits, period);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Category Breakdown',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: categoryData.entries.map((entry) {
                    final colors = [
                      Colors.blue,
                      Colors.green,
                      Colors.orange,
                      Colors.purple,
                      Colors.red,
                      Colors.teal,
                    ];
                    final colorIndex =
                        categoryData.keys.toList().indexOf(entry.key) %
                        colors.length;

                    return PieChartSectionData(
                      value: entry.value.toDouble(),
                      title: '${entry.key}\n${entry.value}',
                      color: colors[colorIndex],
                      radius: 60,
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  }).toList(),
                  centerSpaceRadius: 40,
                  sectionsSpace: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHabitPerformanceRanking(List<Habit> habits, String period) {
    final rankedHabits = _getRankedHabits(habits, period);

    return ProgressiveDisclosure(
      title: 'Habit Performance Ranking',
      subtitle: 'View detailed performance metrics for all habits',
      summary: Column(
        children: rankedHabits.take(3).map((habitData) {
          final habit = habitData['habit'] as Habit;
          final rate = habitData['rate'] as double;

          return SmoothTransitions.slideTransition(
            show: true,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Container(
                    width: 6,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Color(habit.colorValue),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          habit.name,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          '${(rate * 100).toInt()}% success rate',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getCompletionRateColor(
                        rate,
                      ).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${(rate * 100).toInt()}%',
                      style: TextStyle(
                        color: _getCompletionRateColor(rate),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
      details: Column(
        children: rankedHabits.map((habitData) {
          final habit = habitData['habit'] as Habit;
          final completions = habitData['completions'] as int;
          final rate = habitData['rate'] as double;

          return HabitStatsDisclosure(
            habitName: habit.name,
            currentStreak: habit.currentStreak,
            completionRate: rate,
            recentCompletions: habit.completions,
            detailedStats: {
              'totalCompletions': completions,
              'bestStreak': habit.longestStreak,
              'averagePerWeek': (completions / 4).toStringAsFixed(1),
              'lastCompleted': habit.completions.isNotEmpty
                  ? DateFormat('MMM d, y').format(habit.completions.last)
                  : 'Never',
            },
          );
        }).toList(),
      ),
    );
  }

  // Helper methods for data processing
  bool _hasEnoughDataForPeriod(List<Habit> habits, int minDays) {
    final now = DateTime.now();
    final cutoffDate = now.subtract(Duration(days: minDays));

    return habits.any(
      (habit) =>
          habit.completions.any((completion) => completion.isAfter(cutoffDate)),
    );
  }

  Map<String, int> _getWeeklyCompletionData(List<Habit> habits) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final data = <String, int>{};

    for (int i = 0; i < 7; i++) {
      final day = startOfWeek.add(Duration(days: i));
      final dayName = DateFormat('EEEE').format(day);
      data[dayName] = _getCompletionsForDate(habits, day);
    }

    return data;
  }

  int _getCompletionsForDate(List<Habit> habits, DateTime date) {
    final dateOnly = DateTime(date.year, date.month, date.day);
    int count = 0;

    for (final habit in habits) {
      for (final completion in habit.completions) {
        final completionDate = DateTime(
          completion.year,
          completion.month,
          completion.day,
        );
        if (completionDate == dateOnly) {
          count++;
        }
      }
    }

    return count;
  }

  Map<String, int> _getCategoryData(List<Habit> habits, String period) {
    final data = <String, int>{};

    for (final habit in habits) {
      final completions = _getCompletionsForPeriod(habit, period);
      data[habit.category] = (data[habit.category] ?? 0) + completions;
    }

    return data;
  }

  int _getCompletionsForPeriod(Habit habit, String period) {
    final now = DateTime.now();
    DateTime startDate;

    switch (period) {
      case 'week':
        startDate = now.subtract(const Duration(days: 7));
        break;
      case 'month':
        startDate = DateTime(now.year, now.month, 1);
        break;
      case 'year':
        startDate = DateTime(now.year, 1, 1);
        break;
      default:
        startDate = now.subtract(const Duration(days: 7));
    }

    return habit.completions
        .where(
          (completion) =>
              completion.isAfter(startDate) &&
              completion.isBefore(now.add(const Duration(days: 1))),
        )
        .length;
  }

  List<Map<String, dynamic>> _getRankedHabits(
    List<Habit> habits,
    String period,
  ) {
    final rankedData = habits.map((habit) {
      final completions = _getCompletionsForPeriod(habit, period);
      final expectedCompletions = _getExpectedCompletionsForPeriod(
        habit,
        period,
      );
      final rate = expectedCompletions > 0
          ? completions / expectedCompletions
          : 0.0;

      return {
        'habit': habit,
        'completions': completions,
        'rate': rate.clamp(0.0, 1.0),
      };
    }).toList();

    rankedData.sort(
      (a, b) => (b['rate'] as double).compareTo(a['rate'] as double),
    );
    return rankedData;
  }

  int _getExpectedCompletionsForPeriod(Habit habit, String period) {
    final now = DateTime.now();
    int days;

    switch (period) {
      case 'week':
        days = 7;
        break;
      case 'month':
        days = now.day;
        break;
      case 'year':
        days = DateTime.now().difference(DateTime(now.year, 1, 1)).inDays + 1;
        break;
      default:
        days = 7;
    }

    switch (habit.frequency) {
      case HabitFrequency.daily:
        return days;
      case HabitFrequency.weekly:
        final weeklyDays = habit.selectedWeekdays.isNotEmpty
            ? habit.selectedWeekdays.length
            : habit.weeklySchedule.length;
        return (days / 7).ceil() * weeklyDays;
      case HabitFrequency.monthly:
        final monthlyDays = habit.selectedMonthDays.isNotEmpty
            ? habit.selectedMonthDays.length
            : habit.monthlySchedule.length;
        return (days / 30).ceil() * monthlyDays;
      default:
        return days;
    }
  }

  List<int> _getMonthlyTrendData(List<Habit> habits) {
    final now = DateTime.now();
    final data = <int>[];

    for (int month = 1; month <= 12; month++) {
      if (month > now.month) {
        data.add(0);
        continue;
      }

      int monthCompletions = 0;
      for (final habit in habits) {
        monthCompletions += habit.completions
            .where(
              (completion) =>
                  completion.year == now.year && completion.month == month,
            )
            .length;
      }
      data.add(monthCompletions);
    }

    return data;
  }

  Color _getCompletionRateColor(double rate) {
    if (rate >= 0.8) return Colors.green;
    if (rate >= 0.6) return Colors.orange;
    return Colors.red;
  }

  Widget _buildYearlyOverviewCards(List<Habit> habits) {
    final yearlyStats = _getYearlyOverviewStats(habits);

    return Row(
      children: [
        Expanded(
          child: _buildOverviewCard(
            'Total Completions',
            yearlyStats['totalCompletions'].toString(),
            Icons.check_circle,
            Colors.green.shade400,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildOverviewCard(
            'Best Month',
            yearlyStats['bestMonth'],
            Icons.star,
            Colors.amber.shade400,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildOverviewCard(
            'Consistency',
            '${yearlyStats['consistencyRate']}%',
            Icons.trending_up,
            Colors.blue.shade400,
          ),
        ),
      ],
    );
  }

  Widget _buildOverviewCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildYearlyConsistencyHeatmap(List<Habit> habits) {
    final heatmapData = _getYearlyHeatmapData(habits);

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.calendar_view_week,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Yearly Consistency Heatmap',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Visual representation of your daily habit completions throughout the year',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 53, // 53 weeks in a year
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 2,
                ),
                itemCount: heatmapData.length,
                itemBuilder: (context, index) {
                  final intensity = heatmapData[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: _getHeatmapColor(intensity),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Less',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Row(
                  children: List.generate(5, (index) {
                    return Container(
                      margin: const EdgeInsets.only(left: 2),
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: _getHeatmapColor(index / 4),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    );
                  }),
                ),
                const Text(
                  'More',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildYearlyMilestones(List<Habit> habits) {
    final milestones = _getYearlyMilestones(habits);

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.emoji_events,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Yearly Milestones & Achievements',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Celebrate your major accomplishments this year',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 20),
            ...milestones.map(
              (milestone) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: milestone['color'].withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        milestone['icon'],
                        color: milestone['color'],
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            milestone['title'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            milestone['description'],
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: milestone['color'],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        milestone['value'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, List<int>> _getMonthlyCategoryTrendData(List<Habit> habits) {
    final now = DateTime.now();
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
    final daysInMonth = lastDayOfMonth.day;

    final categoryData = <String, List<int>>{};

    // Initialize categories with empty data
    for (final habit in habits) {
      if (!categoryData.containsKey(habit.category)) {
        categoryData[habit.category] = List.filled(daysInMonth, 0);
      }
    }

    // Fill in the completion data for each day
    for (int day = 1; day <= daysInMonth; day++) {
      final currentDate = DateTime(now.year, now.month, day);

      for (final habit in habits) {
        final completionsForDay = habit.completions.where((completion) {
          final completionDate = DateTime(
            completion.year,
            completion.month,
            completion.day,
          );
          return completionDate == currentDate;
        }).length;

        if (categoryData.containsKey(habit.category)) {
          categoryData[habit.category]![day - 1] += completionsForDay;
        }
      }
    }

    // Remove categories with no data
    categoryData.removeWhere(
      (key, value) => value.every((element) => element == 0),
    );

    return categoryData;
  }

  Map<String, List<int>> _getYearlyCategoryData(List<Habit> habits) {
    final now = DateTime.now();
    final categoryData = <String, List<int>>{};

    // Initialize categories with empty data for 12 months
    for (final habit in habits) {
      if (!categoryData.containsKey(habit.category)) {
        categoryData[habit.category] = List.filled(12, 0);
      }
    }

    // Fill in the completion data for each month
    for (int month = 1; month <= 12; month++) {
      for (final habit in habits) {
        final completionsForMonth = habit.completions
            .where(
              (completion) =>
                  completion.year == now.year && completion.month == month,
            )
            .length;

        if (categoryData.containsKey(habit.category)) {
          categoryData[habit.category]![month - 1] += completionsForMonth;
        }
      }
    }

    // Remove categories with no data
    categoryData.removeWhere(
      (key, value) => value.every((element) => element == 0),
    );

    return categoryData;
  }

  Map<String, dynamic> _getYearlyOverviewStats(List<Habit> habits) {
    final now = DateTime.now();
    int totalCompletions = 0;
    final monthlyCompletions = <int, int>{};
    int daysWithCompletions = 0;
    final completedDays = <String>{};

    for (final habit in habits) {
      for (final completion in habit.completions) {
        if (completion.year == now.year) {
          totalCompletions++;
          monthlyCompletions[completion.month] =
              (monthlyCompletions[completion.month] ?? 0) + 1;
          completedDays.add(
            '${completion.year}-${completion.month}-${completion.day}',
          );
        }
      }
    }

    daysWithCompletions = completedDays.length;
    final daysSoFar = now.difference(DateTime(now.year, 1, 1)).inDays + 1;
    final consistencyRate = daysSoFar > 0
        ? ((daysWithCompletions / daysSoFar) * 100).round()
        : 0;

    String bestMonth = 'N/A';
    if (monthlyCompletions.isNotEmpty) {
      final bestMonthNum = monthlyCompletions.entries
          .reduce((a, b) => a.value > b.value ? a : b)
          .key;
      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      bestMonth = months[bestMonthNum - 1];
    }

    return {
      'totalCompletions': totalCompletions,
      'bestMonth': bestMonth,
      'consistencyRate': consistencyRate,
    };
  }

  List<double> _getYearlyHeatmapData(List<Habit> habits) {
    final now = DateTime.now();
    final startOfYear = DateTime(now.year, 1, 1);
    final daysSoFar = now.difference(startOfYear).inDays + 1;
    final heatmapData = <double>[];

    for (int i = 0; i < daysSoFar; i++) {
      final currentDate = startOfYear.add(Duration(days: i));
      int completionsForDay = 0;

      for (final habit in habits) {
        completionsForDay += habit.completions.where((completion) {
          final completionDate = DateTime(
            completion.year,
            completion.month,
            completion.day,
          );
          return completionDate ==
              DateTime(currentDate.year, currentDate.month, currentDate.day);
        }).length;
      }

      // Normalize intensity (0.0 to 1.0)
      final maxPossibleCompletions = habits.length;
      final intensity = maxPossibleCompletions > 0
          ? completionsForDay / maxPossibleCompletions
          : 0.0;
      heatmapData.add(intensity.clamp(0.0, 1.0));
    }

    // Fill remaining days of the year with 0
    final totalDaysInYear = DateTime(
      now.year + 1,
      1,
      1,
    ).difference(startOfYear).inDays;
    while (heatmapData.length < totalDaysInYear) {
      heatmapData.add(0.0);
    }

    return heatmapData;
  }

  Color _getHeatmapColor(double intensity) {
    if (intensity == 0) return Colors.grey.shade200;
    if (intensity <= 0.25) return Colors.green.shade200;
    if (intensity <= 0.5) return Colors.green.shade400;
    if (intensity <= 0.75) return Colors.green.shade600;
    return Colors.green.shade800;
  }

  List<Map<String, dynamic>> _getYearlyMilestones(List<Habit> habits) {
    final now = DateTime.now();
    final milestones = <Map<String, dynamic>>[];

    // Calculate various milestone metrics
    int totalCompletions = 0;
    int longestStreak = 0;

    final habitCompletions = <String, int>{};
    final monthlyCompletions = <int, int>{};

    for (final habit in habits) {
      int habitTotal = 0;
      for (final completion in habit.completions) {
        if (completion.year == now.year) {
          totalCompletions++;
          habitTotal++;
          monthlyCompletions[completion.month] =
              (monthlyCompletions[completion.month] ?? 0) + 1;
        }
      }
      habitCompletions[habit.name] = habitTotal;
    }

    // Calculate streaks (simplified)
    final sortedDates = <DateTime>[];
    for (final habit in habits) {
      for (final completion in habit.completions) {
        if (completion.year == now.year) {
          sortedDates.add(
            DateTime(completion.year, completion.month, completion.day),
          );
        }
      }
    }
    sortedDates.sort();

    if (sortedDates.isNotEmpty) {
      int tempStreak = 1;

      for (int i = 1; i < sortedDates.length; i++) {
        if (sortedDates[i].difference(sortedDates[i - 1]).inDays == 1) {
          tempStreak++;
        } else {
          longestStreak = longestStreak > tempStreak
              ? longestStreak
              : tempStreak;
          tempStreak = 1;
        }
      }
      longestStreak = longestStreak > tempStreak ? longestStreak : tempStreak;
    }

    // Add milestones
    if (totalCompletions >= 100) {
      milestones.add({
        'title': 'Century Club',
        'description': 'Completed over 100 habits this year!',
        'value': totalCompletions.toString(),
        'icon': Icons.military_tech,
        'color': Colors.amber.shade600,
      });
    }

    if (longestStreak >= 7) {
      milestones.add({
        'title': 'Streak Master',
        'description': 'Maintained your longest streak',
        'value': '${longestStreak}d',
        'icon': Icons.local_fire_department,
        'color': Colors.orange.shade600,
      });
    }

    if (monthlyCompletions.isNotEmpty) {
      final bestMonth = monthlyCompletions.entries.reduce(
        (a, b) => a.value > b.value ? a : b,
      );
      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      milestones.add({
        'title': 'Peak Performance',
        'description':
            'Your most productive month was ${months[bestMonth.key - 1]}',
        'value': bestMonth.value.toString(),
        'icon': Icons.trending_up,
        'color': Colors.blue.shade600,
      });
    }

    if (habits.length >= 5) {
      milestones.add({
        'title': 'Habit Collector',
        'description': 'Tracking multiple habits simultaneously',
        'value': '${habits.length}',
        'icon': Icons.collections,
        'color': Colors.purple.shade600,
      });
    }

    // If no significant milestones, add encouraging ones
    if (milestones.isEmpty) {
      milestones.add({
        'title': 'Getting Started',
        'description': 'Every journey begins with a single step',
        'value': totalCompletions.toString(),
        'icon': Icons.rocket_launch,
        'color': Colors.green.shade600,
      });
    }

    return milestones;
  }
}
