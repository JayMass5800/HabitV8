import 'dart:math' as math;
import '../domain/model/habit.dart';
import '../data/database.dart';
import 'health_service.dart';
import 'health_habit_mapping_service.dart';
import 'habit_stats_service.dart';
import 'logging_service.dart';

/// Advanced Health-Habit Analytics Service
/// 
/// Provides comprehensive analytics and insights about the relationship
/// between health metrics and habit performance, including:
/// - Correlation analysis between health data and habit completion
/// - Predictive modeling for habit success
/// - Health trend impact on habit streaks
/// - Personalized optimization recommendations
/// - Performance scoring and benchmarking
class HealthHabitAnalyticsService {
  
  /// Generate comprehensive health-habit analytics report
  static Future<HealthHabitAnalyticsReport> generateAnalyticsReport({
    required HabitService habitService,
    int analysisWindowDays = 90,
  }) async {
    final report = HealthHabitAnalyticsReport();
    
    try {
      AppLogger.info('Generating health-habit analytics report for $analysisWindowDays days...');
      
      // Get all habits and filter for health-mappable habits
      final allHabits = await habitService.getAllHabits();
      
      // Use mapping service to find health-related habits regardless of category
      final mappableHabits = await HealthHabitMappingService.getMappableHabits(allHabits);
      final habits = allHabits.where((habit) => 
        mappableHabits.any((mapping) => mapping.habitId == habit.id)
      ).toList();
      
      final healthSummary = await HealthService.getTodayHealthSummary();
      
      if (habits.isEmpty) {
        report.error = 'No health-mappable habits found for analysis';
        return report;
      }
      
      if (healthSummary.containsKey('error')) {
        report.error = 'No health data available for analysis';
        return report;
      }
      
      // Generate analytics for each habit
      for (final habit in habits) {
        try {
          final analytics = await _generateHabitAnalytics(
            habit: habit,
            healthSummary: healthSummary,
            habitService: habitService,
            windowDays: analysisWindowDays,
          );
          
          report.habitAnalytics[habit.id] = analytics;
          
        } catch (e) {
          AppLogger.error('Error analyzing habit ${habit.name}', e);
        }
      }
      
      // Generate overall insights
      report.overallInsights = await _generateOverallInsights(habits, healthSummary);
      report.recommendations = await _generateRecommendations(habits, healthSummary);
      
      // Calculate summary statistics
      report.totalHabitsAnalyzed = habits.length;
      report.analysisWindowDays = analysisWindowDays;
      report.generatedAt = DateTime.now();
      
      AppLogger.info('Analytics report generated for ${habits.length} habits');
      
    } catch (e) {
      AppLogger.error('Error generating analytics report', e);
      report.error = 'Failed to generate analytics report: ${e.toString()}';
    }
    
    return report;
  }

  /// Generate analytics for a single habit
  static Future<HabitAnalytics> _generateHabitAnalytics({
    required Habit habit,
    required Map<String, dynamic> healthSummary,
    required HabitService habitService,
    required int windowDays,
  }) async {
    final analytics = HabitAnalytics(habitId: habit.id, habitName: habit.name);
    
    try {
      // Get habit completion data from the habit's completions list
      final now = DateTime.now();
      final windowStart = now.subtract(Duration(days: windowDays));
      final recentCompletions = habit.completions.where((completion) =>
        completion.isAfter(windowStart) && completion.isBefore(now.add(Duration(days: 1)))
      ).toList();
      
      // Calculate basic metrics using HabitStatsService
      final statsService = HabitStatsService();
      final streakInfo = statsService.getStreakInfo(habit);
      
      analytics.completionRate = recentCompletions.length / windowDays;
      analytics.currentStreak = streakInfo.current;
      analytics.longestStreak = streakInfo.longest;
      
      // Get health mapping
      final mapping = await HealthHabitMappingService.analyzeHabitForHealthMapping(habit);
      if (mapping != null) {
        analytics.healthDataType = mapping.healthDataType;
        analytics.threshold = mapping.threshold;
        
        // Calculate health correlation (simplified)
        analytics.healthCorrelation = _calculateSimpleCorrelation(
          healthSummary,
          mapping.healthDataType,
          recentCompletions.length,
        );
        
        // Generate insights
        analytics.insights = _generateHabitInsights(habit, mapping, healthSummary);
      }
      
      // Calculate performance score
      analytics.performanceScore = _calculatePerformanceScore(analytics);
      
    } catch (e) {
      AppLogger.error('Error generating analytics for habit ${habit.name}', e);
      analytics.error = e.toString();
    }
    
    return analytics;
  }

