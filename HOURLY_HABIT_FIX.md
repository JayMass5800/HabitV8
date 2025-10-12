# Hourly Habit Completion Fix

## Issue
Hourly habits were not being marked as completed when the "Complete" button was pressed from a notification. Other frequencies (daily, weekly, etc.) were working correctly.

## Root Cause
The background notification action handler (`completeHabitInBackground` in `notification_action_handler.dart`) was treating all habits the same way:
- It checked if the habit was completed **today** (any time)
- It used the current time (`DateTime.now()`) for the completion timestamp

This approach works for daily/weekly/monthly habits, but **hourly habits need to track completions for specific time slots** (e.g., 9:00 AM, 2:00 PM, 5:00 PM).

## The Fix
Updated `completeHabitInBackground` method to handle hourly habits correctly:

### 1. Extract Time Slot from Payload
For hourly habits, the notification payload contains the specific time slot in the format: `"habitId|HH:MM"` (e.g., `"abc123|14:30"`).

```dart
// For hourly habits, extract the specific time slot from payload
if (habit.frequency == HabitFrequency.hourly) {
  final timeSlot = NotificationHelpers.extractTimeSlotFromPayload(payloadJson);
  if (timeSlot != null) {
    final hour = timeSlot['hour']!;
    final minute = timeSlot['minute']!;
    completionTime = DateTime(now.year, now.month, now.day, hour, minute);
  }
}
```

### 2. Check Specific Time Slot Completion
Instead of checking if completed "today", check if the **specific time slot** is already completed:

```dart
if (habit.frequency == HabitFrequency.hourly) {
  // For hourly habits, check if this specific time slot is already completed
  alreadyCompleted = habit.completions.any((completion) {
    return completion.year == completionTime.year &&
        completion.month == completionTime.month &&
        completion.day == completionTime.day &&
        completion.hour == completionTime.hour &&
        completion.minute == completionTime.minute;
  });
} else {
  // For non-hourly habits, check if completed today
  // ... existing logic ...
}
```

### 3. Use Correct Completion Time
Save the completion with the specific time slot time, not the current time:

```dart
habit.completions.add(completionTime); // Uses time slot time for hourly habits
```

## Files Modified
- `lib/services/notifications/notification_action_handler.dart`
  - Updated `completeHabitInBackground` method (lines 237-393)

## Testing
To verify the fix:
1. Create an hourly habit with multiple time slots (e.g., 9:00 AM, 2:00 PM, 5:00 PM)
2. Wait for a notification to appear for one time slot
3. Press the "Complete" button on the notification
4. Verify that:
   - The specific time slot is marked as completed
   - Other time slots remain incomplete
   - You can complete other time slots independently
   - The UI updates correctly to show the completion

## Related Code
The foreground handler (`notification_action_service.dart`) already had the correct logic for hourly habits. This fix brings the background handler in line with the foreground implementation.

## Why This Matters
Hourly habits are unique because:
- Users can have multiple completions per day (one per time slot)
- Each time slot is independent
- Completing one slot shouldn't affect others
- The completion time must match the scheduled time slot exactly

Without this fix, hourly habits would either:
- Not be marked as completed at all
- Be marked with the wrong timestamp
- Prevent other time slots from being completed