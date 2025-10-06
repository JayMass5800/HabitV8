D/WM-Processor(25041): Work WorkGenerationalId(workSpecId=e482c73b-8278-4f78-89d5-681fa11935d3, generation=0) is already enqueued for processing
D/WM-WorkerWrapper(25041): Starting work for com.habittracker.habitv8.BootCompletionWorker
D/WM-WorkerWrapper(25041): Starting work for com.habittracker.habitv8.WidgetUpdateWorker
I/BootCompletionWorker(25041): Starting boot completion work
I/WidgetUpdateWorker(25041): Starting widget update work
D/WidgetUpdateWorker(25041): Widget data loaded: 354 characters
D/WidgetUpdateWorker(25041): Updating habits data: 354 characters
I/BootCompletionWorker(25041): ✅ Boot completion flag set for Flutter app
D/WidgetUpdateWorker(25041): Processed 2 total habits, 2 for today
D/WidgetUpdateWorker(25041): Theme settings copied: mode=null, color=ffffffff
D/WidgetUpdateWorker(25041): Widget data updated from Flutter preferences
I/WidgetUpdateWorker(25041): ✅ Periodic widget updates scheduled (every 15 minutes)
I/WidgetUpdateWorker(25041): ✅ Fallback widget updates scheduled (every hour)
D/WidgetUpdateWorker(25041): Updated 1 timeline widgets
D/HabitTimelineWidget(25041): onUpdate called with 1 widget IDs
D/HabitTimelineWidget(25041): ListView setup completed for widget 33 (service will read fresh theme data)
D/HabitTimelineWidget(25041): Detected theme mode: 'dark'
D/HabitTimelineWidget(25041): Using theme - mode: 'dark', primary: ff2196f3
D/HabitTimelineWidget(25041): Semi-transparent theme applied - isDark: true, bg: 800f0f0f
D/HabitTimelineService(25041): onDataSetChanged called - FORCING reload (invalidating cache)
D/HabitTimelineService(25041): 🎨 Loading fresh theme data from preferences:
D/HabitTimelineService(25041):   - HomeWidget['themeMode']: dark
D/HabitTimelineService(25041):   - Flutter['flutter.theme_mode']: null
D/HabitTimelineService(25041): 🎨 Final detected theme mode: 'dark'
D/HabitTimelineService(25041): Theme applied - isDark: true, textColor: ffffffff, primary: ff2196f3
D/HabitTimelineService(25041): ✅ Found habits data at key 'habits', length: 354, preview: [{"id":"1759709001188","name":"test","category":"Health","colorValue":4280391411,"isCompleted":true,
D/HabitTimelineService(25041): Attempting to load habits from key: habits, Raw length: 354
D/HabitTimelineWidget(25041): Found habits in widgetData
D/HabitTimelineService(25041): Loaded 2 habits for timeline widget
D/HabitTimelineService(25041): First habit keys: [id, name, category, colorValue, isCompleted, status, timeDisplay, frequency]
D/HabitTimelineService(25041): getCount returning: 2 habits
D/HabitTimelineService(25041): getViewAt position: 0
D/HabitTimelineService(25041): Created view for habit: test at position 0
D/HabitTimelineService(25041): getViewAt position: 1
D/HabitTimelineService(25041): Created view for habit: yrst at position 1
D/WM-GreedyScheduler(25041): Cancelling work ID 707a631a-3f0a-412e-b416-bdbc606f29fc
D/HabitTimelineWidget(25041): Widget update completed for ID: 33
I/WidgetUpdateWorker(25041): ✅ Widget update work completed successfully
D/WM-SystemJobScheduler(25041): Scheduling work ID 707a631a-3f0a-412e-b416-bdbc606f29fcJob ID 23
D/WM-SystemJobService(25041): onStartJob for WorkGenerationalId(workSpecId=2df0d2a4-75f7-4e00-9edc-e7cdeb828225, generation=0)
I/MainActivity(25041): onPause: Preserving alarm sound if playing
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (25041): │ #1   AppLifecycleService.didChangeAppLifecycleState (package:habitv8/services/app_lifecycle_service.dart:69:15)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 💡 📱 App lifecycle state changed to: AppLifecycleState.inactive
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
D/HabitTimelineService(25041): getCount returning: 2 habits
D/HabitTimelineService(25041): getViewAt position: 0
D/HabitTimelineService(25041): Created view for habit: test at position 0
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (25041): │ #1   AppLifecycleService.didChangeAppLifecycleState (package:habitv8/services/app_lifecycle_service.dart:88:19)
D/HabitTimelineService(25041): getViewAt position: 1
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 💡 ⏹️ App inactive
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
D/MainActivity(25041): onNewIntent called with action: android.intent.action.MAIN
I/MainActivity(25041): onResume: Preserving alarm sound state
I/BootCompletionWorker(25041): ✅ Flutter app started for notification rescheduling
D/HabitTimelineService(25041): Created view for habit: yrst at position 1
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
D/WM-GreedyScheduler(25041): Cancelling work ID 080f6f34-62b4-4232-8fec-cde934e160eb
I/flutter (25041): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (25041): │ #1   AppLifecycleService.didChangeAppLifecycleState (package:habitv8/services/app_lifecycle_service.dart:69:15)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 💡 📱 App lifecycle state changed to: AppLifecycleState.resumed
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (25041): │ #1   AppLifecycleService.didChangeAppLifecycleState (package:habitv8/services/app_lifecycle_service.dart:84:19)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 💡 ▶️ App resumed
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
D/WM-SystemJobScheduler(25041): Scheduling work ID 080f6f34-62b4-4232-8fec-cde934e160ebJob ID 24
I/flutter (25041): │ #1   AppLifecycleService._handleAppResumed (package:habitv8/services/app_lifecycle_service.dart:131:17)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 💡 🔄 Handling app resume - re-registering notification callbacks...
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (25041): │ #1   AppLifecycleService._ensureDatabaseConnection (package:habitv8/services/app_lifecycle_service.dart:183:17)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 🐛 🔗 Ensuring database connection is valid...
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (25041): │ #1   AppLifecycleService._handleAppResumed (package:habitv8/services/app_lifecycle_service.dart:141:21)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 💡 🔄 About to invalidate habitsProvider on app resume
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (25041): │ #1   AppLifecycleService._handleAppResumed (package:habitv8/services/app_lifecycle_service.dart:143:21)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 💡 🔄 Invalidated habitsProvider to force refresh from database
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
D/HabitTimelineService(25041): onDataSetChanged called - FORCING reload (invalidating cache)
D/HabitTimelineService(25041): 🎨 Loading fresh theme data from preferences:
D/HabitTimelineService(25041):   - HomeWidget['themeMode']: dark
D/HabitTimelineService(25041):   - Flutter['flutter.theme_mode']: null
D/HabitTimelineService(25041): 🎨 Final detected theme mode: 'dark'
D/HabitTimelineService(25041): Theme applied - isDark: true, textColor: ffffffff, primary: ff2196f3
D/HabitTimelineService(25041): ✅ Found habits data at key 'habits', length: 354, preview: [{"id":"1759709001188","name":"test","category":"Health","colorValue":4280391411,"isCompleted":true,
D/HabitTimelineService(25041): Attempting to load habits from key: habits, Raw length: 354
D/HabitTimelineService(25041): Loaded 2 habits for timeline widget
D/HabitTimelineService(25041): First habit keys: [id, name, category, colorValue, isCompleted, status, timeDisplay, frequency]
D/HabitTimelineService(25041): getCount returning: 2 habits
D/HabitTimelineService(25041): getViewAt position: 0
D/HabitTimelineService(25041): Created view for habit: test at position 0
I/WM-WorkerWrapper(25041): Worker result SUCCESS for Work [ id=e482c73b-8278-4f78-89d5-681fa11935d3, tags={ com.habittracker.habitv8.WidgetUpdateWorker } ]
D/HabitTimelineService(25041): getViewAt position: 1
D/HabitTimelineService(25041): Created view for habit: yrst at position 1
D/WM-Processor(25041): Work WorkGenerationalId(workSpecId=2df0d2a4-75f7-4e00-9edc-e7cdeb828225, generation=0) is already enqueued for processing
I/WM-WorkerWrapper(25041): Worker result SUCCESS for Work [ id=2df0d2a4-75f7-4e00-9edc-e7cdeb828225, tags={ com.habittracker.habitv8.BootCompletionWorker,boot_completion } ]
D/WM-Processor(25041): Processor e482c73b-8278-4f78-89d5-681fa11935d3 executed; reschedule = false
D/WM-SystemJobService(25041): e482c73b-8278-4f78-89d5-681fa11935d3 executed on JobScheduler
D/WM-Processor(25041): Processor 2df0d2a4-75f7-4e00-9edc-e7cdeb828225 executed; reschedule = false
D/WM-SystemJobService(25041): 2df0d2a4-75f7-4e00-9edc-e7cdeb828225 executed on JobScheduler
D/WM-GreedyScheduler(25041): Cancelling work ID e482c73b-8278-4f78-89d5-681fa11935d3
D/WM-GreedyScheduler(25041): Cancelling work ID 2df0d2a4-75f7-4e00-9edc-e7cdeb828225
I/flutter (25041): Widget HabitTimelineWidgetProvider update completed
I/flutter (25041): Updating widget HabitCompactWidgetProvider with data keys: [habits, nextHabit, selectedDate, themeMode, primaryColor, lastUpdate]
I/flutter (25041): ✅ Saved habits: length=354, preview=[{"id":"1759709001188","name":"test","category":"Health","colorValue":4280391411,"isCompleted":true,"status":"Completed","timeDisplay":"17:04","freque...
I/flutter (25041): ✅ Saved nextHabit: {"id":"1759709114965","name":"yrst","category":"Personal","colorValue":4280391411,"isCompleted":fals...
I/flutter (25041): ✅ Saved selectedDate: 2025-10-05
I/flutter (25041): ✅ Saved themeMode: dark
I/flutter (25041): ✅ Saved primaryColor: 4280391411
I/flutter (25041): ✅ Saved lastUpdate: 1759709117906
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (25041): │ #1   AppLifecycleService._handleAppResumed (package:habitv8/services/app_lifecycle_service.dart:148:21)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 💡 ⏱️ Delay after invalidation complete
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (25041): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:43:15)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 💡 🔍 Checking notification callback registration...
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (25041): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:44:15)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 💡 📦 Container available: true
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (25041): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:45:15)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 💡 🔗 Callback currently set: true
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (25041): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:56:17)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 💡 ✅ Notification action callback is properly registered
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (25041): │ #1   AppLifecycleService._processPendingActionsWithRetry (package:habitv8/services/app_lifecycle_service.dart:236:15)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 💡 🔄 Scheduling pending action processing attempt 1/5 with 1000ms delay
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (25041): │ #1   AppLifecycleService._refreshWidgetsOnResume (package:habitv8/services/app_lifecycle_service.dart:275:17)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 🐛 🔄 Force refreshing widgets on app resume...
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (25041): │ #1   AppLifecycleService._checkMissedResetOnResume (package:habitv8/services/app_lifecycle_service.dart:297:17)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 🐛 🔍 Checking for missed midnight resets on app resume...
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (25041): │ #1   AppLifecycleService._handleAppResumed (package:habitv8/services/app_lifecycle_service.dart:173:17)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 💡 ✅ App resume handling completed
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (25041): │ #1   AppLifecycleService._ensureDatabaseConnection.<anonymous closure> (package:habitv8/services/app_lifecycle_service.dart:194:23)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 🐛 ✅ Database connection is healthy
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (25041): │ #1   habitsProvider.<anonymous closure> (package:habitv8/data/database.dart:428:13)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 💡 🔍 habitsProvider: Starting to fetch habits from database
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (25041): │ #1   habitsProvider.<anonymous closure> (package:habitv8/data/database.dart:431:13)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 💡 🔍 habitsProvider: Fetched 2 habits from database
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (25041): │ #1   habitsProvider.<anonymous closure> (package:habitv8/data/database.dart:437:17)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 🐛    test: 1 completions
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): Widget HabitCompactWidgetProvider update completed
I/flutter (25041): ✅ All widgets updated successfully (debounced)
D/WindowOnBackDispatcher(25041): setTopOnBackInvokedCallback (unwrapped): androidx.activity.OnBackPressedDispatcher$Api34Impl$createOnBackAnimationCallback$1@6f75580
D/WindowOnBackDispatcher(25041): setTopOnBackInvokedCallback (unwrapped): android.app.Activity$$ExternalSyntheticLambda0@8e6bc39
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (25041): │ #1   NotificationActionHandler.processPendingActionsManually (package:habitv8/services/notifications/notification_action_handler.dart:924:15)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 💡 🔄 Manually processing pending actions
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (25041): │ #1   NotificationActionHandler.processPendingActionsManually (package:habitv8/services/notifications/notification_action_handler.dart:928:17)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 💡 ✅ Using callback to process pending actions
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (25041): │ #1   NotificationActionHandler.processPendingActions (package:habitv8/services/notifications/notification_action_handler.dart:336:15)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 💡 🔄 Processing pending notification actions
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (25041): │ #1   NotificationStorage.loadAllActions (package:habitv8/services/notifications/notification_storage.dart:254:17)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 🐛 🔍 All SharedPreferences keys: [onboarding_completed, trial_start_date, subscription_status, user_achievements, user_xp, last_midnight_reset, last_trial_check]
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (25041): │ #1   NotificationStorage.loadAllActions (package:habitv8/services/notifications/notification_storage.dart:260:17)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 🐛 🔍 Method 1 (getStringList): null
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (25041): │ #1   NotificationStorage.loadAllActions (package:habitv8/services/notifications/notification_storage.dart:261:17)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 🐛 🔍 Method 2 (get): null
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (25041): │ #1   NotificationStorage.loadAllActions (package:habitv8/services/notifications/notification_storage.dart:265:17)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 🐛 🔍 Found 0 pending actions in SharedPreferences
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (25041): │ #1   NotificationStorage.loadAllActions (package:habitv8/services/notifications/notification_storage.dart:272:19)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 🐛 No pending notification actions to process in SharedPreferences
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (25041): │ #1   NotificationStorage.loadActionsFromFile (package:habitv8/services/notifications/notification_storage.dart:339:17)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 🐛 🔍 File: Checking for actions at path: /data/user/0/com.habittracker.habitv8.debug/app_flutter/pending_notification_actions.json
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (25041): │ #1   NotificationStorage.loadActionsFromFile (package:habitv8/services/notifications/notification_storage.dart:342:19)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 🐛 🔍 File: File does not exist
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (25041): │ #1   NotificationStorage.loadAllActions (package:habitv8/services/notifications/notification_storage.dart:297:19)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 🐛 No pending actions found in any storage method
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (25041): │ #1   NotificationActionHandler.processPendingActions (package:habitv8/services/notifications/notification_action_handler.dart:341:15)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 💡 Found 0 actions in storage
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (25041): │ #1   NotificationActionHandler.processPendingActions (package:habitv8/services/notifications/notification_action_handler.dart:345:17)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 💡 ⏭️  No new actions - initial pending actions already processed
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (25041): │ #1   AppLifecycleService._processPendingActionsWithRetry.<anonymous closure> (package:habitv8/services/app_lifecycle_service.dart:242:19)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 💡 ✅ Pending actions processed successfully on attempt 1
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): 🧪 FORCE UPDATE: Starting immediate widget update...
I/flutter (25041): 🧪 FORCE UPDATE: Called from notification completion handler
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (25041): │ #1   AppLifecycleService._processPendingCompletions.<anonymous closure> (package:habitv8/services/app_lifecycle_service.dart:265:19)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 💡 ✅ Pending completions processed successfully
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): 🧪 FORCE UPDATE: updateAllWidgets() completed
I/flutter (25041): Filtering 2 habits for date 2025-10-05:
I/flutter (25041):   - test: HabitFrequency.daily -> INCLUDED
I/flutter (25041):   - yrst: HabitFrequency.daily -> INCLUDED
I/flutter (25041): Result: 2 habits for today
I/flutter (25041): Widget data preparation: Found 2 total habits, 2 for today
I/flutter (25041): 🎨 Getting app theme: ThemeMode.system
I/flutter (25041): 🎨 App is in SYSTEM mode, device brightness: Brightness.dark → dark
I/flutter (25041): 🎨 Final theme mode to send to widgets: dark
I/flutter (25041): 🎨 Using app primary color: 4280391411
I/flutter (25041): 🎯 Widget data prepared: 2 habits in list, JSON length: 354
I/flutter (25041): 🎯 First 200 chars of habits JSON: [{"id":"1759709001188","name":"test","category":"Health","colorValue":4280391411,"isCompleted":true,"status":"Completed","timeDisplay":"17:04","frequency":"HabitFrequency.daily"},{"id":"1759709114965"
I/flutter (25041): 🎯 Theme data: dark, primary: 4280391411
I/flutter (25041): Saved widget theme data: dark, color: 4280391411
I/flutter (25041): Updating widget HabitTimelineWidgetProvider with data keys: [habits, nextHabit, selectedDate, themeMode, primaryColor, lastUpdate]
I/flutter (25041): ✅ Saved habits: length=354, preview=[{"id":"1759709001188","name":"test","category":"Health","colorValue":4280391411,"isCompleted":true,"status":"Completed","timeDisplay":"17:04","freque...
I/flutter (25041): ✅ Saved nextHabit: {"id":"1759709114965","name":"yrst","category":"Personal","colorValue":4280391411,"isCompleted":fals...
I/flutter (25041): ✅ Saved selectedDate: 2025-10-05
I/flutter (25041): ✅ Saved themeMode: dark
I/flutter (25041): ✅ Saved primaryColor: 4280391411
I/flutter (25041): ✅ Saved lastUpdate: 1759709119907
I/flutter (25041): 🧪 FORCE UPDATE: Waited 300ms for data propagation
I/MainActivity(25041): Widget force refresh triggered for both compact and timeline widgets
I/flutter (25041): 🧪 FORCE UPDATE: Successfully triggered widget refresh via method channel
I/flutter (25041): 🧪 FORCE UPDATE: Completed successfully
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (25041): │ #1   AppLifecycleService._refreshWidgetsOnResume.<anonymous closure> (package:habitv8/services/app_lifecycle_service.dart:282:21)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 🐛 ✅ Widgets force refreshed successfully on app resume
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
W/JobInfo (25041): Requested important-while-foreground flag for job25 is ignored and takes no effect
D/WM-SystemJobScheduler(25041): Scheduling work ID c28418f0-6394-4bb2-b54c-8d3a806391c9Job ID 25
I/flutter (25041): Widget HabitTimelineWidgetProvider update completed
I/flutter (25041): Updating widget HabitCompactWidgetProvider with data keys: [habits, nextHabit, selectedDate, themeMode, primaryColor, lastUpdate]
D/WM-GreedyScheduler(25041): Starting work for c28418f0-6394-4bb2-b54c-8d3a806391c9
I/flutter (25041): ✅ Saved habits: length=354, preview=[{"id":"1759709001188","name":"test","category":"Health","colorValue":4280391411,"isCompleted":true,"status":"Completed","timeDisplay":"17:04","freque...
D/WM-Processor(25041): Processor: processing WorkGenerationalId(workSpecId=c28418f0-6394-4bb2-b54c-8d3a806391c9, generation=0)
D/WM-SystemJobService(25041): onStartJob for WorkGenerationalId(workSpecId=c28418f0-6394-4bb2-b54c-8d3a806391c9, generation=0)
I/flutter (25041): ✅ Saved nextHabit: {"id":"1759709114965","name":"yrst","category":"Personal","colorValue":4280391411,"isCompleted":fals...
I/flutter (25041): ✅ Saved selectedDate: 2025-10-05
I/flutter (25041): ✅ Saved themeMode: dark
I/flutter (25041): ✅ Saved primaryColor: 4280391411
D/WM-WorkerWrapper(25041): Starting work for com.habittracker.habitv8.WidgetUpdateWorker
D/WM-Processor(25041): Work WorkGenerationalId(workSpecId=c28418f0-6394-4bb2-b54c-8d3a806391c9, generation=0) is already enqueued for processing
I/flutter (25041): ✅ Saved lastUpdate: 1759709119907
I/WidgetUpdateWorker(25041): Starting widget update work
D/WidgetUpdateWorker(25041): Widget data loaded: 354 characters
D/WidgetUpdateWorker(25041): Updating habits data: 354 characters
D/WidgetUpdateWorker(25041): Processed 2 total habits, 2 for today
D/WidgetUpdateWorker(25041): Theme settings copied: mode=null, color=ffffffff
D/WidgetUpdateWorker(25041): Widget data updated from Flutter preferences
D/WidgetUpdateWorker(25041): Updated 1 timeline widgets
D/HabitTimelineWidget(25041): onUpdate called with 1 widget IDs
D/HabitTimelineWidget(25041): ListView setup completed for widget 33 (service will read fresh theme data)
D/HabitTimelineWidget(25041): Detected theme mode: 'dark'
D/HabitTimelineWidget(25041): Using theme - mode: 'dark', primary: ff2196f3
D/HabitTimelineWidget(25041): Semi-transparent theme applied - isDark: true, bg: 800f0f0f
D/HabitTimelineService(25041): onDataSetChanged called - FORCING reload (invalidating cache)
D/HabitTimelineService(25041): 🎨 Loading fresh theme data from preferences:
D/HabitTimelineService(25041):   - HomeWidget['themeMode']: dark
D/HabitTimelineService(25041):   - Flutter['flutter.theme_mode']: null
D/HabitTimelineService(25041): 🎨 Final detected theme mode: 'dark'
D/HabitTimelineService(25041): Theme applied - isDark: true, textColor: ffffffff, primary: ff2196f3
D/HabitTimelineService(25041): ✅ Found habits data at key 'habits', length: 354, preview: [{"id":"1759709001188","name":"test","category":"Health","colorValue":4280391411,"isCompleted":true,
D/HabitTimelineService(25041): Attempting to load habits from key: habits, Raw length: 354
D/HabitTimelineWidget(25041): Found habits in widgetData
D/HabitTimelineWidget(25041): Widget update completed for ID: 33
I/WidgetUpdateWorker(25041): ✅ Widget update work completed successfully
D/HabitTimelineService(25041): Loaded 2 habits for timeline widget
D/HabitTimelineService(25041): First habit keys: [id, name, category, colorValue, isCompleted, status, timeDisplay, frequency]
D/HabitTimelineService(25041): getCount returning: 2 habits
D/HabitTimelineService(25041): getViewAt position: 0
D/HabitTimelineService(25041): Created view for habit: test at position 0
I/WM-WorkerWrapper(25041): Worker result SUCCESS for Work [ id=c28418f0-6394-4bb2-b54c-8d3a806391c9, tags={ com.habittracker.habitv8.WidgetUpdateWorker } ]
D/HabitTimelineService(25041): getViewAt position: 1
D/HabitTimelineService(25041): Created view for habit: yrst at position 1
D/WM-Processor(25041): Processor c28418f0-6394-4bb2-b54c-8d3a806391c9 executed; reschedule = false
D/WM-SystemJobService(25041): c28418f0-6394-4bb2-b54c-8d3a806391c9 executed on JobScheduler
D/WM-GreedyScheduler(25041): Cancelling work ID c28418f0-6394-4bb2-b54c-8d3a806391c9
D/HabitTimelineService(25041): getCount returning: 2 habits
D/HabitTimelineService(25041): getViewAt position: 0
D/HabitTimelineService(25041): Created view for habit: test at position 0
D/HabitTimelineService(25041): getViewAt position: 1
D/HabitTimelineService(25041): Created view for habit: yrst at position 1
D/HabitTimelineService(25041): onDataSetChanged called - FORCING reload (invalidating cache)
D/HabitTimelineService(25041): 🎨 Loading fresh theme data from preferences:
D/HabitTimelineService(25041):   - HomeWidget['themeMode']: dark
D/HabitTimelineService(25041):   - Flutter['flutter.theme_mode']: null
D/HabitTimelineService(25041): 🎨 Final detected theme mode: 'dark'
D/HabitTimelineService(25041): Theme applied - isDark: true, textColor: ffffffff, primary: ff2196f3
D/HabitTimelineService(25041): ✅ Found habits data at key 'habits', length: 354, preview: [{"id":"1759709001188","name":"test","category":"Health","colorValue":4280391411,"isCompleted":true,
D/HabitTimelineService(25041): Attempting to load habits from key: habits, Raw length: 354
D/HabitTimelineService(25041): Loaded 2 habits for timeline widget
D/HabitTimelineService(25041): First habit keys: [id, name, category, colorValue, isCompleted, status, timeDisplay, frequency]
D/HabitTimelineService(25041): getCount returning: 2 habits
D/HabitTimelineService(25041): getViewAt position: 0
D/HabitTimelineService(25041): Created view for habit: test at position 0
D/HabitTimelineService(25041): getViewAt position: 1
D/HabitTimelineService(25041): Created view for habit: yrst at position 1
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (25041): │ #1   MidnightHabitResetService.checkForMissedResetOnAppActive (package:habitv8/services/midnight_habit_reset_service.dart:270:17)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 🐛 🔍 Checking for missed resets on app activation
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (25041): │ #1   MidnightHabitResetService._checkMissedReset (package:habitv8/services/midnight_habit_reset_service.dart:84:21)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 🐛 ✅ No missed reset - last reset was today
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (25041): │ #1   AppLifecycleService._checkMissedResetOnResume.<anonymous closure> (package:habitv8/services/app_lifecycle_service.dart:304:21)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 🐛 ✅ Missed reset check completed on app resume
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): Widget HabitCompactWidgetProvider update completed
I/flutter (25041): ✅ All widgets updated successfully (debounced)
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (25041): │ #1   AppLifecycleService.didChangeAppLifecycleState (package:habitv8/services/app_lifecycle_service.dart:69:15)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 💡 📱 App lifecycle state changed to: AppLifecycleState.inactive
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (25041): │ #1   AppLifecycleService.didChangeAppLifecycleState (package:habitv8/services/app_lifecycle_service.dart:88:19)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 💡 ⏹️ App inactive
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/MainActivity(25041): onPause: Preserving alarm sound if playing
D/VRI[MainActivity](25041): visibilityChanged oldVisibility=true newVisibility=false
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (25041): │ #1   AppLifecycleService.didChangeAppLifecycleState (package:habitv8/services/app_lifecycle_service.dart:69:15)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 💡 📱 App lifecycle state changed to: AppLifecycleState.hidden
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (25041): │ #1   AppLifecycleService.didChangeAppLifecycleState (package:habitv8/services/app_lifecycle_service.dart:91:19)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 💡 👁️ App hidden
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (25041): │ #1   AppLifecycleService.didChangeAppLifecycleState (package:habitv8/services/app_lifecycle_service.dart:69:15)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 💡 📱 App lifecycle state changed to: AppLifecycleState.paused
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (25041): │ #1   AppLifecycleService.didChangeAppLifecycleState (package:habitv8/services/app_lifecycle_service.dart:79:19)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 💡 ⏸️ App paused - performing background cleanup...
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (25041): │ #1   AppLifecycleService._performBackgroundCleanup (package:habitv8/services/app_lifecycle_service.dart:320:17)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 🐛 🧹 Performing background cleanup...
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (25041): │ #1   AppLifecycleService._performBackgroundCleanup (package:habitv8/services/app_lifecycle_service.dart:325:17)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 🐛 ✅ Background cleanup completed
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
D/ImeBackDispatcher(25041): Clear (mImeCallbacks.size=0)
D/ImeBackDispatcher(25041): switch root view (mImeCallbacks.size=0)
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (25041): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:43:15)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 💡 🔍 Checking notification callback registration...
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (25041): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:44:15)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 💡 📦 Container available: true
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (25041): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:45:15)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 💡 🔗 Callback currently set: true
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (25041): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:56:17)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 💡 ✅ Notification action callback is properly registered
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (25041): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:43:15)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 💡 🔍 Checking notification callback registration...
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (25041): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:44:15)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 💡 📦 Container available: true
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (25041): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:45:15)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 💡 🔗 Callback currently set: true
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (25041): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:56:17)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 💡 ✅ Notification action callback is properly registered
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/Choreographer(25041): Skipped 41 frames!  The application may be doing too much work on its main thread.
I/flutter (25041): [IMPORTANT:flutter/shell/platform/android/android_context_vk_impeller.cc(62)] Using the Impeller rendering backend (Vulkan).
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (25041): │ #1   onBackgroundNotificationResponse (package:habitv8/services/notifications/notification_action_handler.dart:25:15)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 💡 🔔 BACKGROUND notification response received
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (25041): │ #1   onBackgroundNotificationResponse (package:habitv8/services/notifications/notification_action_handler.dart:26:15)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 💡 Background action ID: complete
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (25041): │ #1   onBackgroundNotificationResponse (package:habitv8/services/notifications/notification_action_handler.dart:27:15)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 💡 Background payload: {"habitId":"1759709114965","type":"habit_reminder"}
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (25041): │ #1   onBackgroundNotificationResponse (package:habitv8/services/notifications/notification_action_handler.dart:35:21)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 💡 Extracted habitId from payload: 1759709114965
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (25041): │ #1   onBackgroundNotificationResponse (package:habitv8/services/notifications/notification_action_handler.dart:39:23)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 💡 Processing background action: complete
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (25041): │ #1   onBackgroundNotificationResponse (package:habitv8/services/notifications/notification_action_handler.dart:57:25)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 💡 ! No handlers available, using background database access
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (25041): │ #1   onBackgroundNotificationResponse (package:habitv8/services/notifications/notification_action_handler.dart:61:25)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 💡 ✅ Hive initialized in background handler
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (25041): │ #1   NotificationActionHandler.completeHabitInBackground (package:habitv8/services/notifications/notification_action_handler.dart:200:17)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 💡 ⚙️ Completing habit in background: 1759709114965
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): 🔄 onHabitCompleted called - updating all widgets
I/flutter (25041): Error triggering Android widget update: MissingPluginException(No implementation found for method triggerImmediateUpdate on channel com.habittracker.habitv8/widget_update)
I/flutter (25041): ✅ Widget update completed after habit completion
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (25041): │ #1   HabitService.markHabitComplete (package:habitv8/data/database.dart:1148:21)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 🐛 Calendar sync disabled, skipping completion sync for habit "yrst"
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (25041): │ #1   NotificationActionHandler.completeHabitInBackground (package:habitv8/services/notifications/notification_action_handler.dart:247:17)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 💡 ✅ Habit completed in background: yrst
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (25041): │ #1   NotificationActionHandler.completeHabitInBackground (package:habitv8/services/notifications/notification_action_handler.dart:251:17)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 🐛 💾 Database flushed after background completion
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): Filtering 2 habits for date 2025-10-05:
I/flutter (25041):   - test: HabitFrequency.daily -> INCLUDED
I/flutter (25041):   - yrst: HabitFrequency.daily -> INCLUDED
I/flutter (25041): Result: 2 habits for today
I/flutter (25041): Widget data preparation: Found 2 total habits, 2 for today
I/flutter (25041): 🎨 Getting app theme: ThemeMode.system
I/flutter (25041): 🎨 App is in SYSTEM mode, device brightness: Brightness.light → light
I/flutter (25041): 🎨 Final theme mode to send to widgets: light
I/flutter (25041): 🎨 Using app primary color: 4280391411
I/flutter (25041): 🎯 Widget data prepared: 2 habits in list, JSON length: 359
I/flutter (25041): 🎯 First 200 chars of habits JSON: [{"id":"1759709001188","name":"test","category":"Health","colorValue":4280391411,"isCompleted":true,"status":"Completed","timeDisplay":"17:04","frequency":"HabitFrequency.daily"},{"id":"1759709114965"
I/flutter (25041): 🎯 Theme data: light, primary: 4280391411
I/flutter (25041): Saved widget theme data: light, color: 4280391411
I/flutter (25041): Updating widget HabitTimelineWidgetProvider with data keys: [habits, nextHabit, selectedDate, themeMode, primaryColor, lastUpdate]
I/flutter (25041): ✅ Saved habits: length=359, preview=[{"id":"1759709001188","name":"test","category":"Health","colorValue":4280391411,"isCompleted":true,"status":"Completed","timeDisplay":"17:04","freque...
I/flutter (25041): ✅ Saved nextHabit: null
I/flutter (25041): ✅ Saved selectedDate: 2025-10-05
I/flutter (25041): ✅ Saved themeMode: light
I/flutter (25041): ✅ Saved primaryColor: 4280391411
I/flutter (25041): ✅ Saved lastUpdate: 1759709227753
I/flutter (25041): Widget HabitTimelineWidgetProvider update completed
I/flutter (25041): Updating widget HabitCompactWidgetProvider with data keys: [habits, nextHabit, selectedDate, themeMode, primaryColor, lastUpdate]
I/flutter (25041): ✅ Saved habits: length=359, preview=[{"id":"1759709001188","name":"test","category":"Health","colorValue":4280391411,"isCompleted":true,"status":"Completed","timeDisplay":"17:04","freque...
I/flutter (25041): ✅ Saved nextHabit: null
I/flutter (25041): ✅ Saved selectedDate: 2025-10-05
I/flutter (25041): ✅ Saved themeMode: light
I/flutter (25041): ✅ Saved primaryColor: 4280391411
I/flutter (25041): ✅ Saved lastUpdate: 1759709227753
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (25041): │ #1   NotificationActionHandler.completeHabitInBackground (package:habitv8/services/notifications/notification_action_handler.dart:255:17)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 🐛 ⏱️ Waited for database sync
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): 🔄 onHabitCompleted called - updating all widgets
I/flutter (25041): ⏱️ Widget update already pending, will schedule another
I/flutter (25041): Error triggering Android widget update: MissingPluginException(No implementation found for method triggerImmediateUpdate on channel com.habittracker.habitv8/widget_update)
I/flutter (25041): ✅ Widget update completed after habit completion
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (25041): │ #1   NotificationActionHandler.completeHabitInBackground (package:habitv8/services/notifications/notification_action_handler.dart:260:19)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 💡 ✅ Widget updated after background completion
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (25041): │ #1   onBackgroundNotificationResponse (package:habitv8/services/notifications/notification_action_handler.dart:72:15)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 💡 ✅ Background notification response processed
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ⏱️ Skipping duplicate widget update
I/flutter (25041): Widget HabitCompactWidgetProvider update completed
I/flutter (25041): ✅ All widgets updated successfully (debounced)
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (25041): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:43:15)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 💡 🔍 Checking notification callback registration...
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (25041): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:44:15)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 💡 📦 Container available: true
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (25041): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:45:15)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 💡 🔗 Callback currently set: true
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (25041): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:56:17)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 💡 ✅ Notification action callback is properly registered
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
D/ViewRootImpl(25041): Skipping stats log for color mode
I/MainActivity(25041): onRestart: Preserving alarm sound if playing
D/MainActivity(25041): onNewIntent called with action: android.intent.action.MAIN
I/MainActivity(25041): onResume: Preserving alarm sound state
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (25041): │ #1   AppLifecycleService.didChangeAppLifecycleState (package:habitv8/services/app_lifecycle_service.dart:69:15)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 💡 📱 App lifecycle state changed to: AppLifecycleState.hidden
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (25041): │ #1   AppLifecycleService.didChangeAppLifecycleState (package:habitv8/services/app_lifecycle_service.dart:91:19)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 💡 👁️ App hidden
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (25041): │ #1   AppLifecycleService.didChangeAppLifecycleState (package:habitv8/services/app_lifecycle_service.dart:69:15)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 💡 📱 App lifecycle state changed to: AppLifecycleState.inactive
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (25041): │ #1   AppLifecycleService.didChangeAppLifecycleState (package:habitv8/services/app_lifecycle_service.dart:88:19)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 💡 ⏹️ App inactive
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
D/ImeBackDispatcher(25041): switch root view (mImeCallbacks.size=0)
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (25041): │ #1   AppLifecycleService.didChangeAppLifecycleState (package:habitv8/services/app_lifecycle_service.dart:69:15)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 💡 📱 App lifecycle state changed to: AppLifecycleState.resumed
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (25041): │ #1   AppLifecycleService.didChangeAppLifecycleState (package:habitv8/services/app_lifecycle_service.dart:84:19)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 💡 ▶️ App resumed
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (25041): │ #1   AppLifecycleService._handleAppResumed (package:habitv8/services/app_lifecycle_service.dart:131:17)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 💡 🔄 Handling app resume - re-registering notification callbacks...
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (25041): │ #1   AppLifecycleService._ensureDatabaseConnection (package:habitv8/services/app_lifecycle_service.dart:183:17)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 🐛 🔗 Ensuring database connection is valid...
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (25041): │ #1   AppLifecycleService._handleAppResumed (package:habitv8/services/app_lifecycle_service.dart:141:21)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 💡 🔄 About to invalidate habitsProvider on app resume
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (25041): │ #1   AppLifecycleService._handleAppResumed (package:habitv8/services/app_lifecycle_service.dart:143:21)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 💡 🔄 Invalidated habitsProvider to force refresh from database
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
D/InsetsController(25041): hide(ime())
I/ImeTracker(25041): com.habittracker.habitv8.debug:6071f4b5: onCancelled at PHASE_CLIENT_ALREADY_HIDDEN
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (25041): │ #1   habitsProvider.<anonymous closure> (package:habitv8/data/database.dart:428:13)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 💡 🔍 habitsProvider: Starting to fetch habits from database
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (25041): │ #1   habitsProvider.<anonymous closure> (package:habitv8/data/database.dart:431:13)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 💡 🔍 habitsProvider: Fetched 2 habits from database
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (25041): │ #1   habitsProvider.<anonymous closure> (package:habitv8/data/database.dart:437:17)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 🐛    test: 1 completions
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/ImeTracker(25041): system_server:679cde18: onCancelled at PHASE_CLIENT_ON_CONTROLS_CHANGED
D/ImeBackDispatcher(25041): Register received callback id=213350146 priority=0
D/WindowOnBackDispatcher(25041): setTopOnBackInvokedCallback (unwrapped): android.view.ImeBackAnimationController@8633981
D/ImeBackDispatcher(25041): Unregister received callback id=213350146
D/WindowOnBackDispatcher(25041): setTopOnBackInvokedCallback (unwrapped): android.app.Activity$$ExternalSyntheticLambda0@8e6bc39
I/ImeTracker(25041): system_server:c1a01b44: onCancelled at PHASE_CLIENT_ON_CONTROLS_CHANGED
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (25041): │ #1   AppLifecycleService._ensureDatabaseConnection.<anonymous closure> (package:habitv8/services/app_lifecycle_service.dart:194:23)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 🐛 ✅ Database connection is healthy
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (25041): │ #1   AppLifecycleService._handleAppResumed (package:habitv8/services/app_lifecycle_service.dart:148:21)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 💡 ⏱️ Delay after invalidation complete
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (25041): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:43:15)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 💡 🔍 Checking notification callback registration...
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (25041): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:44:15)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 💡 📦 Container available: true
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (25041): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:45:15)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 💡 🔗 Callback currently set: true
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (25041): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:56:17)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 💡 ✅ Notification action callback is properly registered
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (25041): │ #1   AppLifecycleService._processPendingActionsWithRetry (package:habitv8/services/app_lifecycle_service.dart:236:15)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 💡 🔄 Scheduling pending action processing attempt 1/5 with 1000ms delay
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (25041): │ #1   AppLifecycleService._refreshWidgetsOnResume (package:habitv8/services/app_lifecycle_service.dart:275:17)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 🐛 🔄 Force refreshing widgets on app resume...
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (25041): │ #1   AppLifecycleService._checkMissedResetOnResume (package:habitv8/services/app_lifecycle_service.dart:297:17)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 🐛 🔍 Checking for missed midnight resets on app resume...
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (25041): │ #1   AppLifecycleService._handleAppResumed (package:habitv8/services/app_lifecycle_service.dart:173:17)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 💡 ✅ App resume handling completed
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (25041): │ #1   NotificationActionHandler.processPendingActionsManually (package:habitv8/services/notifications/notification_action_handler.dart:924:15)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 💡 🔄 Manually processing pending actions
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (25041): │ #1   NotificationActionHandler.processPendingActionsManually (package:habitv8/services/notifications/notification_action_handler.dart:928:17)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 💡 ✅ Using callback to process pending actions
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (25041): │ #1   NotificationActionHandler.processPendingActions (package:habitv8/services/notifications/notification_action_handler.dart:336:15)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 💡 🔄 Processing pending notification actions
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (25041): │ #1   NotificationStorage.loadAllActions (package:habitv8/services/notifications/notification_storage.dart:254:17)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 🐛 🔍 All SharedPreferences keys: [onboarding_completed, trial_start_date, subscription_status, user_achievements, user_xp, last_midnight_reset, last_trial_check]
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (25041): │ #1   NotificationStorage.loadAllActions (package:habitv8/services/notifications/notification_storage.dart:260:17)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 🐛 🔍 Method 1 (getStringList): null
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (25041): │ #1   NotificationStorage.loadAllActions (package:habitv8/services/notifications/notification_storage.dart:261:17)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 🐛 🔍 Method 2 (get): null
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (25041): │ #1   NotificationStorage.loadAllActions (package:habitv8/services/notifications/notification_storage.dart:265:17)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 🐛 🔍 Found 0 pending actions in SharedPreferences
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (25041): │ #1   NotificationStorage.loadAllActions (package:habitv8/services/notifications/notification_storage.dart:272:19)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 🐛 No pending notification actions to process in SharedPreferences
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (25041): │ #1   NotificationStorage.loadActionsFromFile (package:habitv8/services/notifications/notification_storage.dart:339:17)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 🐛 🔍 File: Checking for actions at path: /data/user/0/com.habittracker.habitv8.debug/app_flutter/pending_notification_actions.json
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (25041): │ #1   NotificationStorage.loadActionsFromFile (package:habitv8/services/notifications/notification_storage.dart:342:19)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 🐛 🔍 File: File does not exist
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (25041): │ #1   NotificationStorage.loadAllActions (package:habitv8/services/notifications/notification_storage.dart:297:19)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 🐛 No pending actions found in any storage method
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (25041): │ #1   NotificationActionHandler.processPendingActions (package:habitv8/services/notifications/notification_action_handler.dart:341:15)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 💡 Found 0 actions in storage
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (25041): │ #1   NotificationActionHandler.processPendingActions (package:habitv8/services/notifications/notification_action_handler.dart:345:17)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 💡 ⏭️  No new actions - initial pending actions already processed
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (25041): │ #1   AppLifecycleService._processPendingActionsWithRetry.<anonymous closure> (package:habitv8/services/app_lifecycle_service.dart:242:19)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 💡 ✅ Pending actions processed successfully on attempt 1
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): 🧪 FORCE UPDATE: Starting immediate widget update...
I/flutter (25041): 🧪 FORCE UPDATE: Called from notification completion handler
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (25041): │ #1   AppLifecycleService._processPendingCompletions.<anonymous closure> (package:habitv8/services/app_lifecycle_service.dart:265:19)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 💡 ✅ Pending completions processed successfully
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): 🧪 FORCE UPDATE: updateAllWidgets() completed
I/flutter (25041): Filtering 2 habits for date 2025-10-05:
I/flutter (25041):   - test: HabitFrequency.daily -> INCLUDED
I/flutter (25041):   - yrst: HabitFrequency.daily -> INCLUDED
I/flutter (25041): Result: 2 habits for today
I/flutter (25041): Widget data preparation: Found 2 total habits, 2 for today
I/flutter (25041): 🎨 Getting app theme: ThemeMode.system
I/flutter (25041): 🎨 App is in SYSTEM mode, device brightness: Brightness.dark → dark
I/flutter (25041): 🎨 Final theme mode to send to widgets: dark
I/flutter (25041): 🎨 Using app primary color: 4280391411
I/flutter (25041): 🎯 Widget data prepared: 2 habits in list, JSON length: 354
I/flutter (25041): 🎯 First 200 chars of habits JSON: [{"id":"1759709001188","name":"test","category":"Health","colorValue":4280391411,"isCompleted":true,"status":"Completed","timeDisplay":"17:04","frequency":"HabitFrequency.daily"},{"id":"1759709114965"
I/flutter (25041): 🎯 Theme data: dark, primary: 4280391411
I/flutter (25041): Saved widget theme data: dark, color: 4280391411
I/flutter (25041): Updating widget HabitTimelineWidgetProvider with data keys: [habits, nextHabit, selectedDate, themeMode, primaryColor, lastUpdate]
I/flutter (25041): ✅ Saved habits: length=354, preview=[{"id":"1759709001188","name":"test","category":"Health","colorValue":4280391411,"isCompleted":true,"status":"Completed","timeDisplay":"17:04","freque...
I/flutter (25041): ✅ Saved nextHabit: null
I/flutter (25041): ✅ Saved selectedDate: 2025-10-05
I/flutter (25041): ✅ Saved themeMode: dark
I/flutter (25041): ✅ Saved primaryColor: 4280391411
I/flutter (25041): ✅ Saved lastUpdate: 1759709294765
I/flutter (25041): 🧪 FORCE UPDATE: Waited 300ms for data propagation
I/MainActivity(25041): Widget force refresh triggered for both compact and timeline widgets
I/flutter (25041): 🧪 FORCE UPDATE: Successfully triggered widget refresh via method channel
I/flutter (25041): 🧪 FORCE UPDATE: Completed successfully
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (25041): │ #1   AppLifecycleService._refreshWidgetsOnResume.<anonymous closure> (package:habitv8/services/app_lifecycle_service.dart:282:21)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 🐛 ✅ Widgets force refreshed successfully on app resume
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): Widget HabitTimelineWidgetProvider update completed
I/flutter (25041): Updating widget HabitCompactWidgetProvider with data keys: [habits, nextHabit, selectedDate, themeMode, primaryColor, lastUpdate]
I/flutter (25041): ✅ Saved habits: length=354, preview=[{"id":"1759709001188","name":"test","category":"Health","colorValue":4280391411,"isCompleted":true,"status":"Completed","timeDisplay":"17:04","freque...
I/flutter (25041): ✅ Saved nextHabit: null
I/flutter (25041): ✅ Saved selectedDate: 2025-10-05
W/JobInfo (25041): Requested important-while-foreground flag for job26 is ignored and takes no effect
D/WM-SystemJobScheduler(25041): Scheduling work ID bc955c1b-3964-40a5-8808-aa793e242206Job ID 26
I/flutter (25041): ✅ Saved themeMode: dark
I/flutter (25041): ✅ Saved primaryColor: 4280391411
I/flutter (25041): ✅ Saved lastUpdate: 1759709294765
D/WM-GreedyScheduler(25041): Starting work for bc955c1b-3964-40a5-8808-aa793e242206
D/WM-Processor(25041): Processor: processing WorkGenerationalId(workSpecId=bc955c1b-3964-40a5-8808-aa793e242206, generation=0)
D/WM-SystemJobService(25041): onStartJob for WorkGenerationalId(workSpecId=bc955c1b-3964-40a5-8808-aa793e242206, generation=0)
D/WM-WorkerWrapper(25041): Starting work for com.habittracker.habitv8.WidgetUpdateWorker
I/WidgetUpdateWorker(25041): Starting widget update work
D/WM-Processor(25041): Work WorkGenerationalId(workSpecId=bc955c1b-3964-40a5-8808-aa793e242206, generation=0) is already enqueued for processing
D/WidgetUpdateWorker(25041): Widget data loaded: 354 characters
D/WidgetUpdateWorker(25041): Updating habits data: 354 characters
D/WidgetUpdateWorker(25041): Processed 2 total habits, 2 for today
D/WidgetUpdateWorker(25041): Theme settings copied: mode=null, color=ffffffff
D/WidgetUpdateWorker(25041): Widget data updated from Flutter preferences
D/WidgetUpdateWorker(25041): Updated 1 timeline widgets
D/HabitTimelineWidget(25041): onUpdate called with 1 widget IDs
D/HabitTimelineWidget(25041): ListView setup completed for widget 33 (service will read fresh theme data)
D/HabitTimelineWidget(25041): Detected theme mode: 'dark'
D/HabitTimelineWidget(25041): Using theme - mode: 'dark', primary: ff2196f3
D/HabitTimelineWidget(25041): Semi-transparent theme applied - isDark: true, bg: 800f0f0f
D/HabitTimelineWidget(25041): Found habits in widgetData
D/HabitTimelineWidget(25041): Widget update completed for ID: 33
I/WidgetUpdateWorker(25041): ✅ Widget update work completed successfully
I/WM-WorkerWrapper(25041): Worker result SUCCESS for Work [ id=bc955c1b-3964-40a5-8808-aa793e242206, tags={ com.habittracker.habitv8.WidgetUpdateWorker } ]
D/WM-Processor(25041): Processor bc955c1b-3964-40a5-8808-aa793e242206 executed; reschedule = false
D/WM-SystemJobService(25041): bc955c1b-3964-40a5-8808-aa793e242206 executed on JobScheduler
D/WM-GreedyScheduler(25041): Cancelling work ID bc955c1b-3964-40a5-8808-aa793e242206
D/HabitTimelineService(25041): onDataSetChanged called - FORCING reload (invalidating cache)
D/HabitTimelineService(25041): 🎨 Loading fresh theme data from preferences:
D/HabitTimelineService(25041):   - HomeWidget['themeMode']: dark
D/HabitTimelineService(25041):   - Flutter['flutter.theme_mode']: null
D/HabitTimelineService(25041): 🎨 Final detected theme mode: 'dark'
D/HabitTimelineService(25041): Theme applied - isDark: true, textColor: ffffffff, primary: ff2196f3
D/HabitTimelineService(25041): ✅ Found habits data at key 'habits', length: 354, preview: [{"id":"1759709001188","name":"test","category":"Health","colorValue":4280391411,"isCompleted":true,
D/HabitTimelineService(25041): Attempting to load habits from key: habits, Raw length: 354
D/HabitTimelineService(25041): Loaded 2 habits for timeline widget
D/HabitTimelineService(25041): First habit keys: [id, name, category, colorValue, isCompleted, status, timeDisplay, frequency]
D/HabitTimelineService(25041): getCount returning: 2 habits
D/HabitTimelineService(25041): getViewAt position: 0
D/HabitTimelineService(25041): Created view for habit: test at position 0
D/HabitTimelineService(25041): getViewAt position: 1
D/HabitTimelineService(25041): Created view for habit: yrst at position 1
D/HabitTimelineService(25041): getCount returning: 2 habits
D/HabitTimelineService(25041): getViewAt position: 0
D/HabitTimelineService(25041): Created view for habit: test at position 0
D/HabitTimelineService(25041): getViewAt position: 1
D/HabitTimelineService(25041): Created view for habit: yrst at position 1
D/HabitTimelineService(25041): onDataSetChanged called - FORCING reload (invalidating cache)
D/HabitTimelineService(25041): 🎨 Loading fresh theme data from preferences:
D/HabitTimelineService(25041):   - HomeWidget['themeMode']: dark
D/HabitTimelineService(25041):   - Flutter['flutter.theme_mode']: null
D/HabitTimelineService(25041): 🎨 Final detected theme mode: 'dark'
D/HabitTimelineService(25041): Theme applied - isDark: true, textColor: ffffffff, primary: ff2196f3
D/HabitTimelineService(25041): ✅ Found habits data at key 'habits', length: 354, preview: [{"id":"1759709001188","name":"test","category":"Health","colorValue":4280391411,"isCompleted":true,
D/HabitTimelineService(25041): Attempting to load habits from key: habits, Raw length: 354
D/HabitTimelineService(25041): Loaded 2 habits for timeline widget
D/HabitTimelineService(25041): First habit keys: [id, name, category, colorValue, isCompleted, status, timeDisplay, frequency]
D/HabitTimelineService(25041): getCount returning: 2 habits
D/HabitTimelineService(25041): getViewAt position: 0
D/HabitTimelineService(25041): Created view for habit: test at position 0
D/HabitTimelineService(25041): getViewAt position: 1
D/HabitTimelineService(25041): Created view for habit: yrst at position 1
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (25041): │ #1   MidnightHabitResetService.checkForMissedResetOnAppActive (package:habitv8/services/midnight_habit_reset_service.dart:270:17)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 🐛 🔍 Checking for missed resets on app activation
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (25041): │ #1   MidnightHabitResetService._checkMissedReset (package:habitv8/services/midnight_habit_reset_service.dart:84:21)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 🐛 ✅ No missed reset - last reset was today
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (25041): │ #1   AppLifecycleService._checkMissedResetOnResume.<anonymous closure> (package:habitv8/services/app_lifecycle_service.dart:304:21)
I/flutter (25041): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (25041): │ 🐛 ✅ Missed reset check completed on app resume
I/flutter (25041): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (25041): Widget HabitCompactWidgetProvider update completed
I/flutter (25041): ✅ All widgets updated successfully (debounced)