# Alarm Audio Restart Fix

**Date:** November 2025  
**Issue:** Alarm sound restarts when opening app after dismissing alarm

## Problem Description

When a user:
1. Receives an alarm notification
2. Dismisses it (via Complete or Snooze button)
3. Kills the app or switches away
4. Opens the app again

The alarm sound would restart playing even though the alarm was already dismissed.

## Root Cause

The issue occurred due to the following sequence:

1. When an alarm notification displays, `onNotificationDisplayed` fires and calls `AlarmService.startAlarmAudio()`
2. When the user dismisses the alarm, `stopAlarmAudio()` is called and the audio stops
3. The notification is also dismissed/cancelled
4. However, when the app is killed and reopened:
   - `_activeAlarmPlayer` is `null` (new process, static state reset)
   - Awesome Notifications may re-fire `onNotificationDisplayed` for any still-visible notifications
   - Or the notification lifecycle triggers the handler again
5. Since there was no tracking of which alarms were already handled, `startAlarmAudio()` would start fresh

## Solution

Added a tracking mechanism in `AlarmService` to remember which alarm IDs have been "handled" (dismissed/completed/snoozed):

### Changes to `lib/services/alarm_service.dart`

1. **Added tracking data structures:**
   ```dart
   static const String _handledAlarmsKey = 'handled_alarm_ids';
   static Set<int> _handledAlarmIds = {};
   static bool _handledAlarmsLoaded = false;
   ```

2. **Added helper methods:**
   - `_loadHandledAlarms()`: Loads handled IDs from SharedPreferences
   - `_saveHandledAlarms()`: Persists handled IDs to SharedPreferences
   - `markAlarmAsHandled(int alarmId)`: Marks an alarm as handled
   - `isAlarmHandled(int alarmId)`: Checks if alarm was already handled
   - `clearHandledAlarm(int alarmId)`: Clears a specific alarm from the list

3. **Added guard in `startAlarmAudio()`:**
   ```dart
   if (await isAlarmHandled(alarmId)) {
     AppLogger.info('⏭️ Skipping alarm audio for $alarmId - already handled');
     return;
   }
   ```

4. **Automatic cleanup:** Keeps only the last 50 handled alarm IDs to prevent memory buildup

### Changes to `lib/services/notifications/notification_action_handler.dart`

1. **In button action handler (Complete/Snooze):**
   ```dart
   await AlarmService.markAlarmAsHandled(receivedAction.id!);
   await AlarmService.stopAlarmAudio(alarmId: receivedAction.id);
   ```

2. **In `onNotificationDismissed`:**
   ```dart
   await AlarmService.markAlarmAsHandled(receivedAction.id!);
   await AlarmService.stopAlarmAudio(alarmId: receivedAction.id);
   ```

## How It Works

1. When user interacts with an alarm (Complete, Snooze, or swipe dismiss):
   - The alarm ID is added to `_handledAlarmIds` set
   - The set is persisted to SharedPreferences
   - Audio is stopped

2. If the app is killed and reopened:
   - If `onNotificationDisplayed` fires for a stale notification:
     - `startAlarmAudio()` is called
     - It checks `isAlarmHandled(alarmId)` 
     - Finds the ID in the set
     - Returns early WITHOUT starting audio

3. Cleanup:
   - When more than 50 IDs are tracked, oldest ones are removed
   - This prevents unbounded growth of the tracking set

## Testing

1. Create a habit with alarm enabled
2. Wait for alarm to fire
3. Dismiss via Complete or Snooze button
4. Kill the app completely
5. Reopen the app
6. Verify alarm sound does NOT restart

## Files Modified

- `lib/services/alarm_service.dart` - Added tracking mechanism and guard
- `lib/services/notifications/notification_action_handler.dart` - Added markAlarmAsHandled calls
