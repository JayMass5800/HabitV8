# RRule Builder Widget Simplification Plan

## Problem Statement

The current RRuleBuilderWidget has multiple confusing layers:
1. **Level 1:** Simple mode with basic frequency options  
2. **Level 2:** Advanced mode with dropdown frequency selector
3. **Level 3:** Inside CreateHabitScreen with another "Advanced Mode" toggle
4. **Result:** Users are confused by nested modes and can't find options easily

## Proposed Solution: Single-Screen Interface

Replace the multi-mode approach with a **single, clear screen** that shows all options organized in logical sections.

---

## New User Interface Design

### Section 1: Frequency Selection
**Header:** "Repeats"  
**UI:** Choice chips (not dropdown)
```
[Daily] [Weekly] [Monthly] [Yearly]
```

### Section 2: Interval (Always Visible)
**Header:** "Frequency"  
**Quick Select Chips:** Context-aware based on frequency
```
For Daily:   [Every day] [Every 2 days] [Every 3 days]
For Weekly:  [Every week] [Bi-weekly] [Every 3 weeks]  
For Monthly: [Every month] [Every 2 months] [Every 3 months]
For Yearly:  [Every year] [Every 2 years]
```

**Custom Input:** "Or every [___] day(s)/week(s)/month(s)/year(s)"
- Text field with number input
- Shows examples below: "Examples: Every 2 days, Every 3 days, etc."

### Section 3: Frequency-Specific Options (Conditional)

#### If Weekly Selected:
**Header:** "On which days?"
```
[Mon] [Tue] [Wed] [Thu] [Fri] [Sat] [Sun]
```
Error state: "Select at least one day" (if none selected)

#### If Monthly Selected:
**Header:** "Monthly Pattern"
**Tab Selector:** 
```
[Specific Days] [By Position]
```

**If "Specific Days" tab:**
```
Select days of the month (1-31):
[1] [2] [3] ... [30] [31]
(Grid layout, 7 columns)

Selected: 1, 15, 28
```

**If "By Position" tab:**
```
Position: [Dropdown: 1st, 2nd, 3rd, 4th, Last]
Day:      [Dropdown: Monday, Tuesday, ..., Sunday]

ℹ️ Example: "2nd Tuesday" means the second Tuesday of each month
```

#### If Yearly Selected:
**Header:** "Yearly Date"
```
Month: [Dropdown: January, February, ..., December]
Day:   [Dropdown: 1, 2, ..., 31] (adjusted based on month)
```

### Section 4: Termination Options
**Header:** "Ends"  
**Segmented Button:**
```
[Never] [After] [On Date]
```

**If "After" selected:**
```
After [___] occurrences
```

**If "On Date" selected:**
```
[Date Picker Button]
Until: Oct 4, 2026
```

### Section 5: Preview (Always Visible at Bottom)
```
┌─────────────────────────────────────┐
│ 🔍 Preview                          │
│                                     │
│ Every 2 weeks on Monday and Friday  │
│                                     │
│ Next occurrences:                   │
│ • Monday, Oct 7, 2025               │
│ • Friday, Oct 11, 2025              │
│ • Monday, Oct 21, 2025              │
│ • Friday, Oct 25, 2025              │
│ • Monday, Nov 4, 2025               │
└─────────────────────────────────────┘
```

---

## Implementation Strategy

### Option 1: Complete Rewrite (Recommended)
**Pros:**
- Clean slate, no legacy code
- Optimized for new single-screen design
- Easier to maintain

**Cons:**
- Requires thorough testing
- More upfront work

**Approach:**
1. Create `rrule_builder_widget_v2.dart`
2. Test thoroughly with all frequency combinations
3. Update `create_habit_screen_v2.dart` to use new widget
4. Archive old widget

### Option 2: Incremental Refactoring
**Pros:**
- Lower risk of breaking existing functionality
- Can test changes incrementally

**Cons:**
- Messy intermediate states
- More complex to manage

