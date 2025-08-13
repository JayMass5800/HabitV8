import 'dart:math' as math;
import 'package:health/health.dart';
import '../domain/model/habit.dart';
import 'health_service.dart';
import 'health_habit_mapping_service.dart';
import 'logging_service.dart';

/// Health-Enhanced Habit Creation Service
/// 
/// This service provides intelligent habit creation capabilities that leverage
/// health data to suggest optimal habits, set realistic thresholds, and
/// enable automatic completion from day one.
class HealthEnhancedHabitCreationService {
  
  /// Generate health-based habit suggestions for a user
  static Future<List<HealthBasedHabitSuggestion>> generateHealthBasedSuggestions({
    int analysisWindowDays = 30,
  }) async {
    final suggestions = <HealthBasedHabitSuggestion>[];
    
    try {
      AppLogger.info('Generating health-based habit suggestions...');
      
      // Check if health permissions are available
      final hasPermissions = await HealthService.hasPermissions();
      if (!hasPermissions) {
        AppLogger.info('No health permissions - returning basic suggestions');
        return _getBasicHealthSuggestions();
      }
      
      // Get recent health data for analysis
      final endDate = DateTime.now();
      final startDate = endDate.subtract(Duration(days: analysisWindowDays));
      
      final healthData = await HealthService.getAllHealthData(
        startDate: startDate,
        endDate: endDate,
      );
      
      if (healthData.isEmpty) {
        AppLogger.info('No health data available - returning basic suggestions');
        return _getBasicHealthSuggestions();
      }
      
      // Analyze each health metric and generate suggestions
      suggestions.addAll(await _analyzeStepsData(healthData, analysisWindowDays));
      suggestions.addAll(await _analyzeActiveEnergyData(healthData, analysisWindowDays));
      suggestions.addAll(await _analyzeSleepData(healthData, analysisWindowDays));
      suggestions.addAll(await _analyzeWaterData(healthData, analysisWindowDays));
      suggestions.addAll(await _analyzeMindfulnessData(healthData, analysisWindowDays));
      suggestions.addAll(await _analyzeWeightData(healthData, analysisWindowDays));
      
      // Sort by priority and confidence
      suggestions.sort((a, b) {
        final priorityCompare = b.priority.compareTo(a.priority);
        if (priorityCompare != 0) return priorityCompare;
        return b.confidence.compareTo(a.confidence);
      });
      
      AppLogger.info('Generated ${suggestions.length} health-based habit suggestions');
      
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
    HealthDataType? healthDataType,
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
          AppLogger.info('Health mapping created for habit: ${mapping.toJson()}');
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
      
      // Use the mapping service to analyze the habit
      final mapping = await HealthHabitMappingService.analyzeHabitForHealthMapping(habit);
      
      if (mapping != null) {
        // Suggest optimal thresholds based on user's historical data
        final optimalThresholds = await HealthHabitMappingService.suggestOptimalThresholds(
          habit: habit,
          healthDataType: mapping.healthDataType,
        );
        
        // Update the mapping with optimal threshold if available
        if (optimalThresholds.isNotEmpty) {
          final optimalThreshold = optimalThresholds[mapping.thresholdLevel] ?? mapping.threshold;
          
          final enhancedMapping = HabitHealthMapping(
            habitId: habit.id,
            healthDataType: mapping.healthDataType,
            threshold: optimalThreshold,
            thresholdLevel: mapping.thresholdLevel,
            relevanceScore: mapping.relevanceScore,
            unit: mapping.unit,
            description: mapping.description,
          );
          
          await _storeHabitHealthMapping(habit.id, enhancedMapping);
          AppLogger.info('Enhanced habit with optimal health thresholds');
          
          return enhancedMapping;
        }
        
        await _storeHabitHealthMapping(habit.id, mapping);
        return mapping;
      }
      
      return null;
      
    } catch (e) {
      AppLogger.error('Error enhancing habit with health integration', e);
      return null;
    }
  }

