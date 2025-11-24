# Notification/Alarm Scheduler Fix for Daily Habits

**Date:** November 24, 2025  
**Issue:** Notifications and alarms not firing for daily habits (only hourly habits worked)

## Problem Summary

Daily, weekly, monthly, yearly, and single-time habits using RRule-based scheduling were not firing notifications or alarms. Only hourly habits worked because they use a completely different code path.

## Root Cause Analysis

Three critical bugs were identified in `notification_alarm_scheduler.dart` that had already been fixed in `notification_scheduler.dart` but not in the alarm scheduler:

### Bug #1: `rangeStart` Used `now` Instead of Start of Day

**Location:** `notification_alarm_scheduler.dart:574`

```dart
// BEFORE (BROKEN)
rangeStart: now,

// AFTER (FIXED)  
final rangeStart = _time.startOfDayLocal(now);
rangeStart: rangeStart,
```

**Impact:** When creating a daily habit in the afternoon, today's occurrence was filtered out because `rangeStart` was after the midnight-based RRule occurrence.

### Bug #2: Missing `isMidnightLocal` Check

**Location:** `notification_alarm_scheduler.dart:_resolveOccurrenceDateTime`

```dart
// BEFORE (BROKEN) - Only checked UTC midnight
if (isMidnightUtc) { ... }

// AFTER (FIXED) - Checks both UTC and local midnight
final localOccurrence = occurrence.toLocal();
final isMidnightLocal = localOccurrence.hour == 0 && ...;
if (isMidnightUtc || isMidnightLocal) { ... }
```

**Impact:** When `dtStart` is set to local midnight, it converts to non-midnight UTC (e.g., midnight PST = 08:00 UTC). The alarm scheduler didn't recognize this as a "date-only" occurrence.

### Bug #3: Used UTC Date Components Instead of Local

**Location:** `notification_alarm_scheduler.dart:_resolveOccurrenceDateTime`

```dart
// BEFORE (BROKEN) - Used UTC date components
return DateTime(
  occurrence.year,   // UTC - may be wrong day!
  occurrence.month,
  occurrence.day,
  notificationTime.hour,
  notificationTime.minute,
);

// AFTER (FIXED) - Uses local date components
return DateTime(
  localOccurrence.year,   // Local - correct day
  localOccurrence.month,
  localOccurrence.day,
  notificationTime.hour,
  notificationTime.minute,
);
```

**Impact:** For users in Western Hemisphere timezones (UTC-X), midnight UTC is the previous day in local time. Using UTC date components scheduled alarms for the wrong day.

## Files Modified

1. **`lib/services/notifications/notification_alarm_scheduler.dart`**
   - Fixed `rangeStart` to use `_time.startOfDayLocal(now)` instead of `now`
   - Added `isMidnightLocal` check in `_resolveOccurrenceDateTime`
   - Changed to use `localOccurrence` date components throughout

2. **`lib/services/work_manager_habit_service.dart`**
   - Fixed `rangeStart` to use start of day
   - Changed to use `localOccurrence` when combining occurrence date with notification time

## Why Hourly Habits Worked

Hourly habits use a completely different code path (`_scheduleHourlyHabitAlarms`) that:
1. Parses time strings directly (e.g., "09:00", "14:00")
2. Uses `_getNextWeekdayDateTime()` to calculate next occurrence
3. Does NOT use `RRuleService.getOccurrences()`
4. Works correctly because it uses local time directly

## Affected Frequencies

All RRule-based frequencies are now fixed:
- ✅ Daily (FREQ=DAILY)
- ✅ Weekly (FREQ=WEEKLY;BYDAY=...)
- ✅ Monthly (FREQ=MONTHLY;BYMONTHDAY=...)
- ✅ Yearly (FREQ=YEARLY;BYMONTH=...;BYMONTHDAY=...)
- ✅ Single (one-time events)
- ✅ Hourly (already worked via different code path)

## Testing Recommendations

1. Create a new daily habit with notification time set for 5 minutes from now
2. Verify the notification fires at the scheduled time
3. Enable alarm for the habit and verify alarm fires
4. Test in different timezones (especially UTC-X like US timezones)
5. Test creating habit in afternoon vs morning
6. Test weekly/monthly/yearly habits similarly

## Related Documentation

- `docs/RRULE_ARCHITECTURE.md` - RRule system architecture
- `docs/NOTIFICATION_REFACTORING_PLAN.md` - Notification system modularization
