// Complete Hive database implementation for HabitV8.
// This handles all database operations for habits including CRUD operations,
// caching, notifications integration, and calendar synchronization.

import 'dart:math' as math;
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../domain/model/habit.dart';
import '../services/habit_stats_service.dart';
import '../services/cache_service.dart';
import '../services/notification_service.dart';
import '../services/logging_service.dart';
import '../services/calendar_service.dart';
import '../services/achievements_service.dart';

// Provider for the Habit database box
final databaseProvider = FutureProvider<Box<Habit>>((ref) async {
  return await DatabaseService.getInstance();
});

// Provider for the HabitService
final habitServiceProvider = FutureProvider<HabitService>((ref) async {
  final habitBox = await ref.watch(databaseProvider.future);
  return HabitService(habitBox);
});

// State class for habits with real-time updates
class HabitsState {
  final List<Habit> habits;
  final bool isLoading;
  final String? error;
  final DateTime lastUpdated;

  const HabitsState({
    required this.habits,
    this.isLoading = false,
    this.error,
    required this.lastUpdated,
  });

  HabitsState copyWith({
    List<Habit>? habits,
    bool? isLoading,
    String? error,
    DateTime? lastUpdated,
  }) {
    return HabitsState(
      habits: habits ?? this.habits,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

// StateNotifier for real-time habit updates
class HabitsNotifier extends StateNotifier<HabitsState> {
  final HabitService _habitService;
  Timer? _refreshTimer;
  final Map<String, int> _habitCompletionsCount = {};
  static bool _databaseResetInProgress = false; // Track database reset state

  HabitsNotifier(this._habitService)
      : super(HabitsState(
          habits: [],
          isLoading: true,
          lastUpdated: DateTime.now(),
        )) {
    _loadHabits();
    _startPeriodicRefresh();
  }

  Future<void> _loadHabits() async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final habits = await _habitService.getAllHabits();
      _updateCompletionsCount(habits);
      state = state.copyWith(
        habits: habits,
        isLoading: false,
        lastUpdated: DateTime.now(),
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
        lastUpdated: DateTime.now(),
      );
    }
  }

  void _updateCompletionsCount(List<Habit> habits) {
    _habitCompletionsCount.clear();
    for (final habit in habits) {
      _habitCompletionsCount[habit.id] = habit.completions.length;
    }
  }

  void _startPeriodicRefresh() {
    _refreshTimer?.cancel();
    // Reduced from 3 seconds to 1 second for faster UI updates
    _refreshTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _checkForUpdates();
    });
  }

  Future<void> _checkForUpdates() async {
    // Skip check if database reset is in progress
    if (_databaseResetInProgress) {
      return;
    }

    try {
      final habits = await _habitService.getAllHabits();
      // Only update if habits have actually changed
      if (_habitsChanged(habits)) {
        _updateCompletionsCount(habits);
        state = state.copyWith(
          habits: habits,
          lastUpdated: DateTime.now(),
        );
      }
    } catch (e) {
      // Handle specific case where box has been closed (during database reset)
      if (e.toString().contains('Box has already been closed') ||
          e.toString().contains('HiveError')) {
        AppLogger.debug('Database was reset, stopping periodic refresh: $e');
        _refreshTimer?.cancel(); // Stop the timer since database is being reset
        return;
      }
      // Silently handle other errors during periodic refresh
      AppLogger.debug('Periodic habit refresh failed: $e');
    }
  }

  bool _habitsChanged(List<Habit> newHabits) {
    if (state.habits.length != newHabits.length) return true;

    // Create a map for faster lookups
    final oldHabitsMap = {for (final habit in state.habits) habit.id: habit};

    for (final newHabit in newHabits) {
      final oldHabit = oldHabitsMap[newHabit.id];
      if (oldHabit == null) return true; // New habit added

      // Check if completions count changed (most sensitive check for timeline updates)
      final oldCompletionsCount = _habitCompletionsCount[newHabit.id] ?? 0;
      if (newHabit.completions.length != oldCompletionsCount) return true;

      // Also check if completions changed by comparing the most recent completion
      if (newHabit.completions.isNotEmpty && oldHabit.completions.isNotEmpty) {
        final newLatest = newHabit.completions.last;
        final oldLatest = oldHabit.completions.last;
        if (newLatest != oldLatest) return true;
      } else if (newHabit.completions.length != oldHabit.completions.length) {
        return true;
      }

      // Check other key properties
      if (oldHabit.name != newHabit.name ||
          oldHabit.isActive != newHabit.isActive ||
          oldHabit.notificationsEnabled != newHabit.notificationsEnabled) {
        return true;
      }
    }
    return false;
  }

  Future<void> refreshHabits() async {
    await _loadHabits();
  }

  /// Force immediate refresh for critical updates (like notification completions)
  Future<void> forceImmediateRefresh() async {
    // Skip refresh if database reset is in progress
    if (_databaseResetInProgress) {
      AppLogger.debug('Skipping force refresh - database reset in progress');
      return;
    }

    try {
      AppLogger.info('🚀 Force immediate habits refresh triggered');
      // Cancel periodic timer briefly to avoid conflicts
      _refreshTimer?.cancel();

      // Force immediate reload
      await _loadHabits();

      // Restart periodic refresh
      _startPeriodicRefresh();

      AppLogger.info('✅ Force immediate habits refresh completed');
    } catch (e) {
      AppLogger.error('❌ Error in force immediate refresh', e);
      // Ensure periodic refresh is restarted even on error
      _startPeriodicRefresh();
      rethrow;
    }
  }

  Future<void> updateHabit(Habit habit) async {
    try {
      await _habitService.updateHabit(habit);
      // Immediately refresh to show changes
      await _loadHabits();
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  // Static methods to control database reset state
  static void markDatabaseResetInProgress() {
    _databaseResetInProgress = true;
  }

  static void markDatabaseResetComplete() {
    _databaseResetInProgress = false;
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }
}

// Provider for real-time habits state
final habitsNotifierProvider =
    StateNotifierProvider<HabitsNotifier, HabitsState>((ref) {
  // Watch both providers to ensure proper initialization order
  final habitServiceAsync = ref.watch(habitServiceProvider);

  return habitServiceAsync.when(
    data: (habitService) => HabitsNotifier(habitService),
    loading: () => throw StateError('HabitService is loading'),
    error: (error, stackTrace) =>
        throw StateError('HabitService error: $error'),
  );
});

// Fallback provider that handles the loading state gracefully
final habitsStateProvider = Provider<AsyncValue<HabitsState>>((ref) {
  try {
    final habitsState = ref.watch(habitsNotifierProvider);
    return AsyncValue.data(habitsState);
  } catch (e) {
    // Return loading state while services are initializing
    return const AsyncValue.loading();
  }
});

class DatabaseService {
  static Box<Habit>? _habitBox;
  static bool _adaptersRegistered = false;

  static Future<Box<Habit>> getInstance() async {
    if (_habitBox != null && _habitBox!.isOpen) return _habitBox!;

    await Hive.initFlutter();

    // Only register adapters once to prevent duplicate registration error
    if (!_adaptersRegistered) {
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(HabitAdapter());
      }
      if (!Hive.isAdapterRegistered(1)) {
        Hive.registerAdapter(HabitFrequencyAdapter());
      }
      if (!Hive.isAdapterRegistered(2)) {
        Hive.registerAdapter(HabitDifficultyAdapter());
      }
      _adaptersRegistered = true;
    }

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
    _adaptersRegistered = false; // Reset adapter registration state
  }

  // Method to manually reset the database if needed
  static Future<void> resetDatabase() async {
    try {
      // Close the database connection first
      await closeDatabase();

      // Small delay to ensure proper closure
      await Future.delayed(const Duration(milliseconds: 100));

      // Delete the box from disk
      await Hive.deleteBoxFromDisk('habits');

      AppLogger.info(
        'Database reset completed. All habit data has been cleared.',
      );
    } catch (e) {
      AppLogger.error('Error during database reset', e);
      rethrow;
    }
  }

  /// Clean up expired single habits to prevent clutter and improve performance
  static Future<void> cleanupExpiredSingleHabits() async {
    try {
      final habitBox = await getInstance();
      final allHabits = habitBox.values.toList();
      final now = DateTime.now();

      final expiredHabits = allHabits.where((habit) {
        return habit.frequency == HabitFrequency.single &&
            habit.singleDateTime != null &&
            habit.singleDateTime!.isBefore(now) &&
            habit.completions.isEmpty; // Not completed yet
      }).toList();

      for (final habit in expiredHabits) {
        // Archive expired single habit instead of deleting
        habit.isActive = false;
        await habit.save();

        // Cancel any pending notifications for this habit
        try {
          await NotificationService.cancelHabitNotifications(
              NotificationService.generateSafeId(habit.id));
        } catch (e) {
          AppLogger.warning(
              'Failed to cancel notifications for expired habit ${habit.name}: $e');
        }

        AppLogger.info(
            'Archived expired single habit: "${habit.name}" (was due: ${habit.singleDateTime})');
      }

      if (expiredHabits.isNotEmpty) {
        AppLogger.info(
            '✅ Cleaned up ${expiredHabits.length} expired single habits');
      }
    } catch (e) {
      AppLogger.error('❌ Error cleaning up expired single habits', e);
    }
  }
}

