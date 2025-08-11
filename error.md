I/flutter (11545): DEBUG: Building frequency section, current frequency: HabitFrequency.daily
I/flutter (11545): DEBUG: Creating choice chip for frequency: HabitFrequency.hourly
I/flutter (11545): DEBUG: Creating choice chip for frequency: HabitFrequency.daily
I/flutter (11545): DEBUG: Creating choice chip for frequency: HabitFrequency.weekly
I/flutter (11545): DEBUG: Creating choice chip for frequency: HabitFrequency.monthly
I/flutter (11545): DEBUG: Creating choice chip for frequency: HabitFrequency.yearly
I/flutter (11545): DEBUG: Starting notification scheduling for habit: try me
I/flutter (11545): DEBUG: Notifications enabled: true
I/flutter (11545): DEBUG: Notification time: 2025-08-06 11:45:00.000
I/flutter (11545): DEBUG: Scheduling for 11:45
I/flutter (11545): DEBUG: Error scheduling notifications: type 'String' is not a subtype of type 'int'
I/flutter (11545): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (11545): │ type 'String' is not a subtype of type 'int'
I/flutter (11545): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (11545): │ #0   AppLogger.error (package:habitv8/services/logging_service.dart:28:13)
I/flutter (11545): │ #1   NotificationService.scheduleHabitNotifications (package:habitv8/services/notification_service.dart:469:17)
I/flutter (11545): │ #2   _CreateHabitScreenState._saveHabit (package:habitv8/ui/screens/create_habit_screen.dart:1119:35)
I/flutter (11545): │ #3   <asynchronous suspension>
I/flutter (11545): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (11545): │ ⛔ Failed to schedule notifications for habit: try me
I/flutter (11545): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (11545): Failed to create habit: type 'String' is not a subtype of type 'int'
