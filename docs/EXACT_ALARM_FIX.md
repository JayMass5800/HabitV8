# Notification Permission Fix

## Problem
Both notification permissions and "allow alarms and reminders" were becoming unselectable (greyed out) on Android 13+ devices after app startup. This was preventing users from enabling any notifications.

## Root Cause
The app was requesting both notification permission and exact alarm permission during startup:
1. **Android 13+ (API 33+)**: Requesting `POST_NOTIFICATIONS` permission during startup causes it to be greyed out
2. **Android 14+ (API 34+)**: Requesting `SCHEDULE_EXACT_ALARMS` permission during startup causes it to be greyed out
3. **Android 15 (API 36)**: Even stricter permission request timing requirements

Android detects early permission requesting as "aggressive permission requesting" and greys out permissions as a protective measure.

## Solution
1. **Removed ALL permission requests from startup**
2. **Added contextual permission requests** - only when actually needed
3. **Updated all notification scheduling methods** to check/request permissions before scheduling
4. **Graceful fallback** if permissions are denied

## Changes Made

### PermissionService (`lib/services/permission_service.dart`)
- **Removed notification permission request from startup** in `requestEssentialPermissions()`
- **Removed exact alarm permission request from startup**
- Added `requestNotificationPermission()` method
- Added `requestNotificationPermissionWithContext()` for better UX
- Added `requestExactAlarmPermission()` method
- Added `requestExactAlarmPermissionWithContext()` for better UX

### NotificationService (`lib/services/notification_service.dart`)
- **Removed permission requests from initialization** in `_requestAndroidPermissions()`
- Added `_ensureNotificationPermissions()` helper method that checks:
  1. Basic notification permission (`POST_NOTIFICATIONS`)
  2. Exact alarm permission (`SCHEDULE_EXACT_ALARMS`) for Android 12+
- Updated all scheduling methods to check permissions before scheduling:
  - `scheduleNotification()`
  - `scheduleDailyNotification()`
  - `scheduleHabitNotification()`
  - `scheduleHabitAlarm()`
  - `scheduleHabitNotifications()`

## Permission Request Flow

### Before (Broken)
```
App Startup → Request Notification Permission → Request Exact Alarm Permission
             ↓                                  ↓
        Permissions become greyed out in Android settings
```

### After (Fixed)
```
App Startup → No permission requests
             ↓
User enables notifications on habit → Request Notification Permission → Request Exact Alarm Permission
                                     ↓                                  ↓
                              Permissions remain selectable in Android settings
```

## Testing Steps
1. **Install the updated app** on Android 13+ device
2. **Check notification permission**: Go to Android Settings > Apps > HabitV8 > Notifications
   - Verify "Allow notifications" toggle is **selectable** (not greyed out)
3. **Check exact alarm permission**: Go to Android Settings > Apps > HabitV8 > Alarms & reminders  
   - Verify "Allow alarms and reminders" option is **selectable** (not greyed out)
4. **Test permission flow**:
   - Create a habit with notifications enabled
   - Verify notification permission is requested at this point (not during startup)
   - Enable the notification permission
   - Verify exact alarm permission is requested next
   - Enable the exact alarm permission
5. **Verify notifications work** precisely after permissions are granted

## Expected Behavior
- **App starts** without requesting any permissions
- **Permissions are requested** only when user enables notifications on a habit
- **If notification permission is granted**: Basic notifications work
- **If exact alarm permission is also granted**: Notifications are precise
- **If exact alarm permission is denied**: Notifications still work but may be delayed up to 15 minutes
- **All permissions remain selectable** in Android settings

## Android Versions Affected
- **Android 13+ (API 33+)**: Requires runtime request for `POST_NOTIFICATIONS`
- **Android 14+ (API 34+)**: Stricter timing for `SCHEDULE_EXACT_ALARMS` requests
- **Android 15 (API 36)**: Even stricter permission request timing requirements
- **Earlier versions**: Don't need runtime notification permission requests

## Technical Details
- **Target SDK**: 36 (Android 15)
- **Min SDK**: 26 (Android 8.0)
- **Permissions declared in manifest**: `POST_NOTIFICATIONS`, `SCHEDULE_EXACT_ALARMS`
- **Permission handler**: `permission_handler` package
- **Notification plugin**: `flutter_local_notifications` package