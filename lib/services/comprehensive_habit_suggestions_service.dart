import '../domain/model/habit.dart';
import '../services/health_enhanced_habit_creation_service.dart';
import '../services/health_service.dart';
import '../services/logging_service.dart';

/// Comprehensive Habit Suggestions Service
///
/// This service provides habit suggestions for all categories, not just health-related ones.
/// It includes health-based suggestions when health data is activated.
class ComprehensiveHabitSuggestionsService {
  /// Generate comprehensive habit suggestions
  static Future<List<HabitSuggestion>> generateSuggestions() async {
    try {
      final suggestions = <HabitSuggestion>[];

      // Add general habit suggestions
      suggestions.addAll(_getGeneralHabitSuggestions());

      // Add health-based suggestions if health data is available
      try {
        final healthSyncEnabled = await HealthService.isHealthSyncEnabled();
        if (healthSyncEnabled && await HealthService.hasPermissions()) {
          final healthSuggestions = await HealthEnhancedHabitCreationService
              .generateHealthBasedSuggestions();
          for (final healthSuggestion in healthSuggestions) {
            suggestions.add(HabitSuggestion(
              name: healthSuggestion.name,
              description: healthSuggestion.description,
              category: healthSuggestion.category,
              frequency: healthSuggestion.frequency,
              icon: _getHealthDataTypeIcon(healthSuggestion.healthDataType),
              type: 'Health',
              priority: 0.9,
              isHealthBased: true,
              healthDataType: healthSuggestion.healthDataType,
              suggestedThreshold: healthSuggestion.suggestedThreshold,
            ));
          }
        }
      } catch (e) {
        AppLogger.warning('Could not load health suggestions: $e');
      }

      // Sort by priority and type
      suggestions.sort((a, b) {
        // Health suggestions first if available
        if (a.isHealthBased && !b.isHealthBased) return -1;
        if (!a.isHealthBased && b.isHealthBased) return 1;

        // Then by priority
        return b.priority.compareTo(a.priority);
      });

      return suggestions;
    } catch (e) {
      AppLogger.error('Error generating comprehensive habit suggestions', e);
      return [];
    }
  }

