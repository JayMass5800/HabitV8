import 'package:awesome_notifications/awesome_notifications.dart';
import '../domain/model/habit.dart';
import 'logging_service.dart';
import 'notifications/notification_core.dart';
import 'notifications/notification_helpers.dart';
import 'notifications/notification_scheduler.dart';
import 'notifications/notification_alarm_scheduler.dart';
import 'notifications/notification_action_handler.dart';
import 'notifications/notification_boot_rescheduler.dart';
import 'notifications/notification_validation_service.dart';
import 'notifications/scheduling_reliability_service.dart';

/// Notification Service Facade - delegates to specialized modules
class NotificationService {
  static late final NotificationScheduler _scheduler;
  static late final NotificationAlarmScheduler _alarmScheduler;
  static late final NotificationBootRescheduler _bootRescheduler;

  static Future<void> initialize() async {
    await NotificationCore.initialize(
        // Action handler is registered directly in NotificationCore.initialize()
        // as onBackgroundNotificationActionIsar (top-level function with @pragma annotation)
        // This is CRITICAL for notification shade buttons to work when app is fully closed
        );
    _scheduler = NotificationScheduler();
    _alarmScheduler = NotificationAlarmScheduler.instance;
    _bootRescheduler = NotificationBootRescheduler();

    // Initialize the reliability service for health monitoring and retry logic
    await SchedulingReliabilityService.initialize();
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
    try {
      final bool wantsNotifications = habit.notificationsEnabled;
      final bool wantsAlarms = habit.alarmEnabled;

      if (wantsNotifications) {
        final allPending = await getPendingNotifications();
        final existingAudit =
            NotificationValidationService.auditHabitFromSnapshot(
          habit,
          allPending,
        );
        final existingTotal =
            existingAudit.notificationCount + existingAudit.alarmCount;

        AppLogger.debug(
          'Scheduling notifications/alarms for ${habit.name}: $existingTotal '
          'existing '
          '(notifications: ${existingAudit.notificationCount}, '
          'alarms: ${existingAudit.alarmCount})',
        );

        // Use atomic rescheduling with retry for existing habits
        // For new habits, we can skip the atomic approach since there's nothing to preserve
        if (!isNewHabit && existingAudit.notificationCount > 0) {
          final success = await SchedulingReliabilityService.atomicReschedule(
            habit: habit,
            scheduleFunction: (h) =>
                _scheduler.scheduleHabitNotifications(h, isNewHabit: false),
            cancelFunction: (habitId) =>
                cancelHabitNotificationsByHabitId(habitId),
          );

          if (!success) {
            AppLogger.warning(
              'Atomic reschedule failed for ${habit.name}, falling back to standard approach',
            );
            // Fall through to standard approach
            await cancelHabitNotificationsByHabitId(habit.id);
            await _scheduler.scheduleHabitNotifications(habit,
                isNewHabit: isNewHabit);
          }
        } else {
          // New habit or no existing notifications - standard approach is fine
          await cancelHabitNotificationsByHabitId(habit.id);
          await _scheduler.scheduleHabitNotifications(habit,
              isNewHabit: isNewHabit);
        }

        final newPending = await getPendingNotifications();
        final newAudit = NotificationValidationService.auditHabitFromSnapshot(
          habit,
          newPending,
        );
        final newTotal = newAudit.notificationCount + newAudit.alarmCount;

        // Verify scheduling with expected count check
        final expectedCount =
            SchedulingReliabilityService.calculateExpectedNotificationCount(
                habit);
        if (newAudit.notificationCount == 0 &&
            !wantsAlarms &&
            expectedCount > 0) {
          AppLogger.error(
            'Failed to schedule any notifications for ${habit.name} - expected $expectedCount, got 0',
          );
          throw Exception(
            'Notification scheduling verification failed: no notifications were created',
          );
        }

        AppLogger.info(
          'Successfully scheduled notifications for ${habit.name}: '
          '$existingTotal → $newTotal '
          '(notifications: ${newAudit.notificationCount}, '
          'alarms: ${newAudit.alarmCount}, expected: ~$expectedCount)',
        );
      } else {
        AppLogger.debug(
          'Notifications disabled for ${habit.name} - cancelling any '
          'existing notifications',
        );
        await cancelHabitNotificationsByHabitId(habit.id);
        AppLogger.info(
          'Notifications remain disabled for habit: ${habit.name}',
        );
      }

      // Schedule alarms with retry logic
      final alarmSuccess = await SchedulingReliabilityService.retryWithBackoff(
        operation: () => _alarmScheduler.scheduleHabitAlarms(habit),
        operationName: 'schedule_alarms_${habit.name}',
      );

      if (wantsAlarms) {
        if (alarmSuccess) {
          AppLogger.info('Alarms refreshed for habit: ${habit.name}');
        } else {
          AppLogger.error('Failed to schedule alarms for habit: ${habit.name}');
        }
      } else {
        AppLogger.debug('Alarms disabled for habit: ${habit.name}');
      }
    } catch (e) {
      AppLogger.error(
        'Failed to schedule notifications/alarms for habit: ${habit.name}',
        e,
      );
      rethrow;
    }
  }

