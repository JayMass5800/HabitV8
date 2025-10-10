import 'package:awesome_notifications/awesome_notifications.dart';
import '../domain/model/habit.dart';
import 'logging_service.dart';
import 'notifications/notification_core.dart';
import 'notifications/notification_helpers.dart';
import 'notifications/notification_scheduler.dart';
import 'notifications/notification_alarm_scheduler.dart';
import 'notifications/notification_action_handler.dart';
import 'notifications/notification_boot_rescheduler.dart';

/// Notification Service Facade - delegates to specialized modules
class NotificationService {
  static late final NotificationScheduler _scheduler;
  static late final NotificationAlarmScheduler _alarmScheduler;
  static late final NotificationBootRescheduler _bootRescheduler;

  static Future<void> initialize() async {
    await NotificationCore.initialize(
      onActionReceivedMethod: onNotificationActionIsar,
    );
    _scheduler = NotificationScheduler();
    _alarmScheduler = NotificationAlarmScheduler.instance;
    _bootRescheduler = NotificationBootRescheduler();
  }

  static Future<void> recreateNotificationChannels() async {
    await NotificationCore.recreateNotificationChannels();
  }

  static Future<bool> isAndroid12Plus() async {
    return await NotificationCore.isAndroid12Plus();
  }

  static void setNotificationActionCallback(
      void Function(String habitId, String action) callback) {
    NotificationActionHandlerIsar.onNotificationAction = callback;
  }

  static void setDirectCompletionHandler(
      Future<void> Function(String habitId) handler) {
    NotificationActionHandlerIsar.directCompletionHandler = handler;
  }

  /// Get the current notification action callback
  static void Function(String habitId, String action)?
      get onNotificationAction {
    return NotificationActionHandlerIsar.onNotificationAction;
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

  static Future<bool> areNotificationsEnabled() async {
    return await NotificationCore.areNotificationsEnabled();
  }

  static Future<bool> canScheduleExactAlarms() async {
    return await NotificationHelpers.canScheduleExactAlarms();
  }

  static Future<void> checkBatteryOptimizationStatus() async {
    await NotificationHelpers.checkBatteryOptimizationStatus();
  }

  static Future<List<NotificationModel>> getPendingNotifications() async {
    return await AwesomeNotifications().listScheduledNotifications();
  }

  static Future<void> rescheduleAllHabitsAfterBoot() async {
    await _bootRescheduler.rescheduleAllHabitsAfterBoot();
  }

  /// Generate a safe notification ID from a string
  static int generateSafeId(String input) {
    return NotificationHelpers.generateSafeId(input);
  }

  /// Process pending notification actions manually
  static Future<void> processPendingActionsManually() async {
    // This method is called when the app comes to foreground
    // awesome_notifications handles this automatically, so we can leave it empty
    // or add custom logic if needed
    AppLogger.debug(
        'Processing pending actions manually (no-op for awesome_notifications)');
  }

  /// Get the count of pending notification actions
  static Future<int> getPendingActionsCount() async {
    // awesome_notifications doesn't have a direct equivalent
    // Return 0 as actions are processed immediately
    return 0;
  }

  /// Handle snooze action with habit name
  static Future<void> handleSnoozeActionWithName(
    String habitId,
    String habitName,
  ) async {
    await NotificationActionHandlerIsar.handleSnoozeAction(habitId, habitName);
  }
}
