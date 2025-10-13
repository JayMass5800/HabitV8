import 'logging_service.dart';
import 'alarm_service.dart';

/// Service to handle alarm snooze functionality
///
/// NOTE: With awesome_notifications migration, snooze is now handled via
/// notification action buttons. This service provides the snooze scheduling logic.
class AlarmSnoozeService {
  static bool _isInitialized = false;

  /// Initialize the alarm snooze service
  static Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      AppLogger.info('Initializing AlarmSnoozeService...');

      // With awesome_notifications, snooze is handled via notification actions
      // No need for method channel setup

      _isInitialized = true;
      AppLogger.info('✅ AlarmSnoozeService initialized successfully');
    } catch (e) {
      AppLogger.error('Failed to initialize AlarmSnoozeService', e);
      rethrow;
    }
  }

  /// Handle the snooze action by scheduling a new alarm
  /// This is called from the notification action handler
  static Future<void> handleSnooze(
    String habitId,
    String habitName,
    int snoozeDelayMinutes, {
    String? alarmSoundName,
  }) async {
    try {
      AppLogger.info('📅 Scheduling snooze alarm for: $habitName');

      final snoozeTime =
          DateTime.now().add(Duration(minutes: snoozeDelayMinutes));

      // Schedule the snooze alarm using AlarmService
      await AlarmService.scheduleHabitAlarm(
        habitId: habitId,
        habitName: habitName,
        scheduledTime: snoozeTime,
        alarmSoundName: alarmSoundName,
        snoozeDelayMinutes: snoozeDelayMinutes,
      );

      AppLogger.info(
        '✅ Snooze alarm scheduled for $habitName at $snoozeTime',
      );
    } catch (e) {
      AppLogger.error('Failed to schedule snooze alarm for $habitName', e);
      rethrow;
    }
  }
}
