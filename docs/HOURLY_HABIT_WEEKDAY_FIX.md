# Hourly Habit Weekday Filtering Fix

## Issue
Hourly habits were not respecting their selected weekdays in:
1. **Homescreen widgets** - showing on days they shouldn't
2. **Notification system** - sending notifications on days they shouldn't  
3. **Alarm system** - triggering alarms on days they shouldn't

The timeline screen was working correctly, but widgets, notifications, and alarms were showing/triggering every day regardless of the selected weekdays.

## Root Cause
Three separate issues in different modules:

### 1. Widget Service (`widget_integration_service.dart`)
The `_isHabitScheduledForDate()` method had incorrect logic for hourly habits:
```dart
case HabitFrequency.hourly:
  return true; // ❌ Always returns true, ignoring weekdays
```

### 2. Notification Scheduler (`notification_scheduler.dart`)
The `_scheduleHourlyHabitNotifications()` method was scheduling notifications without checking weekdays:
- It scheduled for "today or tomorrow" without verifying if those days were in `selectedWeekdays`
- No validation that weekdays were selected at all

### 3. Alarm Scheduler (`notification_alarm_scheduler.dart`)
The `_scheduleHourlyHabitAlarms()` method had flawed logic:
- It only checked if "today" is in selected weekdays
- If today wasn't selected, it would skip scheduling entirely (or only schedule for tomorrow)
- This meant if you created the habit on Wednesday but set it for Monday only, no alarms would be scheduled

## Solution
Applied consistent weekday filtering across all three modules, matching the correct implementation in timeline_screen.dart:

### 1. Widget Service Fix
```dart
case HabitFrequency.hourly:
  // CRITICAL FIX: Hourly habits must respect selected weekdays
  // Use date.weekday (1=Monday, 7=Sunday) to match selectedWeekdays storage
  final weekday = date.weekday;
  // Check both old and new fields for backward compatibility
  return habit.selectedWeekdays.contains(weekday) ||
      habit.weeklySchedule.contains(weekday);
```

### 2. Notification Scheduler Fix
```dart
Future<void> _scheduleHourlyHabitNotifications(Habit habit, int hour, int minute) async {
  // Validate weekdays are selected
  final selectedWeekdays = habit.selectedWeekdays.isNotEmpty 
      ? habit.selectedWeekdays 
      : habit.weeklySchedule;
  
  if (selectedWeekdays.isEmpty) {
    AppLogger.warning('No weekdays selected for hourly habit: ${habit.name}');
    return;
  }

  // Schedule notification for EACH selected weekday
  for (final timeStr in hourlyTimes) {
    for (final weekday in selectedWeekdays) {
      DateTime nextNotification = _getNextWeekday(now, weekday, timeHour, timeMinute);
      
      await scheduleHabitNotification(
        id: NotificationHelpers.generateSafeId('${habit.id}_${weekday}_${timeHour}_$timeMinute'),
        habitId: habitIdWithTimeSlot,
        // ... schedule for specific weekday
      );
    }
  }
}
```

### 3. Alarm Scheduler Fix
```dart
Future<void> _scheduleHourlyHabitAlarms(Habit habit) async {
  // Validate weekdays are selected
  if (selectedWeekdays.isEmpty) {
    AppLogger.warning('No weekdays selected for hourly habit: ${habit.name}');
    return;
  }

  // Schedule alarm for EACH selected weekday
  for (String timeString in hourlyTimes) {
    for (final weekday in selectedWeekdays) {
      tz.TZDateTime nextAlarm = _getNextWeekdayDateTime(baseTime, weekday, hour, minute);
      
      await AlarmService.scheduleExactAlarm(
        alarmId: NotificationHelpers.generateSafeId('${habit.id}_hourly_${weekday}_${hour}_$minute'),
        // ... schedule for specific weekday
      );
    }
  }
}
```

## Files Modified
1. `lib/services/widget_integration_service.dart`
   - Updated `_isHabitScheduledForDate()` to check weekdays for hourly habits
   
2. `lib/services/notifications/notification_scheduler.dart`
   - Updated `_scheduleHourlyHabitNotifications()` to validate weekdays and schedule for each selected weekday
   
3. `lib/services/notifications/notification_alarm_scheduler.dart`
   - Updated `_scheduleHourlyHabitAlarms()` to validate weekdays and schedule for each selected weekday

## Testing
To verify the fix:

1. **Create a test hourly habit**:
   - Name: "Monday Only Test"
   - Frequency: Hourly
   - Times: 10:00, 14:00, 18:00
   - Selected weekdays: Monday only
   - Enable notifications and/or alarms

2. **Verify on Monday**:
   - ✅ Appears in timeline screen
   - ✅ Appears in homescreen widgets
   - ✅ Receives notifications at scheduled times
   - ✅ Alarms trigger at scheduled times

3. **Verify on Wednesday (or any non-Monday)**:
   - ✅ Does NOT appear in timeline screen
   - ✅ Does NOT appear in homescreen widgets
   - ✅ Does NOT receive notifications
   - ✅ Alarms do NOT trigger

4. **Re-edit the habit**:
   - This will trigger notification/alarm rescheduling
   - Verify new schedules are created correctly
   - Check app logs to see weekday-specific scheduling messages

## Technical Details

### Weekday Format
- Uses `DateTime.weekday` (1=Monday, 2=Tuesday, ..., 7=Sunday)
- Stored in `habit.selectedWeekdays` as List<int>
- Backward compatibility with `habit.weeklySchedule`

### Notification/Alarm ID Format
- Changed from: `${habit.id}_${hour}_$minute`
- Changed to: `${habit.id}_${weekday}_${hour}_$minute`
- This ensures separate notifications/alarms for each weekday

### Helper Method
All three modules now use helper methods to calculate next occurrence:
- Notifications: `_getNextWeekday()`
- Alarms: `_getNextWeekdayDateTime()`
- These methods find the next occurrence of a specific weekday at a specific time

## Impact
- **No database migration required** - uses existing `selectedWeekdays` field
- **Backward compatible** - falls back to `weeklySchedule` if needed
- **Modular** - each service maintains its own responsibility
- **Consistent** - all three modules now use the same filtering logic as timeline screen

## Notes
- This fix applies to **legacy frequency-based hourly habits** (not RRule-based)
- For RRule-based habits, weekday filtering is handled by the RRule library
- The fix ensures hourly habits behave consistently with weekly habits regarding weekday selection