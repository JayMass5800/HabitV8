import 'dart:math' as math;
import 'package:health/health.dart';
import '../domain/model/habit.dart';
import 'health_service.dart';
import 'logging_service.dart';

/// Health-Habit Mapping Service
/// 
/// This service provides intelligent mapping between health metrics and habits,
/// enabling automatic completion based on health data patterns and thresholds.
class HealthHabitMappingService {
  
  /// Map of health data types to their corresponding habit keywords and thresholds
  static const Map<HealthDataType, HealthHabitMapping> healthMappings = {
    HealthDataType.STEPS: HealthHabitMapping(
      keywords: [
        // Basic walking terms
        'walk', 'walking', 'walked', 'step', 'steps', 'stepping',
        // Running and jogging
        'run', 'running', 'jog', 'jogging', 'sprint', 'sprinting',
        // Movement and activity
        'move', 'movement', 'moving', 'active', 'activity', 'stroll', 'strolling',
        'hike', 'hiking', 'trek', 'trekking', 'march', 'marching',
        // Exercise terms that involve steps
        'exercise', 'cardio', 'fitness', 'aerobic', 'aerobics',
        // Specific activities
        'treadmill', 'elliptical', 'stepper', 'stairs', 'climbing',
        // Daily activities
        'commute', 'commuting', 'errands', 'shopping', 'patrol', 'patrolling',
        // Distance terms (often correlate with steps)
        'distance', 'mile', 'miles', 'km', 'kilometer', 'meters',
      ],
      thresholds: {
        'minimal': 2000,    // Light activity
        'moderate': 5000,   // Moderate activity
        'active': 8000,     // Active lifestyle
        'very_active': 12000, // Very active
      },
      unit: 'steps',
      description: 'Daily step count for walking and movement habits',
    ),
    
    HealthDataType.ACTIVE_ENERGY_BURNED: HealthHabitMapping(
      keywords: [
        // General exercise terms
        'exercise', 'exercising', 'workout', 'working', 'train', 'training',
        'fitness', 'fit', 'active', 'activity', 'sport', 'sports',
        // Gym and equipment
        'gym', 'gymnasium', 'weights', 'lifting', 'strength', 'resistance',
        'dumbbell', 'barbell', 'kettlebell', 'machine', 'equipment',
        // Cardio activities
        'cardio', 'cardiovascular', 'aerobic', 'aerobics', 'hiit',
        'run', 'running', 'jog', 'jogging', 'sprint', 'bike', 'biking',
        'cycle', 'cycling', 'swim', 'swimming', 'row', 'rowing',
        // Specific workouts
        'crossfit', 'pilates', 'yoga', 'zumba', 'dance', 'dancing',
        'boxing', 'kickboxing', 'martial', 'karate', 'taekwondo',
        // Equipment and activities
        'treadmill', 'elliptical', 'stepper', 'climber', 'vibration', 'plate', 'vibrating',
        'tennis', 'basketball', 'football', 'soccer', 'volleyball',
        'badminton', 'squash', 'racquet', 'golf', 'baseball',
        // Outdoor activities
        'hike', 'hiking', 'climb', 'climbing', 'ski', 'skiing',
        'surf', 'surfing', 'kayak', 'kayaking', 'paddle',
        // Body parts (often in exercise context)
        'abs', 'core', 'legs', 'arms', 'chest', 'back', 'shoulders',
        // Intensity terms
        'intense', 'vigorous', 'hard', 'tough', 'challenging',
        // Calorie-related terms
        'burn', 'burning', 'calories', 'calorie', 'energy',
      ],
      thresholds: {
        'minimal': 100,     // Light exercise (100 cal)
        'moderate': 250,    // Moderate exercise (250 cal)
        'active': 400,      // Active exercise (400 cal)
        'very_active': 600, // Intense exercise (600+ cal)
      },
      unit: 'calories',
      description: 'Active energy burned for exercise and fitness habits',
    ),
    
    HealthDataType.SLEEP_IN_BED: HealthHabitMapping(
      keywords: [
        // Basic sleep terms
        'sleep', 'sleeping', 'slept', 'asleep', 'sleepy',
        'rest', 'resting', 'rested', 'restful',
        // Bedtime terms
        'bed', 'bedtime', 'bedroom', 'mattress', 'pillow',
        'nap', 'napping', 'napped', 'siesta', 'doze', 'dozing',
        // Time-related sleep terms
        'night', 'nighttime', 'evening', 'late', 'early',
        'hours', 'hour', 'time', 'schedule', 'routine',
        // Sleep quality terms
        'deep', 'light', 'rem', 'dream', 'dreaming',
        'slumber', 'snooze', 'drowsy', 'tired', 'fatigue',
        // Sleep hygiene terms
        'wind', 'down', 'relax', 'unwind', 'calm', 'peaceful',
        'quiet', 'dark', 'comfortable', 'cozy',
        // Sleep problems (people track to improve)
        'insomnia', 'restless', 'toss', 'turn', 'wake', 'waking',
        // Recovery terms
        'recover', 'recovery', 'recharge', 'rejuvenate', 'refresh',
      ],
      thresholds: {
        'minimal': 6.0,     // 6 hours minimum
        'moderate': 7.0,    // 7 hours recommended
        'active': 8.0,      // 8 hours optimal
        'very_active': 9.0, // 9+ hours extended
      },
      unit: 'hours',
      description: 'Sleep duration for rest and recovery habits',
    ),
    
    HealthDataType.WATER: HealthHabitMapping(
      keywords: [
        // Basic water terms
        'water', 'h2o', 'hydrate', 'hydrating', 'hydration',
        'drink', 'drinking', 'drank', 'sip', 'sipping',
        // Fluid terms
        'fluid', 'fluids', 'liquid', 'liquids', 'beverage', 'beverages',
        // Containers and measurements
        'bottle', 'bottles', 'glass', 'glasses', 'cup', 'cups',
        'liter', 'liters', 'litre', 'litres', 'ml', 'milliliter',
        'ounce', 'ounces', 'oz', 'gallon', 'quart', 'pint',
        // Types of water/drinks
        'tap', 'filtered', 'spring', 'mineral', 'sparkling',
        'plain', 'still', 'cold', 'warm', 'hot', 'ice', 'iced',
        // Health-related terms
        'thirst', 'thirsty', 'dehydrate', 'dehydration',
        'electrolyte', 'electrolytes', 'replenish', 'refill',
        // Daily habits
        'morning', 'afternoon', 'evening', 'meal', 'meals',
        'before', 'after', 'during', 'workout', 'exercise',
        // Tracking terms
        'intake', 'consumption', 'amount', 'quantity', 'goal',
        'target', 'daily', 'hourly', 'regular', 'consistent',
      ],
      thresholds: {
        'minimal': 1000,    // 1L minimum
        'moderate': 2000,   // 2L recommended
        'active': 3000,     // 3L active
        'very_active': 4000, // 4L+ high activity
      },
      unit: 'ml',
      description: 'Water intake for hydration habits',
    ),
    
    HealthDataType.MINDFULNESS: HealthHabitMapping(
      keywords: [
        // Meditation terms
        'meditate', 'meditation', 'meditative', 'meditating',
        'mindful', 'mindfulness', 'mindfully', 'aware', 'awareness',
        // Breathing practices
        'breathe', 'breathing', 'breath', 'breathwork',
        'inhale', 'exhale', 'pranayama', 'respiratory',
        // Mental states
        'calm', 'calming', 'peace', 'peaceful', 'tranquil', 'serenity',
        'zen', 'zenful', 'centered', 'grounded', 'present', 'presence',
        'focus', 'focused', 'concentration', 'concentrate',
        // Relaxation terms
        'relax', 'relaxation', 'relaxing', 'unwind', 'unwinding',
        'stress', 'destress', 'relief', 'tension', 'release',
        'quiet', 'silence', 'still', 'stillness',
        // Spiritual/philosophical terms
        'spiritual', 'soul', 'inner', 'self', 'reflection', 'reflect',
        'contemplation', 'contemplate', 'introspection',
        'gratitude', 'grateful', 'thankful', 'appreciation',
        // Practices and techniques
        'vipassana', 'transcendental', 'guided', 'mantra', 'chant',
        'visualization', 'visualize', 'imagery', 'affirmation',
        'prayer', 'praying', 'devotion', 'worship',
        // Apps and tools
        'headspace', 'calm', 'insight', 'timer', 'bell', 'gong',
        'cushion', 'mat', 'candle', 'incense',
        // Time-related
        'minutes', 'minute', 'session', 'practice', 'daily',
        'morning', 'evening', 'routine', 'habit',
      ],
      thresholds: {
        'minimal': 5,       // 5 minutes minimum
        'moderate': 10,     // 10 minutes recommended
        'active': 20,       // 20 minutes active practice
        'very_active': 30,  // 30+ minutes extended
      },
      unit: 'minutes',
      description: 'Mindfulness and meditation practice duration',
    ),
    
    HealthDataType.WEIGHT: HealthHabitMapping(
      keywords: [
        // Basic weight terms
        'weight', 'weigh', 'weighing', 'weighed', 'pounds', 'lbs',
        'kilograms', 'kg', 'kilogram', 'grams', 'gram',
        // Scale and measurement
        'scale', 'scales', 'measure', 'measuring', 'measurement',
        'track', 'tracking', 'monitor', 'monitoring', 'record',
        // Body terms
        'body', 'bodily', 'mass', 'bmi', 'index', 'composition',
        'fat', 'muscle', 'lean', 'bone', 'density',
        // Health tracking
        'health', 'healthy', 'fitness', 'progress', 'goal',
        'target', 'ideal', 'maintain', 'maintenance',
        // Weight management
        'lose', 'losing', 'loss', 'gain', 'gaining', 'maintain',
        'diet', 'dieting', 'nutrition', 'eating', 'food',
        // Daily habits
        'morning', 'daily', 'weekly', 'regular', 'routine',
        'consistent', 'habit', 'check', 'checking',
        // Medical/health terms
        'doctor', 'physician', 'medical', 'health', 'checkup',
        'appointment', 'visit', 'clinic', 'hospital',
        // Emotional/motivational
        'motivation', 'motivated', 'discipline', 'commitment',
        'accountability', 'responsible', 'mindful',
      ],
      thresholds: {
        'minimal': 1,       // Any weight measurement
        'moderate': 1,      // Daily weighing
        'active': 1,        // Consistent tracking
        'very_active': 1,   // Multiple measurements
      },
      unit: 'measurements',
      description: 'Weight tracking for body monitoring habits',
    ),
  };

