import 'dart:math' as math;
import '../domain/model/habit.dart';

/// Service for calculating comprehensive habit insights and analytics
class InsightsService {
  static final InsightsService _instance = InsightsService._internal();
  factory InsightsService() => _instance;
  InsightsService._internal();

  /// Calculate overall completion rate for all habits in the last 30 days
  Map<String, dynamic> calculateOverallCompletionRate(List<Habit> habits) {
    if (habits.isEmpty) {
      return {
        'rate': 0.0,
        'trend': 0.0,
        'trendText': 'No data available',
        'sparkline': <double>[],
      };
    }

    final now = DateTime.now();
    final last30Days = now.subtract(const Duration(days: 30));
    final previous30Days = now.subtract(const Duration(days: 60));

    // Calculate current period completion rate
    int totalScheduledCurrent = 0;
    int totalCompletedCurrent = 0;
    int totalScheduledPrevious = 0;
    int totalCompletedPrevious = 0;

    // Generate sparkline data (last 4 weeks)
    final sparklineData = <double>[];

    for (int week = 0; week < 4; week++) {
      final weekStart = now.subtract(Duration(days: (week + 1) * 7));
      final weekEnd = now.subtract(Duration(days: week * 7));

      int weekScheduled = 0;
      int weekCompleted = 0;

      for (final habit in habits) {
        if (!habit.isActive) continue;

        // Calculate expected completions for this week
        final expectedForWeek =
            _getExpectedCompletionsForPeriod(habit, weekStart, weekEnd);
        weekScheduled += expectedForWeek;

        // Count actual completions
        final actualForWeek = habit.completions
            .where((completion) =>
                completion.isAfter(weekStart) &&
                completion.isBefore(weekEnd.add(const Duration(days: 1))))
            .length;
        weekCompleted += actualForWeek;
      }

      final weekRate =
          weekScheduled > 0 ? (weekCompleted / weekScheduled) : 0.0;
      sparklineData.insert(
          0, weekRate); // Insert at beginning for chronological order
    }

    for (final habit in habits) {
      if (!habit.isActive) continue;

      // Current period (last 30 days)
      final expectedCurrent =
          _getExpectedCompletionsForPeriod(habit, last30Days, now);
      totalScheduledCurrent += expectedCurrent;

      final actualCurrent = habit.completions
          .where((completion) =>
              completion.isAfter(last30Days) &&
              completion.isBefore(now.add(const Duration(days: 1))))
          .length;
      totalCompletedCurrent += actualCurrent;

      // Previous period (31-60 days ago)
      final expectedPrevious =
          _getExpectedCompletionsForPeriod(habit, previous30Days, last30Days);
      totalScheduledPrevious += expectedPrevious;

      final actualPrevious = habit.completions
          .where((completion) =>
              completion.isAfter(previous30Days) &&
              completion.isBefore(last30Days.add(const Duration(days: 1))))
          .length;
      totalCompletedPrevious += actualPrevious;
    }

    final currentRate = totalScheduledCurrent > 0
        ? (totalCompletedCurrent / totalScheduledCurrent)
        : 0.0;
    final previousRate = totalScheduledPrevious > 0
        ? (totalCompletedPrevious / totalScheduledPrevious)
        : 0.0;
    final trend = currentRate - previousRate;

    String trendText;
    if (trend > 0.05) {
      trendText = '+${(trend * 100).round()}% vs. previous 30 days';
    } else if (trend < -0.05) {
      trendText = '${(trend * 100).round()}% vs. previous 30 days';
    } else {
      trendText = 'Stable vs. previous 30 days';
    }

    return {
      'rate': currentRate,
      'trend': trend,
      'trendText': trendText,
      'sparkline': sparklineData,
    };
  }

  /// Calculate current longest streak across all habits
  Map<String, dynamic> calculateCurrentStreak(List<Habit> habits) {
    if (habits.isEmpty) {
      return {
        'days': 0,
        'habitName': 'No habits',
        'comparison': 'Start creating habits!',
      };
    }

    int longestCurrentStreak = 0;
    String streakHabitName = '';
    int bestEverStreak = 0;

    for (final habit in habits) {
      if (!habit.isActive) continue;

      final streakInfo = habit.streakInfo;
      if (streakInfo.current > longestCurrentStreak) {
        longestCurrentStreak = streakInfo.current;
        streakHabitName = habit.name;
      }

      if (streakInfo.longest > bestEverStreak) {
        bestEverStreak = streakInfo.longest;
      }
    }

    String comparison;
    if (bestEverStreak > longestCurrentStreak) {
      comparison = 'Your best streak ever is $bestEverStreak days';
    } else if (longestCurrentStreak > 0) {
      comparison = 'This is your best streak ever!';
    } else {
      comparison = 'Start a new streak today!';
    }

    return {
      'days': longestCurrentStreak,
      'habitName':
          streakHabitName.isEmpty ? 'No active habits' : streakHabitName,
      'comparison': comparison,
    };
  }

