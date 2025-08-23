// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HabitAdapter extends TypeAdapter<Habit> {
  @override
  final int typeId = 0;

  @override
  Habit read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Habit()
      ..id = fields[0] as String
      ..name = fields[1] as String
      ..description = fields[2] as String?
      ..category = fields[3] as String
      ..colorValue = fields[4] as int
      ..createdAt = fields[5] as DateTime
      ..nextDueDate = fields[6] as DateTime?
      ..frequency = fields[7] as HabitFrequency
      ..targetCount = fields[8] as int
      ..completions = (fields[9] as List).cast<DateTime>()
      ..currentStreak = fields[10] as int
      ..longestStreak = fields[11] as int
      ..isActive = fields[12] as bool
      ..notificationsEnabled = fields[13] as bool
      ..notificationTime = fields[14] as DateTime?
      ..weeklySchedule = (fields[15] as List).cast<int>()
      ..monthlySchedule = (fields[16] as List).cast<int>()
      ..reminderTime = fields[17] as DateTime?
      ..difficulty = fields[18] as HabitDifficulty
      ..selectedWeekdays = (fields[19] as List).cast<int>()
      ..selectedMonthDays = (fields[20] as List).cast<int>()
      ..hourlyTimes = (fields[21] as List).cast<String>()
      ..selectedYearlyDates = (fields[22] as List).cast<String>()
      ..alarmEnabled = fields[23] as bool
      ..alarmSoundName = fields[24] as String?
      ..snoozeDelayMinutes = fields[25] as int;
  }

  @override
  void write(BinaryWriter writer, Habit obj) {
    writer
      ..writeByte(26)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.colorValue)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.nextDueDate)
      ..writeByte(7)
      ..write(obj.frequency)
      ..writeByte(8)
      ..write(obj.targetCount)
      ..writeByte(9)
      ..write(obj.completions)
      ..writeByte(10)
      ..write(obj.currentStreak)
      ..writeByte(11)
      ..write(obj.longestStreak)
      ..writeByte(12)
      ..write(obj.isActive)
      ..writeByte(13)
      ..write(obj.notificationsEnabled)
      ..writeByte(14)
      ..write(obj.notificationTime)
      ..writeByte(15)
      ..write(obj.weeklySchedule)
      ..writeByte(16)
      ..write(obj.monthlySchedule)
      ..writeByte(17)
      ..write(obj.reminderTime)
      ..writeByte(18)
      ..write(obj.difficulty)
      ..writeByte(19)
      ..write(obj.selectedWeekdays)
      ..writeByte(20)
      ..write(obj.selectedMonthDays)
      ..writeByte(21)
      ..write(obj.hourlyTimes)
      ..writeByte(22)
      ..write(obj.selectedYearlyDates)
      ..writeByte(23)
      ..write(obj.alarmEnabled)
      ..writeByte(24)
      ..write(obj.alarmSoundName)
      ..writeByte(25)
      ..write(obj.snoozeDelayMinutes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HabitAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HabitFrequencyAdapter extends TypeAdapter<HabitFrequency> {
  @override
  final int typeId = 1;

  @override
  HabitFrequency read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return HabitFrequency.hourly;
      case 1:
        return HabitFrequency.daily;
      case 2:
        return HabitFrequency.weekly;
      case 3:
        return HabitFrequency.monthly;
      case 4:
        return HabitFrequency.yearly;
      default:
        return HabitFrequency.hourly;
    }
  }

  @override
  void write(BinaryWriter writer, HabitFrequency obj) {
    switch (obj) {
      case HabitFrequency.hourly:
        writer.writeByte(0);
        break;
      case HabitFrequency.daily:
        writer.writeByte(1);
        break;
      case HabitFrequency.weekly:
        writer.writeByte(2);
        break;
      case HabitFrequency.monthly:
        writer.writeByte(3);
        break;
      case HabitFrequency.yearly:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HabitFrequencyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HabitDifficultyAdapter extends TypeAdapter<HabitDifficulty> {
  @override
  final int typeId = 2;

  @override
  HabitDifficulty read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return HabitDifficulty.easy;
      case 1:
        return HabitDifficulty.medium;
      case 2:
        return HabitDifficulty.hard;
      default:
        return HabitDifficulty.easy;
    }
  }

  @override
  void write(BinaryWriter writer, HabitDifficulty obj) {
    switch (obj) {
      case HabitDifficulty.easy:
        writer.writeByte(0);
        break;
      case HabitDifficulty.medium:
        writer.writeByte(1);
        break;
      case HabitDifficulty.hard:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HabitDifficultyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
