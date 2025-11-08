# CRITICAL: Auto-Start Permission Required for Boot Notification Rescheduling

## Problem Discovered
After testing, we discovered that notifications are **NOT rescheduled** after device reboot unless the user opens the app.

## Root Cause
Flutter WorkManager requires `Workmanager().initialize(callbackDispatcher)` to be called from `main()` to register the background task handler. However, if the app never opens after reboot, `main()` never runs, so the callback dispatcher is never registered, and WorkManager tasks cannot execute.

## Solution: AUTO-START Permission

### What is Auto-Start Permission?
Auto-start permission allows the app to automatically launch in the background when the device boots, without user interaction. This is essential for:
- Rescheduling notifications after reboot
- Running background tasks via WorkManager
- Ensuring critical app functionality works without user opening the app

### How to Enable Auto-Start Permission

#### Xiaomi/MIUI/Redmi
1. Go to **Settings** → **Apps** → **Manage apps**
2. Find **HabitV8**
3. Tap **Autostart**
4. Enable the toggle

#### Samsung/One UI
1. Go to **Settings** → **Apps**
2. Find **HabitV8**
3. Tap **Battery**
4. Allow background activity

#### Huawei/EMUI
1. Go to **Settings** → **Apps** → **App launch**
2. Find **HabitV8**
3. Disable **Manage automatically**
4. Enable **Auto-launch**, **Secondary launch**, and **Run in background**

#### Oppo/ColorOS
1. Go to **Settings** → **Apps** → **App Management**
2. Find **HabitV8**
3. Tap **Startup manager**
4. Enable auto-start

#### Vivo/Funtouch OS/Origin OS
1. Go to **i Manager** → **App Manager** → **Autostart Manager**
2. Find **HabitV8**
3. Enable the toggle

#### OnePlus/OxygenOS
1. Go to **Settings** → **Apps** → **App Management**
2. Find **HabitV8**
3. Tap **Battery** → **Advanced settings**
4. Enable **Allow background activity**

#### Realme/Realme UI
1. Go to **Settings** → **App Management** → **Startup Manager**
2. Find **HabitV8**
3. Enable auto-start

#### Stock Android/Google Pixel
1. Go to **Settings** → **Apps**
2. Find **HabitV8**
3. Tap **Battery**
4. Select **Unrestricted**

### Why This Is Necessary

Without auto-start permission:
1. Device reboots
2. `BootCompletionWorker` sets flag: `workmanager_boot_reschedule_needed = true`
3. WorkManager tries to run boot reschedule task
4. **BUT**: Flutter app never launched, so `Workmanager().initialize()` was never called
5. **RESULT**: Callback dispatcher not registered, task cannot execute
6. ❌ Notifications never rescheduled

With auto-start permission:
1. Device reboots
2. `BootCompletionWorker` triggers app to auto-start in background
3. App's `main()` runs → `Workmanager().initialize(callbackDispatcher)` called
4. Callback dispatcher registered
5. WorkManager boot reschedule task executes
6. `_performBootReschedule()` runs in background
7. All notifications rescheduled from habit data
8. ✅ Notifications work even though user never manually opened the app

## Implementation Notes

### Current Boot Flow
```
Device Reboot
    ↓
Android15CompatBootReceiver (BOOT_COMPLETED)
    ↓
BootCompletionWorker
    ├─→ Sets workmanager_boot_reschedule_needed = true
    ├─→ Sets needs_notification_reschedule_after_boot = true
    └─→ Schedules WidgetUpdateWorker
    ↓
[REQUIRES AUTO-START PERMISSION]
    ↓
App auto-launches in background (invisible to user)
    ↓
main() runs → Workmanager().initialize(callbackDispatcher)
    ↓
WorkManagerHabitService.initialize()
    ↓
Checks workmanager_boot_reschedule_needed flag
    ↓
Schedules BOOT_RESCHEDULE_TASK
    ↓
Task executes via callbackDispatcher
    ↓
_performBootReschedule() runs
    ↓
Gets all habits from Isar
    ↓
Reschedules all notifications
    ↓
✅ Done - app can close, notifications will fire at scheduled times
```

### Fallback Mechanism
If auto-start permission is NOT granted:
1. User must manually open the app after reboot
2. App checks `needs_notification_reschedule_after_boot` flag
3. Calls `_rescheduleNotificationsAfterBoot()`
4. Notifications rescheduled when app opens

**This is why the test failed**: Without auto-start permission, the app never launched in background, so WorkManager couldn't run, so notifications weren't rescheduled.

## User Instructions to Add to App

### In-App Permission Request
Consider adding a settings screen that:
1. Detects if auto-start permission is likely needed (Xiaomi, Huawei, etc.)
2. Shows instructions for enabling auto-start
3. Explains why it's needed ("To reschedule habit reminders after phone restarts")
4. Provides a button to open the app's settings page

### Example Code for Opening App Settings
```dart
import 'package:permission_handler/permission_handler.dart';

Future<void> openAppSettings() async {
  await openAppSettings();
}
```

### Detection Logic
```dart
Future<bool> needsAutoStartPermission() async {
  // Check if running on manufacturer that typically requires auto-start permission
  final manufacturer = await deviceInfo.manufacturer;
  return ['xiaomi', 'huawei', 'oppo', 'vivo', 'realme', 'oneplus']
      .any((m) => manufacturer.toLowerCase().contains(m));
}
```

## Testing Checklist

### Before Reboot
- [ ] Set a habit with notification for 2-3 minutes in future
- [ ] Note the exact time
- [ ] Check auto-start permission is enabled
- [ ] Reboot device

### After Reboot
- [ ] Do NOT open the app
- [ ] Wait for scheduled notification time
- [ ] Verify notification appears
- [ ] If notification doesn't appear:
  - Check auto-start permission
  - Check battery optimization settings
  - Open app and check logs

### Log Messages to Look For
```
// Boot receiver
I/Android15CompatBootReceiver: Boot completed
I/BootCompletionWorker: ✅ Boot completion flags set

// App auto-start (if permission granted)
🔄 Initializing WorkManager Habit Service
🔄 Boot reschedule flag detected
✅ Boot reschedule task scheduled

// WorkManager background execution
🔄 Executing WorkManager task: com.habitv8.BOOT_RESCHEDULE_TASK
🔄 Starting boot notification rescheduling (WorkManager background task)
📋 Found X active habits to reschedule notifications
✅ Boot notification rescheduling complete
```

## Alternative Solutions (If Auto-Start is Not Possible)

### Option 1: Persistent Notification
Show a persistent foreground notification that:
- Reminds user to open app after reboot
- Can be dismissed but reappears until app is opened
- Ensures user knows notifications need to be restored

### Option 2: Widget Interaction
Use home screen widget that:
- Shows "Tap to restore notifications" after reboot
- Triggers notification rescheduling when tapped
- More user-friendly than requiring app launch

### Option 3: Native Android Scheduling
Implement notification scheduling entirely in Kotlin:
- Parse habit data from Isar database using native code
- Schedule notifications using Android AlarmManager directly
- No dependency on Flutter/Dart code execution
- More complex but doesn't require auto-start permission

## Conclusion

**AUTO-START PERMISSION IS REQUIRED** for the WorkManager-based boot notification rescheduling to work without user intervention.

Without it, users MUST manually open the app after every reboot for notifications to be rescheduled.

This should be clearly documented in:
1. App onboarding flow
2. Settings screen
3. Help documentation
4. Play Store description (optional but recommended)

Consider adding an in-app check that detects if auto-start permission is likely needed and guides users through enabling it.
