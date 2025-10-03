# 🔄 RRule Refactoring - Quick Reference Guide

## What is RRule?

**RRule** (Recurrence Rule) is an industry-standard way to define repeating events, based on the iCalendar specification (RFC 5545). It's used by Google Calendar, Apple Calendar, Outlook, and thousands of other applications.

Instead of having separate systems for daily, weekly, monthly habits, RRule uses a single string pattern that can represent ANY recurrence pattern.

---

## Current vs. New System

### Current System ❌

```dart
// 6 different frequency types
enum HabitFrequency {
  hourly, daily, weekly, monthly, yearly, single
}

// Multiple separate fields
List<int> selectedWeekdays = [];      // For weekly
List<int> selectedMonthDays = [];     // For monthly  
List<String> hourlyTimes = [];        // For hourly
List<String> selectedYearlyDates = []; // For yearly
DateTime? singleDateTime;              // For single

// Logic scattered everywhere (30+ locations)
switch (habit.frequency) {
  case HabitFrequency.daily:
    // Check if today...
  case HabitFrequency.weekly:
    // Check if right day of week...
  case HabitFrequency.monthly:
    // Check if right day of month...
  // ... etc
}
```

**Problems:**
- 🔴 Can't do "every other week"
- 🔴 Can't do "third Tuesday of month"
- 🔴 Switch statements in 30+ files
- 🔴 Hard to maintain
- 🔴 Easy to introduce bugs
- 🔴 Difficult to add new patterns

### New System ✅

```dart
// Single recurrence system
class Habit {
  String? rruleString;       // "FREQ=WEEKLY;INTERVAL=2;BYDAY=MO,WE,FR"
  DateTime? dtStart;         // When the recurrence starts
  bool usesRRule = false;    // Migration flag
}

// Centralized logic (1 location)
bool isDue = RRuleService.isDueOnDate(
  rruleString: habit.rruleString!,
  startDate: habit.dtStart!,
  checkDate: today,
);
```

**Benefits:**
- ✅ Supports ANY pattern imaginable
- ✅ Single source of truth
- ✅ Industry standard
- ✅ Easy to test
- ✅ Easy to maintain
- ✅ Flexible and extensible

---

## RRule Pattern Examples

### Simple Patterns (Current Capabilities)

| What User Wants | Old System | New RRule String |
|----------------|------------|------------------|
| Every day | `frequency: daily` | `FREQ=DAILY` |
| Every week | `frequency: weekly` | `FREQ=WEEKLY` |
| Monday & Friday | `frequency: weekly`<br>`selectedWeekdays: [1,5]` | `FREQ=WEEKLY;BYDAY=MO,FR` |
| 15th of each month | `frequency: monthly`<br>`selectedMonthDays: [15]` | `FREQ=MONTHLY;BYMONTHDAY=15` |
| Every July 4th | `frequency: yearly`<br>`selectedYearlyDates: ['2025-07-04']` | `FREQ=YEARLY;BYMONTH=7;BYMONTHDAY=4` |
| Every hour | `frequency: hourly` | `FREQ=HOURLY` |

### Advanced Patterns (New Capabilities!)

| What User Wants | RRule String | Why It's Useful |
|----------------|--------------|-----------------|
| Every other week | `FREQ=WEEKLY;INTERVAL=2` | Bi-weekly meetings, alternating habits |
| Every 3 days | `FREQ=DAILY;INTERVAL=3` | Workout routines, medication |
| First Monday of month | `FREQ=MONTHLY;BYDAY=1MO` | Monthly reviews, bills |
| Third Tuesday of month | `FREQ=MONTHLY;BYDAY=3TU` | Book clubs, team meetings |
| Last Friday of month | `FREQ=MONTHLY;BYDAY=-1FR` | End-of-month tasks |
| Weekdays only | `FREQ=WEEKLY;BYDAY=MO,TU,WE,TH,FR` | Work-related habits |
| Every 2nd & 16th | `FREQ=MONTHLY;BYMONTHDAY=2,16` | Payday habits |
| Quarterly (every 3 months) | `FREQ=MONTHLY;INTERVAL=3` | Quarterly goals, reviews |
| Every 10 days | `FREQ=DAILY;INTERVAL=10` | Skincare, maintenance |

