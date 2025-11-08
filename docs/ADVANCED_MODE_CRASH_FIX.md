# Advanced Mode Crash Fix

## Issue
When switching from Simple to Advanced mode in the habit creation screen, the app crashed with the following error:

```
setState() or markNeedsBuild() called during build.
```

## Root Cause
The `RRuleBuilderWidget` was calling `_updatePreview()` in its `initState()` method, which in turn called the `onRRuleChanged` callback. This callback triggered `setState()` on the parent `CreateHabitScreen` widget **while it was still in the build phase**, which is not allowed in Flutter.

**Call Stack:**
1. CreateHabitScreen builds and includes RRuleBuilderWidget
2. RRuleBuilderWidget.initState() called
3. initState() calls _updatePreview()
4. _updatePreview() calls widget.onRRuleChanged()
5. onRRuleChanged callback calls setState() on CreateHabitScreen
6. ❌ CRASH: Can't call setState during build!

## Solution
Deferred the `_updatePreview()` call until after the first frame is complete using `WidgetsBinding.instance.addPostFrameCallback()`.

### Code Change
**Before:**
```dart
@override
void initState() {
  super.initState();
  _startDate = widget.initialStartDate ?? DateTime.now();
  
  if (widget.initialRRuleString != null) {
    _isAdvancedMode = true;
    _parseExistingRRule(widget.initialRRuleString!);
  } else if (widget.initialFrequency != null) {
    _frequency = widget.initialFrequency!;
  }
  
  _updatePreview(); // ❌ Called during build phase
}
```

**After:**
```dart
@override
void initState() {
  super.initState();
  _startDate = widget.initialStartDate ?? DateTime.now();
  
  if (widget.initialRRuleString != null) {
    _isAdvancedMode = true;
    _parseExistingRRule(widget.initialRRuleString!);
  } else if (widget.initialFrequency != null) {
    _frequency = widget.initialFrequency!;
  }
  
  // ✅ Defer until after first frame
  WidgetsBinding.instance.addPostFrameCallback((_) {
    _updatePreview();
  });
}
```

## Why This Works
`addPostFrameCallback()` schedules the callback to run **after** the current frame is fully built and rendered. This ensures:

1. ✅ The CreateHabitScreen completes its build phase
2. ✅ The RRuleBuilderWidget is fully mounted
3. ✅ The parent widget is ready to receive setState() calls
4. ✅ No build-phase violations

## Testing
Test the fix by:
1. Open Create Habit screen (defaults to Simple mode)
2. Click the "Advanced" toggle button
3. ✅ App should NOT crash
4. ✅ RRuleBuilderWidget should appear with preview
5. ✅ Switching back to Simple mode should work
6. ✅ Making changes in either mode should work

## Related Files
- `lib/ui/widgets/rrule_builder_widget.dart` - Widget fixed
- `lib/ui/screens/create_habit_screen.dart` - Parent widget with dual-mode UI
- `error.md` - Original crash stack trace

## Date
October 3, 2025