**Approach:**
1. Remove the `_isAdvancedMode` toggle and related logic
2. Flatten the `build()` method to show all sections
3. Remove `forceAdvancedMode` parameter (keep for backward compat but ignore)
4. Simplify conditional rendering

---

## Key Simplifications

### 1. Remove Mode Toggle Completely
```dart
// OLD - Confusing
Widget build(BuildContext context) {
  return Column(
    children: [
      _buildModeToggle(),
      if (_isAdvancedMode) 
        _buildAdvancedMode()
      else
        _buildSimpleMode(),
    ],
  );
}

// NEW - Clear
Widget build(BuildContext context) {
  return Column(
    children: [
      _buildFrequencySelector(),
      _buildIntervalSelector(),
      if (_frequency == HabitFrequency.weekly) _buildWeekdaySelector(),
      if (_frequency == HabitFrequency.monthly) _buildMonthlySelector(),
      if (_frequency == HabitFrequency.yearly) _buildYearlySelector(),
      _buildTerminationSelector(),
      _buildPreview(),
    ],
  );
}
```

### 2. Use Choice Chips Instead of Dropdown for Frequency
```dart
// OLD - Hidden in dropdown
DropdownButtonFormField<HabitFrequency>(...)

// NEW - Visible chips
Wrap(
  children: [
    ChoiceChip(label: Text('Daily'), selected: _frequency == HabitFrequency.daily, ...),
    ChoiceChip(label: Text('Weekly'), selected: _frequency == HabitFrequency.weekly, ...),
    ChoiceChip(label: Text('Monthly'), selected: _frequency == HabitFrequency.monthly, ...),
    ChoiceChip(label: Text('Yearly'), selected: _frequency == HabitFrequency.yearly, ...),
  ],
)
```

### 3. Add Quick-Select Interval Chips
```dart
Widget _buildIntervalSelector() {
  return Column(
    children: [
      // Quick select buttons
      Wrap(
        children: [
          _buildIntervalChip(1, 'Every ${frequency.toLowerCase()}'),
          if (_frequency == HabitFrequency.daily) _buildIntervalChip(2, 'Every 2 days'),
          if (_frequency == HabitFrequency.weekly) _buildIntervalChip(2, 'Bi-weekly'),
          // ... more quick selects
        ],
      ),
      // Custom input
      Row(
        children: [
          Text('Or every'),
          SizedBox(width: 80, child: TextFormField(...)),
          Text(unit),
        ],
      ),
    ],
  );
}
```

### 4. Improve Monthly Pattern Selector
```dart
// Use SegmentedButton for clearer pattern selection
SegmentedButton<_MonthlyPatternType>(
  segments: [
    ButtonSegment(
      value: _MonthlyPatternType.onDays,
      label: Text('Specific Days'),
      icon: Icon(Icons.calendar_today),
    ),
    ButtonSegment(
      value: _MonthlyPatternType.onPosition,
      label: Text('By Position'),
      icon: Icon(Icons.event_repeat),
    ),
  ],
  selected: {_monthlyPatternType},
  onSelectionChanged: (selection) => setState(() => _monthlyPatternType = selection.first),
)
```

---

## Update to CreateHabitScreen

### Remove Advanced Mode Toggle
Since the RRuleBuilderWidget now handles everything in a single screen, we don't need the "Advanced Mode" toggle in CreateHabitScreen.

```dart
// OLD - create_habit_screen_v2.dart
if (_useAdvancedMode) {
  _buildAdvancedModeUI() // Shows RRuleBuilderWidget
} else {
  _buildSimpleUI() // Shows basic frequency UI
}

// NEW - create_habit_screen_v2.dart
// Just use RRuleBuilderWidget directly for all advanced patterns
// Remove _useAdvancedMode boolean and toggle completely
```

### Update Info Banner
```dart
// OLD
'Advanced mode: Create complex patterns like "every 2 weeks", "every 3rd day", ...'

// NEW (or remove completely since it's self-explanatory now)
'Create custom schedules: Choose frequency, set intervals, pick specific days, and more.'
```

