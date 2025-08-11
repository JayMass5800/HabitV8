import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'logging_service.dart';

class AchievementsService {
  static const String _achievementsKey = 'user_achievements';
  static const String _xpKey = 'user_xp';

  /// Get all available achievements
  static List<Achievement> getAllAchievements() {
    return [
      // Streak Achievements
      Achievement(
        id: 'first_streak',
        title: 'Getting Started',
        description: 'Complete your first habit',
        icon: '🎯',
        category: AchievementCategory.streak,
        requirement: 1,
        xpReward: 10,
        type: AchievementType.streak,
      ),
      Achievement(
        id: 'week_streak',
        title: 'Week Warrior',
        description: 'Maintain a 7-day streak',
        icon: '🔥',
        category: AchievementCategory.streak,
        requirement: 7,
        xpReward: 50,
        type: AchievementType.streak,
      ),
      Achievement(
        id: 'month_streak',
        title: 'Monthly Master',
        description: 'Maintain a 30-day streak',
        icon: '💪',
        category: AchievementCategory.streak,
        requirement: 30,
        xpReward: 200,
        type: AchievementType.streak,
      ),
      Achievement(
        id: 'hundred_streak',
        title: 'Century Club',
        description: 'Achieve a 100-day streak',
        icon: '👑',
        category: AchievementCategory.streak,
        requirement: 100,
        xpReward: 500,
        type: AchievementType.streak,
      ),

      // Consistency Achievements
      Achievement(
        id: 'perfect_week',
        title: 'Perfect Week',
        description: 'Complete all habits for 7 consecutive days',
        icon: '⭐',
        category: AchievementCategory.consistency,
        requirement: 7,
        xpReward: 75,
        type: AchievementType.perfectDays,
      ),
      Achievement(
        id: 'perfect_month',
        title: 'Flawless Month',
        description: 'Complete all habits for 30 consecutive days',
        icon: '🌟',
        category: AchievementCategory.consistency,
        requirement: 30,
        xpReward: 300,
        type: AchievementType.perfectDays,
      ),

      // Habit Count Achievements
      Achievement(
        id: 'habit_collector',
        title: 'Habit Collector',
        description: 'Create 5 different habits',
        icon: '📚',
        category: AchievementCategory.variety,
        requirement: 5,
        xpReward: 40,
        type: AchievementType.habitCount,
      ),
      Achievement(
        id: 'habit_master',
        title: 'Habit Master',
        description: 'Create 10 different habits',
        icon: '🎓',
        category: AchievementCategory.variety,
        requirement: 10,
        xpReward: 100,
        type: AchievementType.habitCount,
      ),

      // Total Completions Achievements
      Achievement(
        id: 'hundred_completions',
        title: 'Centurion',
        description: 'Complete 100 habits total',
        icon: '🏆',
        category: AchievementCategory.dedication,
        requirement: 100,
        xpReward: 150,
        type: AchievementType.totalCompletions,
      ),
      Achievement(
        id: 'thousand_completions',
        title: 'Dedication Legend',
        description: 'Complete 1000 habits total',
        icon: '💎',
        category: AchievementCategory.dedication,
        requirement: 1000,
        xpReward: 750,
        type: AchievementType.totalCompletions,
      ),

      // Category Specific Achievements
      Achievement(
        id: 'health_hero',
        title: 'Health Hero',
        description: 'Complete 50 health-related habits',
        icon: '❤️',
        category: AchievementCategory.health,
        requirement: 50,
        xpReward: 100,
        type: AchievementType.categorySpecific,
        categoryFilter: 'Health',
      ),
      Achievement(
        id: 'fitness_fanatic',
        title: 'Fitness Fanatic',
        description: 'Complete 50 fitness habits',
        icon: '💪',
        category: AchievementCategory.health,
        requirement: 50,
        xpReward: 100,
        type: AchievementType.categorySpecific,
        categoryFilter: 'Fitness',
      ),
      Achievement(
        id: 'mindful_master',
        title: 'Mindful Master',
        description: 'Complete 50 mental health habits',
        icon: '🧘',
        category: AchievementCategory.mentalHealth,
        requirement: 50,
        xpReward: 100,
        type: AchievementType.categorySpecific,
        categoryFilter: 'Mental Health',
      ),

      // Special Achievements
      Achievement(
        id: 'early_bird',
        title: 'Early Bird',
        description: 'Complete 20 habits before 8 AM',
        icon: '🌅',
        category: AchievementCategory.special,
        requirement: 20,
        xpReward: 75,
        type: AchievementType.timeSpecific,
        timeFilter: 8,
      ),
      Achievement(
        id: 'night_owl',
        title: 'Night Owl',
        description: 'Complete 20 habits after 10 PM',
        icon: '🦉',
        category: AchievementCategory.special,
        requirement: 20,
        xpReward: 75,
        type: AchievementType.timeSpecific,
        timeFilter: 22,
      ),
      Achievement(
        id: 'comeback_kid',
        title: 'Comeback Kid',
        description: 'Restart a habit after missing it for 7+ days',
        icon: '🔄',
        category: AchievementCategory.special,
        requirement: 1,
        xpReward: 50,
        type: AchievementType.comeback,
      ),
    ];
  }

