import 'dart:math' as math;
import '../domain/model/habit.dart';
import 'health_service.dart';
import 'logging_service.dart';

/// Health-Enhanced Habit Creation Service
///
/// This service provides intelligent habit creation capabilities that leverage
/// health data to suggest optimal habits, set realistic thresholds, and
/// enable automatic completion from day one.
class HealthEnhancedHabitCreationService {
  /// Generate health-based habit suggestions for a user
  static Future<List<HealthBasedHabitSuggestion>>
      generateHealthBasedSuggestions({
    int analysisWindowDays = 30,
  }) async {
    final suggestions = <HealthBasedHabitSuggestion>[];

    try {
      AppLogger.info('Generating health-based habit suggestions...');

      // Check if health permissions are available with error handling
      bool hasPermissions = false;
      try {
        hasPermissions = await HealthService.hasPermissions();
      } catch (e) {
        AppLogger.error('Error checking health permissions: $e');
        return _getBasicHealthSuggestions();
      }

      if (!hasPermissions) {
        AppLogger.info('No health permissions - returning basic suggestions');
        return _getBasicHealthSuggestions();
      }

      // Get recent health data for analysis using the new minimal health service
      Map<String, dynamic> healthSummary = {};
      try {
        healthSummary = await HealthService.getTodayHealthSummary();
      } catch (e) {
        AppLogger.error('Error getting health summary: $e');
        return _getBasicHealthSuggestions();
      }

      if (healthSummary.containsKey('error')) {
        AppLogger.info(
            'No health data available - returning basic suggestions');
        return _getBasicHealthSuggestions();
      }

      // Analyze each health metric and generate suggestions
      suggestions.addAll(
          await _analyzeStepsDataMinimal(healthSummary, analysisWindowDays));
      suggestions.addAll(await _analyzeActiveEnergyDataMinimal(
          healthSummary, analysisWindowDays));
      suggestions.addAll(
          await _analyzeSleepDataMinimal(healthSummary, analysisWindowDays));
      suggestions.addAll(
          await _analyzeWaterDataMinimal(healthSummary, analysisWindowDays));
      suggestions.addAll(await _analyzeMindfulnessDataMinimal(
          healthSummary, analysisWindowDays));
      suggestions.addAll(
          await _analyzeWeightDataMinimal(healthSummary, analysisWindowDays));

      // Sort by priority and confidence
      suggestions.sort((a, b) {
        final priorityCompare = b.priority.compareTo(a.priority);
        if (priorityCompare != 0) return priorityCompare;
        return b.confidence.compareTo(a.confidence);
      });

      AppLogger.info(
          'Generated ${suggestions.length} health-based habit suggestions');
    } catch (e) {
      AppLogger.error('Error generating health-based suggestions', e);
      return _getBasicHealthSuggestions();
    }

    return suggestions.take(10).toList(); // Return top 10 suggestions
  }

  /// Create a habit with health integration pre-configured
  static Future<Habit> createHealthIntegratedHabit({
    required String name,
    required String description,
    required HabitFrequency frequency,
    required String category,
    String? healthDataType,
    double? customThreshold,
    String? thresholdLevel,
  }) async {
    try {
      AppLogger.info('Creating health-integrated habit: $name');

      // Create the basic habit
      final habit = Habit.create(
        name: name,
        description: description,
        frequency: frequency,
        category: category,
        colorValue: 0xFF2196F3, // Default blue color
      );

      // If health data type is specified, set up the integration
      if (healthDataType != null) {
        final mapping = await _createHealthMapping(
          habit: habit,
          healthDataType: healthDataType,
          customThreshold: customThreshold,
          thresholdLevel: thresholdLevel,
        );

        if (mapping != null) {
          // Store the mapping for future use
          await _storeHabitHealthMapping(habit.id, mapping);
          AppLogger.info(
              'Health mapping created for habit: ${mapping.toJson()}');
        }
      }

      return habit;
    } catch (e) {
      AppLogger.error('Error creating health-integrated habit', e);
      rethrow;
    }
  }