---

## Testing Checklist

### Basic Frequency Tests
- [ ] Daily → Shows interval selector
- [ ] Weekly → Shows interval selector + weekday chips
- [ ] Monthly → Shows interval selector + pattern tabs (days/position)
- [ ] Yearly → Shows interval selector + month/day dropdowns

### Interval Tests
- [ ] Quick select chip updates interval correctly
- [ ] Custom input field updates interval correctly
- [ ] Interval displays correctly in preview

### Weekly Pattern Tests
- [ ] Can select multiple weekdays
- [ ] Error shows when no weekdays selected
- [ ] Preview shows correct days

### Monthly Pattern Tests
- [ ] "Specific Days" tab shows day grid (1-31)
- [ ] Can select multiple days
- [ ] Selected days display below grid
- [ ] "By Position" tab shows position + weekday dropdowns
- [ ] Position preview updates correctly

### Yearly Pattern Tests
- [ ] Month dropdown shows all 12 months
- [ ] Day dropdown adjusts to month (28/29/30/31 days)
- [ ] February handles leap years correctly

### Termination Tests
- [ ] "Never" selected by default
- [ ] "After" shows count input
- [ ] "On Date" shows date picker
- [ ] Preview respects termination setting

### Preview Tests
- [ ] Shows human-readable summary
- [ ] Shows next 5 occurrences
- [ ] Updates in real-time as options change
- [ ] Handles edge cases (Feb 29, last day of month, etc.)

---

## Migration Path

### Phase 1: Create New Widget (Day 1)
1. Create `rrule_builder_widget_v2.dart` with simplified design
2. Keep old widget intact
3. Test new widget in isolation

### Phase 2: Switch CreateHabitScreen (Day 2)
1. Update `create_habit_screen_v2.dart` to import new widget
2. Remove "Advanced Mode" toggle
3. Simplify _buildAdvancedModeUI()
4. Test habit creation flow

### Phase 3: Cleanup (Day 3)
1. Rename `rrule_builder_widget.dart` → `rrule_builder_widget_old.dart.bak`
2. Rename `rrule_builder_widget_v2.dart` → `rrule_builder_widget.dart`
3. Remove _useAdvancedMode from CreateHabitScreen state
4. Full regression testing

---

## Benefits Summary

✅ **User-Friendly:** Single screen, no hidden modes  
✅ **Clear Layout:** Logical sections, easy to scan  
✅ **Quick Selection:** Chips for common intervals (bi-weekly, every 2 days)  
✅ **Real-Time Feedback:** Preview updates as you make changes  
✅ **Less Cognitive Load:** No "simple vs advanced" mental model  
✅ **Better Discovery:** All options visible, no need to hunt through menus  
✅ **Consistent:** Same interface for all frequencies  

---

## Code Size Comparison

**Old Approach:**
- `_buildSimpleMode()`: ~80 lines
- `_buildAdvancedMode()`: ~120 lines
- Mode toggle logic: ~30 lines
- **Total:** ~230 lines + complexity

**New Approach:**
- `build()`: ~30 lines (just structure)
- `_buildFrequencySelector()`: ~40 lines
- `_buildIntervalSelector()`: ~60 lines (with quick selects)
- `_buildWeekdaySelector()`: ~30 lines
- `_buildMonthlySelector()`: ~80 lines
- `_buildYearlySelector()`: ~40 lines
- `_buildTerminationSelector()`: ~50 lines
- `_buildPreview()`: ~50 lines
- **Total:** ~380 lines, but **much clearer** and **easier to maintain**

---

## Next Steps

1. **Decision:** Choose Option 1 (Complete Rewrite) or Option 2 (Incremental)
2. **Implementation:** Create new widget file
3. **Testing:** Verify all frequency combinations
4. **Integration:** Update CreateHabitScreen
5. **Documentation:** Update DEVELOPER_GUIDE.md with new approach