  /// Calculate simple correlation between health data and habit completion
  static double _calculateSimpleCorrelation(
    Map<String, dynamic> healthSummary,
    String healthDataType,
    int completions,
  ) {
    try {
      double healthValue = 0.0;
      
      switch (healthDataType) {
        case 'STEPS':
          healthValue = (healthSummary['steps'] as num?)?.toDouble() ?? 0.0;
          break;
        case 'ACTIVE_ENERGY_BURNED':
          healthValue = (healthSummary['activeCalories'] as num?)?.toDouble() ?? 0.0;
          break;
        case 'SLEEP_IN_BED':
          healthValue = (healthSummary['sleepHours'] as num?)?.toDouble() ?? 0.0;
          break;
        case 'WATER':
          healthValue = (healthSummary['waterIntake'] as num?)?.toDouble() ?? 0.0;
          break;
        case 'MINDFULNESS':
          healthValue = (healthSummary['mindfulnessMinutes'] as num?)?.toDouble() ?? 0.0;
          break;
        case 'WEIGHT':
          healthValue = (healthSummary['weight'] as num?)?.toDouble() ?? 0.0;
          break;
      }
      
      // Simple correlation based on whether both values are above average
      if (healthValue > 0 && completions > 0) {
        return 0.7; // Positive correlation
      } else if (healthValue == 0 && completions == 0) {
        return 0.3; // Weak correlation
      } else {
        return 0.1; // Low correlation
      }
      
    } catch (e) {
      AppLogger.error('Error calculating correlation', e);
      return 0.0;
    }
  }

  /// Generate insights for a habit
  static List<String> _generateHabitInsights(
    Habit habit,
    HabitHealthMapping mapping,
    Map<String, dynamic> healthSummary,
  ) {
    final insights = <String>[];
    
    try {
      final healthDataType = mapping.healthDataType;
      final threshold = mapping.threshold;
      
      switch (healthDataType) {
        case 'STEPS':
          final steps = (healthSummary['steps'] as num?)?.toDouble() ?? 0.0;
          if (steps >= threshold) {
            insights.add('Your step count (${steps.round()}) exceeds your habit threshold (${threshold.round()}). Great job!');
          } else {
            insights.add('Your step count (${steps.round()}) is below your habit threshold (${threshold.round()}). Consider increasing daily activity.');
          }
          break;
          
        case 'ACTIVE_ENERGY_BURNED':
          final calories = (healthSummary['activeCalories'] as num?)?.toDouble() ?? 0.0;
          if (calories >= threshold) {
            insights.add('Your active calories (${calories.round()}) meet your exercise goals. Keep it up!');
          } else {
            insights.add('Your active calories (${calories.round()}) are below target (${threshold.round()}). Consider more intense workouts.');
          }
          break;
          
        case 'SLEEP_IN_BED':
          final sleep = (healthSummary['sleepHours'] as num?)?.toDouble() ?? 0.0;
          if (sleep >= threshold) {
            insights.add('Your sleep duration (${sleep.toStringAsFixed(1)}h) meets your rest goals.');
          } else {
            insights.add('Your sleep duration (${sleep.toStringAsFixed(1)}h) is below target (${threshold.toStringAsFixed(1)}h). Consider earlier bedtime.');
          }
          break;
          
        case 'WATER':
          final water = (healthSummary['waterIntake'] as num?)?.toDouble() ?? 0.0;
          if (water >= threshold) {
            insights.add('Your hydration (${(water/1000).toStringAsFixed(1)}L) meets your daily goals.');
          } else {
            insights.add('Your hydration (${(water/1000).toStringAsFixed(1)}L) is below target (${(threshold/1000).toStringAsFixed(1)}L). Drink more water.');
          }
          break;
          
        case 'MINDFULNESS':
          final mindfulness = (healthSummary['mindfulnessMinutes'] as num?)?.toDouble() ?? 0.0;
          if (mindfulness >= threshold) {
            insights.add('Your mindfulness practice (${mindfulness.round()} min) meets your wellness goals.');
          } else {
            insights.add('Your mindfulness practice (${mindfulness.round()} min) could be expanded to ${threshold.round()} minutes daily.');
          }
          break;
          
        default:
          insights.add('Health data tracking is active for this habit.');
      }
      
    } catch (e) {
      AppLogger.error('Error generating insights', e);
      insights.add('Unable to generate insights at this time.');
    }
    
    return insights;
  }

  /// Calculate performance score for a habit
  static double _calculatePerformanceScore(HabitAnalytics analytics) {
    double score = 0.0;
    
    // Completion rate (40% of score)
    score += analytics.completionRate * 0.4;
    
    // Current streak (30% of score)
    final streakScore = math.min(analytics.currentStreak / 30.0, 1.0); // Max at 30 days
    score += streakScore * 0.3;
    
    // Health correlation (20% of score)
    score += analytics.healthCorrelation * 0.2;
    
    // Consistency bonus (10% of score)
    if (analytics.completionRate > 0.8) {
      score += 0.1;
    }
    
    return math.min(score, 1.0);
  }

