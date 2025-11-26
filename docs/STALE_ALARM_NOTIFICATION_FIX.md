# Stale Alarm Notification Fix

**Date:** November 25, 2025  
**Issue:** Alarm sound plays when opening app (even with no notification in tray)

## Problem Description

When a user opens the app, an alarm sound would start playing even when:
1. There's no alarm notification visible in the notification tray
2. The user hasn't interacted with any notifications

## Root Causes

### Cause 1: Stale Notification in Tray (Original Issue)
When a notification is left visible in the tray and the app is restarted:
- `awesome_notifications` re-fires `onNotificationDisplayed` for visible notifications
- This triggers alarm audio to start

### Cause 2: Race Condition During Initialization (Additional Issue)
When the app starts:
1. `NotificationService.initialize()` registers the `onNotificationDisplayed` listener
2. Any past-due scheduled alarms may fire IMMEDIATELY
3. `AlarmService.initialize()` hadn't been called yet, so `appInitializationTime` was null
4. The stale notification check was skipped, allowing the alarm audio to play

## Solution

### Layer 1: Early Initialization Time Recording

Added `AlarmService.recordAppInitializationTime()` method called BEFORE `NotificationService.initialize()`:

```dart
// In main()
AlarmService.recordAppInitializationTime();  // <-- CRITICAL: Before notification init
await NotificationService.initialize();      // This registers listeners
await AlarmService.initialize();             // Full initialization
```

### Layer 2: Defensive Check for Null appInitTime

If `appInitTime` is null when `onNotificationDisplayed` fires, treat it as a stale notification:

```dart
if (appInitTime == null) {
  AppLogger.warning('⚠️ Alarm notification received before AlarmService initialized - likely stale');
  await AlarmService.markAlarmAsHandled(receivedNotification.id!);
  return;
}
```

### Layer 3: Creation Time Comparison

For notifications that fire after initialization:
- Compare `notification.createdDate` with `appInitializationTime`
- If created > 5 seconds before app started, it's stale

## How It Works

1. When `main()` runs, `AlarmService.recordAppInitializationTime()` is called first
2. This records `DateTime.now()` before any notification listeners are registered
3. When `NotificationService.initialize()` runs and registers `onNotificationDisplayed`:
   - If a stale notification fires immediately, `appInitTime` is already set
   - The handler checks if the notification predates app start
   - If stale, the alarm is marked as handled and audio is NOT started
4. For notifications created after app start, audio plays normally

## Files Modified

- `lib/main.dart` - Added early call to `AlarmService.recordAppInitializationTime()`
- `lib/services/alarm_service.dart` - Added `recordAppInitializationTime()` method
- `lib/services/notifications/notification_action_handler.dart` - Added null check for `appInitTime`

## Testing

1. Create a habit with alarm enabled for a past time
2. Kill the app
3. Clear all notifications from tray
4. Open the app
5. Verify alarm sound does NOT play

## Relationship to Other Fixes

This fix complements `ALARM_AUDIO_RESTART_FIX.md` which handles:
- Alarms that were explicitly dismissed/completed/snoozed (tracked in SharedPreferences)
