import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../domain/model/habit.dart';
import '../domain/model/archived_habit.dart';
import '../domain/model/scheduled_notification.dart';
import '../services/logging_service.dart';
import '../services/notification_service.dart';

// Provider for Isar instance
final isarProvider = FutureProvider<Isar>((ref) async {
  return await IsarDatabaseService.getInstance();
});

// Provider for HabitService
final habitServiceIsarProvider = FutureProvider<HabitServiceIsar>((ref) async {
  final isar = await ref.watch(isarProvider.future);
  return HabitServiceIsar(isar);
});

// Stream provider for reactive habit updates
// CRITICAL: NOT using autoDispose to keep stream alive even when screens are not visible
// This ensures immediate updates when habits are completed from notifications
final habitsStreamIsarProvider = StreamProvider<List<Habit>>((ref) {
  return Stream<List<Habit>>.multi((controller) async {
    final habitService = await ref.watch(habitServiceIsarProvider.future);

    // Emit initial data
    final initialHabits = await habitService.getAllHabits();
    controller.add(initialHabits);
    AppLogger.info(
        '🔄 habitsStreamIsarProvider: Emitted initial data (${initialHabits.length} habits)');

    // Listen to Isar's watch stream for real-time updates
    final subscription = habitService.watchAllHabits().listen(
      (habits) {
        AppLogger.info(
            '🔔 Isar: Emitting ${habits.length} habits to all screens');
        AppLogger.info(
            '📱 Timeline, All Habits, Stats screens will auto-refresh now!');
        controller.add(habits);
      },
      onError: (error) {
        AppLogger.error('Error in Isar habits stream: $error');
        controller.addError(error);
      },
    );

    ref.onDispose(() {
      AppLogger.info('🔄 habitsStreamIsarProvider: Disposing subscription');
      subscription.cancel();
    });

    await controller.done;
  });
});

// Stream provider for watching individual habits by ID
// Use this for edit screens, detail views, etc. to get real-time updates for a specific habit
final habitByIdProvider = StreamProvider.autoDispose.family<Habit?, String>(
  (ref, habitId) {
    return Stream<Habit?>.multi((controller) async {
      final habitService = await ref.watch(habitServiceIsarProvider.future);

      // Emit initial data
      final initialHabit = await habitService.getHabitById(habitId);
      controller.add(initialHabit);
      AppLogger.info(
          '🔄 habitByIdProvider: Emitted initial habit (${initialHabit?.name ?? "not found"})');

      // Listen to Isar's watch stream for real-time updates
      final subscription = habitService.watchHabit(habitId).listen(
        (habit) {
          AppLogger.info(
              '🔔 Isar: Habit ${habit?.name ?? "deleted"} updated, emitting to watchers');
          controller.add(habit);
        },
        onError: (error) {
          AppLogger.error('Error in Isar habit watch stream: $error');
          controller.addError(error);
        },
      );

      ref.onDispose(() {
        subscription.cancel();
      });

      await controller.done;
    });
  },
);

class IsarDatabaseService {
  static Isar? _isar;

  /// Get Isar instance (singleton pattern)
  static Future<Isar> getInstance() async {
    if (_isar != null && _isar!.isOpen) {
      return _isar!;
    }

    final dir = await getApplicationDocumentsDirectory();

    _isar = await Isar.open(
      [HabitSchema, ArchivedHabitSchema, ScheduledNotificationSchema],
      directory: dir.path,
      name: 'habitv8_db',
      inspector: true, // Enable Isar Inspector for debugging
    );

    AppLogger.info('✅ Isar database initialized at: ${dir.path}');
    return _isar!;
  }

  /// Close Isar instance
  static Future<void> closeDatabase() async {
    if (_isar != null && _isar!.isOpen) {
      await _isar!.close();
      _isar = null;
      AppLogger.info('✅ Isar database closed');
    }
  }

