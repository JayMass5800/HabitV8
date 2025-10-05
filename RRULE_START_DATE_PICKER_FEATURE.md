# RRule Start Date Picker Feature

## Overview
Added an **optional** start date picker to the RRule Builder Widget that defaults to "starting today" but allows users to customize the start date when needed. This is particularly useful for creating alternating bi-weekly schedules.

## Problem Solved
**User Scenario:** Creating two bi-weekly habits that alternate (e.g., trash collection one week, recycling collection the next week).

**Before:** 
- No way to control which week a bi-weekly pattern starts on
- Both bi-weekly habits would occur on the same weeks
- Impossible to create alternating schedules

**After:**
- Default behavior: Habits start today (no extra clicks needed!)
- **When needed:** User can customize start date with one click
- Trash habit: Start date = Monday, Jan 1
- Recycling habit: Start date = Monday, Jan 8  
- Result: Trash on odd weeks, recycling on even weeks

## Implementation Details

### Changes Made
**File:** `lib/ui/widgets/rrule_builder_widget.dart`

### 1. Added Collapsible Start Date Picker
```dart
Widget _buildStartDatePicker() {
  // Collapsed by default: Shows "Starting today" with "Customize" button
  // Expanded when needed: Full date picker with change and reset options
}
```

**Smart Defaults:**
- **Collapsed state (default):** Minimal UI, just shows "Starting today"
- **Expanded state (when customized):** Full date picker with calendar icon
- **Auto-detection:** If `initialStartDate` is not today, automatically expands
- **Reset option:** X button to quickly reset back to today

**User Flow:**
1. **Default:** User sees "Starting today" - no action needed ✓
2. **Custom needed:** Click "Customize" button
3. **Set date:** Use date picker to choose specific date
4. **Reset:** Click X to return to "starting today"

### 2. Context-Sensitive Help Text
```dart
String _getStartDateHelpText() {
  if (_frequency == HabitFrequency.weekly && _interval == 2) {
    return 'For bi-weekly patterns, the start date determines which week the pattern begins. '
        'To create alternating schedules (e.g., trash vs recycling), set different start dates.';
  } else if (_interval > 1) {
    return 'The start date anchors your pattern. For interval-based schedules, '
        'this determines the first occurrence in the cycle.';
  }
  return 'This is the first date in your recurring pattern. All future occurrences are calculated from this date.';
}
```

### 3. Integration Points
Added to **both** Simple and Advanced modes:

**Simple Mode:**
```dart
Widget _buildSimpleMode() {
  return Column(
    children: [
      _buildStartDatePicker(),  // ← NEW
      const SizedBox(height: 16),
      // ... frequency selector
    ],
  );
}
```

**Advanced Mode:**
```dart
Widget _buildAdvancedMode() {
  return Column(
    children: [
      _buildStartDatePicker(),  // ← NEW
      const SizedBox(height: 16),
      // ... frequency selector
      // ... interval selector
    ],
  );
}
```

## User Experience Flow

### Creating Alternating Bi-Weekly Habits

#### Trash Collection Habit
1. Open Create Habit screen
2. Name: "Put out trash"
3. Switch to Advanced mode (or use Custom Intervals)
4. **Set Start Date:** January 1, 2024 (Monday)
5. Frequency: Weekly
6. Interval: 2 (every 2 weeks)
7. Select days: Monday
8. Preview shows: Jan 1, Jan 15, Jan 29, Feb 12...

#### Recycling Collection Habit
1. Open Create Habit screen
2. Name: "Put out recycling"
3. Switch to Advanced mode
4. **Set Start Date:** January 8, 2024 (Monday) ← **ONE WEEK OFFSET**
5. Frequency: Weekly
6. Interval: 2 (every 2 weeks)
7. Select days: Monday
8. Preview shows: Jan 8, Jan 22, Feb 5, Feb 19...

**Result:** Trash and recycling alternate perfectly!

## Visual Design

### Collapsed State (Default)
```
┌─────────────────────────────────────────────────────────┐
│ 📅  Starting today                      [Customize]     │
└─────────────────────────────────────────────────────────┘
```

