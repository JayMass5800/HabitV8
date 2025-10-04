# Advanced Mode Frequency Selector & Alarm Time Fix

## Issues Fixed

### 1. Alarm Time Selector Not Visible
**Problem:** When selecting alarms as the habit type, the time selector was hidden, making it impossible to set an alarm time.

**Root Cause:** The time selector was only shown when `_notificationsEnabled` was true, but enabling alarms automatically disabled notifications, creating a catch-22 situation.

**Solution:** Reorganized the Notifications & Alarms section with the following layout:

```
Notifications & Alarms Section:
├── Time Selector (shown first, for both notifications and alarms)
│   ├── Label: "Alarm Time" (if alarms enabled) or "Notification Time" (if notifications enabled)
│   └── Tap to set time
├── Divider
├── Enable Notifications Toggle
├── Enable Alarms Toggle
└── If alarms enabled:
    ├── Divider
    ├── Alarm Sound Picker
    └── Permission Warning
```

**Benefits:**
- Time selector is always visible (except for hourly and single frequencies)
- Works for both notifications and alarms
- Clear labeling based on selected mode
- Better UX flow: set time first, then choose reminder method

---

### 2. Advanced Mode Limited to Daily Frequency
**Problem:** The Advanced Mode section only allowed creating daily patterns with complex rules. Users couldn't create patterns like "every 2 weeks", "every 3rd month", or "every 3 days".

**Root Cause:** The `RRuleBuilderWidget` was called with `forceAdvancedMode: true`, which:
- Skipped the widget's internal Simple/Advanced mode toggle
- Hid the frequency dropdown selector
- Only allowed modifications to the frequency set by the parent screen

**Solution:** Changed `forceAdvancedMode: false` and updated the info text to guide users.

**New User Flow:**
1. User toggles "Advanced Mode" in Create Habit Screen
2. `RRuleBuilderWidget` appears in Simple mode initially
3. User sees frequency chips (Hourly, Daily, Weekly, Monthly, Yearly)
4. User selects desired frequency
5. User can toggle to "Advanced Mode" within the widget for:
   - Interval controls (every 2 weeks, every 3 days, etc.)
   - Complex day patterns (2nd Tuesday, last Friday, etc.)
   - Termination options (after X occurrences, until date)

**Examples Now Possible:**
- ✅ Every 2 weeks (Weekly + interval 2)
- ✅ Every 3 days (Daily + interval 3)
- ✅ Every 3rd month (Monthly + interval 3)
- ✅ Bi-weekly on Monday and Wednesday (Weekly + interval 2 + specific days)
- ✅ 2nd and 4th Tuesday of each month (Monthly + position patterns)
- ✅ Every other year on birthday (Yearly + interval 2)

---

## Files Modified

### `lib/ui/screens/create_habit_screen_v2.dart`

#### Change 1: Reorganized Notification Section
**Lines:** 1141-1250 (approx)

**Key Changes:**
- Moved time selector to top of section
- Made time selector always visible (not conditional on notifications enabled)
- Dynamic label: "Alarm Time" vs "Notification Time"
- Reordered toggles to appear after time selector
- Alarm-specific settings only shown when alarms enabled

#### Change 2: Enabled Frequency Selection in Advanced Mode
**Lines:** 508-560 (approx)

**Key Changes:**
- Changed `forceAdvancedMode: true` → `forceAdvancedMode: false`
- Updated info banner text to explain new capabilities
- New text mentions interval controls and advanced mode toggle

---

## Testing Recommendations

### Test Alarm Time Selector
1. Create new habit
2. Select any frequency (Daily, Weekly, Monthly, Yearly)
3. Scroll to "Notifications & Alarms" section
4. ✅ Verify time selector is visible at the top
5. Toggle "Enable Alarms" ON
6. ✅ Verify label changes to "Alarm Time"
7. ✅ Verify alarm sound picker appears
8. Tap time selector
9. ✅ Verify time picker opens
10. Set a time
11. ✅ Verify time displays correctly