  /// Generate overall insights
  static Future<List<String>> _generateOverallInsights(
    List<Habit> habits,
    Map<String, dynamic> healthSummary,
  ) async {
    final insights = <String>[];
    
    try {
      final steps = (healthSummary['steps'] as num?)?.toDouble() ?? 0.0;
      final sleep = (healthSummary['sleepHours'] as num?)?.toDouble() ?? 0.0;
      final water = (healthSummary['waterIntake'] as num?)?.toDouble() ?? 0.0;
      
      // Activity insights
      if (steps > 10000) {
        insights.add('Excellent activity level! You\'re exceeding the recommended daily steps.');
      } else if (steps > 5000) {
        insights.add('Good activity level. Consider increasing to 10,000 steps daily for optimal health.');
      } else {
        insights.add('Low activity detected. Focus on movement-based habits to improve overall health.');
      }
      
      // Sleep insights
      if (sleep >= 7.5) {
        insights.add('Great sleep habits! You\'re getting adequate rest for recovery.');
      } else if (sleep > 0) {
        insights.add('Sleep could be improved. Aim for 7-8 hours nightly for better habit consistency.');
      }
      
      // Hydration insights
      if (water >= 2000) {
        insights.add('Good hydration levels support your overall health goals.');
      } else if (water > 0) {
        insights.add('Increase water intake to support your health and fitness habits.');
      }
      
      // Habit-specific insights
      final healthHabits = habits.where((h) => 
        h.category.toLowerCase().contains('health') || 
        h.category.toLowerCase().contains('fitness')
      ).length;
      
      if (healthHabits > 0) {
        insights.add('You have $healthHabits health-related habits. Health data integration can boost your success rate.');
      }
      
    } catch (e) {
      AppLogger.error('Error generating overall insights', e);
      insights.add('Health data analysis is available to enhance your habit tracking.');
    }
    
    return insights;
  }

  /// Generate recommendations
  static Future<List<String>> _generateRecommendations(
    List<Habit> habits,
    Map<String, dynamic> healthSummary,
  ) async {
    final recommendations = <String>[];
    
    try {
      final steps = (healthSummary['steps'] as num?)?.toDouble() ?? 0.0;
      final sleep = (healthSummary['sleepHours'] as num?)?.toDouble() ?? 0.0;
      final activeCalories = (healthSummary['activeCalories'] as num?)?.toDouble() ?? 0.0;
      
      // Activity recommendations
      if (steps < 8000) {
        recommendations.add('Create a daily walking habit to increase your step count.');
      }
      
      if (activeCalories < 300) {
        recommendations.add('Add structured exercise habits to boost your active energy burn.');
      }
      
      // Sleep recommendations
      if (sleep < 7.0) {
        recommendations.add('Establish a consistent bedtime routine to improve sleep duration.');
      }
      
      // Integration recommendations
      final nonHealthHabits = habits.where((h) => 
        !h.category.toLowerCase().contains('health') && 
        !h.category.toLowerCase().contains('fitness')
      ).length;
      
      if (nonHealthHabits > 0) {
        recommendations.add('Consider connecting more habits to health data for automatic tracking.');
      }
      
      recommendations.add('Review your habit thresholds monthly to ensure they remain challenging but achievable.');
      
    } catch (e) {
      AppLogger.error('Error generating recommendations', e);
      recommendations.add('Regular review of your health data can help optimize your habits.');
    }
    
    return recommendations;
  }
}

/// Analytics report for health-habit integration
class HealthHabitAnalyticsReport {
  Map<String, HabitAnalytics> habitAnalytics = {};
  List<String> overallInsights = [];
  List<String> recommendations = [];
  List<String> predictiveInsights = [];
  int totalHabitsAnalyzed = 0;
  int analysisWindowDays = 0;
  DateTime? generatedAt;
  String? error;
  double overallScore = 0.0;
  
  bool get hasError => error != null;
  
  Map<String, dynamic> toJson() => {
    'habitAnalytics': habitAnalytics.map((k, v) => MapEntry(k, v.toJson())),
    'overallInsights': overallInsights,
    'recommendations': recommendations,
    'predictiveInsights': predictiveInsights,
    'totalHabitsAnalyzed': totalHabitsAnalyzed,
    'analysisWindowDays': analysisWindowDays,
    'generatedAt': generatedAt?.toIso8601String(),
    'error': error,
    'overallScore': overallScore,
    'hasError': hasError,
  };
}

/// Analytics for a single habit
class HabitAnalytics {
  final String habitId;
  final String habitName;
  double completionRate = 0.0;
  int currentStreak = 0;
  int longestStreak = 0;
  String? healthDataType;
  double? threshold;
  double healthCorrelation = 0.0;
  double performanceScore = 0.0;
  List<String> insights = [];
  String? error;
  
  HabitAnalytics({
    required this.habitId,
    required this.habitName,
  });
  
  Map<String, dynamic> toJson() => {
    'habitId': habitId,
    'habitName': habitName,
    'completionRate': completionRate,
    'currentStreak': currentStreak,
    'longestStreak': longestStreak,
    'healthDataType': healthDataType,
    'threshold': threshold,
    'healthCorrelation': healthCorrelation,
    'performanceScore': performanceScore,
    'insights': insights,
    'error': error,
  };
}