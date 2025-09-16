import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'logging_service.dart';

class AchievementsService {
  static const String _achievementsKey = 'user_achievements';
  static const String _xpKey = 'user_xp';

  /// Get all available achievements
  static List<Achievement> getAllAchievements() {
    return [
      // === STREAK ACHIEVEMENTS (BEGINNER) ===
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
        id: 'three_streak',
        title: 'Momentum Builder',
        description: 'Maintain a 3-day streak',
        icon: '🚀',
        category: AchievementCategory.streak,
        requirement: 3,
        xpReward: 25,
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
        id: 'two_week_streak',
        title: 'Fortnight Fighter',
        description: 'Maintain a 14-day streak',
        icon: '⚡',
        category: AchievementCategory.streak,
        requirement: 14,
        xpReward: 100,
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
        id: 'quarter_streak',
        title: 'Quarterly Champion',
        description: 'Maintain a 90-day streak',
        icon: '🏅',
        category: AchievementCategory.streak,
        requirement: 90,
        xpReward: 400,
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
      Achievement(
        id: 'six_month_streak',
        title: 'Half-Year Hero',
        description: 'Maintain a 180-day streak',
        icon: '🌟',
        category: AchievementCategory.streak,
        requirement: 180,
        xpReward: 800,
        type: AchievementType.streak,
      ),
      Achievement(
        id: 'year_streak',
        title: 'Annual Achiever',
        description: 'Maintain a 365-day streak',
        icon: '💎',
        category: AchievementCategory.streak,
        requirement: 365,
        xpReward: 1500,
        type: AchievementType.streak,
      ),
      Achievement(
        id: 'two_year_streak',
        title: 'Biennial Beast',
        description: 'Maintain a 730-day streak',
        icon: '👑',
        category: AchievementCategory.streak,
        requirement: 730,
        xpReward: 2500,
        type: AchievementType.streak,
      ),
      Achievement(
        id: 'three_year_streak',
        title: 'Triple Threat',
        description: 'Maintain a 1095-day streak',
        icon: '🦄',
        category: AchievementCategory.streak,
        requirement: 1095,
        xpReward: 5000,
        type: AchievementType.streak,
      ),

      // === CONSISTENCY ACHIEVEMENTS ===
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
      Achievement(
        id: 'perfect_quarter',
        title: 'Quarterly Perfection',
        description: 'Complete all habits for 90 consecutive days',
        icon: '💫',
        category: AchievementCategory.consistency,
        requirement: 90,
        xpReward: 750,
        type: AchievementType.perfectDays,
      ),
      Achievement(
        id: 'perfect_half_year',
        title: 'Semi-Annual Supremacy',
        description: 'Complete all habits for 180 consecutive days',
        icon: '✨',
        category: AchievementCategory.consistency,
        requirement: 180,
        xpReward: 1200,
        type: AchievementType.perfectDays,
      ),
      Achievement(
        id: 'perfect_year',
        title: 'Annual Perfection',
        description: 'Complete all habits for 365 consecutive days',
        icon: '🏆',
        category: AchievementCategory.consistency,
        requirement: 365,
        xpReward: 2000,
        type: AchievementType.perfectDays,
      ),

      // === HABIT COUNT ACHIEVEMENTS ===
      Achievement(
        id: 'habit_starter',
        title: 'Habit Starter',
        description: 'Create 3 different habits',
        icon: '🌱',
        category: AchievementCategory.variety,
        requirement: 3,
        xpReward: 25,
        type: AchievementType.habitCount,
      ),
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
        id: 'habit_curator',
        title: 'Habit Curator',
        description: 'Create 7 different habits',
        icon: '🗂️',
        category: AchievementCategory.variety,
        requirement: 7,
        xpReward: 60,
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
      Achievement(
        id: 'habit_architect',
        title: 'Habit Architect',
        description: 'Create 15 different habits',
        icon: '🏗️',
        category: AchievementCategory.variety,
        requirement: 15,
        xpReward: 150,
        type: AchievementType.habitCount,
      ),
      Achievement(
        id: 'habit_guru',
        title: 'Habit Guru',
        description: 'Create 20 different habits',
        icon: '🧙',
        category: AchievementCategory.variety,
        requirement: 20,
        xpReward: 250,
        type: AchievementType.habitCount,
      ),
      Achievement(
        id: 'habit_legend',
        title: 'Habit Legend',
        description: 'Create 30 different habits',
        icon: '🦅',
        category: AchievementCategory.variety,
        requirement: 30,
        xpReward: 400,
        type: AchievementType.habitCount,
      ),
      Achievement(
        id: 'habit_overlord',
        title: 'Habit Overlord',
        description: 'Create 50 different habits',
        icon: '👑',
        category: AchievementCategory.variety,
        requirement: 50,
        xpReward: 750,
        type: AchievementType.habitCount,
      ),

      // === TOTAL COMPLETIONS ACHIEVEMENTS ===
      Achievement(
        id: 'first_ten',
        title: 'Double Digits',
        description: 'Complete 10 habits total',
        icon: '🔟',
        category: AchievementCategory.dedication,
        requirement: 10,
        xpReward: 25,
        type: AchievementType.totalCompletions,
      ),
      Achievement(
        id: 'quarter_century',
        title: 'Quarter Century',
        description: 'Complete 25 habits total',
        icon: '🎊',
        category: AchievementCategory.dedication,
        requirement: 25,
        xpReward: 50,
        type: AchievementType.totalCompletions,
      ),
      Achievement(
        id: 'half_century',
        title: 'Half Century',
        description: 'Complete 50 habits total',
        icon: '🎉',
        category: AchievementCategory.dedication,
        requirement: 50,
        xpReward: 75,
        type: AchievementType.totalCompletions,
      ),
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
        id: 'quarter_thousand',
        title: 'Quarter Millennium',
        description: 'Complete 250 habits total',
        icon: '🎯',
        category: AchievementCategory.dedication,
        requirement: 250,
        xpReward: 300,
        type: AchievementType.totalCompletions,
      ),
      Achievement(
        id: 'half_thousand',
        title: 'Half Millennium',
        description: 'Complete 500 habits total',
        icon: '🌟',
        category: AchievementCategory.dedication,
        requirement: 500,
        xpReward: 500,
        type: AchievementType.totalCompletions,
      ),
      Achievement(
        id: 'thousand_completions',
        title: 'Millennium Master',
        description: 'Complete 1000 habits total',
        icon: '💎',
        category: AchievementCategory.dedication,
        requirement: 1000,
        xpReward: 750,
        type: AchievementType.totalCompletions,
      ),
      Achievement(
        id: 'two_thousand_completions',
        title: 'Double Millennium',
        description: 'Complete 2000 habits total',
        icon: '💠',
        category: AchievementCategory.dedication,
        requirement: 2000,
        xpReward: 1200,
        type: AchievementType.totalCompletions,
      ),
      Achievement(
        id: 'three_thousand_completions',
        title: 'Triple Millennium',
        description: 'Complete 3000 habits total',
        icon: '💯',
        category: AchievementCategory.dedication,
        requirement: 3000,
        xpReward: 1800,
        type: AchievementType.totalCompletions,
      ),
      Achievement(
        id: 'five_thousand_completions',
        title: 'Quintuple Threat',
        description: 'Complete 5000 habits total',
        icon: '🔥',
        category: AchievementCategory.dedication,
        requirement: 5000,
        xpReward: 2500,
        type: AchievementType.totalCompletions,
      ),
      Achievement(
        id: 'ten_thousand_completions',
        title: 'Habit Immortal',
        description: 'Complete 10000 habits total',
        icon: '🦄',
        category: AchievementCategory.dedication,
        requirement: 10000,
        xpReward: 5000,
        type: AchievementType.totalCompletions,
      ),

      // === PRODUCTIVITY ACHIEVEMENTS ===
      Achievement(
        id: 'productivity_starter',
        title: 'Productivity Starter',
        description: 'Complete 10 productivity habits',
        icon: '📈',
        category: AchievementCategory.special,
        requirement: 10,
        xpReward: 30,
        type: AchievementType.categorySpecific,
        categoryFilter: 'Productivity',
      ),
      Achievement(
        id: 'efficiency_expert',
        title: 'Efficiency Expert',
        description: 'Complete 50 productivity habits',
        icon: '⚡',
        category: AchievementCategory.special,
        requirement: 50,
        xpReward: 100,
        type: AchievementType.categorySpecific,
        categoryFilter: 'Productivity',
      ),
      Achievement(
        id: 'productivity_guru',
        title: 'Productivity Guru',
        description: 'Complete 100 productivity habits',
        icon: '🎯',
        category: AchievementCategory.special,
        requirement: 100,
        xpReward: 200,
        type: AchievementType.categorySpecific,
        categoryFilter: 'Productivity',
      ),

      // === LEARNING ACHIEVEMENTS ===
      Achievement(
        id: 'learning_apprentice',
        title: 'Learning Apprentice',
        description: 'Complete 10 learning habits',
        icon: '📖',
        category: AchievementCategory.special,
        requirement: 10,
        xpReward: 30,
        type: AchievementType.categorySpecific,
        categoryFilter: 'Learning',
      ),
      Achievement(
        id: 'knowledge_seeker',
        title: 'Knowledge Seeker',
        description: 'Complete 50 learning habits',
        icon: '🎓',
        category: AchievementCategory.special,
        requirement: 50,
        xpReward: 100,
        type: AchievementType.categorySpecific,
        categoryFilter: 'Learning',
      ),
      Achievement(
        id: 'wisdom_keeper',
        title: 'Wisdom Keeper',
        description: 'Complete 100 learning habits',
        icon: '📚',
        category: AchievementCategory.special,
        requirement: 100,
        xpReward: 200,
        type: AchievementType.categorySpecific,
        categoryFilter: 'Learning',
      ),

      // === TIME-SPECIFIC ACHIEVEMENTS ===
      Achievement(
        id: 'sunrise_warrior',
        title: 'Sunrise Warrior',
        description: 'Complete 10 habits before 6 AM',
        icon: '🌅',
        category: AchievementCategory.special,
        requirement: 10,
        xpReward: 50,
        type: AchievementType.timeSpecific,
        timeFilter: 6,
      ),
      Achievement(
        id: 'early_bird',
        title: 'Early Bird',
        description: 'Complete 25 habits before 8 AM',
        icon: '🐦',
        category: AchievementCategory.special,
        requirement: 25,
        xpReward: 75,
        type: AchievementType.timeSpecific,
        timeFilter: 8,
      ),
      Achievement(
        id: 'dawn_patrol',
        title: 'Dawn Patrol',
        description: 'Complete 50 habits before 8 AM',
        icon: '🌄',
        category: AchievementCategory.special,
        requirement: 50,
        xpReward: 150,
        type: AchievementType.timeSpecific,
        timeFilter: 8,
      ),
      Achievement(
        id: 'morning_master',
        title: 'Morning Master',
        description: 'Complete 100 habits before 8 AM',
        icon: '☀️',
        category: AchievementCategory.special,
        requirement: 100,
        xpReward: 250,
        type: AchievementType.timeSpecific,
        timeFilter: 8,
      ),
      Achievement(
        id: 'midnight_warrior',
        title: 'Midnight Warrior',
        description: 'Complete 10 habits after midnight',
        icon: '🌙',
        category: AchievementCategory.special,
        requirement: 10,
        xpReward: 50,
        type: AchievementType.timeSpecific,
        timeFilter: 24,
      ),
      Achievement(
        id: 'night_owl',
        title: 'Night Owl',
        description: 'Complete 25 habits after 10 PM',
        icon: '🦉',
        category: AchievementCategory.special,
        requirement: 25,
        xpReward: 75,
        type: AchievementType.timeSpecific,
        timeFilter: 22,
      ),
      Achievement(
        id: 'midnight_master',
        title: 'Midnight Master',
        description: 'Complete 50 habits after 10 PM',
        icon: '🌃',
        category: AchievementCategory.special,
        requirement: 50,
        xpReward: 150,
        type: AchievementType.timeSpecific,
        timeFilter: 22,
      ),
      Achievement(
        id: 'lunch_break_hero',
        title: 'Lunch Break Hero',
        description: 'Complete 25 habits between 12-2 PM',
        icon: '🍽️',
        category: AchievementCategory.special,
        requirement: 25,
        xpReward: 75,
        type: AchievementType.timeSpecific,
        timeFilter: 13,
      ),

      // === SPECIAL CIRCUMSTANCE ACHIEVEMENTS ===
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
      Achievement(
        id: 'resilient_spirit',
        title: 'Resilient Spirit',
        description: 'Restart 3 habits after breaks',
        icon: '💪',
        category: AchievementCategory.special,
        requirement: 3,
        xpReward: 100,
        type: AchievementType.comeback,
      ),
      Achievement(
        id: 'phoenix_rising',
        title: 'Phoenix Rising',
        description: 'Restart 5 habits after breaks',
        icon: '🔥',
        category: AchievementCategory.special,
        requirement: 5,
        xpReward: 200,
        type: AchievementType.comeback,
      ),
      Achievement(
        id: 'weekend_warrior',
        title: 'Weekend Warrior',
        description: 'Complete 50 habits on weekends',
        icon: '🏖️',
        category: AchievementCategory.special,
        requirement: 50,
        xpReward: 100,
        type: AchievementType.special,
      ),
      Achievement(
        id: 'holiday_hero',
        title: 'Holiday Hero',
        description: 'Complete habits on 10 holidays',
        icon: '🎄',
        category: AchievementCategory.special,
        requirement: 10,
        xpReward: 150,
        type: AchievementType.special,
      ),

      // === SOCIAL ACHIEVEMENTS ===
      Achievement(
        id: 'social_butterfly',
        title: 'Social Butterfly',
        description: 'Complete 25 social habits',
        icon: '🦋',
        category: AchievementCategory.special,
        requirement: 25,
        xpReward: 75,
        type: AchievementType.categorySpecific,
        categoryFilter: 'Social',
      ),
      Achievement(
        id: 'community_builder',
        title: 'Community Builder',
        description: 'Complete 50 social habits',
        icon: '🏘️',
        category: AchievementCategory.special,
        requirement: 50,
        xpReward: 125,
        type: AchievementType.categorySpecific,
        categoryFilter: 'Social',
      ),

      // === FINANCE ACHIEVEMENTS ===
      Achievement(
        id: 'penny_wise',
        title: 'Penny Wise',
        description: 'Complete 10 finance habits',
        icon: '💰',
        category: AchievementCategory.special,
        requirement: 10,
        xpReward: 30,
        type: AchievementType.categorySpecific,
        categoryFilter: 'Finance',
      ),
      Achievement(
        id: 'money_master',
        title: 'Money Master',
        description: 'Complete 50 finance habits',
        icon: '💵',
        category: AchievementCategory.special,
        requirement: 50,
        xpReward: 100,
        type: AchievementType.categorySpecific,
        categoryFilter: 'Finance',
      ),
      Achievement(
        id: 'wealth_builder',
        title: 'Wealth Builder',
        description: 'Complete 100 finance habits',
        icon: '💎',
        category: AchievementCategory.special,
        requirement: 100,
        xpReward: 200,
        type: AchievementType.categorySpecific,
        categoryFilter: 'Finance',
      ),

      // === ULTIMATE ACHIEVEMENTS (VERY LONG TERM) ===
      Achievement(
        id: 'decade_dedication',
        title: 'Decade of Dedication',
        description: 'Maintain any habit for 3650 days (10 years)',
        icon: '🏛️',
        category: AchievementCategory.streak,
        requirement: 3650,
        xpReward: 10000,
        type: AchievementType.streak,
      ),
      Achievement(
        id: 'habit_sage',
        title: 'Habit Sage',
        description: 'Unlock 75% of all achievements',
        icon: '🧙‍♂️',
        category: AchievementCategory.special,
        requirement: 1, // Special logic needed
        xpReward: 2500,
        type: AchievementType.special,
      ),
      Achievement(
        id: 'habit_deity',
        title: 'Habit Deity',
        description: 'Unlock all achievements',
        icon: '👑',
        category: AchievementCategory.special,
        requirement: 1, // Special logic needed
        xpReward: 5000,
        type: AchievementType.special,
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
          final timeCompletions =
              _getTimeSpecificCompletions(completions, achievement.timeFilter!);
          earned = timeCompletions >= achievement.requirement;
          break;

        case AchievementType.comeback:
          earned = _hasComeback(habits, completions);
          break;

        case AchievementType.special:
          earned = _checkSpecialAchievement(achievement, habits, completions);
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

      AppLogger.info(
          'Awarded $xp XP${reason != null ? ' for $reason' : ''}. Total: $newXP');

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
      return allAchievements
          .where((a) => achievementIds.contains(a.id))
          .toList();
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
          currentProgress =
              _getPerfectDaysStreak(habits, completions).toDouble();
          break;
        case AchievementType.habitCount:
          currentProgress = habits.length.toDouble();
          break;
        case AchievementType.totalCompletions:
          currentProgress = completions.length.toDouble();
          break;
        case AchievementType.categorySpecific:
          currentProgress = _getCategoryCompletions(
                  habits, completions, achievement.categoryFilter!)
              .toDouble();
          break;
        case AchievementType.timeSpecific:
          currentProgress =
              _getTimeSpecificCompletions(completions, achievement.timeFilter!)
                  .toDouble();
          break;
        case AchievementType.comeback:
          currentProgress = _hasComeback(habits, completions) ? 1.0 : 0.0;
          break;
        case AchievementType.special:
          currentProgress =
              _getSpecialAchievementProgress(achievement, habits, completions);
          break;
      }

      progress[achievement.id] =
          (currentProgress / achievement.requirement).clamp(0.0, 1.0);
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
        }) /
        habits.length;

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
    // A comeback is when a user restarts a habit after missing it for 7+ days
    final now = DateTime.now();

    for (final habit in habits) {
      final habitId = habit['id'];
      if (habitId == null) continue;

      // Get all completions for this habit, sorted by date
      final habitCompletions = completions
          .where((completion) => completion['habitId'] == habitId)
          .map((completion) => completion['completedAt'] as DateTime?)
          .where((date) => date != null)
          .cast<DateTime>()
          .toList()
        ..sort();

      if (habitCompletions.length < 2) {
        continue; // Need at least 2 completions to detect a gap
      }

      // Look for gaps of 7+ days between completions
      for (int i = 1; i < habitCompletions.length; i++) {
        final previousCompletion = habitCompletions[i - 1];
        final currentCompletion = habitCompletions[i];

        final daysBetween =
            currentCompletion.difference(previousCompletion).inDays;

        // If there's a gap of 7+ days and the current completion is recent (within last 30 days)
        if (daysBetween >= 7 &&
            now.difference(currentCompletion).inDays <= 30) {
          return true; // Found a comeback!
        }
      }

      // Also check if there's a recent completion after a long gap from the last completion
      if (habitCompletions.isNotEmpty) {
        final lastCompletion = habitCompletions.last;
        final daysSinceLastCompletion = now.difference(lastCompletion).inDays;

        // If the last completion was recent (within 7 days) but there was a long gap before it
        if (daysSinceLastCompletion <= 7 && habitCompletions.length >= 2) {
          final secondLastCompletion =
              habitCompletions[habitCompletions.length - 2];
          final gapBeforeLastCompletion =
              lastCompletion.difference(secondLastCompletion).inDays;

          if (gapBeforeLastCompletion >= 7) {
            return true; // Recent comeback detected!
          }
        }
      }
    }

    return false;
  }

  static double _calculateOverallCompletionRate(
    List<Map<String, dynamic>> habits,
    List<Map<String, dynamic>> completions,
  ) {
    if (habits.isEmpty) return 0.0;

    return habits.fold<double>(0.0, (sum, habit) {
          return sum + (habit['completionRate'] ?? 0.0);
        }) /
        habits.length;
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

  /// Check if special achievement criteria are met
  static bool _checkSpecialAchievement(
    Achievement achievement,
    List<Map<String, dynamic>> habits,
    List<Map<String, dynamic>> completions,
  ) {
    switch (achievement.id) {
      case 'weekend_warrior':
        return _getWeekendCompletions(completions) >= achievement.requirement;
      case 'holiday_hero':
        return _getHolidayCompletions(completions) >= achievement.requirement;
      case 'habit_sage':
        // Check if 75% of achievements are unlocked
        return _getAchievementUnlockPercentage() >= 0.75;
      case 'habit_deity':
        // Check if all achievements are unlocked
        return _getAchievementUnlockPercentage() >= 1.0;
      default:
        return false;
    }
  }

  /// Get progress for special achievements
  static double _getSpecialAchievementProgress(
    Achievement achievement,
    List<Map<String, dynamic>> habits,
    List<Map<String, dynamic>> completions,
  ) {
    switch (achievement.id) {
      case 'weekend_warrior':
        return _getWeekendCompletions(completions).toDouble();
      case 'holiday_hero':
        return _getHolidayCompletions(completions).toDouble();
      case 'habit_sage':
      case 'habit_deity':
        return _getAchievementUnlockPercentage();
      default:
        return 0.0;
    }
  }

  /// Count completions on weekends
  static int _getWeekendCompletions(List<Map<String, dynamic>> completions) {
    return completions.where((completion) {
      final date = completion['completedAt'] as DateTime?;
      if (date == null) return false;
      return date.weekday == DateTime.saturday ||
          date.weekday == DateTime.sunday;
    }).length;
  }

  /// Count completions on holidays (simplified - you can expand this)
  static int _getHolidayCompletions(List<Map<String, dynamic>> completions) {
    // This is a simplified version - you'd want to add actual holiday dates
    final holidays = [
      DateTime(DateTime.now().year, 1, 1), // New Year's Day
      DateTime(DateTime.now().year, 7, 4), // Independence Day (US)
      DateTime(DateTime.now().year, 12, 25), // Christmas
      // Add more holidays as needed
    ];

    return completions.where((completion) {
      final date = completion['completedAt'] as DateTime?;
      if (date == null) return false;
      return holidays.any((holiday) =>
          holiday.year == date.year &&
          holiday.month == date.month &&
          holiday.day == date.day);
    }).length;
  }

  /// Get percentage of achievements unlocked (placeholder - needs async implementation)
  static double _getAchievementUnlockPercentage() {
    // This is a placeholder - in a real implementation, you'd need to make this async
    // and check the actual unlocked achievements percentage
    return 0.0; // Will need proper implementation
  }
}

enum AchievementCategory {
  streak,
  consistency,
  variety,
  dedication,
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
  special,
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