### Test Advanced Mode Frequency Selection
1. Create new habit
2. Enter habit name
3. Select "Advanced Mode" toggle
4. ✅ Verify RRuleBuilder widget appears in Simple mode
5. ✅ Verify frequency chips are visible (Hourly, Daily, Weekly, Monthly, Yearly)
6. Select "Weekly"
7. ✅ Verify weekday selector appears
8. Toggle "Advanced Mode" within the widget
9. ✅ Verify "Repeat every" interval selector appears
10. Change interval to 2
11. ✅ Verify pattern summary shows "every 2 weeks"

### Test Complex Patterns
1. **Every 3 Days:**
   - Advanced Mode → Simple Mode → Daily
   - Toggle to Advanced Mode within widget → Interval: 3
   - ✅ Verify: "every 3 days"

2. **Bi-weekly:**
   - Advanced Mode → Simple Mode → Weekly → Mon, Wed
   - Toggle to Advanced Mode → Interval: 2
   - ✅ Verify: "every 2 weeks on Monday and Wednesday"

3. **Every 3rd Month:**
   - Advanced Mode → Simple Mode → Monthly → Select day 15
   - Toggle to Advanced Mode → Interval: 3
   - ✅ Verify: "every 3 months on day 15"

4. **2nd Tuesday:**
   - Advanced Mode → Simple Mode → Monthly
   - Toggle to Advanced Mode → Select position pattern
   - ✅ Verify: "on the 2nd Tuesday of each month"

---

## User Impact

### Positive Changes
✅ Alarm time selector is now accessible when alarms are enabled
✅ Can create any frequency pattern (daily, weekly, monthly, yearly) with custom intervals
✅ Better UX: time selection before notification/alarm choice
✅ More intuitive flow in advanced mode
✅ All RRule capabilities are now accessible

### No Breaking Changes
✅ Existing habits continue to work
✅ Simple mode workflows unchanged
✅ Default behaviors preserved

---

## Technical Notes

### RRuleBuilderWidget Behavior

**When `forceAdvancedMode: true`:**
- Starts in advanced mode
- Hides frequency selector
- Hides internal Simple/Advanced toggle
- Only shows interval and frequency-specific controls

**When `forceAdvancedMode: false`:**
- Starts in simple mode
- Shows frequency chips in simple mode
- Shows frequency dropdown in advanced mode
- Shows internal Simple/Advanced toggle button
- User has full control over all RRule options

### Time Selector Conditional Display

```dart
if (_selectedFrequency != HabitFrequency.hourly &&
    _selectedFrequency != HabitFrequency.single)
```

**Why excluded:**
- **Hourly:** Uses multiple time pickers (users add multiple times per day)
- **Single:** One-time event uses datetime picker, not time picker

---

## Future Enhancements (Optional)

1. **Preset Patterns:** Add quick buttons for common patterns
   - "Every 2 weeks"
   - "Every 3 days"
   - "First Monday of month"

2. **Better Labeling:** When in advanced mode, show current frequency in the toggle
   - "Advanced Mode (Weekly)" instead of just "Advanced Mode"

3. **Validation Messages:** Show helpful messages when invalid combinations selected
   - "Please select at least one weekday for weekly habits"
   - "Please select at least one day for monthly habits"

4. **Pattern Preview:** Show next 3-5 occurrences in the advanced mode info banner
   - Helps users verify their complex patterns are correct

---

## Commit Message Suggestion

```
fix: Enable frequency selection in advanced mode and fix alarm time visibility

- Reorganized Notifications & Alarms section to show time selector first
- Time selector now works for both notifications and alarms
- Changed forceAdvancedMode to false to enable frequency dropdown in advanced mode
- Users can now create complex patterns: "every 2 weeks", "every 3 days", etc.
- Updated info banner to explain new advanced mode capabilities

Fixes: Alarm time selector not visible when alarms enabled
Fixes: Advanced mode limited to daily frequency only
```