  /// Calculate consistency score (0-100)
  Map<String, dynamic> calculateConsistencyScore(List<Habit> habits) {
    if (habits.isEmpty) {
      return {
        'score': 0,
        'label': 'No Data',
      };
    }

    final activeHabits = habits.where((h) => h.isActive).toList();
    if (activeHabits.isEmpty) {
      return {
        'score': 0,
        'label': 'No Active Habits',
      };
    }

    double totalScore = 0;
    int habitCount = 0;

    for (final habit in activeHabits) {
      if (habit.completions.isNotEmpty) {
        totalScore += habit.consistencyScore;
        habitCount++;
      }
    }

    final averageScore = habitCount > 0 ? (totalScore / habitCount) : 0.0;
    final score = averageScore.round();

    String label;
    if (score >= 90) {
      label = 'Exceptional';
    } else if (score >= 80) {
      label = 'Highly Consistent';
    } else if (score >= 70) {
      label = 'Very Consistent';
    } else if (score >= 60) {
      label = 'Consistently Building';
    } else if (score >= 40) {
      label = 'Building Momentum';
    } else if (score > 0) {
      label = 'Getting Started';
    } else {
      label = 'Just Beginning';
    }

    return {
      'score': score,
      'label': label,
    };
  }

  /// Calculate most powerful day of the week
  Map<String, dynamic> calculateMostPowerfulDay(List<Habit> habits) {
    if (habits.isEmpty) {
      return {
        'day': 'No data',
        'percentage': 0,
        'insight': 'Start tracking habits to see patterns!',
      };
    }

    final dayCompletions = <int>[0, 0, 0, 0, 0, 0, 0]; // Mon-Sun
    final dayTotals = <int>[
      0,
      0,
      0,
      0,
      0,
      0,
      0
    ]; // Expected completions per day

    final now = DateTime.now();
    final last30Days = now.subtract(const Duration(days: 30));

    for (final habit in habits) {
      if (!habit.isActive) continue;

      final recentCompletions = habit.completions
          .where((completion) => completion.isAfter(last30Days))
          .toList();

      for (final completion in recentCompletions) {
        final dayOfWeek = completion.weekday - 1; // Convert to 0-6 (Mon-Sun)
        dayCompletions[dayOfWeek]++;
      }

      // Calculate expected completions per day based on habit frequency
      for (int day = 0; day < 7; day++) {
        if (habit.selectedWeekdays.contains(day + 1) ||
            (habit.selectedWeekdays.isEmpty &&
                habit.frequency == HabitFrequency.daily)) {
          dayTotals[day] +=
              _getExpectedDailyCompletions(habit, last30Days, now);
        }
      }
    }

    // Find the day with highest completion rate
    double bestRate = 0;
    int bestDay = 0;

    for (int i = 0; i < 7; i++) {
      if (dayTotals[i] > 0) {
        final rate = dayCompletions[i] / dayTotals[i];
        if (rate > bestRate) {
          bestRate = rate;
          bestDay = i;
        }
      }
    }

    final dayNames = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];

    // Calculate percentage above average
    final totalCompletions = dayCompletions.reduce((a, b) => a + b);
    final totalExpected = dayTotals.reduce((a, b) => a + b);
    final averageRate =
        totalExpected > 0 ? totalCompletions / totalExpected : 0.0;
    final improvement = bestRate > averageRate
        ? ((bestRate - averageRate) / averageRate * 100)
        : 0.0;

    String insight;
    if (improvement > 20) {
      insight =
          'You complete ${improvement.round()}% more habits on this day than your average';
    } else if (improvement > 10) {
      insight =
          'This is your most productive day with ${improvement.round()}% better performance';
    } else if (improvement > 0) {
      insight = 'Slightly better performance on this day';
    } else {
      insight = 'Your completion rate is fairly consistent across all days';
    }

