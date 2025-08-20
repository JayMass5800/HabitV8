// A placeholder for the Hive database implementation.
// This will be responsible for all the database operations.

import 'dart:math' as math;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../domain/model/habit.dart';
import '../services/habit_stats_service.dart';
import '../services/cache_service.dart';
import '../services/notification_service.dart';
import '../services/logging_service.dart';
import '../services/calendar_service.dart';

// Provider for the Habit database box
final databaseProvider = FutureProvider<Box<Habit>>((ref) async {
  return await DatabaseService.getInstance();
});

// Provider for the HabitService
final habitServiceProvider = FutureProvider<HabitService>((ref) async {
  final habitBox = await ref.watch(databaseProvider.future);
  return HabitService(habitBox);
});

class DatabaseService {
  static Box<Habit>? _habitBox;

  static Future<Box<Habit>> getInstance() async {
    if (_habitBox != null) return _habitBox!;

    await Hive.initFlutter();
    Hive.registerAdapter(HabitAdapter());
    Hive.registerAdapter(HabitFrequencyAdapter());
    Hive.registerAdapter(HabitDifficultyAdapter());

    try {
      _habitBox = await Hive.openBox<Habit>('habits');
    } catch (e) {
      // If there's an adapter error with existing data, delete the box and recreate it
      AppLogger.error('Error opening habits box', e);
      AppLogger.info(
        'Clearing habits box due to adapter registration issues...',
      );
      await Hive.deleteBoxFromDisk('habits');
      _habitBox = await Hive.openBox<Habit>('habits');
    }

    return _habitBox!;
  }

  static Future<void> closeDatabase() async {
    await _habitBox?.close();
    _habitBox = null;
  }

  // Method to manually reset the database if needed
  static Future<void> resetDatabase() async {
    await closeDatabase();
    await Hive.deleteBoxFromDisk('habits');
    AppLogger.info(
      'Database reset completed. All habit data has been cleared.',
    );
  }
}

class HabitService {
  final Box<Habit> _habitBox;
  final HabitStatsService _statsService = HabitStatsService();

  HabitService(this._habitBox);

  Future<List<Habit>> getAllHabits() async {
    return _habitBox.values.toList();
  }

  Future<void> addHabit(Habit habit) async {
    await _habitBox.add(habit);
    // No need to invalidate cache for new habits

    // Sync to calendar if enabled
    try {
      await CalendarService.syncHabitChanges(habit);
      AppLogger.info('Synced new habit "${habit.name}" to calendar');
    } catch (e) {
      AppLogger.error('Failed to sync new habit to calendar', e);
    }
  }

  Future<void> updateHabit(Habit habit) async {
    await habit.save();
    // Cache is automatically invalidated by habit.save()

    // Sync to calendar if enabled
    try {
      await CalendarService.syncHabitChanges(habit);
      AppLogger.info('Synced updated habit "${habit.name}" to calendar');
    } catch (e) {
      AppLogger.error('Failed to sync updated habit to calendar', e);
    }
  }

  Future<void> deleteHabit(Habit habit) async {
    try {
      // Cancel all notifications for this habit before deletion
      final habitIdHash = NotificationService.generateSafeId(habit.id);
      await NotificationService.cancelHabitNotifications(habitIdHash);

      // Remove from calendar before deletion
      try {
        await CalendarService.syncHabitChanges(habit, isDeleted: true);
        AppLogger.info('Removed habit "${habit.name}" from calendar');
      } catch (e) {
        AppLogger.error('Failed to remove habit from calendar', e);
      }

      // Invalidate cache before deletion
      _statsService.invalidateHabitCache(habit.id);

      // Delete the habit from database
      await habit.delete();

      AppLogger.info(
        'Successfully deleted habit: ${habit.name} and cancelled all associated notifications',
      );
    } catch (e) {
      AppLogger.error('Error deleting habit ${habit.name}', e);
      // Still attempt to delete the habit even if notification cancellation fails
      _statsService.invalidateHabitCache(habit.id);
      await habit.delete();
    }
  }

