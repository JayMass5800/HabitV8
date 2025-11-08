# Edit Habit Screen - RRule Integration & Notification Reorganization

## Overview
Updated `edit_habit_screen.dart` to match all UX improvements from `create_habit_screen_v2.dart`, including RRule custom scheduling capabilities and reorganized notification section.

## Changes Applied

### 1. Notification Section Reorganization
**Location**: `_buildNotificationSection()` method

**Changes**:
- **Section Title**: Changed from "Notifications" to "Notifications & Alarms" (unified section)
- **Time Selector First**: Alarm/notification time picker now appears FIRST (before toggles)
- **Dynamic Label**: Shows "Alarm Time" when alarms enabled, "Notification Time" when notifications enabled
- **Removed Divider**: Eliminated separate "Alarm Settings" subsection - all in one unified flow
- **Mutual Exclusivity**: Both toggles now properly disable each other when enabled

**New Order**:
1. Section title: "Notifications & Alarms"
2. Time selector (when enabled) - **NOW FIRST**
3. Hourly habits info banner (when applicable)
4. Enable Notifications toggle
5. Enable Alarms toggle
6. Alarm sound picker (conditionally shown)
7. Permissions warning banner (when alarms enabled)

**Benefit**: Alarm time selector is now always visible when alarms are enabled - no more hidden UI!

### 2. RRule Custom Scheduling Integration
**Location**: `_buildFrequencySection()` method and new helper methods

**New Features**:
- **Advanced Mode Toggle**: Added "Custom Schedules" button (matches create screen)
  - Simple mode: Shows legacy chip-based frequency selector
  - Advanced mode: Shows RRuleBuilderWidget with full custom scheduling
- **State Variables Added**:
  ```dart
  bool _useAdvancedMode = false;
  String? _rruleString;
  late DateTime _rruleStartDate;
  ```
- **Initialization**: RRule state loaded from existing habit data in `initState()`
  ```dart
  _rruleString = widget.habit.rruleString;
  _rruleStartDate = widget.habit.dtStart ?? DateTime.now();
  _useAdvancedMode = widget.habit.usesRRule; // Auto-show advanced mode for RRule habits
  ```

**New UI Methods**:
1. `_buildSimpleModeWithFrequencySelector()`: Wraps existing frequency chip UI
2. `_buildSimpleModeUI()`: Contains all frequency-specific UI (weekly/monthly/yearly/etc)
3. `_buildAdvancedModeUI()`: Shows RRuleBuilderWidget with info banner

**RRuleBuilderWidget Integration**:
```dart
RRuleBuilderWidget(
  initialRRuleString: _rruleString,
  initialStartDate: _rruleStartDate,
  initialFrequency: _selectedFrequency,
  forceAdvancedMode: true, // Show all options immediately
  onRRuleChanged: (rruleString, startDate) {
    setState(() {
      _rruleString = rruleString;
      _rruleStartDate = startDate;
    });
  },
)
```

### 3. Save Logic Updates
**Location**: `_saveHabit()` method

**Added RRule Persistence**:
```dart
// Save RRule data if using advanced mode
if (_useAdvancedMode && _rruleString != null) {
  widget.habit.rruleString = _rruleString;
  widget.habit.dtStart = _rruleStartDate;
  widget.habit.usesRRule = true;
  debugPrint('✅ Saving habit with custom RRule: $_rruleString');
}
```

**Updated Auto-Upgrade Logic**:
- Now skips RRule auto-generation if user is already using custom RRule (`!_useAdvancedMode`)
- Prevents overwriting user's custom schedules with auto-generated simple RRules

### 4. Import Added
```dart
import '../widgets/rrule_builder_widget.dart';
```

## User Experience Improvements

### Before:
- ❌ Alarm time selector hidden when alarms enabled (catch-22)
- ❌ No way to edit RRule-based habits with custom schedules
- ❌ Editing RRule habit would show simple mode and potentially overwrite custom schedule
- ❌ Confusing separate "Alarm Settings" section

### After:
- ✅ Alarm time selector always visible first
- ✅ Can toggle between Simple and Custom Schedules modes
- ✅ RRule habits automatically open in advanced mode
- ✅ Custom RRule schedules preserved and editable
- ✅ Unified "Notifications & Alarms" section with logical flow
- ✅ Feature parity with create screen

## Technical Details

### RRule Habit Detection
When editing an existing RRule habit:
1. `_useAdvancedMode` initialized to `widget.habit.usesRRule`
2. If true, advanced mode UI shown automatically
3. User can see and edit their custom RRule schedule
4. Switching back to simple mode won't overwrite RRule (save logic checks `_useAdvancedMode`)

### Backward Compatibility
- Simple mode still uses legacy frequency system (chips + conditional UI)
- Auto-upgrade to RRule only occurs for non-RRule habits in simple mode
- Legacy `selectedWeekdays`, `selectedMonthDays`, etc. still saved for compatibility
- RRule data saved alongside legacy data

### Validation
- Existing validation for weekly/monthly/yearly/hourly/single habits unchanged
- RRule validation handled within RRuleBuilderWidget
- No additional validation needed for custom RRule schedules

## Testing Recommendations

1. **Edit RRule Habit**:
   - Open habit created with custom schedule in create screen
   - Verify advanced mode shown automatically
   - Verify RRule preview matches expected pattern
   - Edit schedule and save
   - Verify changes persist

2. **Edit Legacy Habit**:
   - Open habit created before RRule integration
   - Verify simple mode shown by default
   - Toggle to advanced mode
   - Create custom schedule and save
   - Verify habit now uses RRule

3. **Alarm Time Visibility**:
   - Create habit with alarm enabled
   - Edit habit
   - Verify alarm time selector visible immediately (no scrolling needed)

4. **Mode Switching**:
   - Edit any habit
   - Toggle between Simple and Custom Schedules
   - Verify UI changes appropriately
   - Save in each mode and verify correct data saved

## Files Modified
1. `lib/ui/screens/edit_habit_screen.dart` - All changes

## Related Documentation
- `CREATE_HABIT_SCREEN_V2_README.md` - Original create screen improvements
- `CLEAR_LABELING_SOLUTION.md` - Label naming rationale ("Custom Schedules")
- `RRULE_REFACTORING_PLAN.md` - Overall RRule migration strategy
- `RRULE_ARCHITECTURE.md` - RRule system architecture

## Impact
- Users can now edit complex recurring patterns in existing habits
- Full feature parity between create and edit screens
- Improved UX for alarm/notification configuration
- Seamless migration path from legacy to RRule system