class HabitService {
  final Box<Habit> _habitBox;
  final HabitStatsService _statsService = HabitStatsService();
  List<Habit>? _cachedHabits;
  DateTime? _cacheTimestamp;
  static const Duration _cacheExpiry =
      Duration(seconds: 5); // Reduced from 30 to 5 seconds

  HabitService(this._habitBox);

  Future<List<Habit>> getAllHabits() async {
    final now = DateTime.now();

    // Return cached data if it's still valid
    if (_cachedHabits != null &&
        _cacheTimestamp != null &&
        now.difference(_cacheTimestamp!) < _cacheExpiry) {
      return _cachedHabits!;
    }

    // Fetch fresh data and cache it
    final habits = _habitBox.values.toList();
    _cachedHabits = habits;
    _cacheTimestamp = now;

    return habits;
  }

  void _invalidateCache() {
    _cachedHabits = null;
    _cacheTimestamp = null;
  }

  Future<void> addHabit(Habit habit) async {
    await _habitBox.add(habit);
    _invalidateCache(); // Invalidate cache when adding new habit

    // Check for new achievements after adding habit
    try {
      await _checkForAchievements();
    } catch (e) {
      AppLogger.error('Failed to check for achievements after adding habit', e);
    }

    // Schedule notifications/alarms for the new habit
    try {
      if (habit.notificationsEnabled || habit.alarmEnabled) {
        await NotificationService.scheduleHabitNotifications(habit);
        AppLogger.info(
            'Scheduled notifications/alarms for new habit "${habit.name}"');
      }
    } catch (e) {
      AppLogger.error('Failed to schedule notifications for new habit', e);
    }

    // Sync to calendar if enabled
    try {
      final syncEnabled = await CalendarService.isCalendarSyncEnabled();
      if (syncEnabled) {
        await CalendarService.syncHabitChanges(habit);
        AppLogger.info('Synced new habit "${habit.name}" to calendar');
      } else {
        AppLogger.debug(
            'Calendar sync disabled, skipping sync for new habit "${habit.name}"');
      }
    } catch (e) {
      AppLogger.error('Failed to sync new habit to calendar', e);
    }
  }

