import 'package:isar/isar.dart';

part 'scheduled_notification.g.dart';

/// Model for storing scheduled notification data persistently
/// This allows us to reschedule notifications after device reboot
@collection
class ScheduledNotification {
  /// Unique notification ID (used as Isar ID)
  Id id = Isar.autoIncrement;

  /// Notification ID used by the notification system
  late int notificationId;

  /// Associated habit ID
  @Index()
  late String habitId;

  /// Notification title
  late String title;

  /// Notification body
  late String body;

  /// Scheduled date/time (stored as milliseconds since epoch)
  @Index()
  late int scheduledTimeMillis;

  /// When this notification record was created (for cleanup)
  late int createdAtMillis;

  /// Whether this is an alarm notification (vs regular notification)
  late bool isAlarm;

  ScheduledNotification({
    this.id = Isar.autoIncrement,
    required this.notificationId,
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
    Id? id,
    int? notificationId,
    String? habitId,
    String? title,
    String? body,
    int? scheduledTimeMillis,
    int? createdAtMillis,
    bool? isAlarm,
  }) {
    return ScheduledNotification(
      id: id ?? this.id,
      notificationId: notificationId ?? this.notificationId,
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
    return 'ScheduledNotification(id: $id, notificationId: $notificationId, habitId: $habitId, scheduledTime: $scheduledTime, isAlarm: $isAlarm)';
  }
}