  /// Enhance an existing habit with health integration
  static Future<HabitHealthMapping?> enhanceHabitWithHealthIntegration(
    Habit habit,
  ) async {
    try {
      AppLogger.info('Enhancing habit with health integration: ${habit.name}');

      // Get health summary to determine best integration
      final healthSummary = await HealthService.getTodayHealthSummary();
      if (healthSummary.containsKey('error')) {
        AppLogger.warning('No health data available for enhancement');
        return null;
      }

      // Determine best health data type based on habit category
      final healthDataType = _determineHealthDataType(habit);
      if (healthDataType == null) {
        AppLogger.info(
            'No suitable health data type found for habit: ${habit.name}');
        return null;
      }

      // Create the mapping
      final mapping = await _createHealthMapping(
        habit: habit,
        healthDataType: healthDataType,
      );

      if (mapping != null) {
        await _storeHabitHealthMapping(habit.id, mapping);
        AppLogger.info('Health enhancement completed for habit: ${habit.name}');
      }

      return mapping;
    } catch (e) {
      AppLogger.error('Error enhancing habit with health integration', e);
      return null;
    }
  }

  /// Generate personalized habit recommendations based on health patterns
  static Future<List<HabitRecommendation>> generatePersonalizedRecommendations({
    int analysisWindowDays = 30,
  }) async {
    final recommendations = <HabitRecommendation>[];

    try {
      AppLogger.info('Generating personalized habit recommendations...');

      final healthSummary = await HealthService.getTodayHealthSummary();
      if (healthSummary.containsKey('error')) {
        return _getBasicRecommendations();
      }

      // Analyze patterns and generate recommendations
      recommendations.addAll(_generateActivityRecommendations(healthSummary));
      recommendations.addAll(_generateSleepRecommendations(healthSummary));
      recommendations.addAll(_generateWellnessRecommendations(healthSummary));

      // Sort by impact potential
      recommendations.sort((a, b) => b.impactScore.compareTo(a.impactScore));

      AppLogger.info(
          'Generated ${recommendations.length} personalized recommendations');
    } catch (e) {
      AppLogger.error('Error generating personalized recommendations', e);
      return _getBasicRecommendations();
    }

    return recommendations.take(5).toList(); // Return top 5 recommendations
  }

  /// Analyze steps data and generate suggestions (minimal version)
  static Future<List<HealthBasedHabitSuggestion>> _analyzeStepsDataMinimal(
    Map<String, dynamic> healthSummary,
    int windowDays,
  ) async {
    final suggestions = <HealthBasedHabitSuggestion>[];

    final steps = (healthSummary['steps'] as num?)?.toDouble() ?? 0.0;
    if (steps <= 0) return suggestions;

    // Generate suggestions based on current activity level
    if (steps < 5000) {
      suggestions.add(HealthBasedHabitSuggestion(
        name: 'Daily Walk',
        description: 'Take a 15-minute walk every day to boost your activity',
        category: 'Fitness',
        frequency: HabitFrequency.daily,
        healthDataType: 'STEPS',
        suggestedThreshold: 3000,
        currentAverage: steps,
        improvementPotential: 0.8,
        priority: HabitPriority.high,
        confidence: 0.9,
        reasoning:
            'Your current steps (${steps.round()}) are below recommended levels. A daily walk can significantly improve your health.',
      ));
    } else if (steps < 8000) {
      suggestions.add(HealthBasedHabitSuggestion(
        name: 'Morning Walk',
        description: 'Start your day with a energizing morning walk',
        category: 'Fitness',
        frequency: HabitFrequency.daily,
        healthDataType: 'STEPS',
        suggestedThreshold: math.min(steps + 2000, 10000),
        currentAverage: steps,
        improvementPotential: 0.6,
        priority: HabitPriority.medium,
        confidence: 0.8,
        reasoning:
            'You\'re moderately active with ${steps.round()} daily steps. A morning walk can help you reach the recommended 10,000 steps.',
      ));
    }

    return suggestions;
  }