  Future<void> updateHabit(Habit habit) async {
    await habit.save();
    _invalidateCache(); // Invalidate cache when updating habit

    // Reschedule notifications/alarms for the updated habit
    try {
      if (habit.notificationsEnabled || habit.alarmEnabled) {
        await NotificationService.scheduleHabitNotifications(habit);
        AppLogger.info(
            'Rescheduled notifications/alarms for updated habit "${habit.name}"');
      } else {
        // Cancel notifications if they were disabled
        final habitIdHash = NotificationService.generateSafeId(habit.id);
        await NotificationService.cancelHabitNotifications(habitIdHash);
        AppLogger.info(
            'Cancelled notifications for habit "${habit.name}" (disabled)');
      }
    } catch (e) {
      AppLogger.error(
          'Failed to reschedule notifications for updated habit', e);
    }

    // Sync to calendar if enabled
    try {
      final syncEnabled = await CalendarService.isCalendarSyncEnabled();
      if (syncEnabled) {
        await CalendarService.syncHabitChanges(habit);
        AppLogger.info('Synced updated habit "${habit.name}" to calendar');
      } else {
        AppLogger.debug(
            'Calendar sync disabled, skipping sync for updated habit "${habit.name}"');
      }
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
        final syncEnabled = await CalendarService.isCalendarSyncEnabled();
        if (syncEnabled) {
          await CalendarService.syncHabitChanges(habit, isDeleted: true);
          AppLogger.info('Removed habit "${habit.name}" from calendar');
        } else {
          AppLogger.debug(
              'Calendar sync disabled, skipping removal for deleted habit "${habit.name}"');
        }
      } catch (e) {
        AppLogger.error('Failed to remove habit from calendar', e);
      }

      // Invalidate cache before deletion
      _statsService.invalidateHabitCache(habit.id);
      _invalidateCache();

      // Delete the habit from database
      await habit.delete();

      AppLogger.info(
        'Successfully deleted habit: ${habit.name} and cancelled all associated notifications',
      );
    } catch (e) {
      AppLogger.error('Error deleting habit ${habit.name}', e);
      // Still attempt to delete the habit even if notification cancellation fails
      _statsService.invalidateHabitCache(habit.id);
      _invalidateCache();
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
        // For hourly habits, prevent exact duplicates (same hour and minute)
        // but allow multiple completions per hour at different minutes
        alreadyCompleted = habit.completions.any((completion) {
          return completion.year == completionDate.year &&
              completion.month == completionDate.month &&
              completion.day == completionDate.day &&
              completion.hour == completionDate.hour &&
              completion.minute == completionDate.minute;
        });
        break;

      case HabitFrequency.daily:
        // For daily habits, prevent duplicates on the same day
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

      case HabitFrequency.weekly:
        // For weekly habits, prevent duplicates within the same week
        final weekStart = _getWeekStart(completionDate);
        final weekEnd = weekStart.add(
          const Duration(days: 6, hours: 23, minutes: 59, seconds: 59),
        );
        alreadyCompleted = habit.completions.any((completion) {
          return completion.isAfter(
                weekStart.subtract(const Duration(seconds: 1)),
              ) &&
              completion.isBefore(weekEnd.add(const Duration(seconds: 1)));
        });
        break;

      case HabitFrequency.monthly:
        // For monthly habits, prevent duplicates within the same month
        final monthStart = DateTime(
          completionDate.year,
          completionDate.month,
          1,
        );
        final monthEnd = DateTime(
          completionDate.year,
          completionDate.month + 1,
          1,
        ).subtract(const Duration(seconds: 1));
        alreadyCompleted = habit.completions.any((completion) {
          return completion.isAfter(
                monthStart.subtract(const Duration(seconds: 1)),
              ) &&
              completion.isBefore(monthEnd.add(const Duration(seconds: 1)));
        });
        break;

      case HabitFrequency.yearly:
        // For yearly habits, prevent duplicates within the same year
        final yearStart = DateTime(completionDate.year, 1, 1);
        final yearEnd = DateTime(
          completionDate.year + 1,
          1,
          1,
        ).subtract(const Duration(seconds: 1));
        alreadyCompleted = habit.completions.any((completion) {
          return completion.isAfter(
                yearStart.subtract(const Duration(seconds: 1)),
              ) &&
              completion.isBefore(yearEnd.add(const Duration(seconds: 1)));
        });
        break;

      case HabitFrequency.single:
        // For single habits, prevent any duplicates (can only be completed once)
        alreadyCompleted = habit.completions.isNotEmpty;
        break;
    }

