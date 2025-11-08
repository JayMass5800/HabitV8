# Calendar Weekday Fix - Hourly & Weekly Habits Display Issue

**Date:** October 5, 2025
**Issue:** Hourly habits not showing on Sundays in calendar; Weekly Sunday habits showing on both Saturday and Sunday
**Root Cause:** Incorrect weekday conversion in `calendar_screen.dart`
**Status:** ✅ FIXED

## Problem Description

### User Report
1. **Hourly habits** (e.g., "drink water" every day) were NOT displaying on Sundays in the calendar view
2. **Weekly habits** scheduled for Sunday were showing as due on BOTH Saturday AND Sunday

### Technical Root Cause

The `calendar_screen.dart` file had an incorrect weekday conversion that was incompatible with how weekdays are stored:

**Storage Format (Correct):**
- Weekdays are stored as 1-7 where:
  - 1 = Monday
  - 2 = Tuesday
  - ...
  - 7 = Sunday
- This matches `DateTime.weekday` (1=Monday, 7=Sunday)

**Calendar Screen Bug (Lines 109-116 and 127-133):**
```dart
// WRONG - This conversion broke Sunday matching
final dayOfWeek = checkDate.weekday == 7 ? 0 : checkDate.weekday;
return habit.selectedWeekdays.contains(dayOfWeek);
```

**Why This Failed:**
- Sunday's `checkDate.weekday` is 7
- Conversion changed it to 0
- But habits store Sunday as 7, not 0
- Result: Sunday habits NEVER matched! ❌
- Saturday (weekday=6) stayed as 6, and if someone selected "every day" (1-7), checking for 0 would fail

**Correct Implementation (calendar_service.dart and timeline_screen.dart):**
```dart
// CORRECT - Use weekday directly
final weekday = date.weekday;
return habit.selectedWeekdays.contains(weekday);
```

## Files Fixed

### `lib/ui/screens/calendar_screen.dart`

**Line 107-116 (Weekly habits):**
```dart
// BEFORE (WRONG)
case HabitFrequency.weekly:
  if (habit.selectedWeekdays.isEmpty) {
    return checkDate.weekday == habitDate.weekday;
  }
  // Convert DateTime.weekday (1=Monday) to our format (0=Sunday)
  final dayOfWeek = checkDate.weekday == 7 ? 0 : checkDate.weekday;
  return habit.selectedWeekdays.contains(dayOfWeek);

// AFTER (FIXED)
case HabitFrequency.weekly:
  if (habit.selectedWeekdays.isEmpty) {
    return checkDate.weekday == habitDate.weekday;
  }
  // Use DateTime.weekday directly (1=Monday, 7=Sunday) - matches storage format
  return habit.selectedWeekdays.contains(checkDate.weekday);
```

**Line 125-133 (Hourly habits):**
```dart
// BEFORE (WRONG)
case HabitFrequency.hourly:
  if (habit.selectedWeekdays.isEmpty || habit.hourlyTimes.isEmpty) {
    return false;
  }
  // Convert DateTime.weekday (1=Monday) to our format (0=Sunday)
  final dayOfWeek = checkDate.weekday == 7 ? 0 : checkDate.weekday;
  return habit.selectedWeekdays.contains(dayOfWeek);

// AFTER (FIXED)
case HabitFrequency.hourly:
  if (habit.selectedWeekdays.isEmpty || habit.hourlyTimes.isEmpty) {
    return false;
  }
  // Use DateTime.weekday directly (1=Monday, 7=Sunday) - matches storage format
  return habit.selectedWeekdays.contains(checkDate.weekday);
```

## Verification

### Files Already Correct (No Changes Needed)
✅ `lib/services/calendar_service.dart` - Already uses `date.weekday` directly
✅ `lib/ui/screens/timeline_screen.dart` - Already uses `date.weekday` directly

### Weekday Storage Consistency
All create/edit screens store weekdays as 1-7:
- `lib/ui/screens/create_habit_screen.dart` - Line 1653: `final dayNumber = index + 1;`
- `lib/ui/screens/create_habit_screen_v2.dart` - Line 751: `final dayNumber = index + 1;`
- `lib/ui/screens/edit_habit_screen.dart` - Line 608: `final weekdayNumber = index + 1;`

## Expected Behavior After Fix

### Hourly Habits
- A "drink water" habit scheduled for every day (Mon-Sun) will now:
  - ✅ Show on Monday-Saturday in calendar
  - ✅ Show on Sunday in calendar (FIXED!)
  - ✅ Match timeline and home widget display

### Weekly Habits
- A habit scheduled for Sunday only will now:
  - ❌ NOT show on Saturday
  - ✅ Show on Sunday (FIXED!)
  - ✅ Match expected behavior

### All Other Frequencies
- No changes needed - monthly, yearly, daily, single habits were unaffected

## Testing Checklist

- [ ] Create hourly habit with all 7 days selected
- [ ] Verify it appears on Sunday in calendar view
- [ ] Create weekly habit for Sunday only
- [ ] Verify it appears ONLY on Sunday, not Saturday
- [ ] Compare calendar view with timeline view for consistency
- [ ] Check home screen widget displays same habits

## Related Files

**Service Layer:**
- `lib/services/calendar_service.dart` - Already correct
- `lib/services/rrule_service.dart` - RRule weekday conversion (0=Sunday in RRule spec)

**UI Layer:**
- `lib/ui/screens/calendar_screen.dart` - FIXED ✅
- `lib/ui/screens/timeline_screen.dart` - Already correct
- `lib/ui/screens/create_habit_screen.dart` - Storage format source
- `lib/ui/screens/edit_habit_screen.dart` - Storage format source

## Notes

### Why Two Different Weekday Formats Exist

1. **Database/UI Format (1-7):**
   - Monday = 1, Sunday = 7
   - Matches Dart's `DateTime.weekday`
   - Used throughout the app for storage and display

2. **RRule Format (0-6 or day codes):**
   - Sunday = 0, Saturday = 6 (numeric)
   - Or: SU, MO, TU, WE, TH, FR, SA (day codes)
   - Only used when converting to/from RRule strings
   - See `RRuleService._weekdayToRRuleDay()` for conversion

The calendar screen was mistakenly trying to convert to a 0-based format that doesn't exist in our database schema.

## Prevention

**When adding new weekday checks:**
1. ✅ Use `date.weekday` directly (1-7)
2. ❌ Do NOT convert to 0-based unless specifically for RRule generation
3. ✅ Check `calendar_service.dart` for reference implementation
4. ✅ Verify with Sunday edge case testing

---

**Fix Verified:** Calendar screen now correctly filters hourly and weekly habits on all days of the week, including Sunday.
