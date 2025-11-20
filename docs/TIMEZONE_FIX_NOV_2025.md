# Timezone Handling Fix - November 2025

## Problem
Habit notifications were not firing at the correct time due to timezone conversion issues in the RRule system. The root cause was a mismatch between how `dtStart` was initialized during habit creation and how the notification scheduler interpreted that start date.

## Root Cause Analysis

### Before Fix:
1. **Habit Creation** (`create_habit_screen.dart`):
   - `dtStart` was **always** set to midnight local time: `00:00:00`
   - Example: User selects 9:00 AM notification
   - `dtStart` = `2025-11-20 00:00:00 Local` (PST)
   
2. **RRule Generation** (`rrule_service.dart`):
   - RRule generates occurrences based on `dtStart`
   - Since `dtStart` is midnight local, it converts to UTC: `2025-11-20 08:00:00 UTC` (for PST)
   
3. **Notification Scheduling** (`notification_scheduler.dart`):
   - Receives occurrence: `2025-11-20 08:00:00 UTC`
   - Checks if occurrence is midnight UTC: `NO` (it's 08:00 UTC)
   - Falls into "specific time" logic, uses occurrence time directly
   - Converts back to local: `2025-11-20 00:00:00 Local` (midnight!)
   - **Result**: Notification scheduled for midnight instead of 9:00 AM ❌

## Solution

### Fix 1: Use Notification Time for dtStart
**File**: `lib/ui/screens/create_habit_screen.dart`

Changed `_generateRRuleFromSimpleMode` to accept `notificationDateTime` parameter:

```dart
void _generateRRuleFromSimpleMode(Habit habit, DateTime? notificationDateTime) {
  // ... generate rruleString ...
  
  // CRITICAL FIX: Use notificationDateTime if available
  if (notificationDateTime != null) {
    habit.dtStart = notificationDateTime;
    AppLogger.info('✅ Using notificationDateTime for dtStart: $notificationDateTime');
  } else {
    habit.dtStart = _time.startOfDayLocal(_time.nowLocal());
    AppLogger.info('✅ Using start of day for dtStart (no notification time set)');
  }
  habit.usesRRule = true;
}
```

**Impact**: Now `dtStart` contains the actual notification time (e.g., 9:00 AM), ensuring RRule generates occurrences at the correct time.

### Fix 2: Detect Local Midnight
**File**: `lib/services/notifications/notification_scheduler.dart`

Added local midnight detection to handle timezone conversion edge cases:

```dart
// Check for both UTC midnight AND local midnight
final isMidnightUtc = occurrence.hour == 0 && occurrence.minute == 0 && ...;

// CRITICAL FIX: Also check local midnight
final localOccurrence = occurrence.toLocal();
final isMidnightLocal = localOccurrence.hour == 0 && localOccurrence.minute == 0 && ...;

if (isMidnightUtc || isMidnightLocal) {
  // Use habit's notificationTime for scheduling
  // This handles legacy habits or habits where dtStart was midnight
  ...
}
```

**Impact**: Handles edge cases where:
- Legacy habits still have midnight `dtStart`
- Advanced mode users explicitly set `dtStart` to midnight
- Timezone conversions create non-midnight UTC values from midnight local

## After Fix:
1. **Habit Creation**: 
   - `dtStart` = `2025-11-20 09:00:00 Local` (user's actual notification time)
   
2. **RRule Generation**: 
   - Occurrences generated at `2025-11-20 17:00:00 UTC` (9:00 AM PST converted)
   
3. **Notification Scheduling**: 
   - Receives occurrence: `2025-11-20 17:00:00 UTC`
   - Checks midnight: NO
   - Checks local midnight: NO (converts to 9:00 AM local)
   - Uses occurrence time directly
   - **Result**: Notification scheduled for 9:00 AM ✅

## Backward Compatibility
Both fixes ensure backward compatibility:
- **Fix 1**: Only affects new habits; existing habits retain their `dtStart`
- **Fix 2**: Adds additional check without breaking existing logic; handles both new and legacy habits

## Testing Recommendations
1. Create a new daily habit with 9:00 AM notification
2. Verify notification fires at 9:00 AM, not midnight
3. Test with different timezones
4. Test hourly and single-occurrence habits (should be unaffected)
5. Verify existing habits continue working correctly

## Files Modified
- `lib/ui/screens/create_habit_screen.dart` (Lines 1532, 1684, 1815)
- `lib/services/notifications/notification_scheduler.dart` (Lines 797-818, 863-865)

## Date
November 20, 2025