  /// Get general habit suggestions for all categories
  static List<HabitSuggestion> _getGeneralHabitSuggestions() {
    return [
      // Productivity Habits
      HabitSuggestion(
        name: 'Morning Planning',
        description: 'Plan your day every morning with a to-do list',
        category: 'Productivity',
        frequency: HabitFrequency.daily,
        icon: 'checklist',
        type: 'Productivity',
        priority: 0.8,
      ),
      HabitSuggestion(
        name: 'Email Inbox Zero',
        description: 'Clear your email inbox completely',
        category: 'Productivity',
        frequency: HabitFrequency.daily,
        icon: 'email',
        type: 'Productivity',
        priority: 0.7,
      ),
      HabitSuggestion(
        name: 'Deep Work Session',
        description: 'Spend 2 hours on focused, uninterrupted work',
        category: 'Productivity',
        frequency: HabitFrequency.daily,
        icon: 'psychology',
        type: 'Productivity',
        priority: 0.8,
      ),

      // Learning Habits
      HabitSuggestion(
        name: 'Read for 30 Minutes',
        description: 'Read books, articles, or educational content',
        category: 'Learning',
        frequency: HabitFrequency.daily,
        icon: 'menu_book',
        type: 'Learning',
        priority: 0.8,
      ),
      HabitSuggestion(
        name: 'Learn New Language',
        description: 'Practice a new language for 15 minutes',
        category: 'Learning',
        frequency: HabitFrequency.daily,
        icon: 'translate',
        type: 'Learning',
        priority: 0.7,
      ),
      HabitSuggestion(
        name: 'Online Course Progress',
        description: 'Complete one lesson of an online course',
        category: 'Learning',
        frequency: HabitFrequency.daily,
        icon: 'school',
        type: 'Learning',
        priority: 0.7,
      ),

      // Personal Development Habits
      HabitSuggestion(
        name: 'Daily Gratitude',
        description: 'Write down 3 things you\'re grateful for',
        category: 'Personal',
        frequency: HabitFrequency.daily,
        icon: 'favorite',
        type: 'Personal',
        priority: 0.8,
      ),
      HabitSuggestion(
        name: 'Morning Affirmations',
        description: 'Recite positive affirmations to start your day',
        category: 'Personal',
        frequency: HabitFrequency.daily,
        icon: 'self_improvement',
        type: 'Personal',
        priority: 0.7,
      ),
      HabitSuggestion(
        name: 'Evening Reflection',
        description: 'Reflect on your day and lessons learned',
        category: 'Personal',
        frequency: HabitFrequency.daily,
        icon: 'lightbulb',
        type: 'Personal',
        priority: 0.7,
      ),

      // Social Habits
      HabitSuggestion(
        name: 'Call Family/Friends',
        description: 'Make a phone call to connect with loved ones',
        category: 'Social',
        frequency: HabitFrequency.weekly,
        icon: 'phone',
        type: 'Social',
        priority: 0.7,
      ),
      HabitSuggestion(
        name: 'Send Appreciation Message',
        description: 'Send a message of appreciation to someone',
        category: 'Social',
        frequency: HabitFrequency.weekly,
        icon: 'message',
        type: 'Social',
        priority: 0.6,
      ),
      HabitSuggestion(
        name: 'Network with Colleagues',
        description: 'Have a meaningful conversation with a colleague',
        category: 'Social',
        frequency: HabitFrequency.weekly,
        icon: 'people',
        type: 'Social',
        priority: 0.6,
      ),

      // Finance Habits
      HabitSuggestion(
        name: 'Track Daily Expenses',
        description: 'Record all expenses and categorize them',
        category: 'Finance',
        frequency: HabitFrequency.daily,
        icon: 'account_balance_wallet',
        type: 'Finance',
        priority: 0.8,
      ),
      HabitSuggestion(
        name: 'Review Investment Portfolio',
        description: 'Check and analyze your investment performance',
        category: 'Finance',
        frequency: HabitFrequency.weekly,
        icon: 'trending_up',
        type: 'Finance',
        priority: 0.7,
      ),
      HabitSuggestion(
        name: 'Save Money Daily',
        description: 'Put aside a small amount of money each day',
        category: 'Finance',
        frequency: HabitFrequency.daily,
        icon: 'savings',
        type: 'Finance',
        priority: 0.8,
      ),

      // Lifestyle Habits
      HabitSuggestion(
        name: 'Make Bed',
        description: 'Make your bed every morning',
        category: 'Lifestyle',
        frequency: HabitFrequency.daily,
        icon: 'bed',
        type: 'Lifestyle',
        priority: 0.6,
      ),
      HabitSuggestion(
        name: 'Tidy Living Space',
        description: 'Spend 10 minutes tidying up your living space',
        category: 'Lifestyle',
        frequency: HabitFrequency.daily,
        icon: 'home',
        type: 'Lifestyle',
        priority: 0.6,
      ),
      HabitSuggestion(
        name: 'Meal Prep Sunday',
        description: 'Prepare meals for the upcoming week',
        category: 'Lifestyle',
        frequency: HabitFrequency.weekly,
        icon: 'restaurant',
        type: 'Lifestyle',
        priority: 0.7,
      ),

      // Hobbies Habits
      HabitSuggestion(
        name: 'Creative Time',
        description: 'Spend time on a creative hobby or project',
        category: 'Hobbies',
        frequency: HabitFrequency.daily,
        icon: 'palette',
        type: 'Hobbies',
        priority: 0.6,
      ),
      HabitSuggestion(
        name: 'Practice Musical Instrument',
        description: 'Practice playing a musical instrument',
        category: 'Hobbies',
        frequency: HabitFrequency.daily,
        icon: 'music_note',
        type: 'Hobbies',
        priority: 0.7,
      ),
      HabitSuggestion(
        name: 'Photography Walk',
        description: 'Take photos during a walk or outing',
        category: 'Hobbies',
        frequency: HabitFrequency.weekly,
        icon: 'camera_alt',
        type: 'Hobbies',
        priority: 0.6,
      ),
    ];
  }

  /// Get icon name for health data type
  static String _getHealthDataTypeIcon(String? healthDataType) {
    switch (healthDataType) {
      case 'STEPS':
        return 'directions_walk';
      case 'ACTIVE_ENERGY_BURNED':
        return 'local_fire_department';
      case 'SLEEP_IN_BED':
        return 'bedtime';
      case 'WATER':
        return 'water_drop';
      case 'MINDFULNESS':
        return 'self_improvement';
      case 'WEIGHT':
        return 'monitor_weight';
      case 'MEDICATION':
        return 'medication';
      default:
        return 'health_and_safety';
    }
  }
}

/// Comprehensive habit suggestion model
class HabitSuggestion {
  final String name;
  final String description;
  final String category;
  final HabitFrequency frequency;
  final String icon;
  final String type;
  final double priority;
  final bool isHealthBased;
  final String? healthDataType;
  final double? suggestedThreshold;

  HabitSuggestion({
    required this.name,
    required this.description,
    required this.category,
    required this.frequency,
    required this.icon,
    required this.type,
    required this.priority,
    this.isHealthBased = false,
    this.healthDataType,
    this.suggestedThreshold,
  });
}
