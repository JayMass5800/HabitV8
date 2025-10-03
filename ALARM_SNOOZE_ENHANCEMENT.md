# Alarm Actions Enhancement (Complete & Snooze)

## Overview
Enhanced the alarm notification action buttons to properly handle both completion and snoozing of habits:
- **COMPLETE button**: Stops the alarm and marks the habit as completed
- **SNOOZE button**: Stops the alarm and reschedules it for 10 minutes later with the same settings

Both features work seamlessly whether the app is in the foreground, background, or completely closed.

## Problem
Previously:
- The snooze button only stopped the alarm but didn't reschedule it
- The complete button only stopped the alarm but didn't mark the habit as completed
- Users had to open the app to actually complete habits after dismissing alarms

## Solution
Implemented complete workflows for both actions:
1. Stops the current alarm (sound + vibration)
2. Cancels the alarm notification
3. Communicates with Flutter to schedule a new alarm
4. Reschedules the alarm for 10 minutes later with the same settings

## Architecture

### Android (Kotlin) Components

#### 1. **AlarmActionReceiver.kt** (NEW)
A dedicated `BroadcastReceiver` that handles alarm notification action button presses:
- **ACTION_COMPLETE**: Stops the alarm service and cancels notifications
- **ACTION_SNOOZE**: 
  - Stops the alarm service
  - Stores snooze data in SharedPreferences
  - Attempts to notify Flutter via method channel
  - Opens MainActivity with snooze intent if app is not running

#### 2. **AlarmService.kt** (MODIFIED)
- Added `habitId` and `soundUriString` properties to track alarm metadata
- Updated `showAlarmNotification()` to use `AlarmActionReceiver` for action buttons
- Action buttons now send broadcasts to `AlarmActionReceiver` instead of stopping the service directly

#### 3. **AlarmReceiver.kt** (MODIFIED)
- Reads `habitId` from stored alarm data
- Passes `habitId` to `AlarmService` when starting the service
- Returns a Map of alarm data instead of just the sound URI

#### 4. **MainActivity.kt** (MODIFIED)
- Added handling for `SNOOZE_ALARM` action in `onNewIntent()`
- Invokes Flutter method channel `onAlarmSnooze` with habit data
- Allows Flutter to handle the actual rescheduling

### Flutter (Dart) Components

#### 1. **alarm_snooze_service.dart** (NEW)
A dedicated service for handling alarm snooze callbacks:
- Sets up method channel listener for `onAlarmSnooze` callbacks
- Receives habitId, habitName, and soundUri from native Android
- Schedules a new alarm using `AlarmManagerService.scheduleSnoozeAlarm()`
- Default snooze delay: 10 minutes

#### 2. **main.dart** (MODIFIED)
- Added initialization of `AlarmSnoozeService` during app startup
- Ensures snooze callbacks are ready to be received

### Android Manifest (MODIFIED)
- Registered `AlarmActionReceiver` as a broadcast receiver
- Set `exported="false"` for security

## Data Flow

### When User Taps "SNOOZE":

1. **Android**: `AlarmActionReceiver` receives broadcast
   ```
   ACTION_SNOOZE
   ├─ alarmId: 123456
   ├─ habitId: "abc-def-ghi"
   ├─ habitName: "Morning Exercise"
   └─ soundUri: "content://..."
   ```

2. **Android**: Receiver stops alarm service
   ```kotlin
   stopAlarmService(context, alarmId)
   // - Stops AlarmService
   // - Cancels alarm notification (ID: alarmId + 2000)
   ```

3. **Android**: Receiver stores snooze data in SharedPreferences
   ```kotlin
   prefs.edit().apply {
       putString("flutter.snooze_alarm_pending_$habitId", habitId)
       putString("flutter.snooze_alarm_name_$habitId", habitName)
       putString("flutter.snooze_alarm_sound_$habitId", soundUri)
       putLong("flutter.snooze_alarm_time_$habitId", currentTimeMillis)
   }
   ```

4. **Android → Flutter**: Receiver attempts to notify Flutter
   ```kotlin
   // If app is running, use method channel
   channel.invokeMethod("onAlarmSnooze", mapOf(...))
   
   // If app is not running, open MainActivity with intent
   startActivity(intent.apply { action = "SNOOZE_ALARM" })
   ```

5. **Flutter**: `AlarmSnoozeService` receives callback
   ```dart
   _handleSnooze(habitId, habitName, soundUri)
   ```