  /// Get personalized habit recommendations based on health patterns
  static Future<List<PersonalizedHabitRecommendation>> getPersonalizedRecommendations({
    required List<Habit> existingHabits,
    int analysisWindowDays = 30,
  }) async {
    final recommendations = <PersonalizedHabitRecommendation>[];
    
    try {
      AppLogger.info('Generating personalized habit recommendations...');
      
      // Get health data for analysis
      final endDate = DateTime.now();
      final startDate = endDate.subtract(Duration(days: analysisWindowDays));
      
      final healthData = await HealthService.getAllHealthData(
        startDate: startDate,
        endDate: endDate,
      );
      
      if (healthData.isEmpty) {
        return _getBasicRecommendations(existingHabits);
      }
      
      // Analyze health patterns and identify improvement opportunities
      final healthPatterns = await _analyzeHealthPatterns(healthData, analysisWindowDays);
      
      // Generate recommendations based on patterns and gaps
      for (final pattern in healthPatterns.entries) {
        final healthType = pattern.key;
        final analysis = pattern.value;
        
        // Check if user already has habits for this health area
        final hasRelatedHabit = await _hasRelatedHabit(existingHabits, healthType);
        
        if (!hasRelatedHabit && analysis.improvementPotential > 0.3) {
          final recommendation = await _generateRecommendationForHealthType(
            healthType,
            analysis,
            existingHabits,
          );
          
          if (recommendation != null) {
            recommendations.add(recommendation);
          }
        }
      }
      
      // Sort by improvement potential and feasibility
      recommendations.sort((a, b) {
        final potentialCompare = b.improvementPotential.compareTo(a.improvementPotential);
        if (potentialCompare != 0) return potentialCompare;
        return b.feasibilityScore.compareTo(a.feasibilityScore);
      });
      
      AppLogger.info('Generated ${recommendations.length} personalized recommendations');
      
    } catch (e) {
      AppLogger.error('Error generating personalized recommendations', e);
      return _getBasicRecommendations(existingHabits);
    }
    
    return recommendations.take(5).toList(); // Return top 5 recommendations
  }

  /// Analyze steps data and generate suggestions
  static Future<List<HealthBasedHabitSuggestion>> _analyzeStepsData(
    List<HealthDataPoint> healthData,
    int windowDays,
  ) async {
    final suggestions = <HealthBasedHabitSuggestion>[];
    
    final stepsData = healthData.where((p) => p.type == HealthDataType.STEPS).toList();
    if (stepsData.isEmpty) return suggestions;
    
    // Calculate daily averages
    final dailySteps = <DateTime, double>{};
    for (final point in stepsData) {
      final day = DateTime(point.dateFrom.year, point.dateFrom.month, point.dateFrom.day);
      final value = (point.value as NumericHealthValue).numericValue;
      dailySteps[day] = (dailySteps[day] ?? 0) + value;
    }
    
    if (dailySteps.isEmpty) return suggestions;
    
    final avgSteps = dailySteps.values.reduce((a, b) => a + b) / dailySteps.length;
    final consistency = _calculateConsistency(dailySteps.values.toList());
    
    // Generate suggestions based on current activity level
    if (avgSteps < 5000) {
      suggestions.add(HealthBasedHabitSuggestion(
        name: 'Daily Walk',
        description: 'Take a 15-minute walk every day to boost your activity',
        category: 'Fitness',
        frequency: HabitFrequency.daily,
        healthDataType: HealthDataType.STEPS,
        suggestedThreshold: 3000,
        currentAverage: avgSteps,
        improvementPotential: 0.8,
        priority: HabitPriority.high,
        confidence: 0.9,
        reasoning: 'Your current average of ${avgSteps.round()} steps is below recommended levels. A daily walk can significantly improve your health.',
      ));
    } else if (avgSteps < 8000) {
      suggestions.add(HealthBasedHabitSuggestion(
        name: 'Morning Walk',
        description: 'Start your day with a energizing morning walk',
        category: 'Fitness',
        frequency: HabitFrequency.daily,
        healthDataType: HealthDataType.STEPS,
        suggestedThreshold: math.min(avgSteps + 2000, 10000),
        currentAverage: avgSteps,
        improvementPotential: 0.6,
        priority: HabitPriority.medium,
        confidence: 0.8,
        reasoning: 'You\'re moderately active with ${avgSteps.round()} daily steps. A morning walk can help you reach the recommended 10,000 steps.',
      ));
    }
    
    // Suggest consistency improvement if needed
    if (consistency < 0.7 && avgSteps > 5000) {
      suggestions.add(HealthBasedHabitSuggestion(
        name: 'Consistent Daily Movement',
        description: 'Maintain regular daily activity for better health outcomes',
        category: 'Fitness',
        frequency: HabitFrequency.daily,
        healthDataType: HealthDataType.STEPS,
        suggestedThreshold: avgSteps * 0.8, // 80% of current average as minimum
        currentAverage: avgSteps,
        improvementPotential: 0.5,
        priority: HabitPriority.medium,
        confidence: 0.7,
        reasoning: 'Your activity varies significantly day-to-day. Consistent movement can improve overall health benefits.',
      ));
    }
    
    return suggestions;
  }

