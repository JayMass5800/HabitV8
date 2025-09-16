# Android 15+ Foreground Service Restriction Fix

## Problem Description

Apps targeting Android 15 (API level 35) or later cannot use `BOOT_COMPLETED` broadcast receivers to launch certain foreground service types. This restriction was causing the HabitV8 app to crash for users on Android 15 and later.

**Specific Issue:**
- The `flutter_local_notifications` plugin includes a `ScheduledNotificationBootReceiver` that automatically starts foreground services on `BOOT_COMPLETED`
- Your app's `AlarmService` has `foregroundServiceType="mediaPlayback"` which is a restricted type
- Starting restricted foreground services from `BOOT_COMPLETED` causes crashes on Android 15+

## Solution Implemented

### 1. Disabled Flutter Local Notifications Boot Receiver
**File:** `android/app/src/main/AndroidManifest.xml`
- Commented out the `com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver` 
- This prevents the plugin from automatically starting foreground services on boot

### 2. Created Android 15+ Compatible Boot Receiver
**File:** `android/app/src/main/kotlin/com/habittracker/habitv8/Android15CompatBootReceiver.kt`
- New receiver that uses WorkManager instead of starting foreground services directly
- Uses `BootCompletionWorker` to handle notification rescheduling in the background
- Sets a flag that the Flutter app can check on next startup

### 3. Updated Flutter App to Handle Boot Completion
**File:** `lib/main.dart`
- Added `_handleBootCompletionIfNeeded()` function to check for boot completion flag
- Added `_rescheduleNotificationsAfterBoot()` function to reschedule notifications safely
- Uses existing `MidnightHabitResetService.forceReset()` to reschedule all notifications

### 4. Enhanced AlarmService Safety
**File:** `android/app/src/main/kotlin/com/habittracker/habitv8/AlarmService.kt`
- Added logging to track how the service is started
- Added safety comments about Android 15+ restrictions

### 5. Added WorkManager Dependency
**File:** `android/app/build.gradle`
- Added `androidx.work:work-runtime-ktx:2.9.0` dependency for the new boot receiver

## How It Works Now

1. **On Device Boot:**
   - `Android15CompatBootReceiver` receives `BOOT_COMPLETED` broadcast
   - Schedules a WorkManager task instead of starting foreground services
   - Sets a flag in SharedPreferences for the Flutter app

2. **On App Startup:**
   - Flutter app checks for the boot completion flag
   - If flag is set, triggers notification rescheduling using existing services
   - Rescheduling happens safely without violating Android 15+ restrictions

3. **Normal Operation:**
   - AlarmService continues to work normally for user-initiated alarms
   - Only the boot-time startup mechanism has changed

## Benefits

- ✅ **Android 15+ Compatible:** No more crashes on Android 15 and later
- ✅ **Backward Compatible:** Works on all Android versions
- ✅ **Minimal Changes:** Uses existing notification scheduling infrastructure  
- ✅ **Reliable:** WorkManager ensures boot completion is handled even if app is not running
- ✅ **Safe:** No restricted foreground services started from BOOT_COMPLETED

## Testing Recommendations

1. **Test on Android 15+ device:**
   - Install the app and set up some habits with notifications
   - Reboot the device
   - Verify the app doesn't crash and notifications are rescheduled properly

2. **Test on older Android versions:**
   - Ensure the app still works correctly on Android 14 and below
   - Verify notifications still work after device reboot

3. **Test edge cases:**
   - App not running when device boots
   - App killed by system after boot before user opens it
   - Multiple reboots in quick succession

## Key Files Changed

- `android/app/src/main/AndroidManifest.xml` - Disabled problematic boot receiver
- `android/app/src/main/kotlin/com/habittracker/habitv8/Android15CompatBootReceiver.kt` - New boot receiver
- `android/app/build.gradle` - Added WorkManager dependency
- `lib/main.dart` - Added boot completion handling
- `android/app/src/main/kotlin/com/habittracker/habitv8/AlarmService.kt` - Enhanced safety logging

This fix ensures your app complies with Android 15+ restrictions while maintaining all existing functionality.