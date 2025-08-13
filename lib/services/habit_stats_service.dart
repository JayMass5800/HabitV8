import 'dart:math' as math;
import '../domain/model/habit.dart';
import 'cache_service.dart';

/// Service for computing and caching habit statistics
class HabitStatsService {
  static final HabitStatsService _instance = HabitStatsService._internal();
  factory HabitStatsService() => _instance;
  HabitStatsService._internal();

  final CacheService _cache = CacheService();

  // Expose cache service publicly for habit model access
  CacheService get cache => _cache;

  /// Get cached completion rate for a habit
  double getCompletionRate(Habit habit, {int days = 30}) {
    final cacheKey = 'completion_rate_${habit.id}_${days}d';

    return _cache.getOrCompute(
      cacheKey,
      () => _calculateCompletionRate(habit, days),
      ttl: const Duration(hours: 1), // Cache for 1 hour
      dependsOn: ['habit_completions_${habit.id}'],
    );
  }

  /// Get cached streak information for a habit
  StreakInfo getStreakInfo(Habit habit) {
    final cacheKey = 'streak_info_${habit.id}';

    return _cache.getOrCompute(
      cacheKey,
      () => _calculateStreakInfo(habit),
      ttl: const Duration(hours: 1),
      dependsOn: ['habit_completions_${habit.id}'],
    );
  }

  /// Get cached weekly completion pattern
  List<double> getWeeklyPattern(Habit habit, {int weeks = 4}) {
    final cacheKey = 'weekly_pattern_${habit.id}_${weeks}w';

    return _cache.getOrCompute(
      cacheKey,
      () => _calculateWeeklyPattern(habit, weeks),
      ttl: const Duration(hours: 6), // Cache for 6 hours
      dependsOn: ['habit_completions_${habit.id}'],
    );
  }

  /// Get cached monthly statistics
  MonthlyStats getMonthlyStats(Habit habit) {
    final cacheKey = 'monthly_stats_${habit.id}';

    return _cache.getOrCompute(
      cacheKey,
      () => _calculateMonthlyStats(habit),
      ttl: const Duration(hours: 12), // Cache for 12 hours
      dependsOn: ['habit_completions_${habit.id}'],
    );
  }

  /// Get cached consistency score (0-100)
  double getConsistencyScore(Habit habit) {
    final cacheKey = 'consistency_score_${habit.id}';

    return _cache.getOrCompute(
      cacheKey,
      () => _calculateConsistencyScore(habit),
      ttl: const Duration(hours: 2),
      dependsOn: ['habit_completions_${habit.id}'],
    );
  }

  /// Get cached habit momentum (trend indicator)
  double getMomentum(Habit habit) {
    final cacheKey = 'momentum_${habit.id}';

    return _cache.getOrCompute(
      cacheKey,
      () => _calculateMomentum(habit),
      ttl: const Duration(hours: 1),
      dependsOn: ['habit_completions_${habit.id}'],
    );
  }

  /// Invalidate all cached data for a specific habit
  void invalidateHabitCache(String habitId) {
    _cache.invalidateDependents('habit_completions_$habitId');
  }

  /// Invalidate all cached statistics
  void invalidateAllStats() {
    _cache.clearAll();
  }

  /// Calculate completion rate (expensive operation)
  double _calculateCompletionRate(Habit habit, int days) {
    if (habit.completions.isEmpty) return 0.0;

    final now = DateTime.now();
    final startDate = now.subtract(Duration(days: days));

    final recentCompletions = habit.completions.where((completion) =>
        completion.isAfter(startDate) &&
        completion.isBefore(now.add(const Duration(days: 1)))).length;

    // Expected completions based on frequency
    int expectedCompletions;
    switch (habit.frequency) {
      case HabitFrequency.hourly:
        expectedCompletions = days * 24; // Assuming 24 opportunities per day
        break;
      case HabitFrequency.daily:
        expectedCompletions = days;
        break;
      case HabitFrequency.weekly:
        expectedCompletions = (days / 7).ceil();
        break;
      case HabitFrequency.monthly:
        expectedCompletions = (days / 30).ceil();
        break;
      case HabitFrequency.yearly:
        expectedCompletions = (days / 365).ceil();
        break;
    }

    return (recentCompletions / math.max(expectedCompletions, 1)).clamp(0.0, 1.0);
  }

  /// Calculate streak information (expensive operation)
  StreakInfo _calculateStreakInfo(Habit habit) {
    if (habit.completions.isEmpty) {
      return StreakInfo(current: 0, longest: 0, lastCompletion: null);
    }

    final sortedCompletions = habit.completions.toList()
      ..sort((a, b) => b.compareTo(a)); // Most recent first

    int currentStreak = 0;
    int longestStreak = 0;
    int tempStreak = 1;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final mostRecent = DateTime(
      sortedCompletions.first.year,
      sortedCompletions.first.month,
      sortedCompletions.first.day,
    );

    // Calculate current streak
    final daysDiff = today.difference(mostRecent).inDays;
    if (daysDiff <= 1) {
      currentStreak = 1;

      for (int i = 1; i < sortedCompletions.length; i++) {
        final current = DateTime(
          sortedCompletions[i-1].year,
          sortedCompletions[i-1].month,
          sortedCompletions[i-1].day,
        );
        final previous = DateTime(
          sortedCompletions[i].year,
          sortedCompletions[i].month,
          sortedCompletions[i].day,
        );

        if (current.difference(previous).inDays == 1) {
          currentStreak++;
        } else {
          break;
        }
      }
    }

    // Calculate longest streak
    tempStreak = 1;
    for (int i = 1; i < sortedCompletions.length; i++) {
      final current = DateTime(
        sortedCompletions[i-1].year,
        sortedCompletions[i-1].month,
        sortedCompletions[i-1].day,
      );
      final previous = DateTime(
        sortedCompletions[i].year,
        sortedCompletions[i].month,
        sortedCompletions[i].day,
      );

      if (current.difference(previous).inDays == 1) {
        tempStreak++;
      } else {
        longestStreak = math.max(longestStreak, tempStreak);
        tempStreak = 1;
      }
    }
    longestStreak = math.max(longestStreak, tempStreak);

    return StreakInfo(
      current: currentStreak,
      longest: longestStreak,
      lastCompletion: sortedCompletions.first,
    );
  }