  /// Analyze active energy data and generate suggestions
  static Future<List<HealthBasedHabitSuggestion>> _analyzeActiveEnergyData(
    List<HealthDataPoint> healthData,
    int windowDays,
  ) async {
    final suggestions = <HealthBasedHabitSuggestion>[];
    
    final energyData = healthData.where((p) => p.type == HealthDataType.ACTIVE_ENERGY_BURNED).toList();
    if (energyData.isEmpty) return suggestions;
    
    // Calculate daily totals
    final dailyEnergy = <DateTime, double>{};
    for (final point in energyData) {
      final day = DateTime(point.dateFrom.year, point.dateFrom.month, point.dateFrom.day);
      final value = (point.value as NumericHealthValue).numericValue;
      dailyEnergy[day] = (dailyEnergy[day] ?? 0) + value;
    }
    
    if (dailyEnergy.isEmpty) return suggestions;
    
    final avgEnergy = dailyEnergy.values.reduce((a, b) => a + b) / dailyEnergy.length;
    
    // Generate exercise suggestions based on current energy expenditure
    if (avgEnergy < 200) {
      suggestions.add(HealthBasedHabitSuggestion(
        name: 'Daily Exercise',
        description: 'Incorporate 20 minutes of moderate exercise into your routine',
        category: 'Fitness',
        frequency: HabitFrequency.daily,
        healthDataType: HealthDataType.ACTIVE_ENERGY_BURNED,
        suggestedThreshold: 250,
        currentAverage: avgEnergy,
        improvementPotential: 0.9,
        priority: HabitPriority.high,
        confidence: 0.85,
        reasoning: 'Your current daily active energy burn of ${avgEnergy.round()} calories suggests low exercise activity. Regular exercise can significantly improve your fitness.',
      ));
    } else if (avgEnergy < 400) {
      suggestions.add(HealthBasedHabitSuggestion(
        name: 'Strength Training',
        description: 'Add strength training sessions to complement your cardio',
        category: 'Fitness',
        frequency: HabitFrequency.weekly,
        healthDataType: HealthDataType.ACTIVE_ENERGY_BURNED,
        suggestedThreshold: 300, // Per session
        currentAverage: avgEnergy,
        improvementPotential: 0.6,
        priority: HabitPriority.medium,
        confidence: 0.75,
        reasoning: 'You\'re moderately active with ${avgEnergy.round()} daily calories burned. Adding strength training can enhance your fitness routine.',
      ));
    }
    
    return suggestions;
  }

