# Hourly Habit Notification Completion Fix

## Issue
Hourly habits were not updating correctly when the "Complete" button was pressed from notifications. While other habit types (daily, weekly, monthly, etc.) worked properly, hourly habits would add a completion timestamp but it wouldn't match the specific time slot that was notified, causing the UI to not reflect the completion.

## Root Cause
The notification action handler (`notification_action_handler.dart`) was using `DateTime.now()` for ALL habit completions, regardless of frequency type. This approach works for daily/weekly/monthly habits where the exact time doesn't matter, but hourly habits require the completion timestamp to match the specific hour that was scheduled.

### How Hourly Habits Work
1. **Notification Scheduling**: When scheduling notifications for hourly habits, the time slot is encoded into the `habitId` field in the payload as: `{habitId}|{hour}:{minute}`
   - Example: `"abc123|14:30"` for a habit scheduled at 2:30 PM

2. **Completion Logic**: The timeline screen correctly extracts the time slot and creates a DateTime with that specific hour/minute when completing via the UI (see `timeline_screen.dart`, line 844-855)

3. **Checking Completion**: The habit model's `_checkCompletedForCurrentPeriod` method (for hourly habits) checks if there's a completion that matches the exact HOUR:
   ```dart
   case HabitFrequency.hourly:
     return completions.any((completion) =>
       completion.year == now.year &&
       completion.month == now.month &&
       completion.day == now.day &&
       completion.hour == now.hour,  // ← Must match the hour!
     );
   ```

## Solution

### 1. Added Helper Function to Extract Time Slot
**File**: `lib/services/notifications/notification_helpers.dart`

Added `extractTimeSlotFromPayload()` function that:
- Parses the payload JSON
- Extracts the time slot from hourly habit IDs (format: `id|HH:MM`)
- Returns a map with `hour` and `minute` keys
- Returns `null` for non-hourly habits

```dart
static Map<String, int>? extractTimeSlotFromPayload(String? payload) {
  // Parses "abc123|14:30" → {hour: 14, minute: 30}
  // Returns null for regular habits
}
```

### 2. Updated Background Completion Handler
**File**: `lib/services/notifications/notification_action_handler.dart`

Modified `completeHabitInBackground()` to:
- Accept both the raw habitId AND the full payload
- Extract the time slot using the new helper function
- Create a DateTime with the specific hour/minute for hourly habits
- Use `DateTime.now()` only for non-hourly habits

```dart
if (timeSlot != null && habit.frequency == HabitFrequency.hourly) {
  // Use the specific time slot from the notification
  final now = DateTime.now();
  completionTime = DateTime(
    now.year,
    now.month,
    now.day,
    timeSlot['hour']!,  // ← From notification payload
    timeSlot['minute']!, // ← From notification payload
  );
} else {
  // For non-hourly habits, use current time
  completionTime = DateTime.now();
}
```

### 3. Updated Background Notification Handler
**File**: `lib/services/notifications/notification_action_handler.dart`

Modified `onBackgroundNotificationResponseIsar()` to:
- Preserve the raw habitId (with time slot) from the payload
- Pass the full payload string to `completeHabitInBackground()`
- Extract base habitId only when needed for callbacks

## Files Changed
1. `lib/services/notifications/notification_helpers.dart`
   - Added `extractTimeSlotFromPayload()` function (38 lines)

2. `lib/services/notifications/notification_action_handler.dart`
   - Updated `onBackgroundNotificationResponseIsar()` to preserve time slot data
   - Updated `completeHabitInBackground()` signature and implementation
   - Added logic to extract time slot and use it for hourly habit completions

## Testing
- ✅ All existing unit tests pass (54 tests)
- ✅ No compilation errors
- ✅ Backward compatible - non-hourly habits continue to work as before

## How to Verify the Fix
1. Create an hourly habit with multiple time slots (e.g., 9:00 AM, 2:00 PM, 6:00 PM)
2. Wait for or trigger a notification for one of the time slots
3. Tap the "Complete" button from the notification
4. Check the timeline screen - the specific time slot should now show as completed
5. Verify that other time slots for the same habit remain incomplete

## Technical Notes
- The fix follows the same pattern used in `timeline_screen.dart` for manual completions
- Maintains Isar's multi-isolate safety - no additional synchronization needed
- Preserves error handling and pending completion retry logic
- Adds debug logging for hourly habit completions to aid future troubleshooting

## Related Code Patterns
This fix aligns with the existing implementation in:
- `timeline_screen.dart` (`_toggleHourlyHabitCompletion()` method, line 813-880)
- `notification_scheduler.dart` (hourly notification scheduling, line 629)
- `habit.dart` (`_checkCompletedForCurrentPeriod()` for hourly frequency, line 217-230)

## Future Improvements
Consider adding:
- Unit tests specifically for hourly habit notification completions
- Integration tests that simulate notification tap → completion flow
- Validation that prevents duplicate completions for the same time slot
