/WidgetUpdateWorker(29722): Widget data updated from Flutter preferences
D/WidgetUpdateWorker(29722): Updated 1 timeline widgets
D/HabitTimelineService(29722): onDataSetChanged called - FORCING reload (invalidating cache)
D/HabitTimelineWidget(29722): onUpdate called with 1 widget IDs
D/HabitTimelineService(29722): 🎨 Loading fresh theme data from preferences:
D/HabitTimelineService(29722):   - HomeWidget['themeMode']: dark
D/HabitTimelineService(29722):   - Flutter['flutter.theme_mode']: null
D/HabitTimelineService(29722): 🎨 Final detected theme mode: 'dark'
D/HabitTimelineService(29722): Theme applied - isDark: true, textColor: ffffffff, primary: ff2196f3
D/HabitTimelineService(29722): ✅ Found habits data at key 'habits', length: 354, preview: [{"id":"1759710702907","name":"fgjk","category":"Health","colorValue":4280391411,"isCompleted":true,
D/HabitTimelineService(29722): Attempting to load habits from key: habits, Raw length: 354
D/HabitTimelineWidget(29722): ListView setup completed for widget 34 (service will read fresh theme data)
D/HabitTimelineWidget(29722): Detected theme mode: 'dark'
D/HabitTimelineWidget(29722): Using theme - mode: 'dark', primary: ff2196f3
D/HabitTimelineWidget(29722): Semi-transparent theme applied - isDark: true, bg: 800f0f0f
D/HabitTimelineService(29722): Loaded 2 habits for timeline widget
D/HabitTimelineService(29722): First habit keys: [id, name, category, colorValue, isCompleted, status, timeDisplay, frequency]
D/HabitTimelineService(29722): getCount returning: 2 habits
D/HabitTimelineService(29722): getViewAt position: 0
D/HabitTimelineService(29722): Created view for habit: fgjk at position 0
D/HabitTimelineService(29722): getViewAt position: 1
D/HabitTimelineService(29722): Created view for habit: ghjjkj at position 1
D/HabitTimelineWidget(29722): Found habits in widgetData
D/HabitTimelineService(29722): getCount returning: 2 habits
D/HabitTimelineService(29722): getViewAt position: 0
D/HabitTimelineService(29722): Created view for habit: fgjk at position 0
D/HabitTimelineService(29722): getViewAt position: 1
D/HabitTimelineWidget(29722): Widget update completed for ID: 34
I/WidgetUpdateWorker(29722): ✅ Widget update work completed successfully
D/HabitTimelineService(29722): Created view for habit: ghjjkj at position 1
I/WM-WorkerWrapper(29722): Worker result SUCCESS for Work [ id=aedab2e4-f25e-420f-9973-8c9954a72f26, tags={ com.habittracker.habitv8.WidgetUpdateWorker } ]
D/WM-Processor(29722): Processor aedab2e4-f25e-420f-9973-8c9954a72f26 executed; reschedule = false
D/WM-SystemJobService(29722): aedab2e4-f25e-420f-9973-8c9954a72f26 executed on JobScheduler
D/HabitTimelineService(29722): onDataSetChanged called - FORCING reload (invalidating cache)
D/HabitTimelineService(29722): 🎨 Loading fresh theme data from preferences:
D/HabitTimelineService(29722):   - HomeWidget['themeMode']: dark
D/HabitTimelineService(29722):   - Flutter['flutter.theme_mode']: null
D/HabitTimelineService(29722): 🎨 Final detected theme mode: 'dark'
D/HabitTimelineService(29722): Theme applied - isDark: true, textColor: ffffffff, primary: ff2196f3
D/HabitTimelineService(29722): ✅ Found habits data at key 'habits', length: 354, preview: [{"id":"1759710702907","name":"fgjk","category":"Health","colorValue":4280391411,"isCompleted":true,
D/HabitTimelineService(29722): Attempting to load habits from key: habits, Raw length: 354
D/HabitTimelineService(29722): Loaded 2 habits for timeline widget
D/HabitTimelineService(29722): First habit keys: [id, name, category, colorValue, isCompleted, status, timeDisplay, frequency]
D/HabitTimelineService(29722): getCount returning: 2 habits
D/HabitTimelineService(29722): getViewAt position: 0
D/HabitTimelineService(29722): Created view for habit: fgjk at position 0
D/HabitTimelineService(29722): getViewAt position: 1
D/HabitTimelineService(29722): Created view for habit: ghjjkj at position 1
D/WM-GreedyScheduler(29722): Cancelling work ID aedab2e4-f25e-420f-9973-8c9954a72f26
I/flutter (29722): Widget HabitTimelineWidgetProvider update completed
I/flutter (29722): Updating widget HabitCompactWidgetProvider with data keys: [habits, nextHabit, selectedDate, themeMode, primaryColor, lastUpdate]
I/flutter (29722): ✅ Saved habits: length=354, preview=[{"id":"1759710702907","name":"fgjk","category":"Health","colorValue":4280391411,"isCompleted":true,"status":"Completed","timeDisplay":"17:32","freque...
I/flutter (29722): ✅ Saved nextHabit: {"id":"1759711330090","name":"ghjjkj","category":"Health","colorValue":4280391411,"isCompleted":fals...
I/flutter (29722): ✅ Saved selectedDate: 2025-10-05
I/flutter (29722): ✅ Saved themeMode: dark
I/flutter (29722): ✅ Saved primaryColor: 4280391411
I/flutter (29722): ✅ Saved lastUpdate: 1759711333068
I/flutter (29722): Widget HabitCompactWidgetProvider update completed
I/flutter (29722): ✅ All widgets updated successfully (debounced)
D/WindowOnBackDispatcher(29722): setTopOnBackInvokedCallback (unwrapped): androidx.activity.OnBackPressedDispatcher$Api34Impl$createOnBackAnimationCallback$1@ae54d1c
D/WindowOnBackDispatcher(29722): setTopOnBackInvokedCallback (unwrapped): android.app.Activity$$ExternalSyntheticLambda0@be17532
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (29722): │ #1   habitsProvider.<anonymous closure> (package:habitv8/data/database.dart:428:13)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 💡 🔍 habitsProvider: Starting to fetch habits from database
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (29722): │ #1   habitsProvider.<anonymous closure> (package:habitv8/data/database.dart:431:13)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 💡 🔍 habitsProvider: Fetched 2 habits from database
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (29722): │ #1   habitsProvider.<anonymous closure> (package:habitv8/data/database.dart:437:17)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 🐛    fgjk: 1 completions
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (29722): │ #1   AppLifecycleService.didChangeAppLifecycleState (package:habitv8/services/app_lifecycle_service.dart:69:15)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 💡 📱 App lifecycle state changed to: AppLifecycleState.inactive
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (29722): │ #1   AppLifecycleService.didChangeAppLifecycleState (package:habitv8/services/app_lifecycle_service.dart:88:19)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 💡 ⏹️ App inactive
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/MainActivity(29722): onPause: Preserving alarm sound if playing
D/VRI[MainActivity](29722): visibilityChanged oldVisibility=true newVisibility=false
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (29722): │ #1   AppLifecycleService.didChangeAppLifecycleState (package:habitv8/services/app_lifecycle_service.dart:69:15)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 💡 📱 App lifecycle state changed to: AppLifecycleState.hidden
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (29722): │ #1   AppLifecycleService.didChangeAppLifecycleState (package:habitv8/services/app_lifecycle_service.dart:91:19)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 💡 👁️ App hidden
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (29722): │ #1   AppLifecycleService.didChangeAppLifecycleState (package:habitv8/services/app_lifecycle_service.dart:69:15)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 💡 📱 App lifecycle state changed to: AppLifecycleState.paused
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (29722): │ #1   AppLifecycleService.didChangeAppLifecycleState (package:habitv8/services/app_lifecycle_service.dart:79:19)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 💡 ⏸️ App paused - performing background cleanup...
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (29722): │ #1   AppLifecycleService._performBackgroundCleanup (package:habitv8/services/app_lifecycle_service.dart:320:17)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 🐛 🧹 Performing background cleanup...
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (29722): │ #1   AppLifecycleService._performBackgroundCleanup (package:habitv8/services/app_lifecycle_service.dart:325:17)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 🐛 ✅ Background cleanup completed
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
D/ImeBackDispatcher(29722): Clear (mImeCallbacks.size=0)
D/ImeBackDispatcher(29722): switch root view (mImeCallbacks.size=0)
D/WM-DelayedWorkTracker(29722): Scheduling work dfbb9360-00da-4cc9-a76c-257d10894d3b
D/WM-GreedyScheduler(29722): Starting work for dfbb9360-00da-4cc9-a76c-257d10894d3b
D/WM-Processor(29722): Processor: processing WorkGenerationalId(workSpecId=dfbb9360-00da-4cc9-a76c-257d10894d3b, generation=0)
D/WM-WorkerWrapper(29722): Starting work for com.habittracker.habitv8.BootCompletionWorker
I/BootCompletionWorker(29722): Starting boot completion work
I/BootCompletionWorker(29722): ✅ Boot completion flag set for Flutter app
I/WidgetUpdateWorker(29722): ✅ Periodic widget updates scheduled (every 15 minutes)
I/WidgetUpdateWorker(29722): ✅ Fallback widget updates scheduled (every hour)
D/WM-GreedyScheduler(29722): Cancelling work ID e9bdcd67-3d18-49da-81e6-3d202d6970d0
I/BootCompletionWorker(29722): ✅ Flutter app started for notification rescheduling
D/WM-SystemJobScheduler(29722): Scheduling work ID e9bdcd67-3d18-49da-81e6-3d202d6970d0Job ID 25
D/WM-SystemJobService(29722): onStartJob for WorkGenerationalId(workSpecId=dfbb9360-00da-4cc9-a76c-257d10894d3b, generation=0)
D/WM-GreedyScheduler(29722): Cancelling work ID 84eb579e-f662-46f2-9c99-e577ba290e72
D/WM-SystemJobScheduler(29722): Scheduling work ID 84eb579e-f662-46f2-9c99-e577ba290e72Job ID 26
I/WM-WorkerWrapper(29722): Worker result SUCCESS for Work [ id=dfbb9360-00da-4cc9-a76c-257d10894d3b, tags={ com.habittracker.habitv8.BootCompletionWorker,boot_completion } ]
D/WM-Processor(29722): Processor dfbb9360-00da-4cc9-a76c-257d10894d3b executed; reschedule = false
D/WM-SystemJobService(29722): dfbb9360-00da-4cc9-a76c-257d10894d3b executed on JobScheduler
D/WM-Processor(29722): Processor: processing WorkGenerationalId(workSpecId=dfbb9360-00da-4cc9-a76c-257d10894d3b, generation=0)
D/WM-GreedyScheduler(29722): Cancelling work ID dfbb9360-00da-4cc9-a76c-257d10894d3b
D/WM-WorkerWrapper(29722): com.habittracker.habitv8.BootCompletionWorker is not in ENQUEUED state. Nothing more to do
D/WM-WorkerWrapper(29722): Status for dfbb9360-00da-4cc9-a76c-257d10894d3b is SUCCEEDED ; not doing any work
D/WM-Processor(29722): Processor dfbb9360-00da-4cc9-a76c-257d10894d3b executed; reschedule = false
D/WM-GreedyScheduler(29722): Cancelling work ID dfbb9360-00da-4cc9-a76c-257d10894d3b
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (29722): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:43:15)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 💡 🔍 Checking notification callback registration...
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (29722): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:44:15)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 💡 📦 Container available: true
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (29722): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:45:15)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 💡 🔗 Callback currently set: true
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (29722): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:56:17)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 💡 ✅ Notification action callback is properly registered
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): [IMPORTANT:flutter/shell/platform/android/android_context_vk_impeller.cc(62)] Using the Impeller rendering backend (Vulkan).
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (29722): │ #1   onBackgroundNotificationResponse (package:habitv8/services/notifications/notification_action_handler.dart:25:15)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 💡 🔔 BACKGROUND notification response received
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (29722): │ #1   onBackgroundNotificationResponse (package:habitv8/services/notifications/notification_action_handler.dart:26:15)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 💡 Background action ID: complete
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (29722): │ #1   onBackgroundNotificationResponse (package:habitv8/services/notifications/notification_action_handler.dart:27:15)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 💡 Background payload: {"habitId":"1759711330090","type":"habit_reminder"}
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (29722): │ #1   onBackgroundNotificationResponse (package:habitv8/services/notifications/notification_action_handler.dart:35:21)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 💡 Extracted habitId from payload: 1759711330090
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (29722): │ #1   onBackgroundNotificationResponse (package:habitv8/services/notifications/notification_action_handler.dart:39:23)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 💡 Processing background action: complete
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (29722): │ #1   onBackgroundNotificationResponse (package:habitv8/services/notifications/notification_action_handler.dart:57:25)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 💡 ! No handlers available, using background database access
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (29722): │ #1   onBackgroundNotificationResponse (package:habitv8/services/notifications/notification_action_handler.dart:61:25)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 💡 ✅ Hive initialized in background handler
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (29722): │ #1   NotificationActionHandler.completeHabitInBackground (package:habitv8/services/notifications/notification_action_handler.dart:200:17)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 💡 ⚙️ Completing habit in background: 1759711330090
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): 🔄 onHabitCompleted called - updating all widgets
I/flutter (29722): Error triggering Android widget update: MissingPluginException(No implementation found for method triggerImmediateUpdate on channel com.habittracker.habitv8/widget_update)
I/flutter (29722): ✅ Widget update completed after habit completion
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (29722): │ #1   HabitService.markHabitComplete (package:habitv8/data/database.dart:1148:21)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 🐛 Calendar sync disabled, skipping completion sync for habit "ghjjkj"
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (29722): │ #1   NotificationActionHandler.completeHabitInBackground (package:habitv8/services/notifications/notification_action_handler.dart:247:17)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 💡 ✅ Habit completed in background: ghjjkj
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (29722): │ #1   NotificationActionHandler.completeHabitInBackground (package:habitv8/services/notifications/notification_action_handler.dart:251:17)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 🐛 💾 Database flushed after background completion
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): Filtering 2 habits for date 2025-10-05:
I/flutter (29722):   - fgjk: HabitFrequency.daily -> INCLUDED
I/flutter (29722):   - ghjjkj: HabitFrequency.daily -> INCLUDED
I/flutter (29722): Result: 2 habits for today
I/flutter (29722): Widget data preparation: Found 2 total habits, 2 for today
I/flutter (29722): 🎨 Getting app theme: ThemeMode.system
I/flutter (29722): 🎨 App is in SYSTEM mode, device brightness: Brightness.light → light
I/flutter (29722): 🎨 Final theme mode to send to widgets: light
I/flutter (29722): 🎨 Using app primary color: 4280391411
I/flutter (29722): 🎯 Widget data prepared: 2 habits in list, JSON length: 359
I/flutter (29722): 🎯 First 200 chars of habits JSON: [{"id":"1759710702907","name":"fgjk","category":"Health","colorValue":4280391411,"isCompleted":true,"status":"Completed","timeDisplay":"17:32","frequency":"HabitFrequency.daily"},{"id":"1759711330090"
I/flutter (29722): 🎯 Theme data: light, primary: 4280391411
I/flutter (29722): Saved widget theme data: light, color: 4280391411
I/flutter (29722): Updating widget HabitTimelineWidgetProvider with data keys: [habits, nextHabit, selectedDate, themeMode, primaryColor, lastUpdate]
I/flutter (29722): ✅ Saved habits: length=359, preview=[{"id":"1759710702907","name":"fgjk","category":"Health","colorValue":4280391411,"isCompleted":true,"status":"Completed","timeDisplay":"17:32","freque...
I/flutter (29722): ✅ Saved nextHabit: null
I/flutter (29722): ✅ Saved selectedDate: 2025-10-05
I/flutter (29722): ✅ Saved themeMode: light
I/flutter (29722): ✅ Saved primaryColor: 4280391411
I/flutter (29722): ✅ Saved lastUpdate: 1759711385190
I/flutter (29722): Widget HabitTimelineWidgetProvider update completed
I/flutter (29722): Updating widget HabitCompactWidgetProvider with data keys: [habits, nextHabit, selectedDate, themeMode, primaryColor, lastUpdate]
I/flutter (29722): ✅ Saved habits: length=359, preview=[{"id":"1759710702907","name":"fgjk","category":"Health","colorValue":4280391411,"isCompleted":true,"status":"Completed","timeDisplay":"17:32","freque...
I/flutter (29722): ✅ Saved nextHabit: null
I/flutter (29722): ✅ Saved selectedDate: 2025-10-05
I/flutter (29722): ✅ Saved themeMode: light
I/flutter (29722): ✅ Saved primaryColor: 4280391411
I/flutter (29722): ✅ Saved lastUpdate: 1759711385190
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (29722): │ #1   NotificationActionHandler.completeHabitInBackground (package:habitv8/services/notifications/notification_action_handler.dart:255:17)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 🐛 ⏱️ Waited for database sync
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): 🔄 onHabitCompleted called - updating all widgets
I/flutter (29722): ⏱️ Widget update already pending, will schedule another
I/flutter (29722): Error triggering Android widget update: MissingPluginException(No implementation found for method triggerImmediateUpdate on channel com.habittracker.habitv8/widget_update)
I/flutter (29722): ✅ Widget update completed after habit completion
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (29722): │ #1   NotificationActionHandler.completeHabitInBackground (package:habitv8/services/notifications/notification_action_handler.dart:260:19)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 💡 ✅ Widget updated after background completion
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (29722): │ #1   onBackgroundNotificationResponse (package:habitv8/services/notifications/notification_action_handler.dart:72:15)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 💡 ✅ Background notification response processed
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): Widget HabitCompactWidgetProvider update completed
I/flutter (29722): ✅ All widgets updated successfully (debounced)
I/flutter (29722): Filtering 2 habits for date 2025-10-05:
I/flutter (29722):   - fgjk: HabitFrequency.daily -> INCLUDED
I/flutter (29722):   - ghjjkj: HabitFrequency.daily -> INCLUDED
I/flutter (29722): Result: 2 habits for today
I/flutter (29722): Widget data preparation: Found 2 total habits, 2 for today
I/flutter (29722): 🎨 Getting app theme: ThemeMode.system
I/flutter (29722): 🎨 App is in SYSTEM mode, device brightness: Brightness.light → light
I/flutter (29722): 🎨 Final theme mode to send to widgets: light
I/flutter (29722): 🎨 Using app primary color: 4280391411
I/flutter (29722): 🎯 Widget data prepared: 2 habits in list, JSON length: 359
I/flutter (29722): 🎯 First 200 chars of habits JSON: [{"id":"1759710702907","name":"fgjk","category":"Health","colorValue":4280391411,"isCompleted":true,"status":"Completed","timeDisplay":"17:32","frequency":"HabitFrequency.daily"},{"id":"1759711330090"
I/flutter (29722): 🎯 Theme data: light, primary: 4280391411
I/flutter (29722): Saved widget theme data: light, color: 4280391411
I/flutter (29722): Updating widget HabitTimelineWidgetProvider with data keys: [habits, nextHabit, selectedDate, themeMode, primaryColor, lastUpdate]
I/flutter (29722): ✅ Saved habits: length=359, preview=[{"id":"1759710702907","name":"fgjk","category":"Health","colorValue":4280391411,"isCompleted":true,"status":"Completed","timeDisplay":"17:32","freque...
I/flutter (29722): ✅ Saved nextHabit: null
I/flutter (29722): ✅ Saved selectedDate: 2025-10-05
I/flutter (29722): ✅ Saved themeMode: light
I/flutter (29722): ✅ Saved primaryColor: 4280391411
I/flutter (29722): ✅ Saved lastUpdate: 1759711385773
I/flutter (29722): Widget HabitTimelineWidgetProvider update completed
I/flutter (29722): Updating widget HabitCompactWidgetProvider with data keys: [habits, nextHabit, selectedDate, themeMode, primaryColor, lastUpdate]
I/flutter (29722): ✅ Saved habits: length=359, preview=[{"id":"1759710702907","name":"fgjk","category":"Health","colorValue":4280391411,"isCompleted":true,"status":"Completed","timeDisplay":"17:32","freque...
I/flutter (29722): ✅ Saved nextHabit: null
I/flutter (29722): ✅ Saved selectedDate: 2025-10-05
I/flutter (29722): ✅ Saved themeMode: light
I/flutter (29722): ✅ Saved primaryColor: 4280391411
I/flutter (29722): ✅ Saved lastUpdate: 1759711385773
I/flutter (29722): Widget HabitCompactWidgetProvider update completed
I/flutter (29722): ✅ All widgets updated successfully (debounced)
I/MainActivity(29722): onRestart: Preserving alarm sound if playing
D/MainActivity(29722): onNewIntent called with action: android.intent.action.MAIN
D/MainActivity(29722): onNewIntent called with action: android.intent.action.MAIN
I/MainActivity(29722): onResume: Preserving alarm sound state
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (29722): │ #1   AppLifecycleService.didChangeAppLifecycleState (package:habitv8/services/app_lifecycle_service.dart:69:15)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 💡 📱 App lifecycle state changed to: AppLifecycleState.hidden
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (29722): │ #1   AppLifecycleService.didChangeAppLifecycleState (package:habitv8/services/app_lifecycle_service.dart:91:19)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 💡 👁️ App hidden
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (29722): │ #1   AppLifecycleService.didChangeAppLifecycleState (package:habitv8/services/app_lifecycle_service.dart:69:15)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 💡 📱 App lifecycle state changed to: AppLifecycleState.inactive
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (29722): │ #1   AppLifecycleService.didChangeAppLifecycleState (package:habitv8/services/app_lifecycle_service.dart:88:19)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 💡 ⏹️ App inactive
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (29722): │ #1   habitsProvider.<anonymous closure> (package:habitv8/data/database.dart:428:13)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 💡 🔍 habitsProvider: Starting to fetch habits from database
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (29722): │ #1   habitsProvider.<anonymous closure> (package:habitv8/data/database.dart:431:13)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 💡 🔍 habitsProvider: Fetched 2 habits from database
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (29722): │ #1   habitsProvider.<anonymous closure> (package:habitv8/data/database.dart:437:17)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 🐛    fgjk: 1 completions
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
D/ImeBackDispatcher(29722): switch root view (mImeCallbacks.size=0)
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (29722): │ #1   AppLifecycleService.didChangeAppLifecycleState (package:habitv8/services/app_lifecycle_service.dart:69:15)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 💡 📱 App lifecycle state changed to: AppLifecycleState.resumed
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (29722): │ #1   AppLifecycleService.didChangeAppLifecycleState (package:habitv8/services/app_lifecycle_service.dart:84:19)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 💡 ▶️ App resumed
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (29722): │ #1   AppLifecycleService._handleAppResumed (package:habitv8/services/app_lifecycle_service.dart:131:17)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 💡 🔄 Handling app resume - re-registering notification callbacks...
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (29722): │ #1   AppLifecycleService._ensureDatabaseConnection (package:habitv8/services/app_lifecycle_service.dart:183:17)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 🐛 🔗 Ensuring database connection is valid...
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (29722): │ #1   AppLifecycleService._handleAppResumed (package:habitv8/services/app_lifecycle_service.dart:141:21)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 💡 🔄 About to invalidate habitsProvider on app resume
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (29722): │ #1   AppLifecycleService._handleAppResumed (package:habitv8/services/app_lifecycle_service.dart:143:21)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 💡 🔄 Invalidated habitsProvider to force refresh from database
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
D/InsetsController(29722): hide(ime())
I/ImeTracker(29722): com.habittracker.habitv8.debug:bb7db8fe: onCancelled at PHASE_CLIENT_ALREADY_HIDDEN
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (29722): │ #1   habitsProvider.<anonymous closure> (package:habitv8/data/database.dart:428:13)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 💡 🔍 habitsProvider: Starting to fetch habits from database
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (29722): │ #1   habitsProvider.<anonymous closure> (package:habitv8/data/database.dart:431:13)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 💡 🔍 habitsProvider: Fetched 2 habits from database
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (29722): │ #1   habitsProvider.<anonymous closure> (package:habitv8/data/database.dart:437:17)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 🐛    fgjk: 1 completions
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/ImeTracker(29722): system_server:581cc7cd: onCancelled at PHASE_CLIENT_ON_CONTROLS_CHANGED
D/ImeBackDispatcher(29722): Register received callback id=213350146 priority=0
D/WindowOnBackDispatcher(29722): setTopOnBackInvokedCallback (unwrapped): android.view.ImeBackAnimationController@e99717f
I/ImeTracker(29722): system_server:1091fdd3: onCancelled at PHASE_CLIENT_ON_CONTROLS_CHANGED
D/ImeBackDispatcher(29722): Unregister received callback id=213350146
D/WindowOnBackDispatcher(29722): setTopOnBackInvokedCallback (unwrapped): android.app.Activity$$ExternalSyntheticLambda0@be17532
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (29722): │ #1   AppLifecycleService._ensureDatabaseConnection.<anonymous closure> (package:habitv8/services/app_lifecycle_service.dart:194:23)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 🐛 ✅ Database connection is healthy
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (29722): │ #1   AppLifecycleService._handleAppResumed (package:habitv8/services/app_lifecycle_service.dart:148:21)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 💡 ⏱️ Delay after invalidation complete
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (29722): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:43:15)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 💡 🔍 Checking notification callback registration...
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (29722): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:44:15)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 💡 📦 Container available: true
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (29722): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:45:15)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 💡 🔗 Callback currently set: true
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (29722): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:56:17)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 💡 ✅ Notification action callback is properly registered
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (29722): │ #1   AppLifecycleService._processPendingActionsWithRetry (package:habitv8/services/app_lifecycle_service.dart:236:15)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 💡 🔄 Scheduling pending action processing attempt 1/5 with 1000ms delay
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (29722): │ #1   AppLifecycleService._refreshWidgetsOnResume (package:habitv8/services/app_lifecycle_service.dart:275:17)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 🐛 🔄 Force refreshing widgets on app resume...
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (29722): │ #1   AppLifecycleService._checkMissedResetOnResume (package:habitv8/services/app_lifecycle_service.dart:297:17)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 🐛 🔍 Checking for missed midnight resets on app resume...
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (29722): │ #1   AppLifecycleService._handleAppResumed (package:habitv8/services/app_lifecycle_service.dart:173:17)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 💡 ✅ App resume handling completed
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (29722): │ #1   NotificationActionHandler.processPendingActionsManually (package:habitv8/services/notifications/notification_action_handler.dart:924:15)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 💡 🔄 Manually processing pending actions
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (29722): │ #1   NotificationActionHandler.processPendingActionsManually (package:habitv8/services/notifications/notification_action_handler.dart:928:17)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 💡 ✅ Using callback to process pending actions
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (29722): │ #1   NotificationActionHandler.processPendingActions (package:habitv8/services/notifications/notification_action_handler.dart:336:15)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 💡 🔄 Processing pending notification actions
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (29722): │ #1   NotificationStorage.loadAllActions (package:habitv8/services/notifications/notification_storage.dart:254:17)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 🐛 🔍 All SharedPreferences keys: [onboarding_completed, trial_start_date, subscription_status, user_achievements, user_xp, last_midnight_reset, last_trial_check]
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (29722): │ #1   NotificationStorage.loadAllActions (package:habitv8/services/notifications/notification_storage.dart:260:17)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 🐛 🔍 Method 1 (getStringList): null
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (29722): │ #1   NotificationStorage.loadAllActions (package:habitv8/services/notifications/notification_storage.dart:261:17)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 🐛 🔍 Method 2 (get): null
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (29722): │ #1   NotificationStorage.loadAllActions (package:habitv8/services/notifications/notification_storage.dart:265:17)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 🐛 🔍 Found 0 pending actions in SharedPreferences
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (29722): │ #1   NotificationStorage.loadAllActions (package:habitv8/services/notifications/notification_storage.dart:272:19)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 🐛 No pending notification actions to process in SharedPreferences
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (29722): │ #1   NotificationStorage.loadActionsFromFile (package:habitv8/services/notifications/notification_storage.dart:339:17)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 🐛 🔍 File: Checking for actions at path: /data/user/0/com.habittracker.habitv8.debug/app_flutter/pending_notification_actions.json
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (29722): │ #1   habitsProvider.<anonymous closure> (package:habitv8/data/database.dart:428:13)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 💡 🔍 habitsProvider: Starting to fetch habits from database
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (29722): │ #1   habitsProvider.<anonymous closure> (package:habitv8/data/database.dart:431:13)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 💡 🔍 habitsProvider: Fetched 2 habits from database
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (29722): │ #1   habitsProvider.<anonymous closure> (package:habitv8/data/database.dart:437:17)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 🐛    fgjk: 1 completions
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (29722): │ #1   NotificationStorage.loadActionsFromFile (package:habitv8/services/notifications/notification_storage.dart:342:19)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 🐛 🔍 File: File does not exist
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (29722): │ #1   NotificationStorage.loadAllActions (package:habitv8/services/notifications/notification_storage.dart:297:19)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 🐛 No pending actions found in any storage method
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (29722): │ #1   NotificationActionHandler.processPendingActions (package:habitv8/services/notifications/notification_action_handler.dart:341:15)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 💡 Found 0 actions in storage
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (29722): │ #1   NotificationActionHandler.processPendingActions (package:habitv8/services/notifications/notification_action_handler.dart:345:17)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 💡 ⏭️  No new actions - initial pending actions already processed
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (29722): │ #1   AppLifecycleService._processPendingActionsWithRetry.<anonymous closure> (package:habitv8/services/app_lifecycle_service.dart:242:19)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 💡 ✅ Pending actions processed successfully on attempt 1
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): 🧪 FORCE UPDATE: Starting immediate widget update...
I/flutter (29722): 🧪 FORCE UPDATE: Called from notification completion handler
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (29722): │ #1   AppLifecycleService._processPendingCompletions.<anonymous closure> (package:habitv8/services/app_lifecycle_service.dart:265:19)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 💡 ✅ Pending completions processed successfully
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): 🧪 FORCE UPDATE: updateAllWidgets() completed
I/flutter (29722): Filtering 2 habits for date 2025-10-05:
I/flutter (29722):   - fgjk: HabitFrequency.daily -> INCLUDED
I/flutter (29722):   - ghjjkj: HabitFrequency.daily -> INCLUDED
I/flutter (29722): Result: 2 habits for today
I/flutter (29722): Widget data preparation: Found 2 total habits, 2 for today
I/flutter (29722): 🎨 Getting app theme: ThemeMode.system
I/flutter (29722): 🎨 App is in SYSTEM mode, device brightness: Brightness.dark → dark
I/flutter (29722): 🎨 Final theme mode to send to widgets: dark
I/flutter (29722): 🎨 Using app primary color: 4280391411
I/flutter (29722): 🎯 Widget data prepared: 2 habits in list, JSON length: 354
I/flutter (29722): 🎯 First 200 chars of habits JSON: [{"id":"1759710702907","name":"fgjk","category":"Health","colorValue":4280391411,"isCompleted":true,"status":"Completed","timeDisplay":"17:32","frequency":"HabitFrequency.daily"},{"id":"1759711330090"
I/flutter (29722): 🎯 Theme data: dark, primary: 4280391411
I/flutter (29722): Saved widget theme data: dark, color: 4280391411
I/flutter (29722): Updating widget HabitTimelineWidgetProvider with data keys: [habits, nextHabit, selectedDate, themeMode, primaryColor, lastUpdate]
I/flutter (29722): ✅ Saved habits: length=354, preview=[{"id":"1759710702907","name":"fgjk","category":"Health","colorValue":4280391411,"isCompleted":true,"status":"Completed","timeDisplay":"17:32","freque...
I/flutter (29722): ✅ Saved nextHabit: null
I/flutter (29722): ✅ Saved selectedDate: 2025-10-05
I/flutter (29722): ✅ Saved themeMode: dark
I/flutter (29722): ✅ Saved primaryColor: 4280391411
I/flutter (29722): ✅ Saved lastUpdate: 1759711392090
I/flutter (29722): 🧪 FORCE UPDATE: Waited 300ms for data propagation
I/MainActivity(29722): Widget force refresh triggered for both compact and timeline widgets
I/flutter (29722): 🧪 FORCE UPDATE: Successfully triggered widget refresh via method channel
I/flutter (29722): 🧪 FORCE UPDATE: Completed successfully
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (29722): │ #1   AppLifecycleService._refreshWidgetsOnResume.<anonymous closure> (package:habitv8/services/app_lifecycle_service.dart:282:21)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 🐛 ✅ Widgets force refreshed successfully on app resume
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
W/JobInfo (29722): Requested important-while-foreground flag for job27 is ignored and takes no effect
D/WM-SystemJobScheduler(29722): Scheduling work ID 695b04ff-1ef5-467a-ba57-66e828a4fdebJob ID 27
I/flutter (29722): Widget HabitTimelineWidgetProvider update completed
I/flutter (29722): Updating widget HabitCompactWidgetProvider with data keys: [habits, nextHabit, selectedDate, themeMode, primaryColor, lastUpdate]
D/WM-GreedyScheduler(29722): Starting work for 695b04ff-1ef5-467a-ba57-66e828a4fdeb
I/flutter (29722): ✅ Saved habits: length=354, preview=[{"id":"1759710702907","name":"fgjk","category":"Health","colorValue":4280391411,"isCompleted":true,"status":"Completed","timeDisplay":"17:32","freque...
D/WM-Processor(29722): Processor: processing WorkGenerationalId(workSpecId=695b04ff-1ef5-467a-ba57-66e828a4fdeb, generation=0)
D/WM-SystemJobService(29722): onStartJob for WorkGenerationalId(workSpecId=695b04ff-1ef5-467a-ba57-66e828a4fdeb, generation=0)
I/flutter (29722): ✅ Saved nextHabit: null
I/flutter (29722): ✅ Saved selectedDate: 2025-10-05
I/flutter (29722): ✅ Saved themeMode: dark
I/flutter (29722): ✅ Saved primaryColor: 4280391411
D/WM-WorkerWrapper(29722): Starting work for com.habittracker.habitv8.WidgetUpdateWorker
I/WidgetUpdateWorker(29722): Starting widget update work
D/WidgetUpdateWorker(29722): Widget data loaded: 354 characters
D/WidgetUpdateWorker(29722): Updating habits data: 354 characters
I/flutter (29722): ✅ Saved lastUpdate: 1759711392090
D/WM-Processor(29722): Work WorkGenerationalId(workSpecId=695b04ff-1ef5-467a-ba57-66e828a4fdeb, generation=0) is already enqueued for processing
D/WidgetUpdateWorker(29722): Processed 2 total habits, 2 for today
D/WidgetUpdateWorker(29722): Theme settings copied: mode=null, color=ffffffff
D/WidgetUpdateWorker(29722): Widget data updated from Flutter preferences
D/WidgetUpdateWorker(29722): Updated 1 timeline widgets
D/HabitTimelineWidget(29722): onUpdate called with 1 widget IDs
D/HabitTimelineWidget(29722): ListView setup completed for widget 34 (service will read fresh theme data)
D/HabitTimelineWidget(29722): Detected theme mode: 'dark'
D/HabitTimelineWidget(29722): Using theme - mode: 'dark', primary: ff2196f3
D/HabitTimelineWidget(29722): Semi-transparent theme applied - isDark: true, bg: 800f0f0f
D/HabitTimelineWidget(29722): Found habits in widgetData
D/HabitTimelineWidget(29722): Widget update completed for ID: 34
I/WidgetUpdateWorker(29722): ✅ Widget update work completed successfully
D/HabitTimelineService(29722): onDataSetChanged called - FORCING reload (invalidating cache)
D/HabitTimelineService(29722): 🎨 Loading fresh theme data from preferences:
D/HabitTimelineService(29722):   - HomeWidget['themeMode']: dark
D/HabitTimelineService(29722):   - Flutter['flutter.theme_mode']: null
D/HabitTimelineService(29722): 🎨 Final detected theme mode: 'dark'
D/HabitTimelineService(29722): Theme applied - isDark: true, textColor: ffffffff, primary: ff2196f3
D/HabitTimelineService(29722): ✅ Found habits data at key 'habits', length: 354, preview: [{"id":"1759710702907","name":"fgjk","category":"Health","colorValue":4280391411,"isCompleted":true,
D/HabitTimelineService(29722): Attempting to load habits from key: habits, Raw length: 354
D/HabitTimelineService(29722): Loaded 2 habits for timeline widget
D/HabitTimelineService(29722): First habit keys: [id, name, category, colorValue, isCompleted, status, timeDisplay, frequency]
D/HabitTimelineService(29722): getCount returning: 2 habits
D/HabitTimelineService(29722): getViewAt position: 0
D/HabitTimelineService(29722): Created view for habit: fgjk at position 0
D/HabitTimelineService(29722): getViewAt position: 1
D/HabitTimelineService(29722): Created view for habit: ghjjkj at position 1
I/WM-WorkerWrapper(29722): Worker result SUCCESS for Work [ id=695b04ff-1ef5-467a-ba57-66e828a4fdeb, tags={ com.habittracker.habitv8.WidgetUpdateWorker } ]
D/HabitTimelineService(29722): getCount returning: 2 habits
D/HabitTimelineService(29722): getViewAt position: 0
D/HabitTimelineService(29722): Created view for habit: fgjk at position 0
D/HabitTimelineService(29722): getViewAt position: 1
D/HabitTimelineService(29722): Created view for habit: ghjjkj at position 1
D/WM-Processor(29722): Processor 695b04ff-1ef5-467a-ba57-66e828a4fdeb executed; reschedule = false
D/WM-SystemJobService(29722): 695b04ff-1ef5-467a-ba57-66e828a4fdeb executed on JobScheduler
D/HabitTimelineService(29722): onDataSetChanged called - FORCING reload (invalidating cache)
D/HabitTimelineService(29722): 🎨 Loading fresh theme data from preferences:
D/HabitTimelineService(29722):   - HomeWidget['themeMode']: dark
D/HabitTimelineService(29722):   - Flutter['flutter.theme_mode']: null
D/HabitTimelineService(29722): 🎨 Final detected theme mode: 'dark'
D/WM-GreedyScheduler(29722): Cancelling work ID 695b04ff-1ef5-467a-ba57-66e828a4fdeb
D/HabitTimelineService(29722): Theme applied - isDark: true, textColor: ffffffff, primary: ff2196f3
D/HabitTimelineService(29722): ✅ Found habits data at key 'habits', length: 354, preview: [{"id":"1759710702907","name":"fgjk","category":"Health","colorValue":4280391411,"isCompleted":true,
D/HabitTimelineService(29722): Attempting to load habits from key: habits, Raw length: 354
D/HabitTimelineService(29722): Loaded 2 habits for timeline widget
D/HabitTimelineService(29722): First habit keys: [id, name, category, colorValue, isCompleted, status, timeDisplay, frequency]
D/HabitTimelineService(29722): getCount returning: 2 habits
D/HabitTimelineService(29722): getViewAt position: 0
D/HabitTimelineService(29722): Created view for habit: fgjk at position 0
D/HabitTimelineService(29722): getViewAt position: 1
D/HabitTimelineService(29722): Created view for habit: ghjjkj at position 1
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (29722): │ #1   MidnightHabitResetService.checkForMissedResetOnAppActive (package:habitv8/services/midnight_habit_reset_service.dart:270:17)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 🐛 🔍 Checking for missed resets on app activation
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (29722): │ #1   MidnightHabitResetService._checkMissedReset (package:habitv8/services/midnight_habit_reset_service.dart:84:21)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 🐛 ✅ No missed reset - last reset was today
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (29722): │ #1   AppLifecycleService._checkMissedResetOnResume.<anonymous closure> (package:habitv8/services/app_lifecycle_service.dart:304:21)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 🐛 ✅ Missed reset check completed on app resume
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): Widget HabitCompactWidgetProvider update completed
I/flutter (29722): ✅ All widgets updated successfully (debounced)
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (29722): │ #1   habitsProvider.<anonymous closure> (package:habitv8/data/database.dart:428:13)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 💡 🔍 habitsProvider: Starting to fetch habits from database
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (29722): │ #1   habitsProvider.<anonymous closure> (package:habitv8/data/database.dart:431:13)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 💡 🔍 habitsProvider: Fetched 2 habits from database
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (29722): │ #1   habitsProvider.<anonymous closure> (package:habitv8/data/database.dart:437:17)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 🐛    fgjk: 1 completions
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (29722): │ #1   habitsProvider.<anonymous closure> (package:habitv8/data/database.dart:428:13)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 💡 🔍 habitsProvider: Starting to fetch habits from database
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (29722): │ #1   habitsProvider.<anonymous closure> (package:habitv8/data/database.dart:431:13)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 💡 🔍 habitsProvider: Fetched 2 habits from database
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (29722): │ #1   habitsProvider.<anonymous closure> (package:habitv8/data/database.dart:437:17)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 🐛    fgjk: 1 completions
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (29722): │ #1   habitsProvider.<anonymous closure> (package:habitv8/data/database.dart:428:13)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 💡 🔍 habitsProvider: Starting to fetch habits from database
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (29722): │ #1   habitsProvider.<anonymous closure> (package:habitv8/data/database.dart:431:13)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 💡 🔍 habitsProvider: Fetched 2 habits from database
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (29722): │ #1   habitsProvider.<anonymous closure> (package:habitv8/data/database.dart:437:17)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 🐛    fgjk: 1 completions
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (29722): │ #1   habitsProvider.<anonymous closure> (package:habitv8/data/database.dart:428:13)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 💡 🔍 habitsProvider: Starting to fetch habits from database
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (29722): │ #1   habitsProvider.<anonymous closure> (package:habitv8/data/database.dart:431:13)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 💡 🔍 habitsProvider: Fetched 2 habits from database
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (29722): │ #1   habitsProvider.<anonymous closure> (package:habitv8/data/database.dart:437:17)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 🐛    fgjk: 1 completions
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (29722): │ #1   habitsProvider.<anonymous closure> (package:habitv8/data/database.dart:428:13)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 💡 🔍 habitsProvider: Starting to fetch habits from database
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (29722): │ #1   habitsProvider.<anonymous closure> (package:habitv8/data/database.dart:431:13)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 💡 🔍 habitsProvider: Fetched 2 habits from database
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (29722): │ #1   habitsProvider.<anonymous closure> (package:habitv8/data/database.dart:437:17)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 🐛    fgjk: 1 completions
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (29722): │ #1   habitsProvider.<anonymous closure> (package:habitv8/data/database.dart:428:13)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 💡 🔍 habitsProvider: Starting to fetch habits from database
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (29722): │ #1   habitsProvider.<anonymous closure> (package:habitv8/data/database.dart:431:13)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 💡 🔍 habitsProvider: Fetched 2 habits from database
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (29722): │ #1   habitsProvider.<anonymous closure> (package:habitv8/data/database.dart:437:17)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 🐛    fgjk: 1 completions
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (29722): │ #1   habitsProvider.<anonymous closure> (package:habitv8/data/database.dart:428:13)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 💡 🔍 habitsProvider: Starting to fetch habits from database
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (29722): │ #1   habitsProvider.<anonymous closure> (package:habitv8/data/database.dart:431:13)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 💡 🔍 habitsProvider: Fetched 2 habits from database
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (29722): │ #1   habitsProvider.<anonymous closure> (package:habitv8/data/database.dart:437:17)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 🐛    fgjk: 1 completions
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (29722): │ #1   habitsProvider.<anonymous closure> (package:habitv8/data/database.dart:428:13)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 💡 🔍 habitsProvider: Starting to fetch habits from database
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (29722): │ #1   habitsProvider.<anonymous closure> (package:habitv8/data/database.dart:431:13)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 💡 🔍 habitsProvider: Fetched 2 habits from database
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (29722): │ #1   habitsProvider.<anonymous closure> (package:habitv8/data/database.dart:437:17)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 🐛    fgjk: 1 completions
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (29722): │ #1   habitsProvider.<anonymous closure> (package:habitv8/data/database.dart:428:13)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 💡 🔍 habitsProvider: Starting to fetch habits from database
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (29722): │ #1   habitsProvider.<anonymous closure> (package:habitv8/data/database.dart:431:13)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 💡 🔍 habitsProvider: Fetched 2 habits from database
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (29722): │ #1   habitsProvider.<anonymous closure> (package:habitv8/data/database.dart:437:17)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 🐛    fgjk: 1 completions
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (29722): │ #1   habitsProvider.<anonymous closure> (package:habitv8/data/database.dart:428:13)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 💡 🔍 habitsProvider: Starting to fetch habits from database
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (29722): │ #1   habitsProvider.<anonymous closure> (package:habitv8/data/database.dart:431:13)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 💡 🔍 habitsProvider: Fetched 2 habits from database
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (29722): │ #1   habitsProvider.<anonymous closure> (package:habitv8/data/database.dart:437:17)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 🐛    fgjk: 1 completions
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (29722): │ #1   habitsProvider.<anonymous closure> (package:habitv8/data/database.dart:428:13)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 💡 🔍 habitsProvider: Starting to fetch habits from database
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (29722): │ #1   habitsProvider.<anonymous closure> (package:habitv8/data/database.dart:431:13)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 💡 🔍 habitsProvider: Fetched 2 habits from database
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (29722): │ #1   habitsProvider.<anonymous closure> (package:habitv8/data/database.dart:437:17)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 🐛    fgjk: 1 completions
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (29722): │ #1   habitsProvider.<anonymous closure> (package:habitv8/data/database.dart:428:13)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 💡 🔍 habitsProvider: Starting to fetch habits from database
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (29722): │ #1   habitsProvider.<anonymous closure> (package:habitv8/data/database.dart:431:13)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 💡 🔍 habitsProvider: Fetched 2 habits from database
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (29722): │ #1   habitsProvider.<anonymous closure> (package:habitv8/data/database.dart:437:17)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 🐛    fgjk: 1 completions
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (29722): │ #1   habitsProvider.<anonymous closure> (package:habitv8/data/database.dart:428:13)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 💡 🔍 habitsProvider: Starting to fetch habits from database
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (29722): │ #1   habitsProvider.<anonymous closure> (package:habitv8/data/database.dart:431:13)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 💡 🔍 habitsProvider: Fetched 2 habits from database
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (29722): │ #1   habitsProvider.<anonymous closure> (package:habitv8/data/database.dart:437:17)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 🐛    fgjk: 1 completions
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (29722): │ #1   habitsProvider.<anonymous closure> (package:habitv8/data/database.dart:428:13)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 💡 🔍 habitsProvider: Starting to fetch habits from database
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (29722): │ #1   habitsProvider.<anonymous closure> (package:habitv8/data/database.dart:431:13)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 💡 🔍 habitsProvider: Fetched 2 habits from database
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (29722): │ #1   habitsProvider.<anonymous closure> (package:habitv8/data/database.dart:437:17)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 🐛    fgjk: 1 completions
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
D/ImeBackDispatcher(29722): Clear (mImeCallbacks.size=0)
I/MainActivity(29722): onPause: Preserving alarm sound if playing
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (29722): │ #1   AppLifecycleService.didChangeAppLifecycleState (package:habitv8/services/app_lifecycle_service.dart:69:15)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 💡 📱 App lifecycle state changed to: AppLifecycleState.inactive
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (29722): │ #1   AppLifecycleService.didChangeAppLifecycleState (package:habitv8/services/app_lifecycle_service.dart:88:19)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 💡 ⏹️ App inactive
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (29722): │ #1   AppLifecycleService.didChangeAppLifecycleState (package:habitv8/services/app_lifecycle_service.dart:69:15)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 💡 📱 App lifecycle state changed to: AppLifecycleState.hidden
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (29722): │ #1   AppLifecycleService.didChangeAppLifecycleState (package:habitv8/services/app_lifecycle_service.dart:91:19)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 💡 👁️ App hidden
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (29722): │ #1   AppLifecycleService.didChangeAppLifecycleState (package:habitv8/services/app_lifecycle_service.dart:69:15)
I/flutter (29722): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (29722): │ 💡 📱 App lifecycle state changed to: AppLifecycleState.paused
I/flutter (29722): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (29722): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────