  static Future<void> scheduleHabitNotificationsOnly(Habit habit) async {
    // Use atomic rescheduling with retry logic for reliability
    // This ensures old notifications are only cancelled AFTER new ones are verified
    final success = await SchedulingReliabilityService.atomicReschedule(
      habit: habit,
      scheduleFunction: (h) async {
        await _scheduler.scheduleHabitNotifications(h);
      },
      cancelFunction: (habitId) async {
        await _scheduler.cancelHabitNotificationsByHabitId(habitId);
      },
    );

    if (!success) {
      // Atomic reschedule failed - attempt fallback with retry
      AppLogger.warning(
        'Atomic reschedule failed for ${habit.name}, attempting fallback...',
      );

      final fallbackSuccess =
          await SchedulingReliabilityService.retryWithBackoff(
        operation: () async {
          // Fallback: traditional cancel-then-schedule with verification
          final allPending = await getPendingNotifications();
          final existingAudit =
              NotificationValidationService.auditHabitFromSnapshot(
            habit,
            allPending,
          );
          final existingCount = existingAudit.notificationCount;

          AppLogger.debug(
            'Fallback rescheduling notifications for ${habit.name}: $existingCount existing',
          );

          await cancelHabitNotificationsByHabitId(habit.id);
          await _scheduler.scheduleHabitNotifications(habit);

          // Verify at least one notification was successfully scheduled
          final newPending = await getPendingNotifications();
          final newAudit = NotificationValidationService.auditHabitFromSnapshot(
            habit,
            newPending,
          );
          final newCount = newAudit.notificationCount;

          if (newCount == 0 && habit.notificationsEnabled) {
            throw Exception(
              'Notification scheduling verification failed: no notifications were created',
            );
          }

          AppLogger.info(
            'Successfully rescheduled notifications for ${habit.name}: $existingCount → $newCount',
          );
        },
        operationName: 'fallback_reschedule_${habit.name}',
      );

      if (!fallbackSuccess) {
        AppLogger.error(
          'Failed to reschedule notifications for habit: ${habit.name} after all retries',
        );
        throw Exception(
          'Failed to reschedule notifications for ${habit.name} after multiple attempts',
        );
      }
    }
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
    String? payload,
  }) async {
    await _scheduler.scheduleHabitNotification(
      id: id,
      habitId: habitId,
      title: title,
      body: body,
      scheduledTime: scheduledTime,
      payload: payload,
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
      payload: payload,
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

  // ==================== RELIABILITY & HEALTH ====================

  /// Check if timezone has changed (call on app resume).
  ///
  /// Returns true if timezone changed and notifications may need rescheduling.
  static Future<bool> checkTimezoneChange() async {
    return await SchedulingReliabilityService.checkTimezoneChange();
  }

  /// Perform a health check on the notification system.
  ///
  /// Returns a report with status, issues, and statistics.
  static Future<Map<String, dynamic>> performHealthCheck() async {
    return await SchedulingReliabilityService.performHealthCheck();
  }

  /// Get scheduling statistics (success rate, retry count, etc.).
  static Map<String, dynamic> getSchedulingStats() {
    return SchedulingReliabilityService.getStats();
  }

  /// Self-heal notifications for habits that have discrepancies.
  ///
  /// Audits all provided habits and reschedules those with missing notifications.
  static Future<int> selfHealNotifications(List<Habit> habits) async {
    // First, audit all habits
    final auditResults = await SchedulingReliabilityService.auditHabits(habits);

    // Find habits that need fixing
    final habitsToFix = habits.where((habit) {
      if (!habit.notificationsEnabled) return false;
      final audit = auditResults[habit.id];
      if (audit == null) return true; // No audit result = needs fixing
      return !audit.hasNotifications;
    }).toList();

    if (habitsToFix.isEmpty) {
      AppLogger.info('🏥 Self-heal: No habits need fixing');
      return 0;
    }

    AppLogger.info('🏥 Self-heal: ${habitsToFix.length} habits need fixing');

    return await SchedulingReliabilityService.selfHeal(
      habitsToFix: habitsToFix,
      scheduleFunction: (habit) => _scheduler.scheduleHabitNotifications(habit),
    );
  }

  /// Generate a collision-resistant notification ID.
  static int generateCollisionResistantId(String input) {
    return SchedulingReliabilityService.generateCollisionResistantId(input);
  }

  /// Get expected notification count for a habit based on its frequency.
  static int getExpectedNotificationCount(Habit habit) {
    return SchedulingReliabilityService.calculateExpectedNotificationCount(
        habit);
  }

  /// Get recent failure log entries for debugging.
  static Future<List<String>> getFailureLog() async {
    return await SchedulingReliabilityService.getFailureLog();
  }
}