---

## RRule Components Explained

### Basic Structure
```
FREQ=WEEKLY;INTERVAL=2;BYDAY=MO,WE,FR;COUNT=10
│    │      │         │    │           │
│    │      │         │    │           └─ Stop after 10 occurrences
│    │      │         │    └───────────── On Monday, Wednesday, Friday
│    │      │         └────────────────── Which days
│    │      └──────────────────────────── Every 2 weeks
│    └─────────────────────────────────── Repeat weekly
└──────────────────────────────────────── Main frequency
```

### Key Components

| Component | What It Does | Values | Example |
|-----------|--------------|--------|---------|
| **FREQ** | Main frequency | HOURLY, DAILY, WEEKLY, MONTHLY, YEARLY | `FREQ=WEEKLY` |
| **INTERVAL** | Skip count (every N) | Any number (default: 1) | `INTERVAL=2` = every 2nd |
| **BYDAY** | Days of week | MO,TU,WE,TH,FR,SA,SU<br>Can have position: 1MO, -1FR | `BYDAY=MO,WE,FR`<br>`BYDAY=1MO` (1st Monday) |
| **BYMONTHDAY** | Days of month | 1-31 or -1 to -31 | `BYMONTHDAY=15` or `BYMONTHDAY=-1` (last day) |
| **BYMONTH** | Months | 1-12 | `BYMONTH=6,12` (June & December) |
| **COUNT** | Limit occurrences | Any number | `COUNT=10` (stop after 10) |
| **UNTIL** | End date | ISO date | `UNTIL=20251231T235959Z` |

### Position Numbers in BYDAY

- `1MO` = First Monday
- `2TU` = Second Tuesday  
- `3WE` = Third Wednesday
- `4TH` = Fourth Thursday
- `-1FR` = Last Friday
- `-2SA` = Second-to-last Saturday

---

## Migration Examples

### Example 1: Simple Daily Habit

**Before:**
```dart
Habit(
  name: "Drink Water",
  frequency: HabitFrequency.daily,
  createdAt: DateTime(2025, 1, 1),
)
```

**After:**
```dart
Habit(
  name: "Drink Water",
  rruleString: "FREQ=DAILY",
  dtStart: DateTime(2025, 1, 1),
  usesRRule: true,
)
```

### Example 2: Weekly Habit (Mon, Wed, Fri)

**Before:**
```dart
Habit(
  name: "Gym",
  frequency: HabitFrequency.weekly,
  selectedWeekdays: [1, 3, 5], // Monday, Wednesday, Friday
  createdAt: DateTime(2025, 1, 1),
)
```

**After:**
```dart
Habit(
  name: "Gym",
  rruleString: "FREQ=WEEKLY;BYDAY=MO,WE,FR",
  dtStart: DateTime(2025, 1, 1),
  usesRRule: true,
)
```

### Example 3: Monthly Habit (15th of month)

**Before:**
```dart
Habit(
  name: "Pay Credit Card",
  frequency: HabitFrequency.monthly,
  selectedMonthDays: [15],
  createdAt: DateTime(2025, 1, 1),
)
```

**After:**
```dart
Habit(
  name: "Pay Credit Card",
  rruleString: "FREQ=MONTHLY;BYMONTHDAY=15",
  dtStart: DateTime(2025, 1, 1),
  usesRRule: true,
)
```

### Example 4: Yearly Habit (Birthday)

**Before:**
```dart
Habit(
  name: "Mom's Birthday",
  frequency: HabitFrequency.yearly,
  selectedYearlyDates: ["2025-07-04"],
  createdAt: DateTime(2025, 1, 1),
)
```