  /// Check for new achievements based on habit data
  static Future<List<Achievement>> checkForNewAchievements({
    required List<Map<String, dynamic>> habits,
    required List<Map<String, dynamic>> completions,
  }) async {
    final newAchievements = <Achievement>[];
    final currentAchievements = await getUnlockedAchievements();
    final currentAchievementIds = currentAchievements.map((a) => a.id).toSet();

    for (final achievement in getAllAchievements()) {
      if (currentAchievementIds.contains(achievement.id)) continue;

      bool earned = false;

      switch (achievement.type) {
        case AchievementType.streak:
          final maxStreak = _getMaxStreak(habits);
          earned = maxStreak >= achievement.requirement;
          break;

        case AchievementType.perfectDays:
          final perfectDays = _getPerfectDaysStreak(habits, completions);
          earned = perfectDays >= achievement.requirement;
          break;

        case AchievementType.habitCount:
          earned = habits.length >= achievement.requirement;
          break;

        case AchievementType.totalCompletions:
          earned = completions.length >= achievement.requirement;
          break;

        case AchievementType.categorySpecific:
          final categoryCompletions = _getCategoryCompletions(
            habits, completions, achievement.categoryFilter!);
          earned = categoryCompletions >= achievement.requirement;
          break;

        case AchievementType.timeSpecific:
          final timeCompletions = _getTimeSpecificCompletions(
            completions, achievement.timeFilter!);
          earned = timeCompletions >= achievement.requirement;
          break;

        case AchievementType.comeback:
          earned = _hasComeback(habits, completions);
          break;
      }

      if (earned) {
        newAchievements.add(achievement);
        await _unlockAchievement(achievement);
      }
    }

    return newAchievements;
  }

  /// Get user's current level based on XP
  static Future<int> getCurrentLevel() async {
    final prefs = await SharedPreferences.getInstance();
    final xp = prefs.getInt(_xpKey) ?? 0;
    return _calculateLevel(xp);
  }