  Future<Habit?> getHabitById(String id) async {
    try {
      return _habitBox.values.firstWhere((habit) => habit.id == id);
    } catch (e) {
      return null; // Return null instead of throwing
    }
  }

  Future<List<Habit>> getActiveHabits() async {
    return _habitBox.values.where((habit) => habit.isActive).toList();
  }

  Future<void> markHabitComplete(
    String habitId,
    DateTime completionDate,
  ) async {
    final habit = _habitBox.values.cast<Habit?>().firstWhere(
      (h) => h?.id == habitId,
      orElse: () => null,
    );

    if (habit == null) {
      AppLogger.warning('Habit not found for completion: $habitId');
      return;
    }

    bool alreadyCompleted = false;

    // Check for duplicates based on habit frequency
    switch (habit.frequency) {
      case HabitFrequency.hourly:
        // For hourly habits, prevent duplicates within the same hour
        final completionHour = DateTime(
          completionDate.year,
          completionDate.month,
          completionDate.day,
          completionDate.hour,
        );
        alreadyCompleted = habit.completions.any((completion) {
          final existingHour = DateTime(
            completion.year,
            completion.month,
            completion.day,
            completion.hour,
          );
          return existingHour.isAtSameMomentAs(completionHour);
        });
        break;

      case HabitFrequency.daily:
      case HabitFrequency.weekly:
      case HabitFrequency.monthly:
      case HabitFrequency.yearly:
        // For other frequencies, prevent duplicates on the same day
        final today = DateTime(
          completionDate.year,
          completionDate.month,
          completionDate.day,
        );
        alreadyCompleted = habit.completions.any((completion) {
          final completionDay = DateTime(
            completion.year,
            completion.month,
            completion.day,
          );
          return completionDay.isAtSameMomentAs(today);
        });
        break;
    }

    if (!alreadyCompleted) {
      habit.completions.add(completionDate);
      _updateStreaks(habit);

      // Invalidate cache before saving
      _statsService.invalidateHabitCache(habitId);
      await habit.save();

      // Sync completion to calendar if enabled
      try {
        await CalendarService.syncHabitChanges(habit);
        AppLogger.debug(
          'Synced habit completion for "${habit.name}" to calendar',
        );
      } catch (e) {
        AppLogger.error('Failed to sync habit completion to calendar', e);
      }
    }
  }

  Future<void> removeHabitCompletion(
    String habitId,
    DateTime completionDate,
  ) async {
    final habit = _habitBox.values.firstWhere((h) => h.id == habitId);
    final today = DateTime(
      completionDate.year,
      completionDate.month,
      completionDate.day,
    );

    habit.completions.removeWhere((completion) {
      final completionDay = DateTime(
        completion.year,
        completion.month,
        completion.day,
      );
      return completionDay.isAtSameMomentAs(today);
    });

    _updateStreaks(habit);

    // Invalidate cache before saving
    _statsService.invalidateHabitCache(habitId);
    await habit.save();

    // Sync removal to calendar if enabled
    try {
      await CalendarService.syncHabitChanges(habit);
      AppLogger.debug(
        'Synced habit completion removal for "${habit.name}" to calendar',
      );
    } catch (e) {
      AppLogger.error('Failed to sync habit completion removal to calendar', e);
    }
  }

  // Bulk operations for better performance
  Future<void> markMultipleHabitsComplete(
    List<String> habitIds,
    DateTime completionDate,
  ) async {
    final habitsToUpdate = <Habit>[];

    for (final habitId in habitIds) {
      final habit = _habitBox.values.firstWhere((h) => h.id == habitId);
      final today = DateTime(
        completionDate.year,
        completionDate.month,
        completionDate.day,
      );

      final alreadyCompleted = habit.completions.any((completion) {
        final completionDay = DateTime(
          completion.year,
          completion.month,
          completion.day,
        );
        return completionDay.isAtSameMomentAs(today);
      });

      if (!alreadyCompleted) {
        habit.completions.add(completionDate);
        _updateStreaks(habit);
        habitsToUpdate.add(habit);
      }
    }

    // Batch invalidate caches
    for (final habit in habitsToUpdate) {
      _statsService.invalidateHabitCache(habit.id);
    }

    // Batch save
    for (final habit in habitsToUpdate) {
      await habit.save();
    }

    // Sync all updated habits to calendar if enabled
    for (final habit in habitsToUpdate) {
      try {
        await CalendarService.syncHabitChanges(habit);
        AppLogger.debug(
          'Synced bulk completion for "${habit.name}" to calendar',
        );
      } catch (e) {
        AppLogger.error(
          'Failed to sync bulk completion to calendar for "${habit.name}"',
          e,
        );
      }
    }
  }