  /// Analyze a habit and determine its health mapping potential
  static Future<HabitHealthMapping?> analyzeHabitForHealthMapping(Habit habit) async {
    try {
      final habitName = habit.name.toLowerCase();
      final habitDescription = (habit.description ?? '').toLowerCase();
      final searchText = '$habitName $habitDescription';
      
      // Find matching health data types
      final matches = <HealthDataType, double>{};
      
      for (final entry in healthMappings.entries) {
        final healthType = entry.key;
        final mapping = entry.value;
        
        double relevanceScore = 0.0;
        
        // Check for keyword matches
        for (final keyword in mapping.keywords) {
          if (searchText.contains(keyword)) {
            relevanceScore += 1.0;
            
            // Bonus for exact matches
            if (habitName == keyword || habitName.contains(keyword)) {
              relevanceScore += 0.5;
            }
          }
        }
        
        // Normalize score based on number of keywords
        if (relevanceScore > 0) {
          relevanceScore = relevanceScore / mapping.keywords.length;
          matches[healthType] = relevanceScore;
        }
      }
      
      if (matches.isEmpty) {
        return null;
      }
      
      // Find the best match
      final bestMatch = matches.entries.reduce((a, b) => a.value > b.value ? a : b);
      
      if (bestMatch.value < 0.1) {
        return null; // Too weak correlation
      }
      
      // Try to extract custom threshold from habit name/description first
      final customThreshold = _extractCustomThreshold(searchText, bestMatch.key);
      
      // Get the mapping for the best match
      final mapping = healthMappings[bestMatch.key]!;
      
      double threshold;
      String thresholdLevel;
      
      if (customThreshold != null) {
        // Use custom threshold extracted from habit text
        threshold = customThreshold;
        thresholdLevel = 'custom';
        AppLogger.info('Using custom threshold for habit ${habit.name}: $threshold');
      } else {
        // Determine appropriate threshold based on habit frequency and difficulty
        thresholdLevel = 'moderate'; // Default
        
        if (habit.frequency == HabitFrequency.daily) {
          thresholdLevel = 'moderate';
        } else if (habit.frequency == HabitFrequency.weekly) {
          thresholdLevel = 'active';
        } else if (habit.frequency == HabitFrequency.monthly) {
          thresholdLevel = 'very_active';
        }
        
        // Adjust based on habit name patterns
        if (searchText.contains('light') || searchText.contains('easy') || searchText.contains('gentle')) {
          thresholdLevel = 'minimal';
        } else if (searchText.contains('intense') || searchText.contains('hard') || searchText.contains('vigorous')) {
          thresholdLevel = 'very_active';
        }
        
        threshold = mapping.thresholds[thresholdLevel] ?? mapping.thresholds['moderate']!;
      }
      
      return HabitHealthMapping(
        habitId: habit.id,
        healthDataType: bestMatch.key,
        threshold: threshold,
        thresholdLevel: thresholdLevel,
        relevanceScore: bestMatch.value,
        unit: mapping.unit,
        description: mapping.description,
      );
      
    } catch (e) {
      AppLogger.error('Error analyzing habit for health mapping: ${habit.name}', e);
      return null;
    }
  }

