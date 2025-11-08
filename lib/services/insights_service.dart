import 'dart:math' as math;
import 'package:logger/logger.dart';
import '../domain/model/habit.dart';
import '../domain/model/archived_habit.dart';
import '../data/database_isar.dart';
import 'rrule_service.dart';

/// Service for calculating comprehensive habit insights and analytics
/// Automatically includes archived habit completion data for complete historical analytics
class InsightsService {
  static final InsightsService _instance = InsightsService._internal();
  factory InsightsService() => _instance;
  InsightsService._internal();

  final Logger _logger = Logger();

  /// Get all archived habits for including in analytics
  Future<List<ArchivedHabit>> _getArchivedHabits() async {
    try {
      final isar = await IsarDatabaseService.getInstance();
      final habitService = HabitServiceIsar(isar);
      return await habitService.getAllArchivedHabits();
    } catch (e) {
      _logger.e('Error fetching archived habits for insights', error: e);
      return [];
    }
  }

  /// Calculate overall completion rate for all habits in the last 30 days
  /// Includes archived habit completions for complete historical data
  Future<Map<String, dynamic>> calculateOverallCompletionRate(
      List<Habit> habits) async {
    // Include archived habit completions
    final archivedHabits = await _getArchivedHabits();

    if (habits.isEmpty && archivedHabits.isEmpty) {
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
        final expectedForWeek = _getExpectedCompletionsForPeriod(
          habit,
          weekStart,
          weekEnd,
        );
        weekScheduled += expectedForWeek;

        // Count actual completions
        final actualForWeek = habit.completions
            .where(
              (completion) =>
                  completion.isAfter(weekStart) &&
                  completion.isBefore(weekEnd.add(const Duration(days: 1))),
            )
            .length;
        weekCompleted += actualForWeek;
      }

      // Include archived habit completions in sparkline
      for (final archived in archivedHabits) {
        final archivedCompletionsForWeek = archived.completions
            .where(
              (completion) =>
                  completion.isAfter(weekStart) &&
                  completion.isBefore(weekEnd.add(const Duration(days: 1))),
            )
            .length;
        weekCompleted += archivedCompletionsForWeek;
        // Archived habits don't contribute to scheduled count (already deleted)
      }

      final weekRate =
          weekScheduled > 0 ? (weekCompleted / weekScheduled) : 0.0;
      sparklineData.insert(
        0,
        weekRate,
      ); // Insert at beginning for chronological order
    }

    for (final habit in habits) {
      if (!habit.isActive) continue;

      // Current period (last 30 days)
      final expectedCurrent = _getExpectedCompletionsForPeriod(
        habit,
        last30Days,
        now,
      );
      totalScheduledCurrent += expectedCurrent;

      final actualCurrent = habit.completions
          .where(
            (completion) =>
                completion.isAfter(last30Days) &&
                completion.isBefore(now.add(const Duration(days: 1))),
          )
          .length;
      totalCompletedCurrent += actualCurrent;

      // Previous period (31-60 days ago)
      final expectedPrevious = _getExpectedCompletionsForPeriod(
        habit,
        previous30Days,
        last30Days,
      );
      totalScheduledPrevious += expectedPrevious;

      final actualPrevious = habit.completions
          .where(
            (completion) =>
                completion.isAfter(previous30Days) &&
                completion.isBefore(last30Days.add(const Duration(days: 1))),
          )
          .length;
      totalCompletedPrevious += actualPrevious;
    }

    // Add archived habit completions to totals
    for (final archived in archivedHabits) {
      // Current period completions
      final archivedCurrentCompletions = archived.completions
          .where(
            (completion) =>
                completion.isAfter(last30Days) &&
                completion.isBefore(now.add(const Duration(days: 1))),
          )
          .length;
      totalCompletedCurrent += archivedCurrentCompletions;

      // Previous period completions
      final archivedPreviousCompletions = archived.completions
          .where(
            (completion) =>
                completion.isAfter(previous30Days) &&
                completion.isBefore(last30Days.add(const Duration(days: 1))),
          )
          .length;
      totalCompletedPrevious += archivedPreviousCompletions;
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
      return {'score': 0, 'label': 'No Data'};
    }

