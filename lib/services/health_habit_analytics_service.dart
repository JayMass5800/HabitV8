import 'dart:math' as math;
import 'package:health/health.dart';
import '../domain/model/habit.dart';
import '../data/database.dart';
import 'health_service.dart';
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
      
      final endDate = DateTime.now();
      final startDate = endDate.subtract(Duration(days: analysisWindowDays));
      
      // Get all habits and health data
      final habits = await habitService.getAllHabits();
      final healthData = await HealthService.getAllHealthData(
        startDate: startDate,
        endDate: endDate,
      );
      
      if (habits.isEmpty) {
        report.error = 'No habits found for analysis';
        return report;
      }
      
      // Perform various analyses
      report.overallScore = await _calculateOverallHealthHabitScore(habits, healthData);
      report.habitAnalyses = await _analyzeIndividualHabits(habits, healthData, startDate, endDate);
      report.correlationMatrix = await _buildCorrelationMatrix(habits, healthData, startDate, endDate);
      report.healthTrends = await _analyzeHealthTrends(healthData, startDate, endDate);
      report.predictiveInsights = await _generatePredictiveInsights(habits, healthData);
      report.optimizationRecommendations = await _generateOptimizationRecommendations(habits, healthData);
      report.benchmarkComparisons = await _generateBenchmarkComparisons(habits, healthData);
      report.streakAnalysis = await _analyzeStreakHealthCorrelations(habits, healthData, startDate, endDate);
      
      report.generatedAt = DateTime.now();
      report.analysisWindowDays = analysisWindowDays;
      
      AppLogger.info('Analytics report generated successfully');
      
    } catch (e) {
      AppLogger.error('Failed to generate analytics report', e);
      report.error = e.toString();
    }
    
    return report;
  }

  /// Calculate overall health-habit integration score (0-100)
  static Future<double> _calculateOverallHealthHabitScore(
    List<Habit> habits,
    List<HealthDataPoint> healthData,
  ) async {
    if (habits.isEmpty) return 0.0;
    
    double totalScore = 0.0;
    int scoredHabits = 0;
    
    for (final habit in habits) {
      final habitScore = await _calculateHabitHealthScore(habit, healthData);
      if (habitScore > 0) {
        totalScore += habitScore;
        scoredHabits++;
      }
    }
    
    if (scoredHabits == 0) return 0.0;
    
    final averageHabitScore = totalScore / scoredHabits;
    
    // Factor in data availability and consistency
    final dataAvailabilityScore = math.min(healthData.length / 100, 1.0) * 20;
    final consistencyScore = _calculateDataConsistency(healthData) * 20;
    
    return math.min(averageHabitScore * 0.6 + dataAvailabilityScore + consistencyScore, 100.0);
  }

  /// Calculate health score for individual habit
  static Future<double> _calculateHabitHealthScore(Habit habit, List<HealthDataPoint> healthData) async {
    double score = 0.0;
    
    try {
      // Base score from completion rate
      final completionRate = habit.completionRate;
      score += completionRate * 40; // Up to 40 points for completion rate
      
      // Bonus points for health data correlation
      final healthCorrelation = await _calculateHabitHealthCorrelation(habit, healthData);
      if (healthCorrelation.abs() > 0.3) {
        score += 20; // 20 points for significant correlation
      } else if (healthCorrelation.abs() > 0.1) {
        score += 10; // 10 points for moderate correlation
      }
      
      // Bonus points for consistency
      final consistencyScore = habit.consistencyScore;
      score += consistencyScore * 0.3; // Up to 30 points for consistency
      
      // Bonus points for streak maintenance
      if (habit.currentStreak > 7) {
        score += 10; // 10 points for week+ streak
      }
      
    } catch (e) {
      AppLogger.error('Error calculating habit health score for ${habit.name}', e);
    }
    
    return math.min(score, 100.0);
  }

  /// Analyze individual habits
  static Future<List<HabitAnalysis>> _analyzeIndividualHabits(
    List<Habit> habits,
    List<HealthDataPoint> healthData,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final analyses = <HabitAnalysis>[];
    
    for (final habit in habits) {
      try {
        final analysis = HabitAnalysis(
          habitId: habit.id,
          habitName: habit.name,
          category: habit.category,
        );
        
        // Basic metrics
        analysis.completionRate = habit.completionRate;
        analysis.currentStreak = habit.currentStreak;
        analysis.longestStreak = habit.longestStreak;
        analysis.consistencyScore = habit.consistencyScore;
        
        // Health correlation
        analysis.healthCorrelation = await _calculateHabitHealthCorrelation(habit, healthData);
        analysis.strongestHealthMetric = await _findStrongestHealthMetric(habit, healthData);
        
        // Performance trends
        analysis.performanceTrend = await _calculatePerformanceTrend(habit, startDate, endDate);
        analysis.healthImpactScore = await _calculateHealthImpactScore(habit, healthData);
        
        // Optimization potential
        analysis.optimizationPotential = await _calculateOptimizationPotential(habit, healthData);
        
        analyses.add(analysis);
        
      } catch (e) {
        AppLogger.error('Error analyzing habit ${habit.name}', e);
      }
    }
    
    return analyses;
  }

  /// Build correlation matrix between habits and health metrics
  static Future<Map<String, Map<String, double>>> _buildCorrelationMatrix(
    List<Habit> habits,
    List<HealthDataPoint> healthData,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final matrix = <String, Map<String, double>>{};
    
    // Group health data by type
    final healthByType = <String, List<HealthDataPoint>>{};
    for (final point in healthData) {
      final typeName = point.type.name;
      if (!healthByType.containsKey(typeName)) {
        healthByType[typeName] = [];
      }
      healthByType[typeName]!.add(point);
    }
    
    // Calculate correlations for each habit
    for (final habit in habits) {
      matrix[habit.id] = {};
      
      for (final entry in healthByType.entries) {
        final healthType = entry.key;
        final healthPoints = entry.value;
        
        final correlation = await _calculateSpecificCorrelation(
          habit: habit,
          healthData: healthPoints,
          healthType: healthType,
          startDate: startDate,
          endDate: endDate,
        );
        
        matrix[habit.id]![healthType] = correlation;
      }
    }
    
    return matrix;
  }

  /// Analyze health trends over time
  static Future<Map<String, HealthTrend>> _analyzeHealthTrends(
    List<HealthDataPoint> healthData,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final trends = <String, HealthTrend>{};
    
    // Group data by type
    final dataByType = <String, List<HealthDataPoint>>{};
    for (final point in healthData) {
      final typeName = point.type.name;
      if (!dataByType.containsKey(typeName)) {
        dataByType[typeName] = [];
      }
      dataByType[typeName]!.add(point);
    }
    
    // Analyze trend for each health metric
    for (final entry in dataByType.entries) {
      final healthType = entry.key;
      final data = entry.value;
      
      if (data.length < 7) continue; // Need at least a week of data
      
      final trend = HealthTrend(healthType: healthType);
      
      // Sort data by date
      data.sort((a, b) => a.dateFrom.compareTo(b.dateFrom));
      
      // Calculate daily averages
      final dailyValues = <DateTime, double>{};
      for (final point in data) {
        final day = DateTime(point.dateFrom.year, point.dateFrom.month, point.dateFrom.day);
        if (point.value is NumericHealthValue) {
          final value = (point.value as NumericHealthValue).numericValue;
          dailyValues[day] = (dailyValues[day] ?? 0) + value;
        }
      }
      
      if (dailyValues.length < 7) continue;
      
      final values = dailyValues.values.toList();
      final dates = dailyValues.keys.toList()..sort();
      
      // Calculate trend metrics
      trend.currentValue = values.last;
      trend.averageValue = values.reduce((a, b) => a + b) / values.length;
      trend.minValue = values.reduce(math.min);
      trend.maxValue = values.reduce(math.max);
      
      // Calculate trend direction and strength
      final firstHalf = values.take(values.length ~/ 2).toList();
      final secondHalf = values.skip(values.length ~/ 2).toList();
      
      final firstAvg = firstHalf.reduce((a, b) => a + b) / firstHalf.length;
      final secondAvg = secondHalf.reduce((a, b) => a + b) / secondHalf.length;
      
      trend.trendDirection = secondAvg > firstAvg ? TrendDirection.increasing : TrendDirection.decreasing;
      trend.trendStrength = ((secondAvg - firstAvg).abs() / firstAvg * 100).clamp(0, 100);
      
      // Calculate volatility
      final variance = values.map((v) => math.pow(v - trend.averageValue, 2)).reduce((a, b) => a + b) / values.length;
      trend.volatility = math.sqrt(variance) / trend.averageValue * 100;
      
      trends[healthType] = trend;
    }
    
    return trends;
  }

  /// Generate predictive insights
  static Future<List<PredictiveInsight>> _generatePredictiveInsights(
    List<Habit> habits,
    List<HealthDataPoint> healthData,
  ) async {
    final insights = <PredictiveInsight>[];
    
    for (final habit in habits) {
      try {
        // Predict completion probability based on current health trends
        final completionProbability = await _predictHabitCompletion(habit, healthData);
        
        if (completionProbability > 0.1) {
          final insight = PredictiveInsight(
            habitId: habit.id,
            habitName: habit.name,
            type: PredictiveInsightType.completionProbability,
            probability: completionProbability,
            confidence: _calculatePredictionConfidence(habit, healthData),
          );
          
          // Generate insight message
          if (completionProbability > 0.8) {
            insight.message = 'Very likely to complete based on current health trends';
          } else if (completionProbability > 0.6) {
            insight.message = 'Good chance of completion with current health patterns';
          } else if (completionProbability > 0.4) {
            insight.message = 'Moderate completion probability - consider health optimization';
          } else {
            insight.message = 'Low completion probability - health metrics suggest challenges';
          }
          
          insights.add(insight);
        }
        
        // Predict optimal timing based on health patterns
        final optimalTiming = await _predictOptimalTiming(habit, healthData);
        if (optimalTiming != null) {
          insights.add(PredictiveInsight(
            habitId: habit.id,
            habitName: habit.name,
            type: PredictiveInsightType.optimalTiming,
            message: 'Optimal completion time: ${optimalTiming.hour}:${optimalTiming.minute.toString().padLeft(2, '0')}',
            confidence: 0.7,
          ));
        }
        
      } catch (e) {
        AppLogger.error('Error generating predictive insights for ${habit.name}', e);
      }
    }
    
    return insights;
  }

  /// Generate optimization recommendations
  static Future<List<OptimizationRecommendation>> _generateOptimizationRecommendations(
    List<Habit> habits,
    List<HealthDataPoint> healthData,
  ) async {
    final recommendations = <OptimizationRecommendation>[];
    
    for (final habit in habits) {
      try {
        final potential = await _calculateOptimizationPotential(habit, healthData);
        
        if (potential > 0.3) {
          final recommendation = OptimizationRecommendation(
            habitId: habit.id,
            habitName: habit.name,
            optimizationPotential: potential,
          );
          
          // Analyze what could be optimized
          final healthCorrelation = await _calculateHabitHealthCorrelation(habit, healthData);
          
          if (healthCorrelation.abs() > 0.3) {
            if (healthCorrelation > 0) {
              recommendation.recommendations.add('Leverage positive health correlation - track related health metrics');
            } else {
              recommendation.recommendations.add('Address negative health correlation - consider timing adjustments');
            }
          }
          
          if (habit.completionRate < 0.7) {
            recommendation.recommendations.add('Focus on consistency - current completion rate is ${(habit.completionRate * 100).round()}%');
          }
          
          if (habit.currentStreak < 7) {
            recommendation.recommendations.add('Build momentum - aim for a 7-day streak to establish routine');
          }
          
          // Health-specific recommendations
          final strongestMetric = await _findStrongestHealthMetric(habit, healthData);
          if (strongestMetric != null) {
            recommendation.recommendations.add('Monitor $strongestMetric - shows strongest correlation with this habit');
          }
          
          if (recommendation.recommendations.isNotEmpty) {
            recommendations.add(recommendation);
          }
        }
        
      } catch (e) {
        AppLogger.error('Error generating optimization recommendations for ${habit.name}', e);
      }
    }
    
    return recommendations;
  }

  /// Generate benchmark comparisons
  static Future<Map<String, BenchmarkComparison>> _generateBenchmarkComparisons(
    List<Habit> habits,
    List<HealthDataPoint> healthData,
  ) async {
    final comparisons = <String, BenchmarkComparison>{};
    
    // Calculate user's overall metrics
    final userMetrics = await _calculateUserMetrics(habits, healthData);
    
    // Compare against ideal benchmarks
    comparisons['completion_rate'] = BenchmarkComparison(
      metric: 'Completion Rate',
      userValue: userMetrics['averageCompletionRate'] ?? 0.0,
      benchmarkValue: 0.8, // 80% is considered excellent
      unit: '%',
    );
    
    comparisons['consistency_score'] = BenchmarkComparison(
      metric: 'Consistency Score',
      userValue: userMetrics['averageConsistencyScore'] ?? 0.0,
      benchmarkValue: 85.0, // 85+ is considered excellent
      unit: 'points',
    );
    
    comparisons['streak_length'] = BenchmarkComparison(
      metric: 'Average Streak Length',
      userValue: userMetrics['averageStreakLength'] ?? 0.0,
      benchmarkValue: 21.0, // 21 days to form a habit
      unit: 'days',
    );
    
    comparisons['health_integration'] = BenchmarkComparison(
      metric: 'Health Integration Score',
      userValue: userMetrics['healthIntegrationScore'] ?? 0.0,
      benchmarkValue: 75.0, // 75+ is considered well-integrated
      unit: 'points',
    );
    
    return comparisons;
  }

  /// Analyze streak-health correlations
  static Future<Map<String, StreakHealthAnalysis>> _analyzeStreakHealthCorrelations(
    List<Habit> habits,
    List<HealthDataPoint> healthData,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final analyses = <String, StreakHealthAnalysis>{};
    
    for (final habit in habits) {
      try {
        final analysis = StreakHealthAnalysis(
          habitId: habit.id,
          habitName: habit.name,
        );
        
        // Analyze how health metrics correlate with streak periods
        final streakPeriods = _identifyStreakPeriods(habit, startDate, endDate);
        
        if (streakPeriods.isNotEmpty) {
          analysis.averageStreakLength = streakPeriods.map((p) => p.length).reduce((a, b) => a + b) / streakPeriods.length;
          analysis.longestStreakLength = streakPeriods.map((p) => p.length).reduce(math.max);
          
          // Analyze health metrics during streak vs non-streak periods
          analysis.healthDuringStreaks = await _analyzeHealthDuringPeriods(streakPeriods, healthData, true);
          analysis.healthDuringBreaks = await _analyzeHealthDuringPeriods(streakPeriods, healthData, false);
          
          // Calculate correlation strength
          analysis.correlationStrength = _calculateStreakHealthCorrelation(
            analysis.healthDuringStreaks,
            analysis.healthDuringBreaks,
          );
        }
        
        analyses[habit.id] = analysis;
        
      } catch (e) {
        AppLogger.error('Error analyzing streak-health correlation for ${habit.name}', e);
      }
    }
    
    return analyses;
  }

  // Helper methods for calculations
  
  static Future<double> _calculateHabitHealthCorrelation(Habit habit, List<HealthDataPoint> healthData) async {
    // Implementation of correlation calculation between habit completions and health data
    // This is a simplified version - you might want to implement more sophisticated correlation analysis
    
    final completionDays = habit.completions
        .map((c) => DateTime(c.year, c.month, c.day))
        .toSet()
        .toList();
    
    if (completionDays.length < 5 || healthData.length < 5) return 0.0;
    
    // Group health data by day
    final healthByDay = <DateTime, double>{};
    for (final point in healthData) {
      final day = DateTime(point.dateFrom.year, point.dateFrom.month, point.dateFrom.day);
      if (point.value is NumericHealthValue) {
        healthByDay[day] = (healthByDay[day] ?? 0) + (point.value as NumericHealthValue).numericValue;
      }
    }
    
    // Calculate correlation (simplified Pearson correlation)
    final commonDays = completionDays.where((day) => healthByDay.containsKey(day)).toList();
    if (commonDays.length < 5) return 0.0;
    
    final habitValues = commonDays.map((day) => 1.0).toList(); // 1 for completion, 0 for non-completion
    final healthValues = commonDays.map((day) => healthByDay[day] ?? 0.0).toList();
    
    return _calculatePearsonCorrelation(habitValues, healthValues);
  }

  static double _calculatePearsonCorrelation(List<double> x, List<double> y) {
    if (x.length != y.length || x.length < 2) return 0.0;
    
    final n = x.length;
    final sumX = x.reduce((a, b) => a + b);
    final sumY = y.reduce((a, b) => a + b);
    final sumXY = List.generate(n, (i) => x[i] * y[i]).reduce((a, b) => a + b);
    final sumX2 = x.map((v) => v * v).reduce((a, b) => a + b);
    final sumY2 = y.map((v) => v * v).reduce((a, b) => a + b);
    
    final numerator = n * sumXY - sumX * sumY;
    final denominator = math.sqrt((n * sumX2 - sumX * sumX) * (n * sumY2 - sumY * sumY));
    
    if (denominator == 0) return 0.0;
    return numerator / denominator;
  }

  static double _calculateDataConsistency(List<HealthDataPoint> healthData) {
    if (healthData.isEmpty) return 0.0;
    
    // Group by day and calculate consistency
    final dailyData = <DateTime, int>{};
    for (final point in healthData) {
      final day = DateTime(point.dateFrom.year, point.dateFrom.month, point.dateFrom.day);
      dailyData[day] = (dailyData[day] ?? 0) + 1;
    }
    
    if (dailyData.length < 7) return 0.0;
    
    final values = dailyData.values.toList();
    final average = values.reduce((a, b) => a + b) / values.length;
    final variance = values.map((v) => math.pow(v - average, 2)).reduce((a, b) => a + b) / values.length;
    final standardDeviation = math.sqrt(variance);
    
    // Lower standard deviation = higher consistency
    return math.max(0, 1 - (standardDeviation / average)).clamp(0, 1);
  }

  static Future<String?> _findStrongestHealthMetric(Habit habit, List<HealthDataPoint> healthData) async {
    final correlations = <String, double>{};
    
    // Group health data by type
    final dataByType = <String, List<HealthDataPoint>>{};
    for (final point in healthData) {
      final typeName = point.type.name;
      if (!dataByType.containsKey(typeName)) {
        dataByType[typeName] = [];
      }
      dataByType[typeName]!.add(point);
    }
    
    // Calculate correlation for each type
    for (final entry in dataByType.entries) {
      final correlation = await _calculateSpecificCorrelation(
        habit: habit,
        healthData: entry.value,
        healthType: entry.key,
        startDate: DateTime.now().subtract(const Duration(days: 30)),
        endDate: DateTime.now(),
      );
      correlations[entry.key] = correlation.abs();
    }
    
    if (correlations.isEmpty) return null;
    
    final strongest = correlations.entries.reduce((a, b) => a.value > b.value ? a : b);
    return strongest.value > 0.1 ? strongest.key : null;
  }

  static Future<double> _calculateSpecificCorrelation({
    required Habit habit,
    required List<HealthDataPoint> healthData,
    required String healthType,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    // Similar to _calculateHabitHealthCorrelation but for specific health type
    return await _calculateHabitHealthCorrelation(habit, healthData);
  }

  static Future<double> _calculatePerformanceTrend(Habit habit, DateTime startDate, DateTime endDate) async {
    // Calculate if habit performance is improving, stable, or declining
    final completions = habit.completions
        .where((c) => c.isAfter(startDate) && c.isBefore(endDate))
        .toList()
        ..sort();
    
    if (completions.length < 14) return 0.0; // Need at least 2 weeks of data
    
    final midpoint = completions.length ~/ 2;
    final firstHalf = completions.take(midpoint).toList();
    final secondHalf = completions.skip(midpoint).toList();
    
    final firstHalfRate = firstHalf.length / (midpoint * 1.0);
    final secondHalfRate = secondHalf.length / ((completions.length - midpoint) * 1.0);
    
    return (secondHalfRate - firstHalfRate) * 100; // Percentage change
  }

  static Future<double> _calculateHealthImpactScore(Habit habit, List<HealthDataPoint> healthData) async {
    final correlation = await _calculateHabitHealthCorrelation(habit, healthData);
    return correlation.abs() * 100; // Convert to 0-100 scale
  }

  static Future<double> _calculateOptimizationPotential(Habit habit, List<HealthDataPoint> healthData) async {
    double potential = 0.0;
    
    // Higher potential if completion rate is low but health correlation exists
    if (habit.completionRate < 0.8) {
      potential += (0.8 - habit.completionRate) * 0.5;
    }
    
    // Higher potential if there's unused health correlation
    final correlation = await _calculateHabitHealthCorrelation(habit, healthData);
    if (correlation.abs() > 0.3) {
      potential += 0.3;
    }
    
    // Higher potential if consistency is low
    if (habit.consistencyScore < 80) {
      potential += (80 - habit.consistencyScore) / 100 * 0.2;
    }
    
    return math.min(potential, 1.0);
  }

  static Future<double> _predictHabitCompletion(Habit habit, List<HealthDataPoint> healthData) async {
    // Simple prediction based on current trends and health data
    double probability = habit.completionRate; // Base probability
    
    // Adjust based on current streak
    if (habit.currentStreak > 0) {
      probability += 0.1; // Bonus for active streak
    }
    
    // Adjust based on health correlation
    final correlation = await _calculateHabitHealthCorrelation(habit, healthData);
    if (correlation > 0.3) {
      probability += 0.2; // Bonus for positive health correlation
    }
    
    return math.min(probability, 1.0);
  }

  static double _calculatePredictionConfidence(Habit habit, List<HealthDataPoint> healthData) {
    // Confidence based on data availability and consistency
    double confidence = 0.5; // Base confidence
    
    if (habit.completions.length > 30) {
      confidence += 0.2; // More data = higher confidence
    }
    
    if (healthData.length > 50) {
      confidence += 0.2; // More health data = higher confidence
    }
    
    if (habit.consistencyScore > 70) {
      confidence += 0.1; // Consistent habits are more predictable
    }
    
    return math.min(confidence, 1.0);
  }

  static Future<DateTime?> _predictOptimalTiming(Habit habit, List<HealthDataPoint> healthData) async {
    // Analyze completion times to find optimal timing
    final completionTimes = habit.completions.map((c) => TimeOfDay(hour: c.hour, minute: c.minute)).toList();
    
    if (completionTimes.length < 10) return null;
    
    // Find most common completion time
    final timeFrequency = <String, int>{};
    for (final time in completionTimes) {
      final key = '${time.hour}:${time.minute}';
      timeFrequency[key] = (timeFrequency[key] ?? 0) + 1;
    }
    
    final mostCommon = timeFrequency.entries.reduce((a, b) => a.value > b.value ? a : b);
    final parts = mostCommon.key.split(':');
    
    return DateTime(2024, 1, 1, int.parse(parts[0]), int.parse(parts[1]));
  }

  static Future<Map<String, dynamic>> _calculateUserMetrics(List<Habit> habits, List<HealthDataPoint> healthData) async {
    final metrics = <String, dynamic>{};
    
    if (habits.isNotEmpty) {
      metrics['averageCompletionRate'] = habits.map((h) => h.completionRate).reduce((a, b) => a + b) / habits.length;
      metrics['averageConsistencyScore'] = habits.map((h) => h.consistencyScore).reduce((a, b) => a + b) / habits.length;
      metrics['averageStreakLength'] = habits.map((h) => h.currentStreak.toDouble()).reduce((a, b) => a + b) / habits.length;
    }
    
    // Calculate health integration score
    int healthMappedHabits = 0;
    for (final habit in habits) {
      final correlation = await _calculateHabitHealthCorrelation(habit, healthData);
      if (correlation.abs() > 0.1) {
        healthMappedHabits++;
      }
    }
    
    metrics['healthIntegrationScore'] = habits.isNotEmpty ? 
        (healthMappedHabits / habits.length * 100) : 0.0;
    
    return metrics;
  }

  static List<StreakPeriod> _identifyStreakPeriods(Habit habit, DateTime startDate, DateTime endDate) {
    final periods = <StreakPeriod>[];
    
    final completions = habit.completions
        .where((c) => c.isAfter(startDate) && c.isBefore(endDate))
        .map((c) => DateTime(c.year, c.month, c.day))
        .toSet()
        .toList()
        ..sort();
    
    if (completions.isEmpty) return periods;
    
    DateTime? streakStart;
    DateTime? lastCompletion;
    
    for (final completion in completions) {
      if (streakStart == null) {
        streakStart = completion;
        lastCompletion = completion;
      } else if (completion.difference(lastCompletion!).inDays == 1) {
        // Continue streak
        lastCompletion = completion;
      } else {
        // End current streak
        if (lastCompletion!.difference(streakStart).inDays >= 2) { // At least 3 days
          periods.add(StreakPeriod(start: streakStart, end: lastCompletion));
        }
        streakStart = completion;
        lastCompletion = completion;
      }
    }
    
    // Add final streak if exists
    if (streakStart != null && lastCompletion != null && 
        lastCompletion.difference(streakStart).inDays >= 2) {
      periods.add(StreakPeriod(start: streakStart, end: lastCompletion));
    }
    
    return periods;
  }

  static Future<Map<String, double>> _analyzeHealthDuringPeriods(
    List<StreakPeriod> periods,
    List<HealthDataPoint> healthData,
    bool duringStreaks,
  ) async {
    final metrics = <String, double>{};
    
    // Group health data by type
    final dataByType = <String, List<HealthDataPoint>>{};
    for (final point in healthData) {
      final typeName = point.type.name;
      if (!dataByType.containsKey(typeName)) {
        dataByType[typeName] = [];
      }
      dataByType[typeName]!.add(point);
    }
    
    // Calculate averages for each health type during specified periods
    for (final entry in dataByType.entries) {
      final healthType = entry.key;
      final data = entry.value;
      
      final relevantData = <double>[];
      
      for (final point in data) {
        final pointDate = DateTime(point.dateFrom.year, point.dateFrom.month, point.dateFrom.day);
        
        bool isInPeriod = false;
        for (final period in periods) {
          if (pointDate.isAfter(period.start.subtract(const Duration(days: 1))) &&
              pointDate.isBefore(period.end.add(const Duration(days: 1)))) {
            isInPeriod = true;
            break;
          }
        }
        
        if (isInPeriod == duringStreaks && point.value is NumericHealthValue) {
          relevantData.add((point.value as NumericHealthValue).numericValue);
        }
      }
      
      if (relevantData.isNotEmpty) {
        metrics[healthType] = relevantData.reduce((a, b) => a + b) / relevantData.length;
      }
    }
    
    return metrics;
  }

  static double _calculateStreakHealthCorrelation(
    Map<String, double> healthDuringStreaks,
    Map<String, double> healthDuringBreaks,
  ) {
    if (healthDuringStreaks.isEmpty || healthDuringBreaks.isEmpty) return 0.0;
    
    double totalCorrelation = 0.0;
    int count = 0;
    
    for (final healthType in healthDuringStreaks.keys) {
      if (healthDuringBreaks.containsKey(healthType)) {
        final streakValue = healthDuringStreaks[healthType]!;
        final breakValue = healthDuringBreaks[healthType]!;
        
        // Simple correlation: positive if health is better during streaks
        final correlation = (streakValue - breakValue) / math.max(streakValue, breakValue);
        totalCorrelation += correlation;
        count++;
      }
    }
    
    return count > 0 ? totalCorrelation / count : 0.0;
  }
}

