import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'package:shared_preferences/shared_preferences.dart';
import '../data/database.dart';
import '../domain/model/habit.dart';
import 'logging_service.dart';
import 'automatic_habit_completion_service.dart';

/// Smart Threshold Service
///
/// This service implements adaptive thresholds that learn from user behavior
/// patterns to improve automatic habit completion accuracy. It analyzes:
/// - User's actual health data patterns over time
/// - Manual completion vs auto-completion patterns
/// - False positive and false negative rates
/// - Seasonal and weekly patterns
/// - Individual user's baseline fitness levels
class SmartThresholdService {
  static const String _thresholdDataKey = 'smart_threshold_data';
  static const String _learningDataKey = 'threshold_learning_data';
  static const String _lastAnalysisKey = 'last_threshold_analysis';
  static const String _userBaselineKey = 'user_baseline_data';

  // Learning parameters
  static const int _minDataPointsForLearning =
      7; // Need at least a week of data
  static const int _maxHistoryDays = 90; // Analyze last 3 months
  static const double _confidenceThreshold =
      0.7; // Minimum confidence for threshold adjustment
  static const double _maxThresholdAdjustment =
      0.3; // Max 30% adjustment per update

  /// Initialize smart thresholds for a habit
  static Future<void> initializeHabitThresholds(String habitId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final thresholdData = await _getThresholdData();

      if (!thresholdData.containsKey(habitId)) {
        thresholdData[habitId] = {
          'initialized': DateTime.now().millisecondsSinceEpoch,
          'adjustments': <Map<String, dynamic>>[],
          'baseline': null,
          'confidence': 0.0,
          'lastUpdate': DateTime.now().millisecondsSinceEpoch,
        };

        await _saveThresholdData(thresholdData);
        AppLogger.info('Initialized smart thresholds for habit: $habitId');
      }
    } catch (e) {
      AppLogger.error(
          'Error initializing smart thresholds for habit $habitId', e);
    }
  }

  /// Get adaptive threshold for a habit based on learned patterns
  static Future<SmartThresholdResult> getAdaptiveThreshold({
    required String habitId,
    required String healthDataType,
    required double originalThreshold,
    required DateTime date,
  }) async {
    try {
      // Check if smart thresholds are enabled
      final isEnabled =
          await AutomaticHabitCompletionService.isSmartThresholdsEnabled();
      if (!isEnabled) {
        return SmartThresholdResult(
          threshold: originalThreshold,
          confidence: 1.0,
          reason: 'Smart thresholds disabled',
          isAdapted: false,
        );
      }

      final thresholdData = await _getThresholdData();
      final habitData = thresholdData[habitId];

      if (habitData == null) {
        await initializeHabitThresholds(habitId);
        return SmartThresholdResult(
          threshold: originalThreshold,
          confidence: 0.5,
          reason: 'Insufficient learning data',
          isAdapted: false,
        );
      }

      // Get user's baseline for this health data type
      final baseline = await _getUserBaseline(healthDataType);
      if (baseline == null) {
        return SmartThresholdResult(
          threshold: originalThreshold,
          confidence: 0.5,
          reason: 'No baseline established',
          isAdapted: false,
        );
      }

      // Calculate adaptive threshold based on patterns
      final adaptiveThreshold = await _calculateAdaptiveThreshold(
        habitId: habitId,
        healthDataType: healthDataType,
        originalThreshold: originalThreshold,
        baseline: baseline,
        date: date,
      );

      return adaptiveThreshold;
    } catch (e) {
      AppLogger.error('Error getting adaptive threshold for habit $habitId', e);
      return SmartThresholdResult(
        threshold: originalThreshold,
        confidence: 0.0,
        reason: 'Error calculating adaptive threshold',
        isAdapted: false,
      );
    }
  }

  /// Learn from completion patterns to improve thresholds
  static Future<void> learnFromCompletion({
    required String habitId,
    required String healthDataType,
    required double healthValue,
    required double usedThreshold,
    required bool wasAutoCompleted,
    required bool wasManuallyCompleted,
    required DateTime date,
  }) async {
    try {
      final isEnabled =
          await AutomaticHabitCompletionService.isSmartThresholdsEnabled();
      if (!isEnabled) return;

      final learningData = await _getLearningData();
      final habitLearning = learningData[habitId] ?? <Map<String, dynamic>>[];

      // Add new learning point
      habitLearning.add({
        'date': date.millisecondsSinceEpoch,
        'healthDataType': healthDataType,
        'healthValue': healthValue,
        'usedThreshold': usedThreshold,
        'wasAutoCompleted': wasAutoCompleted,
        'wasManuallyCompleted': wasManuallyCompleted,
        'dayOfWeek': date.weekday,
        'hourOfDay': date.hour,
      });

      // Keep only recent data points
      final cutoffDate =
          DateTime.now().subtract(Duration(days: _maxHistoryDays));
      habitLearning.removeWhere((point) {
        final pointDate = DateTime.fromMillisecondsSinceEpoch(point['date']);
        return pointDate.isBefore(cutoffDate);
      });

      learningData[habitId] = habitLearning;
      await _saveLearningData(learningData);

      // Update user baseline
      await _updateUserBaseline(healthDataType, healthValue, date);

      // Trigger threshold analysis if we have enough data
      if (habitLearning.length >= _minDataPointsForLearning) {
        await _analyzeAndUpdateThreshold(habitId, healthDataType);
      }

      AppLogger.info(
          'Learned from completion for habit $habitId: value=$healthValue, threshold=$usedThreshold, auto=$wasAutoCompleted, manual=$wasManuallyCompleted');
    } catch (e) {
      AppLogger.error('Error learning from completion for habit $habitId', e);
    }
  }

  /// Analyze patterns and update threshold if needed
  static Future<void> _analyzeAndUpdateThreshold(
      String habitId, String healthDataType) async {
    try {
      final learningData = await _getLearningData();
      final habitLearning = learningData[habitId] ?? <Map<String, dynamic>>[];

      if (habitLearning.length < _minDataPointsForLearning) return;

      // Analyze false positives and false negatives
      final analysis = _analyzeCompletionPatterns(habitLearning);

      if (analysis.confidence < _confidenceThreshold) {
        AppLogger.info(
            'Threshold analysis confidence too low for habit $habitId: ${analysis.confidence}');
        return;
      }

      // Calculate recommended threshold adjustment
      final currentThreshold = _getCurrentThreshold(habitLearning);
      final recommendedThreshold =
          _calculateRecommendedThreshold(analysis, currentThreshold);

      // Apply conservative adjustment
      final maxAdjustment = currentThreshold * _maxThresholdAdjustment;
      final adjustment = (recommendedThreshold - currentThreshold)
          .clamp(-maxAdjustment, maxAdjustment);
      final newThreshold = currentThreshold + adjustment;

      // Update threshold data
      final thresholdData = await _getThresholdData();
      final habitData = thresholdData[habitId] ?? <String, dynamic>{};

      final adjustments =
          List<Map<String, dynamic>>.from(habitData['adjustments'] ?? []);
      adjustments.add({
        'date': DateTime.now().millisecondsSinceEpoch,
        'oldThreshold': currentThreshold,
        'newThreshold': newThreshold,
        'reason': analysis.reason,
        'confidence': analysis.confidence,
        'falsePositiveRate': analysis.falsePositiveRate,
        'falseNegativeRate': analysis.falseNegativeRate,
      });

      habitData['adjustments'] = adjustments;
      habitData['currentThreshold'] = newThreshold;
      habitData['confidence'] = analysis.confidence;
      habitData['lastUpdate'] = DateTime.now().millisecondsSinceEpoch;

      thresholdData[habitId] = habitData;
      await _saveThresholdData(thresholdData);

      AppLogger.info(
          'Updated smart threshold for habit $habitId: $currentThreshold -> $newThreshold (confidence: ${analysis.confidence})');
    } catch (e) {
      AppLogger.error(
          'Error analyzing and updating threshold for habit $habitId', e);
    }
  }

  /// Calculate adaptive threshold based on current context
  static Future<SmartThresholdResult> _calculateAdaptiveThreshold({
    required String habitId,
    required String healthDataType,
    required double originalThreshold,
    required UserBaseline baseline,
    required DateTime date,
  }) async {
    final thresholdData = await _getThresholdData();
    final habitData = thresholdData[habitId];

    if (habitData == null) {
      return SmartThresholdResult(
        threshold: originalThreshold,
        confidence: 0.0,
        reason: 'No habit data available',
        isAdapted: false,
      );
    }

    double adaptiveThreshold =
        habitData['currentThreshold']?.toDouble() ?? originalThreshold;
    final confidence = habitData['confidence']?.toDouble() ?? 0.0;

    // Apply contextual adjustments
    adaptiveThreshold = _applyContextualAdjustments(
      threshold: adaptiveThreshold,
      baseline: baseline,
      date: date,
      healthDataType: healthDataType,
    );

    // Apply weekly pattern adjustments
    adaptiveThreshold = await _applyWeeklyPatternAdjustments(
      habitId: habitId,
      threshold: adaptiveThreshold,
      date: date,
    );

    return SmartThresholdResult(
      threshold: adaptiveThreshold,
      confidence: confidence,
      reason: 'Adapted based on learned patterns',
      isAdapted: adaptiveThreshold != originalThreshold,
    );
  }

  /// Apply contextual adjustments based on time and user patterns
  static double _applyContextualAdjustments({
    required double threshold,
    required UserBaseline baseline,
    required DateTime date,
    required String healthDataType,
  }) {
    double adjustedThreshold = threshold;

    // Weekend vs weekday adjustments
    final isWeekend = date.weekday >= 6;
    if (isWeekend && baseline.weekendMultiplier != null) {
      adjustedThreshold *= baseline.weekendMultiplier!;
    }

    // Time of day adjustments for certain metrics
    if (healthDataType == 'STEPS' || healthDataType == 'ACTIVE_ENERGY_BURNED') {
      final hour = date.hour;
      if (hour < 12) {
        // Morning - might be lower activity
        adjustedThreshold *= 0.9;
      } else if (hour > 18) {
        // Evening - might have accumulated more activity
        adjustedThreshold *= 1.1;
      }
    }

    // Seasonal adjustments (basic implementation)
    final month = date.month;
    if (healthDataType == 'STEPS') {
      if (month >= 12 || month <= 2) {
        // Winter - potentially less outdoor activity
        adjustedThreshold *= 0.95;
      } else if (month >= 6 && month <= 8) {
        // Summer - potentially more outdoor activity
        adjustedThreshold *= 1.05;
      }
    }

    return adjustedThreshold;
  }

  /// Apply weekly pattern adjustments
  static Future<double> _applyWeeklyPatternAdjustments({
    required String habitId,
    required double threshold,
    required DateTime date,
  }) async {
    try {
      final learningData = await _getLearningData();
      final habitLearning = learningData[habitId] ?? <Map<String, dynamic>>[];

      if (habitLearning.length < 14) return threshold; // Need at least 2 weeks

      // Calculate average health values by day of week
      final dayAverages = <int, List<double>>{};
      for (final point in habitLearning) {
        final dayOfWeek = point['dayOfWeek'] as int;
        final healthValue = (point['healthValue'] as num).toDouble();
        dayAverages.putIfAbsent(dayOfWeek, () => []).add(healthValue);
      }

      // Calculate multiplier for current day of week
      final currentDayOfWeek = date.weekday;
      final currentDayValues = dayAverages[currentDayOfWeek];
      if (currentDayValues == null || currentDayValues.isEmpty)
        return threshold;

      final currentDayAverage =
          currentDayValues.reduce((a, b) => a + b) / currentDayValues.length;

      // Calculate overall average
      final allValues = dayAverages.values.expand((list) => list).toList();
      final overallAverage =
          allValues.reduce((a, b) => a + b) / allValues.length;

      // Apply conservative adjustment based on day-of-week pattern
      final dayMultiplier =
          (currentDayAverage / overallAverage).clamp(0.8, 1.2);
      return threshold * dayMultiplier;
    } catch (e) {
      AppLogger.error('Error applying weekly pattern adjustments', e);
      return threshold;
    }
  }

  /// Analyze completion patterns to identify issues
  static ThresholdAnalysis _analyzeCompletionPatterns(
      List<Map<String, dynamic>> learningData) {
    int falsePositives = 0; // Auto-completed but not manually completed
    int falseNegatives = 0; // Not auto-completed but manually completed
    int truePositives = 0; // Auto-completed and manually completed
    int trueNegatives = 0; // Not auto-completed and not manually completed

    final healthValues = <double>[];
    final thresholds = <double>[];

    for (final point in learningData) {
      final wasAutoCompleted = point['wasAutoCompleted'] as bool;
      final wasManuallyCompleted = point['wasManuallyCompleted'] as bool;
      final healthValue = (point['healthValue'] as num).toDouble();
      final usedThreshold = (point['usedThreshold'] as num).toDouble();

      healthValues.add(healthValue);
      thresholds.add(usedThreshold);

      if (wasAutoCompleted && wasManuallyCompleted) {
        truePositives++;
      } else if (wasAutoCompleted && !wasManuallyCompleted) {
        falsePositives++;
      } else if (!wasAutoCompleted && wasManuallyCompleted) {
        falseNegatives++;
      } else {
        trueNegatives++;
      }
    }

    final total =
        falsePositives + falseNegatives + truePositives + trueNegatives;
    if (total == 0) {
      return ThresholdAnalysis(
        falsePositiveRate: 0.0,
        falseNegativeRate: 0.0,
        confidence: 0.0,
        reason: 'No data available',
      );
    }

    final falsePositiveRate = falsePositives / total;
    final falseNegativeRate = falseNegatives / total;
    final accuracy = (truePositives + trueNegatives) / total;

    // Calculate confidence based on data amount and accuracy
    final dataConfidence = math.min(
        learningData.length / 30.0, 1.0); // More data = higher confidence
    final accuracyConfidence = accuracy;
    final confidence = (dataConfidence * accuracyConfidence);

    String reason = 'Analysis complete';
    if (falsePositiveRate > 0.2) {
      reason = 'High false positive rate - threshold may be too low';
    } else if (falseNegativeRate > 0.2) {
      reason = 'High false negative rate - threshold may be too high';
    } else if (accuracy > 0.8) {
      reason = 'Good accuracy - minor adjustments only';
    }

    return ThresholdAnalysis(
      falsePositiveRate: falsePositiveRate,
      falseNegativeRate: falseNegativeRate,
      confidence: confidence,
      reason: reason,
    );
  }

  /// Calculate recommended threshold based on analysis
  static double _calculateRecommendedThreshold(
      ThresholdAnalysis analysis, double currentThreshold) {
    if (analysis.falsePositiveRate > 0.2) {
      // Too many false positives - increase threshold
      return currentThreshold * (1.0 + (analysis.falsePositiveRate * 0.5));
    } else if (analysis.falseNegativeRate > 0.2) {
      // Too many false negatives - decrease threshold
      return currentThreshold * (1.0 - (analysis.falseNegativeRate * 0.5));
    }

    // Minor adjustments for fine-tuning
    final adjustment =
        (analysis.falsePositiveRate - analysis.falseNegativeRate) * 0.1;
    return currentThreshold * (1.0 + adjustment);
  }

  /// Get current threshold from learning data
  static double _getCurrentThreshold(List<Map<String, dynamic>> learningData) {
    if (learningData.isEmpty) return 0.0;

    // Use the most recent threshold
    learningData.sort((a, b) => (b['date'] as int).compareTo(a['date'] as int));
    return (learningData.first['usedThreshold'] as num).toDouble();
  }

  /// Update user baseline data
  static Future<void> _updateUserBaseline(
      String healthDataType, double value, DateTime date) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final baselineData = prefs.getString(_userBaselineKey);
      final baselines = baselineData != null
          ? Map<String, dynamic>.from(await _parseJson(baselineData))
          : <String, dynamic>{};

      final typeBaseline = baselines[healthDataType] ??
          <String, dynamic>{
            'values': <double>[],
            'weekendValues': <double>[],
            'weekdayValues': <double>[],
            'lastUpdate': 0,
          };

      final values = List<double>.from(typeBaseline['values'] ?? []);
      final weekendValues =
          List<double>.from(typeBaseline['weekendValues'] ?? []);
      final weekdayValues =
          List<double>.from(typeBaseline['weekdayValues'] ?? []);

      values.add(value);
      if (date.weekday >= 6) {
        weekendValues.add(value);
      } else {
        weekdayValues.add(value);
      }

      // Keep only recent values (last 90 days worth)
      if (values.length > 90) {
        values.removeRange(0, values.length - 90);
      }
      if (weekendValues.length > 26) {
        // ~3 months of weekends
        weekendValues.removeRange(0, weekendValues.length - 26);
      }
      if (weekdayValues.length > 65) {
        // ~3 months of weekdays
        weekdayValues.removeRange(0, weekdayValues.length - 65);
      }

      typeBaseline['values'] = values;
      typeBaseline['weekendValues'] = weekendValues;
      typeBaseline['weekdayValues'] = weekdayValues;
      typeBaseline['lastUpdate'] = DateTime.now().millisecondsSinceEpoch;

      baselines[healthDataType] = typeBaseline;
      await prefs.setString(_userBaselineKey, await _stringifyJson(baselines));
    } catch (e) {
      AppLogger.error('Error updating user baseline for $healthDataType', e);
    }
  }

  /// Get user baseline for health data type
  static Future<UserBaseline?> _getUserBaseline(String healthDataType) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final baselineData = prefs.getString(_userBaselineKey);
      if (baselineData == null) return null;

      final baselines =
          Map<String, dynamic>.from(await _parseJson(baselineData));
      final typeBaseline = baselines[healthDataType];
      if (typeBaseline == null) return null;

      final values = List<double>.from(typeBaseline['values'] ?? []);
      final weekendValues =
          List<double>.from(typeBaseline['weekendValues'] ?? []);
      final weekdayValues =
          List<double>.from(typeBaseline['weekdayValues'] ?? []);

      if (values.isEmpty) return null;

      final average = values.reduce((a, b) => a + b) / values.length;
      final weekendAverage = weekendValues.isNotEmpty
          ? weekendValues.reduce((a, b) => a + b) / weekendValues.length
          : null;
      final weekdayAverage = weekdayValues.isNotEmpty
          ? weekdayValues.reduce((a, b) => a + b) / weekdayValues.length
          : null;

      double? weekendMultiplier;
      if (weekendAverage != null &&
          weekdayAverage != null &&
          weekdayAverage > 0) {
        weekendMultiplier = weekendAverage / weekdayAverage;
      }

      return UserBaseline(
        healthDataType: healthDataType,
        average: average,
        weekendMultiplier: weekendMultiplier,
        dataPoints: values.length,
      );
    } catch (e) {
      AppLogger.error('Error getting user baseline for $healthDataType', e);
      return null;
    }
  }

  /// Get threshold data from storage
  static Future<Map<String, dynamic>> _getThresholdData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString(_thresholdDataKey);
      return data != null
          ? Map<String, dynamic>.from(await _parseJson(data))
          : <String, dynamic>{};
    } catch (e) {
      AppLogger.error('Error getting threshold data', e);
      return <String, dynamic>{};
    }
  }

  /// Save threshold data to storage
  static Future<void> _saveThresholdData(Map<String, dynamic> data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_thresholdDataKey, await _stringifyJson(data));
    } catch (e) {
      AppLogger.error('Error saving threshold data', e);
    }
  }

  /// Get learning data from storage
  static Future<Map<String, List<Map<String, dynamic>>>>
      _getLearningData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString(_learningDataKey);
      if (data == null) return <String, List<Map<String, dynamic>>>{};

      final parsed = Map<String, dynamic>.from(await _parseJson(data));
      final result = <String, List<Map<String, dynamic>>>{};

      for (final entry in parsed.entries) {
        result[entry.key] = List<Map<String, dynamic>>.from(
            (entry.value as List)
                .map((item) => Map<String, dynamic>.from(item)));
      }

      return result;
    } catch (e) {
      AppLogger.error('Error getting learning data', e);
      return <String, List<Map<String, dynamic>>>{};
    }
  }

  /// Save learning data to storage
  static Future<void> _saveLearningData(
      Map<String, List<Map<String, dynamic>>> data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_learningDataKey, await _stringifyJson(data));
    } catch (e) {
      AppLogger.error('Error saving learning data', e);
    }
  }

  /// Get smart threshold statistics
  static Future<Map<String, dynamic>> getSmartThresholdStats() async {
    try {
      final thresholdData = await _getThresholdData();
      final learningData = await _getLearningData();

      int totalHabits = thresholdData.length;
      int habitsWithAdjustments = 0;
      int totalAdjustments = 0;
      double averageConfidence = 0.0;

      for (final habitData in thresholdData.values) {
        final adjustments = habitData['adjustments'] as List? ?? [];
        if (adjustments.isNotEmpty) {
          habitsWithAdjustments++;
          totalAdjustments += adjustments.length;
        }
        averageConfidence +=
            (habitData['confidence'] as num?)?.toDouble() ?? 0.0;
      }

      if (totalHabits > 0) {
        averageConfidence /= totalHabits;
      }

      int totalLearningPoints = 0;
      for (final points in learningData.values) {
        totalLearningPoints += points.length;
      }

      return {
        'totalHabits': totalHabits,
        'habitsWithAdjustments': habitsWithAdjustments,
        'totalAdjustments': totalAdjustments,
        'averageConfidence': averageConfidence,
        'totalLearningPoints': totalLearningPoints,
        'isEnabled':
            await AutomaticHabitCompletionService.isSmartThresholdsEnabled(),
      };
    } catch (e) {
      AppLogger.error('Error getting smart threshold stats', e);
      return {'error': e.toString()};
    }
  }

  /// Reset smart thresholds for a habit
  static Future<void> resetHabitThresholds(String habitId) async {
    try {
      final thresholdData = await _getThresholdData();
      final learningData = await _getLearningData();

      thresholdData.remove(habitId);
      learningData.remove(habitId);

      await _saveThresholdData(thresholdData);
      await _saveLearningData(learningData);

      AppLogger.info('Reset smart thresholds for habit: $habitId');
    } catch (e) {
      AppLogger.error('Error resetting smart thresholds for habit $habitId', e);
    }
  }

  /// Helper methods for JSON parsing
  static Future<Map<String, dynamic>> _parseJson(String jsonString) async {
    try {
      return Map<String, dynamic>.from(json.decode(jsonString));
    } catch (e) {
      AppLogger.error('Error parsing JSON: $jsonString', e);
      return <String, dynamic>{};
    }
  }

  static Future<String> _stringifyJson(Map<String, dynamic> data) async {
    try {
      return json.encode(data);
    } catch (e) {
      AppLogger.error('Error stringifying JSON', e);
      return '{}';
    }
  }
}

/// Result of smart threshold calculation
class SmartThresholdResult {
  final double threshold;
  final double confidence;
  final String reason;
  final bool isAdapted;

  SmartThresholdResult({
    required this.threshold,
    required this.confidence,
    required this.reason,
    required this.isAdapted,
  });
}

/// User baseline data for a health metric
class UserBaseline {
  final String healthDataType;
  final double average;
  final double? weekendMultiplier;
  final int dataPoints;

  UserBaseline({
    required this.healthDataType,
    required this.average,
    this.weekendMultiplier,
    required this.dataPoints,
  });
}

/// Analysis of threshold performance
class ThresholdAnalysis {
  final double falsePositiveRate;
  final double falseNegativeRate;
  final double confidence;
  final String reason;

  ThresholdAnalysis({
    required this.falsePositiveRate,
    required this.falseNegativeRate,
    required this.confidence,
    required this.reason,
  });
}