  /// Reset database (delete all data)
  static Future<void> resetDatabase() async {
    if (_isar != null && _isar!.isOpen) {
      await _isar!.writeTxn(() async {
        await _isar!.clear();
      });
      AppLogger.info('✅ Isar database reset completed');
    }
  }
}

class HabitServiceIsar {
  final Isar _isar;

  HabitServiceIsar(this._isar);

  /// Get all habits
  Future<List<Habit>> getAllHabits() async {
    return await _isar.habits.where().findAll();
  }

  /// Get active habits only
  Future<List<Habit>> getActiveHabits() async {
    return await _isar.habits.filter().isActiveEqualTo(true).findAll();
  }

  /// Get habit by ID
  Future<Habit?> getHabitById(String habitId) async {
    return await _isar.habits.filter().idEqualTo(habitId).findFirst();
  }

  /// Add new habit
  Future<void> addHabit(Habit habit) async {
    await _isar.writeTxn(() async {
      await _isar.habits.put(habit);
    });
    AppLogger.info('✅ Habit added: ${habit.name}');
    AppLogger.info('   Notification time: ${habit.notificationTime}');
    AppLogger.info('   Notification time isUtc: ${habit.notificationTime?.isUtc}');
    AppLogger.info('   Notification time hour: ${habit.notificationTime?.hour}');
    AppLogger.info('   Notification time minute: ${habit.notificationTime?.minute}');
    AppLogger.info('   Alarm enabled: ${habit.alarmEnabled}');
    AppLogger.info('   RRule: ${habit.rruleString}');
    AppLogger.info('   dtStart: ${habit.dtStart}');

    // Schedule notifications and alarms for the new habit
    try {
      if (habit.notificationsEnabled || habit.alarmEnabled) {
        // Re-read the habit from database to see if Isar changed it
        final savedHabit = await getHabitById(habit.id);
        if (savedHabit != null) {
          AppLogger.info('   After Isar save - Notification time: ${savedHabit.notificationTime}');
          AppLogger.info('   After Isar save - isUtc: ${savedHabit.notificationTime?.isUtc}');
          AppLogger.info('   After Isar save - hour: ${savedHabit.notificationTime?.hour}');
          AppLogger.info('   After Isar save - minute: ${savedHabit.notificationTime?.minute}');
        }
        await NotificationService.scheduleHabitNotifications(habit,
            isNewHabit: true);
        AppLogger.info('✅ Notifications/alarms scheduled for: ${habit.name}');
      }
    } catch (e) {
      AppLogger.error(
          '❌ Error scheduling notifications/alarms for ${habit.name}', e);
    }
  }

  /// Update existing habit
  Future<void> updateHabit(Habit habit) async {
    await _isar.writeTxn(() async {
      await _isar.habits.put(habit);
    });
    AppLogger.info('✅ Habit updated: ${habit.name}');

    // Reschedule notifications and alarms for the updated habit
    try {
      // Cancel and reschedule (NotificationService handles both notifications and alarms)
      if (habit.notificationsEnabled || habit.alarmEnabled) {
        await NotificationService.scheduleHabitNotifications(habit);
        AppLogger.info('✅ Notifications/alarms rescheduled for: ${habit.name}');
      } else {
        // If both disabled, just cancel
        await NotificationService.cancelHabitNotificationsByHabitId(habit.id);
        AppLogger.info('✅ Notifications/alarms cancelled for: ${habit.name}');
      }
    } catch (e) {
      AppLogger.error(
          '❌ Error rescheduling notifications/alarms for ${habit.name}', e);
    }
  }

