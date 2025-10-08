// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scheduled_notification.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ScheduledNotificationAdapter extends TypeAdapter<ScheduledNotification> {
  @override
  final int typeId = 3;

  @override
  ScheduledNotification read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ScheduledNotification(
      id: fields[0] as int,
      habitId: fields[1] as String,
      title: fields[2] as String,
      body: fields[3] as String,
      scheduledTimeMillis: fields[4] as int,
      createdAtMillis: fields[5] as int,
      isAlarm: fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ScheduledNotification obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.habitId)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.body)
      ..writeByte(4)
      ..write(obj.scheduledTimeMillis)
      ..writeByte(5)
      ..write(obj.createdAtMillis)
      ..writeByte(6)
      ..write(obj.isAlarm);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScheduledNotificationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
