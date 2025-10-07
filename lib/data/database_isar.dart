import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../domain/model/habit.dart';
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
final habitsStreamIsarProvider = StreamProvider.autoDispose<List<Habit>>((ref) {
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
      [HabitSchema],
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

    // Schedule notifications and alarms for the new habit
    try {
      if (habit.notificationsEnabled || habit.alarmEnabled) {
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

  /// Delete habit
  Future<void> deleteHabit(String habitId) async {
    String? habitName;
    await _isar.writeTxn(() async {
      final habit = await _isar.habits.filter().idEqualTo(habitId).findFirst();

      if (habit != null) {
        habitName = habit.name;
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
        habit.completions.add(completionTime);
        await _isar.habits.put(habit);
        AppLogger.info('✅ Habit completed: ${habit.name}');
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
        await _isar.habits.put(habit);
        AppLogger.info('✅ Habit uncompleted: ${habit.name}');
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
  /// Use this for notification triggers and widget updates
  /// Emits void event whenever any habit is added, updated, or deleted
  Stream<void> watchHabitsLazy() {
    return _isar.habits.where().watchLazy(fireImmediately: false);
  }

  /// Watch for active habits changes (lazy)
  /// Emits void event whenever active habits change
  Stream<void> watchActiveHabitsLazy() {
    return _isar.habits
        .filter()
        .isActiveEqualTo(true)
        .watchLazy(fireImmediately: false);
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
}
