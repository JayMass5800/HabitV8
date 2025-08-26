import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/model/habit.dart';
import '../data/database.dart';
import 'health_service.dart';
import 'health_habit_mapping_service.dart';
import 'logging_service.dart';
import 'notification_service.dart';

/// Simple health data point replacement to avoid health package dependency
class HealthDataPoint {
  final String type;
  final double value;
  final DateTime timestamp;
  final String unit;

  HealthDataPoint({
    required this.type,
    required this.value,
    required this.timestamp,
    required this.unit,
  });

  factory HealthDataPoint.fromMap(Map<String, dynamic> map) {
    return HealthDataPoint(
      type: map['type'] ?? '',
      value: (map['value'] as num?)?.toDouble() ?? 0.0,
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] ?? 0),
      unit: map['unit'] ?? '',
    );
  }
}

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
        AppLogger.warning(
          'Health service not initialized, continuing with limited functionality',
        );
      }

      // Ensure we have all necessary health permissions, including heart rate
      final hasPermissions = await HealthService.hasPermissions();
      if (!hasPermissions) {
        AppLogger.info(
          'Health permissions not granted, requesting permissions...',
        );
        final permissionResult = await HealthService.requestPermissions();
        if (permissionResult.granted) {
          AppLogger.info(
            'Health permissions successfully granted during integration service initialization',
          );
        } else {
          AppLogger.warning(
            'Failed to grant health permissions during integration service initialization',
          );
        }
      }

      // Set up default thresholds if not exists
      await _initializeDefaultThresholds();

      // Enable auto-completion by default
      final prefs = await SharedPreferences.getInstance();
      if (!prefs.containsKey(_autoCompletionEnabledKey)) {
        await prefs.setBool(_autoCompletionEnabledKey, true);
      }

      // Verify heart rate access specifically (with delay to prevent immediate crashes)
      try {
        // Add delay to prevent immediate method channel calls after permission grant
        await Future.delayed(const Duration(seconds: 2));

        final heartRate = await HealthService.getLatestHeartRate().timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            AppLogger.warning('Heart rate verification timed out');
            return null;
          },
        );
        if (heartRate != null) {
          AppLogger.info(
            'Heart rate access verified: ${heartRate.round()} bpm',
          );
        } else {
          AppLogger.info(
            'No heart rate data available, but access appears to be granted',
          );
        }
      } catch (e) {
        AppLogger.warning('Heart rate access verification failed: $e');
      }

      AppLogger.info(
        'Health-Habit Integration Service initialized successfully',
      );
      return true;
    } catch (e) {
      AppLogger.error(
        'Failed to initialize Health-Habit Integration Service',
        e,
      );
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

      // Get all active habits and filter for health-mappable habits
      final allHabits = await habitService.getActiveHabits();
      final mappableHabits = await HealthHabitMappingService.getMappableHabits(
        allHabits,
      );
      final habits = allHabits
          .where(
            (habit) =>
                mappableHabits.any((mapping) => mapping.habitId == habit.id),
          )
          .toList();
      if (habits.isEmpty) {
        AppLogger.info('No active health-mappable habits found');
        return result;
      }

      // Get today's health data
      final healthSummary = await HealthService.getTodayHealthSummary();

      if (healthSummary.containsKey('error')) {
        AppLogger.info('No health data available for today');
        return result;
      }

      // Process each habit for potential auto-completion
      for (final habit in habits) {
        try {
          final completionResult = await _processHabitForAutoCompletion(
            habit: habit,
            healthSummary: healthSummary,
            habitService: habitService,
          );

          if (completionResult.completed) {
            result.completedHabits.add(completionResult);
          }

          // Analyze habit-health correlation
          final correlation = await _analyzeHabitHealthCorrelation(
            habit: habit,
            healthSummary: healthSummary,
          );
          result.correlations[habit.id] = correlation;
        } catch (e) {
          AppLogger.error('Error processing habit ${habit.name}', e);
        }
      }

      // Update last sync time
      await _updateLastSyncTime();

      // Generate health insights for habits
      result.insights = await _generateHealthHabitInsights(
        habits,
        healthSummary,
      );

      AppLogger.info(
        'Health-habit sync completed: ${result.completedHabits.length} habits auto-completed',
      );

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
  static Future<HabitAutoCompletionResult> _processHabitForAutoCompletion({
    required Habit habit,
    required Map<String, dynamic> healthSummary,
    required HabitService habitService,
  }) async {
    final result = HabitAutoCompletionResult(
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
      final completionCheck =
          await HealthHabitMappingService.checkHabitCompletion(
        habit: habit,
        date: DateTime.now(),
      );

      if (completionCheck.shouldComplete) {
        // Auto-complete the habit
        await habitService.markHabitComplete(habit.id, DateTime.now());

        result.completed = true;
        result.reason = completionCheck.reason;
        result.healthDataType = completionCheck.healthDataType;
        result.healthValue = completionCheck.healthValue;
        result.threshold = completionCheck.threshold;
        result.confidence = completionCheck.confidence;

        AppLogger.info(
          'Auto-completed habit "${habit.name}": ${completionCheck.reason}',
        );
      } else {
        result.reason = completionCheck.reason;
      }
    } catch (e) {
      AppLogger.error(
        'Error processing habit ${habit.name} for auto-completion',
        e,
      );
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
    if (habitName.contains('walk') ||
        habitName.contains('step') ||
        habitName.contains('run') ||
        habitName.contains('jog') ||
        habitCategory.contains('fitness') ||
        habitCategory.contains('exercise')) {
      if (habitName.contains('morning')) {
        mapping['STEPS'] = _defaultHealthThresholds['STEPS']!['morning_walk'];
      } else if (habitName.contains('evening')) {
        mapping['STEPS'] = _defaultHealthThresholds['STEPS']!['evening_walk'];
      } else if (habitName.contains('exercise') ||
          habitName.contains('workout')) {
        mapping['STEPS'] = _defaultHealthThresholds['STEPS']!['exercise'];
      } else {
        mapping['STEPS'] = _defaultHealthThresholds['STEPS']!['daily_walk'];
      }
    }

    // Active energy-based habits
    if (habitName.contains('workout') ||
        habitName.contains('exercise') ||
        habitName.contains('gym') ||
        habitName.contains('cardio') ||
        habitName.contains('training')) {
      if (habitName.contains('cardio')) {
        mapping['ACTIVE_ENERGY_BURNED'] =
            _defaultHealthThresholds['ACTIVE_ENERGY_BURNED']!['cardio'];
      } else if (habitName.contains('gym')) {
        mapping['ACTIVE_ENERGY_BURNED'] =
            _defaultHealthThresholds['ACTIVE_ENERGY_BURNED']!['gym'];
      } else {
        mapping['ACTIVE_ENERGY_BURNED'] =
            _defaultHealthThresholds['ACTIVE_ENERGY_BURNED']!['workout'];
      }
    }

    // Sleep-based habits
    if (habitName.contains('sleep') ||
        habitName.contains('bed') ||
        habitName.contains('rest') ||
        habitCategory.contains('sleep')) {
      if (habitName.contains('bedtime')) {
        mapping['SLEEP_IN_BED'] =
            _defaultHealthThresholds['SLEEP_IN_BED']!['bedtime'];
      } else {
        mapping['SLEEP_IN_BED'] =
            _defaultHealthThresholds['SLEEP_IN_BED']!['sleep'];
      }
    }

    // Water-based habits
    if (habitName.contains('water') ||
        habitName.contains('hydrat') ||
        habitName.contains('drink') ||
        habitCategory.contains('hydration')) {
      if (habitName.contains('hydration')) {
        mapping['WATER'] = _defaultHealthThresholds['WATER']!['hydration'];
      } else {
        mapping['WATER'] = _defaultHealthThresholds['WATER']!['drink_water'];
      }
    }

    // Mindfulness-based habits
    if (habitName.contains('meditat') ||
        habitName.contains('mindful') ||
        habitName.contains('breathing') ||
        habitName.contains('relax') ||
        habitCategory.contains('mental') ||
        habitCategory.contains('wellness')) {
      if (habitName.contains('breathing')) {
        mapping['MINDFULNESS'] =
            _defaultHealthThresholds['MINDFULNESS']!['breathing'];
      } else if (habitName.contains('relax')) {
        mapping['MINDFULNESS'] =
            _defaultHealthThresholds['MINDFULNESS']!['relaxation'];
      } else {
        mapping['MINDFULNESS'] =
            _defaultHealthThresholds['MINDFULNESS']!['meditation'];
      }
    }

    // Weight-based habits
    if (habitName.contains('weight') ||
        habitName.contains('weigh') ||
        habitCategory.contains('weight')) {
      mapping['WEIGHT'] =
          _defaultHealthThresholds['WEIGHT']!['weight_tracking'];
    }

    return mapping;
  }

  /// Analyze correlation between habit completion and health metrics
  static Future<HabitHealthCorrelation> _analyzeHabitHealthCorrelation({
    required Habit habit,
    required Map<String, dynamic> healthSummary,
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
          .map(
            (completion) =>
                DateTime(completion.year, completion.month, completion.day),
          )
          .toSet()
          .toList();

      if (completionDays.length < 5) {
        // Not enough data for meaningful correlation
        return correlation;
      }

      // Simplified correlation analysis using health summary
      for (final entry in healthSummary.entries) {
        final healthType = entry.key;
        final healthValue = entry.value;

        if (healthValue is num && healthValue > 0) {
          // Simple correlation based on completion rate and health value presence
          final completionRate = completionDays.length / 30.0;
          final correlationValue =
              completionRate * 0.7; // Simplified correlation
          correlation.correlations[healthType] = correlationValue;
        }
      }
    } catch (e) {
      AppLogger.error('Error analyzing habit-health correlation', e);
    }

    return correlation;
  }

  /// Generate comprehensive health-habit insights
  static Future<Map<String, dynamic>> _generateHealthHabitInsights(
    List<Habit> habits,
    Map<String, dynamic> healthSummary,
  ) async {
    final insights = <String, dynamic>{};

    try {
      // Overall health-habit integration score
      final integrationScore = _calculateIntegrationScore(
        habits,
        healthSummary,
      );
      insights['integrationScore'] = integrationScore;

      // Health-driven habit suggestions
      final suggestions = await _generateHealthDrivenSuggestions(healthSummary);
      insights['suggestions'] = suggestions;

      // Health trend analysis
      final trends = _analyzeHealthTrends(healthSummary);
      insights['trends'] = trends;

      // Habit completion predictions
      final predictions = _generateCompletionPredictions(habits, healthSummary);
      insights['predictions'] = predictions;
    } catch (e) {
      AppLogger.error('Error generating health-habit insights', e);
    }

    return insights;
  }

  /// Calculate overall health-habit integration score (0-100)
  static double _calculateIntegrationScore(
    List<Habit> habits,
    Map<String, dynamic> healthSummary,
  ) {
    if (habits.isEmpty || healthSummary.containsKey('error')) return 0.0;

    int healthMappedHabits = 0;
    for (final habit in habits) {
      final mapping = _getHealthMappingForHabit(habit);
      if (mapping.isNotEmpty) {
        healthMappedHabits++;
      }
    }

    final mappingScore = (healthMappedHabits / habits.length) * 50;
    final dataAvailabilityScore = healthSummary.isNotEmpty ? 50.0 : 0.0;

    return mappingScore + dataAvailabilityScore;
  }

  /// Generate health-driven habit suggestions
  static Future<List<String>> _generateHealthDrivenSuggestions(
    Map<String, dynamic> healthSummary,
  ) async {
    final suggestions = <String>[];

    try {
      // Steps-based suggestions
      final steps = healthSummary['steps'] ?? 0;
      if (steps < 8000) {
        suggestions.add(
          'Consider adding a "Daily Walk" habit - you\'re at $steps steps today',
        );
      }

      // Sleep-based suggestions
      final sleepHours = healthSummary['averageSleepHours'] ?? 8.0;
      if (sleepHours < 7.0) {
        suggestions.add(
          'Add an "Earlier Bedtime" habit - averaging ${sleepHours.toStringAsFixed(1)} hours',
        );
      }

      // Water-based suggestions
      final water = healthSummary['waterIntake'] ?? 0;
      if (water < 2000) {
        suggestions.add(
          'Create a "Hydration" habit - only ${water.round()}ml consumed today',
        );
      }

      // Mindfulness-based suggestions
      final mindfulness = healthSummary['mindfulnessMinutes'] ?? 0;
      if (mindfulness < 10) {
        suggestions.add(
          'Try a "Daily Meditation" habit - ${mindfulness.round()} minutes today',
        );
      }
    } catch (e) {
      AppLogger.error('Error generating health-driven suggestions', e);
    }

    return suggestions;
  }

  /// Analyze health trends for insights
  static Map<String, dynamic> _analyzeHealthTrends(
    Map<String, dynamic> healthSummary,
  ) {
    final trends = <String, dynamic>{};

    try {
      // Simplified trend analysis using health summary
      for (final entry in healthSummary.entries) {
        final type = entry.key;
        final value = entry.value;

        if (value is num && value > 0) {
          // Simple trend analysis based on current values
          String trendDirection = 'stable';
          String trendDescription = '';

          switch (type) {
            case 'steps':
              if (value >= 10000) {
                trendDirection = 'excellent';
                trendDescription = 'Meeting daily step goals';
              } else if (value >= 5000) {
                trendDirection = 'good';
                trendDescription = 'Moderate activity level';
              } else {
                trendDirection = 'low';
                trendDescription = 'Below recommended activity';
              }
              break;
            case 'sleepHours':
              if (value >= 7.5) {
                trendDirection = 'excellent';
                trendDescription = 'Adequate sleep duration';
              } else if (value >= 6) {
                trendDirection = 'fair';
                trendDescription = 'Could improve sleep';
              } else {
                trendDirection = 'poor';
                trendDescription = 'Insufficient sleep';
              }
              break;
            default:
              trendDirection = 'stable';
              trendDescription = 'Data available';
          }

          trends[type] = {
            'direction': trendDirection,
            'description': trendDescription,
            'current': value,
          };
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
    Map<String, dynamic> healthSummary,
  ) {
    final predictions = <String, dynamic>{};

    try {
      for (final habit in habits) {
        if (habit.isCompletedToday) continue;

        final mapping = _getHealthMappingForHabit(habit);
        if (mapping.isEmpty) continue;

        double completionProbability = 0.0;
        String reason = '';

        // Simplified prediction based on health summary
        final habitName = habit.name.toLowerCase();

        if (habitName.contains('walk') || habitName.contains('step')) {
          final steps = (healthSummary['steps'] as num?)?.toDouble() ?? 0.0;
          if (steps >= 8000) {
            completionProbability = 1.0;
            reason = 'Step goal likely achieved';
          } else if (steps > 0) {
            completionProbability = steps / 10000;
            reason = 'Progress: ${(completionProbability * 100).round()}%';
          }
        } else if (habitName.contains('sleep')) {
          final sleep =
              (healthSummary['sleepHours'] as num?)?.toDouble() ?? 0.0;
          if (sleep >= 7.5) {
            completionProbability = 1.0;
            reason = 'Sleep goal achieved';
          } else if (sleep > 0) {
            completionProbability = sleep / 8.0;
            reason = 'Progress: ${(completionProbability * 100).round()}%';
          }
        } else if (habitName.contains('water')) {
          final water =
              (healthSummary['waterIntake'] as num?)?.toDouble() ?? 0.0;
          if (water >= 2000) {
            completionProbability = 1.0;
            reason = 'Hydration goal achieved';
          } else if (water > 0) {
            completionProbability = water / 2500;
            reason = 'Progress: ${(completionProbability * 100).round()}%';
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
      await prefs.setInt(
        _lastHealthSyncKey,
        DateTime.now().millisecondsSinceEpoch,
      );
    } catch (e) {
      AppLogger.error('Error updating last sync time', e);
    }
  }

  /// Send notification about auto-completed habits
  static Future<void> _sendAutoCompletionNotification(
    List<HabitAutoCompletionResult> completedHabits,
  ) async {
    try {
      if (completedHabits.length == 1) {
        await NotificationService.showNotification(
          id: 9999,
          title: 'Habit Auto-Completed! 🎉',
          body:
              'Great job! "${completedHabits.first.habitName}" was completed based on your health data.',
        );
      } else {
        await NotificationService.showNotification(
          id: 9999,
          title: 'Habits Auto-Completed! 🎉',
          body:
              '${completedHabits.length} habits completed based on your health data.',
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
      final healthPermissions = await HealthService.hasPermissions();
      final autoCompletionEnabled = await isAutoCompletionEnabled();

      int healthMappedHabits = 0;
      final habitMappings = <String, dynamic>{};

      // Use the mapping service to find all mappable habits (regardless of category)
      final mappableHabits = await HealthHabitMappingService.getMappableHabits(
        allHabits,
      );
      healthMappedHabits = mappableHabits.length;

      for (final mapping in mappableHabits) {
        final habit = allHabits.firstWhere((h) => h.id == mapping.habitId);
        habitMappings[habit.id] = {
          'name': habit.name,
          'category': habit.category,
          'healthDataType': mapping.healthDataType,
          'threshold': mapping.threshold,
          'unit': mapping.unit,
          'relevanceScore': mapping.relevanceScore,
        };
      }

      // Count health-related habits by category for reference
      final healthCategoryHabits = allHabits
          .where(
            (habit) =>
                habit.category == 'Health' || habit.category == 'Fitness',
          )
          .length;

      status['totalHabits'] = allHabits.length;
      status['healthCategoryHabits'] =
          healthCategoryHabits; // Habits specifically categorized as Health/Fitness
      status['healthMappedHabits'] = healthMappedHabits;
      status['mappingPercentage'] = allHabits.isNotEmpty
          ? (healthMappedHabits / allHabits.length * 100).round()
          : 0;
      status['healthPermissions'] = healthPermissions;
      status['autoCompletionEnabled'] = autoCompletionEnabled;
      status['habitMappings'] = habitMappings;

      // Get recent sync info
      final prefs = await SharedPreferences.getInstance();
      final lastSync = prefs.getInt(_lastHealthSyncKey) ?? 0;
      status['lastSyncTime'] = lastSync;
      status['lastSyncDate'] = lastSync > 0
          ? DateTime.fromMillisecondsSinceEpoch(lastSync).toIso8601String()
          : null;
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
  static Future<void> updateHealthThresholds(
    Map<String, Map<String, dynamic>> newThresholds,
  ) async {
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
  final List<HabitAutoCompletionResult> completedHabits = [];
  final Map<String, HabitHealthCorrelation> correlations = {};
  Map<String, dynamic> insights = {};
  String? error;

  bool get hasError => error != null;
  bool get hasCompletions => completedHabits.isNotEmpty;
  int get completionCount => completedHabits.length;
}

/// Result of individual habit auto-completion operation
class HabitAutoCompletionResult {
  final String habitId;
  final String habitName;
  bool completed;
  String? reason;
  String? healthDataType;
  dynamic healthValue;
  dynamic threshold;
  double confidence;
  String? error;

  HabitAutoCompletionResult({
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

  HabitHealthCorrelation({required this.habitId, required this.correlations});

  /// Get the strongest correlation
  MapEntry<String, double>? get strongestCorrelation {
    if (correlations.isEmpty) return null;

    return correlations.entries.reduce(
      (a, b) => a.value.abs() > b.value.abs() ? a : b,
    );
  }

  /// Get correlations above a threshold
  Map<String, double> getSignificantCorrelations({double threshold = 0.3}) {
    return Map.fromEntries(
      correlations.entries.where((entry) => entry.value.abs() >= threshold),
    );
  }
}

/// Result of threshold checking
class ThresholdResult {
  bool meets;
  dynamic value;

  ThresholdResult({required this.meets, required this.value});
}
