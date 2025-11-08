# Boot Notification Rescheduling Implementation

## Overview
Implemented a comprehensive solution to reschedule notifications after device reboot, addressing the issue where scheduled notifications are cleared by the OS on reboot.

## Problem Statement
As documented in `error.md`, scheduled local notifications are cleared by the operating system on device reboot and are not persistent by default. Without intervention, users would lose all scheduled habit reminders after rebooting their device.

## Solution Architecture

### 1. Persistent Notification Storage
Created a Hive-based storage system to persist notification data:

**Files Created:**
- `lib/domain/model/scheduled_notification.dart` - Hive model for notification data
- `lib/services/notifications/scheduled_notification_storage.dart` - Storage service
- `lib/services/notifications/notification_boot_rescheduler.dart` - Boot rescheduling service

**Key Features:**
- Stores notification ID, habitId, title, body, scheduled time
- Tracks whether notification is an alarm vs regular notification
- Provides cleanup methods for old/expired notifications
- Uses Hive for reliable persistence (typeId 3)

### 2. Integration Points

#### A. Notification Scheduling (notification_scheduler.dart)
**Changes Made:**
- Added imports for `ScheduledNotification` and `ScheduledNotificationStorage`
- Modified `scheduleHabitNotification()` to persist notification data after successful scheduling
- Updated all cancellation methods to remove from persistent storage:
  - `cancelNotification()` - removes single notification from storage
  - `cancelAllNotifications()` - clears all storage
  - `cancelHabitNotifications()` - removes by base ID
  - `cancelHabitNotificationsByHabitId()` - removes all for a habit

#### B. Notification Service Facade (notification_service.dart)
**Changes Made:**
- Added `NotificationBootRescheduler` initialization
- Added `ScheduledNotificationStorage` initialization in `initialize()`
- Exposed public methods:
  - `rescheduleNotificationsAfterBoot()` - reschedules from storage
  - `getNotificationStats()` - debugging/monitoring
  - `cleanupOldNotificationRecords()` - maintenance

#### C. Boot Completion Flow (main.dart)
**Changes Made:**
- Updated `_rescheduleNotificationsAfterBoot()` to use **habit-based regeneration** instead of storage replay
- **Critical Decision**: Rather than replaying stored notifications, we regenerate all notifications from active habits
- This ensures:
  - ✅ All habit types are included (daily, weekly, monthly, yearly, hourly, single, RRule)
  - ✅ Notifications reflect current habit settings (in case habits were edited while device was off)
  - ✅ No dependency on potentially incomplete storage
  - ✅ Proper filtering and scheduling logic for each habit type

### 3. Android Boot Receiver Integration

The existing `Android15CompatBootReceiver.kt` already handles:
- Receiving `BOOT_COMPLETED` broadcast
- Setting flag in SharedPreferences: `needs_notification_reschedule_after_boot`
- Main.dart checks this flag on startup and calls `_rescheduleNotificationsAfterBoot()`

## Implementation Details

### Notification Persistence Flow
```
1. User creates/updates habit with notifications enabled
2. NotificationScheduler.scheduleHabitNotification() called
3. Notification scheduled with flutter_local_notifications
4. Notification data saved to Hive storage (ScheduledNotificationStorage)
5. On cancellation, data removed from storage
```

### Boot Rescheduling Flow
```
1. Device reboots
2. Android15CompatBootReceiver receives BOOT_COMPLETED
3. Flag set: needs_notification_reschedule_after_boot = true
4. User opens app
5. main.dart checks flag in _handleBootCompletionIfNeeded()
6. Calls _rescheduleNotificationsAfterBoot()
7. Fetches all active habits from Isar database
8. For each habit with notificationsEnabled:
   - Cancels any existing notifications
   - Reschedules based on habit's frequency, RRule, times, etc.
9. All habit types properly handled through existing scheduling logic
10. Flag cleared
```

## Why Habit-Based Regeneration Instead of Storage Replay?

**Initial Approach (Storage Replay):**
- ❌ Only reschedules notifications that were stored
- ❌ Doesn't account for habits edited while device was off
- ❌ May miss notifications if storage was incomplete
- ❌ Doesn't filter by current date/relevance