  /// Calculate weekly completion pattern
  List<double> _calculateWeeklyPattern(Habit habit, int weeks) {
    final pattern = List<double>.filled(7, 0.0); // Monday to Sunday
    final now = DateTime.now();
    final startDate = now.subtract(Duration(days: weeks * 7));

    final recentCompletions = habit.completions.where((completion) =>
        completion.isAfter(startDate)).toList();

    final dayCount = List<int>.filled(7, 0);
    final totalDays = List<int>.filled(7, 0);

    // Count total possible days for each weekday
    for (int i = 0; i < weeks * 7; i++) {
      final date = startDate.add(Duration(days: i));
      totalDays[date.weekday - 1]++;
    }

    // Count completions for each weekday
    for (final completion in recentCompletions) {
      dayCount[completion.weekday - 1]++;
    }

    // Calculate completion rate for each weekday
    for (int i = 0; i < 7; i++) {
      if (totalDays[i] > 0) {
        pattern[i] = dayCount[i] / totalDays[i];
      }
    }

    return pattern;
  }

  /// Calculate monthly statistics
  MonthlyStats _calculateMonthlyStats(Habit habit) {
    final now = DateTime.now();
    final lastMonth = DateTime(now.year, now.month - 1);

    final thisMonthCompletions = habit.completions.where((c) =>
        c.year == now.year && c.month == now.month).length;
    
    final lastMonthCompletions = habit.completions.where((c) =>
        c.year == lastMonth.year && c.month == lastMonth.month).length;

    final avgCompletions = habit.completions.isEmpty ? 0.0 :
        habit.completions.length / _getMonthsSinceCreation(habit);

    return MonthlyStats(
      thisMonth: thisMonthCompletions,
      lastMonth: lastMonthCompletions,
      average: avgCompletions,
      trend: thisMonthCompletions - lastMonthCompletions,
    );
  }

  /// Calculate consistency score
  double _calculateConsistencyScore(Habit habit) {
    if (habit.completions.length < 7) return 0.0;

    final now = DateTime.now();
    final last30Days = now.subtract(const Duration(days: 30));
    
    final recentCompletions = habit.completions.where((c) =>
        c.isAfter(last30Days)).toList()..sort();

    if (recentCompletions.isEmpty) return 0.0;

    // Calculate variance in completion intervals
    final intervals = <int>[];
    for (int i = 1; i < recentCompletions.length; i++) {
      final interval = recentCompletions[i].difference(recentCompletions[i-1]).inDays;
      intervals.add(interval);
    }

    if (intervals.isEmpty) return 100.0;

    final mean = intervals.reduce((a, b) => a + b) / intervals.length;
    final variance = intervals.map((i) => math.pow(i - mean, 2)).reduce((a, b) => a + b) / intervals.length;
    final standardDeviation = math.sqrt(variance);

    // Lower standard deviation = higher consistency
    final maxDeviation = 7.0; // Days
    final consistencyScore = ((maxDeviation - math.min(standardDeviation, maxDeviation)) / maxDeviation) * 100;

    return consistencyScore.clamp(0.0, 100.0);
  }

  /// Calculate momentum (trend indicator)
  double _calculateMomentum(Habit habit) {
    if (habit.completions.length < 14) return 0.0;

    final now = DateTime.now();
    final last7Days = habit.completions.where((c) =>
        c.isAfter(now.subtract(const Duration(days: 7)))).length;
    
    final previous7Days = habit.completions.where((c) =>
        c.isAfter(now.subtract(const Duration(days: 14))) &&
        c.isBefore(now.subtract(const Duration(days: 7)))).length;

    if (previous7Days == 0) return last7Days > 0 ? 1.0 : 0.0;

    return (last7Days - previous7Days) / previous7Days;
  }

  int _getMonthsSinceCreation(Habit habit) {
    final now = DateTime.now();
    final created = habit.createdAt;
    return ((now.year - created.year) * 12 + (now.month - created.month)).abs();
  }
}

class StreakInfo {
  final int current;
  final int longest;
  final DateTime? lastCompletion;

  StreakInfo({
    required this.current,
    required this.longest,
    this.lastCompletion,
  });
}

class MonthlyStats {
  final int thisMonth;
  final int lastMonth;
  final double average;
  final int trend;

  MonthlyStats({
    required this.thisMonth,
    required this.lastMonth,
    required this.average,
    required this.trend,
  });
}
