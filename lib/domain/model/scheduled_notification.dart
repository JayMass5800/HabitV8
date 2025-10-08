import 'package:hive/hive.dart';

part 'scheduled_notification.g.dart';

/// Model for storing scheduled notification data persistently
/// This allows us to reschedule notifications after device reboot
@HiveType(
    typeId: 3) // typeId 0-2 reserved for Habit models, 3 is next available
class ScheduledNotification extends HiveObject {
  /// Unique notification ID
  @HiveField(0)
  final int id;

  /// Associated habit ID
  @HiveField(1)
  final String habitId;

  /// Notification title
  @HiveField(2)
  final String title;

  /// Notification body
  @HiveField(3)
  final String body;

  /// Scheduled date/time (stored as milliseconds since epoch)
  @HiveField(4)
  final int scheduledTimeMillis;

  /// When this notification record was created (for cleanup)
  @HiveField(5)
  final int createdAtMillis;

  /// Whether this is an alarm notification (vs regular notification)
  @HiveField(6)
  final bool isAlarm;

  ScheduledNotification({
    required this.id,
    required this.habitId,
    required this.title,
    required this.body,
    required this.scheduledTimeMillis,
    required this.createdAtMillis,
    this.isAlarm = false,
  });

  /// Get the scheduled time as DateTime
  DateTime get scheduledTime =>
      DateTime.fromMillisecondsSinceEpoch(scheduledTimeMillis);

  /// Get the created time as DateTime
  DateTime get createdAt =>
      DateTime.fromMillisecondsSinceEpoch(createdAtMillis);

  /// Check if this notification is still in the future
  bool get isFuture => scheduledTime.isAfter(DateTime.now());

  /// Check if this notification is in the past (and should be cleaned up)
  bool get isPast => scheduledTime.isBefore(DateTime.now());

  /// Create a copy with updated fields
  ScheduledNotification copyWith({
    int? id,
    String? habitId,
    String? title,
    String? body,
    int? scheduledTimeMillis,
    int? createdAtMillis,
    bool? isAlarm,
  }) {
    return ScheduledNotification(
      id: id ?? this.id,
      habitId: habitId ?? this.habitId,
      title: title ?? this.title,
      body: body ?? this.body,
      scheduledTimeMillis: scheduledTimeMillis ?? this.scheduledTimeMillis,
      createdAtMillis: createdAtMillis ?? this.createdAtMillis,
      isAlarm: isAlarm ?? this.isAlarm,
    );
  }

  @override
  String toString() {
    return 'ScheduledNotification(id: $id, habitId: $habitId, scheduledTime: $scheduledTime, isAlarm: $isAlarm)';
  }
}
