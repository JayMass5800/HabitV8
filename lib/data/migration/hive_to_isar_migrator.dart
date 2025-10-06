import 'package:hive/hive.dart';
import 'package:isar/isar.dart';
import '../../domain/model/habit.dart' as hive_model;
import '../../domain/model/habit_isar.dart' as isar_model;
import '../../services/logging_service.dart';

class HiveToIsarMigrator {
  /// Migrate all habits from Hive to Isar
  static Future<MigrationResult> migrateAllHabits(
    Box<hive_model.Habit> hiveBox,
    Isar isar,
  ) async {
    try {
      AppLogger.info('🔄 Starting Hive to Isar migration...');
      
      final hiveHabits = hiveBox.values.toList();
      AppLogger.info('📊 Found ${hiveHabits.length} habits in Hive database');
      
      final isarHabits = <isar_model.Habit>[];
      
      for (final hiveHabit in hiveHabits) {
        try {
          isarHabits.add(_convertHabitToIsar(hiveHabit));
        } catch (e) {
          AppLogger.error('Failed to convert habit ${hiveHabit.id}', e);
          return MigrationResult(
            success: false,
            hiveCount: hiveHabits.length,
            isarCount: 0,
            errorMessage: 'Failed to convert habit ${hiveHabit.name}: $e',
          );
        }
      }
      
      await isar.writeTxn(() async {
        await isar.habits.putAll(isarHabits);
      });
      
      final isarCount = await isar.habits.count();
      AppLogger.info('✅ Migration completed: $isarCount habits migrated');
      
      return MigrationResult(
        success: true,
        hiveCount: hiveHabits.length,
        isarCount: isarCount,
      );
    } catch (e) {
      AppLogger.error('Migration failed', e);
      return MigrationResult(
        success: false,
        hiveCount: 0,
        isarCount: 0,
        errorMessage: e.toString(),
      );
    }
  }
  
  /// Convert single Hive habit to Isar habit
  static isar_model.Habit _convertHabitToIsar(hive_model.Habit hiveHabit) {
    return isar_model.Habit()
      ..habitId = hiveHabit.id
      ..name = hiveHabit.name
      ..description = hiveHabit.description
      ..category = hiveHabit.category
      ..colorValue = hiveHabit.colorValue
      ..createdAt = hiveHabit.createdAt
      ..nextDueDate = hiveHabit.nextDueDate
      ..frequency = _convertFrequency(hiveHabit.frequency)
      ..targetCount = hiveHabit.targetCount
      ..completions = List.from(hiveHabit.completions)
      ..currentStreak = hiveHabit.currentStreak
      ..longestStreak = hiveHabit.longestStreak
      ..isActive = hiveHabit.isActive
      ..notificationsEnabled = hiveHabit.notificationsEnabled
      ..notificationTime = hiveHabit.notificationTime
      ..weeklySchedule = List.from(hiveHabit.weeklySchedule)
      ..monthlySchedule = List.from(hiveHabit.monthlySchedule)
      ..reminderTime = hiveHabit.reminderTime
      ..difficulty = _convertDifficulty(hiveHabit.difficulty)
      ..selectedWeekdays = List.from(hiveHabit.selectedWeekdays)
      ..selectedMonthDays = List.from(hiveHabit.selectedMonthDays)
      ..hourlyTimes = List.from(hiveHabit.hourlyTimes)
      ..selectedYearlyDates = List.from(hiveHabit.selectedYearlyDates)
      ..singleDateTime = hiveHabit.singleDateTime
      ..alarmEnabled = hiveHabit.alarmEnabled
      ..alarmSoundName = hiveHabit.alarmSoundName
      ..alarmSoundUri = hiveHabit.alarmSoundUri
      ..snoozeDelayMinutes = hiveHabit.snoozeDelayMinutes
      ..rruleString = hiveHabit.rruleString
      ..dtStart = hiveHabit.dtStart
      ..usesRRule = hiveHabit.usesRRule;
  }
  
  static isar_model.HabitFrequency _convertFrequency(
    hive_model.HabitFrequency freq,
  ) {
    return isar_model.HabitFrequency.values.firstWhere(
      (e) => e.name == freq.name,
    );
  }
  
  static isar_model.HabitDifficulty _convertDifficulty(
    hive_model.HabitDifficulty diff,
  ) {
    return isar_model.HabitDifficulty.values.firstWhere(
      (e) => e.name == diff.name,
    );
  }
}

class MigrationResult {
  final bool success;
  final int hiveCount;
  final int isarCount;
  final String? errorMessage;
  
  MigrationResult({
    required this.success,
    required this.hiveCount,
    required this.isarCount,
    this.errorMessage,
  });
  
  bool get isValid => success && hiveCount == isarCount;
  
  @override
  String toString() {
    if (success) {
      return 'Migration successful: $hiveCount habits → $isarCount habits';
    } else {
      return 'Migration failed: $errorMessage';
    }
  }
}