  /// Analyze sleep data and generate suggestions
  static Future<List<HealthBasedHabitSuggestion>> _analyzeSleepData(
    List<HealthDataPoint> healthData,
    int windowDays,
  ) async {
    final suggestions = <HealthBasedHabitSuggestion>[];
    
    final sleepData = healthData.where((p) => p.type == HealthDataType.SLEEP_IN_BED).toList();
    if (sleepData.isEmpty) return suggestions;
    
    // Calculate nightly sleep duration
    final nightlySleep = <DateTime, double>{};
    for (final point in sleepData) {
      final night = DateTime(point.dateFrom.year, point.dateFrom.month, point.dateFrom.day);
      final durationHours = (point.value as NumericHealthValue).numericValue / 60.0; // Convert minutes to hours
      nightlySleep[night] = (nightlySleep[night] ?? 0) + durationHours;
    }
    
    if (nightlySleep.isEmpty) return suggestions;
    
    final avgSleep = nightlySleep.values.reduce((a, b) => a + b) / nightlySleep.length;
    final consistency = _calculateConsistency(nightlySleep.values.toList());
    
    // Generate sleep-related suggestions
    if (avgSleep < 7.0) {
      suggestions.add(HealthBasedHabitSuggestion(
        name: 'Earlier Bedtime',
        description: 'Establish a consistent bedtime to get 7-8 hours of sleep',
        category: 'Sleep',
        frequency: HabitFrequency.daily,
        healthDataType: HealthDataType.SLEEP_IN_BED,
        suggestedThreshold: 7.5,
        currentAverage: avgSleep,
        improvementPotential: 0.8,
        priority: HabitPriority.high,
        confidence: 0.9,
        reasoning: 'Your average sleep of ${avgSleep.toStringAsFixed(1)} hours is below the recommended 7-8 hours. Better sleep can improve energy and health.',
      ));
    }
    
    if (consistency < 0.8) {
      suggestions.add(HealthBasedHabitSuggestion(
        name: 'Consistent Sleep Schedule',
        description: 'Go to bed and wake up at the same time every day',
        category: 'Sleep',
        frequency: HabitFrequency.daily,
        healthDataType: HealthDataType.SLEEP_IN_BED,
        suggestedThreshold: math.max(avgSleep, 7.0),
        currentAverage: avgSleep,
        improvementPotential: 0.6,
        priority: HabitPriority.medium,
        confidence: 0.8,
        reasoning: 'Your sleep schedule varies significantly. A consistent sleep routine can improve sleep quality and overall health.',
      ));
    }
    
    return suggestions;
  }

  /// Analyze water data and generate suggestions
  static Future<List<HealthBasedHabitSuggestion>> _analyzeWaterData(
    List<HealthDataPoint> healthData,
    int windowDays,
  ) async {
    final suggestions = <HealthBasedHabitSuggestion>[];
    
    final waterData = healthData.where((p) => p.type == HealthDataType.WATER).toList();
    if (waterData.isEmpty) return suggestions;
    
    // Calculate daily water intake
    final dailyWater = <DateTime, double>{};
    for (final point in waterData) {
      final day = DateTime(point.dateFrom.year, point.dateFrom.month, point.dateFrom.day);
      final value = (point.value as NumericHealthValue).numericValue;
      dailyWater[day] = (dailyWater[day] ?? 0) + value;
    }
    
    if (dailyWater.isEmpty) return suggestions;
    
    final avgWater = dailyWater.values.reduce((a, b) => a + b) / dailyWater.length;
    
    // Generate hydration suggestions
    if (avgWater < 2000) { // Less than 2L per day
      suggestions.add(HealthBasedHabitSuggestion(
        name: 'Daily Hydration',
        description: 'Drink at least 8 glasses of water throughout the day',
        category: 'Health',
        frequency: HabitFrequency.daily,
        healthDataType: HealthDataType.WATER,
        suggestedThreshold: 2500,
        currentAverage: avgWater,
        improvementPotential: 0.7,
        priority: HabitPriority.medium,
        confidence: 0.8,
        reasoning: 'Your current water intake of ${(avgWater/1000).toStringAsFixed(1)}L is below recommended levels. Proper hydration supports overall health.',
      ));
    }
    
    return suggestions;
  }

