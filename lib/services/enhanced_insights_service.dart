import 'package:logger/logger.dart';
import '../domain/model/habit.dart';
import 'insights_service.dart';
import 'ai_service.dart';

/// Enhanced insights service that combines rule-based and AI-powered insights
class EnhancedInsightsService {
  static final EnhancedInsightsService _instance = EnhancedInsightsService._internal();
  factory EnhancedInsightsService() => _instance;
  EnhancedInsightsService._internal();

  final Logger _logger = Logger();
  final InsightsService _insightsService = InsightsService();
  final AIService _aiService = AIService();

  /// Generate comprehensive insights combining rule-based and AI analysis
  Future<List<Map<String, dynamic>>> generateComprehensiveInsights(
    List<Habit> habits, {
    bool useAI = true,
    String? preferredAIProvider,
  }) async {
    final insights = <Map<String, dynamic>>[];

    // Always get rule-based insights as a baseline
    final ruleBasedInsights = _insightsService.generateAIInsights(habits);
    insights.addAll(ruleBasedInsights);

    // Add AI insights if enabled and configured
    if (useAI && _aiService.isConfigured) {
      try {
        List<Map<String, dynamic>> aiInsights;
        
        if (preferredAIProvider?.toLowerCase() == 'gemini') {
          aiInsights = await _aiService.generateGeminiInsights(habits);
        } else {
          aiInsights = await _aiService.generateOpenAIInsights(habits);
        }

        // Merge AI insights with rule-based ones, avoiding duplicates
        for (final aiInsight in aiInsights) {
          // Simple deduplication based on title similarity
          final isDuplicate = insights.any((existing) =>
              _calculateSimilarity(existing['title'], aiInsight['title']) > 0.7);
          
          if (!isDuplicate) {
            insights.add(aiInsight);
          }
        }
      } catch (e) {
        // Fallback to rule-based insights if AI fails
        _logger.w('AI insights failed, using rule-based fallback: $e');
      }
    }

    // Limit to top 4 insights and prioritize by type
    final prioritizedInsights = _prioritizeInsights(insights);
    return prioritizedInsights.take(4).toList();
  }

  /// Get only rule-based insights (for users without AI configured)
  List<Map<String, dynamic>> getRuleBasedInsights(List<Habit> habits) {
    return _insightsService.generateAIInsights(habits);
  }

  /// Check if AI insights are available
  bool get isAIAvailable => _aiService.isConfigured;

  /// Get available AI providers
  List<String> get availableAIProviders => _aiService.availableProviders;

  /// Generate personalized recommendations based on habit data
  Future<List<Map<String, dynamic>>> generatePersonalizedRecommendations(
    List<Habit> habits,
  ) async {
    final recommendations = <Map<String, dynamic>>[];

    // Rule-based recommendations
    _addRuleBasedRecommendations(habits, recommendations);

    // AI-powered recommendations if available
    if (_aiService.isConfigured) {
      try {
        final aiRecommendations = await _generateAIRecommendations(habits);
        recommendations.addAll(aiRecommendations);
      } catch (e) {
        _logger.w('AI recommendations failed: $e');
      }
    }

    return recommendations.take(3).toList();
  }

  /// Calculate similarity between two strings (simple implementation)
  double _calculateSimilarity(String a, String b) {
    if (a == b) return 1.0;
    
    final aWords = a.toLowerCase().split(' ').toSet();
    final bWords = b.toLowerCase().split(' ').toSet();
    final intersection = aWords.intersection(bWords).length;
    final union = aWords.union(bWords).length;
    
    return union > 0 ? intersection / union : 0.0;
  }

  /// Prioritize insights by type and relevance
  List<Map<String, dynamic>> _prioritizeInsights(List<Map<String, dynamic>> insights) {
    final priorityOrder = {
      'achievement': 5,
      'motivational': 4,
      'pattern': 3,
      'insight': 2,
      'strength': 1,
    };

    insights.sort((a, b) {
      final aPriority = priorityOrder[a['type']] ?? 0;
      final bPriority = priorityOrder[b['type']] ?? 0;
      return bPriority.compareTo(aPriority);
    });

    return insights;
  }

  /// Add rule-based recommendations
  void _addRuleBasedRecommendations(
    List<Habit> habits,
    List<Map<String, dynamic>> recommendations,
  ) {
    if (habits.isEmpty) {
      recommendations.add({
        'type': 'setup',
        'title': 'Start Your Journey',
        'description': 'Create your first habit to begin tracking your progress.',
        'action': 'create_habit',
        'icon': 'add_circle',
      });
      return;
    }

    final activeHabits = habits.where((h) => h.isActive).toList();
    final avgCompletionRate = activeHabits.isNotEmpty
        ? activeHabits.map((h) => h.completionRate).reduce((a, b) => a + b) / activeHabits.length
        : 0.0;

    // Recommend habit stacking for low performers
    if (avgCompletionRate < 0.6) {
      recommendations.add({
        'type': 'strategy',
        'title': 'Try Habit Stacking',
        'description': 'Link new habits to existing routines to improve consistency.',
        'action': 'learn_stacking',
        'icon': 'link',
      });
    }

    // Recommend celebrating wins for high performers
    if (avgCompletionRate > 0.8) {
      recommendations.add({
        'type': 'celebration',
        'title': 'Celebrate Your Success',
        'description': 'Acknowledge your achievements and set new challenges.',
        'action': 'view_achievements',
        'icon': 'celebration',
      });
    }

    // Recommend habit reminders for inconsistent habits
    final inconsistentHabits = activeHabits.where((h) => h.consistencyScore < 60).toList();
    if (inconsistentHabits.isNotEmpty) {
      recommendations.add({
        'type': 'improvement',
        'title': 'Set Better Reminders',
        'description': 'Improve consistency with strategic habit reminders.',
        'action': 'setup_reminders',
        'icon': 'notifications',
      });
    }
  }

  /// Generate AI-powered recommendations
  Future<List<Map<String, dynamic>>> _generateAIRecommendations(List<Habit> habits) async {
    // This would call the AI service with a specific prompt for recommendations
    // For now, return empty list as this would need specific AI training
    return [];
  }

  /// Get habit analytics for AI processing
  Map<String, dynamic> getHabitAnalytics(List<Habit> habits) {
    if (habits.isEmpty) return {};

    final activeHabits = habits.where((h) => h.isActive).toList();
    final totalCompletions = activeHabits.fold<int>(0, (sum, h) => sum + h.completions.length);
    
    final categories = <String, List<Habit>>{};
    for (final habit in activeHabits) {
      categories.putIfAbsent(habit.category, () => []).add(habit);
    }

    final categoryPerformance = <String, double>{};
    for (final entry in categories.entries) {
      final avgRate = entry.value.map((h) => h.completionRate).reduce((a, b) => a + b) / entry.value.length;
      categoryPerformance[entry.key] = avgRate;
    }

    return {
      'totalHabits': activeHabits.length,
      'totalCompletions': totalCompletions,
      'categories': categories.keys.toList(),
      'categoryPerformance': categoryPerformance,
      'averageCompletionRate': activeHabits.isNotEmpty
          ? activeHabits.map((h) => h.completionRate).reduce((a, b) => a + b) / activeHabits.length
          : 0.0,
      'bestStreak': activeHabits.isNotEmpty
          ? activeHabits.map((h) => h.streakInfo.longest).reduce((a, b) => a > b ? a : b)
          : 0,
      'currentStreaks': activeHabits.map((h) => h.streakInfo.current).toList(),
    };
  }
}
