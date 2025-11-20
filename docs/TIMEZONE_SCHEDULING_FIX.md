# Timezone Scheduling Fix - November 19, 2025

## Issue Summary
Notifications and alarms were not firing due to:
1. TZDateTime incompatibility with `awesome_notifications` plugin (FIXED)
2. **NEW:** Incorrect dtStart time causing RRule to miss occurrences
3. **NEW:** rangeStart filtering out today's occurrences

## Root Causes

### Issue 1: TZDateTime Incompatibility (FIXED)
The `TimeService.toLocal()` method returns `TZDateTime` objects, but `NotificationCalendar.fromDate()` expects regular `DateTime` objects in local time. The plugin was misinterpreting `TZDateTime` as UTC, causing double timezone conversion and resulting in scheduled times that were in the past or incorrect.

### Issue 2: dtStart Set to Current Time Instead of Start of Day (FIXED)
When creating a new habit in simple mode, `dtStart` was set to `_time.nowLocal()` (e.g., 3:00 PM). If the notification time was earlier (e.g., 2:00 PM), RRule wouldn't find any occurrences for today because dtStart was after the notification time.

**Example:**
- Create habit at 3:00 PM
- Set notification time to 2:00 PM
- dtStart = 3:00 PM
- RRule looks for occurrences starting from 3:00 PM
- ❌ Misses the 2:00 PM occurrence today

### Issue 3: rangeStart Filtering Out Today's Future Occurrences (FIXED)
The `rangeStart` parameter in `getOccurrences()` was set to `now` (current time), which filtered out any occurrences earlier in the day, even if they were in the future after applying the notification time.

**Example:**
- Current time: 3:00 PM
- Habit created with notification at 8:00 PM today
- rangeStart = 3:00 PM (current time)
- RRule finds occurrence at midnight (date only)
- _resolveOccurrenceDateTime converts midnight → 8:00 PM today
- But rangeStart was checking against midnight, not 8:00 PM
- Result: Works, but inefficient and confusing

The fix changes rangeStart to start of today, so we get all of today's date-only occurrences, then filter by actual scheduled time.

## Files Modified

### 1. `lib/services/notifications/notification_scheduler.dart`
**Line ~47-120**: Added conversion from TZDateTime to regular DateTime before scheduling
**Line ~718-730**: Fixed rangeStart to use start of today instead of current time

```dart
// CRITICAL FIX: Start looking from the beginning of today, not from now
// This ensures we find occurrences today even if their notification time has passed
// The isAfter(now) check below will filter out past times
final rangeStart = _time.startOfDayLocal(now);
```
```dart
// Convert TZDateTime to regular DateTime for awesome_notifications compatibility
final scheduledDateTime = DateTime(
  localScheduledTime.year,
  localScheduledTime.month,
  localScheduledTime.day,
  localScheduledTime.hour,
  localScheduledTime.minute,
  localScheduledTime.second,
  localScheduledTime.millisecond,
  localScheduledTime.microsecond,
);
```

### 2. `lib/services/alarm_service.dart`
**Line ~562**: Converted scheduledTime to regular DateTime before creating alarm notification
```dart
schedule: NotificationCalendar.fromDate(
  date: DateTime(
    scheduledTime.year,
    scheduledTime.month,
    scheduledTime.day,
    scheduledTime.hour,
    scheduledTime.minute,
    scheduledTime.second,
    scheduledTime.millisecond,
    scheduledTime.microsecond,
  ),
  allowWhileIdle: true,
  preciseAlarm: true,
  repeats: false,
),
```

### 3. `lib/services/notifications/notification_action_handler.dart`
**Two locations (~632 and ~809)**: Fixed snooze notification scheduling with DateTime conversion

### 4. `lib/ui/screens/create_habit_screen.dart` (NEW FIX)
**Line ~1821**: Fixed dtStart to use start of day instead of current time
```dart
// CRITICAL FIX: dtStart should be start of today, not current time
// This ensures RRule finds occurrences today even if notification time has passed
habit.dtStart = _time.startOfDayLocal(_time.nowLocal());
```

## Testing Instructions

### 1. Rebuild and Install
```powershell
flutter clean
flutter pub get
flutter build apk --release
# Or use the quick build script:
.\quick_build.bat
```

### 2. Test Notification Habit
1. Create a new habit with notifications enabled
2. Set notification time to 2-3 minutes from now
3. Wait for notification to fire
4. Expected: Notification appears at scheduled time with action buttons

### 3. Test Alarm Habit
1. Create a new habit with alarm enabled
2. Set alarm time to 2-3 minutes from now
3. Wait for alarm to fire
4. Expected: Full-screen alarm appears with sound and action buttons

### 4. Verify with ADB
```powershell
# Check scheduled alarms
adb shell dumpsys alarm | Select-String "habitv8"

# Check app logs
adb logcat -s flutter:I | Select-String "notification|alarm|schedule"
```

## Technical Details

### Why This Fix Works
1. **Regular DateTime** objects have no timezone metadata
2. **awesome_notifications** correctly interprets regular DateTime as local device time
3. No double conversion occurs
4. Scheduled times fire at the intended local time

### Timezone Flow (After Fix)
```
User selects time (e.g., 2:00 PM) 
  → Stored as DateTime with hour=14, minute=0
  → TimeService.toLocal() converts to TZDateTime (preserves 2:00 PM local)
  → NEW: Convert TZDateTime to regular DateTime(14, 0, ...)
  → NotificationCalendar.fromDate() schedules for 2:00 PM local
  → ✅ Notification fires at 2:00 PM
```

### Timezone Flow (Before Fix - BROKEN)
```
User selects time (e.g., 2:00 PM)
  → Stored as DateTime with hour=14, minute=0
  → TimeService.toLocal() converts to TZDateTime (preserves 2:00 PM local)
  → ❌ NotificationCalendar.fromDate() misinterprets TZDateTime as UTC
  → ❌ Plugin applies timezone offset again (e.g., -5 hours)
  → ❌ Notification scheduled for 9:00 AM (in the past!)
  → ❌ Notification never fires
```

## Related Issues
- Affects all notification scheduling paths
- Affects all alarm scheduling paths
- Affects snooze functionality
- Does NOT affect completion tracking or streak calculations (those use TimeService correctly)

## Future Considerations
Consider updating `TimeService` to provide a `toNativeDateTime()` method that explicitly returns regular DateTime for plugin compatibility:

```dart
/// Convert to regular DateTime (no timezone metadata) for plugin compatibility
DateTime toNativeDateTime(DateTime dateTime) {
  final local = toLocal(dateTime);
  return DateTime(
    local.year,
    local.month,
    local.day,
    local.hour,
    local.minute,
    local.second,
    local.millisecond,
    local.microsecond,
  );
}
```

This would make the intent clear and reduce the chance of future bugs.

## Verification Checklist
- [x] notification_scheduler.dart updated (TZDateTime conversion)
- [x] notification_scheduler.dart updated (rangeStart fix)
- [x] alarm_service.dart updated
- [x] notification_action_handler.dart updated (2 locations)
- [x] create_habit_screen.dart updated (dtStart fix)
- [x] No compilation errors
- [ ] Tested notification habit (2-3 min delay)
- [ ] Tested alarm habit (2-3 min delay)
- [ ] Tested creating habit after notification time has passed today
- [ ] Verified with adb dumpsys alarm
- [ ] Checked app logs for scheduling confirmation