// Data classes for analytics

class HealthHabitAnalyticsReport {
  double overallScore = 0.0;
  List<HabitAnalysis> habitAnalyses = [];
  Map<String, Map<String, double>> correlationMatrix = {};
  Map<String, HealthTrend> healthTrends = {};
  List<PredictiveInsight> predictiveInsights = [];
  List<OptimizationRecommendation> optimizationRecommendations = [];
  Map<String, BenchmarkComparison> benchmarkComparisons = {};
  Map<String, StreakHealthAnalysis> streakAnalysis = {};
  
  DateTime? generatedAt;
  int analysisWindowDays = 0;
  String? error;
  
  bool get hasError => error != null;
  bool get isValid => !hasError && habitAnalyses.isNotEmpty;
}

class HabitAnalysis {
  final String habitId;
  final String habitName;
  final String category;
  
  double completionRate = 0.0;
  int currentStreak = 0;
  int longestStreak = 0;
  double consistencyScore = 0.0;
  double healthCorrelation = 0.0;
  String? strongestHealthMetric;
  double performanceTrend = 0.0;
  double healthImpactScore = 0.0;
  double optimizationPotential = 0.0;
  
  HabitAnalysis({
    required this.habitId,
    required this.habitName,
    required this.category,
  });
}

class HealthTrend {
  final String healthType;
  double currentValue = 0.0;
  double averageValue = 0.0;
  double minValue = 0.0;
  double maxValue = 0.0;
  TrendDirection trendDirection = TrendDirection.stable;
  double trendStrength = 0.0;
  double volatility = 0.0;
  