  /// Check if a habit should be auto-completed based on health data
  static Future<HabitCompletionResult> checkHabitCompletion({
    required Habit habit,
    required DateTime date,
    HabitHealthMapping? mapping,
  }) async {
    try {
      // Get or create mapping
      mapping ??= await analyzeHabitForHealthMapping(habit);
      
      if (mapping == null) {
        return HabitCompletionResult(
          shouldComplete: false,
          reason: 'No health mapping found for this habit',
        );
      }
      
      // Get health data for the specified date
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));
      
      final healthData = await HealthService.getHealthDataFromTypes(
        types: [mapping.healthDataType],
        startTime: startOfDay,
        endTime: endOfDay,
      );
      
      if (healthData.isEmpty) {
        // Provide specific guidance for water tracking
        if (mapping.healthDataType == HealthDataType.WATER) {
          return HabitCompletionResult(
            shouldComplete: false,
            reason: 'No water intake data found. Water must be manually logged in your health app (Apple Health, Google Health, etc.) to enable auto-completion.',
          );
        }
        
        return HabitCompletionResult(
          shouldComplete: false,
          reason: 'No health data available for ${mapping.healthDataType.name}',
        );
      }
      
      // Calculate total value for the day
      double totalValue = 0.0;
      int dataPoints = 0;
      
