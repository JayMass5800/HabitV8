# RRule Date Offset Bug Fix

## Issue Summary
**Fixed:** Calendar/Timeline screens showing recurring habits on incorrect days (off-by-one day errors)

**Bug Report:** Habits using the new RRule logic were displaying on the wrong day slots. For example, a monthly habit set to occur on the 5th, 10th, and 15th was showing on the 4th, 5th, 9th, 10th, 14th, and 15th.

**Root Cause:** Timezone and date range handling issues in `RRuleService.isDueOnDate()` and `RRuleService.getOccurrences()` methods.

## Technical Details

### The Problem

The bug manifested in two parts:

1. **In `isDueOnDate()` (line 233-251):**
   - Created local DateTime objects for day boundaries
   - Used `dayEnd = dayStart + 1 day`, which created a range spanning into the next day
   - Example: Checking Oct 5 resulted in range Oct 5 00:00:00 → Oct 6 00:00:00

2. **In `getOccurrences()` (line 180-230):**
   - Always converted range boundaries to UTC by extracting date components
   - Always added `23:59:59` to the `rangeEnd`, even if time was already specified
   - This caused the Oct 5 check to become: Oct 5 00:00:00 UTC → Oct 6 23:59:59 UTC (nearly 2 full days!)

### The Flow of the Bug

```
User checks: "Is habit due on Oct 5?"
↓
isDueOnDate creates: dayStart = Oct 5 local, dayEnd = Oct 6 local
↓
getOccurrences converts: rangeStart = Oct 5 UTC, rangeEnd = Oct 6 23:59:59 UTC
↓
RRule package returns occurrences in that range (too wide!)
↓
Result: Shows habits from Oct 5 AND Oct 6
```

### The Fix

**File:** `lib/services/rrule_service.dart`

**Change 1 - `isDueOnDate()` method (lines 233-257):**
```dart
// BEFORE:
final dayStart = DateTime(checkDate.year, checkDate.month, checkDate.day);
final dayEnd = dayStart.add(const Duration(days: 1));

// AFTER:
final dayStartUtc = DateTime.utc(checkDate.year, checkDate.month, checkDate.day);
final dayEndUtc = DateTime.utc(checkDate.year, checkDate.month, checkDate.day, 23, 59, 59);
```

**Rationale:** 
- Start with UTC from the beginning to avoid timezone conversion issues
- Use explicit end time (23:59:59) on the SAME day, not the next day
- Ensures we're checking exactly one day's worth of time

**Change 2 - `getOccurrences()` method (lines 180-230):**
```dart
// BEFORE:
final rangeStartUtc = DateTime.utc(rangeStart.year, rangeStart.month, rangeStart.day);
final rangeEndUtc = DateTime.utc(rangeEnd.year, rangeEnd.month, rangeEnd.day, 23, 59, 59);

// AFTER:
final rangeStartUtc = rangeStart.isUtc
    ? rangeStart
    : DateTime.utc(rangeStart.year, rangeStart.month, rangeStart.day);

final rangeEndUtc = rangeEnd.isUtc
    ? rangeEnd
    : DateTime.utc(rangeEnd.year, rangeEnd.month, rangeEnd.day, 23, 59, 59);
```

**Rationale:**
- Respect UTC DateTimes that already have time components set
- Only add default time boundaries (00:00:00 and 23:59:59) for non-UTC input
- Prevents double-conversion and preserves intended time ranges

## Verification

### New Test Suite
Created `test/rrule_date_offset_bug_test.dart` with comprehensive test cases:

1. **Monthly habit test:** Verifies habits on 5th, 10th, 15th don't show on 4th, 6th, 9th, 11th, 14th, 16th
2. **Weekly habit test:** Verifies Monday-only habits don't show on Sunday or Tuesday
3. **Daily habit test:** Verifies daily habits show every day as expected
4. **Occurrence precision test:** Verifies exact dates returned by `getOccurrences()`

All tests pass ✅

### Regression Testing
All existing tests in `test/services/rrule_service_test.dart` still pass ✅

## Impact Analysis

### Files Modified
- `lib/services/rrule_service.dart` (2 methods changed)

### Affected Screens
This fix automatically corrects display issues in:
- **Calendar Screen** (`lib/ui/screens/calendar_screen.dart` line 90)
- **Timeline Screen** (`lib/ui/screens/timeline_screen.dart` line 600)
- Any other screen calling `RRuleService.isDueOnDate()`

### Breaking Changes
**None.** This is a pure bug fix with no API changes.

### Data Migration
**Not required.** The bug was in date calculation logic, not data storage.

## Testing Recommendations

### Manual Testing Checklist
- [ ] Create a monthly habit for days 5, 10, 15
- [ ] Verify Calendar shows habit ONLY on those days
- [ ] Verify Timeline shows habit ONLY on those days
- [ ] Create a weekly habit for Monday and Wednesday
- [ ] Verify Calendar shows habit ONLY on Mon/Wed
- [ ] Verify Timeline shows habit ONLY on Mon/Wed
- [ ] Create a daily habit
- [ ] Verify it shows every day on both screens
- [ ] Test across different timezones (if possible)
- [ ] Test with bi-weekly and other interval-based RRules

### Automated Testing
Run the full test suite:
```powershell
flutter test
```

Specifically verify RRule tests:
```powershell
flutter test test/services/rrule_service_test.dart
flutter test test/rrule_date_offset_bug_test.dart
```

## Notes for Developers

### Why UTC?
The `rrule` package (RFC 5545 specification) requires UTC DateTimes for consistent recurrence calculations. We normalize all date operations to UTC to avoid timezone-related bugs.

### Date-Only Comparisons
When checking if a habit is due on a date (ignoring time):
1. Extract year, month, day from the check date
2. Create UTC DateTime with those components
3. Set time boundaries explicitly (00:00:00 to 23:59:59)
4. Let RRule calculate occurrences in that precise range

### Legacy Frequency Support
The calendar and timeline screens check `habit.usesRRule` before calling these methods. If false, they fall back to legacy frequency logic (still in place and unaffected by this fix).

## Related Documentation
- `RRULE_REFACTORING_PLAN.md` - Phase 4 RRule integration status
- `RRULE_ARCHITECTURE.md` - RRule system architecture
- `DEVELOPER_GUIDE.md` - General project architecture

## Version History
- **2025-10-05:** Initial fix implemented and tested
- Bug identified in `error.md` report
- Fixed in commit [current commit]
- All tests passing on branch `feature/rrule-refactoring`
