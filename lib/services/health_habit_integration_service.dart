import 'dart:async';
import 'dart:math' as math;
import 'package:health/health.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/model/habit.dart';
import '../data/database.dart';
import 'health_service.dart';
import 'health_habit_mapping_service.dart';
import 'logging_service.dart';
import 'notification_service.dart';

/// Comprehensive Health-Habit Integration Service
/// 
/// This service provides deep integration between health metrics and habit tracking:
/// - Automatic habit completion based on health data
/// - Health-habit correlation analysis
/// - Smart health-based habit recommendations
/// - Real-time health monitoring for habit validation
/// - Predictive habit completion suggestions
class HealthHabitIntegrationService {
  static const String _lastHealthSyncKey = 'last_health_sync';
  static const String _healthHabitMappingsKey = 'health_habit_mappings';
  static const String _autoCompletionEnabledKey = 'auto_completion_enabled';
  static const String _healthThresholdsKey = 'health_thresholds';
  
  // Health data thresholds for automatic habit completion
  static const Map<String, Map<String, dynamic>> _defaultHealthThresholds = {
    'STEPS': {
      'daily_walk': 8000,
      'morning_walk': 3000,
      'evening_walk': 3000,
      'exercise': 10000,
    },
    'ACTIVE_ENERGY_BURNED': {
      'workout': 300, // calories
      'cardio': 200,
      'exercise': 250,
      'gym': 400,
    },
    'SLEEP_IN_BED': {
      'sleep': 7.0, // hours
      'rest': 6.5,
      'bedtime': 8.0,
    },
    'WATER': {
      'hydration': 2000, // ml
      'drink_water': 1500,
      'water_intake': 2500,
    },
    'MINDFULNESS': {
      'meditation': 10, // minutes
      'mindfulness': 5,
      'breathing': 3,
      'relaxation': 15,
    },
    'WEIGHT': {
      'weight_tracking': 0.1, // any weight entry counts
      'weigh_in': 0.1,
    },
  };

  /// Initialize the health-habit integration service
  static Future<bool> initialize() async {
    try {
      AppLogger.info('Initializing Health-Habit Integration Service...');
      
      // Initialize health service first
      final healthInitialized = await HealthService.initialize();
      if (!healthInitialized) {
        AppLogger.warning('Health service not initialized, continuing with limited functionality');
      }
      
      // Set up default thresholds if not exists
      await _initializeDefaultThresholds();
      
      // Enable auto-completion by default
      final prefs = await SharedPreferences.getInstance();
      if (!prefs.containsKey(_autoCompletionEnabledKey)) {
        await prefs.setBool(_autoCompletionEnabledKey, true);
      }
      
      AppLogger.info('Health-Habit Integration Service initialized successfully');
      return true;
    } catch (e) {
      AppLogger.error('Failed to initialize Health-Habit Integration Service', e);
      return false;
    }
  }