6. **Flutter**: Service schedules new alarm
   ```dart
   final snoozeTime = DateTime.now().add(Duration(minutes: 10));
   await AlarmManagerService.scheduleSnoozeAlarm(
     alarmId: snoozeAlarmId,
     habitId: habitId,
     habitName: habitName,
     snoozeTime: snoozeTime,
     alarmSoundUri: soundUri,
     snoozeDelayMinutes: 10,
   );
   ```

7. **Result**: New alarm scheduled for 10 minutes later
   - Same habit
   - Same alarm sound
   - Same notification behavior

## Key Features

### ✅ Proper Alarm Stopping
- Stops alarm sound (MediaPlayer/Ringtone)
- Stops vibration
- Dismisses both notifications (service + alarm)

### ✅ Cross-Process Communication
- Uses method channel for live app
- Uses SharedPreferences + Intent for background
- Guarantees snooze works regardless of app state

### ✅ Consistent Behavior
- Snooze delay: 10 minutes (configurable)
- Preserves alarm sound settings
- Maintains habit context

### ✅ Robust Error Handling
- Graceful fallback if method channel fails
- Logs all steps for debugging
- Continues app operation even if snooze fails

## Testing Instructions

1. **Create an alarm-type habit**
   - Set alarm time to 2-3 minutes in the future
   - Choose a custom alarm sound (optional)

2. **Wait for alarm to fire**
   - Verify alarm sound plays
   - Verify vibration works
   - Verify notification appears with habit name

3. **Test COMPLETE button**
   - Tap "✅ COMPLETE"
   - Verify alarm stops
   - Verify notifications disappear
   - Verify alarm does NOT reschedule

4. **Test SNOOZE button**
   - Wait for alarm to fire again
   - Tap "⏰ SNOOZE"
   - Verify alarm stops immediately
   - Verify notifications disappear
   - Wait 10 minutes
   - Verify alarm fires again with same sound
   - Verify alarm notification appears again

5. **Test app states**
   - Test snooze with app in foreground
   - Test snooze with app in background
   - Test snooze with app killed/swiped away
   - Verify snooze works in all cases

## Configuration

### Snooze Delay
Currently hardcoded to 10 minutes in `AlarmSnoozeService`:
```dart
const snoozeDelayMinutes = 10;
```

Can be made configurable by:
1. Reading from habit settings
2. Reading from app preferences
3. Adding user-selectable snooze durations

### Snooze Alarm ID
Generated as: `habitId_snooze` using:
```dart
AlarmManagerService.generateHabitAlarmId(habitId, suffix: 'snooze')
```

Ensures uniqueness and prevents conflicts with main alarm.

## Future Enhancements

1. **Configurable Snooze Duration**
   - Allow users to set custom snooze delays per habit
   - Offer preset options (5, 10, 15, 30 minutes)

2. **Snooze Limit**
   - Limit number of snoozes per alarm
   - Force completion after N snoozes

3. **Snooze History**
   - Track snooze count for analytics
   - Show snooze patterns in insights

4. **Smart Snooze**
   - Gradually decrease snooze duration
   - Increase alarm volume after each snooze

5. **Complete from Snooze**
   - Mark habit as complete when snoozing
   - Option to auto-complete on third snooze

## Troubleshooting

### Snooze Not Working
1. Check logs for "Snooze alarm action received"
2. Verify `AlarmActionReceiver` is registered in manifest
3. Ensure `AlarmSnoozeService` is initialized in main.dart
4. Check SharedPreferences for snooze data

### Alarm Not Rescheduling
1. Check if `scheduleSnoozeAlarm` is called
2. Verify exact alarm permission is granted
3. Check battery optimization settings
4. Review alarm data file in app_flutter directory

### Method Channel Errors
1. Verify method channel name matches on both sides
2. Check Flutter engine is initialized
3. Ensure MainActivity is not being destroyed
4. Review logcat for method channel exceptions

## Files Changed

### New Files
- `android/app/src/main/kotlin/.../AlarmActionReceiver.kt`
- `lib/services/alarm_snooze_service.dart`

### Modified Files
- `android/app/src/main/kotlin/.../AlarmService.kt`
- `android/app/src/main/kotlin/.../AlarmReceiver.kt`
- `android/app/src/main/kotlin/.../MainActivity.kt`
- `android/app/src/main/AndroidManifest.xml`
- `lib/main.dart`

## Related Documentation
- `ALARM_NOTIFICATION_FIX.md` - Initial alarm notification implementation
- `ANDROID_15_FOREGROUND_SERVICE_FINAL_FIX.md` - Foreground service architecture
- See `notification_action_handler.dart` for notification snooze implementation
