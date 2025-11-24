# Import Fix for Timezone Handling - November 2025

## Problem
After implementing the timezone fix (dtStart alignment with notificationTime), imported habits were not working correctly. Non-hourly habits that were exported before the timezone fix had `dtStart` set to midnight, causing notifications to still fire at incorrect times after import.

## Root Cause
The timezone fix introduced in `TIMEZONE_FIX_NOV_2025.md` changed how new habits are created:
- **New behavior**: `dtStart` is set to the actual `notificationTime` (e.g., 9:00 AM)
- **Old behavior**: `dtStart` was always set to midnight (00:00)

When importing habits that were exported with the old behavior:
1. Habit has `usesRRule=true`, `rruleString` set, `dtStart=00:00`, `notificationTime=09:00`
2. RRule generates occurrences based on `dtStart=00:00` → converts to UTC (e.g., 08:00 UTC for PST)
3. New timezone detection sees "local midnight" and uses `notificationTime`
4. But the mismatch still causes scheduling issues

## Solution
Added post-import correction logic to align `dtStart` with `notificationTime` for imported RRule habits.

### Implementation
**File**: `lib/services/data_export_import_service.dart`

Added correction logic in both import paths:
1. **JSON Import** (`_createHabitFromJson` method)
2. **CSV Import** (`_createHabitFromCsvRow` method)

```dart
// CRITICAL FIX: Imported habits may have dtStart=midnight from old logic
// If habit uses RRule and has notificationTime, align dtStart with notificationTime
// This ensures the timezone fix works correctly for imported habits
if (habit.usesRRule &&
    habit.notificationTime != null &&
    habit.frequency != HabitFrequency.hourly &&
    habit.frequency != HabitFrequency.single) {
  // Check if dtStart is at midnight (old behavior)
  final dtStartLocal = habit.dtStart?.toLocal();
  if (dtStartLocal != null &&
      dtStartLocal.hour == 0 &&
      dtStartLocal.minute == 0) {
    // Align dtStart with notificationTime to match new creation logic
    final notifTime = habit.notificationTime!;
    habit.dtStart = DateTime(
      dtStartLocal.year,
      dtStartLocal.month,
      dtStartLocal.day,
      notifTime.hour,
      notifTime.minute,
    );
    AppLogger.info(
      'Import fix: Aligned dtStart with notificationTime for habit: ${habit.name} '
      '(${notifTime.hour}:${notifTime.minute})',
    );
  }
}
```

### Logic Flow
1. **Check if habit qualifies for fix**:
   - Uses RRule system (`usesRRule=true`)
   - Has notification time set (`notificationTime != null`)
   - Not hourly or single occurrence (these use different logic)

2. **Check if dtStart needs correction**:
   - Convert `dtStart` to local time
   - Check if it's exactly midnight (00:00:00)

3. **Apply correction**:
   - Create new `dtStart` with:
     - Same date as original `dtStart`
     - Hour and minute from `notificationTime`
   - This aligns imported habits with new creation logic

### Example
**Before fix**:
- Exported habit: `dtStart=2025-11-20 00:00:00 Local`, `notificationTime=2025-11-20 09:00:00`
- After import: Still `dtStart=00:00`, causing midnight notifications

**After fix**:
- Exported habit: `dtStart=2025-11-20 00:00:00 Local`, `notificationTime=2025-11-20 09:00:00`
- After import: `dtStart=2025-11-20 09:00:00 Local` (automatically corrected)
- Notifications fire at 9:00 AM ✅

## Scope
This fix applies to:
- ✅ JSON imports
- ✅ CSV imports
- ✅ All non-hourly, non-single RRule habits
- ✅ Habits with both `usesRRule=true` and `notificationTime` set

Does NOT affect:
- ❌ Hourly habits (use different scheduling logic)
- ❌ Single occurrence habits (use `singleDateTime`)
- ❌ Habits without notifications
- ❌ Legacy habits not using RRule system

## Backward Compatibility
- Habits exported with new logic (dtStart already aligned): No change, correction skips them
- Habits exported with old logic (dtStart=midnight): Automatically corrected on import
- Habits without RRule: Unaffected, use legacy frequency system

## Testing Recommendations
1. Export habits created before timezone fix
2. Import them into app with fix applied
3. Verify notifications fire at correct time (not midnight)
4. Test both JSON and CSV import paths
5. Test with different timezones
6. Verify hourly and single habits still work

## Files Modified
- `lib/services/data_export_import_service.dart`:
  - `_createHabitFromJson` (lines ~870-900)
  - `_createHabitFromCsvRow` (lines ~1070-1100)

## Related Fixes
- See `TIMEZONE_FIX_NOV_2025.md` for the original timezone handling fix
- This fix complements the original by ensuring imported habits work correctly

## Date
November 21, 2025
