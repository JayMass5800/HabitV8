I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (16090): │ #1   AppLifecycleService._processPendingActionsWithRetry.<anonymous closure> (package:habitv8/services/app_lifecycle_service.dart:213:19)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 💡 ✅ Pending actions processed successfully on attempt 1
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): 🧪 FORCE UPDATE: Starting immediate widget update...
I/flutter (16090): Filtering 0 habits for date 2025-10-04:
I/flutter (16090): Result: 0 habits for today
I/flutter (16090): Widget data preparation: Found 0 total habits, 0 for today
I/flutter (16090): 🎨 Getting app theme: ThemeMode.system
I/flutter (16090): 🎨 App is in SYSTEM mode, device brightness: Brightness.dark → dark
I/flutter (16090): 🎨 Final theme mode to send to widgets: dark
I/flutter (16090): 🎨 Using app primary color: 4280391411
I/flutter (16090): 🎯 Widget data prepared: 0 habits in list, JSON length: 2
I/flutter (16090): 🎯 First 200 chars of habits JSON: []
I/flutter (16090): 🎯 Theme data: dark, primary: 4280391411
I/MainActivity(16090): Widget force refresh triggered for both compact and timeline widgets
I/flutter (16090): 🧪 FORCE UPDATE: Successfully triggered widget refresh via method channel
I/flutter (16090): 🧪 FORCE UPDATE: Completed successfully
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (16090): │ #1   AppLifecycleService._refreshWidgetsOnResume.<anonymous closure> (package:habitv8/services/app_lifecycle_service.dart:241:21)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 🐛 ✅ Widgets force refreshed successfully on app resume
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): Saved widget theme data: dark, color: 4280391411
I/flutter (16090): Updating widget HabitTimelineWidgetProvider with data keys: [habits, nextHabit, selectedDate, themeMode, primaryColor, lastUpdate]
I/flutter (16090): ✅ Saved habits: length=2, preview=[]
I/flutter (16090): ✅ Saved nextHabit: null
I/flutter (16090): ✅ Saved selectedDate: 2025-10-04
I/flutter (16090): ✅ Saved themeMode: dark
I/flutter (16090): ✅ Saved primaryColor: 4280391411
W/JobInfo (16090): Requested important-while-foreground flag for job4 is ignored and takes no effect
D/WM-SystemJobScheduler(16090): Scheduling work ID 4e86b175-e95f-4de4-bbb8-f8c21a4bac46Job ID 4
I/flutter (16090): ✅ Saved lastUpdate: 1759603423278
D/WM-GreedyScheduler(16090): Starting work for 4e86b175-e95f-4de4-bbb8-f8c21a4bac46
D/WM-SystemJobService(16090): onStartJob for WorkGenerationalId(workSpecId=4e86b175-e95f-4de4-bbb8-f8c21a4bac46, generation=0)
D/WM-Processor(16090): Processor: processing WorkGenerationalId(workSpecId=4e86b175-e95f-4de4-bbb8-f8c21a4bac46, generation=0)
D/WM-Processor(16090): Work WorkGenerationalId(workSpecId=4e86b175-e95f-4de4-bbb8-f8c21a4bac46, generation=0) is already enqueued for processing
D/WM-WorkerWrapper(16090): Starting work for com.habittracker.habitv8.WidgetUpdateWorker
I/WidgetUpdateWorker(16090): Starting widget update work
D/WidgetUpdateWorker(16090): Widget data loaded: 2 characters
D/WidgetUpdateWorker(16090): Skipping habits update - no new data to write (would be empty array)
D/WidgetUpdateWorker(16090): Theme settings copied: mode=null, color=ffffffff
D/WidgetUpdateWorker(16090): Widget data updated from Flutter preferences
I/WidgetUpdateWorker(16090): ✅ Widget update work completed successfully
I/WM-WorkerWrapper(16090): Worker result SUCCESS for Work [ id=4e86b175-e95f-4de4-bbb8-f8c21a4bac46, tags={ com.habittracker.habitv8.WidgetUpdateWorker } ]
D/WM-Processor(16090): Processor 4e86b175-e95f-4de4-bbb8-f8c21a4bac46 executed; reschedule = false
D/WM-SystemJobService(16090): 4e86b175-e95f-4de4-bbb8-f8c21a4bac46 executed on JobScheduler
D/WM-GreedyScheduler(16090): Cancelling work ID 4e86b175-e95f-4de4-bbb8-f8c21a4bac46
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (16090): │ #1   MidnightHabitResetService.checkForMissedResetOnAppActive (package:habitv8/services/midnight_habit_reset_service.dart:270:17)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 🐛 🔍 Checking for missed resets on app activation
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (16090): │ #1   MidnightHabitResetService._checkMissedReset (package:habitv8/services/midnight_habit_reset_service.dart:84:21)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 🐛 ✅ No missed reset - last reset was today
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (16090): │ #1   AppLifecycleService._checkMissedResetOnResume.<anonymous closure> (package:habitv8/services/app_lifecycle_service.dart:263:21)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 🐛 ✅ Missed reset check completed on app resume
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): Widget HabitTimelineWidgetProvider update completed
I/flutter (16090): Updating widget HabitCompactWidgetProvider with data keys: [habits, nextHabit, selectedDate, themeMode, primaryColor, lastUpdate]
I/flutter (16090): ✅ Saved habits: length=2, preview=[]
I/flutter (16090): ✅ Saved nextHabit: null
I/flutter (16090): ✅ Saved selectedDate: 2025-10-04
I/flutter (16090): ✅ Saved themeMode: dark
I/flutter (16090): ✅ Saved primaryColor: 4280391411
I/flutter (16090): ✅ Saved lastUpdate: 1759603423278
I/flutter (16090): Widget HabitCompactWidgetProvider update completed
I/flutter (16090): ✅ All widgets updated successfully (debounced)
D/WindowOnBackDispatcher(16090): setTopOnBackInvokedCallback (unwrapped): androidx.activity.OnBackPressedDispatcher$Api34Impl$createOnBackAnimationCallback$1@c27e0e1
I/ImeTracker(16090): com.habittracker.habitv8.debug:388e9be2: onRequestShow at ORIGIN_CLIENT reason SHOW_SOFT_INPUT fromUser false
I/HWUI    (16090): Using FreeType backend (prop=Auto)
D/InsetsController(16090): show(ime())
D/ImeBackDispatcher(16090): Undo preliminary clear (mImeCallbacks.size=0)
D/InsetsController(16090): Setting requestedVisibleTypes to -1 (was -9)
D/InputConnectionAdaptor(16090): The input method toggled cursor monitoring on
D/ImeBackDispatcher(16090): Register received callback id=213350146 priority=0
D/WindowOnBackDispatcher(16090): setTopOnBackInvokedCallback (unwrapped): android.view.ImeBackAnimationController@384f1d0
W/InteractionJankMonitor(16090): Initializing without READ_DEVICE_CONFIG permission. enabled=false, interval=1, missedFrameThreshold=3, frameTimeThreshold=64, package=com.habittracker.habitv8.debug
I/ImeTracker(16090): com.habittracker.habitv8.debug:388e9be2: onShown
I/ImeTracker(16090): com.habittracker.habitv8.debug:3c6cf4dd: onRequestHide at ORIGIN_CLIENT reason HIDE_SOFT_INPUT fromUser false
D/InsetsController(16090): hide(ime())
D/ImeBackDispatcher(16090): Preliminary clear (mImeCallbacks.size=1)
D/WindowOnBackDispatcher(16090): setTopOnBackInvokedCallback (unwrapped): androidx.activity.OnBackPressedDispatcher$Api34Impl$createOnBackAnimationCallback$1@c27e0e1
D/InsetsController(16090): Setting requestedVisibleTypes to -9 (was -1)
D/CompatChangeReporter(16090): Compat change id reported: 395521150; UID 10586; state: ENABLED
D/InputConnectionAdaptor(16090): The input method toggled cursor monitoring off
D/ImeBackDispatcher(16090): Unregister received callback id=213350146
I/ImeTracker(16090): system_server:f0a3449: onCancelled at PHASE_CLIENT_ON_CONTROLS_CHANGED
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (16090): │ #1   _CreateHabitScreenV2State._generateRRuleFromSimpleMode (package:habitv8/ui/screens/create_habit_screen_v2.dart:1691:17)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 💡 ✅ Generated RRule from simple mode: FREQ=DAILY
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (16090): │ #1   NotificationScheduler.cancelHabitNotificationsByHabitId (package:habitv8/services/notifications/notification_scheduler.dart:674:15)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 🐛 🚫 Starting notification cancellation for habit: 1759603440661
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (16090): │ #1   NotificationScheduler.scheduleHabitNotifications (package:habitv8/services/notifications/notification_scheduler.dart:207:15)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 🐛 Starting notification scheduling for habit: testing (isNewHabit: true)
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (16090): │ #1   NotificationScheduler.scheduleHabitNotifications (package:habitv8/services/notifications/notification_scheduler.dart:210:15)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 🐛 Notifications enabled: true
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (16090): │ #1   NotificationCore.ensureNotificationPermissions (package:habitv8/services/notifications/notification_core.dart:280:17)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 💡 Checking notification permission...
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (16090): │ #1   NotificationCore.ensureNotificationPermissions (package:habitv8/services/notifications/notification_core.dart:285:19)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 💡 Requesting notification permission for scheduling...
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (16090): │ #1   PermissionService.requestNotificationPermissionWithContext (package:habitv8/services/permission_service.dart:98:17)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 💡 Requesting notification permission with user context...
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (16090): │ #1   PermissionService.requestNotificationPermission (package:habitv8/services/permission_service.dart:73:17)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 💡 Requesting notification permission when needed...
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/MainActivity(16090): onPause: Preserving alarm sound if playing
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (16090): │ #1   AppLifecycleService.didChangeAppLifecycleState (package:habitv8/services/app_lifecycle_service.dart:63:15)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 💡 📱 App lifecycle state changed to: AppLifecycleState.inactive
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (16090): │ #1   AppLifecycleService.didChangeAppLifecycleState (package:habitv8/services/app_lifecycle_service.dart:82:19)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 💡 ⏹️ App inactive
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
D/ImeBackDispatcher(16090): Clear (mImeCallbacks.size=0)
D/ImeBackDispatcher(16090): switch root view (mImeCallbacks.size=0)
I/MainActivity(16090): onResume: Preserving alarm sound state
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (16090): │ #1   PermissionService.requestNotificationPermission (package:habitv8/services/permission_service.dart:79:17)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 💡 Notification permission request result: true
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (16090): │ #1   PermissionService.requestNotificationPermissionWithContext (package:habitv8/services/permission_service.dart:104:19)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 💡 Notification permission granted successfully
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (16090): │ #1   PermissionService.hasExactAlarmPermission (package:habitv8/services/permission_service.dart:143:17)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 💡 Checking exact alarm permission status...
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (16090): │ #1   PermissionService.hasExactAlarmPermission (package:habitv8/services/permission_service.dart:147:17)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 💡 Exact alarm permission check result: true (simplified)
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (16090): │ #1   NotificationCore.ensureNotificationPermissions (package:habitv8/services/notifications/notification_core.dart:318:19)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 💡 Exact alarm permission already available
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (16090): │ #1   NotificationScheduler.scheduleHabitNotifications (package:habitv8/services/notifications/notification_scheduler.dart:267:17)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 🐛 Scheduling for 11:45
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (16090): │ #1   NotificationScheduler.scheduleHabitNotifications (package:habitv8/services/notifications/notification_scheduler.dart:283:19)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 🐛 Skipping notification cancellation - new habit with no existing notifications
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (16090): │ #1   NotificationScheduler.scheduleHabitNotifications (package:habitv8/services/notifications/notification_scheduler.dart:290:19)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 🐛 Scheduling RRule-based notifications
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
D/ImeBackDispatcher(16090): switch root view (mImeCallbacks.size=0)
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (16090): │ #1   AppLifecycleService.didChangeAppLifecycleState (package:habitv8/services/app_lifecycle_service.dart:63:15)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 💡 📱 App lifecycle state changed to: AppLifecycleState.resumed
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (16090): │ #1   AppLifecycleService.didChangeAppLifecycleState (package:habitv8/services/app_lifecycle_service.dart:78:19)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 💡 ▶️ App resumed
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (16090): │ #1   AppLifecycleService._handleAppResumed (package:habitv8/services/app_lifecycle_service.dart:125:17)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 💡 🔄 Handling app resume - re-registering notification callbacks...
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (16090): │ #1   AppLifecycleService._ensureDatabaseConnection (package:habitv8/services/app_lifecycle_service.dart:154:17)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 🐛 🔗 Ensuring database connection is valid...
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (16090): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:43:15)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 💡 🔍 Checking notification callback registration...
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (16090): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:44:15)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 💡 📦 Container available: true
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (16090): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:45:15)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 💡 🔗 Callback currently set: true
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (16090): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:56:17)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 💡 ✅ Notification action callback is properly registered
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (16090): │ #1   AppLifecycleService._processPendingActionsWithRetry (package:habitv8/services/app_lifecycle_service.dart:207:15)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 💡 🔄 Scheduling pending action processing attempt 1/5 with 1000ms delay
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (16090): │ #1   AppLifecycleService._refreshWidgetsOnResume (package:habitv8/services/app_lifecycle_service.dart:234:17)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 🐛 🔄 Force refreshing widgets on app resume...
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (16090): │ #1   AppLifecycleService._checkMissedResetOnResume (package:habitv8/services/app_lifecycle_service.dart:256:17)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 🐛 🔍 Checking for missed midnight resets on app resume...
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (16090): │ #1   AppLifecycleService._handleAppResumed (package:habitv8/services/app_lifecycle_service.dart:144:17)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 💡 ✅ App resume handling completed
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
D/InsetsController(16090): hide(ime())
I/ImeTracker(16090): com.habittracker.habitv8.debug:dd6e927d: onCancelled at PHASE_CLIENT_ALREADY_HIDDEN
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (16090): │ #1   AppLifecycleService._ensureDatabaseConnection.<anonymous closure> (package:habitv8/services/app_lifecycle_service.dart:165:23)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 🐛 ✅ Database connection is healthy
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
W/System  (16090): A resource failed to call release. 
W/System  (16090): A resource failed to call release. 
W/System  (16090): A resource failed to call release.
W/System  (16090): A resource failed to call release.
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (16090): │ #1   NotificationScheduler._scheduleRRuleHabitNotifications (package:habitv8/services/notifications/notification_scheduler.dart:827:17)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 💡 📅 Scheduled 85 RRule notifications for testing
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (16090): │ #1   NotificationScheduler.scheduleHabitNotifications (package:habitv8/services/notifications/notification_scheduler.dart:327:17)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 💡 ✅ Successfully scheduled notifications for habit: testing
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (16090): │ #1   NotificationAlarmScheduler.scheduleHabitAlarms (package:habitv8/services/notifications/notification_alarm_scheduler.dart:30:15)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 🐛 Starting alarm scheduling for habit: testing
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (16090): │ #1   NotificationAlarmScheduler.scheduleHabitAlarms (package:habitv8/services/notifications/notification_alarm_scheduler.dart:31:15)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 🐛 Alarm enabled: false
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (16090): │ #1   NotificationAlarmScheduler.scheduleHabitAlarms (package:habitv8/services/notifications/notification_alarm_scheduler.dart:32:15)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 🐛 Alarm sound: null
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (16090): │ #1   NotificationAlarmScheduler.scheduleHabitAlarms (package:habitv8/services/notifications/notification_alarm_scheduler.dart:33:15)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 🐛 Alarm sound URI: null
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (16090): │ #1   NotificationAlarmScheduler.scheduleHabitAlarms (package:habitv8/services/notifications/notification_alarm_scheduler.dart:37:17)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 🐛 Skipping alarms - disabled
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (16090): │ #1   NotificationAlarmScheduler.scheduleHabitAlarms (package:habitv8/services/notifications/notification_alarm_scheduler.dart:38:17)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 💡 Alarms disabled for habit: testing
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (16090): │ #1   HabitService.addHabit (package:habitv8/data/database.dart:622:21)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 💡 Scheduled notifications/alarms for new habit "testing"
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (16090): │ #1   HabitService.addHabit (package:habitv8/data/database.dart:636:21)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 🐛 Calendar sync disabled, skipping sync for new habit "testing"
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (16090): │ #1   _CreateHabitScreenV2State._saveHabit (package:habitv8/ui/screens/create_habit_screen_v2.dart:1475:19)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 💡 Habit created: testing
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/WidgetUpdateWorker(16090): ✅ Immediate widget update triggered
I/MainActivity(16090): Immediate widget update triggered via WidgetUpdateWorker
I/flutter (16090): Android widget immediate update triggered
W/JobInfo (16090): Requested important-while-foreground flag for job5 is ignored and takes no effect
D/WM-SystemJobScheduler(16090): Scheduling work ID 5fd700b1-2c08-4ac8-9b65-b1c4621897a6Job ID 5
D/WM-GreedyScheduler(16090): Starting work for 5fd700b1-2c08-4ac8-9b65-b1c4621897a6
D/WM-Processor(16090): Processor: processing WorkGenerationalId(workSpecId=5fd700b1-2c08-4ac8-9b65-b1c4621897a6, generation=0)
D/WM-WorkerWrapper(16090): Starting work for com.habittracker.habitv8.WidgetUpdateWorker
I/WidgetUpdateWorker(16090): Starting widget update work
D/WidgetUpdateWorker(16090): Widget data loaded: 2 characters
D/WidgetUpdateWorker(16090): Skipping habits update - no new data to write (would be empty array)
D/WidgetUpdateWorker(16090): Theme settings copied: mode=null, color=ffffffff
D/WidgetUpdateWorker(16090): Widget data updated from Flutter preferences
D/WindowOnBackDispatcher(16090): setTopOnBackInvokedCallback (unwrapped): android.app.Activity$$ExternalSyntheticLambda0@21c93d
D/WM-SystemJobService(16090): onStartJob for WorkGenerationalId(workSpecId=5fd700b1-2c08-4ac8-9b65-b1c4621897a6, generation=0)
I/WidgetUpdateWorker(16090): ✅ Widget update work completed successfully
D/WM-Processor(16090): Work WorkGenerationalId(workSpecId=5fd700b1-2c08-4ac8-9b65-b1c4621897a6, generation=0) is already enqueued for processing
I/WM-WorkerWrapper(16090): Worker result SUCCESS for Work [ id=5fd700b1-2c08-4ac8-9b65-b1c4621897a6, tags={ com.habittracker.habitv8.WidgetUpdateWorker,immediate_widget_update } ]
D/WM-Processor(16090): Processor 5fd700b1-2c08-4ac8-9b65-b1c4621897a6 executed; reschedule = false
D/WM-SystemJobService(16090): 5fd700b1-2c08-4ac8-9b65-b1c4621897a6 executed on JobScheduler
D/WM-GreedyScheduler(16090): Cancelling work ID 5fd700b1-2c08-4ac8-9b65-b1c4621897a6
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (16090): │ #1   NotificationActionHandler.processPendingActionsManually (package:habitv8/services/notifications/notification_action_handler.dart:779:15)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 💡 🔄 Manually processing pending actions
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (16090): │ #1   NotificationActionHandler.processPendingActionsManually (package:habitv8/services/notifications/notification_action_handler.dart:783:17)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 💡 ✅ Using callback to process pending actions
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (16090): │ #1   NotificationActionHandler.processPendingActions (package:habitv8/services/notifications/notification_action_handler.dart:213:17)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 💡 ⏭️  Skipping - initial pending actions already processed
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (16090): │ #1   AppLifecycleService._processPendingActionsWithRetry.<anonymous closure> (package:habitv8/services/app_lifecycle_service.dart:213:19)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 💡 ✅ Pending actions processed successfully on attempt 1
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): Filtering 1 habits for date 2025-10-04:
I/flutter (16090):   - testing: HabitFrequency.daily -> INCLUDED
I/flutter (16090): Result: 1 habits for today
I/flutter (16090): Widget data preparation: Found 1 total habits, 1 for today
I/flutter (16090): 🎨 Getting app theme: ThemeMode.system
I/flutter (16090): 🎨 App is in SYSTEM mode, device brightness: Brightness.dark → dark
I/flutter (16090): 🎨 Final theme mode to send to widgets: dark
I/flutter (16090): 🎨 Using app primary color: 4280391411
I/flutter (16090): 🎯 Widget data prepared: 1 habits in list, JSON length: 177
I/flutter (16090): 🎯 First 200 chars of habits JSON: [{"id":"1759603440661","name":"testing","category":"Health","colorValue":4280391411,"isCompleted":false,"status":"Due","timeDisplay":"11:45","frequency":"HabitFrequency.daily"}]
I/flutter (16090): 🎯 Theme data: dark, primary: 4280391411
I/flutter (16090): Saved widget theme data: dark, color: 4280391411
I/flutter (16090): Updating widget HabitTimelineWidgetProvider with data keys: [habits, nextHabit, selectedDate, themeMode, primaryColor, lastUpdate]
I/flutter (16090): ✅ Saved habits: length=177, preview=[{"id":"1759603440661","name":"testing","category":"Health","colorValue":4280391411,"isCompleted":false,"status":"Due","timeDisplay":"11:45","frequenc...
I/flutter (16090): ✅ Saved nextHabit: {"id":"1759603440661","name":"testing","category":"Health","colorValue":4280391411,"isCompleted":fal...
I/flutter (16090): ✅ Saved selectedDate: 2025-10-04
I/flutter (16090): ✅ Saved themeMode: dark
I/flutter (16090): ✅ Saved primaryColor: 4280391411
I/flutter (16090): ✅ Saved lastUpdate: 1759603443184
I/flutter (16090): Widget HabitTimelineWidgetProvider update completed
I/flutter (16090): Updating widget HabitCompactWidgetProvider with data keys: [habits, nextHabit, selectedDate, themeMode, primaryColor, lastUpdate]
I/flutter (16090): ✅ Saved habits: length=177, preview=[{"id":"1759603440661","name":"testing","category":"Health","colorValue":4280391411,"isCompleted":false,"status":"Due","timeDisplay":"11:45","frequenc...
I/flutter (16090): ✅ Saved nextHabit: {"id":"1759603440661","name":"testing","category":"Health","colorValue":4280391411,"isCompleted":fal...
I/flutter (16090): ✅ Saved selectedDate: 2025-10-04
I/flutter (16090): ✅ Saved themeMode: dark
I/flutter (16090): ✅ Saved primaryColor: 4280391411
I/flutter (16090): ✅ Saved lastUpdate: 1759603443184
I/flutter (16090): 🧪 FORCE UPDATE: Starting immediate widget update...
I/flutter (16090): ⏱️ Widget update already pending, will schedule another
I/flutter (16090): Widget HabitCompactWidgetProvider update completed
I/flutter (16090): ✅ All widgets updated successfully (debounced)
I/MainActivity(16090): Widget force refresh triggered for both compact and timeline widgets
I/flutter (16090): 🧪 FORCE UPDATE: Successfully triggered widget refresh via method channel
I/flutter (16090): 🧪 FORCE UPDATE: Completed successfully
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (16090): │ #1   AppLifecycleService._refreshWidgetsOnResume.<anonymous closure> (package:habitv8/services/app_lifecycle_service.dart:241:21)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 🐛 ✅ Widgets force refreshed successfully on app resume
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
W/JobInfo (16090): Requested important-while-foreground flag for job6 is ignored and takes no effect
D/WM-SystemJobScheduler(16090): Scheduling work ID 0880383f-06a6-4c86-bd75-25236740fcf7Job ID 6
D/WM-GreedyScheduler(16090): Starting work for 0880383f-06a6-4c86-bd75-25236740fcf7
D/WM-SystemJobService(16090): onStartJob for WorkGenerationalId(workSpecId=0880383f-06a6-4c86-bd75-25236740fcf7, generation=0)
D/WM-Processor(16090): Processor: processing WorkGenerationalId(workSpecId=0880383f-06a6-4c86-bd75-25236740fcf7, generation=0)
D/WM-Processor(16090): Work WorkGenerationalId(workSpecId=0880383f-06a6-4c86-bd75-25236740fcf7, generation=0) is already enqueued for processing
D/WM-WorkerWrapper(16090): Starting work for com.habittracker.habitv8.WidgetUpdateWorker
I/WidgetUpdateWorker(16090): Starting widget update work
D/WidgetUpdateWorker(16090): Widget data loaded: 177 characters
D/WidgetUpdateWorker(16090): Updating habits data: 177 characters
D/WidgetUpdateWorker(16090): Processed 1 total habits, 1 for today
D/WidgetUpdateWorker(16090): Theme settings copied: mode=null, color=ffffffff
D/WidgetUpdateWorker(16090): Widget data updated from Flutter preferences
I/WidgetUpdateWorker(16090): ✅ Widget update work completed successfully
I/WM-WorkerWrapper(16090): Worker result SUCCESS for Work [ id=0880383f-06a6-4c86-bd75-25236740fcf7, tags={ com.habittracker.habitv8.WidgetUpdateWorker } ]
D/WM-Processor(16090): Processor 0880383f-06a6-4c86-bd75-25236740fcf7 executed; reschedule = false
D/WM-SystemJobService(16090): 0880383f-06a6-4c86-bd75-25236740fcf7 executed on JobScheduler
D/WM-GreedyScheduler(16090): Cancelling work ID 0880383f-06a6-4c86-bd75-25236740fcf7
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (16090): │ #1   MidnightHabitResetService.checkForMissedResetOnAppActive (package:habitv8/services/midnight_habit_reset_service.dart:270:17)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 🐛 🔍 Checking for missed resets on app activation
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (16090): │ #1   MidnightHabitResetService._checkMissedReset (package:habitv8/services/midnight_habit_reset_service.dart:84:21)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 🐛 ✅ No missed reset - last reset was today
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (16090): │ #1   AppLifecycleService._checkMissedResetOnResume.<anonymous closure> (package:habitv8/services/app_lifecycle_service.dart:263:21)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 🐛 ✅ Missed reset check completed on app resume
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): Filtering 1 habits for date 2025-10-04:
I/flutter (16090):   - testing: HabitFrequency.daily -> INCLUDED
I/flutter (16090): Result: 1 habits for today
I/flutter (16090): Widget data preparation: Found 1 total habits, 1 for today
I/flutter (16090): 🎨 Getting app theme: ThemeMode.system
I/flutter (16090): 🎨 App is in SYSTEM mode, device brightness: Brightness.dark → dark
I/flutter (16090): 🎨 Final theme mode to send to widgets: dark
I/flutter (16090): 🎨 Using app primary color: 4280391411
I/flutter (16090): 🎯 Widget data prepared: 1 habits in list, JSON length: 177
I/flutter (16090): 🎯 First 200 chars of habits JSON: [{"id":"1759603440661","name":"testing","category":"Health","colorValue":4280391411,"isCompleted":false,"status":"Due","timeDisplay":"11:45","frequency":"HabitFrequency.daily"}]
I/flutter (16090): 🎯 Theme data: dark, primary: 4280391411
I/flutter (16090): Saved widget theme data: dark, color: 4280391411
I/flutter (16090): Updating widget HabitTimelineWidgetProvider with data keys: [habits, nextHabit, selectedDate, themeMode, primaryColor, lastUpdate]
I/flutter (16090): ✅ Saved habits: length=177, preview=[{"id":"1759603440661","name":"testing","category":"Health","colorValue":4280391411,"isCompleted":false,"status":"Due","timeDisplay":"11:45","frequenc...
I/flutter (16090): ✅ Saved nextHabit: {"id":"1759603440661","name":"testing","category":"Health","colorValue":4280391411,"isCompleted":fal...
I/flutter (16090): ✅ Saved selectedDate: 2025-10-04
I/flutter (16090): ✅ Saved themeMode: dark
I/flutter (16090): ✅ Saved primaryColor: 4280391411
I/flutter (16090): ✅ Saved lastUpdate: 1759603444108
I/flutter (16090): Widget HabitTimelineWidgetProvider update completed
I/flutter (16090): Updating widget HabitCompactWidgetProvider with data keys: [habits, nextHabit, selectedDate, themeMode, primaryColor, lastUpdate]
I/flutter (16090): ✅ Saved habits: length=177, preview=[{"id":"1759603440661","name":"testing","category":"Health","colorValue":4280391411,"isCompleted":false,"status":"Due","timeDisplay":"11:45","frequenc...
I/flutter (16090): ✅ Saved nextHabit: {"id":"1759603440661","name":"testing","category":"Health","colorValue":4280391411,"isCompleted":fal...
I/flutter (16090): ✅ Saved selectedDate: 2025-10-04
I/flutter (16090): ✅ Saved themeMode: dark
I/flutter (16090): ✅ Saved primaryColor: 4280391411
I/flutter (16090): ✅ Saved lastUpdate: 1759603444108
I/flutter (16090): Widget HabitCompactWidgetProvider update completed
I/flutter (16090): ✅ All widgets updated successfully (debounced)
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (16090): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:43:15)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 💡 🔍 Checking notification callback registration...
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (16090): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:44:15)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 💡 📦 Container available: true
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (16090): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:45:15)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 💡 🔗 Callback currently set: true
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (16090): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:56:17)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 💡 ✅ Notification action callback is properly registered
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
D/WindowOnBackDispatcher(16090): setTopOnBackInvokedCallback (unwrapped): androidx.activity.OnBackPressedDispatcher$Api34Impl$createOnBackAnimationCallback$1@c27e0e1
D/WindowOnBackDispatcher(16090): setTopOnBackInvokedCallback (unwrapped): android.app.Activity$$ExternalSyntheticLambda0@21c93d
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (16090): │ #1   AppLifecycleService.didChangeAppLifecycleState (package:habitv8/services/app_lifecycle_service.dart:63:15)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 💡 📱 App lifecycle state changed to: AppLifecycleState.inactive
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (16090): │ #1   AppLifecycleService.didChangeAppLifecycleState (package:habitv8/services/app_lifecycle_service.dart:82:19)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 💡 ⏹️ App inactive
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/MainActivity(16090): onPause: Preserving alarm sound if playing
D/VRI[MainActivity](16090): visibilityChanged oldVisibility=true newVisibility=false
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (16090): │ #1   AppLifecycleService.didChangeAppLifecycleState (package:habitv8/services/app_lifecycle_service.dart:63:15)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 💡 📱 App lifecycle state changed to: AppLifecycleState.hidden
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (16090): │ #1   AppLifecycleService.didChangeAppLifecycleState (package:habitv8/services/app_lifecycle_service.dart:85:19)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 💡 👁️ App hidden
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (16090): │ #1   AppLifecycleService.didChangeAppLifecycleState (package:habitv8/services/app_lifecycle_service.dart:63:15)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 💡 📱 App lifecycle state changed to: AppLifecycleState.paused
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (16090): │ #1   AppLifecycleService.didChangeAppLifecycleState (package:habitv8/services/app_lifecycle_service.dart:73:19)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 💡 ⏸️ App paused - performing background cleanup...
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (16090): │ #1   AppLifecycleService._performBackgroundCleanup (package:habitv8/services/app_lifecycle_service.dart:279:17)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 🐛 🧹 Performing background cleanup...
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (16090): │ #1   AppLifecycleService._performBackgroundCleanup (package:habitv8/services/app_lifecycle_service.dart:284:17)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 🐛 ✅ Background cleanup completed
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
D/ImeBackDispatcher(16090): Clear (mImeCallbacks.size=0)
D/ImeBackDispatcher(16090): switch root view (mImeCallbacks.size=0)
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (16090): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:43:15)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 💡 🔍 Checking notification callback registration...
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (16090): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:44:15)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 💡 📦 Container available: true
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (16090): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:45:15)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 💡 🔗 Callback currently set: true
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (16090): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:56:17)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 💡 ✅ Notification action callback is properly registered
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (16090): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:43:15)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 💡 🔍 Checking notification callback registration...
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (16090): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:44:15)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 💡 📦 Container available: true
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (16090): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:45:15)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 💡 🔗 Callback currently set: true
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (16090): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:56:17)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 💡 ✅ Notification action callback is properly registered
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): [IMPORTANT:flutter/shell/platform/android/android_context_vk_impeller.cc(62)] Using the Impeller rendering backend (Vulkan).
I/Choreographer(16090): Skipped 411 frames!  The application may be doing too much work on its main thread.
Performing hot reload...                                                
Reloaded 1 of 2041 libraries in 13,458ms (compile: 40 ms, reload: 3107 ms, reassemble: 1318 ms).
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (16090): │ #1   onBackgroundNotificationResponse (package:habitv8/services/notifications/notification_action_handler.dart:24:15)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 💡 🔔 BACKGROUND notification response received
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (16090): │ #1   onBackgroundNotificationResponse (package:habitv8/services/notifications/notification_action_handler.dart:25:15)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 💡 Background action ID: complete
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (16090): │ #1   onBackgroundNotificationResponse (package:habitv8/services/notifications/notification_action_handler.dart:26:15)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 💡 Background payload: {"habitId":"1759603440661","type":"habit_reminder"}
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (16090): │ #1   onBackgroundNotificationResponse (package:habitv8/services/notifications/notification_action_handler.dart:30:15)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 💡 ✅ Hive initialized in background handler
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (16090): │ #1   onBackgroundNotificationResponse (package:habitv8/services/notifications/notification_action_handler.dart:38:21)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 💡 Extracted habitId from payload: 1759603440661
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (16090): │ #1   onBackgroundNotificationResponse (package:habitv8/services/notifications/notification_action_handler.dart:42:23)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 💡 Processing background action: complete
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (16090): │ #1   NotificationActionHandler.completeHabitInBackground (package:habitv8/services/notifications/notification_action_handler.dart:180:17)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 💡 ⚙️ Completing habit in background: 1759603440661
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (16090): │ #1   AchievementsService.awardXP (package:habitv8/services/achievements_service.dart:782:17)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 💡 Awarded 10 XP for Getting Started. Total: 10
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (16090): │ #1   AchievementsService._unlockAchievement (package:habitv8/services/achievements_service.dart:904:19)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 💡 Achievement unlocked: Getting Started
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (16090): │ #1   AchievementsService.awardXP (package:habitv8/services/achievements_service.dart:782:17)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 💡 Awarded 75 XP for Perfect Week. Total: 85
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (16090): │ #1   AchievementsService._unlockAchievement (package:habitv8/services/achievements_service.dart:904:19)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 💡 Achievement unlocked: Perfect Week
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (16090): │ #1   AchievementsService.awardXP (package:habitv8/services/achievements_service.dart:782:17)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 💡 Awarded 300 XP for Flawless Month. Total: 385
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (16090): │ #1   AchievementsService._handleLevelUp (package:habitv8/services/achievements_service.dart:922:15)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 💡 Level up! 1 -> 2
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (16090): │ #1   AchievementsService._unlockAchievement (package:habitv8/services/achievements_service.dart:904:19)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 💡 Achievement unlocked: Flawless Month
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (16090): │ #1   HabitService._checkForAchievements (package:habitv8/data/database.dart:1367:19)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 💡 3 new achievement(s) unlocked
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (16090): │ #1   HabitService._checkForAchievements (package:habitv8/data/database.dart:1369:21)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 💡 Achievement unlocked: Getting Started
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (16090): │ #1   HabitService._checkForAchievements (package:habitv8/data/database.dart:1369:21)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 💡 Achievement unlocked: Perfect Week
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (16090): │ #1   HabitService._checkForAchievements (package:habitv8/data/database.dart:1369:21)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 💡 Achievement unlocked: Flawless Month
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (16090): │ #1   HabitService.markHabitComplete (package:habitv8/data/database.dart:1015:21)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 🐛 Calendar sync disabled, skipping completion sync for habit "testing"
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (16090): │ #1   NotificationActionHandler.completeHabitInBackground (package:habitv8/services/notifications/notification_action_handler.dart:195:17)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 💡 ✅ Habit completed in background: testing
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (16090): │ #1   NotificationActionHandler.completeHabitInBackground (package:habitv8/services/notifications/notification_action_handler.dart:200:19)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 💡 ✅ Widget updated after background completion
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (16090): │ #1   onBackgroundNotificationResponse (package:habitv8/services/notifications/notification_action_handler.dart:52:15)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 💡 ✅ Background notification response processed
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): Filtering 1 habits for date 2025-10-04:
I/flutter (16090):   - testing: HabitFrequency.daily -> INCLUDED
I/flutter (16090): Result: 1 habits for today
I/flutter (16090): Widget data preparation: Found 1 total habits, 1 for today
I/flutter (16090): 🎨 Getting app theme: ThemeMode.system
I/flutter (16090): 🎨 App is in SYSTEM mode, device brightness: Brightness.light → light
I/flutter (16090): 🎨 Final theme mode to send to widgets: light
I/flutter (16090): 🎨 Using app primary color: 4280391411
I/flutter (16090): 🎯 Widget data prepared: 1 habits in list, JSON length: 182
I/flutter (16090): 🎯 First 200 chars of habits JSON: [{"id":"1759603440661","name":"testing","category":"Health","colorValue":4280391411,"isCompleted":true,"status":"Completed","timeDisplay":"11:45","frequency":"HabitFrequency.daily"}]
I/flutter (16090): 🎯 Theme data: light, primary: 4280391411
I/flutter (16090): Saved widget theme data: light, color: 4280391411
I/flutter (16090): Updating widget HabitTimelineWidgetProvider with data keys: [habits, nextHabit, selectedDate, themeMode, primaryColor, lastUpdate]
I/flutter (16090): ✅ Saved habits: length=182, preview=[{"id":"1759603440661","name":"testing","category":"Health","colorValue":4280391411,"isCompleted":true,"status":"Completed","timeDisplay":"11:45","fre...
I/flutter (16090): ✅ Saved nextHabit: null
I/flutter (16090): ✅ Saved selectedDate: 2025-10-04
I/flutter (16090): ✅ Saved themeMode: light
I/flutter (16090): ✅ Saved primaryColor: 4280391411
I/flutter (16090): ✅ Saved lastUpdate: 1759603921455
I/flutter (16090): Widget HabitTimelineWidgetProvider update completed
I/flutter (16090): Updating widget HabitCompactWidgetProvider with data keys: [habits, nextHabit, selectedDate, themeMode, primaryColor, lastUpdate]
I/flutter (16090): ✅ Saved habits: length=182, preview=[{"id":"1759603440661","name":"testing","category":"Health","colorValue":4280391411,"isCompleted":true,"status":"Completed","timeDisplay":"11:45","fre...
I/flutter (16090): ✅ Saved nextHabit: null
I/flutter (16090): ✅ Saved selectedDate: 2025-10-04
I/flutter (16090): ✅ Saved themeMode: light
I/flutter (16090): ✅ Saved primaryColor: 4280391411
I/flutter (16090): ✅ Saved lastUpdate: 1759603921455
I/flutter (16090): Widget HabitCompactWidgetProvider update completed
I/flutter (16090): ✅ All widgets updated successfully (debounced)
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (16090): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:43:15)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 💡 🔍 Checking notification callback registration...
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (16090): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:44:15)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 💡 📦 Container available: true
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (16090): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:45:15)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 💡 🔗 Callback currently set: true
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (16090): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:56:17)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 💡 ✅ Notification action callback is properly registered
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
D/ViewRootImpl(16090): Skipping stats log for color mode
I/MainActivity(16090): onRestart: Preserving alarm sound if playing
D/MainActivity(16090): onNewIntent called with action: android.intent.action.MAIN
I/MainActivity(16090): onResume: Preserving alarm sound state
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (16090): │ #1   AppLifecycleService.didChangeAppLifecycleState (package:habitv8/services/app_lifecycle_service.dart:63:15)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 💡 📱 App lifecycle state changed to: AppLifecycleState.hidden
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (16090): │ #1   AppLifecycleService.didChangeAppLifecycleState (package:habitv8/services/app_lifecycle_service.dart:85:19)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 💡 👁️ App hidden
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (16090): │ #1   AppLifecycleService.didChangeAppLifecycleState (package:habitv8/services/app_lifecycle_service.dart:63:15)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 💡 📱 App lifecycle state changed to: AppLifecycleState.inactive
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (16090): │ #1   AppLifecycleService.didChangeAppLifecycleState (package:habitv8/services/app_lifecycle_service.dart:82:19)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 💡 ⏹️ App inactive
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
D/ImeBackDispatcher(16090): switch root view (mImeCallbacks.size=0)
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (16090): │ #1   AppLifecycleService.didChangeAppLifecycleState (package:habitv8/services/app_lifecycle_service.dart:63:15)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 💡 📱 App lifecycle state changed to: AppLifecycleState.resumed
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (16090): │ #1   AppLifecycleService.didChangeAppLifecycleState (package:habitv8/services/app_lifecycle_service.dart:78:19)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 💡 ▶️ App resumed
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (16090): │ #1   AppLifecycleService._handleAppResumed (package:habitv8/services/app_lifecycle_service.dart:125:17)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 💡 🔄 Handling app resume - re-registering notification callbacks...
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (16090): │ #1   AppLifecycleService._ensureDatabaseConnection (package:habitv8/services/app_lifecycle_service.dart:154:17)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 🐛 🔗 Ensuring database connection is valid...
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (16090): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:43:15)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 💡 🔍 Checking notification callback registration...
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (16090): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:44:15)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 💡 📦 Container available: true
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (16090): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:45:15)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 💡 🔗 Callback currently set: true
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (16090): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:56:17)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 💡 ✅ Notification action callback is properly registered
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (16090): │ #1   AppLifecycleService._processPendingActionsWithRetry (package:habitv8/services/app_lifecycle_service.dart:207:15)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 💡 🔄 Scheduling pending action processing attempt 1/5 with 1000ms delay
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (16090): │ #1   AppLifecycleService._refreshWidgetsOnResume (package:habitv8/services/app_lifecycle_service.dart:234:17)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 🐛 🔄 Force refreshing widgets on app resume...
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (16090): │ #1   AppLifecycleService._checkMissedResetOnResume (package:habitv8/services/app_lifecycle_service.dart:256:17)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 🐛 🔍 Checking for missed midnight resets on app resume...
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (16090): │ #1   AppLifecycleService._handleAppResumed (package:habitv8/services/app_lifecycle_service.dart:144:17)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 💡 ✅ App resume handling completed
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
D/InsetsController(16090): hide(ime())
I/ImeTracker(16090): com.habittracker.habitv8.debug:3554dd3a: onCancelled at PHASE_CLIENT_ALREADY_HIDDEN
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (16090): │ #1   AppLifecycleService._ensureDatabaseConnection.<anonymous closure> (package:habitv8/services/app_lifecycle_service.dart:165:23)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 🐛 ✅ Database connection is healthy
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (16090): │ #1   NotificationActionHandler.processPendingActionsManually (package:habitv8/services/notifications/notification_action_handler.dart:779:15)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 💡 🔄 Manually processing pending actions
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (16090): │ #1   NotificationActionHandler.processPendingActionsManually (package:habitv8/services/notifications/notification_action_handler.dart:783:17)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 💡 ✅ Using callback to process pending actions
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (16090): │ #1   NotificationActionHandler.processPendingActions (package:habitv8/services/notifications/notification_action_handler.dart:213:17)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 💡 ⏭️  Skipping - initial pending actions already processed
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (16090): │ #1   AppLifecycleService._processPendingActionsWithRetry.<anonymous closure> (package:habitv8/services/app_lifecycle_service.dart:213:19)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 💡 ✅ Pending actions processed successfully on attempt 1
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): 🧪 FORCE UPDATE: Starting immediate widget update...
I/flutter (16090): Filtering 1 habits for date 2025-10-04:
I/flutter (16090):   - testing: HabitFrequency.daily -> INCLUDED
I/flutter (16090): Result: 1 habits for today
I/flutter (16090): Widget data preparation: Found 1 total habits, 1 for today
I/flutter (16090): 🎨 Getting app theme: ThemeMode.system
I/flutter (16090): 🎨 App is in SYSTEM mode, device brightness: Brightness.dark → dark
I/flutter (16090): 🎨 Final theme mode to send to widgets: dark
I/flutter (16090): 🎨 Using app primary color: 4280391411
I/flutter (16090): 🎯 Widget data prepared: 1 habits in list, JSON length: 177
I/flutter (16090): 🎯 First 200 chars of habits JSON: [{"id":"1759603440661","name":"testing","category":"Health","colorValue":4280391411,"isCompleted":false,"status":"Due","timeDisplay":"11:45","frequency":"HabitFrequency.daily"}]
I/flutter (16090): 🎯 Theme data: dark, primary: 4280391411
I/MainActivity(16090): Widget force refresh triggered for both compact and timeline widgets
I/flutter (16090): 🧪 FORCE UPDATE: Successfully triggered widget refresh via method channel
I/flutter (16090): 🧪 FORCE UPDATE: Completed successfully
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (16090): │ #1   AppLifecycleService._refreshWidgetsOnResume.<anonymous closure> (package:habitv8/services/app_lifecycle_service.dart:241:21)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 🐛 ✅ Widgets force refreshed successfully on app resume
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): Saved widget theme data: dark, color: 4280391411
I/flutter (16090): Updating widget HabitTimelineWidgetProvider with data keys: [habits, nextHabit, selectedDate, themeMode, primaryColor, lastUpdate]
I/flutter (16090): ✅ Saved habits: length=177, preview=[{"id":"1759603440661","name":"testing","category":"Health","colorValue":4280391411,"isCompleted":false,"status":"Due","timeDisplay":"11:45","frequenc...
I/flutter (16090): ✅ Saved nextHabit: null
I/flutter (16090): ✅ Saved selectedDate: 2025-10-04
I/flutter (16090): ✅ Saved themeMode: dark
I/flutter (16090): ✅ Saved primaryColor: 4280391411
I/flutter (16090): ✅ Saved lastUpdate: 1759603930045
W/JobInfo (16090): Requested important-while-foreground flag for job7 is ignored and takes no effect
D/WM-SystemJobScheduler(16090): Scheduling work ID 989ba7ea-cbe9-4e48-9f5b-51dd111ae61cJob ID 7
D/WM-GreedyScheduler(16090): Starting work for 989ba7ea-cbe9-4e48-9f5b-51dd111ae61c
D/WM-SystemJobService(16090): onStartJob for WorkGenerationalId(workSpecId=989ba7ea-cbe9-4e48-9f5b-51dd111ae61c, generation=0)
D/WM-Processor(16090): Processor: processing WorkGenerationalId(workSpecId=989ba7ea-cbe9-4e48-9f5b-51dd111ae61c, generation=0)
D/WM-Processor(16090): Work WorkGenerationalId(workSpecId=989ba7ea-cbe9-4e48-9f5b-51dd111ae61c, generation=0) is already enqueued for processing
D/WM-WorkerWrapper(16090): Starting work for com.habittracker.habitv8.WidgetUpdateWorker
I/WidgetUpdateWorker(16090): Starting widget update work
D/WidgetUpdateWorker(16090): Widget data loaded: 177 characters
D/WidgetUpdateWorker(16090): Updating habits data: 177 characters
D/WidgetUpdateWorker(16090): Processed 1 total habits, 1 for today
D/WidgetUpdateWorker(16090): Theme settings copied: mode=null, color=ffffffff
D/WidgetUpdateWorker(16090): Widget data updated from Flutter preferences
I/WidgetUpdateWorker(16090): ✅ Widget update work completed successfully
I/WM-WorkerWrapper(16090): Worker result SUCCESS for Work [ id=989ba7ea-cbe9-4e48-9f5b-51dd111ae61c, tags={ com.habittracker.habitv8.WidgetUpdateWorker } ]
D/WM-Processor(16090): Processor 989ba7ea-cbe9-4e48-9f5b-51dd111ae61c executed; reschedule = false
D/WM-SystemJobService(16090): 989ba7ea-cbe9-4e48-9f5b-51dd111ae61c executed on JobScheduler
D/WM-GreedyScheduler(16090): Cancelling work ID 989ba7ea-cbe9-4e48-9f5b-51dd111ae61c
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (16090): │ #1   MidnightHabitResetService.checkForMissedResetOnAppActive (package:habitv8/services/midnight_habit_reset_service.dart:270:17)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 🐛 🔍 Checking for missed resets on app activation
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (16090): │ #1   MidnightHabitResetService._checkMissedReset (package:habitv8/services/midnight_habit_reset_service.dart:84:21)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 🐛 ✅ No missed reset - last reset was today
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (16090): │ #1   AppLifecycleService._checkMissedResetOnResume.<anonymous closure> (package:habitv8/services/app_lifecycle_service.dart:263:21)
I/flutter (16090): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (16090): │ 🐛 ✅ Missed reset check completed on app resume
I/flutter (16090): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (16090): Widget HabitTimelineWidgetProvider update completed
I/flutter (16090): Updating widget HabitCompactWidgetProvider with data keys: [habits, nextHabit, selectedDate, themeMode, primaryColor, lastUpdate]
I/flutter (16090): ✅ Saved habits: length=177, preview=[{"id":"1759603440661","name":"testing","category":"Health","colorValue":4280391411,"isCompleted":false,"status":"Due","timeDisplay":"11:45","frequenc...
I/flutter (16090): ✅ Saved nextHabit: null
I/flutter (16090): ✅ Saved selectedDate: 2025-10-04
I/flutter (16090): ✅ Saved themeMode: dark
I/flutter (16090): ✅ Saved primaryColor: 4280391411
I/flutter (16090): ✅ Saved lastUpdate: 1759603930045
I/flutter (16090): Widget HabitCompactWidgetProvider update completed