**After:**
```dart
Habit(
  name: "Mom's Birthday",
  rruleString: "FREQ=YEARLY;BYMONTH=7;BYMONTHDAY=4",
  dtStart: DateTime(2025, 1, 1),
  usesRRule: true,
)
```

---

## Code Comparison

### Checking if Habit is Due

**Old Way (30+ similar switch statements across codebase):**

```dart
bool isHabitDueToday(Habit habit) {
  final today = DateTime.now();
  
  switch (habit.frequency) {
    case HabitFrequency.daily:
      return true;
      
    case HabitFrequency.weekly:
      final todayWeekday = today.weekday == 7 ? 0 : today.weekday;
      return habit.selectedWeekdays.contains(todayWeekday);
      
    case HabitFrequency.monthly:
      return habit.selectedMonthDays.contains(today.day);
      
    case HabitFrequency.yearly:
      return habit.selectedYearlyDates.any((dateStr) {
        final date = DateTime.parse(dateStr);
        return date.month == today.month && date.day == today.day;
      });
      
    case HabitFrequency.hourly:
      return true;
      
    case HabitFrequency.single:
      if (habit.singleDateTime != null) {
        return habit.singleDateTime!.year == today.year &&
               habit.singleDateTime!.month == today.month &&
               habit.singleDateTime!.day == today.day;
      }
      return false;
  }
}
```

**New Way (Single line!):**

```dart
bool isHabitDueToday(Habit habit) {
  if (habit.usesRRule && habit.rruleString != null) {
    return RRuleService.isDueOnDate(
      rruleString: habit.rruleString!,
      startDate: habit.dtStart ?? habit.createdAt,
      checkDate: DateTime.now(),
    );
  }
  // Legacy fallback for old habits
  return _legacyIsHabitDueToday(habit);
}
```

---

## Implementation Checklist

### Phase 0: Setup ✅
- [ ] Add `rrule` package to `pubspec.yaml`
- [ ] Create `lib/services/rrule_service.dart`
- [ ] Test basic RRule parsing
- [ ] Document RRule patterns

### Phase 1: Data Model ✅
- [ ] Add `rruleString` field to Habit
- [ ] Add `dtStart` field to Habit
- [ ] Add `usesRRule` flag to Habit
- [ ] Regenerate Hive adapters
- [ ] Test data persistence

### Phase 2: RRule Service ✅
- [ ] Implement `convertLegacyToRRule()`
- [ ] Implement `createRRule()`
- [ ] Implement `getOccurrences()`
- [ ] Implement `isDueOnDate()`
- [ ] Implement `getRRuleSummary()`
- [ ] Write comprehensive tests

### Phase 3: Service Updates ✅
- [ ] Update `habit_stats_service.dart`
- [ ] Update `calendar_service.dart`
- [ ] Update `widget_service.dart`
- [ ] Update `work_manager_habit_service.dart`
- [ ] Update `alarm_manager_service.dart`
- [ ] Update all other services

### Phase 4: UI Updates ✅
- [ ] Create `RRuleBuilderWidget`
- [ ] Update `create_habit_screen.dart`
- [ ] Update `edit_habit_screen.dart`
- [ ] Update display screens
- [ ] Add real-time preview
- [ ] Test user flows

### Phase 5: Migration ✅
- [ ] Create migration script
- [ ] Implement lazy migration
- [ ] Test with sample data
- [ ] Create backups
- [ ] Validate conversions

### Phase 6: Testing ✅
- [ ] Unit tests (95%+ coverage)
- [ ] Integration tests
- [ ] Edge case testing
- [ ] Performance testing
- [ ] User acceptance testing

### Phase 7: Launch ✅
- [ ] Beta testing
- [ ] Gradual rollout
- [ ] Monitor errors
- [ ] Gather feedback
- [ ] Final documentation

---

## Common Pitfalls & Solutions

### ⚠️ Pitfall 1: Timezone Issues
**Problem:** RRule uses UTC, but habits are local time  
**Solution:** Always convert to local timezone when displaying, store in UTC