  HealthTrend({required this.healthType});
}

enum TrendDirection { increasing, decreasing, stable }

class PredictiveInsight {
  final String habitId;
  final String habitName;
  final PredictiveInsightType type;
  double probability = 0.0;
  double confidence = 0.0;
  String message = '';
  
  PredictiveInsight({
    required this.habitId,
    required this.habitName,
    required this.type,
    this.probability = 0.0,
    this.confidence = 0.0,
    this.message = '',
  });
}

enum PredictiveInsightType { completionProbability, optimalTiming, riskAssessment }

class OptimizationRecommendation {
  final String habitId;
  final String habitName;
  double optimizationPotential = 0.0;
  List<String> recommendations = [];
  
  OptimizationRecommendation({
    required this.habitId,
    required this.habitName,
    this.optimizationPotential = 0.0,
  });
}

class BenchmarkComparison {
  final String metric;
  final double userValue;
  final double benchmarkValue;
  final String unit;
  
  BenchmarkComparison({
    required this.metric,
    required this.userValue,
    required this.benchmarkValue,
    required this.unit,
  });
  
  double get percentageOfBenchmark => (userValue / benchmarkValue * 100).clamp(0, 200);
  bool get exceedsBenchmark => userValue >= benchmarkValue;
  double get gap => benchmarkValue - userValue;
}

class StreakHealthAnalysis {
  final String habitId;
  final String habitName;
  double averageStreakLength = 0.0;
  int longestStreakLength = 0;
  Map<String, double> healthDuringStreaks = {};
  Map<String, double> healthDuringBreaks = {};
  double correlationStrength = 0.0;
  
  StreakHealthAnalysis({
    required this.habitId,
    required this.habitName,
  });
}

class StreakPeriod {
  final DateTime start;
  final DateTime end;
  
  StreakPeriod({required this.start, required this.end});
  
  int get length => end.difference(start).inDays + 1;
}

class TimeOfDay {
  final int hour;
  final int minute;
  
  TimeOfDay({required this.hour, required this.minute});
}