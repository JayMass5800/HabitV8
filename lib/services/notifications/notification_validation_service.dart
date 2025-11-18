import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';

import '../logging_service.dart';
import '../../domain/model/habit.dart';

class NotificationAuditResult {
  NotificationAuditResult({
    required this.habitId,
    required this.notificationCount,
    required this.alarmCount,
    required this.notificationIds,
    required this.alarmIds,
  });

  final String habitId;
  final int notificationCount;
  final int alarmCount;
  final List<int> notificationIds;
  final List<int> alarmIds;

  bool get hasNotifications => notificationCount > 0;
  bool get hasAlarms => alarmCount > 0;
  bool get hasAny => hasNotifications || hasAlarms;

  @override
  String toString() {
    return 'NotificationAuditResult(habitId: $habitId, notifications: '
        '$notificationCount, alarms: $alarmCount, notificationIds: '
        '$notificationIds, alarmIds: $alarmIds)';
  }
}

class NotificationValidationService {
  NotificationValidationService._();

  static Future<List<NotificationModel>> fetchScheduledNotifications() {
    return AwesomeNotifications().listScheduledNotifications();
  }

  static NotificationAuditResult auditHabitFromSnapshot(
    Habit habit,
    Iterable<NotificationModel> scheduledNotifications,
  ) {
    int notifications = 0;
    int alarms = 0;
    final notificationIds = <int>[];
    final alarmIds = <int>[];

    for (final model in scheduledNotifications) {
      if (!_belongsToHabit(model, habit.id)) {
        continue;
      }

      final channelKey = model.content?.channelKey ?? '';
      final id = model.content?.id;

      if (channelKey.startsWith('habit_alarm')) {
        alarms++;
        if (id != null) {
          alarmIds.add(id);
        }
      } else {
        notifications++;
        if (id != null) {
          notificationIds.add(id);
        }
      }
    }

    return NotificationAuditResult(
      habitId: habit.id,
      notificationCount: notifications,
      alarmCount: alarms,
      notificationIds: notificationIds,
      alarmIds: alarmIds,
    );
  }

  static Future<NotificationAuditResult> auditHabit(Habit habit) async {
    AppLogger.debug('Running notification audit for habit: ${habit.name}');
    final snapshot = await fetchScheduledNotifications();
    return auditHabitFromSnapshot(habit, snapshot);
  }

  static Future<Map<String, NotificationAuditResult>> auditHabits(
    Iterable<Habit> habits,
  ) async {
    final habitList = habits.toList();
    if (habitList.isEmpty) {
      return {};
    }

    final snapshot = await fetchScheduledNotifications();
    final results = <String, NotificationAuditResult>{};

    for (final habit in habitList) {
      results[habit.id] = auditHabitFromSnapshot(habit, snapshot);
    }

    return results;
  }

  static void logAuditDiscrepancies({
    required Iterable<Habit> habits,
    required Map<String, NotificationAuditResult> results,
    String context = 'notification_audit',
  }) {
    final habitList = habits.toList();
    int missingNotifications = 0;
    int missingAlarms = 0;

    for (final habit in habitList) {
      final audit = results[habit.id];
      if (audit == null) {
        AppLogger.warning(
          '[$context] No audit result for habit ${habit.id}',
        );
        continue;
      }

      if (habit.notificationsEnabled && !audit.hasNotifications) {
        missingNotifications++;
        AppLogger.warning(
          '[$context] Habit ${habit.name} (${habit.id}) expects notifications '
          'but none are scheduled.',
        );
      }

      if (habit.alarmEnabled && !audit.hasAlarms) {
        missingAlarms++;
        AppLogger.warning(
          '[$context] Habit ${habit.name} (${habit.id}) expects alarms but '
          'none are scheduled.',
        );
      }
    }

    AppLogger.info(
      '[$context] Notification audit inspected ${habitList.length} habits. '
      'Missing notifications: $missingNotifications, '
      'missing alarms: $missingAlarms',
    );
  }

  static String? extractHabitId(NotificationModel notification) {
    final rawPayload = notification.content?.payload?['data'];
    if (rawPayload == null) {
      return null;
    }

    final payload = rawPayload.toString();

    try {
      final data = jsonDecode(payload);
      if (data is Map<String, dynamic>) {
        final habitId = data['habitId'];
        if (habitId is String) {
          return habitId;
        }
      }
    } catch (e) {
      if (payload.contains('habitId')) {
        AppLogger.warning(
          'Failed to decode payload as JSON but contains habitId. '
          'Payload: $payload',
        );
      } else {
        AppLogger.debug('Payload not JSON for notification: $payload');
      }
    }

    return payload.isEmpty ? null : payload;
  }

  static bool _belongsToHabit(NotificationModel model, String habitId) {
    final extractedHabitId = extractHabitId(model);
    if (extractedHabitId == null) {
      return false;
    }

    if (extractedHabitId == habitId) {
      return true;
    }

    if (extractedHabitId.startsWith('$habitId|')) {
      return true;
    }

    return false;
  }
}