      for (final point in healthData) {
        if (point.value is NumericHealthValue) {
          final value = (point.value as NumericHealthValue).numericValue;
          
          // Special handling for different health types
          switch (mapping.healthDataType) {
            case HealthDataType.SLEEP_IN_BED:
              // Convert minutes to hours for sleep
              totalValue += value / 60.0;
              break;
            case HealthDataType.WEIGHT:
              // For weight, just count measurements
              dataPoints++;
              totalValue = dataPoints.toDouble();
              break;
            default:
              totalValue += value;
          }
        }
      }
      
      // Check if threshold is met
      final thresholdMet = totalValue >= mapping.threshold;
      
      if (thresholdMet) {
        String reason = _generateCompletionReason(mapping, totalValue);
        
        return HabitCompletionResult(
          shouldComplete: true,
          reason: reason,
          healthValue: totalValue,
          threshold: mapping.threshold,
          healthDataType: mapping.healthDataType,
          confidence: _calculateConfidence(mapping, totalValue, healthData.length),
        );
      } else {
        return HabitCompletionResult(
          shouldComplete: false,
          reason: 'Threshold not met: ${totalValue.round()} ${mapping.unit} < ${mapping.threshold.round()} ${mapping.unit}',
          healthValue: totalValue,
          threshold: mapping.threshold,
          healthDataType: mapping.healthDataType,
        );
      }
      
    } catch (e) {
      AppLogger.error('Error checking habit completion for ${habit.name}', e);
      return HabitCompletionResult(
        shouldComplete: false,
        reason: 'Error checking health data: $e',
      );
    }
  }

  /// Generate a human-readable completion reason
  static String _generateCompletionReason(HabitHealthMapping mapping, double value) {
    final roundedValue = value.round();
    
    switch (mapping.healthDataType) {
      case HealthDataType.STEPS:
        if (roundedValue >= 12000) {
          return 'Excellent! You walked $roundedValue steps today 🚶‍♂️';
        } else if (roundedValue >= 8000) {
          return 'Great job! You reached $roundedValue steps today 👟';
        } else {
          return 'You walked $roundedValue steps today ✅';
        }
        
      case HealthDataType.ACTIVE_ENERGY_BURNED:
        if (roundedValue >= 600) {
          return 'Amazing workout! You burned $roundedValue calories 🔥';
        } else if (roundedValue >= 400) {
          return 'Great exercise session! $roundedValue calories burned 💪';
        } else {
          return 'You burned $roundedValue calories through activity 🏃‍♂️';
        }
        
      case HealthDataType.SLEEP_IN_BED:
        final hours = (value * 10).round() / 10; // Round to 1 decimal
        if (hours >= 8.5) {
          return 'Excellent rest! You slept ${hours}h last night 😴';
        } else if (hours >= 7.5) {
          return 'Good sleep! You got ${hours}h of rest 🛏️';
        } else {
          return 'You slept ${hours}h last night 💤';
        }
        
      case HealthDataType.WATER:
        final liters = (value / 1000 * 10).round() / 10; // Convert to liters, round to 1 decimal
        if (liters >= 3.0) {
          return 'Excellent hydration! You drank ${liters}L of water 💧';
        } else if (liters >= 2.0) {
          return 'Great hydration! ${liters}L of water consumed 🥤';
        } else {
          return 'You drank ${liters}L of water today 💦';
        }
        
      case HealthDataType.MINDFULNESS:
        if (roundedValue >= 30) {
          return 'Deep meditation! You practiced for ${roundedValue} minutes 🧘‍♂️';
        } else if (roundedValue >= 15) {
          return 'Great mindfulness session! ${roundedValue} minutes of practice 🧘‍♀️';
        } else {
          return 'You meditated for ${roundedValue} minutes today ☮️';
        }
        
      case HealthDataType.WEIGHT:
        return 'Weight tracked successfully! 📊';
        
      default:
        return 'Health goal achieved! ${roundedValue} ${mapping.unit} ✅';
    }
  }

  /// Calculate confidence score for the completion
  static double _calculateConfidence(HabitHealthMapping mapping, double value, int dataPointCount) {
    double confidence = 0.5; // Base confidence
    
    // Higher confidence for more data points
    if (dataPointCount >= 5) {
      confidence += 0.2;
    } else if (dataPointCount >= 3) {
      confidence += 0.1;
    }
    
    // Higher confidence for exceeding threshold significantly
    final exceedanceRatio = value / mapping.threshold;
    if (exceedanceRatio >= 1.5) {
      confidence += 0.2;
    } else if (exceedanceRatio >= 1.2) {
      confidence += 0.1;
    }
    
    // Higher confidence for high relevance score
    if (mapping.relevanceScore >= 0.8) {
      confidence += 0.1;
    }
    
    return math.min(confidence, 1.0);
  }

  /// Get all habits that can be mapped to health data
  static Future<List<HabitHealthMapping>> getMappableHabits(List<Habit> habits) async {
    final mappings = <HabitHealthMapping>[];
    
    for (final habit in habits) {
      final mapping = await analyzeHabitForHealthMapping(habit);
      if (mapping != null) {
        mappings.add(mapping);
      }
    }
    
    return mappings;
  }

  /// Get health data types that are actively used by habits
  static Future<Set<HealthDataType>> getActiveHealthDataTypes(List<Habit> habits) async {
    final activeTypes = <HealthDataType>{};
    
    for (final habit in habits) {
      final mapping = await analyzeHabitForHealthMapping(habit);
      if (mapping != null) {
        activeTypes.add(mapping.healthDataType);
      }
    }
    
    return activeTypes;
  }

  /// Suggest optimal thresholds for a habit based on user's historical health data
  static Future<Map<String, double>> suggestOptimalThresholds({
    required Habit habit,
    required HealthDataType healthDataType,
    int analysisWindowDays = 30,
  }) async {
    try {
      final endDate = DateTime.now();
      final startDate = endDate.subtract(Duration(days: analysisWindowDays));
      
      final healthData = await HealthService.getHealthDataFromTypes(
        types: [healthDataType],
        startTime: startDate,
        endTime: endDate,
      );
      
      if (healthData.length < 7) {
        // Not enough data, return default thresholds
        return healthMappings[healthDataType]?.thresholds ?? {};
      }
      
      // Calculate daily values
      final dailyValues = <DateTime, double>{};
      
      for (final point in healthData) {
        final day = DateTime(point.dateFrom.year, point.dateFrom.month, point.dateFrom.day);
        double value = 0.0;
        
        if (point.value is NumericHealthValue) {
          value = (point.value as NumericHealthValue).numericValue.toDouble();
          
          // Convert units as needed
          if (healthDataType == HealthDataType.SLEEP_IN_BED) {
            value = value / 60.0; // Convert minutes to hours
          }
        }
        
        dailyValues[day] = (dailyValues[day] ?? 0) + value;
      }
      
      final values = dailyValues.values.toList()..sort();
      
      if (values.isEmpty) {
        return healthMappings[healthDataType]?.thresholds ?? {};
      }
      
      // Calculate percentile-based thresholds
      final suggestions = <String, double>{};
      
      suggestions['minimal'] = _getPercentile(values, 25); // 25th percentile
      suggestions['moderate'] = _getPercentile(values, 50); // 50th percentile (median)
      suggestions['active'] = _getPercentile(values, 75); // 75th percentile
      suggestions['very_active'] = _getPercentile(values, 90); // 90th percentile
      
      return suggestions;
      
    } catch (e) {
      AppLogger.error('Error suggesting optimal thresholds', e);
      return healthMappings[healthDataType]?.thresholds ?? {};
    }
  }

  /// Calculate percentile value from a sorted list
  static double _getPercentile(List<double> sortedValues, int percentile) {
    if (sortedValues.isEmpty) return 0.0;
    
    final index = (percentile / 100.0 * (sortedValues.length - 1)).round();
    return sortedValues[index.clamp(0, sortedValues.length - 1)];
  }

  /// Get comprehensive mapping statistics
  static Future<Map<String, dynamic>> getMappingStatistics(List<Habit> habits) async {
    final stats = <String, dynamic>{};
    
    try {
      final mappings = await getMappableHabits(habits);
      
      stats['totalHabits'] = habits.length;
      stats['mappableHabits'] = mappings.length;
      stats['mappingPercentage'] = habits.isNotEmpty ? 
          (mappings.length / habits.length * 100).round() : 0;
      
      // Count by health data type
      final typeCount = <String, int>{};
      for (final mapping in mappings) {
        final typeName = mapping.healthDataType.name;
        typeCount[typeName] = (typeCount[typeName] ?? 0) + 1;
      }
      stats['mappingsByType'] = typeCount;
      
      // Average relevance score
      if (mappings.isNotEmpty) {
        final avgRelevance = mappings
            .map((m) => m.relevanceScore)
            .reduce((a, b) => a + b) / mappings.length;
        stats['averageRelevanceScore'] = (avgRelevance * 100).round();
      }
      
      // Most common health data types
      final sortedTypes = typeCount.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      stats['mostCommonTypes'] = sortedTypes.take(3)
          .map((e) => {'type': e.key, 'count': e.value})
          .toList();
      
    } catch (e) {
      AppLogger.error('Error calculating mapping statistics', e);
      stats['error'] = e.toString();
    }
    
    return stats;
  }

  /// Check if a habit should be recommended for manual tracking instead of health integration
  static bool shouldRecommendManualTracking(Habit habit) {
    final searchText = '${habit.name} ${habit.description ?? ''}'.toLowerCase();
    
    // Water habits are often better tracked manually due to lack of automatic tracking
    if (searchText.contains(RegExp(r'\b(water|hydrat|drink|fluid)\b'))) {
      return true;
    }
    
    // Other habits that might be better tracked manually
    // (can be expanded based on user feedback)
    
    return false;
  }

  /// Extract custom threshold from habit name/description
  static double? _extractCustomThreshold(String searchText, HealthDataType healthType) {
    try {
      // Define patterns for different health data types
      List<RegExp> patterns = [];
      
      switch (healthType) {
        case HealthDataType.STEPS:
          patterns = [
            RegExp(r'(\d+)\s*steps?', caseSensitive: false),
            RegExp(r'(\d+)\s*step', caseSensitive: false),
            RegExp(r'walk\s*(\d+)', caseSensitive: false),
            RegExp(r'(\d+)\s*walk', caseSensitive: false),
          ];
          break;
        case HealthDataType.ACTIVE_ENERGY_BURNED:
          patterns = [
            RegExp(r'(\d+)\s*cal(?:ories?)?', caseSensitive: false),
            RegExp(r'burn\s*(\d+)', caseSensitive: false),
            RegExp(r'(\d+)\s*burn', caseSensitive: false),
          ];
          break;
        case HealthDataType.WATER:
          patterns = [
            RegExp(r'(\d+)\s*ml', caseSensitive: false),
            RegExp(r'(\d+)\s*l(?:iter)?s?', caseSensitive: false),
            RegExp(r'(\d+)\s*cup', caseSensitive: false),
            RegExp(r'drink\s*(\d+)', caseSensitive: false),
          ];
          break;
        case HealthDataType.MINDFULNESS:
          patterns = [
            RegExp(r'(\d+)\s*min(?:ute)?s?', caseSensitive: false),
            RegExp(r'meditate\s*(\d+)', caseSensitive: false),
            RegExp(r'(\d+)\s*meditation', caseSensitive: false),
          ];
          break;
        case HealthDataType.SLEEP_IN_BED:
          patterns = [
            RegExp(r'(\d+)\s*h(?:our)?s?', caseSensitive: false),
            RegExp(r'sleep\s*(\d+)', caseSensitive: false),
            RegExp(r'(\d+)\s*sleep', caseSensitive: false),
          ];
          break;
        default:
          return null;
      }
      
      // Try to find a match with any of the patterns
      for (final pattern in patterns) {
        final match = pattern.firstMatch(searchText);
        if (match != null && match.group(1) != null) {
          final value = double.tryParse(match.group(1)!);
          if (value != null && value > 0) {
            // Apply unit conversions if needed
            switch (healthType) {
              case HealthDataType.WATER:
                // Convert liters to ml if needed
                if (searchText.toLowerCase().contains('l') && !searchText.toLowerCase().contains('ml')) {
                  return value * 1000; // Convert liters to ml
                }
                return value;
              case HealthDataType.SLEEP_IN_BED:
                // Sleep is stored in hours
                return value;
              default:
                return value;
            }
          }
        }
      }
      
      return null;
    } catch (e) {
      AppLogger.error('Error extracting custom threshold from: $searchText', e);
      return null;
    }
  }
}