  /// Analyze mindfulness data and generate suggestions
  static Future<List<HealthBasedHabitSuggestion>> _analyzeMindfulnessData(
    List<HealthDataPoint> healthData,
    int windowDays,
  ) async {
    final suggestions = <HealthBasedHabitSuggestion>[];
    
    final mindfulnessData = healthData.where((p) => p.type == HealthDataType.MINDFULNESS).toList();
    
    // If no mindfulness data, suggest starting meditation
    if (mindfulnessData.isEmpty) {
      suggestions.add(HealthBasedHabitSuggestion(
        name: 'Daily Meditation',
        description: 'Start with 5 minutes of daily meditation for mental wellness',
        category: 'Mindfulness',
        frequency: HabitFrequency.daily,
        healthDataType: HealthDataType.MINDFULNESS,
        suggestedThreshold: 5,
        currentAverage: 0,
        improvementPotential: 0.8,
        priority: HabitPriority.medium,
        confidence: 0.7,
        reasoning: 'No mindfulness activity detected. Regular meditation can reduce stress and improve mental well-being.',
      ));
      return suggestions;
    }
    
    // Calculate daily meditation time
    final dailyMindfulness = <DateTime, double>{};
    for (final point in mindfulnessData) {
      final day = DateTime(point.dateFrom.year, point.dateFrom.month, point.dateFrom.day);
      final value = (point.value as NumericHealthValue).numericValue;
      dailyMindfulness[day] = (dailyMindfulness[day] ?? 0) + value;
    }
    
    final avgMindfulness = dailyMindfulness.values.reduce((a, b) => a + b) / dailyMindfulness.length;
    
    // Suggest increasing meditation time if current practice is minimal
    if (avgMindfulness < 10) {
      suggestions.add(HealthBasedHabitSuggestion(
        name: 'Extended Meditation',
        description: 'Gradually increase your meditation practice to 10-15 minutes',
        category: 'Mindfulness',
        frequency: HabitFrequency.daily,
        healthDataType: HealthDataType.MINDFULNESS,
        suggestedThreshold: math.min(avgMindfulness + 5, 15),
        currentAverage: avgMindfulness,
        improvementPotential: 0.6,
        priority: HabitPriority.low,
        confidence: 0.7,
        reasoning: 'Your current meditation practice of ${avgMindfulness.round()} minutes is good. Extending it can provide additional mental health benefits.',
      ));
    }
    
    return suggestions;
  }

  /// Analyze weight data and generate suggestions
  static Future<List<HealthBasedHabitSuggestion>> _analyzeWeightData(
    List<HealthDataPoint> healthData,
    int windowDays,
  ) async {
    final suggestions = <HealthBasedHabitSuggestion>[];
    
    final weightData = healthData.where((p) => p.type == HealthDataType.WEIGHT).toList();
    
    // If no weight tracking, suggest starting
    if (weightData.isEmpty) {
      suggestions.add(HealthBasedHabitSuggestion(
        name: 'Daily Weight Tracking',
        description: 'Track your weight daily for better health awareness',
        category: 'Health',
        frequency: HabitFrequency.daily,
        healthDataType: HealthDataType.WEIGHT,
        suggestedThreshold: 1, // One measurement per day
        currentAverage: 0,
        improvementPotential: 0.5,
        priority: HabitPriority.low,
        confidence: 0.6,
        reasoning: 'No weight tracking detected. Regular weight monitoring can help maintain health awareness.',
      ));
      return suggestions;
    }
    
    // Calculate tracking frequency
    final trackingDays = weightData.map((p) => 
      DateTime(p.dateFrom.year, p.dateFrom.month, p.dateFrom.day)
    ).toSet().length;
    
    final trackingFrequency = trackingDays / windowDays;
    
    // Suggest more consistent tracking if needed
    if (trackingFrequency < 0.5) {
      suggestions.add(HealthBasedHabitSuggestion(
        name: 'Consistent Weight Tracking',
        description: 'Track your weight more regularly for better health monitoring',
        category: 'Health',
        frequency: HabitFrequency.daily,
        healthDataType: HealthDataType.WEIGHT,
        suggestedThreshold: 1,
        currentAverage: trackingFrequency,
        improvementPotential: 0.4,
        priority: HabitPriority.low,
        confidence: 0.6,
        reasoning: 'You track your weight ${(trackingFrequency * 100).round()}% of days. More consistent tracking can provide better health insights.',
      ));
    }
    
    return suggestions;
  }

  /// Calculate consistency score for a list of values
  static double _calculateConsistency(List<double> values) {
    if (values.length < 2) return 1.0;
    
    final mean = values.reduce((a, b) => a + b) / values.length;
    final variance = values.map((v) => math.pow(v - mean, 2)).reduce((a, b) => a + b) / values.length;
    final standardDeviation = math.sqrt(variance);
    
    // Normalize consistency score (lower standard deviation = higher consistency)
    final coefficientOfVariation = standardDeviation / mean;
    return math.max(0.0, 1.0 - coefficientOfVariation);
  }