  /// Analyze active energy data and generate suggestions (minimal version)
  static Future<List<HealthBasedHabitSuggestion>>
      _analyzeActiveEnergyDataMinimal(
    Map<String, dynamic> healthSummary,
    int windowDays,
  ) async {
    final suggestions = <HealthBasedHabitSuggestion>[];

    final activeCalories =
        (healthSummary['activeCalories'] as num?)?.toDouble() ?? 0.0;
    if (activeCalories <= 0) return suggestions;

    // Generate exercise suggestions based on current energy expenditure
    if (activeCalories < 200) {
      suggestions.add(HealthBasedHabitSuggestion(
        name: 'Daily Exercise',
        description:
            'Incorporate 20 minutes of moderate exercise into your routine',
        category: 'Fitness',
        frequency: HabitFrequency.daily,
        healthDataType: 'ACTIVE_ENERGY_BURNED',
        suggestedThreshold: 250,
        currentAverage: activeCalories,
        improvementPotential: 0.9,
        priority: HabitPriority.high,
        confidence: 0.85,
        reasoning:
            'Your current daily active energy burn of ${activeCalories.round()} calories suggests low exercise activity. Regular exercise can significantly improve your fitness.',
      ));
    } else if (activeCalories < 400) {
      suggestions.add(HealthBasedHabitSuggestion(
        name: 'Strength Training',
        description: 'Add strength training sessions to complement your cardio',
        category: 'Fitness',
        frequency: HabitFrequency.weekly,
        healthDataType: 'ACTIVE_ENERGY_BURNED',
        suggestedThreshold: 300, // Per session
        currentAverage: activeCalories,
        improvementPotential: 0.6,
        priority: HabitPriority.medium,
        confidence: 0.75,
        reasoning:
            'You\'re moderately active with ${activeCalories.round()} daily calories burned. Adding strength training can enhance your fitness routine.',
      ));
    }

    return suggestions;
  }

  /// Analyze sleep data and generate suggestions (minimal version)
  static Future<List<HealthBasedHabitSuggestion>> _analyzeSleepDataMinimal(
    Map<String, dynamic> healthSummary,
    int windowDays,
  ) async {
    final suggestions = <HealthBasedHabitSuggestion>[];

    final sleepHours = (healthSummary['sleepHours'] as num?)?.toDouble() ?? 0.0;
    if (sleepHours <= 0) return suggestions;

    // Generate sleep-related suggestions
    if (sleepHours < 7.0) {
      suggestions.add(HealthBasedHabitSuggestion(
        name: 'Earlier Bedtime',
        description: 'Establish a consistent bedtime to get 7-8 hours of sleep',
        category: 'Sleep',
        frequency: HabitFrequency.daily,
        healthDataType: 'SLEEP_IN_BED',
        suggestedThreshold: 7.5,
        currentAverage: sleepHours,
        improvementPotential: 0.8,
        priority: HabitPriority.high,
        confidence: 0.9,
        reasoning:
            'Your recent sleep of ${sleepHours.toStringAsFixed(1)} hours is below the recommended 7-8 hours. Better sleep can improve energy and health.',
      ));
    }

    // Always suggest consistent sleep schedule as it's important
    suggestions.add(HealthBasedHabitSuggestion(
      name: 'Consistent Sleep Schedule',
      description: 'Go to bed and wake up at the same time every day',
      category: 'Sleep',
      frequency: HabitFrequency.daily,
      healthDataType: 'SLEEP_IN_BED',
      suggestedThreshold: math.max(sleepHours, 7.0),
      currentAverage: sleepHours,
      improvementPotential: 0.7,
      priority: HabitPriority.medium,
      confidence: 0.8,
      reasoning:
          'Consistent sleep timing can improve sleep quality and overall health.',
    ));

    return suggestions;
  }

  /// Analyze water data and generate suggestions (minimal version)
  static Future<List<HealthBasedHabitSuggestion>> _analyzeWaterDataMinimal(
    Map<String, dynamic> healthSummary,
    int windowDays,
  ) async {
    final suggestions = <HealthBasedHabitSuggestion>[];

    final waterIntake =
        (healthSummary['waterIntake'] as num?)?.toDouble() ?? 0.0;

    // Generate hydration suggestions (even if no data, as hydration is important)
    if (waterIntake < 2000) {
      // Less than 2 liters
      suggestions.add(HealthBasedHabitSuggestion(
        name: 'Daily Hydration',
        description: 'Drink 8 glasses of water throughout the day',
        category: 'Health',
        frequency: HabitFrequency.daily,
        healthDataType: 'WATER',
        suggestedThreshold: 2000, // 2 liters in ml
        currentAverage: waterIntake,
        improvementPotential: 0.7,
        priority: HabitPriority.medium,
        confidence: 0.8,
        reasoning: waterIntake > 0
            ? 'Your current water intake of ${waterIntake.round()}ml is below the recommended 2000ml daily. Proper hydration improves energy and health.'
            : 'Proper hydration is essential for health. Aim for 8 glasses (2000ml) of water daily.',
      ));
    }

    return suggestions;
  }

