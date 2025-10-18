import 'logging_service.dart';
import 'alarm_service.dart';

/// Test helper for diagnosing alarm issues
class AlarmTestHelper {
  /// Schedule a test alarm for 10 seconds from now
  static Future<void> scheduleTestAlarm() async {
    try {
      AppLogger.info('🧪 SCHEDULING TEST ALARM - will fire in 10 seconds');

      final now = DateTime.now();
      final testTime = now.add(const Duration(seconds: 10));

      AppLogger.info('Current time: $now');
      AppLogger.info('Test alarm time: $testTime');

      // Use AlarmService to schedule the test alarm
      await AlarmService.scheduleExactAlarm(
        alarmId: 999, // Special test ID
        habitId: 'test_habit_001',
        habitName: 'TEST HABIT - Check Your Logs!',
        scheduledTime: testTime,
        frequency: 'test',
        alarmSoundName: 'sounds/alarm.mp3',
        snoozeDelayMinutes: 5,
      );

      AppLogger.info('✅ TEST ALARM SCHEDULED SUCCESSFULLY');
      AppLogger.info('');
      AppLogger.info('📋 DIAGNOSTIC CHECKLIST:');
      AppLogger.info('1. Watch this log output for the next 15 seconds');
      AppLogger.info(
          '2. When alarm fires, you should see: "🔔 Notification displayed"');
      AppLogger.info(
          '3. Then you should see: "🚨 Alarm notification detected"');
      AppLogger.info(
          '4. Then you should see: "🚨 Starting native alarm sound" or "⏰ Starting alarm sound"');
      AppLogger.info(
          '5. You should HEAR an alarm sound (or see NativeAlarm logs)');
      AppLogger.info('6. Tap "COMPLETE" button to stop the alarm');
      AppLogger.info('');
      AppLogger.info('If you do NOT hear sound:');
      AppLogger.info('- Check Android logcat for NativeAlarm errors');
      AppLogger.info('- Verify device is not in silent mode');
      AppLogger.info('- Check volume is not muted');
    } catch (e) {
      AppLogger.error('Failed to schedule test alarm', e);
      rethrow;
    }
  }

  /// Cancel the test alarm
  static Future<void> cancelTestAlarm() async {
    try {
      AppLogger.info('Cancelling test alarm...');
      await AlarmService.cancelHabitAlarms('test_habit_001');
      AppLogger.info('Test alarm cancelled');
    } catch (e) {
      AppLogger.error('Failed to cancel test alarm', e);
    }
  }
}