  /// Generate basic health suggestions when no data is available
  static List<HealthBasedHabitSuggestion> _getBasicHealthSuggestions() {
    return [
      HealthBasedHabitSuggestion(
        name: 'Daily Walk',
        description: 'Take a 20-minute walk every day',
        category: 'Fitness',
        frequency: HabitFrequency.daily,
        healthDataType: HealthDataType.STEPS,
        suggestedThreshold: 5000,
        currentAverage: 0,
        improvementPotential: 0.8,
        priority: HabitPriority.high,
        confidence: 0.7,
        reasoning: 'Walking is a fundamental activity for maintaining good health and fitness.',
      ),
      HealthBasedHabitSuggestion(
        name: 'Drink Water',
        description: 'Stay hydrated by drinking 8 glasses of water daily',
        category: 'Health',
        frequency: HabitFrequency.daily,
        healthDataType: HealthDataType.WATER,
        suggestedThreshold: 2000,
        currentAverage: 0,
        improvementPotential: 0.7,
        priority: HabitPriority.medium,
        confidence: 0.8,
        reasoning: 'Proper hydration is essential for optimal body function and health.',
      ),
      HealthBasedHabitSuggestion(
        name: 'Meditation',
        description: 'Practice 10 minutes of daily meditation',
        category: 'Mindfulness',
        frequency: HabitFrequency.daily,
        healthDataType: HealthDataType.MINDFULNESS,
        suggestedThreshold: 10,
        currentAverage: 0,
        improvementPotential: 0.6,
        priority: HabitPriority.medium,
        confidence: 0.7,
        reasoning: 'Regular meditation can reduce stress and improve mental well-being.',
      ),
    ];
  }

  /// Create health mapping for a habit
  static Future<HabitHealthMapping?> _createHealthMapping({
    required Habit habit,
    required HealthDataType healthDataType,
    double? customThreshold,
    String? thresholdLevel,
  }) async {
    try {
      // Get default mapping configuration
      final defaultMapping = HealthHabitMappingService.healthMappings[healthDataType];
      if (defaultMapping == null) return null;
      
      // Determine threshold
      double threshold;
      String level;
      
      if (customThreshold != null) {
        threshold = customThreshold;
        level = thresholdLevel ?? 'custom';
      } else {
        level = thresholdLevel ?? 'moderate';
        threshold = defaultMapping.thresholds[level] ?? defaultMapping.thresholds['moderate']!;
      }
      
      return HabitHealthMapping(
        habitId: habit.id,
        healthDataType: healthDataType,
        threshold: threshold,
        thresholdLevel: level,
        relevanceScore: 1.0, // Perfect relevance since it's explicitly set
        unit: defaultMapping.unit,
        description: defaultMapping.description,
      );
      
    } catch (e) {
      AppLogger.error('Error creating health mapping', e);
      return null;
    }
  }

  /// Store habit-health mapping
  static Future<void> _storeHabitHealthMapping(String habitId, HabitHealthMapping mapping) async {
    // This would typically store in a database or shared preferences
    // For now, we'll just log it
    AppLogger.info('Storing health mapping for habit $habitId: ${mapping.toJson()}');
  }



  /// Analyze health patterns
  static Future<Map<HealthDataType, HealthPatternAnalysis>> _analyzeHealthPatterns(
    List<HealthDataPoint> healthData,
    int windowDays,
  ) async {
    final patterns = <HealthDataType, HealthPatternAnalysis>{};
    
    for (final healthType in HealthDataType.values) {
      final typeData = healthData.where((p) => p.type == healthType).toList();
      if (typeData.isEmpty) continue;
      
      final analysis = _analyzeHealthTypePattern(typeData, windowDays);
      patterns[healthType] = analysis;
    }
    
    return patterns;
  }

