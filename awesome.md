# Flutter Notifications Migration Plan: flutter_local_notifications → awesome_notifications

## Current Status

### ✅ COMPLETED - Core Notification System
The following files have been successfully migrated to `awesome_notifications`:

1. **notification_service.dart** - Main facade service
2. **notification_core.dart** - Initialization, channels, permissions
3. **notification_scheduler.dart** - Scheduling logic for all frequency types
4. **notification_action_handler.dart** - Action button handling (Complete/Snooze)
5. **notification_helpers.dart** - Utility functions

### ⚠️ REMAINING - Alarm System (NOT YET MIGRATED)
The following files still use `flutter_local_notifications` and need migration:

1. **alarm_service.dart** - High-priority alarm notifications
2. **alarm_manager_service.dart** - Alarm scheduling and management

## Current Compilation Errors (82 total)

### Category 1: Alarm Services (70 errors)
Both `alarm_service.dart` and `alarm_manager_service.dart` are still importing and using `flutter_local_notifications`:

**Error Types:**
- Missing package dependency (flutter_local_notifications removed from pubspec.yaml)
- Undefined classes: `FlutterLocalNotificationsPlugin`, `AndroidInitializationSettings`, `InitializationSettings`, `AndroidNotificationDetails`, `NotificationDetails`
- Undefined enums: `Importance`, `Priority`, `AndroidNotificationCategory`, `NotificationVisibility`, `AndroidScheduleMode`, `UILocalNotificationDateInterpretation`
- Undefined methods: `AndroidNotificationAction`, `UriAndroidNotificationSound`

### Category 2: Code Quality Warnings (12 warnings)

**notification_action_handler.dart (5 warnings):**
- Line 6: Unused import `shared_preferences` (but may be needed for future alarm migration)
- Line 10: Unused import `widget_integration_service` (but may be needed for future alarm migration)
- Line 12: Unused import `notification_scheduler` (but may be needed for future alarm migration)
- Line 55: Unnecessary null comparison (receivedAction.buttonKeyPressed != null)
- Line 72: Unnecessary non-null assertion (receivedAction.buttonKeyPressed!)

**notification_core.dart (1 warning):**
- Line 294: Missing curly braces in if statement

**notification_scheduler.dart (1 warning):**
- Line 3: Unused import `timezone` (but may be needed for RRule calculations)

## Migration Strategy

### Phase 1: Fix Code Quality Issues (Low Risk)
These are simple fixes that don't change functionality:

1. **notification_core.dart** - Add curly braces to if statement (line 294)
2. **notification_action_handler.dart** - Fix unnecessary null checks (lines 55, 72)

**DO NOT REMOVE IMPORTS YET** - They may be needed when we migrate the alarm services.

### Phase 2: Migrate Alarm Services (High Risk)

#### 2.1 Understand Current Alarm Functionality

**alarm_service.dart** provides:
- Exact alarm scheduling (high-priority, time-critical)
- Full-screen intent notifications (wake device, show over lockscreen)
- Custom alarm sounds (system ringtones or app assets)
- Snooze functionality with configurable delays
- Persistent alarm data storage
- Audio playback for alarms

**alarm_manager_service.dart** provides:
- Alarm scheduling management
- Alarm cancellation
- Alarm rescheduling
- Integration with habit scheduling system

#### 2.2 awesome_notifications Alarm Equivalents

**Key Differences:**
- `flutter_local_notifications` uses Android AlarmManager for exact timing
- `awesome_notifications` uses its own scheduling system with exact alarm support

**Migration Mapping:**

| flutter_local_notifications | awesome_notifications |
|----------------------------|----------------------|
| `Importance.max` | `NotificationImportance.Max` |
| `Priority.high` | `NotificationPriority.High` |
| `AndroidNotificationCategory.alarm` | `NotificationCategory.Alarm` |
| `NotificationVisibility.public` | `NotificationPrivacy.Public` |
| `fullScreenIntent: true` | `fullScreenIntent: true` (same) |
| `AndroidNotificationDetails` | `NotificationContent` + `NotificationAndroidCron` |
| `AndroidNotificationAction` | `NotificationActionButton` |
| `UriAndroidNotificationSound` | `sound: 'resource://raw/alarm_sound'` |
| `zonedSchedule()` | `createNotification()` with `NotificationCalendar` |
| `AndroidScheduleMode.exactAllowWhileIdle` | Built-in with exact alarm permission |

#### 2.3 Migration Steps for alarm_service.dart