**Final Approach (Habit-Based Regeneration):**
- ✅ Regenerates from source of truth (habit data in Isar)
- ✅ Includes ALL habit types through existing scheduling logic
- ✅ Respects current habit settings and enabled state
- ✅ Uses existing frequency-specific scheduling logic
- ✅ Automatically filters to relevant time windows
- ✅ More reliable and maintainable

## Habit Types Coverage

The implementation handles **all habit types** because it delegates to the existing `NotificationService.scheduleHabitNotifications()` which includes:

1. **Daily** - via `_scheduleDailyHabitNotifications()`
2. **Weekly** - via `_scheduleWeeklyHabitNotifications()`
3. **Monthly** - via `_scheduleMonthlyHabitNotifications()`
4. **Yearly** - via `_scheduleYearlyHabitNotifications()`
5. **Hourly** - via `_scheduleHourlyHabitNotifications()`
6. **Single** - via `_scheduleSingleHabitNotification()`
7. **RRule-based** - via `_scheduleRRuleHabitNotifications()` (for habits using RFC 5545 recurrence rules)

Each frequency type has its own scheduling window and logic:
- Yearly: 2 years ahead
- Monthly: 1 year ahead
- Others: 12 weeks (84 days) ahead

## Date Filtering

Notifications are automatically filtered by:
1. **Time window**: Each frequency type schedules only within its appropriate window
2. **RRule occurrences**: RRule-based habits use `RRuleService.getOccurrences()` to get only valid dates
3. **Enabled state**: Only habits with `notificationsEnabled = true` are scheduled
4. **Active state**: Only active habits are processed

## Storage Purpose

While the final implementation uses **habit-based regeneration** for boot rescheduling, the persistent storage system still serves important purposes:

1. **Debugging**: `getNotificationStats()` provides insight into scheduled notifications
2. **Cleanup**: Automatic removal of old notification records
3. **Fallback**: Storage could be used as fallback if habit data becomes corrupted
4. **Future features**: Foundation for notification analytics or history

## Testing Recommendations

1. **Boot Test**: 
   - Schedule notifications for various habit types
   - Reboot device
   - Verify all notifications are rescheduled correctly

2. **Multi-Type Test**:
   - Create habits: daily, weekly, monthly, yearly, hourly, single, RRule
   - Enable notifications for all
   - Reboot
   - Verify each type reschedules correctly

3. **Storage Cleanup**:
   - Let notifications fire
   - Verify old records are cleaned up after 24 hours

## Files Modified/Created

### Created:
1. `lib/domain/model/scheduled_notification.dart` (81 lines)
2. `lib/domain/model/scheduled_notification.g.dart` (generated by build_runner)
3. `lib/services/notifications/scheduled_notification_storage.dart` (217 lines)
4. `lib/services/notifications/notification_boot_rescheduler.dart` (177 lines)

### Modified:
1. `lib/services/notifications/notification_scheduler.dart`
   - Added notification persistence on scheduling
   - Added storage cleanup on cancellation
   
2. `lib/services/notification_service.dart`
   - Added boot rescheduler initialization
   - Added public API methods
   
3. `lib/main.dart`
   - Updated `_rescheduleNotificationsAfterBoot()` with habit-based regeneration

### Existing (No Changes Required):
- `android/app/src/main/AndroidManifest.xml` - Already has RECEIVE_BOOT_COMPLETED permission
- `android/app/src/main/kotlin/.../Android15CompatBootReceiver.kt` - Already sets boot flag
- Notification scheduling logic for each habit type - Already comprehensive

## Build Command Executed
```powershell
flutter pub run build_runner build --delete-conflicting-outputs
```
This generated the Hive adapter for `ScheduledNotification` model.

## Summary

✅ **Complete implementation** of boot notification rescheduling
✅ **All habit types supported** through delegation to existing scheduling logic
✅ **Proper filtering** by time windows, RRule occurrences, and enabled state
✅ **Reliable approach** using habit data as source of truth
✅ **No compilation errors** - ready for testing
✅ **Follows project architecture** - modular services with single responsibility
✅ **Future-proof** - persistent storage foundation for analytics/debugging

The implementation successfully addresses the error.md requirements while improving upon the suggested approach by using habit-based regeneration for maximum reliability and coverage.