  /// Analyze pattern for a specific health type
  static HealthPatternAnalysis _analyzeHealthTypePattern(
    List<HealthDataPoint> data,
    int windowDays,
  ) {
    // Calculate daily values
    final dailyValues = <DateTime, double>{};
    for (final point in data) {
      final day = DateTime(point.dateFrom.year, point.dateFrom.month, point.dateFrom.day);
      final value = (point.value as NumericHealthValue).numericValue;
      dailyValues[day] = (dailyValues[day] ?? 0) + value;
    }
    
    final values = dailyValues.values.toList();
    if (values.isEmpty) {
      return HealthPatternAnalysis(
        average: 0,
        consistency: 0,
        trend: 0,
        improvementPotential: 0,
      );
    }
    
    final average = values.reduce((a, b) => a + b) / values.length;
    final consistency = _calculateConsistency(values);
    
    // Calculate trend (simple linear regression slope)
    double trend = 0;
    if (values.length > 1) {
      final n = values.length;
      final sumX = (n * (n - 1)) / 2; // Sum of indices 0, 1, 2, ...
      final sumY = values.reduce((a, b) => a + b);
      final sumXY = values.asMap().entries.map((e) => e.key * e.value).reduce((a, b) => a + b);
      final sumX2 = (n * (n - 1) * (2 * n - 1)) / 6; // Sum of squares of indices
      
      trend = (n * sumXY - sumX * sumY) / (n * sumX2 - sumX * sumX);
    }
    
    // Calculate improvement potential based on consistency and trend
    double improvementPotential = 0;
    if (consistency < 0.7) improvementPotential += 0.3;
    if (trend < 0) improvementPotential += 0.4;
    if (average < _getBenchmarkValue(data.first.type)) improvementPotential += 0.5;
    
    return HealthPatternAnalysis(
      average: average,
      consistency: consistency,
      trend: trend,
      improvementPotential: math.min(improvementPotential, 1.0),
    );
  }

  /// Get benchmark value for a health type
  static double _getBenchmarkValue(HealthDataType type) {
    switch (type) {
      case HealthDataType.STEPS:
        return 8000;
      case HealthDataType.ACTIVE_ENERGY_BURNED:
        return 300;
      case HealthDataType.SLEEP_IN_BED:
        return 420; // 7 hours in minutes
      case HealthDataType.WATER:
        return 2000;
      case HealthDataType.MINDFULNESS:
        return 10;
      case HealthDataType.WEIGHT:
        return 1; // Daily tracking
      default:
        return 0;
    }
  }

  /// Check if user has related habit
  static Future<bool> _hasRelatedHabit(List<Habit> habits, HealthDataType healthType) async {
    for (final habit in habits) {
      final mapping = await HealthHabitMappingService.analyzeHabitForHealthMapping(habit);
      if (mapping?.healthDataType == healthType) {
        return true;
      }
    }
    return false;
  }

  /// Generate recommendation for health type
  static Future<PersonalizedHabitRecommendation?> _generateRecommendationForHealthType(
    HealthDataType healthType,
    HealthPatternAnalysis analysis,
    List<Habit> existingHabits,
  ) async {
    // Implementation would generate specific recommendations based on health type and analysis
    // This is a simplified version
    return null; // Placeholder
  }

  /// Get basic recommendations when no health data is available
  static List<PersonalizedHabitRecommendation> _getBasicRecommendations(List<Habit> existingHabits) {
    // Return basic recommendations
    return [];
  }
}

/// Health-based habit suggestion
class HealthBasedHabitSuggestion {
  final String name;
  final String description;
  final String category;
  final HabitFrequency frequency;
  final HealthDataType healthDataType;
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
}

/// Habit priority levels
enum HabitPriority {
  low,
  medium,
  high;
  
  int get value {
    switch (this) {
      case HabitPriority.low:
        return 1;
      case HabitPriority.medium:
        return 2;
      case HabitPriority.high:
        return 3;
    }
  }
  
  int compareTo(HabitPriority other) {
    return value.compareTo(other.value);
  }
}

/// Health pattern analysis
class HealthPatternAnalysis {
  final double average;
  final double consistency;
  final double trend;
  final double improvementPotential;
  
  HealthPatternAnalysis({
    required this.average,
    required this.consistency,
    required this.trend,
    required this.improvementPotential,
  });
}

/// Personalized habit recommendation
class PersonalizedHabitRecommendation {
  final String name;
  final String description;
  final String category;
  final double improvementPotential;
  final double feasibilityScore;
  final String reasoning;
  
  PersonalizedHabitRecommendation({
    required this.name,
    required this.description,
    required this.category,
    required this.improvementPotential,
    required this.feasibilityScore,
    required this.reasoning,
  });
}