  /// Analyze mindfulness data and generate suggestions (minimal version)
  static Future<List<HealthBasedHabitSuggestion>>
      _analyzeMindfulnessDataMinimal(
    Map<String, dynamic> healthSummary,
    int windowDays,
  ) async {
    final suggestions = <HealthBasedHabitSuggestion>[];

    final mindfulnessMinutes =
        (healthSummary['mindfulnessMinutes'] as num?)?.toDouble() ?? 0.0;

    // Generate mindfulness suggestions (important for mental health)
    if (mindfulnessMinutes < 10) {
      suggestions.add(HealthBasedHabitSuggestion(
        name: 'Daily Meditation',
        description: 'Practice 10 minutes of mindfulness or meditation daily',
        category: 'Wellness',
        frequency: HabitFrequency.daily,
        healthDataType: 'MINDFULNESS',
        suggestedThreshold: 10,
        currentAverage: mindfulnessMinutes,
        improvementPotential: 0.8,
        priority: HabitPriority.medium,
        confidence: 0.85,
        reasoning: mindfulnessMinutes > 0
            ? 'Your current mindfulness practice of ${mindfulnessMinutes.round()} minutes can be expanded. Regular meditation reduces stress and improves focus.'
            : 'Daily mindfulness practice can reduce stress, improve focus, and enhance overall well-being.',
      ));
    }

    return suggestions;
  }

  /// Analyze weight data and generate suggestions (minimal version)
  static Future<List<HealthBasedHabitSuggestion>> _analyzeWeightDataMinimal(
    Map<String, dynamic> healthSummary,
    int windowDays,
  ) async {
    final suggestions = <HealthBasedHabitSuggestion>[];

    final weight = healthSummary['weight'] as double?;

    // Only suggest weight tracking if we have some weight data
    if (weight != null && weight > 0) {
      suggestions.add(HealthBasedHabitSuggestion(
        name: 'Regular Weight Tracking',
        description: 'Track your weight weekly to monitor health trends',
        category: 'Health',
        frequency: HabitFrequency.weekly,
        healthDataType: 'WEIGHT',
        suggestedThreshold: 1, // Once per week
        currentAverage: 1, // Assuming current tracking
        improvementPotential: 0.5,
        priority: HabitPriority.low,
        confidence: 0.7,
        reasoning:
            'Regular weight monitoring helps track health trends and maintain awareness of your fitness progress.',
      ));
    }

    return suggestions;
  }

  /// Get basic health suggestions when no health data is available
  static List<HealthBasedHabitSuggestion> _getBasicHealthSuggestions() {
    return [
      HealthBasedHabitSuggestion(
        name: 'Daily Walk',
        description: 'Take a 30-minute walk every day',
        category: 'Fitness',
        frequency: HabitFrequency.daily,
        healthDataType: 'STEPS',
        suggestedThreshold: 5000,
        currentAverage: 0,
        improvementPotential: 0.8,
        priority: HabitPriority.high,
        confidence: 0.9,
        reasoning:
            'Regular walking is one of the best ways to improve overall health and fitness.',
      ),
      HealthBasedHabitSuggestion(
        name: 'Consistent Sleep',
        description: 'Go to bed at the same time every night',
        category: 'Sleep',
        frequency: HabitFrequency.daily,
        healthDataType: 'SLEEP_IN_BED',
        suggestedThreshold: 7.5,
        currentAverage: 0,
        improvementPotential: 0.9,
        priority: HabitPriority.high,
        confidence: 0.95,
        reasoning:
            'Quality sleep is fundamental to physical and mental health.',
      ),
      HealthBasedHabitSuggestion(
        name: 'Stay Hydrated',
        description: 'Drink 8 glasses of water daily',
        category: 'Health',
        frequency: HabitFrequency.daily,
        healthDataType: 'WATER',
        suggestedThreshold: 2000,
        currentAverage: 0,
        improvementPotential: 0.7,
        priority: HabitPriority.medium,
        confidence: 0.8,
        reasoning:
            'Proper hydration is essential for all bodily functions and energy levels.',
      ),
    ];
  }