**Step 1: Update Imports**
```dart
// REMOVE:
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

// ADD (if not already present):
import 'package:awesome_notifications/awesome_notifications.dart';
```

**Step 2: Replace Plugin Instance**
```dart
// REMOVE:
static final FlutterLocalNotificationsPlugin _notificationsPlugin =
    FlutterLocalNotificationsPlugin();

// REPLACE WITH:
// Use AwesomeNotifications() directly (singleton pattern)
```

**Step 3: Update Initialization**
```dart
// REMOVE:
const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);
await _notificationsPlugin.initialize(initializationSettings);

// REPLACE WITH:
// Initialization is handled by NotificationCore.initialize()
// Just verify it's been called
if (!await AwesomeNotifications().isNotificationAllowed()) {
  await AwesomeNotifications().requestPermissionToSendNotifications();
}
```

**Step 4: Create Alarm Channel**
Add a dedicated alarm channel in `notification_core.dart`:
```dart
NotificationChannel(
  channelKey: 'habit_alarms',
  channelName: 'Habit Alarms',
  channelDescription: 'High-priority alarms for time-critical habits',
  importance: NotificationImportance.Max,
  defaultColor: Color(0xFF9C27B0),
  ledColor: Colors.red,
  playSound: true,
  enableVibration: true,
  enableLights: true,
  locked: true, // Prevent user from dismissing
  defaultPrivacy: NotificationPrivacy.Public,
  criticalAlerts: true, // iOS critical alerts
  channelShowBadge: true,
  onlyAlertOnce: false,
)
```

**Step 5: Update scheduleExactAlarm() Method**
```dart
// REPLACE AndroidNotificationDetails with NotificationContent
await AwesomeNotifications().createNotification(
  content: NotificationContent(
    id: alarmId,
    channelKey: 'habit_alarms',
    title: '🚨 $habitName',
    body: 'Time for your habit!',
    category: NotificationCategory.Alarm,
    notificationLayout: NotificationLayout.Default,
    fullScreenIntent: true,
    wakeUpScreen: true,
    criticalAlert: true,
    payload: {
      'habitId': habitId,
      'frequency': frequency,
      'alarmId': alarmId.toString(),
    },
    customSound: alarmSoundName != null 
        ? 'resource://raw/${alarmSoundName.replaceAll('.mp3', '')}'
        : null,
  ),
  actionButtons: [
    NotificationActionButton(
      key: 'complete',
      label: 'Complete',
      actionType: ActionType.Default,
      autoDismissible: true,
    ),
    NotificationActionButton(
      key: 'snooze',
      label: 'Snooze $snoozeDelayMinutes min',
      actionType: ActionType.Default,
      autoDismissible: false,
    ),
  ],
  schedule: NotificationCalendar.fromDate(
    date: scheduledTime,
    allowWhileIdle: true,
    preciseAlarm: true,
  ),
);
```

**Step 6: Update Alarm Sound Handling**
- Custom sounds must be in `android/app/src/main/res/raw/` directory
- Reference as `resource://raw/sound_name` (without .mp3 extension)
- System ringtones need different handling (may require additional plugin)

#### 2.4 Migration Steps for alarm_manager_service.dart

**Step 1: Update Imports** (same as alarm_service.dart)

**Step 2: Update All Notification Creation Calls**
- Replace `AndroidNotificationDetails` with `NotificationContent`
- Replace `NotificationDetails` with notification content + schedule
- Replace `zonedSchedule()` with `createNotification()`
- Update all enum values (Importance → NotificationImportance, etc.)

**Step 3: Update Cancellation Logic**
```dart
// REPLACE:
await _notificationsPlugin.cancel(alarmId);

// WITH:
await AwesomeNotifications().cancel(alarmId);
```

**Step 4: Update Pending Notifications Query**
```dart
// REPLACE:
final pendingNotifications = await _notificationsPlugin.pendingNotificationRequests();

// WITH:
final scheduledNotifications = await AwesomeNotifications().listScheduledNotifications();
```

### Phase 3: Testing Strategy

#### 3.1 Unit Tests
- Test alarm scheduling at exact times
- Test alarm cancellation
- Test alarm rescheduling
- Test snooze functionality
- Test custom sound loading

#### 3.2 Integration Tests
- Test alarm triggers at scheduled time
- Test full-screen intent (device wake)
- Test action buttons (Complete/Snooze)
- Test alarm persistence across app restarts
- Test alarm behavior when app is killed