/// Health-habit mapping configuration
class HealthHabitMapping {
  final List<String> keywords;
  final Map<String, double> thresholds;
  final String unit;
  final String description;
  
  const HealthHabitMapping({
    required this.keywords,
    required this.thresholds,
    required this.unit,
    required this.description,
  });
}

/// Individual habit-health mapping
class HabitHealthMapping {
  final String habitId;
  final HealthDataType healthDataType;
  final double threshold;
  final String thresholdLevel;
  final double relevanceScore;
  final String unit;
  final String description;
  
  HabitHealthMapping({
    required this.habitId,
    required this.healthDataType,
    required this.threshold,
    required this.thresholdLevel,
    required this.relevanceScore,
    required this.unit,
    required this.description,
  });
  
  Map<String, dynamic> toJson() => {
    'habitId': habitId,
    'healthDataType': healthDataType.name,
    'threshold': threshold,
    'thresholdLevel': thresholdLevel,
    'relevanceScore': relevanceScore,
    'unit': unit,
    'description': description,
  };
}

/// Result of habit completion check
class HabitCompletionResult {
  final bool shouldComplete;
  final String reason;
  final double? healthValue;
  final double? threshold;
  final HealthDataType? healthDataType;
  final double confidence;
  
  HabitCompletionResult({
    required this.shouldComplete,
    required this.reason,
    this.healthValue,
    this.threshold,
    this.healthDataType,
    this.confidence = 0.0,
  });
  
  Map<String, dynamic> toJson() => {
    'shouldComplete': shouldComplete,
    'reason': reason,
    'healthValue': healthValue,
    'threshold': threshold,
    'healthDataType': healthDataType?.name,
    'confidence': confidence,
  };
}