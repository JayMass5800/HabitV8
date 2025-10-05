# Calendar RRule dtStart Fix - Biweekly Habits Display Issue

## Issue Summary
The calendar and timeline screens were incorrectly displaying biweekly (and other interval-based) RRule habits on every day instead of the correct days. This was causing biweekly habits to appear as daily habits.

## Root Cause
The `_isHabitDueOnDate()` methods in both `calendar_screen.dart` and `timeline_screen.dart` were using `habit.createdAt` as the start date for RRule calculations instead of `habit.dtStart`.

### Why This Matters
For RRule habits (especially those with intervals), the **start date is critical** for calculating recurrence patterns:

- **`dtStart`**: The official start date of the recurrence pattern (RFC 5545 standard)
- **`createdAt`**: When the habit was first created in the database

These dates can differ, and using the wrong one causes incorrect interval calculations.

### Example of the Problem
```dart
// Biweekly habit created on Oct 1, but pattern starts on Oct 6 (Monday)
Habit(
  createdAt: DateTime(2025, 10, 1),  // Wednesday
  dtStart: DateTime(2025, 10, 6),    // Monday
  rruleString: 'FREQ=WEEKLY;INTERVAL=2;BYDAY=MO'
)

// Using createdAt (WRONG):
// Oct 1 (Wed) -> Oct 8 (Wed) -> Oct 15 (Wed) -> ...
// But Mondays would incorrectly show as due!

// Using dtStart (CORRECT):
// Oct 6 (Mon) -> Oct 20 (Mon) -> Nov 3 (Mon) -> ...
```

## Files Fixed

### 1. `lib/ui/screens/calendar_screen.dart`
**Line 87** - Changed from:
```dart
return RRuleService.isDueOnDate(
  rruleString: habit.rruleString!,
  startDate: habit.createdAt,  // ❌ WRONG
  checkDate: checkDate,
);
```

To:
```dart
// Use dtStart if available, otherwise fall back to createdAt
// This is critical for interval-based RRules (e.g., bi-weekly)
final startDate = habit.dtStart ?? habit.createdAt;
return RRuleService.isDueOnDate(
  rruleString: habit.rruleString!,
  startDate: startDate,  // ✅ CORRECT
  checkDate: checkDate,
);
```

### 2. `lib/ui/screens/timeline_screen.dart`
**Line 599** - Applied the same fix as calendar_screen.dart

### 3. Test Added: `test/services/calendar_service_rrule_test.dart`
Added comprehensive test case `isHabitDueOnDate uses dtStart instead of createdAt for RRule habits` that:
- Creates a habit where `createdAt` and `dtStart` differ
- Verifies biweekly intervals are calculated from `dtStart`, not `createdAt`
- Tests 5 different dates to ensure proper interval spacing

## Files Already Correct
The following files already had the correct implementation:
- ✅ `lib/services/calendar_service.dart` (line 195)
- ✅ `lib/services/widget_service.dart` (line 138)

## Testing
All tests pass:
```
test/services/calendar_service_rrule_test.dart: 7 tests passed
```

Including the new test case that specifically validates this fix.

## Impact
This fix resolves:
- ✅ Biweekly habits showing on every day instead of every 2 weeks
- ✅ Any interval-based RRule habits (every 2 weeks, every 3 days, etc.)
- ✅ Ensures calendar and timeline screens match the behavior of calendar_service

## Related Pattern
This is part of the consistent pattern used throughout the codebase for RRule habits:

```dart
// ALWAYS use this pattern for RRule start dates:
final startDate = habit.dtStart ?? habit.createdAt;
```

## Date: October 4, 2025