#### 3.3 Manual Testing Checklist
- [ ] Schedule alarm for 1 minute in future
- [ ] Verify alarm triggers on time
- [ ] Verify full-screen intent shows
- [ ] Verify custom sound plays
- [ ] Test Complete button
- [ ] Test Snooze button
- [ ] Verify alarm reschedules after snooze
- [ ] Kill app and verify alarm still triggers
- [ ] Test alarm on Android 12+ (exact alarm permission)
- [ ] Test alarm with battery optimization enabled

### Phase 4: Cleanup

After successful migration and testing:

1. Remove unused imports from all files
2. Remove any flutter_local_notifications compatibility code
3. Update documentation
4. Remove flutter_local_notifications from dependencies (already done)

## Risk Assessment

### Low Risk (Can do immediately)
- Fix code quality warnings (curly braces, unnecessary null checks)
- These don't change functionality

### Medium Risk (Requires testing)
- Migrate alarm_service.dart
- Migrate alarm_manager_service.dart
- These change core alarm functionality but have clear equivalents

### High Risk (Requires extensive testing)
- Custom alarm sounds (may need additional plugin)
- Full-screen intent behavior (device-specific)
- Exact alarm scheduling on Android 12+ (permission handling)

## Dependencies to Consider

### Current Dependencies
- `awesome_notifications: ^0.10.1` ✅ Already added
- `permission_handler: ^11.3.1` ✅ Already added
- `audioplayers: ^6.1.0` ✅ Already present (for alarm audio)
- `flutter_ringtone_manager: ^0.0.2` ✅ Already present (for system ringtones)

### Potential Additional Dependencies
- May need additional plugin for system ringtone selection with awesome_notifications
- Consider `android_alarm_manager_plus` if awesome_notifications doesn't provide sufficient exact alarm guarantees

## Timeline Estimate

- **Phase 1 (Code Quality)**: 30 minutes
- **Phase 2 (Alarm Migration)**: 4-6 hours
- **Phase 3 (Testing)**: 2-3 hours
- **Phase 4 (Cleanup)**: 1 hour

**Total**: 7-10 hours

## Notes

### Why Imports Appear "Unused"
The Flutter analyzer shows some imports as unused because:
1. They were used with flutter_local_notifications
2. The alarm services haven't been migrated yet
3. Once alarm services are migrated, these imports will be needed again (or replaced with awesome_notifications equivalents)

**DO NOT REMOVE THESE IMPORTS UNTIL ALARM MIGRATION IS COMPLETE**

### Critical Considerations for Alarms
1. **Exact Timing**: Alarms must trigger at exact times (not approximate)
2. **Full-Screen Intent**: Must wake device and show over lockscreen
3. **High Priority**: Must bypass Do Not Disturb (with user permission)
4. **Persistence**: Must survive app kills and device reboots
5. **Custom Sounds**: Must support custom alarm sounds

### awesome_notifications Advantages
- Better cross-platform support (iOS critical alerts)
- More modern API design
- Better action button handling
- Built-in exact alarm support
- Better notification grouping
- More customization options

### Potential Challenges
1. **Custom Sounds**: May need to convert sound file references
2. **Full-Screen Intent**: Behavior may differ across devices
3. **Android 12+**: Exact alarm permission handling
4. **System Ringtones**: May need different approach than flutter_local_notifications

## Next Steps

1. **Immediate**: Fix code quality warnings (Phase 1)
2. **Next**: Migrate alarm_service.dart (Phase 2.3)
3. **Then**: Migrate alarm_manager_service.dart (Phase 2.4)
4. **Finally**: Comprehensive testing (Phase 3)

## Questions to Answer Before Migration

1. Are alarms critical for the app, or can they be treated as high-priority notifications?
2. Do users need system ringtone selection, or are app-provided sounds sufficient?
3. What's the acceptable alarm timing accuracy? (±1 minute? ±10 seconds?)
4. Should alarms persist after device reboot? (requires additional setup)
5. Are iOS critical alerts needed? (requires special entitlement)

## References

- [awesome_notifications Documentation](https://pub.dev/packages/awesome_notifications)
- [awesome_notifications Scheduling Guide](https://pub.dev/packages/awesome_notifications#-scheduling-a-notification)
- [Android Exact Alarms](https://developer.android.com/about/versions/12/behavior-changes-12#exact-alarm-permission)
- [iOS Critical Alerts](https://developer.apple.com/documentation/usernotifications/asking_permission_to_use_notifications#3544375)