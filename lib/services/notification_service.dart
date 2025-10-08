import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../domain/model/habit.dart';
import '../data/database_isar.dart';
import 'notifications/notification_core.dart';
import 'notifications/notification_helpers.dart';
import 'notifications/notification_scheduler.dart';
import 'notifications/notification_alarm_scheduler.dart';
import 'notifications/notification_action_handler.dart';
import 'notifications/notification_boot_rescheduler.dart';

/// Notification Service Facade - delegates to specialized modules
class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static late final NotificationScheduler _scheduler;
  static late final NotificationAlarmScheduler _alarmScheduler;
  static late final NotificationBootRescheduler _bootRescheduler;

  static Future<void> initialize() async {
    await NotificationCore.initialize(
      plugin: _notificationsPlugin,
      onForegroundTap: onNotificationTappedIsar,
      onBackgroundTap: onBackgroundNotificationResponseIsar,
    );
    _scheduler = NotificationScheduler(_notificationsPlugin);
    _alarmScheduler = NotificationAlarmScheduler.instance;
    _bootRescheduler = NotificationBootRescheduler(_notificationsPlugin);
  }

  static Future<void> recreateNotificationChannels() async {
    await NotificationCore.recreateNotificationChannels(_notificationsPlugin);
  }

  static Future<bool> isAndroid12Plus() async {
    return await NotificationCore.isAndroid12Plus();
  }

  static void setNotificationActionCallback(
      void Function(String habitId, String action) callback) {
    NotificationActionHandlerIsar.registerActionCallback(callback);
  }

  static void setDirectCompletionHandler(
      Future<void> Function(String habitId) handler) {
    NotificationActionHandlerIsar.setDirectCompletionHandler(handler);
  }

  /// Get the current notification action callback
  static void Function(String habitId, String action)?
      get onNotificationAction {
    return NotificationActionHandlerIsar.onNotificationAction;
  }

  /// Get the number of pending actions (for debugging)
  static Future<int> getPendingActionsCount() async {
    return await NotificationActionHandlerIsar.getPendingActionsCount();
  }

  static Future<void> scheduleHabitNotifications(Habit habit,
      {bool isNewHabit = false}) async {
    await cancelHabitNotificationsByHabitId(habit.id);
    await _scheduler.scheduleHabitNotifications(habit, isNewHabit: isNewHabit);
    await _alarmScheduler.scheduleHabitAlarms(habit);
  }

  static Future<void> scheduleHabitNotificationsOnly(Habit habit) async {
    await cancelHabitNotificationsByHabitId(habit.id);
    await _scheduler.scheduleHabitNotifications(habit);
  }

  static Future<void> scheduleHabitAlarms(Habit habit) async {
    await _alarmScheduler.scheduleHabitAlarms(habit);
  }

  static Future<void> scheduleHabitNotification({
    required int id,
    required String habitId,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    await _scheduler.scheduleHabitNotification(
      id: id,
      habitId: habitId,
      title: title,
      body: body,
      scheduledTime: scheduledTime,
    );
  }

  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? payload,
  }) async {
    await _scheduler.scheduleHabitNotification(
      id: id,
      habitId: id.toString(),
      title: title,
      body: body,
      scheduledTime: scheduledTime,
    );
  }

  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    await _scheduler.showNotification(
      id: id,
      title: title,
      body: body,
      payload: payload,
    );
  }

  static Future<void> showHabitNotification({
    required int id,
    required String habitId,
    required String title,
    required String body,
  }) async {
    await _scheduler.showNotification(
      id: id,
      title: title,
      body: body,
      payload: '{"habitId":"$habitId"}',
    );
  }

  static Future<void> showTestNotification() async {
    await showNotification(
      id: DateTime.now().millisecondsSinceEpoch,
      title: 'Test Notification',
      body: 'If you see this, notifications are working!',
    );
  }

  /// Test scheduled notification - schedules a notification for 10 seconds in the future
  static Future<void> testScheduledNotification() async {
    final scheduledTime = DateTime.now().add(const Duration(seconds: 10));
    await scheduleNotification(
      id: DateTime.now().millisecondsSinceEpoch,
      title: 'Scheduled Test Notification',
      body: 'This notification was scheduled 10 seconds ago!',
      scheduledTime: scheduledTime,
    );
  }

  static Future<void> cancelNotification(int id) async {
    await _scheduler.cancelNotification(id);
  }

  static Future<void> cancelAllNotifications() async {
    await _scheduler.cancelAllNotifications();
  }

  static Future<void> cancelHabitNotifications(int habitId) async {
    await _scheduler.cancelNotification(habitId);
  }

  static Future<void> cancelHabitNotificationsByHabitId(String habitId) async {
    await _scheduler.cancelHabitNotificationsByHabitId(habitId);
  }

  static Future<void> processPendingActionsManually() async {
    try {
      final isar = await IsarDatabaseService.getInstance();
      await NotificationActionHandlerIsar.processPendingActionsManually(isar);
    } catch (e) {
      // Error logging handled in NotificationActionHandlerIsar
    }
  }

  static Future<bool> areNotificationsEnabled() async {
    final result = await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.areNotificationsEnabled();
    return result ?? true;
  }

  static Future<bool> canScheduleExactAlarms() async {
    return await NotificationHelpers.canScheduleExactAlarms();
  }

  static Future<void> checkBatteryOptimizationStatus() async {
    await NotificationHelpers.checkBatteryOptimizationStatus();
  }

  static Future<List<PendingNotificationRequest>>
      getPendingNotifications() async {
    return await NotificationHelpers.getPendingNotifications(
        _notificationsPlugin);
  }

  static int generateSafeId(String habitId) {
    return NotificationHelpers.generateSafeId(habitId);
  }

  static Future<bool> verifyNotificationScheduled(
    int notificationId,
    String habitId,
  ) async {
    return await NotificationHelpers.verifyNotificationScheduled(
      _notificationsPlugin,
      notificationId,
      habitId,
    );
  }

  static Future<bool> isHabitCompletedForPeriod(
    Habit habit,
    DateTime checkTime,
  ) async {
    return NotificationHelpers.isHabitCompletedForPeriod(
      habit,
      checkTime,
    );
  }

  static int calculateStreak(
      List<DateTime> completions, HabitFrequency frequency) {
    return NotificationHelpers.calculateStreak(completions, frequency);
  }

  static Future<void> handleSnoozeActionWithName(
    String habitId,
    String habitName,
  ) async {
    // Isar version uses different params: handleSnoozeAction(habitId, snoozeMinutes)
    // Default to 10 minutes snooze
    await NotificationActionHandlerIsar.handleSnoozeAction(
      habitId,
      10, // Default snooze duration in minutes
    );
  }

  static Future<void> scheduleDailyNotification({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    final now = DateTime.now();
    var scheduledTime = DateTime(now.year, now.month, now.day, hour, minute);
    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }
    await _scheduler.scheduleHabitNotification(
      id: id,
      habitId: id.toString(),
      title: title,
      body: body,
      scheduledTime: scheduledTime,
    );
  }

  static Future<void> scheduleDailyHabitReminder({
    required String habitId,
    required String habitName,
    required int hour,
    required int minute,
  }) async {
    final id = generateSafeId(habitId);
    await scheduleDailyNotification(
      id: id,
      title: 'Habit Reminder',
      body: 'Do not forget to complete: $habitName',
      hour: hour,
      minute: minute,
    );
  }

  /// Reschedule all notifications after device reboot
  ///
  /// This method loads persisted notification data and reschedules
  /// all pending notifications that were lost during reboot.
  static Future<void> rescheduleNotificationsAfterBoot() async {
    await _bootRescheduler.rescheduleAllNotifications();
  }

  /// Get statistics about stored notifications
  ///
  /// Returns a map with keys: total, pending, expired, alarms, regular
  static Future<Map<String, int>> getNotificationStats() async {
    return await _bootRescheduler.getNotificationStats();
  }

  /// Clean up old notification records from storage
  /// Note: With Isar migration, notification scheduling is based on habit data
  /// This method is deprecated and will be removed in a future version
  static Future<void> cleanupOldNotificationRecords() async {
    // No-op: Notification data is now managed through Isar habit records
    // Old Hive-based ScheduledNotificationStorage has been removed
  }
}