  // Cleanup expired cache entries periodically
  void cleanupCache() {
    _statsService.cache.cleanup();
  }

  // Get cache statistics for monitoring
  CacheStats getCacheStats() {
    return _statsService.cache.getStats();
  }

  /// Check if habit is completed for the current time period
  bool isHabitCompletedForCurrentPeriod(String habitId, DateTime checkTime) {
    final habit = _habitBox.values.cast<Habit?>().firstWhere(
      (h) => h?.id == habitId,
      orElse: () => null,
    );

    if (habit == null) {
      AppLogger.warning('Habit not found for completion check: $habitId');
      return false;
    }

    switch (habit.frequency) {
      case HabitFrequency.hourly:
        // Check if completed in the current hour
        final currentHour = DateTime(
          checkTime.year,
          checkTime.month,
          checkTime.day,
          checkTime.hour,
        );
        return habit.completions.any((completion) {
          final completionHour = DateTime(
            completion.year,
            completion.month,
            completion.day,
            completion.hour,
          );
          return completionHour.isAtSameMomentAs(currentHour);
        });

      case HabitFrequency.daily:
      case HabitFrequency.weekly:
      case HabitFrequency.monthly:
      case HabitFrequency.yearly:
        // Check if completed today
        final today = DateTime(checkTime.year, checkTime.month, checkTime.day);
        return habit.completions.any((completion) {
          final completionDay = DateTime(
            completion.year,
            completion.month,
            completion.day,
          );
          return completionDay.isAtSameMomentAs(today);
        });
    }
  }

  void _updateStreaks(Habit habit) {
    if (habit.completions.isEmpty) {
      habit.currentStreak = 0;
      return;
    }

    // Sort completions by date
    final sortedCompletions = habit.completions.toList()
      ..sort((a, b) => b.compareTo(a)); // Most recent first

    int currentStreak = 0;
    int longestStreak = 0;
    int tempStreak = 1;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final mostRecent = DateTime(
      sortedCompletions.first.year,
      sortedCompletions.first.month,
      sortedCompletions.first.day,
    );

    // Check if most recent completion is today or yesterday
    final daysDiff = today.difference(mostRecent).inDays;
    if (daysDiff <= 1) {
      currentStreak = 1;

      // Count consecutive days backwards
      for (int i = 1; i < sortedCompletions.length; i++) {
        final current = DateTime(
          sortedCompletions[i - 1].year,
          sortedCompletions[i - 1].month,
          sortedCompletions[i - 1].day,
        );
        final previous = DateTime(
          sortedCompletions[i].year,
          sortedCompletions[i].month,
          sortedCompletions[i].day,
        );

        if (current.difference(previous).inDays == 1) {
          currentStreak++;
          tempStreak++;
        } else {
          break;
        }
      }
    }

    // Calculate longest streak
    tempStreak = 1;
    for (int i = 1; i < sortedCompletions.length; i++) {
      final current = DateTime(
        sortedCompletions[i - 1].year,
        sortedCompletions[i - 1].month,
        sortedCompletions[i - 1].day,
      );
      final previous = DateTime(
        sortedCompletions[i].year,
        sortedCompletions[i].month,
        sortedCompletions[i].day,
      );

      if (current.difference(previous).inDays == 1) {
        tempStreak++;
      } else {
        longestStreak = math.max(longestStreak, tempStreak);
        tempStreak = 1;
      }
    }
    longestStreak = math.max(longestStreak, tempStreak);

    habit.currentStreak = currentStreak;
    habit.longestStreak = longestStreak;
  }
}