    final activeHabits = habits.where((h) => h.isActive).toList();
    if (activeHabits.isEmpty) {
      return {'score': 0, 'label': 'No Active Habits'};
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

    return {'score': score, 'label': label};
  }

  /// Calculate most powerful day of the week
  /// Calculate most powerful day of the week
  /// Includes archived habit completions for comprehensive analysis
  Future<Map<String, dynamic>> calculateMostPowerfulDay(
      List<Habit> habits) async {
    final archivedHabits = await _getArchivedHabits();

    if (habits.isEmpty && archivedHabits.isEmpty) {
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
      0,
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
          dayTotals[day] += _getExpectedDailyCompletions(
            habit,
            last30Days,
            now,
          );
        }
      }
    }

    // Include archived habit completions
    for (final archived in archivedHabits) {
      final recentCompletions = archived.completions
          .where((completion) => completion.isAfter(last30Days))
          .toList();

      for (final completion in recentCompletions) {
        final dayOfWeek = completion.weekday - 1; // Convert to 0-6 (Mon-Sun)
        dayCompletions[dayOfWeek]++;
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
      'Sunday',
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

    try {
      // Enhanced pattern analysis with all methods
      final allPotentialInsights = <Map<String, dynamic>>[];

      // Original pattern analysis methods
      try {
        _analyzeWeekendDrops(habits, allPotentialInsights);
      } catch (e) {
        _logger.e('Error in _analyzeWeekendDrops: $e');
      }

      try {
        _analyzeStreakOpportunities(habits, allPotentialInsights);
      } catch (e) {
        _logger.e('Error in _analyzeStreakOpportunities: $e');
      }

      try {
        _analyzeTimeCorrelations(habits, allPotentialInsights);
      } catch (e) {
        _logger.e('Error in _analyzeTimeCorrelations: $e');
      }

      try {
        _analyzeCategoryPerformance(habits, allPotentialInsights);
      } catch (e) {
        _logger.e('Error in _analyzeCategoryPerformance: $e');
      }

      try {
        _analyzeConsistencyPatterns(habits, allPotentialInsights);
      } catch (e) {
        _logger.e('Error in _analyzeConsistencyPatterns: $e');
      }

      try {
        _analyzeAtRiskHabits(habits, allPotentialInsights);
      } catch (e) {
        _logger.e('Error in _analyzeAtRiskHabits: $e');
      }

      try {
        _analyzeVolatility(habits, allPotentialInsights);
      } catch (e) {
        _logger.e('Error in _analyzeVolatility: $e');
      }

      try {
        _addPerHabitSuggestions(habits, allPotentialInsights);
      } catch (e) {
        _logger.e('Error in _addPerHabitSuggestions: $e');
      }

      // NEW: Enhanced analysis methods
      try {
        _analyzeTemporalPatterns(habits, allPotentialInsights);
      } catch (e) {
        _logger.e('Error in _analyzeTemporalPatterns: $e');
      }

      try {
        _analyzeDifficultyPerformance(habits, allPotentialInsights);
      } catch (e) {
        _logger.e('Error in _analyzeDifficultyPerformance: $e');
      }

      try {
        _analyzeHabitCorrelations(habits, allPotentialInsights);
      } catch (e) {
        _logger.e('Error in _analyzeHabitCorrelations: $e');
      }

      try {
        _analyzeImprovementOpportunities(habits, allPotentialInsights);
      } catch (e) {
        _logger.e('Error in _analyzeImprovementOpportunities: $e');
      }

      // Prioritize insights: achievements > patterns > motivational
      final priorityMap = {
        'achievement': 4,
        'celebration': 4,
        'pattern': 3,
        'insight': 3,
        'actionable': 3,
        'strength': 2,
        'motivation': 2,
        'motivational': 1,
      };

      allPotentialInsights.sort((a, b) {
        final priorityA = priorityMap[a['type']] ?? 0;
        final priorityB = priorityMap[b['type']] ?? 0;
        return priorityB.compareTo(priorityA);
      });

      // Take top 3, ensuring variety in types
      final selectedTypes = <String>{};
      for (final insight in allPotentialInsights) {
        final type = insight['type'] as String;
        // Allow max 2 insights of the same type
        final typeCount = selectedTypes.where((t) => t == type).length;
        if (typeCount < 2) {
          insights.add(insight);
          selectedTypes.add(type);
          if (insights.length >= 3) break;
        }
      }
    } catch (e) {
      _logger.e('Error in generateAIInsights: $e');
      // Add a fallback insight if all analysis fails
      insights.add({
        'type': 'motivational',
        'title': 'Keep Going!',
        'description':
            'Your habit journey is unique. Focus on consistency over perfection.',
        'icon': 'trending_up',
      });
    }

    // Ensure we always return at least one insight if we have habits
    if (insights.isEmpty && habits.isNotEmpty) {
      insights.add({
        'type': 'motivational',
        'title': 'Building Momentum',
        'description':
            'You have ${habits.where((h) => h.isActive).length} active habits. Every completion builds momentum!',
        'icon': 'rocket_launch',
      });
    }

    return insights.take(3).toList(); // Limit to top 3 insights
  }

  /// Analyze weekend completion drops
  void _analyzeWeekendDrops(
    List<Habit> habits,
    List<Map<String, dynamic>> insights,
  ) {
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
    List<Habit> habits,
    List<Map<String, dynamic>> insights,
  ) {
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
    List<Habit> habits,
    List<Map<String, dynamic>> insights,
  ) {
    // This is a simplified correlation analysis
    // In a real implementation, you might use more sophisticated statistical methods

    final morningHabits = habits
        .where(
          (h) => h.notificationTime != null && h.notificationTime!.hour < 12,
        )
        .toList();

    final eveningHabits = habits
        .where(
          (h) => h.notificationTime != null && h.notificationTime!.hour >= 18,
        )
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
    List<Habit> habits,
    List<Map<String, dynamic>> insights,
  ) {
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
    List<Habit> habits,
    List<Map<String, dynamic>> insights,
  ) {
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
    Habit habit,
    DateTime start,
    DateTime end,
  ) {
    // Use RRule if available
    if (habit.usesRRule && habit.rruleString != null) {
      final occurrences = RRuleService.getOccurrences(
        rruleString: habit.rruleString!,
        startDate: habit.dtStart ?? habit.createdAt,
        rangeStart: start,
        rangeEnd: end,
      );
      return occurrences.length;
    }

    // Legacy frequency-based calculation
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
      case HabitFrequency.single:
        // Single habits can only be completed once, so check if the period contains the target date
        if (habit.singleDateTime == null) return 0;
        final targetDate = habit.singleDateTime!;
        return (targetDate.isAfter(start.subtract(const Duration(days: 1))) &&
                targetDate.isBefore(end.add(const Duration(days: 1))))
            ? 1
            : 0;
    }
  }

  /// Helper method to calculate expected daily completions
  int _getExpectedDailyCompletions(Habit habit, DateTime start, DateTime end) {
    final totalDays = end.difference(start).inDays;
    final expectedTotal = _getExpectedCompletionsForPeriod(habit, start, end);
    return (expectedTotal / math.max(totalDays / 30, 1))
        .round(); // Average per 30-day period
  }

  // --- New analytics helpers ---

  /// Detect habits trending down and likely to miss next expected completion.
  void _analyzeAtRiskHabits(
    List<Habit> habits,
    List<Map<String, dynamic>> insights,
  ) {
    final active = habits.where((h) => h.isActive).toList();
    if (active.isEmpty) return;

    Habit? worst;
    double worstSlope = 0; // negative slope = declining

    for (final h in active) {
      // Build last 8 weeks completion rate series for this habit
      final now = DateTime.now();
      final weeks = <double>[];
      for (int i = 7; i >= 0; i--) {
        final weekStart = now.subtract(Duration(days: i * 7 + now.weekday - 1));
        final weekEnd = weekStart.add(const Duration(days: 6));
        final expected = _getExpectedCompletionsForPeriod(
          h,
          weekStart,
          weekEnd,
        );
        final completed = h.completions
            .where(
              (c) =>
                  c.isAfter(weekStart.subtract(const Duration(days: 1))) &&
                  c.isBefore(weekEnd.add(const Duration(days: 1))),
            )
            .length;
        final rate = expected > 0 ? completed / expected : 0.0;
        weeks.add(rate);
      }
      if (weeks.length < 3) continue;

      // Linear trend using simple slope with equally spaced x
      final n = weeks.length;
      final xbar = (n - 1) / 2.0;
      final ybar = weeks.reduce((a, b) => a + b) / n;
      double num = 0, den = 0;
      for (int i = 0; i < n; i++) {
        num += (i - xbar) * (weeks[i] - ybar);
        den += (i - xbar) * (i - xbar);
      }
      final slope = den > 0 ? num / den : 0.0; // per-week change in rate

      // Consider at risk if downward slope and overdue or low momentum
      final atRisk = slope < -0.05 || (h.isOverdue && h.momentum < 0.5);
      if (atRisk && slope < worstSlope) {
        worstSlope = slope;
        worst = h;
      }
    }

    if (worst != null) {
      final daysSince = worst.daysSinceLastCompletion;
      final msg = daysSince >= 0
          ? 'It\'s been $daysSince day(s) since your last "${worst.name}" completion.'
          : 'Momentum is dipping for "${worst.name}".';
      insights.add({
        'type': 'pattern',
        'title': 'At-Risk Habit Detected',
        'description':
            '$msg Consider a quick win or adjusting timing to catch the trend early.',
        'icon': 'trending_up',
        'action': 'open_habit',
        'habitId': worst.id,
        'ctaLabel': 'Review and Nudge',
      });
    }
  }

  /// Detect high variance habits and suggest consistency tactics.
  void _analyzeVolatility(
    List<Habit> habits,
    List<Map<String, dynamic>> insights,
  ) {
    final active = habits.where((h) => h.isActive && h.completions.isNotEmpty);
    Habit? volatile;
    double highestVar = 0;

    for (final h in active) {
      // Weekly completion counts over last 8 weeks
      final now = DateTime.now();
      final series = <double>[];
      for (int i = 7; i >= 0; i--) {
        final weekStart = now.subtract(Duration(days: i * 7 + now.weekday - 1));
        final weekEnd = weekStart.add(const Duration(days: 6));
        final cnt = h.completions
            .where(
              (c) =>
                  c.isAfter(weekStart.subtract(const Duration(days: 1))) &&
                  c.isBefore(weekEnd.add(const Duration(days: 1))),
            )
            .length
            .toDouble();
        series.add(cnt);
      }
      if (series.length < 2) continue;
      final mean = series.reduce((a, b) => a + b) / series.length;
      final variance =
          series.map((v) => (v - mean) * (v - mean)).reduce((a, b) => a + b) /
              series.length;
      if (variance > highestVar && variance > 0.5) {
        highestVar = variance;
        volatile = h;
      }
    }

    if (volatile != null) {
      insights.add({
        'type': 'pattern',
        'title': 'High Volatility Detected',
        'description':
            '"${volatile.name}" shows big week-to-week swings. Try smaller targets and steadier reminders to stabilize.',
        'icon': 'trending_up',
        'action': 'adjust_reminder',
        'habitId': volatile.id,
        'ctaLabel': 'Tune Reminders',
      });
    }
  }

  /// Add per-habit suggestions with a simple estimated impact.
  void _addPerHabitSuggestions(
    List<Habit> habits,
    List<Map<String, dynamic>> insights,
  ) {
    final active = habits.where((h) => h.isActive).toList();
    if (active.isEmpty) return;

    // Pick one low performer and one moderate to showcase CTAs
    final sorted = [...active]
      ..sort((a, b) => a.completionRate.compareTo(b.completionRate));
    final low = sorted.first;

    // Estimate: moving reminder to morning boosts by ~10-20% if current rate < 60%
    final base = low.completionRate;
    if (base < 0.6) {
      final est = ((base + 0.15).clamp(0.0, 1.0) * 100).round();
      insights.add({
        'type': 'insight',
        'title': 'Timing Tweak Could Help',
        'description':
            'Shifting "${low.name}" to your morning block may lift completion to about $est%.',
        'icon': 'wb_sunny',
        'action': 'adjust_reminder',
        'habitId': low.id,
        'ctaLabel': 'Adjust Reminder Time',
      });
    }

    // Suggest stacking for any habit with consistency < 60
    final stackTarget = sorted.firstWhere(
      (h) => h.consistencyScore < 60,
      orElse: () => low,
    );
    insights.add({
      'type': 'insight',
      'title': 'Stack With a Routine',
      'description':
          'Attach "${stackTarget.name}" after an existing routine (e.g., coffee). Expect ~10% consistency gain.',
      'icon': 'link',
      'action': 'open_habit',
      'habitId': stackTarget.id,
      'ctaLabel': 'Stack with Morning Routine',
    });
  }

  /// Generate weekly completion trend data for charts
  List<Map<String, dynamic>> generateWeeklyTrendData(
    List<Habit> habits, {
    int weeks = 12,
  }) {
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
            .where(
              (completion) =>
                  completion.isAfter(
                    weekStart.subtract(const Duration(days: 1)),
                  ) &&
                  completion.isBefore(weekEnd.add(const Duration(days: 1))),
            )
            .length;

        totalCompletions += weekCompletions;
        totalExpected += _getExpectedCompletionsForPeriod(
          habit,
          weekStart,
          weekEnd,
        );
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

  /// Analyze temporal patterns (weekday vs weekend, time of day)
  void _analyzeTemporalPatterns(
    List<Habit> habits,
    List<Map<String, dynamic>> insights,
  ) {
    final now = DateTime.now();
    final last30Days = now.subtract(const Duration(days: 30));

    int morningCompletions = 0;
    int afternoonCompletions = 0;
    int eveningCompletions = 0;
    int totalWithTime = 0;

    for (final habit in habits) {
      if (!habit.isActive || habit.notificationTime == null) continue;

      final recentCompletions =
          habit.completions.where((c) => c.isAfter(last30Days)).length;

      if (recentCompletions > 0) {
        final hour = habit.notificationTime!.hour;
        if (hour < 12) {
          morningCompletions += recentCompletions;
        } else if (hour < 17) {
          afternoonCompletions += recentCompletions;
        } else {
          eveningCompletions += recentCompletions;
        }
        totalWithTime += recentCompletions;
      }
    }

    if (totalWithTime > 10) {
      final morningRate = (morningCompletions / totalWithTime * 100).round();
      final afternoonRate =
          (afternoonCompletions / totalWithTime * 100).round();
      final eveningRate = (eveningCompletions / totalWithTime * 100).round();

      String timeOfDay = 'morning';
      int maxRate = morningRate;
      String icon = 'wb_sunny';

      if (afternoonRate > maxRate) {
        maxRate = afternoonRate;
        timeOfDay = 'afternoon';
        icon = 'light_mode';
      }
      if (eveningRate > maxRate) {
        maxRate = eveningRate;
        timeOfDay = 'evening';
        icon = 'nightlight';
      }

      if (maxRate > 45) {
        insights.add({
          'type': 'pattern',
          'title': 'Prime Time Detected',
          'description':
              'You\'re crushing it in the $timeOfDay with $maxRate% of completions. Consider scheduling new habits during this window.',
          'icon': icon,
        });
      }
    }
  }

  /// Analyze performance by difficulty level
  void _analyzeDifficultyPerformance(
    List<Habit> habits,
    List<Map<String, dynamic>> insights,
  ) {
    final difficultyGroups = <HabitDifficulty, List<Habit>>{};
    for (final habit in habits) {
      if (!habit.isActive) continue;
      difficultyGroups.putIfAbsent(habit.difficulty, () => []).add(habit);
    }

    // Check if user is consistently succeeding at hard habits
    final hardHabits = difficultyGroups[HabitDifficulty.hard] ?? [];
    if (hardHabits.isNotEmpty) {
      final avgRate =
          hardHabits.map((h) => h.completionRate).reduce((a, b) => a + b) /
              hardHabits.length;
      if (avgRate > 0.8) {
        insights.add({
          'type': 'achievement',
          'title': 'Challenge Champion',
          'description':
              'You\'re maintaining ${(avgRate * 100).round()}% completion on hard habits. You\'ve leveled up!',
          'icon': 'emoji_events',
        });
      }
    }

    // Check if user should upgrade difficulty
    final easyHabits = difficultyGroups[HabitDifficulty.easy] ?? [];
    if (easyHabits.length >= 2) {
      final highPerformers = easyHabits
          .where((h) => h.completionRate > 0.9 && h.streakInfo.current >= 7)
          .toList();
      if (highPerformers.isNotEmpty) {
        final habitName = highPerformers.first.name;
        insights.add({
          'type': 'actionable',
          'title': 'Ready to Level Up?',
          'description':
              '"$habitName" has a ${(highPerformers.first.completionRate * 100).round()}% completion rate. Consider increasing frequency or difficulty.',
          'icon': 'trending_up',
        });
      }
    }
  }

  /// Analyze correlations between habits
  void _analyzeHabitCorrelations(
    List<Habit> habits,
    List<Map<String, dynamic>> insights,
  ) {
    if (habits.length < 2) return;

    final now = DateTime.now();
    final last14Days = now.subtract(const Duration(days: 14));

    int bestOverlap = 0;
    String habit1Name = '';
    String habit2Name = '';

    for (int i = 0; i < habits.length; i++) {
      for (int j = i + 1; j < habits.length; j++) {
        final h1 = habits[i];
        final h2 = habits[j];

        final completions1 = h1.completions
            .where((c) => c.isAfter(last14Days))
            .map((c) => '${c.year}-${c.month}-${c.day}')
            .toSet();
        final completions2 = h2.completions
            .where((c) => c.isAfter(last14Days))
            .map((c) => '${c.year}-${c.month}-${c.day}')
            .toSet();

        final overlap = completions1.intersection(completions2).length;
        if (overlap > bestOverlap) {
          bestOverlap = overlap;
          habit1Name = h1.name;
          habit2Name = h2.name;
        }
      }
    }

    if (bestOverlap >= 5) {
      insights.add({
        'type': 'insight',
        'title': 'Habit Stack Detected',
        'description':
            '"$habit1Name" and "$habit2Name" pair well together ($bestOverlap days). This is an effective habit stack!',
        'icon': 'link',
      });
    }
  }

  /// Analyze improvement opportunities
  void _analyzeImprovementOpportunities(
    List<Habit> habits,
    List<Map<String, dynamic>> insights,
  ) {
    // Find habits with declining performance
    final now = DateTime.now();
    final lastWeek = now.subtract(const Duration(days: 7));
    final previousWeek = now.subtract(const Duration(days: 14));

    for (final habit in habits) {
      if (!habit.isActive) continue;

      final lastWeekCount =
          habit.completions.where((c) => c.isAfter(lastWeek)).length;
      final previousWeekCount = habit.completions
          .where((c) => c.isAfter(previousWeek) && c.isBefore(lastWeek))
          .length;

      if (previousWeekCount >= 3 && lastWeekCount < previousWeekCount - 2) {
        insights.add({
          'type': 'actionable',
          'title': 'Needs Attention',
          'description':
              '"${habit.name}" dropped from $previousWeekCount to $lastWeekCount completions. Review your schedule or reduce difficulty temporarily.',
          'icon': 'warning',
        });
        return; // Only show one declining habit warning
      }
    }

    // Find habits with perfect consistency that could be celebrated
    final perfectHabits = habits
        .where(
          (h) =>
              h.isActive &&
              h.consistencyScore == 100 &&
              h.completions.length >= 7,
        )
        .toList();
    if (perfectHabits.isNotEmpty) {
      final habit = perfectHabits.first;
      insights.add({
        'type': 'celebration',
        'title': 'Perfect Consistency!',
        'description':
            '"${habit.name}" has 100% consistency over ${habit.completions.length} completions. Absolute mastery!',
        'icon': 'stars',
      });
    }
  }
}