  /// Set up default health thresholds
  static Future<void> _initializeDefaultThresholds() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (!prefs.containsKey(_healthThresholdsKey)) {
        final thresholdsJson = <String, String>{};
        _defaultHealthThresholds.forEach((key, value) {
          thresholdsJson[key] = value.toString();
        });
        await prefs.setString(_healthThresholdsKey, thresholdsJson.toString());
      }
    } catch (e) {
      AppLogger.error('Failed to initialize default thresholds', e);
    }
  }

  /// Enable or disable automatic habit completion
  static Future<void> setAutoCompletionEnabled(bool enabled) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_autoCompletionEnabledKey, enabled);
      AppLogger.info('Auto-completion ${enabled ? 'enabled' : 'disabled'}');
    } catch (e) {
      AppLogger.error('Failed to set auto-completion preference', e);
    }
  }

  /// Check if auto-completion is enabled
  static Future<bool> isAutoCompletionEnabled() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_autoCompletionEnabledKey) ?? true;
    } catch (e) {
      AppLogger.error('Failed to get auto-completion preference', e);
      return false;
    }
  }

  /// Perform comprehensive health-habit sync
  /// This is the main method that should be called periodically
  static Future<HealthHabitSyncResult> performHealthHabitSync({
    required HabitService habitService,
    bool forceSync = false,
  }) async {
    final result = HealthHabitSyncResult();
    
    try {
      AppLogger.info('Starting comprehensive health-habit sync...');
      
      // Check if auto-completion is enabled
      final autoCompletionEnabled = await isAutoCompletionEnabled();
      if (!autoCompletionEnabled && !forceSync) {
        AppLogger.info('Auto-completion disabled, skipping sync');
        return result;
      }
      
      // Check if we need to sync (avoid too frequent syncs)
      if (!forceSync && !await _shouldPerformSync()) {
        AppLogger.info('Sync not needed at this time');
        return result;
      }
      
      // Get all active habits and filter for health-related categories only
      final allHabits = await habitService.getActiveHabits();
      final habits = allHabits.where((habit) => 
        habit.category == 'Health' || habit.category == 'Fitness'
      ).toList();
      if (habits.isEmpty) {
        AppLogger.info('No active health or fitness habits found');
        return result;
      }
      
      // Get today's health data
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));
      
      final healthData = await HealthService.getAllHealthData(
        startDate: startOfDay,
        endDate: endOfDay,
      );
      
      if (healthData.isEmpty) {
        AppLogger.info('No health data available for today');
        return result;
      }
      
      // Process each habit for potential auto-completion
      for (final habit in habits) {
        try {
          final completionResult = await _processHabitForAutoCompletion(
            habit: habit,
            healthData: healthData,
            habitService: habitService,
          );
          
          if (completionResult.completed) {
            result.completedHabits.add(completionResult);
          }
          
          // Analyze habit-health correlation
          final correlation = await _analyzeHabitHealthCorrelation(
            habit: habit,
            healthData: healthData,
          );
          result.correlations[habit.id] = correlation;
          
        } catch (e) {
          AppLogger.error('Error processing habit ${habit.name}', e);
        }
      }
      
      // Update last sync time
      await _updateLastSyncTime();
      
      // Generate health insights for habits
      result.insights = await _generateHealthHabitInsights(habits, healthData);
      
      AppLogger.info('Health-habit sync completed: ${result.completedHabits.length} habits auto-completed');
      
      // Send notification if habits were completed
      if (result.completedHabits.isNotEmpty) {
        await _sendAutoCompletionNotification(result.completedHabits);
      }
      
    } catch (e) {
      AppLogger.error('Failed to perform health-habit sync', e);
      result.error = e.toString();
    }
    
    return result;
  }

  /// Process a single habit for potential auto-completion using advanced mapping
  static Future<HabitCompletionResult> _processHabitForAutoCompletion({
    required Habit habit,
    required List<HealthDataPoint> healthData,
    required HabitService habitService,
  }) async {
    final result = HabitCompletionResult(
      habitId: habit.id,
      habitName: habit.name,
      completed: false,
    );
    
    try {
      // Skip if already completed today
      if (habit.isCompletedToday) {
        result.reason = 'Already completed today';
        return result;
      }
      
      // Use the advanced mapping service to check for completion
      final completionCheck = await HealthHabitMappingService.checkHabitCompletion(
        habit: habit,
        date: DateTime.now(),
      );
      
      if (completionCheck.shouldComplete) {
        // Auto-complete the habit
        await habitService.markHabitComplete(habit.id, DateTime.now());
        
        result.completed = true;
        result.reason = completionCheck.reason;
        result.healthDataType = completionCheck.healthDataType?.name;
        result.healthValue = completionCheck.healthValue;
        result.threshold = completionCheck.threshold;
        result.confidence = completionCheck.confidence;
        
        AppLogger.info('Auto-completed habit "${habit.name}": ${completionCheck.reason}');
      } else {
        result.reason = completionCheck.reason;
      }
      
    } catch (e) {
      AppLogger.error('Error processing habit ${habit.name} for auto-completion', e);
      result.error = e.toString();
    }
    
    return result;
  }

  /// Get health data type mapping for a habit based on its name and category
  static Map<String, dynamic> _getHealthMappingForHabit(Habit habit) {
    final mapping = <String, dynamic>{};
    final habitName = habit.name.toLowerCase();
    final habitCategory = habit.category.toLowerCase();
    
    // Steps-based habits
    if (habitName.contains('walk') || habitName.contains('step') || 
        habitName.contains('run') || habitName.contains('jog') ||
        habitCategory.contains('fitness') || habitCategory.contains('exercise')) {
      
      if (habitName.contains('morning')) {
        mapping['STEPS'] = _defaultHealthThresholds['STEPS']!['morning_walk'];
      } else if (habitName.contains('evening')) {
        mapping['STEPS'] = _defaultHealthThresholds['STEPS']!['evening_walk'];
      } else if (habitName.contains('exercise') || habitName.contains('workout')) {
        mapping['STEPS'] = _defaultHealthThresholds['STEPS']!['exercise'];
      } else {
        mapping['STEPS'] = _defaultHealthThresholds['STEPS']!['daily_walk'];
      }
    }
    
    // Active energy-based habits
    if (habitName.contains('workout') || habitName.contains('exercise') || 
        habitName.contains('gym') || habitName.contains('cardio') ||
        habitName.contains('training')) {
      
      if (habitName.contains('cardio')) {
        mapping['ACTIVE_ENERGY_BURNED'] = _defaultHealthThresholds['ACTIVE_ENERGY_BURNED']!['cardio'];
      } else if (habitName.contains('gym')) {
        mapping['ACTIVE_ENERGY_BURNED'] = _defaultHealthThresholds['ACTIVE_ENERGY_BURNED']!['gym'];
      } else {
        mapping['ACTIVE_ENERGY_BURNED'] = _defaultHealthThresholds['ACTIVE_ENERGY_BURNED']!['workout'];
      }
    }
    
    // Sleep-based habits
    if (habitName.contains('sleep') || habitName.contains('bed') || 
        habitName.contains('rest') || habitCategory.contains('sleep')) {
      
      if (habitName.contains('bedtime')) {
        mapping['SLEEP_IN_BED'] = _defaultHealthThresholds['SLEEP_IN_BED']!['bedtime'];
      } else {
        mapping['SLEEP_IN_BED'] = _defaultHealthThresholds['SLEEP_IN_BED']!['sleep'];
      }
    }
    
    // Water-based habits
    if (habitName.contains('water') || habitName.contains('hydrat') || 
        habitName.contains('drink') || habitCategory.contains('hydration')) {
      
      if (habitName.contains('hydration')) {
        mapping['WATER'] = _defaultHealthThresholds['WATER']!['hydration'];
      } else {
        mapping['WATER'] = _defaultHealthThresholds['WATER']!['drink_water'];
      }
    }
    
    // Mindfulness-based habits
    if (habitName.contains('meditat') || habitName.contains('mindful') || 
        habitName.contains('breathing') || habitName.contains('relax') ||
        habitCategory.contains('mental') || habitCategory.contains('wellness')) {
      
      if (habitName.contains('breathing')) {
        mapping['MINDFULNESS'] = _defaultHealthThresholds['MINDFULNESS']!['breathing'];
      } else if (habitName.contains('relax')) {
        mapping['MINDFULNESS'] = _defaultHealthThresholds['MINDFULNESS']!['relaxation'];
      } else {
        mapping['MINDFULNESS'] = _defaultHealthThresholds['MINDFULNESS']!['meditation'];
      }
    }
    
    // Weight-based habits
    if (habitName.contains('weight') || habitName.contains('weigh') || 
        habitCategory.contains('weight')) {
      mapping['WEIGHT'] = _defaultHealthThresholds['WEIGHT']!['weight_tracking'];
    }
    
    return mapping;
  }

  /// Check if health data meets the threshold for habit completion
  static ThresholdResult _checkHealthThreshold({
    required String healthType,
    required List<HealthDataPoint> healthData,
    required dynamic threshold,
  }) {
    final result = ThresholdResult(meets: false, value: 0);
    
    try {
      switch (healthType) {
        case 'STEPS':
          int totalSteps = 0;
          for (var point in healthData) {
            if (point.value is NumericHealthValue) {
              totalSteps += (point.value as NumericHealthValue).numericValue.toInt();
            }
          }
          result.value = totalSteps;
          result.meets = totalSteps >= (threshold as int);
          break;
          
        case 'ACTIVE_ENERGY_BURNED':
          double totalEnergy = 0;
          for (var point in healthData) {
            if (point.value is NumericHealthValue) {
              totalEnergy += (point.value as NumericHealthValue).numericValue;
            }
          }
          result.value = totalEnergy.round();
          result.meets = totalEnergy >= (threshold as int);
          break;
          
        case 'SLEEP_IN_BED':
          double totalSleep = 0;
          for (var point in healthData) {
            if (point.value is NumericHealthValue) {
              totalSleep += (point.value as NumericHealthValue).numericValue;
            }
          }
          result.value = (totalSleep * 100).round() / 100; // Round to 2 decimals
          result.meets = totalSleep >= (threshold as double);
          break;
          
        case 'WATER':
          double totalWater = 0;
          for (var point in healthData) {
            if (point.value is NumericHealthValue) {
              totalWater += (point.value as NumericHealthValue).numericValue;
            }
          }
          result.value = totalWater.round();
          result.meets = totalWater >= (threshold as int);
          break;
          
        case 'MINDFULNESS':
          double totalMindfulness = 0;
          for (var point in healthData) {
            if (point.value is NumericHealthValue) {
              totalMindfulness += (point.value as NumericHealthValue).numericValue;
            }
          }
          result.value = totalMindfulness.round();
          result.meets = totalMindfulness >= (threshold as int);
          break;
          
        case 'WEIGHT':
          // For weight, any entry counts as completion
          result.meets = healthData.isNotEmpty;
          if (healthData.isNotEmpty && healthData.first.value is NumericHealthValue) {
            result.value = (healthData.first.value as NumericHealthValue).numericValue;
          }
          break;
      }
    } catch (e) {
      AppLogger.error('Error checking health threshold for $healthType', e);
    }
    
    return result;
  }

  /// Analyze correlation between habit completion and health metrics
  static Future<HabitHealthCorrelation> _analyzeHabitHealthCorrelation({
    required Habit habit,
    required List<HealthDataPoint> healthData,
  }) async {
    final correlation = HabitHealthCorrelation(
      habitId: habit.id,
      correlations: {},
    );
    
    try {
      // Get habit completion history for the last 30 days
      final now = DateTime.now();
      final thirtyDaysAgo = now.subtract(const Duration(days: 30));
      
      final completionDays = habit.completions
          .where((completion) => completion.isAfter(thirtyDaysAgo))
          .map((completion) => DateTime(completion.year, completion.month, completion.day))
          .toSet()
          .toList();
      
      if (completionDays.length < 5) {
        // Not enough data for meaningful correlation
        return correlation;
      }
      
      // Analyze correlation with each health metric
      final healthDataByType = <String, List<HealthDataPoint>>{};
      for (var point in healthData) {
        final typeName = point.type.name;
        if (!healthDataByType.containsKey(typeName)) {
          healthDataByType[typeName] = [];
        }
        healthDataByType[typeName]!.add(point);
      }
      
      for (final entry in healthDataByType.entries) {
        final healthType = entry.key;
        final data = entry.value;
        
        final correlationValue = _calculateCorrelation(
          completionDays: completionDays,
          healthData: data,
          healthType: healthType,
        );
        
        correlation.correlations[healthType] = correlationValue;
      }
      
    } catch (e) {
      AppLogger.error('Error analyzing habit-health correlation', e);
    }
    
    return correlation;
  }

  /// Calculate correlation coefficient between habit completions and health metric
  static double _calculateCorrelation({
    required List<DateTime> completionDays,
    required List<HealthDataPoint> healthData,
    required String healthType,
  }) {
    try {
      // Group health data by day
      final healthByDay = <DateTime, double>{};
      for (var point in healthData) {
        final day = DateTime(point.dateFrom.year, point.dateFrom.month, point.dateFrom.day);
        if (point.value is NumericHealthValue) {
          healthByDay[day] = (healthByDay[day] ?? 0) + 
              (point.value as NumericHealthValue).numericValue;
        }
      }
      
      if (healthByDay.length < 5) return 0.0;
      
      // Create paired data for correlation calculation
      final pairs = <MapEntry<double, double>>[];
      for (final day in healthByDay.keys) {
        final habitCompleted = completionDays.contains(day) ? 1.0 : 0.0;
        final healthValue = healthByDay[day] ?? 0.0;
        pairs.add(MapEntry(habitCompleted, healthValue));
      }
      
      if (pairs.length < 5) return 0.0;
      
      // Calculate Pearson correlation coefficient
      final n = pairs.length;
      final sumX = pairs.map((p) => p.key).reduce((a, b) => a + b);
      final sumY = pairs.map((p) => p.value).reduce((a, b) => a + b);
      final sumXY = pairs.map((p) => p.key * p.value).reduce((a, b) => a + b);
      final sumX2 = pairs.map((p) => p.key * p.key).reduce((a, b) => a + b);
      final sumY2 = pairs.map((p) => p.value * p.value).reduce((a, b) => a + b);
      
      final numerator = n * sumXY - sumX * sumY;
      final denominator = math.sqrt((n * sumX2 - sumX * sumX) * (n * sumY2 - sumY * sumY));
      
      if (denominator == 0) return 0.0;
      
      return numerator / denominator;
    } catch (e) {
      AppLogger.error('Error calculating correlation', e);
      return 0.0;
    }
  }

  /// Generate comprehensive health-habit insights
  static Future<Map<String, dynamic>> _generateHealthHabitInsights(
    List<Habit> habits,
    List<HealthDataPoint> healthData,
  ) async {
    final insights = <String, dynamic>{};
    
    try {
      // Overall health-habit integration score
      final integrationScore = _calculateIntegrationScore(habits, healthData);
      insights['integrationScore'] = integrationScore;
      
      // Health-driven habit suggestions
      final suggestions = await _generateHealthDrivenSuggestions(healthData);
      insights['suggestions'] = suggestions;
      
      // Health trend analysis
      final trends = _analyzeHealthTrends(healthData);
      insights['trends'] = trends;
      
      // Habit completion predictions
      final predictions = _generateCompletionPredictions(habits, healthData);
      insights['predictions'] = predictions;
      
    } catch (e) {
      AppLogger.error('Error generating health-habit insights', e);
    }
    
    return insights;
  }

  /// Calculate overall health-habit integration score (0-100)
  static double _calculateIntegrationScore(List<Habit> habits, List<HealthDataPoint> healthData) {
    if (habits.isEmpty || healthData.isEmpty) return 0.0;
    
    int healthMappedHabits = 0;
    for (final habit in habits) {
      final mapping = _getHealthMappingForHabit(habit);
      if (mapping.isNotEmpty) {
        healthMappedHabits++;
      }
    }
    
    final mappingScore = (healthMappedHabits / habits.length) * 50;
    final dataAvailabilityScore = math.min(healthData.length / 10, 1.0) * 50;
    
    return mappingScore + dataAvailabilityScore;
  }

  /// Generate health-driven habit suggestions
  static Future<List<String>> _generateHealthDrivenSuggestions(List<HealthDataPoint> healthData) async {
    final suggestions = <String>[];
    
    try {
      final healthSummary = await HealthService.getTodayHealthSummary();
      
      // Steps-based suggestions
      final steps = healthSummary['steps'] ?? 0;
      if (steps < 8000) {
        suggestions.add('Consider adding a "Daily Walk" habit - you\'re at $steps steps today');
      }
      
      // Sleep-based suggestions
      final sleepHours = healthSummary['averageSleepHours'] ?? 8.0;
      if (sleepHours < 7.0) {
        suggestions.add('Add an "Earlier Bedtime" habit - averaging ${sleepHours.toStringAsFixed(1)} hours');
      }
      
      // Water-based suggestions
      final water = healthSummary['waterIntake'] ?? 0;
      if (water < 2000) {
        suggestions.add('Create a "Hydration" habit - only ${water.round()}ml consumed today');
      }
      
      // Mindfulness-based suggestions
      final mindfulness = healthSummary['mindfulnessMinutes'] ?? 0;
      if (mindfulness < 10) {
        suggestions.add('Try a "Daily Meditation" habit - ${mindfulness.round()} minutes today');
      }
      
    } catch (e) {
      AppLogger.error('Error generating health-driven suggestions', e);
    }
    
    return suggestions;
  }

  /// Analyze health trends for insights
  static Map<String, dynamic> _analyzeHealthTrends(List<HealthDataPoint> healthData) {
    final trends = <String, dynamic>{};
    
    try {
      // Group data by type and analyze trends
      final dataByType = <String, List<HealthDataPoint>>{};
      for (var point in healthData) {
        final typeName = point.type.name;
        if (!dataByType.containsKey(typeName)) {
          dataByType[typeName] = [];
        }
        dataByType[typeName]!.add(point);
      }
      
      for (final entry in dataByType.entries) {
        final type = entry.key;
        final data = entry.value;
        
        if (data.length >= 2) {
          // Calculate simple trend (increasing/decreasing)
          final values = data
              .where((point) => point.value is NumericHealthValue)
              .map((point) => (point.value as NumericHealthValue).numericValue)
              .toList();
          
          if (values.length >= 2) {
            final firstHalf = values.take(values.length ~/ 2).toList();
            final secondHalf = values.skip(values.length ~/ 2).toList();
            
            final firstAvg = firstHalf.reduce((a, b) => a + b) / firstHalf.length;
            final secondAvg = secondHalf.reduce((a, b) => a + b) / secondHalf.length;
            
            final trendDirection = secondAvg > firstAvg ? 'increasing' : 'decreasing';
            final trendStrength = ((secondAvg - firstAvg).abs() / firstAvg * 100).round();
            
            trends[type] = {
              'direction': trendDirection,
              'strength': trendStrength,
              'current': secondAvg.round(),
            };
          }
        }
      }
      
    } catch (e) {
      AppLogger.error('Error analyzing health trends', e);
    }
    
    return trends;
  }

  /// Generate habit completion predictions based on health data
  static Map<String, dynamic> _generateCompletionPredictions(
    List<Habit> habits,
    List<HealthDataPoint> healthData,
  ) {
    final predictions = <String, dynamic>{};
    
    try {
      for (final habit in habits) {
        if (habit.isCompletedToday) continue;
        
        final mapping = _getHealthMappingForHabit(habit);
        if (mapping.isEmpty) continue;
        
        double completionProbability = 0.0;
        String reason = '';
        
        for (final entry in mapping.entries) {
          final healthType = entry.key;
          final threshold = entry.value;
          
          final relevantData = healthData.where((point) => 
            point.type.name == healthType).toList();
          
          if (relevantData.isNotEmpty) {
            final thresholdResult = _checkHealthThreshold(
              healthType: healthType,
              healthData: relevantData,
              threshold: threshold,
            );
            
            if (thresholdResult.meets) {
              completionProbability = 1.0;
              reason = 'Already meets threshold';
              break;
            } else {
              // Calculate probability based on current progress
              final progress = thresholdResult.value / threshold;
              completionProbability = math.max(completionProbability, math.min(progress, 0.9));
              reason = 'Progress: ${(progress * 100).round()}%';
            }
          }
        }
        
        if (completionProbability > 0.1) {
          predictions[habit.id] = {
            'habitName': habit.name,
            'probability': (completionProbability * 100).round(),
            'reason': reason,
          };
        }
      }
      
    } catch (e) {
      AppLogger.error('Error generating completion predictions', e);
    }
    
    return predictions;
  }

  /// Check if sync should be performed based on time and conditions
  static Future<bool> _shouldPerformSync() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastSync = prefs.getInt(_lastHealthSyncKey) ?? 0;
      final now = DateTime.now().millisecondsSinceEpoch;
      
      // Sync at most every 30 minutes
      const syncInterval = 30 * 60 * 1000; // 30 minutes in milliseconds
      
      return (now - lastSync) >= syncInterval;
    } catch (e) {
      AppLogger.error('Error checking sync timing', e);
      return true; // Default to allowing sync
    }
  }

  /// Update the last sync time
  static Future<void> _updateLastSyncTime() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_lastHealthSyncKey, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      AppLogger.error('Error updating last sync time', e);
    }
  }

  /// Send notification about auto-completed habits
  static Future<void> _sendAutoCompletionNotification(
    List<HabitCompletionResult> completedHabits,
  ) async {
    try {
      if (completedHabits.length == 1) {
        await NotificationService.showNotification(
          id: 9999,
          title: 'Habit Auto-Completed! 🎉',
          body: 'Great job! "${completedHabits.first.habitName}" was completed based on your health data.',
        );
      } else {
        await NotificationService.showNotification(
          id: 9999,
          title: 'Habits Auto-Completed! 🎉',
          body: '${completedHabits.length} habits completed based on your health data.',
        );
      }
    } catch (e) {
      AppLogger.error('Error sending auto-completion notification', e);
    }
  }

  /// Get detailed health-habit integration status
  static Future<Map<String, dynamic>> getIntegrationStatus({
    required HabitService habitService,
  }) async {
    final status = <String, dynamic>{};
    
    try {
      final allHabits = await habitService.getActiveHabits();
      // Filter for health and fitness habits only
      final habits = allHabits.where((habit) => 
        habit.category == 'Health' || habit.category == 'Fitness'
      ).toList();
      final healthPermissions = await HealthService.hasPermissions();
      final autoCompletionEnabled = await isAutoCompletionEnabled();
      
      int healthMappedHabits = 0;
      final habitMappings = <String, dynamic>{};
      
      // Use the new mapping service for better analysis
      final mappableHabits = await HealthHabitMappingService.getMappableHabits(habits);
      healthMappedHabits = mappableHabits.length;
      
      for (final mapping in mappableHabits) {
        final habit = habits.firstWhere((h) => h.id == mapping.habitId);
        habitMappings[habit.id] = {
          'name': habit.name,
          'healthDataType': mapping.healthDataType.name,
          'threshold': mapping.threshold,
          'unit': mapping.unit,
          'relevanceScore': mapping.relevanceScore,
        };
      }
      
      status['totalHabits'] = habits.length;
      status['totalAllHabits'] = allHabits.length; // Keep track of all habits for reference
      status['healthMappedHabits'] = healthMappedHabits;
      status['mappingPercentage'] = habits.isNotEmpty ? 
          (healthMappedHabits / habits.length * 100).round() : 0;
      status['healthPermissions'] = healthPermissions;
      status['autoCompletionEnabled'] = autoCompletionEnabled;
      status['habitMappings'] = habitMappings;
      
      // Get recent sync info
      final prefs = await SharedPreferences.getInstance();
      final lastSync = prefs.getInt(_lastHealthSyncKey) ?? 0;
      status['lastSyncTime'] = lastSync;
      status['lastSyncDate'] = lastSync > 0 ? 
          DateTime.fromMillisecondsSinceEpoch(lastSync).toIso8601String() : null;
      
    } catch (e) {
      AppLogger.error('Error getting integration status', e);
      status['error'] = e.toString();
    }
    
    return status;
  }

  /// Manually trigger health-habit sync
  static Future<HealthHabitSyncResult> manualSync({
    required HabitService habitService,
  }) async {
    AppLogger.info('Manual health-habit sync triggered');
    return await performHealthHabitSync(
      habitService: habitService,
      forceSync: true,
    );
  }

  /// Update health thresholds for specific habit types
  static Future<void> updateHealthThresholds(Map<String, Map<String, dynamic>> newThresholds) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_healthThresholdsKey, newThresholds.toString());
      AppLogger.info('Health thresholds updated');
    } catch (e) {
      AppLogger.error('Error updating health thresholds', e);
    }
  }

  /// Get current health thresholds
  static Future<Map<String, Map<String, dynamic>>> getHealthThresholds() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final thresholdsString = prefs.getString(_healthThresholdsKey);
      if (thresholdsString != null) {
        // Parse the stored thresholds
        // For now, return default thresholds
        return _defaultHealthThresholds;
      }
    } catch (e) {
      AppLogger.error('Error getting health thresholds', e);
    }
    
    return _defaultHealthThresholds;
  }
}

