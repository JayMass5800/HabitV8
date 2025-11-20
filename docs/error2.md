The problem stems from a mismatch between how the habit's start date (dtStart) is initialized during creation and how the notification scheduler interprets that start date when generating recurrence instances.

Habit Creation (create_habit_screen.dart):
In _saveHabit, the dtStart property is explicitly forced to midnight local time, regardless of the user's selected notification time.


// File: lib/ui/screens/create_habit_screen.dart (approx line 1530)// CRITICAL FIX: dtStart should be start of today, not current time// This ensures RRule finds occurrences today even if notification time has passedhabit.dtStart = _time.startOfDayLocal(_time.nowLocal());
This sets the "seed" time for all future occurrences to 00:00:00.

RRule Generation (rrule_service.dart):
The RRuleService generates occurrences based on this dtStart. Since dtStart is midnight, all generated occurrences will be at midnight (local time converted to UTC).

Notification Scheduling (notification_scheduler.dart):
The _resolveOccurrenceDateTime method attempts to determine the correct time for the notification. It has logic to use the notificationTime only if the occurrence is exactly midnight UTC.


// File: lib/services/notifications/notification_scheduler.dart (approx line 800)// Check if the occurrence is exactly midnight UTC (implies date-only RRule)final isMidnightUtc = occurrence.hour == 0 && ...;if (isMidnightUtc) {  // Use habit.notificationTime} else {  // Use the occurrence time directly  return occurrence.toLocal();}
The Failure:

dtStart is set to Local Midnight (e.g., 00:00 PST).
This converts to 08:00 UTC (for PST).
The scheduler sees 08:00 UTC, so isMidnightUtc is false.
It falls into the else block and uses the occurrence time directly.
08:00 UTC converts back to 00:00 Local Time.
Result: The notification is scheduled for midnight instead of the user's selected time.
Recommended Fixes
To resolve this, you should apply changes in two places to be robust:

Fix in create_habit_screen.dart:
Initialize dtStart with the notificationDateTime if it exists, so the RRule "seed" time matches the user's intent.


// Instead of forcing startOfDayLocal:if (notificationDateTime != null) {  habit.dtStart = notificationDateTime;} else {  habit.dtStart = _time.startOfDayLocal(_time.nowLocal());}
Fix in notification_scheduler.dart:
Update _resolveOccurrenceDateTime to detect Local Midnight in addition to UTC Midnight. This handles cases where dtStart was set to midnight (legacy habits or specific logic) but a notificationTime is present.


final localOccurrence = occurrence.toLocal();final isMidnightLocal = localOccurrence.hour == 0 && localOccurrence.minute == 0;if (isMidnightUtcfinal localOccurrence = occurrence.toLocal();final isMidnightLocal = localOccurrence.hour == 0 && localOccurrence.minute == 0;if (isMidnightUtc
|| isMidnightLocal) {
// Use habit.notificationTime if available
}
```

I have made no changes to your code as requested.I have made no changes to your code as requested.