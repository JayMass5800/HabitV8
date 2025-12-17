import 'dart:math';
import 'logging_service.dart';

class TrendAnalysisService {
  static const int _minimumDaysForTrend = 7; // Require a full week of data

  /// Analyze habit trends only if sufficient data exists
  static Future<Map<String, dynamic>> analyzeHabitTrends({
    required List<Map<String, dynamic>> habits,
    required List<Map<String, dynamic>> completions,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final analysisEndDate = endDate ?? DateTime.now();
    final analysisStartDate = startDate ?? analysisEndDate.subtract(const Duration(days: 30));

    // Check if we have at least a week of data
    final daysDifference = analysisEndDate.difference(analysisStartDate).inDays;

    if (daysDifference < _minimumDaysForTrend) {
      return {
        'hasEnoughData': false,
        'message': 'Trends will be available after $_minimumDaysForTrend days of habit tracking',
        'daysUntilTrends': _minimumDaysForTrend - daysDifference,
        'minimumDays': _minimumDaysForTrend,
      };
    }

    final Map<String, dynamic> trends = {
      'hasEnoughData': true,
      'analysisStartDate': analysisStartDate,
      'analysisEndDate': analysisEndDate,
      'totalDaysAnalyzed': daysDifference,
      'habitTrends': <String, Map<String, dynamic>>{},
      'overallTrends': <String, dynamic>{},
      'weeklyPatterns': <String, dynamic>{},
      'monthlyPatterns': <String, dynamic>{},
      'insights': <String>[],
      'recommendations': <String>[],
    };

    try {
      // Analyze individual habit trends
      for (final habit in habits) {
        final habitId = habit['id']?.toString();
        if (habitId == null) continue;

        final habitCompletions = completions
            .where((c) => c['habitId'] == habitId)
            .where((c) => _isDateInRange(c['completedAt'], analysisStartDate, analysisEndDate))
            .toList();

        if (habitCompletions.length >= _minimumDaysForTrend) {
          trends['habitTrends'][habitId] = _analyzeIndividualHabitTrend(
            habit, habitCompletions, analysisStartDate, analysisEndDate);
        }
      }

      // Analyze overall trends
      trends['overallTrends'] = _analyzeOverallTrends(habits, completions, analysisStartDate, analysisEndDate);

      // Analyze weekly patterns
      trends['weeklyPatterns'] = _analyzeWeeklyPatterns(completions, analysisStartDate, analysisEndDate);

      // Analyze monthly patterns (if we have enough data)
      if (daysDifference >= 30) {
        trends['monthlyPatterns'] = _analyzeMonthlyPatterns(completions, analysisStartDate, analysisEndDate);
      }

      // Generate insights and recommendations
      final insights = _generateInsights(trends);
      trends['insights'] = insights['insights'];
      trends['recommendations'] = insights['recommendations'];

      AppLogger.info('Trend analysis completed for ${habits.length} habits over $daysDifference days');

    } catch (e) {
      AppLogger.error('Error during trend analysis', e);
      trends['error'] = 'Failed to analyze trends: ${e.toString()}';
    }

    return trends;
  }

  /// Check if user has enough data for trend analysis
  static bool hasEnoughDataForTrends(List<Map<String, dynamic>> completions) {
    if (completions.isEmpty) return false;

    final sortedCompletions = completions
        .where((c) => c['completedAt'] != null)
        .map((c) => c['completedAt'] as DateTime)
        .toList()
      ..sort();

    if (sortedCompletions.isEmpty) return false;

    final daysDifference = sortedCompletions.last.difference(sortedCompletions.first).inDays;
    return daysDifference >= _minimumDaysForTrend;
  }

  /// Get the minimum date when trends will be available
  static DateTime? getMinimumDateForTrends(List<Map<String, dynamic>> completions) {
    if (completions.isEmpty) return null;

    final sortedCompletions = completions
        .where((c) => c['completedAt'] != null)
        .map((c) => c['completedAt'] as DateTime)
        .toList()
      ..sort();

    if (sortedCompletions.isEmpty) return null;

    return sortedCompletions.first.add(Duration(days: _minimumDaysForTrend));
  }

  /// Analyze individual habit trend
  static Map<String, dynamic> _analyzeIndividualHabitTrend(
    Map<String, dynamic> habit,
    List<Map<String, dynamic>> completions,
    DateTime startDate,
    DateTime endDate,
  ) {
    final habitName = habit['name']?.toString() ?? 'Unknown Habit';
    final dailyCompletions = _groupCompletionsByDay(completions);

    // Calculate daily completion rates
    final completionRates = <double>[];
    final currentDate = DateTime(startDate.year, startDate.month, startDate.day);
    final analysisEndDate = DateTime(endDate.year, endDate.month, endDate.day);

    DateTime date = currentDate;
    while (date.isBefore(analysisEndDate) || date.isAtSameMomentAs(analysisEndDate)) {
      final dateKey = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      final completionCount = dailyCompletions[dateKey] ?? 0;
      completionRates.add(completionCount > 0 ? 1.0 : 0.0);
      date = date.add(const Duration(days: 1));
    }

    if (completionRates.length < 2) {
      return {
        'habitName': habitName,
        'trend': 'insufficient_data',
        'direction': 'neutral',
        'strength': 0.0,
        'message': 'Not enough data for trend analysis',
      };
    }

    // Calculate trend using linear regression
    final trendData = _calculateLinearTrend(completionRates);
    final weeklyAverage = _calculateWeeklyAverages(completionRates);

    return {
      'habitName': habitName,
      'trend': trendData['trend'],
      'direction': trendData['direction'],
      'strength': trendData['strength'],
      'slope': trendData['slope'],
      'currentStreak': habit['currentStreak'] ?? 0,
      'weeklyAverages': weeklyAverage,
      'totalCompletions': completions.length,
      'completionRate': completionRates.where((r) => r > 0).length / completionRates.length,
      'message': _generateTrendMessage(trendData, habitName),
    };
  }

  /// Analyze overall trends across all habits
  static Map<String, dynamic> _analyzeOverallTrends(
    List<Map<String, dynamic>> habits,
    List<Map<String, dynamic>> completions,
    DateTime startDate,
    DateTime endDate,
  ) {
    final dailyCompletions = _groupCompletionsByDay(completions);
    final dailyTotals = <double>[];

    DateTime date = DateTime(startDate.year, startDate.month, startDate.day);
    final analysisEndDate = DateTime(endDate.year, endDate.month, endDate.day);

    while (date.isBefore(analysisEndDate) || date.isAtSameMomentAs(analysisEndDate)) {
      final dateKey = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      final totalCompletions = dailyCompletions[dateKey] ?? 0;
      dailyTotals.add(totalCompletions.toDouble());
      date = date.add(const Duration(days: 1));
    }

    final trendData = _calculateLinearTrend(dailyTotals);
    final weeklyAverages = _calculateWeeklyAverages(dailyTotals);

    return {
      'trend': trendData['trend'],
      'direction': trendData['direction'],
      'strength': trendData['strength'],
      'slope': trendData['slope'],
      'weeklyAverages': weeklyAverages,
      'averageDailyCompletions': dailyTotals.isNotEmpty
          ? dailyTotals.reduce((a, b) => a + b) / dailyTotals.length
          : 0.0,
      'peakDay': _findPeakDay(dailyCompletions),
      'message': _generateOverallTrendMessage(trendData),
    };
  }

  /// Analyze weekly patterns
  static Map<String, dynamic> _analyzeWeeklyPatterns(
    List<Map<String, dynamic>> completions,
    DateTime startDate,
    DateTime endDate,
  ) {
    final weekdayCompletions = <int, List<int>>{
      1: [], 2: [], 3: [], 4: [], 5: [], 6: [], 7: [] // Monday to Sunday
    };

    final dailyCompletions = _groupCompletionsByDay(completions);

    DateTime date = DateTime(startDate.year, startDate.month, startDate.day);
    final analysisEndDate = DateTime(endDate.year, endDate.month, endDate.day);

    while (date.isBefore(analysisEndDate) || date.isAtSameMomentAs(analysisEndDate)) {
      final dateKey = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      final completionCount = dailyCompletions[dateKey] ?? 0;
      weekdayCompletions[date.weekday]!.add(completionCount);
      date = date.add(const Duration(days: 1));
    }

    final weekdayAverages = <String, double>{};
    final weekdayNames = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

    for (int i = 1; i <= 7; i++) {
      final completions = weekdayCompletions[i]!;
      if (completions.isNotEmpty) {
        weekdayAverages[weekdayNames[i - 1]] =
            completions.reduce((a, b) => a + b) / completions.length;
      } else {
        weekdayAverages[weekdayNames[i - 1]] = 0.0;
      }
    }

    final bestDay = weekdayAverages.entries
        .reduce((a, b) => a.value > b.value ? a : b);
    final worstDay = weekdayAverages.entries
        .reduce((a, b) => a.value < b.value ? a : b);

    return {
      'weekdayAverages': weekdayAverages,
      'bestDay': bestDay.key,
      'bestDayAverage': bestDay.value,
      'worstDay': worstDay.key,
      'worstDayAverage': worstDay.value,
      'weekendVsWeekday': _calculateWeekendVsWeekdayRatio(weekdayAverages),
    };
  }

  /// Analyze monthly patterns
  static Map<String, dynamic> _analyzeMonthlyPatterns(
    List<Map<String, dynamic>> completions,
    DateTime startDate,
    DateTime endDate,
  ) {
    final monthlyData = <String, int>{};

    for (final completion in completions) {
      final completedAt = completion['completedAt'];
      if (completedAt is DateTime &&
          _isDateInRange(completedAt, startDate, endDate)) {
        final monthKey = '${completedAt.year}-${completedAt.month.toString().padLeft(2, '0')}';
        monthlyData[monthKey] = (monthlyData[monthKey] ?? 0) + 1;
      }
    }

    if (monthlyData.length < 2) {
      return {
        'hasEnoughData': false,
        'message': 'Need at least 2 months of data for monthly analysis',
      };
    }

    final monthlyTotals = monthlyData.values.toList().map((v) => v.toDouble()).toList();
    final trendData = _calculateLinearTrend(monthlyTotals);

    return {
      'hasEnoughData': true,
      'monthlyTotals': monthlyData,
      'trend': trendData['trend'],
      'direction': trendData['direction'],
      'averageMonthlyCompletions': monthlyTotals.reduce((a, b) => a + b) / monthlyTotals.length,
      'bestMonth': monthlyData.entries.reduce((a, b) => a.value > b.value ? a : b),
      'worstMonth': monthlyData.entries.reduce((a, b) => a.value < b.value ? a : b),
    };
  }

  // Helper methods

  static bool _isDateInRange(dynamic date, DateTime startDate, DateTime endDate) {
    if (date is! DateTime) return false;
    return date.isAfter(startDate.subtract(const Duration(days: 1))) &&
           date.isBefore(endDate.add(const Duration(days: 1)));
  }

  static Map<String, int> _groupCompletionsByDay(List<Map<String, dynamic>> completions) {
    final dailyCompletions = <String, int>{};

    for (final completion in completions) {
      final completedAt = completion['completedAt'];
      if (completedAt is DateTime) {
        final dateKey = '${completedAt.year}-${completedAt.month.toString().padLeft(2, '0')}-${completedAt.day.toString().padLeft(2, '0')}';
        dailyCompletions[dateKey] = (dailyCompletions[dateKey] ?? 0) + 1;
      }
    }

    return dailyCompletions;
  }

  static Map<String, dynamic> _calculateLinearTrend(List<double> values) {
    if (values.length < 2) {
      return {
        'trend': 'insufficient_data',
        'direction': 'neutral',
        'strength': 0.0,
        'slope': 0.0,
      };
    }

    final n = values.length;
    final x = List.generate(n, (i) => i.toDouble());

    final xMean = x.reduce((a, b) => a + b) / n;
    final yMean = values.reduce((a, b) => a + b) / n;

    double numerator = 0.0;
    double denominator = 0.0;

    for (int i = 0; i < n; i++) {
      numerator += (x[i] - xMean) * (values[i] - yMean);
      denominator += pow(x[i] - xMean, 2);
    }

    final slope = denominator != 0 ? numerator / denominator : 0.0;
    final strength = slope.abs();

    String trend;
    String direction;

    if (strength < 0.01) {
      trend = 'stable';
      direction = 'neutral';
    } else if (slope > 0) {
      trend = strength > 0.05 ? 'strong_improving' : 'improving';
      direction = 'upward';
    } else {
      trend = strength > 0.05 ? 'strong_declining' : 'declining';
      direction = 'downward';
    }

    return {
      'trend': trend,
      'direction': direction,
      'strength': strength,
      'slope': slope,
    };
  }

  static List<double> _calculateWeeklyAverages(List<double> dailyValues) {
    final weeklyAverages = <double>[];

    for (int i = 0; i < dailyValues.length; i += 7) {
      final weekEnd = min(i + 7, dailyValues.length);
      final weekData = dailyValues.sublist(i, weekEnd);
      final average = weekData.reduce((a, b) => a + b) / weekData.length;
      weeklyAverages.add(average);
    }

    return weeklyAverages;
  }

  static String _findPeakDay(Map<String, int> dailyCompletions) {
    if (dailyCompletions.isEmpty) return 'No data';

    final peak = dailyCompletions.entries.reduce((a, b) => a.value > b.value ? a : b);
    return peak.key;
  }

  static double _calculateWeekendVsWeekdayRatio(Map<String, double> weekdayAverages) {
    final weekdayTotal = weekdayAverages['Monday']! + weekdayAverages['Tuesday']! +
                        weekdayAverages['Wednesday']! + weekdayAverages['Thursday']! +
                        weekdayAverages['Friday']!;
    final weekendTotal = weekdayAverages['Saturday']! + weekdayAverages['Sunday']!;

    final weekdayAvg = weekdayTotal / 5;
    final weekendAvg = weekendTotal / 2;

    return weekdayAvg != 0 ? weekendAvg / weekdayAvg : 0.0;
  }

  static String _generateTrendMessage(Map<String, dynamic> trendData, String habitName) {
    final trend = trendData['trend'];

    switch (trend) {
      case 'strong_improving':
        return '$habitName is showing strong improvement! Keep up the excellent work.';
      case 'improving':
        return '$habitName is gradually improving. You\'re on the right track!';
      case 'stable':
        return '$habitName has been consistent. Consider strategies to boost performance.';
      case 'declining':
        return '$habitName is showing a slight decline. Time to refocus your efforts.';
      case 'strong_declining':
        return '$habitName needs attention. Consider reviewing your approach or obstacles.';
      default:
        return 'Not enough data to determine trend for $habitName.';
    }
  }

  static String _generateOverallTrendMessage(Map<String, dynamic> trendData) {
    final trend = trendData['trend'];

    switch (trend) {
      case 'strong_improving':
        return 'Your overall habit performance is improving significantly!';
      case 'improving':
        return 'Your habit consistency is gradually improving.';
      case 'stable':
        return 'Your habits are consistently maintained.';
      case 'declining':
        return 'Your overall habit performance is declining slightly.';
      case 'strong_declining':
        return 'Your habit performance needs attention across multiple areas.';
      default:
        return 'Building baseline data for trend analysis.';
    }
  }

  static Map<String, List<String>> _generateInsights(Map<String, dynamic> trends) {
    final insights = <String>[];
    final recommendations = <String>[];

    final overallTrends = trends['overallTrends'] as Map<String, dynamic>;
    final weeklyPatterns = trends['weeklyPatterns'] as Map<String, dynamic>;

    // Overall trend insights
    final overallTrend = overallTrends['trend'];
    if (overallTrend == 'improving' || overallTrend == 'strong_improving') {
      insights.add('Your habit consistency is improving over time!');
    } else if (overallTrend == 'declining' || overallTrend == 'strong_declining') {
      insights.add('Your habit performance has been declining recently.');
      recommendations.add('Consider reviewing your habit schedule and removing obstacles.');
    }

    // Weekly pattern insights
    final bestDay = weeklyPatterns['bestDay'];
    final worstDay = weeklyPatterns['worstDay'];
    final weekendRatio = weeklyPatterns['weekendVsWeekday'] as double;

    insights.add('Your most productive day is $bestDay.');
    insights.add('Your least productive day is $worstDay.');

    if (weekendRatio < 0.7) {
      insights.add('You\'re less consistent on weekends.');
      recommendations.add('Plan simpler habits for weekends to maintain consistency.');
    } else if (weekendRatio > 1.3) {
      insights.add('You\'re more active on weekends!');
      recommendations.add('Try to maintain weekend momentum during weekdays.');
    }

    return {
      'insights': insights,
      'recommendations': recommendations,
    };
  }
}