  /// Delete habit with optional archival of completion data
  /// If [archiveCompletions] is true, completion history is preserved in ArchivedHabit collection
  Future<void> deleteHabit(String habitId,
      {bool archiveCompletions = false}) async {
    String? habitName;
    await _isar.writeTxn(() async {
      final habit = await _isar.habits.filter().idEqualTo(habitId).findFirst();

      if (habit != null) {
        habitName = habit.name;

        // Archive completion data if requested
        if (archiveCompletions && habit.completions.isNotEmpty) {
          final archivedHabit = ArchivedHabit.fromHabit(
            id: habit.id,
            name: habit.name,
            description: habit.description,
            category: habit.category,
            colorValue: habit.colorValue,
            createdAt: habit.createdAt,
            completions: habit.completions,
            currentStreak: habit.currentStreak,
            longestStreak: habit.longestStreak,
            rruleString: habit.rruleString,
            dtStart: habit.dtStart,
            usedRRule: habit.usesRRule,
          );

          await _isar.archivedHabits.put(archivedHabit);
          AppLogger.info(
              '📦 Archived completion data for: ${habit.name} (${habit.completions.length} completions)');
        }

        await _isar.habits.delete(habit.isarId);
        AppLogger.info('✅ Habit deleted: ${habit.name}');
      }
    });

    // Cancel notifications and alarms for the deleted habit
    if (habitName != null) {
      try {
        await NotificationService.cancelHabitNotificationsByHabitId(habitId);
        AppLogger.info('✅ Notifications/alarms cancelled for: $habitName');
      } catch (e) {
        AppLogger.error(
            '❌ Error cancelling notifications/alarms for $habitName', e);
      }
    }
  }

  /// Mark habit as complete
  Future<void> completeHabit(String habitId, DateTime completionTime) async {
    await _isar.writeTxn(() async {
      final habit = await _isar.habits.filter().idEqualTo(habitId).findFirst();

      if (habit != null) {
        // Add completion
        habit.completions.add(completionTime);

        // Update streak (same logic as notification handler)
        habit.currentStreak = _calculateStreak(habit.completions);
        if (habit.currentStreak > habit.longestStreak) {
          habit.longestStreak = habit.currentStreak;
        }

        await _isar.habits.put(habit);
        AppLogger.info(
            '✅ Habit completed: ${habit.name} (Streak: ${habit.currentStreak})');
      }
    });
  }

  /// Uncomplete habit (remove completion)
  Future<void> uncompleteHabit(String habitId, DateTime completionTime) async {
    await _isar.writeTxn(() async {
      final habit = await _isar.habits.filter().idEqualTo(habitId).findFirst();

      if (habit != null) {
        habit.completions.removeWhere((completion) {
          final completionDay = DateTime(
            completion.year,
            completion.month,
            completion.day,
          );
          final targetDay = DateTime(
            completionTime.year,
            completionTime.month,
            completionTime.day,
          );
          return completionDay.isAtSameMomentAs(targetDay);
        });

        // Recalculate streak after removing completion
        habit.currentStreak = _calculateStreak(habit.completions);

        await _isar.habits.put(habit);
        AppLogger.info(
            '✅ Habit uncompleted: ${habit.name} (Streak: ${habit.currentStreak})');
      }
    });
  }

  /// Watch all habits (reactive stream)
  Stream<List<Habit>> watchAllHabits() {
    return _isar.habits.where().watch(fireImmediately: true);
  }

  /// Watch specific habit (reactive stream)
  Stream<Habit?> watchHabit(String habitId) {
    return _isar.habits
        .filter()
        .idEqualTo(habitId)
        .watch(fireImmediately: true)
        .map((habits) => habits.isNotEmpty ? habits.first : null);
  }

  /// Watch for ANY habit changes (lazy - no data transfer)
  /// RECOMMENDED for notification triggers and widget updates
  ///
  /// Emits void event whenever any habit is added, updated, or deleted
  /// This is more efficient than watchAllHabits() because:
  /// - No data transfer (just a signal that something changed)
  /// - Lower memory usage
  /// - Faster event delivery
  /// - You can fetch fresh data when needed instead of receiving it in every event
  ///
  /// Use this when you need to know THAT something changed, not WHAT changed
  /// CRITICAL: fireImmediately: true ensures widgets update on app start
  Stream<void> watchHabitsLazy() {
    return _isar.habits.where().watchLazy(fireImmediately: true);
  }