### Expanded State (After Clicking "Customize")
```
┌─────────────────────────────────────────────────────────┐
│ Start Date                                              │
│ ┌─────────────────────────────────────────────────────┐ │
│ │ 📅  Monday, January 1, 2024    [Change]  [X]        │ │
│ │     Pattern starts from this date                   │ │
│ └─────────────────────────────────────────────────────┘ │
│ ┌─────────────────────────────────────────────────────┐ │
│ │ ℹ️  For bi-weekly patterns, the start date          │ │
│ │    determines which week the pattern begins. To     │ │
│ │    create alternating schedules (e.g., trash vs     │ │
│ │    recycling), set different start dates.           │ │
│ └─────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────┘
```

**Buttons:**
- **Customize:** Expands the full date picker
- **Change:** Opens date picker dialog
- **X:** Resets to today and collapses

## Technical Notes

### Date Picker Constraints
- **First Date:** January 1, 2020
- **Last Date:** 10 years from now
- **Initial Value:** Current `_startDate` (defaults to `DateTime.now()` or `initialStartDate`)

### State Management
- Changes to start date immediately trigger `_updatePreview()`
- Preview panel updates to show new occurrence dates
- Parent widget receives updated `startDate` via `onRRuleChanged` callback

### Existing Functionality Preserved
- Widget already tracked `_startDate` internally
- Already accepted `initialStartDate` parameter
- Change: Now allows users to **modify** the start date via UI

## Benefits

### 1. Flexibility
- Default: Zero extra clicks - starts today automatically
- When needed: One-click customization for special dates
- Users can create complex alternating schedules
- No code changes needed for existing habits

### 2. User-Friendly
- Minimal UI by default (no clutter)
- Clear "Starting today" label (no confusion)
- One-click "Customize" to expand when needed
- Quick reset with X button
- Visual calendar picker (familiar Android UI)
- Context-sensitive help text guides users

### 3. Real-Time Feedback
- Preview panel immediately shows new occurrence dates
- Users can verify their pattern before saving
- Help text updates based on frequency and interval

### 4. Backward Compatible
- Existing habits continue to work
- Default start date behavior unchanged
- No breaking changes to API

## Use Cases

### 1. Alternating Bi-Weekly Schedules
- Trash vs Recycling (original request)
- Lawn mowing vs Edging
- Deep clean upstairs vs downstairs

### 2. Month-End Patterns
- Start on Jan 31 → Repeats monthly on the 31st (or last day of month)
- Useful for bills, rent, subscriptions

### 3. Specific Day Patterns
- Start on first Monday of year
- Ensures weekly pattern aligns to specific day consistently

### 4. Custom Intervals
- Every 3 days starting from specific date
- Every 4 weeks starting from project kickoff date

## Testing Recommendations

### Manual Test Scenarios
1. **Basic Weekly:** Start date today, weekly on Mon/Wed/Fri
2. **Bi-weekly Alternating:** Create two habits with 1-week offset
3. **Monthly on 31st:** Start date Jan 31, monthly pattern
4. **Yearly:** Start date Feb 29, yearly (test leap year handling)
5. **Simple Mode:** Verify picker appears in simple mode
6. **Advanced Mode:** Verify picker appears in advanced mode

### Edge Cases
- ✅ Start date in past
- ✅ Start date far in future  
- ✅ Start date = today
- ✅ Changing start date multiple times
- ✅ Preview updates correctly after change

## Future Enhancements (Optional)

### 1. Quick Offset Buttons
```dart
// Add "Today", "Tomorrow", "Next Monday" buttons
Row(
  children: [
    TextButton('Today', onPressed: () => setDate(DateTime.now())),
    TextButton('Next Mon', onPressed: () => setDate(nextMonday())),
  ],
)
```

### 2. Visual Calendar View
- Show month calendar with start date highlighted
- Allow tap-to-select date directly

### 3. Time Component
- Currently only date is used
- Could add time picker for hourly frequencies

### 4. Validation Feedback
- Warn if start date is very far in past
- Suggest better start dates for common patterns

## Summary

✅ **Implemented:** Start date picker in both Simple and Advanced modes  
✅ **Zero Errors:** Clean compilation  
✅ **Backward Compatible:** No breaking changes  
✅ **User-Friendly:** Clear UI with context-sensitive help  
✅ **Solves Real Problem:** Enables alternating bi-weekly schedules  

**Result:** Users can now easily create alternating bi-weekly habits (trash vs recycling) by setting different start dates for each habit!