    return {
      'day': dayNames[bestDay],
      'percentage': improvement.round(),
      'insight': insight,
    };
  }

  /// Generate AI-powered insights
  List<Map<String, dynamic>> generateAIInsights(List<Habit> habits) {
    final insights = <Map<String, dynamic>>[];

    if (habits.isEmpty) {
      insights.add({
        'type': 'motivational',
        'title': 'Welcome to HabitV8!',
        'description':
            'Create your first habit to start building better routines.',
        'icon': 'rocket_launch',
      });
      return insights;
    }

    // Pattern Analysis
    _analyzeWeekendDrops(habits, insights);
    _analyzeStreakOpportunities(habits, insights);
    _analyzeTimeCorrelations(habits, insights);
    _analyzeCategoryPerformance(habits, insights);
    _analyzeConsistencyPatterns(habits, insights);

    return insights.take(3).toList(); // Limit to top 3 insights
  }

  /// Analyze weekend completion drops
  void _analyzeWeekendDrops(
      List<Habit> habits, List<Map<String, dynamic>> insights) {
    final now = DateTime.now();
    final last30Days = now.subtract(const Duration(days: 30));

    int weekdayCompletions = 0;
    int weekendCompletions = 0;
    int weekdayExpected = 0;
    int weekendExpected = 0;

    for (final habit in habits) {
      if (!habit.isActive) continue;

      final recentCompletions = habit.completions
          .where((completion) => completion.isAfter(last30Days))
          .toList();

      for (final completion in recentCompletions) {
        if (completion.weekday >= 6) {
          // Saturday or Sunday
          weekendCompletions++;
        } else {
          weekdayCompletions++;
        }
      }

      // Calculate expected completions
      for (int day = 1; day <= 7; day++) {
        if (habit.selectedWeekdays.contains(day) ||
            (habit.selectedWeekdays.isEmpty &&
                habit.frequency == HabitFrequency.daily)) {
          final expected = _getExpectedDailyCompletions(habit, last30Days, now);
          if (day >= 6) {
            weekendExpected += expected;
          } else {
            weekdayExpected += expected;
          }
        }
      }
    }

    final weekdayRate =
        weekdayExpected > 0 ? weekdayCompletions / weekdayExpected : 0.0;
    final weekendRate =
        weekendExpected > 0 ? weekendCompletions / weekendExpected : 0.0;

    if (weekdayRate > 0 &&
        weekendRate > 0 &&
        weekdayRate - weekendRate > 0.25) {
      final dropPercentage =
          ((weekdayRate - weekendRate) / weekdayRate * 100).round();
      insights.add({
        'type': 'pattern',
        'title': 'Weekend Challenge Detected',
        'description':
            'Your completion rate drops by $dropPercentage% on weekends. Consider scheduling habits earlier in the day or creating weekend-specific routines.',
        'icon': 'weekend',
      });
    }
  }

  /// Analyze streak opportunities
  void _analyzeStreakOpportunities(
      List<Habit> habits, List<Map<String, dynamic>> insights) {
    for (final habit in habits) {
      if (!habit.isActive) continue;

      final streakInfo = habit.streakInfo;
      if (streakInfo.current >= 7 && streakInfo.current < streakInfo.longest) {
        final daysToRecord = streakInfo.longest - streakInfo.current;
        insights.add({
          'type': 'motivation',
          'title': 'Streak Opportunity!',
          'description':
              'You\'re only $daysToRecord days away from beating your personal record for "${habit.name}". Keep going!',
          'icon': 'local_fire_department',
        });
        return; // Only show one streak opportunity at a time
      }

      if (streakInfo.current >= 14) {
        insights.add({
          'type': 'celebration',
          'title': 'Amazing Streak!',
          'description':
              'You\'ve successfully completed "${habit.name}" for ${streakInfo.current} days straight. This is building into a powerful habit!',
          'icon': 'celebration',
        });
        return;
      }
    }
  }

  /// Analyze time correlations between habits
  void _analyzeTimeCorrelations(
      List<Habit> habits, List<Map<String, dynamic>> insights) {
    // This is a simplified correlation analysis
    // In a real implementation, you might use more sophisticated statistical methods

    final morningHabits = habits
        .where(
            (h) => h.notificationTime != null && h.notificationTime!.hour < 12)
        .toList();

    final eveningHabits = habits
        .where(
            (h) => h.notificationTime != null && h.notificationTime!.hour >= 18)
        .toList();

    if (morningHabits.isNotEmpty && eveningHabits.isNotEmpty) {
      final morningAvgRate =
          morningHabits.map((h) => h.completionRate).reduce((a, b) => a + b) /
              morningHabits.length;
      final eveningAvgRate =
          eveningHabits.map((h) => h.completionRate).reduce((a, b) => a + b) /
              eveningHabits.length;

      if (morningAvgRate > eveningAvgRate + 0.2) {
        insights.add({
          'type': 'insight',
          'title': 'Morning Power',
          'description':
              'Your morning habits have a ${((morningAvgRate - eveningAvgRate) * 100).round()}% higher completion rate. Consider moving challenging habits to your morning routine.',
          'icon': 'wb_sunny',
        });
      }
    }
  }

  /// Analyze category performance
  void _analyzeCategoryPerformance(
      List<Habit> habits, List<Map<String, dynamic>> insights) {
    final categoryRates = <String, List<double>>{};

    for (final habit in habits) {
      if (!habit.isActive) continue;

      categoryRates
          .putIfAbsent(habit.category, () => [])
          .add(habit.completionRate);
    }

    String bestCategory = '';
    double bestRate = 0;

    for (final entry in categoryRates.entries) {
      final avgRate = entry.value.reduce((a, b) => a + b) / entry.value.length;
      if (avgRate > bestRate) {
        bestRate = avgRate;
        bestCategory = entry.key;
      }
    }

    if (bestCategory.isNotEmpty && bestRate > 0.8) {
      insights.add({
        'type': 'strength',
        'title': 'Category Champion',
        'description':
            'Your "$bestCategory" habits have an outstanding ${(bestRate * 100).round()}% completion rate. This is your strongest category!',
        'icon': 'emoji_events',
      });
    }
  }

  /// Analyze consistency patterns
  void _analyzeConsistencyPatterns(
      List<Habit> habits, List<Map<String, dynamic>> insights) {
    final highConsistencyHabits =
        habits.where((h) => h.isActive && h.consistencyScore > 85).toList();

    if (highConsistencyHabits.isNotEmpty) {
      final habitNames =
          highConsistencyHabits.take(2).map((h) => '"${h.name}"').join(' and ');
      insights.add({
        'type': 'achievement',
        'title': 'Consistency Master',
        'description':
            'You\'ve maintained exceptional consistency with $habitNames. Your dedication is paying off!',
        'icon': 'trending_up',
      });
    }
  }

  /// Helper method to calculate expected completions for a period
  int _getExpectedCompletionsForPeriod(
      Habit habit, DateTime start, DateTime end) {
    final days = end.difference(start).inDays;

    switch (habit.frequency) {
      case HabitFrequency.daily:
        return days;
      case HabitFrequency.weekly:
        return (days / 7).ceil();
      case HabitFrequency.monthly:
        return (days / 30).ceil();
      case HabitFrequency.yearly:
        return (days / 365).ceil();
      case HabitFrequency.hourly:
        final scheduledDays = habit.selectedWeekdays.isNotEmpty
            ? habit.selectedWeekdays.length
            : 7;
        final weeksInPeriod = (days / 7).ceil();
        return habit.hourlyTimes.length * scheduledDays * weeksInPeriod;
    }
  }

  /// Helper method to calculate expected daily completions
  int _getExpectedDailyCompletions(Habit habit, DateTime start, DateTime end) {
    final totalDays = end.difference(start).inDays;
    final expectedTotal = _getExpectedCompletionsForPeriod(habit, start, end);
    return (expectedTotal / math.max(totalDays / 30, 1))
        .round(); // Average per 30-day period
  }

  /// Generate weekly completion trend data for charts
  List<Map<String, dynamic>> generateWeeklyTrendData(List<Habit> habits,
      {int weeks = 12}) {
    final now = DateTime.now();
    final trendData = <Map<String, dynamic>>[];

    for (int i = weeks - 1; i >= 0; i--) {
      final weekStart = now.subtract(Duration(days: i * 7 + now.weekday - 1));
      final weekEnd = weekStart.add(const Duration(days: 6));

      int totalCompletions = 0;
      int totalExpected = 0;

      for (final habit in habits) {
        if (!habit.isActive) continue;

        final weekCompletions = habit.completions
            .where((completion) =>
                completion
                    .isAfter(weekStart.subtract(const Duration(days: 1))) &&
                completion.isBefore(weekEnd.add(const Duration(days: 1))))
            .length;

        totalCompletions += weekCompletions;
        totalExpected +=
            _getExpectedCompletionsForPeriod(habit, weekStart, weekEnd);
      }

      final completionRate =
          totalExpected > 0 ? (totalCompletions / totalExpected) * 100 : 0.0;

      trendData.add({
        'week': 'Week ${i + 1}',
        'weekStart': weekStart,
        'completionRate': completionRate,
        'totalCompletions': totalCompletions,
        'totalExpected': totalExpected,
      });
    }

    return trendData.reversed.toList(); // Return in chronological order
  }
}