  /// Watch for active habits changes (lazy)
  /// Emits void event whenever active habits change
  /// CRITICAL: fireImmediately: true ensures immediate updates
  Stream<void> watchActiveHabitsLazy() {
    return _isar.habits
        .filter()
        .isActiveEqualTo(true)
        .watchLazy(fireImmediately: true);
  }

  /// Get habits by category
  Future<List<Habit>> getHabitsByCategory(String category) async {
    return await _isar.habits.filter().categoryEqualTo(category).findAll();
  }

  /// Search habits by name
  Future<List<Habit>> searchHabits(String query) async {
    return await _isar.habits
        .filter()
        .nameContains(query, caseSensitive: false)
        .findAll();
  }

  /// Bulk update habits
  Future<void> updateHabits(List<Habit> habits) async {
    await _isar.writeTxn(() async {
      await _isar.habits.putAll(habits);
    });
    AppLogger.info('✅ Bulk update: ${habits.length} habits updated');
  }

  /// Mark habit as complete (alias for completeHabit)
  Future<void> markHabitComplete(
      String habitId, DateTime completionTime) async {
    await completeHabit(habitId, completionTime);
  }

  /// Remove habit completion (alias for uncompleteHabit)
  Future<void> removeHabitCompletion(
      String habitId, DateTime completionTime) async {
    await uncompleteHabit(habitId, completionTime);
  }

  /// Check if habit is completed for current period
  bool isHabitCompletedForCurrentPeriod(Habit habit) {
    return habit.isCompletedForCurrentPeriod;
  }

  /// Calculate current streak from completions
  /// Same logic as notification handler to ensure consistency
  int _calculateStreak(List<DateTime> completions) {
    if (completions.isEmpty) return 0;

    // Sort completions in descending order
    final sorted = List<DateTime>.from(completions)
      ..sort((a, b) => b.compareTo(a));

    int streak = 0;
    final today = DateTime.now();
    DateTime checkDate = DateTime(today.year, today.month, today.day);

    for (final completion in sorted) {
      final completionDate = DateTime(
        completion.year,
        completion.month,
        completion.day,
      );

      if (completionDate.isAtSameMomentAs(checkDate)) {
        streak++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      } else if (completionDate.isBefore(checkDate)) {
        break;
      }
    }

    return streak;
  }

  /// Get all archived habits
  Future<List<ArchivedHabit>> getAllArchivedHabits() async {
    return await _isar.archivedHabits.where().findAll();
  }

  /// Get archived habit by original ID
  Future<ArchivedHabit?> getArchivedHabitById(String habitId) async {
    return await _isar.archivedHabits.filter().idEqualTo(habitId).findFirst();
  }

  /// Delete archived habit
  Future<void> deleteArchivedHabit(String habitId) async {
    await _isar.writeTxn(() async {
      final archived =
          await _isar.archivedHabits.filter().idEqualTo(habitId).findFirst();
      if (archived != null) {
        await _isar.archivedHabits.delete(archived.isarId);
        AppLogger.info('✅ Archived habit deleted: ${archived.name}');
      }
    });
  }

  /// Add archived habit (for import operations)
  Future<void> addArchivedHabit(ArchivedHabit archivedHabit) async {
    await _isar.writeTxn(() async {
      await _isar.archivedHabits.put(archivedHabit);
      AppLogger.info('✅ Archived habit added: ${archivedHabit.name}');
    });
  }
}

/// Simple IsarDatabase class for background isolates
/// This provides a clean API for accessing Isar in background contexts
class IsarDatabase {
  /// Get Isar instance (delegates to IsarDatabaseService)
  static Future<Isar> get instance => IsarDatabaseService.getInstance();
}