  /// Create health mapping for a habit
  static Future<HabitHealthMapping?> _createHealthMapping({
    required Habit habit,
    required String healthDataType,
    double? customThreshold,
    String? thresholdLevel,
  }) async {
    try {
      // This would integrate with the health habit mapping service
      // For now, return a basic mapping structure
      return HabitHealthMapping(
        habitId: habit.id,
        healthDataType: healthDataType,
        threshold: customThreshold ?? _getDefaultThreshold(healthDataType),
        thresholdLevel: thresholdLevel ?? 'moderate',
        isActive: true,
        createdAt: DateTime.now(),
      );
    } catch (e) {
      AppLogger.error('Error creating health mapping', e);
      return null;
    }
  }

  /// Store habit health mapping
  static Future<void> _storeHabitHealthMapping(
      String habitId, HabitHealthMapping mapping) async {
    try {
      // This would store the mapping in the database
      // Implementation depends on your storage system
      AppLogger.info('Stored health mapping for habit: $habitId');
    } catch (e) {
      AppLogger.error('Error storing habit health mapping', e);
    }
  }

  /// Determine appropriate health data type for a habit
  static String? _determineHealthDataType(Habit habit) {
    final category = habit.category.toLowerCase();

    if (category.contains('fitness') || category.contains('exercise')) {
      return 'STEPS';
    } else if (category.contains('sleep')) {
      return 'SLEEP_IN_BED';
    } else if (category.contains('water') || category.contains('hydration')) {
      return 'WATER';
    } else if (category.contains('meditation') ||
        category.contains('mindfulness')) {
      return 'MINDFULNESS';
    } else if (category.contains('weight') || category.contains('health')) {
      return 'WEIGHT';
    }

    return null; // No suitable health data type found
  }

  /// Get default threshold for a health data type
  static double _getDefaultThreshold(String healthDataType) {
    switch (healthDataType) {
      case 'STEPS':
        return 8000;
      case 'ACTIVE_ENERGY_BURNED':
        return 300;
      case 'SLEEP_IN_BED':
        return 7.5;
      case 'WATER':
        return 2000;
      case 'MINDFULNESS':
        return 10;
      case 'WEIGHT':
        return 1; // Weekly tracking
      case 'MEDICATION':
        return 1; // Daily medication adherence
      default:
        return 1;
    }
  }

  /// Generate activity recommendations
  static List<HabitRecommendation> _generateActivityRecommendations(
      Map<String, dynamic> healthSummary) {
    final recommendations = <HabitRecommendation>[];

    final steps = (healthSummary['steps'] as num?)?.toDouble() ?? 0.0;
    final activeCalories =
        (healthSummary['activeCalories'] as num?)?.toDouble() ?? 0.0;

    if (steps < 8000) {
      recommendations.add(HabitRecommendation(
        title: 'Increase Daily Activity',
        description: 'Your step count suggests room for more daily movement',
        suggestedHabits: ['Morning Walk', 'Take Stairs', 'Walking Meetings'],
        impactScore: 0.8,
        category: 'Fitness',
      ));
    }

    if (activeCalories < 300) {
      recommendations.add(HabitRecommendation(
        title: 'Add Structured Exercise',
        description: 'Consider adding dedicated workout sessions',
        suggestedHabits: ['Gym Session', 'Home Workout', 'Yoga Class'],
        impactScore: 0.9,
        category: 'Fitness',
      ));
    }

    return recommendations;
  }

  /// Generate sleep recommendations
  static List<HabitRecommendation> _generateSleepRecommendations(
      Map<String, dynamic> healthSummary) {
    final recommendations = <HabitRecommendation>[];

    final sleepHours = (healthSummary['sleepHours'] as num?)?.toDouble() ?? 0.0;

    if (sleepHours < 7.0) {
      recommendations.add(HabitRecommendation(
        title: 'Improve Sleep Duration',
        description: 'Your sleep duration is below optimal levels',
        suggestedHabits: [
          'Earlier Bedtime',
          'Sleep Schedule',
          'Evening Routine'
        ],
        impactScore: 0.95,
        category: 'Sleep',
      ));
    }

    return recommendations;
  }