### ⚠️ Pitfall 2: Invalid RRule Strings
**Problem:** Malformed RRule crashes app  
**Solution:** Always validate with `RRuleService.isValidRRule()` before saving

### ⚠️ Pitfall 3: Performance with Large Date Ranges
**Problem:** Generating 1000+ occurrences is slow  
**Solution:** Use pagination, cache results, limit range

### ⚠️ Pitfall 4: User Confusion
**Problem:** RRule patterns too complex for average user  
**Solution:** Provide simple presets + advanced mode

### ⚠️ Pitfall 5: Migration Errors
**Problem:** Some habits don't convert correctly  
**Solution:** Extensive testing, validation, logging, rollback mechanism

---

## Testing Strategy

### Unit Tests
```dart
test('Daily habit converts to FREQ=DAILY', () {
  final habit = Habit(frequency: HabitFrequency.daily);
  final rrule = RRuleService.convertLegacyToRRule(habit);
  expect(rrule, equals('FREQ=DAILY'));
});

test('Weekly habit with Mon/Wed/Fri converts correctly', () {
  final habit = Habit(
    frequency: HabitFrequency.weekly,
    selectedWeekdays: [1, 3, 5],
  );
  final rrule = RRuleService.convertLegacyToRRule(habit);
  expect(rrule, equals('FREQ=WEEKLY;BYDAY=MO,WE,FR'));
});

test('isDueOnDate returns true for matching date', () {
  final isDue = RRuleService.isDueOnDate(
    rruleString: 'FREQ=DAILY',
    startDate: DateTime(2025, 1, 1),
    checkDate: DateTime(2025, 10, 3),
  );
  expect(isDue, isTrue);
});
```

### Integration Tests
```dart
testWidgets('Creating habit with RRule saves correctly', (tester) async {
  // ... test widget creation flow
});

testWidgets('Migrating old habit preserves schedule', (tester) async {
  // ... test migration
});
```

### Edge Cases to Test
- [ ] Leap years (Feb 29)
- [ ] Daylight saving time transitions
- [ ] End of month (Jan 31 → Feb ?)
- [ ] Very long date ranges
- [ ] Invalid RRule strings
- [ ] Habits created before app update
- [ ] Concurrent habit modifications

---

## Resources

### Official Documentation
- **RFC 5545:** https://tools.ietf.org/html/rfc5545
- **Dart rrule package:** https://pub.dev/packages/rrule

### Tools & Validators
- **RRule Generator:** https://jkbrzt.github.io/rrule/
- **RRule Tester:** https://icalendar.org/rrule-tool.html

### Example Apps
- Google Calendar (uses RRule internally)
- Apple Calendar (iCal format)
- Outlook Calendar

---

## Support & Questions

### Common Questions

**Q: What happens to my existing habits?**  
A: They continue to work! Migration happens lazily (when you access the habit) or you can trigger it manually.

**Q: Can I still use simple daily/weekly options?**  
A: Yes! The UI will have a "Simple" mode that creates basic RRules automatically.

**Q: What if I want a really complex pattern?**  
A: The "Advanced" mode in the UI lets you build any RRule pattern supported by the standard.

**Q: Will this slow down the app?**  
A: No! RRule parsing is very fast, and we'll use caching for frequently accessed patterns.

**Q: Can I export my habits to other calendar apps?**  
A: Yes! RRule is the industry standard, so your habits can be exported to iCal format.

---

## Success Criteria

✅ **Code Quality**
- 30-40% reduction in frequency-checking code
- 95%+ test coverage
- Zero switch statements on HabitFrequency in services

✅ **Performance**
- Habit checking ≤ current speed
- Widget updates ≤ current speed
- App startup ≤ current speed

✅ **User Experience**
- All existing habits continue to work
- New patterns available to users
- Clear, understandable UI

✅ **Stability**
- Zero data loss
- < 5 bugs in first month
- 99.9%+ successful migrations

---

**Document Version:** 1.0  
**Last Updated:** October 3, 2025  
**Status:** Reference Guide