    if (!alreadyCompleted) {
      habit.completions.add(completionDate);
      _updateStreaks(habit);

      // Invalidate cache before saving
      _statsService.invalidateHabitCache(habitId);
      await habit.save();

      // Check for new achievements after completing the habit
      try {
        await _checkForAchievements();
      } catch (e) {
        AppLogger.error(
            'Failed to check for achievements after habit completion', e);
      }

      // Sync completion to calendar if enabled
      try {
        final syncEnabled = await CalendarService.isCalendarSyncEnabled();
        if (syncEnabled) {
          await CalendarService.syncHabitChanges(habit);
          AppLogger.debug(
            'Synced habit completion for "${habit.name}" to calendar',
          );
        } else {
          AppLogger.debug(
              'Calendar sync disabled, skipping completion sync for habit "${habit.name}"');
        }
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

    // Check for achievement changes after removing completion
    try {
      await _checkForAchievements();
    } catch (e) {
      AppLogger.error(
          'Failed to check for achievements after completion removal', e);
    }

    // Sync removal to calendar if enabled
    try {
      final syncEnabled = await CalendarService.isCalendarSyncEnabled();
      if (syncEnabled) {
        await CalendarService.syncHabitChanges(habit);
        AppLogger.debug(
          'Synced habit completion removal for "${habit.name}" to calendar',
        );
      } else {
        AppLogger.debug(
            'Calendar sync disabled, skipping completion removal sync for habit "${habit.name}"');
      }
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
    final syncEnabled = await CalendarService.isCalendarSyncEnabled();
    for (final habit in habitsToUpdate) {
      try {
        if (syncEnabled) {
          await CalendarService.syncHabitChanges(habit);
          AppLogger.debug(
            'Synced bulk completion for "${habit.name}" to calendar',
          );
        } else {
          AppLogger.debug(
              'Calendar sync disabled, skipping bulk completion sync for habit "${habit.name}"');
        }
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

      case HabitFrequency.weekly:
        // Check if completed in the current week (Monday to Sunday)
        final weekStart = _getWeekStart(checkTime);
        final weekEnd = weekStart.add(
          const Duration(days: 6, hours: 23, minutes: 59, seconds: 59),
        );
        return habit.completions.any((completion) {
          return completion.isAfter(
                weekStart.subtract(const Duration(seconds: 1)),
              ) &&
              completion.isBefore(weekEnd.add(const Duration(seconds: 1)));
        });

      case HabitFrequency.monthly:
        // Check if completed in the current month
        final monthStart = DateTime(checkTime.year, checkTime.month, 1);
        final monthEnd = DateTime(
          checkTime.year,
          checkTime.month + 1,
          1,
        ).subtract(const Duration(seconds: 1));
        return habit.completions.any((completion) {
          return completion.isAfter(
                monthStart.subtract(const Duration(seconds: 1)),
              ) &&
              completion.isBefore(monthEnd.add(const Duration(seconds: 1)));
        });

      case HabitFrequency.yearly:
        // Check if completed in the current year
        final yearStart = DateTime(checkTime.year, 1, 1);
        final yearEnd = DateTime(
          checkTime.year + 1,
          1,
          1,
        ).subtract(const Duration(seconds: 1));
        return habit.completions.any((completion) {
          return completion.isAfter(
                yearStart.subtract(const Duration(seconds: 1)),
              ) &&
              completion.isBefore(yearEnd.add(const Duration(seconds: 1)));
        });

      case HabitFrequency.single:
        // Single habits can only be completed once - check if already completed
        return habit.completions.isNotEmpty;
    }
  }

  /// Get the start of the week (Monday) for a given date
  DateTime _getWeekStart(DateTime date) {
    // Get the Monday of the current week
    final daysFromMonday = (date.weekday - 1) % 7;
    return DateTime(
      date.year,
      date.month,
      date.day,
    ).subtract(Duration(days: daysFromMonday));
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

  Future<void> _checkForAchievements() async {
    try {
      // Get all habits
      final habits = await getAllHabits();

      // Convert habits to the format expected by AchievementsService
      final habitData = habits
          .map((h) => {
                'id': h.id,
                'name': h.name,
                'category': h.category,
                'currentStreak': h.streakInfo.current,
                'longestStreak': h.streakInfo.longest,
                'completionRate': h.completionRate,
                'completions': h.completions
                    .map((c) => {
                          'timestamp': c.millisecondsSinceEpoch,
                          'hour': c.hour,
                        })
                    .toList(),
              })
          .toList();

      final completionData = habits
          .expand((h) => h.completions)
          .map((c) => {
                'timestamp': c.millisecondsSinceEpoch,
                'habitId':
                    habits.firstWhere((h) => h.completions.contains(c)).id,
                'hour': c.hour,
              })
          .toList();

      // Check for new achievements
      final newAchievements = await AchievementsService.checkForNewAchievements(
        habits: habitData,
        completions: completionData,
      );

      if (newAchievements.isNotEmpty) {
        AppLogger.info('${newAchievements.length} new achievement(s) unlocked');
        for (final achievement in newAchievements) {
          AppLogger.info('Achievement unlocked: ${achievement.title}');
        }
      }
    } catch (e) {
      AppLogger.error('Error checking for achievements', e);
    }
  }
}