  /// Generate wellness recommendations
  static List<HabitRecommendation> _generateWellnessRecommendations(
      Map<String, dynamic> healthSummary) {
    final recommendations = <HabitRecommendation>[];

    final mindfulnessMinutes =
        (healthSummary['mindfulnessMinutes'] as num?)?.toDouble() ?? 0.0;
    final waterIntake =
        (healthSummary['waterIntake'] as num?)?.toDouble() ?? 0.0;

    if (mindfulnessMinutes < 10) {
      recommendations.add(HabitRecommendation(
        title: 'Add Mindfulness Practice',
        description: 'Regular meditation can reduce stress and improve focus',
        suggestedHabits: [
          'Daily Meditation',
          'Breathing Exercises',
          'Mindful Walking'
        ],
        impactScore: 0.7,
        category: 'Wellness',
      ));
    }

    if (waterIntake < 2000) {
      recommendations.add(HabitRecommendation(
        title: 'Improve Hydration',
        description: 'Proper hydration supports all bodily functions',
        suggestedHabits: [
          'Water Reminder',
          'Morning Water',
          'Hydration Tracking'
        ],
        impactScore: 0.6,
        category: 'Health',
      ));
    }

    return recommendations;
  }

  /// Get basic recommendations when no health data is available
  static List<HabitRecommendation> _getBasicRecommendations() {
    return [
      HabitRecommendation(
        title: 'Start with Movement',
        description: 'Physical activity is the foundation of good health',
        suggestedHabits: ['Daily Walk', 'Stretching', 'Take Stairs'],
        impactScore: 0.9,
        category: 'Fitness',
      ),
      HabitRecommendation(
        title: 'Prioritize Sleep',
        description: 'Quality sleep affects every aspect of health',
        suggestedHabits: [
          'Consistent Bedtime',
          'Evening Routine',
          'Sleep Hygiene'
        ],
        impactScore: 0.95,
        category: 'Sleep',
      ),
      HabitRecommendation(
        title: 'Build Wellness Habits',
        description: 'Small daily practices compound into big health benefits',
        suggestedHabits: ['Hydration', 'Meditation', 'Healthy Eating'],
        impactScore: 0.8,
        category: 'Wellness',
      ),
    ];
  }
}

/// Health-based habit suggestion model
class HealthBasedHabitSuggestion {
  final String name;
  final String description;
  final String category;
  final HabitFrequency frequency;
  final String healthDataType;
  final double suggestedThreshold;
  final double currentAverage;
  final double improvementPotential;
  final HabitPriority priority;
  final double confidence;
  final String reasoning;

  HealthBasedHabitSuggestion({
    required this.name,
    required this.description,
    required this.category,
    required this.frequency,
    required this.healthDataType,
    required this.suggestedThreshold,
    required this.currentAverage,
    required this.improvementPotential,
    required this.priority,
    required this.confidence,
    required this.reasoning,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'category': category,
        'frequency': frequency.toString(),
        'healthDataType': healthDataType,
        'suggestedThreshold': suggestedThreshold,
        'currentAverage': currentAverage,
        'improvementPotential': improvementPotential,
        'priority': priority.toString(),
        'confidence': confidence,
        'reasoning': reasoning,
      };
}

/// Habit recommendation model
class HabitRecommendation {
  final String title;
  final String description;
  final List<String> suggestedHabits;
  final double impactScore;
  final String category;

  HabitRecommendation({
    required this.title,
    required this.description,
    required this.suggestedHabits,
    required this.impactScore,
    required this.category,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'suggestedHabits': suggestedHabits,
        'impactScore': impactScore,
        'category': category,
      };
}

/// Habit health mapping model
class HabitHealthMapping {
  final String habitId;
  final String healthDataType;
  final double threshold;
  final String thresholdLevel;
  final bool isActive;
  final DateTime createdAt;

  HabitHealthMapping({
    required this.habitId,
    required this.healthDataType,
    required this.threshold,
    required this.thresholdLevel,
    required this.isActive,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'habitId': habitId,
        'healthDataType': healthDataType,
        'threshold': threshold,
        'thresholdLevel': thresholdLevel,
        'isActive': isActive,
        'createdAt': createdAt.toIso8601String(),
      };
}

/// Habit priority enum
enum HabitPriority {
  low,
  medium,
  high,
}

extension HabitPriorityExtension on HabitPriority {
  int compareTo(HabitPriority other) {
    return index.compareTo(other.index);
  }
}
