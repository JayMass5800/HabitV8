I/flutter ( 1105): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter ( 1105): │ #1   AppLifecycleService.didChangeAppLifecycleState (package:habitv8/services/app_lifecycle_service.dart:63:15)
I/flutter ( 1105): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 1105): │ 💡 📱 App lifecycle state changed to: AppLifecycleState.inactive
I/flutter ( 1105): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter ( 1105): │ #1   AppLifecycleService.didChangeAppLifecycleState (package:habitv8/services/app_lifecycle_service.dart:82:19)
I/flutter ( 1105): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 1105): │ 💡 ⏹️ App inactive
I/flutter ( 1105): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): Saved widget theme data: dark, color: 4280391411
I/flutter ( 1105): Updating widget HabitTimelineWidgetProvider with data keys: [habits, nextHabit, selectedDate, themeMode, primaryColor, lastUpdate]
I/flutter ( 1105): ✅ Saved habits: length=1697, preview=[{"id":"1759563363513_0","name":"Blood Pressure Med","category":"Health","colorValue":4283215696,"isCompleted":true,"status":"Completed","timeDisplay"...
I/flutter ( 1105): ✅ Saved nextHabit: {"id":"1759563367825_8","name":"open My News app","category":"Learning","colorValue":4294940672,"isC...
I/flutter ( 1105): ✅ Saved selectedDate: 2025-10-04
I/flutter ( 1105): ✅ Saved themeMode: dark
I/flutter ( 1105): ✅ Saved primaryColor: 4280391411
W/JobInfo ( 1105): Requested important-while-foreground flag for job101 is ignored and takes no effect
D/WM-SystemJobScheduler( 1105): Scheduling work ID db9e7799-9b37-49e4-a532-d84b795ef749Job ID 101
I/flutter ( 1105): ✅ Saved lastUpdate: 1759602623719
D/WM-SystemJobService( 1105): onStartJob for WorkGenerationalId(workSpecId=db9e7799-9b37-49e4-a532-d84b795ef749, generation=0)
D/WM-GreedyScheduler( 1105): Starting work for db9e7799-9b37-49e4-a532-d84b795ef749
D/WM-Processor( 1105): Processor: processing WorkGenerationalId(workSpecId=db9e7799-9b37-49e4-a532-d84b795ef749, generation=0)
D/WM-Processor( 1105): Work WorkGenerationalId(workSpecId=db9e7799-9b37-49e4-a532-d84b795ef749, generation=0) is already enqueued for processing
D/WM-WorkerWrapper( 1105): Starting work for com.habittracker.habitv8.WidgetUpdateWorker
I/WidgetUpdateWorker( 1105): Starting widget update work
D/WidgetUpdateWorker( 1105): Widget data loaded: 1697 characters
D/WidgetUpdateWorker( 1105): Updating habits data: 1697 characters
D/WidgetUpdateWorker( 1105): Processed 9 total habits, 9 for today
D/WidgetUpdateWorker( 1105): Theme settings copied: mode=null, color=ffffffff
D/WidgetUpdateWorker( 1105): Widget data updated from Flutter preferences
D/WidgetUpdateWorker( 1105): Updated 1 timeline widgets
D/HabitTimelineWidget( 1105): onUpdate called with 1 widget IDs
D/HabitTimelineWidget( 1105): ListView setup completed for widget 15 (service will read fresh theme data)
D/HabitTimelineWidget( 1105): Detected theme mode: 'dark'
D/HabitTimelineWidget( 1105): Using theme - mode: 'dark', primary: ff2196f3
D/HabitTimelineWidget( 1105): Semi-transparent theme applied - isDark: true, bg: 800f0f0f
D/HabitTimelineWidget( 1105): Found habits in widgetData
D/HabitTimelineService( 1105): onDataSetChanged called - reloading habit data
D/HabitTimelineService( 1105): 🎨 Loading fresh theme data from preferences:
D/HabitTimelineService( 1105):   - HomeWidget['themeMode']: dark
D/HabitTimelineService( 1105):   - Flutter['flutter.theme_mode']: null
D/HabitTimelineService( 1105): 🎨 Final detected theme mode: 'dark'
D/HabitTimelineService( 1105): Theme applied - isDark: true, textColor: ffffffff, primary: ff2196f3
D/HabitTimelineService( 1105): ✅ Found habits data at key 'habits', length: 1697, preview: [{"id":"1759563363513_0","name":"Blood Pressure Med","category":"Health","colorValue":4283215696,"is
D/HabitTimelineService( 1105): Attempting to load habits from key: habits, Raw length: 1697
D/HabitTimelineWidget( 1105): Widget update completed for ID: 15
I/WidgetUpdateWorker( 1105): ✅ Widget update work completed successfully
D/HabitTimelineService( 1105): Loaded 9 habits for timeline widget
D/HabitTimelineService( 1105): First habit keys: [id, name, category, colorValue, isCompleted, status, timeDisplay, frequency]
D/HabitTimelineService( 1105): getCount returning: 9 habits
D/HabitTimelineService( 1105): getViewAt position: 0
D/HabitTimelineService( 1105): Created view for habit: Blood Pressure Med at position 0
I/WM-WorkerWrapper( 1105): Worker result SUCCESS for Work [ id=db9e7799-9b37-49e4-a532-d84b795ef749, tags={ com.habittracker.habitv8.WidgetUpdateWorker } ]
D/HabitTimelineService( 1105): getViewAt position: 1
D/HabitTimelineService( 1105): Created view for habit: daily advance at position 1
D/HabitTimelineService( 1105): getViewAt position: 2
D/HabitTimelineService( 1105): Created view for habit: Drink water at position 2
D/HabitTimelineService( 1105): getViewAt position: 3
D/HabitTimelineService( 1105): Created view for habit: completion test at position 3
D/HabitTimelineService( 1105): getViewAt position: 4
D/HabitTimelineService( 1105): Created view for habit: complete testing at position 4
D/WM-Processor( 1105): Processor db9e7799-9b37-49e4-a532-d84b795ef749 executed; reschedule = false
D/WM-SystemJobService( 1105): db9e7799-9b37-49e4-a532-d84b795ef749 executed on JobScheduler
D/HabitTimelineService( 1105): getViewAt position: 5
D/HabitTimelineService( 1105): Created view for habit: ghjkkll at position 5
D/HabitTimelineService( 1105): getViewAt position: 6
D/HabitTimelineService( 1105): Created view for habit: open My News app at position 6
D/HabitTimelineService( 1105): getViewAt position: 7
D/HabitTimelineService( 1105): Created view for habit: Cholesterol Med at position 7
D/HabitTimelineService( 1105): getViewAt position: 8
D/HabitTimelineService( 1105): Created view for habit: Put the bins out at position 8
D/WM-GreedyScheduler( 1105): Cancelling work ID db9e7799-9b37-49e4-a532-d84b795ef749
D/HabitTimelineService( 1105): getCount returning: 9 habits
D/HabitTimelineService( 1105): getViewAt position: 0
D/HabitTimelineService( 1105): Created view for habit: Blood Pressure Med at position 0
D/HabitTimelineService( 1105): getViewAt position: 1
D/HabitTimelineService( 1105): Created view for habit: daily advance at position 1
D/HabitTimelineService( 1105): getViewAt position: 2
D/HabitTimelineService( 1105): Created view for habit: Drink water at position 2
D/HabitTimelineService( 1105): getViewAt position: 3
D/HabitTimelineService( 1105): Created view for habit: completion test at position 3
D/HabitTimelineService( 1105): getViewAt position: 4
D/HabitTimelineService( 1105): Created view for habit: complete testing at position 4
D/HabitTimelineService( 1105): getViewAt position: 5
D/HabitTimelineService( 1105): Created view for habit: ghjkkll at position 5
D/HabitTimelineService( 1105): getViewAt position: 6
D/HabitTimelineService( 1105): Created view for habit: open My News app at position 6
D/HabitTimelineService( 1105): getViewAt position: 7
D/HabitTimelineService( 1105): Created view for habit: Cholesterol Med at position 7
D/HabitTimelineService( 1105): getViewAt position: 8
D/HabitTimelineService( 1105): Created view for habit: Put the bins out at position 8
D/HabitTimelineService( 1105): onDataSetChanged called - reloading habit data
D/HabitTimelineService( 1105): 🎨 Loading fresh theme data from preferences:
D/HabitTimelineService( 1105):   - HomeWidget['themeMode']: dark
D/HabitTimelineService( 1105):   - Flutter['flutter.theme_mode']: null
D/HabitTimelineService( 1105): 🎨 Final detected theme mode: 'dark'
D/HabitTimelineService( 1105): Theme applied - isDark: true, textColor: ffffffff, primary: ff2196f3
D/HabitTimelineService( 1105): ✅ Found habits data at key 'habits', length: 1697, preview: [{"id":"1759563363513_0","name":"Blood Pressure Med","category":"Health","colorValue":4283215696,"is
D/HabitTimelineService( 1105): Attempting to load habits from key: habits, Raw length: 1697
D/HabitTimelineService( 1105): Loaded 9 habits for timeline widget
D/HabitTimelineService( 1105): First habit keys: [id, name, category, colorValue, isCompleted, status, timeDisplay, frequency]
D/HabitTimelineService( 1105): getCount returning: 9 habits
D/HabitTimelineService( 1105): getViewAt position: 0
D/HabitTimelineService( 1105): Created view for habit: Blood Pressure Med at position 0
D/HabitTimelineService( 1105): getViewAt position: 1
D/HabitTimelineService( 1105): Created view for habit: daily advance at position 1
D/HabitTimelineService( 1105): getViewAt position: 2
D/HabitTimelineService( 1105): Created view for habit: Drink water at position 2
D/HabitTimelineService( 1105): getViewAt position: 3
D/HabitTimelineService( 1105): Created view for habit: completion test at position 3
D/HabitTimelineService( 1105): getViewAt position: 4
D/HabitTimelineService( 1105): Created view for habit: complete testing at position 4
D/HabitTimelineService( 1105): getViewAt position: 5
D/HabitTimelineService( 1105): Created view for habit: ghjkkll at position 5
D/HabitTimelineService( 1105): getViewAt position: 6
D/HabitTimelineService( 1105): Created view for habit: open My News app at position 6
D/HabitTimelineService( 1105): getViewAt position: 7
D/HabitTimelineService( 1105): Created view for habit: Cholesterol Med at position 7
D/HabitTimelineService( 1105): getViewAt position: 8
D/HabitTimelineService( 1105): Created view for habit: Put the bins out at position 8
I/flutter ( 1105): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter ( 1105): │ #1   MidnightHabitResetService.checkForMissedResetOnAppActive (package:habitv8/services/midnight_habit_reset_service.dart:270:17)
I/flutter ( 1105): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 1105): │ 🐛 🔍 Checking for missed resets on app activation
I/flutter ( 1105): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter ( 1105): │ #1   MidnightHabitResetService._checkMissedReset (package:habitv8/services/midnight_habit_reset_service.dart:84:21)
I/flutter ( 1105): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 1105): │ 🐛 ✅ No missed reset - last reset was today
I/flutter ( 1105): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter ( 1105): │ #1   AppLifecycleService._checkMissedResetOnResume.<anonymous closure> (package:habitv8/services/app_lifecycle_service.dart:263:21)
I/flutter ( 1105): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 1105): │ 🐛 ✅ Missed reset check completed on app resume
I/flutter ( 1105): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): Widget HabitTimelineWidgetProvider update completed
I/flutter ( 1105): Updating widget HabitCompactWidgetProvider with data keys: [habits, nextHabit, selectedDate, themeMode, primaryColor, lastUpdate]
I/flutter ( 1105): ✅ Saved habits: length=1697, preview=[{"id":"1759563363513_0","name":"Blood Pressure Med","category":"Health","colorValue":4283215696,"isCompleted":true,"status":"Completed","timeDisplay"...
I/flutter ( 1105): ✅ Saved nextHabit: {"id":"1759563367825_8","name":"open My News app","category":"Learning","colorValue":4294940672,"isC...
I/flutter ( 1105): ✅ Saved selectedDate: 2025-10-04
I/flutter ( 1105): ✅ Saved themeMode: dark
I/flutter ( 1105): ✅ Saved primaryColor: 4280391411
I/flutter ( 1105): ✅ Saved lastUpdate: 1759602623719
I/flutter ( 1105): Widget HabitCompactWidgetProvider update completed
I/flutter ( 1105): ✅ All widgets updated successfully (debounced)
D/ImeBackDispatcher( 1105): switch root view (mImeCallbacks.size=0)
I/flutter ( 1105): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter ( 1105): │ #1   AppLifecycleService.didChangeAppLifecycleState (package:habitv8/services/app_lifecycle_service.dart:63:15)
I/flutter ( 1105): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 1105): │ 💡 📱 App lifecycle state changed to: AppLifecycleState.resumed
I/flutter ( 1105): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter ( 1105): │ #1   AppLifecycleService.didChangeAppLifecycleState (package:habitv8/services/app_lifecycle_service.dart:78:19)
I/flutter ( 1105): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 1105): │ 💡 ▶️ App resumed
I/flutter ( 1105): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter ( 1105): │ #1   AppLifecycleService._handleAppResumed (package:habitv8/services/app_lifecycle_service.dart:125:17)
I/flutter ( 1105): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 1105): │ 💡 🔄 Handling app resume - re-registering notification callbacks...
I/flutter ( 1105): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter ( 1105): │ #1   AppLifecycleService._ensureDatabaseConnection (package:habitv8/services/app_lifecycle_service.dart:154:17)
I/flutter ( 1105): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 1105): │ 🐛 🔗 Ensuring database connection is valid...
I/flutter ( 1105): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter ( 1105): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:43:15)
I/flutter ( 1105): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 1105): │ 💡 🔍 Checking notification callback registration...
I/flutter ( 1105): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter ( 1105): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:44:15)
I/flutter ( 1105): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 1105): │ 💡 📦 Container available: true
I/flutter ( 1105): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter ( 1105): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:45:15)
I/flutter ( 1105): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 1105): │ 💡 🔗 Callback currently set: true
I/flutter ( 1105): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter ( 1105): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:56:17)
I/flutter ( 1105): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 1105): │ 💡 ✅ Notification action callback is properly registered
I/flutter ( 1105): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter ( 1105): │ #1   AppLifecycleService._processPendingActionsWithRetry (package:habitv8/services/app_lifecycle_service.dart:207:15)
I/flutter ( 1105): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 1105): │ 💡 🔄 Scheduling pending action processing attempt 1/5 with 1000ms delay
I/flutter ( 1105): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter ( 1105): │ #1   AppLifecycleService._refreshWidgetsOnResume (package:habitv8/services/app_lifecycle_service.dart:234:17)
I/flutter ( 1105): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 1105): │ 🐛 🔄 Force refreshing widgets on app resume...
I/flutter ( 1105): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter ( 1105): │ #1   AppLifecycleService._checkMissedResetOnResume (package:habitv8/services/app_lifecycle_service.dart:256:17)
I/flutter ( 1105): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 1105): │ 🐛 🔍 Checking for missed midnight resets on app resume...
I/flutter ( 1105): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter ( 1105): │ #1   AppLifecycleService._handleAppResumed (package:habitv8/services/app_lifecycle_service.dart:144:17)
I/flutter ( 1105): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 1105): │ 💡 ✅ App resume handling completed
I/flutter ( 1105): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
D/InsetsController( 1105): hide(ime())
I/ImeTracker( 1105): com.habittracker.habitv8.debug:e066951d: onCancelled at PHASE_CLIENT_ALREADY_HIDDEN
I/flutter ( 1105): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter ( 1105): │ #1   AppLifecycleService._ensureDatabaseConnection.<anonymous closure> (package:habitv8/services/app_lifecycle_service.dart:165:23)
I/flutter ( 1105): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 1105): │ 🐛 ✅ Database connection is healthy
I/flutter ( 1105): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter ( 1105): │ #1   NotificationActionHandler.processPendingActionsManually (package:habitv8/services/notifications/notification_action_handler.dart:779:15)
I/flutter ( 1105): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 1105): │ 💡 🔄 Manually processing pending actions
I/flutter ( 1105): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter ( 1105): │ #1   NotificationActionHandler.processPendingActionsManually (package:habitv8/services/notifications/notification_action_handler.dart:783:17)
I/flutter ( 1105): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 1105): │ 💡 ✅ Using callback to process pending actions
I/flutter ( 1105): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter ( 1105): │ #1   NotificationActionHandler.processPendingActions (package:habitv8/services/notifications/notification_action_handler.dart:213:17)
I/flutter ( 1105): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 1105): │ 💡 ⏭️  Skipping - initial pending actions already processed
I/flutter ( 1105): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter ( 1105): │ #1   AppLifecycleService._processPendingActionsWithRetry.<anonymous closure> (package:habitv8/services/app_lifecycle_service.dart:213:19)
I/flutter ( 1105): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 1105): │ 💡 ✅ Pending actions processed successfully on attempt 1
I/flutter ( 1105): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): 🧪 FORCE UPDATE: Starting immediate widget update...
I/flutter ( 1105): Filtering 13 habits for date 2025-10-04:
I/flutter ( 1105):   - Blood Pressure Med: HabitFrequency.daily -> INCLUDED
I/flutter ( 1105):   - Cholesterol Med: HabitFrequency.daily -> INCLUDED
I/flutter ( 1105):   - Put the bins out: HabitFrequency.monthly -> INCLUDED
I/flutter ( 1105):   - Put the bins out!: HabitFrequency.monthly -> EXCLUDED
I/flutter ( 1105):   - Vibration Plate: HabitFrequency.weekly -> EXCLUDED
I/flutter ( 1105):   - Shower you animal!: HabitFrequency.weekly -> EXCLUDED
I/flutter ( 1105):   - 10am late Drop Off: HabitFrequency.weekly -> EXCLUDED
I/flutter ( 1105):   - Drink water: HabitFrequency.hourly -> INCLUDED
I/flutter ( 1105):   - open My News app: HabitFrequency.daily -> INCLUDED
I/flutter ( 1105):   - daily advance: HabitFrequency.daily -> INCLUDED
I/flutter ( 1105):   - completion test: HabitFrequency.daily -> INCLUDED
I/flutter ( 1105):   - complete testing: HabitFrequency.daily -> INCLUDED
I/flutter ( 1105):   - ghjkkll: HabitFrequency.daily -> INCLUDED
I/flutter ( 1105): Result: 9 habits for today
I/flutter ( 1105): Widget data preparation: Found 13 total habits, 9 for today
I/flutter ( 1105): 🎨 Getting app theme: ThemeMode.system
I/flutter ( 1105): 🎨 App is in SYSTEM mode, device brightness: Brightness.dark → dark
I/flutter ( 1105): 🎨 Final theme mode to send to widgets: dark
I/flutter ( 1105): 🎨 Using app primary color: 4280391411
I/flutter ( 1105): 🎯 Widget data prepared: 9 habits in list, JSON length: 1697
I/flutter ( 1105): 🎯 First 200 chars of habits JSON: [{"id":"1759563363513_0","name":"Blood Pressure Med","category":"Health","colorValue":4283215696,"isCompleted":true,"status":"Completed","timeDisplay":"08:30","frequency":"HabitFrequency.daily"},{"id"
I/flutter ( 1105): 🎯 Theme data: dark, primary: 4280391411
I/MainActivity( 1105): Widget force refresh triggered for both compact and timeline widgets
I/flutter ( 1105): 🧪 FORCE UPDATE: Successfully triggered widget refresh via method channel
I/flutter ( 1105): 🧪 FORCE UPDATE: Completed successfully
I/flutter ( 1105): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter ( 1105): │ #1   AppLifecycleService._refreshWidgetsOnResume.<anonymous closure> (package:habitv8/services/app_lifecycle_service.dart:241:21)
I/flutter ( 1105): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 1105): │ 🐛 ✅ Widgets force refreshed successfully on app resume
I/flutter ( 1105): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): Saved widget theme data: dark, color: 4280391411
I/flutter ( 1105): Updating widget HabitTimelineWidgetProvider with data keys: [habits, nextHabit, selectedDate, themeMode, primaryColor, lastUpdate]
I/flutter ( 1105): ✅ Saved habits: length=1697, preview=[{"id":"1759563363513_0","name":"Blood Pressure Med","category":"Health","colorValue":4283215696,"isCompleted":true,"status":"Completed","timeDisplay"...
I/flutter ( 1105): ✅ Saved nextHabit: {"id":"1759563367825_8","name":"open My News app","category":"Learning","colorValue":4294940672,"isC...
I/flutter ( 1105): ✅ Saved selectedDate: 2025-10-04
I/flutter ( 1105): ✅ Saved themeMode: dark
I/flutter ( 1105): ✅ Saved primaryColor: 4280391411
I/flutter ( 1105): ✅ Saved lastUpdate: 1759602631022
W/JobInfo ( 1105): Requested important-while-foreground flag for job102 is ignored and takes no effect
D/WM-SystemJobScheduler( 1105): Scheduling work ID b931308e-d17d-4114-a1dd-336a57f3860fJob ID 102
D/WM-GreedyScheduler( 1105): Starting work for b931308e-d17d-4114-a1dd-336a57f3860f
D/WM-SystemJobService( 1105): onStartJob for WorkGenerationalId(workSpecId=b931308e-d17d-4114-a1dd-336a57f3860f, generation=0)
D/WM-Processor( 1105): Processor: processing WorkGenerationalId(workSpecId=b931308e-d17d-4114-a1dd-336a57f3860f, generation=0)
D/WM-Processor( 1105): Work WorkGenerationalId(workSpecId=b931308e-d17d-4114-a1dd-336a57f3860f, generation=0) is already enqueued for processing
D/WM-WorkerWrapper( 1105): Starting work for com.habittracker.habitv8.WidgetUpdateWorker
I/WidgetUpdateWorker( 1105): Starting widget update work
D/WidgetUpdateWorker( 1105): Widget data loaded: 1697 characters
D/WidgetUpdateWorker( 1105): Updating habits data: 1697 characters
D/WidgetUpdateWorker( 1105): Processed 9 total habits, 9 for today
D/WidgetUpdateWorker( 1105): Theme settings copied: mode=null, color=ffffffff
D/WidgetUpdateWorker( 1105): Widget data updated from Flutter preferences
D/WidgetUpdateWorker( 1105): Updated 1 timeline widgets
D/HabitTimelineWidget( 1105): onUpdate called with 1 widget IDs
D/HabitTimelineWidget( 1105): ListView setup completed for widget 15 (service will read fresh theme data)
D/HabitTimelineWidget( 1105): Detected theme mode: 'dark'
D/HabitTimelineWidget( 1105): Using theme - mode: 'dark', primary: ff2196f3
D/HabitTimelineWidget( 1105): Semi-transparent theme applied - isDark: true, bg: 800f0f0f
D/HabitTimelineWidget( 1105): Found habits in widgetData
D/HabitTimelineWidget( 1105): Widget update completed for ID: 15
I/WidgetUpdateWorker( 1105): ✅ Widget update work completed successfully
I/WM-WorkerWrapper( 1105): Worker result SUCCESS for Work [ id=b931308e-d17d-4114-a1dd-336a57f3860f, tags={ com.habittracker.habitv8.WidgetUpdateWorker } ]
D/WM-Processor( 1105): Processor b931308e-d17d-4114-a1dd-336a57f3860f executed; reschedule = false
D/WM-SystemJobService( 1105): b931308e-d17d-4114-a1dd-336a57f3860f executed on JobScheduler
D/HabitTimelineService( 1105): onDataSetChanged called - reloading habit data
D/HabitTimelineService( 1105): 🎨 Loading fresh theme data from preferences:
D/HabitTimelineService( 1105):   - HomeWidget['themeMode']: dark
D/HabitTimelineService( 1105):   - Flutter['flutter.theme_mode']: null
D/HabitTimelineService( 1105): 🎨 Final detected theme mode: 'dark'
D/WM-GreedyScheduler( 1105): Cancelling work ID b931308e-d17d-4114-a1dd-336a57f3860f
D/HabitTimelineService( 1105): Theme applied - isDark: true, textColor: ffffffff, primary: ff2196f3
D/HabitTimelineService( 1105): ✅ Found habits data at key 'habits', length: 1697, preview: [{"id":"1759563363513_0","name":"Blood Pressure Med","category":"Health","colorValue":4283215696,"is
D/HabitTimelineService( 1105): Attempting to load habits from key: habits, Raw length: 1697
D/HabitTimelineService( 1105): Loaded 9 habits for timeline widget
D/HabitTimelineService( 1105): First habit keys: [id, name, category, colorValue, isCompleted, status, timeDisplay, frequency]
D/HabitTimelineService( 1105): getCount returning: 9 habits
D/HabitTimelineService( 1105): getViewAt position: 0
D/HabitTimelineService( 1105): Created view for habit: Blood Pressure Med at position 0
D/HabitTimelineService( 1105): getViewAt position: 1
D/HabitTimelineService( 1105): Created view for habit: daily advance at position 1
D/HabitTimelineService( 1105): getViewAt position: 2
D/HabitTimelineService( 1105): Created view for habit: Drink water at position 2
D/HabitTimelineService( 1105): getViewAt position: 3
D/HabitTimelineService( 1105): Created view for habit: completion test at position 3
D/HabitTimelineService( 1105): getViewAt position: 4
D/HabitTimelineService( 1105): Created view for habit: complete testing at position 4
D/HabitTimelineService( 1105): getViewAt position: 5
D/HabitTimelineService( 1105): Created view for habit: ghjkkll at position 5
D/HabitTimelineService( 1105): getViewAt position: 6
D/HabitTimelineService( 1105): Created view for habit: open My News app at position 6
D/HabitTimelineService( 1105): getViewAt position: 7
D/HabitTimelineService( 1105): Created view for habit: Cholesterol Med at position 7
D/HabitTimelineService( 1105): getViewAt position: 8
D/HabitTimelineService( 1105): Created view for habit: Put the bins out at position 8
D/HabitTimelineService( 1105): getCount returning: 9 habits
D/HabitTimelineService( 1105): getViewAt position: 0
D/HabitTimelineService( 1105): Created view for habit: Blood Pressure Med at position 0
D/HabitTimelineService( 1105): getViewAt position: 1
D/HabitTimelineService( 1105): Created view for habit: daily advance at position 1
D/HabitTimelineService( 1105): getViewAt position: 2
D/HabitTimelineService( 1105): Created view for habit: Drink water at position 2
D/HabitTimelineService( 1105): getViewAt position: 3
D/HabitTimelineService( 1105): Created view for habit: completion test at position 3
D/HabitTimelineService( 1105): getViewAt position: 4
D/HabitTimelineService( 1105): Created view for habit: complete testing at position 4
D/HabitTimelineService( 1105): getViewAt position: 5
D/HabitTimelineService( 1105): Created view for habit: ghjkkll at position 5
D/HabitTimelineService( 1105): getViewAt position: 6
D/HabitTimelineService( 1105): Created view for habit: open My News app at position 6
D/HabitTimelineService( 1105): getViewAt position: 7
D/HabitTimelineService( 1105): Created view for habit: Cholesterol Med at position 7
D/HabitTimelineService( 1105): getViewAt position: 8
D/HabitTimelineService( 1105): Created view for habit: Put the bins out at position 8
D/HabitTimelineService( 1105): onDataSetChanged called - reloading habit data
D/HabitTimelineService( 1105): 🎨 Loading fresh theme data from preferences:
D/HabitTimelineService( 1105):   - HomeWidget['themeMode']: dark
D/HabitTimelineService( 1105):   - Flutter['flutter.theme_mode']: null
D/HabitTimelineService( 1105): 🎨 Final detected theme mode: 'dark'
D/HabitTimelineService( 1105): Theme applied - isDark: true, textColor: ffffffff, primary: ff2196f3
D/HabitTimelineService( 1105): ✅ Found habits data at key 'habits', length: 1697, preview: [{"id":"1759563363513_0","name":"Blood Pressure Med","category":"Health","colorValue":4283215696,"is
D/HabitTimelineService( 1105): Attempting to load habits from key: habits, Raw length: 1697
D/HabitTimelineService( 1105): Loaded 9 habits for timeline widget
D/HabitTimelineService( 1105): First habit keys: [id, name, category, colorValue, isCompleted, status, timeDisplay, frequency]
D/HabitTimelineService( 1105): getCount returning: 9 habits
D/HabitTimelineService( 1105): getViewAt position: 0
D/HabitTimelineService( 1105): Created view for habit: Blood Pressure Med at position 0
D/HabitTimelineService( 1105): getViewAt position: 1
D/HabitTimelineService( 1105): Created view for habit: daily advance at position 1
D/HabitTimelineService( 1105): getViewAt position: 2
D/HabitTimelineService( 1105): Created view for habit: Drink water at position 2
D/HabitTimelineService( 1105): getViewAt position: 3
D/HabitTimelineService( 1105): Created view for habit: completion test at position 3
D/HabitTimelineService( 1105): getViewAt position: 4
D/HabitTimelineService( 1105): Created view for habit: complete testing at position 4
D/HabitTimelineService( 1105): getViewAt position: 5
D/HabitTimelineService( 1105): Created view for habit: ghjkkll at position 5
D/HabitTimelineService( 1105): getViewAt position: 6
D/HabitTimelineService( 1105): Created view for habit: open My News app at position 6
D/HabitTimelineService( 1105): getViewAt position: 7
D/HabitTimelineService( 1105): Created view for habit: Cholesterol Med at position 7
D/HabitTimelineService( 1105): getViewAt position: 8
D/HabitTimelineService( 1105): Created view for habit: Put the bins out at position 8
I/flutter ( 1105): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter ( 1105): │ #1   MidnightHabitResetService.checkForMissedResetOnAppActive (package:habitv8/services/midnight_habit_reset_service.dart:270:17)
I/flutter ( 1105): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 1105): │ 🐛 🔍 Checking for missed resets on app activation
I/flutter ( 1105): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter ( 1105): │ #1   MidnightHabitResetService._checkMissedReset (package:habitv8/services/midnight_habit_reset_service.dart:84:21)
I/flutter ( 1105): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 1105): │ 🐛 ✅ No missed reset - last reset was today
I/flutter ( 1105): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter ( 1105): │ #1   AppLifecycleService._checkMissedResetOnResume.<anonymous closure> (package:habitv8/services/app_lifecycle_service.dart:263:21)
I/flutter ( 1105): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 1105): │ 🐛 ✅ Missed reset check completed on app resume
I/flutter ( 1105): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): Widget HabitTimelineWidgetProvider update completed
I/flutter ( 1105): Updating widget HabitCompactWidgetProvider with data keys: [habits, nextHabit, selectedDate, themeMode, primaryColor, lastUpdate]
I/flutter ( 1105): ✅ Saved habits: length=1697, preview=[{"id":"1759563363513_0","name":"Blood Pressure Med","category":"Health","colorValue":4283215696,"isCompleted":true,"status":"Completed","timeDisplay"...
I/flutter ( 1105): ✅ Saved nextHabit: {"id":"1759563367825_8","name":"open My News app","category":"Learning","colorValue":4294940672,"isC...
I/flutter ( 1105): ✅ Saved selectedDate: 2025-10-04
I/flutter ( 1105): ✅ Saved themeMode: dark
I/flutter ( 1105): ✅ Saved primaryColor: 4280391411
I/flutter ( 1105): ✅ Saved lastUpdate: 1759602631022
I/flutter ( 1105): Widget HabitCompactWidgetProvider update completed
I/flutter ( 1105): ✅ All widgets updated successfully (debounced)
D/WindowOnBackDispatcher( 1105): setTopOnBackInvokedCallback (unwrapped): androidx.activity.OnBackPressedDispatcher$Api34Impl$createOnBackAnimationCallback$1@78c2244
I/ImeTracker( 1105): com.habittracker.habitv8.debug:fd02c954: onRequestShow at ORIGIN_CLIENT reason SHOW_SOFT_INPUT fromUser false
D/InsetsController( 1105): show(ime())
D/ImeBackDispatcher( 1105): Undo preliminary clear (mImeCallbacks.size=0)
D/InsetsController( 1105): Setting requestedVisibleTypes to -1 (was -9)
D/InputConnectionAdaptor( 1105): The input method toggled cursor monitoring on
D/ImeBackDispatcher( 1105): Register received callback id=213350146 priority=0
D/WindowOnBackDispatcher( 1105): setTopOnBackInvokedCallback (unwrapped): android.view.ImeBackAnimationController@2928386
I/ImeTracker( 1105): com.habittracker.habitv8.debug:fd02c954: onShown
I/ImeTracker( 1105): com.habittracker.habitv8.debug:56d74054: onRequestHide at ORIGIN_CLIENT reason HIDE_SOFT_INPUT fromUser false
D/InsetsController( 1105): hide(ime())
D/ImeBackDispatcher( 1105): Preliminary clear (mImeCallbacks.size=1)
D/WindowOnBackDispatcher( 1105): setTopOnBackInvokedCallback (unwrapped): androidx.activity.OnBackPressedDispatcher$Api34Impl$createOnBackAnimationCallback$1@78c2244
D/InsetsController( 1105): Setting requestedVisibleTypes to -9 (was -1)
D/InputConnectionAdaptor( 1105): The input method toggled cursor monitoring off
D/ImeBackDispatcher( 1105): Unregister received callback id=213350146
I/ImeTracker( 1105): system_server:292a708f: onCancelled at PHASE_CLIENT_ON_CONTROLS_CHANGED
I/flutter ( 1105): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter ( 1105): │ #1   _CreateHabitScreenV2State._generateRRuleFromSimpleMode (package:habitv8/ui/screens/create_habit_screen_v2.dart:1719:17)
I/flutter ( 1105): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 1105): │ 💡 ✅ Generated RRule from simple mode: FREQ=DAILY
I/flutter ( 1105): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter ( 1105): │ #1   NotificationScheduler.cancelHabitNotificationsByHabitId (package:habitv8/services/notifications/notification_scheduler.dart:674:15)
I/flutter ( 1105): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 1105): │ 🐛 🚫 Starting notification cancellation for habit: 1759602654944
I/flutter ( 1105): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter ( 1105): │ #1   NotificationScheduler.scheduleHabitNotifications (package:habitv8/services/notifications/notification_scheduler.dart:207:15)
I/flutter ( 1105): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 1105): │ 🐛 Starting notification scheduling for habit: assf (isNewHabit: true)
I/flutter ( 1105): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter ( 1105): │ #1   NotificationScheduler.scheduleHabitNotifications (package:habitv8/services/notifications/notification_scheduler.dart:210:15)
I/flutter ( 1105): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 1105): │ 🐛 Notifications enabled: true
I/flutter ( 1105): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter ( 1105): │ #1   NotificationCore.ensureNotificationPermissions (package:habitv8/services/notifications/notification_core.dart:280:17)
I/flutter ( 1105): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 1105): │ 💡 Checking notification permission...
I/flutter ( 1105): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter ( 1105): │ #1   NotificationCore.ensureNotificationPermissions (package:habitv8/services/notifications/notification_core.dart:296:19)
I/flutter ( 1105): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 1105): │ 💡 Notification permission already granted
I/flutter ( 1105): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter ( 1105): │ #1   PermissionService.hasExactAlarmPermission (package:habitv8/services/permission_service.dart:143:17)
I/flutter ( 1105): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 1105): │ 💡 Checking exact alarm permission status...
I/flutter ( 1105): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter ( 1105): │ #1   PermissionService.hasExactAlarmPermission (package:habitv8/services/permission_service.dart:147:17)
I/flutter ( 1105): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 1105): │ 💡 Exact alarm permission check result: true (simplified)
I/flutter ( 1105): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter ( 1105): │ #1   NotificationCore.ensureNotificationPermissions (package:habitv8/services/notifications/notification_core.dart:318:19)
I/flutter ( 1105): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 1105): │ 💡 Exact alarm permission already available
I/flutter ( 1105): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter ( 1105): │ #1   NotificationScheduler.scheduleHabitNotifications (package:habitv8/services/notifications/notification_scheduler.dart:267:17)
I/flutter ( 1105): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 1105): │ 🐛 Scheduling for 11:32
I/flutter ( 1105): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter ( 1105): │ #1   NotificationScheduler.scheduleHabitNotifications (package:habitv8/services/notifications/notification_scheduler.dart:283:19)
I/flutter ( 1105): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 1105): │ 🐛 Skipping notification cancellation - new habit with no existing notifications
I/flutter ( 1105): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter ( 1105): │ #1   NotificationScheduler.scheduleHabitNotifications (package:habitv8/services/notifications/notification_scheduler.dart:290:19)
I/flutter ( 1105): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 1105): │ 🐛 Scheduling RRule-based notifications
I/flutter ( 1105): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
W/System  ( 1105): A resource failed to call release. 
W/System  ( 1105): A resource failed to call release. 
I/r.habitv8.debug( 1105): Background concurrent mark compact GC freed 33MB AllocSpace bytes, 79(29MB) LOS objects, 44% free, 120MB/216MB, paused 184us,4.675ms total 780.407ms
I/r.habitv8.debug( 1105): Background young concurrent mark compact GC freed 115MB AllocSpace bytes, 257(93MB) LOS objects, 9% free, 196MB/216MB, paused 93us,5.962ms total 1.008s
I/r.habitv8.debug( 1105): Background concurrent mark compact GC freed 118MB AllocSpace bytes, 251(95MB) LOS objects, 75% free, 20MB/81MB, paused 350us,3.447ms total 125.636ms
I/flutter ( 1105): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter ( 1105): │ #1   NotificationScheduler._scheduleRRuleHabitNotifications (package:habitv8/services/notifications/notification_scheduler.dart:823:17)
I/flutter ( 1105): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 1105): │ 💡 📅 Scheduled 85 RRule notifications for assf
I/flutter ( 1105): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter ( 1105): │ #1   NotificationScheduler.scheduleHabitNotifications (package:habitv8/services/notifications/notification_scheduler.dart:327:17)
I/flutter ( 1105): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 1105): │ 💡 ✅ Successfully scheduled notifications for habit: assf
I/flutter ( 1105): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter ( 1105): │ #1   NotificationAlarmScheduler.scheduleHabitAlarms (package:habitv8/services/notifications/notification_alarm_scheduler.dart:30:15)
I/flutter ( 1105): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 1105): │ 🐛 Starting alarm scheduling for habit: assf
I/flutter ( 1105): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter ( 1105): │ #1   NotificationAlarmScheduler.scheduleHabitAlarms (package:habitv8/services/notifications/notification_alarm_scheduler.dart:31:15)
I/flutter ( 1105): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 1105): │ 🐛 Alarm enabled: false
I/flutter ( 1105): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter ( 1105): │ #1   NotificationAlarmScheduler.scheduleHabitAlarms (package:habitv8/services/notifications/notification_alarm_scheduler.dart:32:15)
I/flutter ( 1105): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 1105): │ 🐛 Alarm sound: null
I/flutter ( 1105): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter ( 1105): │ #1   NotificationAlarmScheduler.scheduleHabitAlarms (package:habitv8/services/notifications/notification_alarm_scheduler.dart:33:15)
I/flutter ( 1105): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 1105): │ 🐛 Alarm sound URI: null
I/flutter ( 1105): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter ( 1105): │ #1   NotificationAlarmScheduler.scheduleHabitAlarms (package:habitv8/services/notifications/notification_alarm_scheduler.dart:37:17)
I/flutter ( 1105): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 1105): │ 🐛 Skipping alarms - disabled
I/flutter ( 1105): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter ( 1105): │ #1   NotificationAlarmScheduler.scheduleHabitAlarms (package:habitv8/services/notifications/notification_alarm_scheduler.dart:38:17)
I/flutter ( 1105): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 1105): │ 💡 Alarms disabled for habit: assf
I/flutter ( 1105): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter ( 1105): │ #1   HabitService.addHabit (package:habitv8/data/database.dart:622:21)
I/flutter ( 1105): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 1105): │ 💡 Scheduled notifications/alarms for new habit "assf"
I/flutter ( 1105): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter ( 1105): │ #1   HabitService.addHabit (package:habitv8/data/database.dart:636:21)
I/flutter ( 1105): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 1105): │ 🐛 Calendar sync disabled, skipping sync for new habit "assf"
I/flutter ( 1105): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/WidgetUpdateWorker( 1105): ✅ Immediate widget update triggered
I/MainActivity( 1105): Immediate widget update triggered via WidgetUpdateWorker
I/flutter ( 1105): Android widget immediate update triggered
I/flutter ( 1105): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter ( 1105): │ #1   NotificationScheduler.cancelHabitNotificationsByHabitId (package:habitv8/services/notifications/notification_scheduler.dart:674:15)
I/flutter ( 1105): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 1105): │ 🐛 🚫 Starting notification cancellation for habit: 1759602654944
I/flutter ( 1105): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
W/JobInfo ( 1105): Requested important-while-foreground flag for job103 is ignored and takes no effect
D/WM-SystemJobScheduler( 1105): Scheduling work ID 94c102a8-818c-4c93-b3d0-ea93f4d1c4a4Job ID 103
D/WM-GreedyScheduler( 1105): Starting work for 94c102a8-818c-4c93-b3d0-ea93f4d1c4a4
D/WM-Processor( 1105): Processor: processing WorkGenerationalId(workSpecId=94c102a8-818c-4c93-b3d0-ea93f4d1c4a4, generation=0)
D/WM-WorkerWrapper( 1105): Starting work for com.habittracker.habitv8.WidgetUpdateWorker
I/WidgetUpdateWorker( 1105): Starting widget update work
D/WidgetUpdateWorker( 1105): Widget data loaded: 1697 characters
D/WidgetUpdateWorker( 1105): Updating habits data: 1697 characters
D/WM-SystemJobService( 1105): onStartJob for WorkGenerationalId(workSpecId=94c102a8-818c-4c93-b3d0-ea93f4d1c4a4, generation=0)
D/WM-Processor( 1105): Work WorkGenerationalId(workSpecId=94c102a8-818c-4c93-b3d0-ea93f4d1c4a4, generation=0) is already enqueued for processing
D/WidgetUpdateWorker( 1105): Processed 9 total habits, 9 for today
D/WidgetUpdateWorker( 1105): Theme settings copied: mode=null, color=ffffffff
D/WidgetUpdateWorker( 1105): Widget data updated from Flutter preferences
D/WidgetUpdateWorker( 1105): Updated 1 timeline widgets
D/HabitTimelineWidget( 1105): onUpdate called with 1 widget IDs
D/HabitTimelineWidget( 1105): ListView setup completed for widget 15 (service will read fresh theme data)
D/HabitTimelineWidget( 1105): Detected theme mode: 'dark'
D/HabitTimelineWidget( 1105): Using theme - mode: 'dark', primary: ff2196f3
D/HabitTimelineWidget( 1105): Semi-transparent theme applied - isDark: true, bg: 800f0f0f
D/HabitTimelineWidget( 1105): Found habits in widgetData
D/HabitTimelineWidget( 1105): Widget update completed for ID: 15
I/WidgetUpdateWorker( 1105): ✅ Widget update work completed successfully
I/WM-WorkerWrapper( 1105): Worker result SUCCESS for Work [ id=94c102a8-818c-4c93-b3d0-ea93f4d1c4a4, tags={ com.habittracker.habitv8.WidgetUpdateWorker,immediate_widget_update } ]
D/HabitTimelineService( 1105): onDataSetChanged called - reloading habit data
D/HabitTimelineService( 1105): 🎨 Loading fresh theme data from preferences:
D/HabitTimelineService( 1105):   - HomeWidget['themeMode']: dark
D/HabitTimelineService( 1105):   - Flutter['flutter.theme_mode']: null
D/HabitTimelineService( 1105): 🎨 Final detected theme mode: 'dark'
D/HabitTimelineService( 1105): Theme applied - isDark: true, textColor: ffffffff, primary: ff2196f3
D/HabitTimelineService( 1105): ✅ Found habits data at key 'habits', length: 1697, preview: [{"id":"1759563363513_0","name":"Blood Pressure Med","category":"Health","colorValue":4283215696,"is
D/HabitTimelineService( 1105): Attempting to load habits from key: habits, Raw length: 1697
D/HabitTimelineService( 1105): Loaded 9 habits for timeline widget
D/HabitTimelineService( 1105): First habit keys: [id, name, category, colorValue, isCompleted, status, timeDisplay, frequency]
D/HabitTimelineService( 1105): getCount returning: 9 habits
D/HabitTimelineService( 1105): getViewAt position: 0
D/HabitTimelineService( 1105): Created view for habit: Blood Pressure Med at position 0
D/HabitTimelineService( 1105): getViewAt position: 1
D/HabitTimelineService( 1105): Created view for habit: daily advance at position 1
D/HabitTimelineService( 1105): getViewAt position: 2
D/HabitTimelineService( 1105): Created view for habit: Drink water at position 2
D/HabitTimelineService( 1105): getViewAt position: 3
D/HabitTimelineService( 1105): Created view for habit: completion test at position 3
D/HabitTimelineService( 1105): getViewAt position: 4
D/HabitTimelineService( 1105): Created view for habit: complete testing at position 4
D/HabitTimelineService( 1105): getViewAt position: 5
D/HabitTimelineService( 1105): Created view for habit: ghjkkll at position 5
D/HabitTimelineService( 1105): getViewAt position: 6
D/HabitTimelineService( 1105): Created view for habit: open My News app at position 6
D/HabitTimelineService( 1105): getViewAt position: 7
D/HabitTimelineService( 1105): Created view for habit: Cholesterol Med at position 7
D/HabitTimelineService( 1105): getViewAt position: 8
D/HabitTimelineService( 1105): Created view for habit: Put the bins out at position 8
D/HabitTimelineService( 1105): getCount returning: 9 habits
D/HabitTimelineService( 1105): getViewAt position: 0
D/HabitTimelineService( 1105): Created view for habit: Blood Pressure Med at position 0
D/HabitTimelineService( 1105): getViewAt position: 1
D/HabitTimelineService( 1105): Created view for habit: daily advance at position 1
D/HabitTimelineService( 1105): getViewAt position: 2
D/HabitTimelineService( 1105): Created view for habit: Drink water at position 2
D/HabitTimelineService( 1105): getViewAt position: 3
D/HabitTimelineService( 1105): Created view for habit: completion test at position 3
D/HabitTimelineService( 1105): getViewAt position: 4
D/HabitTimelineService( 1105): Created view for habit: complete testing at position 4
D/HabitTimelineService( 1105): getViewAt position: 5
D/HabitTimelineService( 1105): Created view for habit: ghjkkll at position 5
D/HabitTimelineService( 1105): getViewAt position: 6
D/HabitTimelineService( 1105): Created view for habit: open My News app at position 6
D/HabitTimelineService( 1105): getViewAt position: 7
D/HabitTimelineService( 1105): Created view for habit: Cholesterol Med at position 7
D/HabitTimelineService( 1105): getViewAt position: 8
D/HabitTimelineService( 1105): Created view for habit: Put the bins out at position 8
D/HabitTimelineService( 1105): onDataSetChanged called - reloading habit data
D/HabitTimelineService( 1105): 🎨 Loading fresh theme data from preferences:
D/HabitTimelineService( 1105):   - HomeWidget['themeMode']: dark
D/HabitTimelineService( 1105):   - Flutter['flutter.theme_mode']: null
D/HabitTimelineService( 1105): 🎨 Final detected theme mode: 'dark'
D/HabitTimelineService( 1105): Theme applied - isDark: true, textColor: ffffffff, primary: ff2196f3
D/HabitTimelineService( 1105): ✅ Found habits data at key 'habits', length: 1697, preview: [{"id":"1759563363513_0","name":"Blood Pressure Med","category":"Health","colorValue":4283215696,"is
D/HabitTimelineService( 1105): Attempting to load habits from key: habits, Raw length: 1697
D/HabitTimelineService( 1105): Loaded 9 habits for timeline widget
D/HabitTimelineService( 1105): First habit keys: [id, name, category, colorValue, isCompleted, status, timeDisplay, frequency]
D/HabitTimelineService( 1105): getCount returning: 9 habits
D/HabitTimelineService( 1105): getViewAt position: 0
D/HabitTimelineService( 1105): Created view for habit: Blood Pressure Med at position 0
D/HabitTimelineService( 1105): getViewAt position: 1
D/HabitTimelineService( 1105): Created view for habit: daily advance at position 1
D/HabitTimelineService( 1105): getViewAt position: 2
D/HabitTimelineService( 1105): Created view for habit: Drink water at position 2
D/HabitTimelineService( 1105): getViewAt position: 3
D/HabitTimelineService( 1105): Created view for habit: completion test at position 3
D/HabitTimelineService( 1105): getViewAt position: 4
D/HabitTimelineService( 1105): Created view for habit: complete testing at position 4
D/HabitTimelineService( 1105): getViewAt position: 5
D/HabitTimelineService( 1105): Created view for habit: ghjkkll at position 5
D/HabitTimelineService( 1105): getViewAt position: 6
D/HabitTimelineService( 1105): Created view for habit: open My News app at position 6
D/HabitTimelineService( 1105): getViewAt position: 7
D/HabitTimelineService( 1105): Created view for habit: Cholesterol Med at position 7
D/HabitTimelineService( 1105): getViewAt position: 8
D/HabitTimelineService( 1105): Created view for habit: Put the bins out at position 8
D/WM-Processor( 1105): Processor 94c102a8-818c-4c93-b3d0-ea93f4d1c4a4 executed; reschedule = false
D/WM-SystemJobService( 1105): 94c102a8-818c-4c93-b3d0-ea93f4d1c4a4 executed on JobScheduler
D/WM-GreedyScheduler( 1105): Cancelling work ID 94c102a8-818c-4c93-b3d0-ea93f4d1c4a4
D/WM-SystemJobService( 1105): onStopJob for WorkGenerationalId(workSpecId=94c102a8-818c-4c93-b3d0-ea93f4d1c4a4, generation=0)
I/flutter ( 1105): Filtering 14 habits for date 2025-10-04:
I/flutter ( 1105):   - Blood Pressure Med: HabitFrequency.daily -> INCLUDED
I/flutter ( 1105):   - Cholesterol Med: HabitFrequency.daily -> INCLUDED
I/flutter ( 1105):   - Put the bins out: HabitFrequency.monthly -> INCLUDED
I/flutter ( 1105):   - Put the bins out!: HabitFrequency.monthly -> EXCLUDED
I/flutter ( 1105):   - Vibration Plate: HabitFrequency.weekly -> EXCLUDED
I/flutter ( 1105):   - Shower you animal!: HabitFrequency.weekly -> EXCLUDED
I/flutter ( 1105):   - 10am late Drop Off: HabitFrequency.weekly -> EXCLUDED
I/flutter ( 1105):   - Drink water: HabitFrequency.hourly -> INCLUDED
I/flutter ( 1105):   - open My News app: HabitFrequency.daily -> INCLUDED
I/flutter ( 1105):   - daily advance: HabitFrequency.daily -> INCLUDED
I/flutter ( 1105):   - completion test: HabitFrequency.daily -> INCLUDED
I/flutter ( 1105):   - complete testing: HabitFrequency.daily -> INCLUDED
I/flutter ( 1105):   - ghjkkll: HabitFrequency.daily -> INCLUDED
I/flutter ( 1105):   - assf: HabitFrequency.daily -> INCLUDED
I/flutter ( 1105): Result: 10 habits for today
I/flutter ( 1105): Widget data preparation: Found 14 total habits, 10 for today
I/flutter ( 1105): 🎨 Getting app theme: ThemeMode.system
I/flutter ( 1105): 🎨 App is in SYSTEM mode, device brightness: Brightness.dark → dark
I/flutter ( 1105): 🎨 Final theme mode to send to widgets: dark
I/flutter ( 1105): 🎨 Using app primary color: 4280391411
I/flutter ( 1105): 🎯 Widget data prepared: 10 habits in list, JSON length: 1870
I/flutter ( 1105): 🎯 First 200 chars of habits JSON: [{"id":"1759563363513_0","name":"Blood Pressure Med","category":"Health","colorValue":4283215696,"isCompleted":true,"status":"Completed","timeDisplay":"08:30","frequency":"HabitFrequency.daily"},{"id"
I/flutter ( 1105): 🎯 Theme data: dark, primary: 4280391411
I/r.habitv8.debug( 1105): Background young concurrent mark compact GC freed 51MB AllocSpace bytes, 98(33MB) LOS objects, 60% free, 32MB/81MB, paused 105us,2.569ms total 213.035ms
I/flutter ( 1105): Saved widget theme data: dark, color: 4280391411
I/flutter ( 1105): Updating widget HabitTimelineWidgetProvider with data keys: [habits, nextHabit, selectedDate, themeMode, primaryColor, lastUpdate]
I/flutter ( 1105): ✅ Saved habits: length=1870, preview=[{"id":"1759563363513_0","name":"Blood Pressure Med","category":"Health","colorValue":4283215696,"isCompleted":true,"status":"Completed","timeDisplay"...
I/flutter ( 1105): ✅ Saved nextHabit: {"id":"1759602654944","name":"assf","category":"Health","colorValue":4280391411,"isCompleted":false,...
I/flutter ( 1105): ✅ Saved selectedDate: 2025-10-04
I/flutter ( 1105): ✅ Saved themeMode: dark
I/flutter ( 1105): ✅ Saved primaryColor: 4280391411
I/flutter ( 1105): ✅ Saved lastUpdate: 1759602658616
I/flutter ( 1105): Widget HabitTimelineWidgetProvider update completed
I/flutter ( 1105): Updating widget HabitCompactWidgetProvider with data keys: [habits, nextHabit, selectedDate, themeMode, primaryColor, lastUpdate]
I/flutter ( 1105): ✅ Saved habits: length=1870, preview=[{"id":"1759563363513_0","name":"Blood Pressure Med","category":"Health","colorValue":4283215696,"isCompleted":true,"status":"Completed","timeDisplay"...
I/flutter ( 1105): ✅ Saved nextHabit: {"id":"1759602654944","name":"assf","category":"Health","colorValue":4280391411,"isCompleted":false,...
I/flutter ( 1105): ✅ Saved selectedDate: 2025-10-04
I/flutter ( 1105): ✅ Saved themeMode: dark
I/flutter ( 1105): ✅ Saved primaryColor: 4280391411
I/flutter ( 1105): ✅ Saved lastUpdate: 1759602658616
I/flutter ( 1105): Widget HabitCompactWidgetProvider update completed
I/flutter ( 1105): ✅ All widgets updated successfully (debounced)
I/r.habitv8.debug( 1105): Waiting for a blocking GC Alloc
I/r.habitv8.debug( 1105): Clamp target GC heap from 351MB to 256MB
I/r.habitv8.debug( 1105): Background concurrent mark compact GC freed 62MB AllocSpace bytes, 141(53MB) LOS objects, 0% free, 255MB/256MB, paused 295us,6.951ms total 1.481s
I/r.habitv8.debug( 1105): Forcing collection of SoftReferences for 576KB allocation
I/r.habitv8.debug( 1105): Waiting for a blocking GC Alloc
I/r.habitv8.debug( 1105): Alloc concurrent mark compact GC freed 134MB AllocSpace bytes, 302(114MB) LOS objects, 77% free, 7141KB/30MB, paused 103us,1.188ms total 30.844ms
I/r.habitv8.debug( 1105): WaitForGcToComplete blocked Alloc on Alloc for 23.223ms
I/r.habitv8.debug( 1105): Background young concurrent mark compact GC freed 15MB AllocSpace bytes, 34(10MB) LOS objects, 0% free, 35MB/35MB, paused 115us,3.838ms total 165.035ms
I/flutter ( 1105): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter ( 1105): │ #1   NotificationScheduler.cancelHabitNotificationsByHabitId (package:habitv8/services/notifications/notification_scheduler.dart:711:19)
I/flutter ( 1105): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 1105): │ 💡 ✅ Cancelled 73 notifications for habit: 1759602654944 (scanned 376 pending)
I/flutter ( 1105): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter ( 1105): │ #1   NotificationScheduler.scheduleHabitNotifications (package:habitv8/services/notifications/notification_scheduler.dart:207:15)
I/flutter ( 1105): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 1105): │ 🐛 Starting notification scheduling for habit: assf (isNewHabit: true)
I/flutter ( 1105): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter ( 1105): │ #1   NotificationScheduler.scheduleHabitNotifications (package:habitv8/services/notifications/notification_scheduler.dart:210:15)
I/flutter ( 1105): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 1105): │ 🐛 Notifications enabled: true
I/flutter ( 1105): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter ( 1105): │ #1   NotificationCore.ensureNotificationPermissions (package:habitv8/services/notifications/notification_core.dart:280:17)
I/flutter ( 1105): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 1105): │ 💡 Checking notification permission...
I/flutter ( 1105): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter ( 1105): │ #1   NotificationCore.ensureNotificationPermissions (package:habitv8/services/notifications/notification_core.dart:296:19)
I/flutter ( 1105): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 1105): │ 💡 Notification permission already granted
I/flutter ( 1105): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter ( 1105): │ #1   PermissionService.hasExactAlarmPermission (package:habitv8/services/permission_service.dart:143:17)
I/flutter ( 1105): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 1105): │ 💡 Checking exact alarm permission status...
I/flutter ( 1105): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter ( 1105): │ #1   PermissionService.hasExactAlarmPermission (package:habitv8/services/permission_service.dart:147:17)
I/flutter ( 1105): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 1105): │ 💡 Exact alarm permission check result: true (simplified)
I/flutter ( 1105): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter ( 1105): │ #1   NotificationCore.ensureNotificationPermissions (package:habitv8/services/notifications/notification_core.dart:318:19)
I/flutter ( 1105): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 1105): │ 💡 Exact alarm permission already available
I/flutter ( 1105): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter ( 1105): │ #1   NotificationScheduler.scheduleHabitNotifications (package:habitv8/services/notifications/notification_scheduler.dart:267:17)
I/flutter ( 1105): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 1105): │ 🐛 Scheduling for 11:32
I/flutter ( 1105): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter ( 1105): │ #1   NotificationScheduler.scheduleHabitNotifications (package:habitv8/services/notifications/notification_scheduler.dart:283:19)
I/flutter ( 1105): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 1105): │ 🐛 Skipping notification cancellation - new habit with no existing notifications
I/flutter ( 1105): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter ( 1105): │ #1   NotificationScheduler.scheduleHabitNotifications (package:habitv8/services/notifications/notification_scheduler.dart:290:19)
I/flutter ( 1105): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 1105): │ 🐛 Scheduling RRule-based notifications
I/flutter ( 1105): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/r.habitv8.debug( 1105): Background concurrent mark compact GC freed 42MB AllocSpace bytes, 105(40MB) LOS objects, 49% free, 96MB/192MB, paused 182us,6.411ms total 734.336ms
I/r.habitv8.debug( 1105): Background young concurrent mark compact GC freed 101MB AllocSpace bytes, 238(84MB) LOS objects, 0% free, 197MB/197MB, paused 93us,7.240ms total 1.033s
I/r.habitv8.debug( 1105): Background concurrent mark compact GC freed 102MB AllocSpace bytes, 234(90MB) LOS objects, 44% free, 117MB/213MB, paused 166us,6.708ms total 631.536ms
I/flutter ( 1105): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter ( 1105): │ #1   NotificationScheduler._scheduleRRuleHabitNotifications (package:habitv8/services/notifications/notification_scheduler.dart:823:17)
I/flutter ( 1105): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 1105): │ 💡 📅 Scheduled 85 RRule notifications for assf
I/flutter ( 1105): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter ( 1105): │ #1   NotificationScheduler.scheduleHabitNotifications (package:habitv8/services/notifications/notification_scheduler.dart:327:17)
I/flutter ( 1105): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 1105): │ 💡 ✅ Successfully scheduled notifications for habit: assf
I/flutter ( 1105): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter ( 1105): │ #1   NotificationAlarmScheduler.scheduleHabitAlarms (package:habitv8/services/notifications/notification_alarm_scheduler.dart:30:15)
I/flutter ( 1105): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 1105): │ 🐛 Starting alarm scheduling for habit: assf
I/flutter ( 1105): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter ( 1105): │ #1   NotificationAlarmScheduler.scheduleHabitAlarms (package:habitv8/services/notifications/notification_alarm_scheduler.dart:31:15)
I/flutter ( 1105): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 1105): │ 🐛 Alarm enabled: false
I/flutter ( 1105): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter ( 1105): │ #1   NotificationAlarmScheduler.scheduleHabitAlarms (package:habitv8/services/notifications/notification_alarm_scheduler.dart:32:15)
I/flutter ( 1105): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 1105): │ 🐛 Alarm sound: null
I/flutter ( 1105): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter ( 1105): │ #1   NotificationAlarmScheduler.scheduleHabitAlarms (package:habitv8/services/notifications/notification_alarm_scheduler.dart:33:15)
I/flutter ( 1105): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 1105): │ 🐛 Alarm sound URI: null
I/flutter ( 1105): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter ( 1105): │ #1   NotificationAlarmScheduler.scheduleHabitAlarms (package:habitv8/services/notifications/notification_alarm_scheduler.dart:37:17)
I/flutter ( 1105): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 1105): │ 🐛 Skipping alarms - disabled
I/flutter ( 1105): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter ( 1105): │ #1   NotificationAlarmScheduler.scheduleHabitAlarms (package:habitv8/services/notifications/notification_alarm_scheduler.dart:38:17)
I/flutter ( 1105): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 1105): │ 💡 Alarms disabled for habit: assf
I/flutter ( 1105): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter ( 1105): │ #1   _CreateHabitScreenV2State._saveHabit (package:habitv8/ui/screens/create_habit_screen_v2.dart:1479:21)
I/flutter ( 1105): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 1105): │ 💡 Notifications/alarms scheduled successfully for habit: assf
I/flutter ( 1105): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter ( 1105): │ #1   _CreateHabitScreenV2State._saveHabit (package:habitv8/ui/screens/create_habit_screen_v2.dart:1503:19)
I/flutter ( 1105): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 1105): │ 💡 Habit created: assf
I/flutter ( 1105): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
D/WindowOnBackDispatcher( 1105): setTopOnBackInvokedCallback (unwrapped): android.app.Activity$$ExternalSyntheticLambda0@7f8efb
I/flutter ( 1105): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter ( 1105): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:43:15)
I/flutter ( 1105): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 1105): │ 💡 🔍 Checking notification callback registration...
I/flutter ( 1105): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter ( 1105): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:44:15)
I/flutter ( 1105): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 1105): │ 💡 📦 Container available: true
I/flutter ( 1105): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter ( 1105): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:45:15)
I/flutter ( 1105): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 1105): │ 💡 🔗 Callback currently set: true
I/flutter ( 1105): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 1105): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter ( 1105): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:56:17)
I/flutter ( 1105): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 1105): │ 💡 ✅ Notification action callback is properly registered