  /// Get user's current XP
  static Future<int> getCurrentXP() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_xpKey) ?? 0;
  }

  /// Get XP needed for next level
  static Future<int> getXPForNextLevel() async {
    final currentLevel = await getCurrentLevel();
    return _getXPRequiredForLevel(currentLevel + 1);
  }

  /// Get XP progress for current level (0.0 to 1.0)
  static Future<double> getLevelProgress() async {
    final currentXP = await getCurrentXP();
    final currentLevel = await getCurrentLevel();
    final currentLevelXP = _getXPRequiredForLevel(currentLevel);
    final nextLevelXP = _getXPRequiredForLevel(currentLevel + 1);

    final progressXP = currentXP - currentLevelXP;
    final totalXPForLevel = nextLevelXP - currentLevelXP;

    return progressXP / totalXPForLevel;
  }

  /// Award XP for completing a habit
  static Future<bool> awardXP(int xp, {String? reason}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentXP = prefs.getInt(_xpKey) ?? 0;
      final oldLevel = _calculateLevel(currentXP);

      final newXP = currentXP + xp;
      await prefs.setInt(_xpKey, newXP);

      final newLevel = _calculateLevel(newXP);

      AppLogger.info('Awarded $xp XP${reason != null ? ' for $reason' : ''}. Total: $newXP');

      // Check for level up
      if (newLevel > oldLevel) {
        await _handleLevelUp(oldLevel, newLevel);
        return true; // Level up occurred
      }

      return false; // No level up
    } catch (e) {
      AppLogger.error('Error awarding XP', e);
      return false;
    }
  }

  /// Get all unlocked achievements
  static Future<List<Achievement>> getUnlockedAchievements() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final achievementIds = prefs.getStringList(_achievementsKey) ?? [];

      final allAchievements = getAllAchievements();
      return allAchievements.where((a) => achievementIds.contains(a.id)).toList();
    } catch (e) {
      AppLogger.error('Error getting unlocked achievements', e);
      return [];
    }
  }

  /// Get achievement progress for all achievements
  static Future<Map<String, double>> getAchievementProgress({
    required List<Map<String, dynamic>> habits,
    required List<Map<String, dynamic>> completions,
  }) async {
    final progress = <String, double>{};

    for (final achievement in getAllAchievements()) {
      double currentProgress = 0;

      switch (achievement.type) {
        case AchievementType.streak:
          currentProgress = _getMaxStreak(habits).toDouble();
          break;
        case AchievementType.perfectDays:
          currentProgress = _getPerfectDaysStreak(habits, completions).toDouble();
          break;
        case AchievementType.habitCount:
          currentProgress = habits.length.toDouble();
          break;
        case AchievementType.totalCompletions:
          currentProgress = completions.length.toDouble();
          break;
        case AchievementType.categorySpecific:
          currentProgress = _getCategoryCompletions(
            habits, completions, achievement.categoryFilter!).toDouble();
          break;
        case AchievementType.timeSpecific:
          currentProgress = _getTimeSpecificCompletions(
            completions, achievement.timeFilter!).toDouble();
          break;
        case AchievementType.comeback:
          currentProgress = _hasComeback(habits, completions) ? 1.0 : 0.0;
          break;
      }

      progress[achievement.id] = (currentProgress / achievement.requirement).clamp(0.0, 1.0);
    }

    return progress;
  }

  /// Generate gamification stats
  static Future<Map<String, dynamic>> getGamificationStats({
    required List<Map<String, dynamic>> habits,
    required List<Map<String, dynamic>> completions,
  }) async {
    final unlockedAchievements = await getUnlockedAchievements();
    final currentLevel = await getCurrentLevel();
    final currentXP = await getCurrentXP();
    final nextLevelXP = await getXPForNextLevel();
    final levelProgress = await getLevelProgress();

    return {
      'level': currentLevel,
      'xp': currentXP,
      'nextLevelXP': nextLevelXP,
      'levelProgress': levelProgress,
      'achievementsUnlocked': unlockedAchievements.length,
      'totalAchievements': getAllAchievements().length,
      'completionRate': _calculateOverallCompletionRate(habits, completions),
      'totalStreak': _getTotalStreak(habits),
      'maxStreak': _getMaxStreak(habits),
      'perfectDays': _getPerfectDaysStreak(habits, completions),
      'rank': _calculateRank(currentLevel, unlockedAchievements.length),
    };
  }

  // Private helper methods

  static Future<void> _unlockAchievement(Achievement achievement) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentAchievements = prefs.getStringList(_achievementsKey) ?? [];

      if (!currentAchievements.contains(achievement.id)) {
        currentAchievements.add(achievement.id);
        await prefs.setStringList(_achievementsKey, currentAchievements);

        // Award XP for the achievement
        await awardXP(achievement.xpReward, reason: achievement.title);

        AppLogger.info('Achievement unlocked: ${achievement.title}');
      }
    } catch (e) {
      AppLogger.error('Error unlocking achievement', e);
    }
  }

  static int _calculateLevel(int xp) {
    // Level formula: level = floor(sqrt(xp / 100))
    return (sqrt(xp / 100)).floor() + 1;
  }

  static int _getXPRequiredForLevel(int level) {
    // XP formula: xp = (level - 1)^2 * 100
    return pow(level - 1, 2).toInt() * 100;
  }

  static Future<void> _handleLevelUp(int oldLevel, int newLevel) async {
    AppLogger.info('Level up! $oldLevel -> $newLevel');
    // Additional level up rewards could be implemented here
  }

  static int _getMaxStreak(List<Map<String, dynamic>> habits) {
    return habits.fold<int>(0, (max, habit) {
      final streak = habit['currentStreak'] ?? 0;
      return streak > max ? streak as int : max;
    });
  }

  static int _getTotalStreak(List<Map<String, dynamic>> habits) {
    return habits.fold<int>(0, (total, habit) {
      final streak = habit['currentStreak'] ?? 0;
      return total + (streak as int);
    });
  }

  static int _getPerfectDaysStreak(
    List<Map<String, dynamic>> habits,
    List<Map<String, dynamic>> completions,
  ) {
    // This would need more complex logic to calculate perfect days
    // For now, return a simple calculation
    if (habits.isEmpty) return 0;

    final avgCompletionRate = habits.fold<double>(0.0, (sum, habit) {
      return sum + (habit['completionRate'] ?? 0.0);
    }) / habits.length;

    return (avgCompletionRate * 30).round(); // Approximate perfect days
  }

  static int _getCategoryCompletions(
    List<Map<String, dynamic>> habits,
    List<Map<String, dynamic>> completions,
    String category,
  ) {
    final categoryHabitIds = habits
        .where((habit) => habit['category'] == category)
        .map((habit) => habit['id'])
        .toSet();

    return completions
        .where((completion) => categoryHabitIds.contains(completion['habitId']))
        .length;
  }

  static int _getTimeSpecificCompletions(
    List<Map<String, dynamic>> completions,
    int targetHour,
  ) {
    return completions.where((completion) {
      final completedAt = completion['completedAt'];
      if (completedAt is DateTime) {
        if (targetHour < 12) {
          return completedAt.hour < targetHour; // Before target hour
        } else {
          return completedAt.hour >= targetHour; // After target hour
        }
      }
      return false;
    }).length;
  }

  static bool _hasComeback(
    List<Map<String, dynamic>> habits,
    List<Map<String, dynamic>> completions,
  ) {
    // This would need more complex logic to detect comebacks
    // For now, return false as a placeholder
    return habits.any((habit) => (habit['currentStreak'] ?? 0) > 0);
  }

  static double _calculateOverallCompletionRate(
    List<Map<String, dynamic>> habits,
    List<Map<String, dynamic>> completions,
  ) {
    if (habits.isEmpty) return 0.0;

    return habits.fold<double>(0.0, (sum, habit) {
      return sum + (habit['completionRate'] ?? 0.0);
    }) / habits.length;
  }

  static String _calculateRank(int level, int achievementsCount) {
    if (level >= 20 && achievementsCount >= 10) return 'Grandmaster';
    if (level >= 15 && achievementsCount >= 8) return 'Master';
    if (level >= 10 && achievementsCount >= 6) return 'Expert';
    if (level >= 7 && achievementsCount >= 4) return 'Advanced';
    if (level >= 5 && achievementsCount >= 2) return 'Intermediate';
    if (level >= 3) return 'Beginner';
    return 'Novice';
  }
}

enum AchievementCategory {
  streak,
  consistency,
  variety,
  dedication,
  health,
  mentalHealth,
  special,
}

enum AchievementType {
  streak,
  perfectDays,
  habitCount,
  totalCompletions,
  categorySpecific,
  timeSpecific,
  comeback,
}

class Achievement {
  final String id;
  final String title;
  final String description;
  final String icon;
  final AchievementCategory category;
  final int requirement;
  final int xpReward;
  final AchievementType type;
  final String? categoryFilter;
  final int? timeFilter;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.category,
    required this.requirement,
    required this.xpReward,
    required this.type,
    this.categoryFilter,
    this.timeFilter,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'icon': icon,
      'category': category.toString(),
      'requirement': requirement,
      'xpReward': xpReward,
      'type': type.toString(),
      'categoryFilter': categoryFilter,
      'timeFilter': timeFilter,
    };
  }
}