/// Result of health-habit sync operation
class HealthHabitSyncResult {
  final List<HabitCompletionResult> completedHabits = [];
  final Map<String, HabitHealthCorrelation> correlations = {};
  Map<String, dynamic> insights = {};
  String? error;
  
  bool get hasError => error != null;
  bool get hasCompletions => completedHabits.isNotEmpty;
  int get completionCount => completedHabits.length;
}

/// Result of individual habit completion check
class HabitCompletionResult {
  final String habitId;
  final String habitName;
  bool completed;
  String? reason;
  String? healthDataType;
  dynamic healthValue;
  dynamic threshold;
  double confidence;
  String? error;
  
  HabitCompletionResult({
    required this.habitId,
    required this.habitName,
    required this.completed,
    this.reason,
    this.healthDataType,
    this.healthValue,
    this.threshold,
    this.confidence = 0.0,
    this.error,
  });
}

/// Correlation analysis between habit and health metrics
class HabitHealthCorrelation {
  final String habitId;
  final Map<String, double> correlations;
  
  HabitHealthCorrelation({
    required this.habitId,
    required this.correlations,
  });
  
  /// Get the strongest correlation
  MapEntry<String, double>? get strongestCorrelation {
    if (correlations.isEmpty) return null;
    
    return correlations.entries.reduce((a, b) => 
        a.value.abs() > b.value.abs() ? a : b);
  }
  
  /// Get correlations above a threshold
  Map<String, double> getSignificantCorrelations({double threshold = 0.3}) {
    return Map.fromEntries(
      correlations.entries.where((entry) => entry.value.abs() >= threshold)
    );
  }
}

/// Result of threshold checking
class ThresholdResult {
  bool meets;
  dynamic value;
  
  ThresholdResult({required this.meets, required this.value});
}