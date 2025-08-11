import 'logging_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SmartRecommendationsService {
  static const String _usedRecommendationsKey = 'used_recommendations';
  static const String _lastRecommendationRefreshKey = 'last_recommendation_refresh';
  static const int _recommendationRefreshDays = 7; // Refresh recommendations every 7 days

  /// Generate smart habit recommendations based on user data
  static Future<List<HabitRecommendation>> generateRecommendations({
    required List<Map<String, dynamic>> existingHabits,
    required Map<String, dynamic> userPreferences,
    Map<String, dynamic>? healthData,
  }) async {
    final List<HabitRecommendation> recommendations = [];

    try {
      // Check if we need to refresh recommendations
      await _checkAndRefreshRecommendations();

      // Get used recommendations to filter them out
      final usedRecommendations = await _getUsedRecommendations();

      // Analyze existing habits
      final habitAnalysis = _analyzeExistingHabits(existingHabits);

      // Get health-based recommendations
      if (healthData != null) {
        recommendations.addAll(_getHealthBasedRecommendations(healthData, habitAnalysis));
      }

      // Get time-based recommendations
      recommendations.addAll(_getTimeBasedRecommendations(habitAnalysis, userPreferences));

      // Get category-based recommendations
      recommendations.addAll(_getCategoryBasedRecommendations(habitAnalysis));

      // Get difficulty progression recommendations
      recommendations.addAll(_getDifficultyProgressionRecommendations(habitAnalysis));

      // Filter out used recommendations and existing habits
      final existingHabitTitles = existingHabits
          .map((h) => h['name']?.toString().toLowerCase() ?? '')
          .where((name) => name.isNotEmpty)
          .toSet();
      
      final filteredRecommendations = recommendations
          .where((rec) => 
              !usedRecommendations.contains(getRecommendationId(rec)) &&
              !existingHabitTitles.contains(rec.title.toLowerCase()))
          .toList();

      // Sort by priority and remove duplicates
      filteredRecommendations.sort((a, b) => b.priority.compareTo(a.priority));

      // Limit to top 10 recommendations
      final uniqueRecommendations = <String, HabitRecommendation>{};
      for (final rec in filteredRecommendations) {
        if (!uniqueRecommendations.containsKey(rec.title) && uniqueRecommendations.length < 10) {
          uniqueRecommendations[rec.title] = rec;
        }
      }

      AppLogger.info('Generated ${uniqueRecommendations.length} smart recommendations (${usedRecommendations.length} used + ${existingHabitTitles.length} existing habits filtered out)');
      return uniqueRecommendations.values.toList();

    } catch (e) {
      AppLogger.error('Failed to generate smart recommendations', e);
      return [];
    }
  }

  /// Mark a recommendation as used when a habit is created from it
  static Future<void> markRecommendationAsUsed(HabitRecommendation recommendation) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usedRecommendations = await _getUsedRecommendations();
      final recommendationId = getRecommendationId(recommendation);
      
      if (!usedRecommendations.contains(recommendationId)) {
        usedRecommendations.add(recommendationId);
        await prefs.setStringList(_usedRecommendationsKey, usedRecommendations);
        AppLogger.info('Marked recommendation as used: ${recommendation.title}');
      }
    } catch (e) {
      AppLogger.error('Failed to mark recommendation as used', e);
    }
  }

  /// Get list of used recommendation IDs
  static Future<List<String>> _getUsedRecommendations() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getStringList(_usedRecommendationsKey) ?? [];
    } catch (e) {
      AppLogger.error('Failed to get used recommendations', e);
      return [];
    }
  }

  /// Generate a unique ID for a recommendation based on its content
  static String getRecommendationId(HabitRecommendation recommendation) {
    return '${recommendation.title}_${recommendation.category}_${recommendation.difficulty}';
  }

  /// Check if recommendations need to be refreshed and clear used ones if needed
  static Future<void> _checkAndRefreshRecommendations() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastRefresh = prefs.getInt(_lastRecommendationRefreshKey) ?? 0;
      final now = DateTime.now().millisecondsSinceEpoch;
      final daysSinceRefresh = (now - lastRefresh) / (1000 * 60 * 60 * 24);

      if (daysSinceRefresh >= _recommendationRefreshDays) {
        // Clear used recommendations to allow them to appear again
        await prefs.remove(_usedRecommendationsKey);
        await prefs.setInt(_lastRecommendationRefreshKey, now);
        AppLogger.info('Refreshed recommendations - cleared used recommendations list');
      }
    } catch (e) {
      AppLogger.error('Failed to check recommendation refresh', e);
    }
  }

  /// Manually refresh recommendations (clear used list)
  static Future<void> refreshRecommendations() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_usedRecommendationsKey);
      await prefs.setInt(_lastRecommendationRefreshKey, DateTime.now().millisecondsSinceEpoch);
      AppLogger.info('Manually refreshed recommendations');
    } catch (e) {
      AppLogger.error('Failed to manually refresh recommendations', e);
    }
  }

  /// Get days until next automatic refresh
  static Future<int> getDaysUntilRefresh() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastRefresh = prefs.getInt(_lastRecommendationRefreshKey) ?? 0;
      final now = DateTime.now().millisecondsSinceEpoch;
      final daysSinceRefresh = (now - lastRefresh) / (1000 * 60 * 60 * 24);
      final daysUntilRefresh = _recommendationRefreshDays - daysSinceRefresh.ceil();
      return daysUntilRefresh > 0 ? daysUntilRefresh : 0;
    } catch (e) {
      AppLogger.error('Failed to get days until refresh', e);
      return 0;
    }
  }

  /// Analyze user's existing habits to find patterns
  static Map<String, dynamic> _analyzeExistingHabits(List<Map<String, dynamic>> habits) {
    final analysis = <String, dynamic>{
      'categories': <String, int>{},
      'timeSlots': <String, int>{},
      'difficulty': <String, int>{},
      'totalHabits': habits.length,
      'averageStreaks': 0,
      'completionRates': <double>[],
    };

    int totalStreaks = 0;

    for (final habit in habits) {
      // Category analysis
      final category = habit['category']?.toString() ?? 'Other';
      analysis['categories'][category] = (analysis['categories'][category] ?? 0) + 1;

      // Time slot analysis
      final reminderTime = habit['reminderTime']?.toString() ?? '';
      if (reminderTime.isNotEmpty) {
        final hour = int.tryParse(reminderTime.split(':')[0]) ?? 12;
        String timeSlot;
        if (hour < 6) {
          timeSlot = 'Late Night';
        } else if (hour < 12) {
          timeSlot = 'Morning';
        } else if (hour < 18) {
          timeSlot = 'Afternoon';
        } else {
          timeSlot = 'Evening';
        }

        analysis['timeSlots'][timeSlot] = (analysis['timeSlots'][timeSlot] ?? 0) + 1;
      }

      // Difficulty analysis
      final difficulty = habit['difficulty']?.toString() ?? 'Medium';
      analysis['difficulty'][difficulty] = (analysis['difficulty'][difficulty] ?? 0) + 1;

      // Streak analysis
      final streak = habit['currentStreak'] ?? 0;
      totalStreaks += streak as int;

      // Completion rate analysis
      final completionRate = habit['completionRate'] ?? 0.0;
      (analysis['completionRates'] as List<double>).add(completionRate as double);
    }

    if (habits.isNotEmpty) {
      analysis['averageStreaks'] = totalStreaks / habits.length;
    }

    return analysis;
  }

  /// Get health-based recommendations
  static List<HabitRecommendation> _getHealthBasedRecommendations(
    Map<String, dynamic> healthData,
    Map<String, dynamic> habitAnalysis,
  ) {
    final recommendations = <HabitRecommendation>[];

    // Steps-based recommendations
    final steps = healthData['steps'] ?? 0;
    if (steps < 8000) {
      recommendations.add(HabitRecommendation(
        title: 'Daily Walk',
        description: 'Take a 30-minute walk to reach 10,000 steps',
        category: 'Fitness',
        difficulty: 'Easy',
        reason: 'Your daily steps ($steps) are below the recommended 10,000',
        priority: 9,
        estimatedDuration: 30,
        suggestedTime: '07:00',
      ));
    }

    // Sleep-based recommendations
    final sleepHours = healthData['averageSleepHours'] ?? 8.0;
    if (sleepHours < 7.0) {
      recommendations.add(HabitRecommendation(
        title: 'Earlier Bedtime',
        description: 'Go to bed 30 minutes earlier for better sleep',
        category: 'Health',
        difficulty: 'Medium',
        reason: 'Your average sleep (${sleepHours.toStringAsFixed(1)} hours) is below optimal',
        priority: 8,
        estimatedDuration: 10,
        suggestedTime: '22:00',
      ));
    }

    // Exercise-based recommendations
    final exerciseMinutes = healthData['exerciseMinutes'] ?? 0;
    if (exerciseMinutes < 30) {
      recommendations.add(HabitRecommendation(
        title: 'Daily Exercise',
        description: 'Add 20 minutes of physical activity',
        category: 'Fitness',
        difficulty: 'Medium',
        reason: 'You need more daily exercise (current: $exerciseMinutes min)',
        priority: 7,
        estimatedDuration: 20,
        suggestedTime: '18:00',
      ));
    }

    return recommendations;
  }

  /// Get time-based recommendations
  static List<HabitRecommendation> _getTimeBasedRecommendations(
    Map<String, dynamic> habitAnalysis,
    Map<String, dynamic> userPreferences,
  ) {
    final recommendations = <HabitRecommendation>[];
    final timeSlots = habitAnalysis['timeSlots'] as Map<String, int>;

    // Find underutilized time slots
    final totalHabits = habitAnalysis['totalHabits'] as int;
    if (totalHabits > 0) {
      // Morning recommendations if morning is underutilized
      final morningHabits = timeSlots['Morning'] ?? 0;
      if (morningHabits < totalHabits * 0.3) {
        recommendations.add(HabitRecommendation(
          title: 'Morning Meditation',
          description: 'Start your day with 10 minutes of mindfulness',
          category: 'Mental Health',
          difficulty: 'Easy',
          reason: 'Your morning routine could benefit from a mindful start',
          priority: 6,
          estimatedDuration: 10,
          suggestedTime: '06:30',
        ));
      }

      // Evening recommendations if evening is underutilized
      final eveningHabits = timeSlots['Evening'] ?? 0;
      if (eveningHabits < totalHabits * 0.2) {
        recommendations.add(HabitRecommendation(
          title: 'Evening Reflection',
          description: 'Reflect on your day and plan tomorrow',
          category: 'Personal Development',
          difficulty: 'Easy',
          reason: 'Evening reflection can improve planning and gratitude',
          priority: 5,
          estimatedDuration: 15,
          suggestedTime: '20:00',
        ));
      }
    }

    return recommendations;
  }

  /// Get category-based recommendations
  static List<HabitRecommendation> _getCategoryBasedRecommendations(
    Map<String, dynamic> habitAnalysis,
  ) {
    final recommendations = <HabitRecommendation>[];
    final categories = habitAnalysis['categories'] as Map<String, int>;

    // Suggest missing important categories
    if (!categories.containsKey('Health') || categories['Health']! < 1) {
      final healthRecommendations = [
        HabitRecommendation(
          title: 'Drink Water',
          description: 'Drink 8 glasses of water daily',
          category: 'Health',
          difficulty: 'Easy',
          reason: 'Hydration is essential for health and energy',
          priority: 8,
          estimatedDuration: 2,
          suggestedTime: '08:00',
        ),
        HabitRecommendation(
          title: 'Take Vitamins',
          description: 'Take daily multivitamin supplement',
          category: 'Health',
          difficulty: 'Very Easy',
          reason: 'Support overall health and fill nutritional gaps',
          priority: 7,
          estimatedDuration: 1,
          suggestedTime: '08:30',
        ),
        HabitRecommendation(
          title: 'Deep Breathing',
          description: '5 minutes of deep breathing exercises',
          category: 'Health',
          difficulty: 'Easy',
          reason: 'Reduce stress and improve oxygen flow',
          priority: 6,
          estimatedDuration: 5,
          suggestedTime: '14:00',
        ),
      ];
      // Add a random health recommendation to provide variety
      final randomIndex = DateTime.now().millisecondsSinceEpoch % healthRecommendations.length;
      recommendations.add(healthRecommendations[randomIndex]);
    }

    if (!categories.containsKey('Learning') || categories['Learning']! < 1) {
      final learningRecommendations = [
        HabitRecommendation(
          title: 'Daily Reading',
          description: 'Read for 20 minutes to expand knowledge',
          category: 'Learning',
          difficulty: 'Easy',
          reason: 'Continuous learning improves cognitive function',
          priority: 6,
          estimatedDuration: 20,
          suggestedTime: '19:00',
        ),
        HabitRecommendation(
          title: 'Learn New Words',
          description: 'Learn 5 new vocabulary words daily',
          category: 'Learning',
          difficulty: 'Easy',
          reason: 'Expand vocabulary and communication skills',
          priority: 5,
          estimatedDuration: 10,
          suggestedTime: '09:00',
        ),
        HabitRecommendation(
          title: 'Practice a Skill',
          description: 'Spend 15 minutes practicing a new skill',
          category: 'Learning',
          difficulty: 'Medium',
          reason: 'Develop new abilities and stay mentally sharp',
          priority: 6,
          estimatedDuration: 15,
          suggestedTime: '20:00',
        ),
      ];
      final randomIndex = DateTime.now().millisecondsSinceEpoch % learningRecommendations.length;
      recommendations.add(learningRecommendations[randomIndex]);
    }

    if (!categories.containsKey('Social') || categories['Social']! < 1) {
      final socialRecommendations = [
        HabitRecommendation(
          title: 'Connect with Friends',
          description: 'Reach out to a friend or family member',
          category: 'Social',
          difficulty: 'Easy',
          reason: 'Social connections are vital for mental health',
          priority: 5,
          estimatedDuration: 15,
          suggestedTime: '17:00',
        ),
        HabitRecommendation(
          title: 'Express Gratitude',
          description: 'Thank someone or give a compliment',
          category: 'Social',
          difficulty: 'Easy',
          reason: 'Strengthen relationships and spread positivity',
          priority: 4,
          estimatedDuration: 5,
          suggestedTime: '12:00',
        ),
        HabitRecommendation(
          title: 'Help Someone',
          description: 'Do a small act of kindness for someone',
          category: 'Social',
          difficulty: 'Medium',
          reason: 'Build community and feel more connected',
          priority: 5,
          estimatedDuration: 10,
          suggestedTime: '16:00',
        ),
      ];
      final randomIndex = DateTime.now().millisecondsSinceEpoch % socialRecommendations.length;
      recommendations.add(socialRecommendations[randomIndex]);
    }

    return recommendations;
  }

  /// Get difficulty progression recommendations
  static List<HabitRecommendation> _getDifficultyProgressionRecommendations(
    Map<String, dynamic> habitAnalysis,
  ) {
    final recommendations = <HabitRecommendation>[];
    final averageStreaks = habitAnalysis['averageStreaks'] as num;
    final completionRates = habitAnalysis['completionRates'] as List<double>;

    if (completionRates.isNotEmpty) {
      final avgCompletionRate = completionRates.reduce((a, b) => a + b) / completionRates.length;

      // If user is doing well, suggest more challenging habits
      if (avgCompletionRate > 0.8 && averageStreaks > 14) {
        recommendations.add(HabitRecommendation(
          title: 'Challenge Workout',
          description: 'Try a more intensive 45-minute workout',
          category: 'Fitness',
          difficulty: 'Hard',
          reason: 'You\'re ready for more challenging habits!',
          priority: 7,
          estimatedDuration: 45,
          suggestedTime: '06:00',
        ));
      }

      // If user is struggling, suggest easier habits
      else if (avgCompletionRate < 0.5 || averageStreaks < 7) {
        recommendations.add(HabitRecommendation(
          title: 'One Push-up',
          description: 'Start small with just one push-up daily',
          category: 'Fitness',
          difficulty: 'Very Easy',
          reason: 'Starting small builds consistency',
          priority: 9,
          estimatedDuration: 1,
          suggestedTime: '07:00',
        ));
      }
    }

    return recommendations;
  }

  /// Get habit suggestions based on current time and context
  static List<HabitRecommendation> getContextualSuggestions({
    required DateTime currentTime,
    required List<Map<String, dynamic>> existingHabits,
    Map<String, dynamic>? recentActivity,
  }) {
    final suggestions = <HabitRecommendation>[];
    final hour = currentTime.hour;

    // Morning suggestions (6-10 AM)
    if (hour >= 6 && hour < 10) {
      final morningOptions = [
        HabitRecommendation(
          title: 'Morning Stretch',
          description: 'Wake up your body with gentle stretches',
          category: 'Health',
          difficulty: 'Easy',
          reason: 'Perfect time to energize your body',
          priority: 8,
          estimatedDuration: 10,
          suggestedTime: currentTime.add(const Duration(minutes: 5)).toString().substring(11, 16),
        ),
        HabitRecommendation(
          title: 'Morning Meditation',
          description: 'Start your day with 5 minutes of mindfulness',
          category: 'Mental Health',
          difficulty: 'Easy',
          reason: 'Set a calm, focused tone for the day',
          priority: 7,
          estimatedDuration: 5,
          suggestedTime: currentTime.add(const Duration(minutes: 5)).toString().substring(11, 16),
        ),
        HabitRecommendation(
          title: 'Drink Water',
          description: 'Hydrate after a night of sleep',
          category: 'Health',
          difficulty: 'Very Easy',
          reason: 'Rehydrate your body after sleep',
          priority: 6,
          estimatedDuration: 1,
          suggestedTime: currentTime.add(const Duration(minutes: 2)).toString().substring(11, 16),
        ),
      ];
      final randomIndex = DateTime.now().millisecondsSinceEpoch % morningOptions.length;
      suggestions.add(morningOptions[randomIndex]);
    }

    // Lunch break suggestions (11 AM - 2 PM)
    else if (hour >= 11 && hour < 14) {
      final lunchOptions = [
        HabitRecommendation(
          title: 'Midday Walk',
          description: 'Take a refreshing walk during lunch break',
          category: 'Fitness',
          difficulty: 'Easy',
          reason: 'Break up your day with movement',
          priority: 7,
          estimatedDuration: 15,
          suggestedTime: currentTime.add(const Duration(minutes: 10)).toString().substring(11, 16),
        ),
        HabitRecommendation(
          title: 'Mindful Eating',
          description: 'Eat lunch without distractions',
          category: 'Mental Health',
          difficulty: 'Medium',
          reason: 'Improve digestion and mindfulness',
          priority: 6,
          estimatedDuration: 20,
          suggestedTime: currentTime.add(const Duration(minutes: 5)).toString().substring(11, 16),
        ),
        HabitRecommendation(
          title: 'Desk Stretches',
          description: 'Do simple stretches at your desk',
          category: 'Health',
          difficulty: 'Easy',
          reason: 'Combat sitting posture and tension',
          priority: 5,
          estimatedDuration: 5,
          suggestedTime: currentTime.add(const Duration(minutes: 2)).toString().substring(11, 16),
        ),
      ];
      final randomIndex = DateTime.now().millisecondsSinceEpoch % lunchOptions.length;
      suggestions.add(lunchOptions[randomIndex]);
    }

    // Evening suggestions (6-9 PM)
    else if (hour >= 18 && hour < 21) {
      final eveningOptions = [
        HabitRecommendation(
          title: 'Gratitude Journal',
          description: 'Write down 3 things you\'re grateful for',
          category: 'Mental Health',
          difficulty: 'Easy',
          reason: 'End your day on a positive note',
          priority: 6,
          estimatedDuration: 5,
          suggestedTime: currentTime.add(const Duration(minutes: 30)).toString().substring(11, 16),
        ),
        HabitRecommendation(
          title: 'Evening Walk',
          description: 'Take a relaxing walk to unwind',
          category: 'Fitness',
          difficulty: 'Easy',
          reason: 'Decompress and get fresh air',
          priority: 5,
          estimatedDuration: 20,
          suggestedTime: currentTime.add(const Duration(minutes: 15)).toString().substring(11, 16),
        ),
        HabitRecommendation(
          title: 'Plan Tomorrow',
          description: 'Review and plan your next day',
          category: 'Personal Development',
          difficulty: 'Easy',
          reason: 'Start tomorrow with clarity and purpose',
          priority: 4,
          estimatedDuration: 10,
          suggestedTime: currentTime.add(const Duration(minutes: 45)).toString().substring(11, 16),
        ),
      ];
      final randomIndex = DateTime.now().millisecondsSinceEpoch % eveningOptions.length;
      suggestions.add(eveningOptions[randomIndex]);
    }

    // Filter out suggestions that match existing habits
    final existingHabitTitles = existingHabits
        .map((h) => h['name']?.toString().toLowerCase() ?? '')
        .where((name) => name.isNotEmpty)
        .toSet();
    
    final filteredSuggestions = suggestions
        .where((suggestion) => !existingHabitTitles.contains(suggestion.title.toLowerCase()))
        .toList();
    
    return filteredSuggestions;
  }

  /// Generate habit insights and optimization suggestions
  static Future<Map<String, dynamic>> generateHabitInsights(
    List<Map<String, dynamic>> habits,
  ) async {
    final insights = <String, dynamic>{
      'totalHabits': habits.length,
      'insights': <String>[],
      'optimizations': <String>[],
      'achievements': <String>[],
    };

    // Analyze habit patterns
    final categories = <String, int>{};
    double totalCompletionRate = 0;
    int totalStreaks = 0;

    for (final habit in habits) {
      final category = habit['category']?.toString() ?? 'Other';
      categories[category] = (categories[category] ?? 0) + 1;

      final completionRate = habit['completionRate'] ?? 0.0;
      totalCompletionRate += completionRate as double;

      final streak = habit['currentStreak'] ?? 0;
      totalStreaks += streak as int;
    }

    if (habits.isNotEmpty) {
      final avgCompletionRate = totalCompletionRate / habits.length;
      final avgStreak = totalStreaks / habits.length;

      // Generate insights
      (insights['insights'] as List<String>).add(
        'Your average completion rate is ${(avgCompletionRate * 100).toStringAsFixed(1)}%'
      );

      (insights['insights'] as List<String>).add(
        'Your average streak is ${avgStreak.toStringAsFixed(1)} days'
      );

      // Most popular category
      if (categories.isNotEmpty) {
        final topCategory = categories.entries.reduce((a, b) => a.value > b.value ? a : b);
        (insights['insights'] as List<String>).add(
          'Your most focused area is ${topCategory.key} with ${topCategory.value} habits'
        );
      }

      // Generate optimizations
      if (avgCompletionRate < 0.7) {
        (insights['optimizations'] as List<String>).add(
          'Consider reducing habit difficulty or frequency to improve consistency'
        );
      }

      if (habits.length > 5) {
        (insights['optimizations'] as List<String>).add(
          'You might be overwhelming yourself. Consider focusing on fewer habits'
        );
      }

      // Generate achievements
      if (avgCompletionRate > 0.8) {
        (insights['achievements'] as List<String>).add('High Achiever: 80%+ completion rate!');
      }

      if (avgStreak > 21) {
        (insights['achievements'] as List<String>).add('Streak Master: 21+ day average streak!');
      }
    }

    AppLogger.info('Generated habit insights for ${habits.length} habits');
    return insights;
  }
}

class HabitRecommendation {
  final String title;
  final String description;
  final String category;
  final String difficulty;
  final String reason;
  final int priority;
  final int estimatedDuration; // in minutes
  final String suggestedTime;

  HabitRecommendation({
    required this.title,
    required this.description,
    required this.category,
    required this.difficulty,
    required this.reason,
    required this.priority,
    required this.estimatedDuration,
    required this.suggestedTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'difficulty': difficulty,
      'reason': reason,
      'priority': priority,
      'estimatedDuration': estimatedDuration,
      'suggestedTime': suggestedTime,
    };
  }
}
