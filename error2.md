I/flutter ( 9158): │ #1   AppLifecycleService._handleAppResumed (package:habitv8/services/app_lifecycle_service.dart:123:17)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡 ✅ App resume handling completed
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
D/ProfileInstaller( 9158): Installing profile for com.habittracker.habitv8.debug
D/WindowOnBackDispatcher( 9158): setTopOnBackInvokedCallback (unwrapped): androidx.activity.OnBackPressedDispatcher$Api34Impl$createOnBackAnimationCallback$1@8585178
D/ImeBackDispatcher( 9158): switch root view (mImeCallbacks.size=0)
D/InsetsController( 9158): hide(ime())
I/ImeTracker( 9158): com.habittracker.habitv8.debug:e4998ccf: onCancelled at PHASE_CLIENT_ALREADY_HIDDEN
D/WindowOnBackDispatcher( 9158): setTopOnBackInvokedCallback (unwrapped): android.app.Activity$$ExternalSyntheticLambda0@9bf33e8
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   MidnightHabitResetService.initialize (package:habitv8/services/midnight_habit_reset_service.dart:20:17)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡 🌙 Initializing Midnight Habit Reset Service
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   MidnightHabitResetService._startMidnightTimer (package:habitv8/services/midnight_habit_reset_service.dart:45:15)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡 ⏰ Next midnight reset in: 10h 23m
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   MidnightHabitResetService._startMidnightTimer (package:habitv8/services/midnight_habit_reset_service.dart:58:15)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡 🌙 Midnight reset timer started
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   MidnightHabitResetService._checkMissedReset (package:habitv8/services/midnight_habit_reset_service.dart:78:19)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡 🆕 First time running, performing initial reset
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   MidnightHabitResetService._performMidnightReset (package:habitv8/services/midnight_habit_reset_service.dart:90:17)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡 🌙 Performing midnight habit reset at 2025-09-12T13:36:52.881355
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   MidnightHabitResetService._performMidnightReset (package:habitv8/services/midnight_habit_reset_service.dart:99:17)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡 🔄 Processing 0 active habits for reset
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   MidnightHabitResetService._performMidnightReset (package:habitv8/services/midnight_habit_reset_service.dart:122:17)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡 ✅ Midnight reset completed: 0 reset, 0 errors
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   MidnightHabitResetService.initialize (package:habitv8/services/midnight_habit_reset_service.dart:29:17)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡 ✅ Midnight Habit Reset Service initialized successfully
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   NotificationService.processPendingActionsManually (package:habitv8/services/notification_service.dart:1228:15)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡 🔄 Manually processing pending actions
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   NotificationService.processPendingActionsManually (package:habitv8/services/notification_service.dart:1232:17)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡 ✅ Using callback to process pending actions
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter ( 9158): │ #1   NotificationService.processPendingActions (package:habitv8/services/notification_service.dart:796:17)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 🐛 🔍 All SharedPreferences keys: [last_midnight_reset]
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter ( 9158): │ #1   NotificationService.processPendingActions (package:habitv8/services/notification_service.dart:803:17)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 🐛 🔍 Method 1 (getStringList): null
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter ( 9158): │ #1   NotificationService.processPendingActions (package:habitv8/services/notification_service.dart:804:17)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 🐛 🔍 Method 2 (get): null
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter ( 9158): │ #1   NotificationService.processPendingActions (package:habitv8/services/notification_service.dart:808:17)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 🐛 🔍 Found 0 pending actions in SharedPreferences
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter ( 9158): │ #1   NotificationService.processPendingActions (package:habitv8/services/notification_service.dart:815:19)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 🐛 No pending notification actions to process in SharedPreferences
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter ( 9158): │ #1   NotificationService._loadActionsFromFile (package:habitv8/services/notification_service.dart:888:17)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 🐛 🔍 File: Checking for actions at path: /data/user/0/com.habittracker.habitv8.debug/app_flutter/pending_notification_actions.json
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter ( 9158): │ #1   NotificationService._loadActionsFromFile (package:habitv8/services/notification_service.dart:891:19)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 🐛 🔍 File: File does not exist
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter ( 9158): │ #1   NotificationService.processPendingActions (package:habitv8/services/notification_service.dart:841:19)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 🐛 No pending actions found in any storage method
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   AppLifecycleService._processPendingActionsWithRetry.<anonymous closure> (package:habitv8/services/app_lifecycle_service.dart:142:19)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡 ✅ Pending actions processed successfully on attempt 1
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
D/WindowOnBackDispatcher( 9158): setTopOnBackInvokedCallback (unwrapped): androidx.activity.OnBackPressedDispatcher$Api34Impl$createOnBackAnimationCallback$1@8585178
D/WindowOnBackDispatcher( 9158): setTopOnBackInvokedCallback (unwrapped): android.app.Activity$$ExternalSyntheticLambda0@9bf33e8
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter ( 9158): │ #1   _CreateHabitScreenState._buildFrequencySection (package:habitv8/ui/screens/create_habit_screen.dart:408:15)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 🐛 Building frequency section, current frequency: HabitFrequency.daily
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter ( 9158): │ #1   _CreateHabitScreenState._buildFrequencySection (package:habitv8/ui/screens/create_habit_screen.dart:408:15)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 🐛 Building frequency section, current frequency: HabitFrequency.daily
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
D/WindowOnBackDispatcher( 9158): setTopOnBackInvokedCallback (unwrapped): androidx.activity.OnBackPressedDispatcher$Api34Impl$createOnBackAnimationCallback$1@8585178
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter ( 9158): │ #1   _CreateHabitScreenState._buildFrequencySection (package:habitv8/ui/screens/create_habit_screen.dart:408:15)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 🐛 Building frequency section, current frequency: HabitFrequency.daily
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/ImeTracker( 9158): com.habittracker.habitv8.debug:61f872d1: onRequestShow at ORIGIN_CLIENT reason SHOW_SOFT_INPUT fromUser false
D/InsetsController( 9158): show(ime())
D/ImeBackDispatcher( 9158): Undo preliminary clear (mImeCallbacks.size=0)
D/InsetsController( 9158): Setting requestedVisibleTypes to -1 (was -9)
D/InputConnectionAdaptor( 9158): The input method toggled cursor monitoring on
D/ImeBackDispatcher( 9158): Register received callback id=122743935 priority=0
D/WindowOnBackDispatcher( 9158): setTopOnBackInvokedCallback (unwrapped): android.view.ImeBackAnimationController@923c93e
W/InteractionJankMonitor( 9158): Initializing without READ_DEVICE_CONFIG permission. enabled=false, interval=1, missedFrameThreshold=3, frameTimeThreshold=64, package=com.habittracker.habitv8.debug
I/ImeTracker( 9158): com.habittracker.habitv8.debug:61f872d1: onShown
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter ( 9158): │ #1   _CreateHabitScreenState._buildFrequencySection (package:habitv8/ui/screens/create_habit_screen.dart:408:15)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 🐛 Building frequency section, current frequency: HabitFrequency.daily
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter ( 9158): │ #1   _CreateHabitScreenState._buildFrequencySection (package:habitv8/ui/screens/create_habit_screen.dart:408:15)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 🐛 Building frequency section, current frequency: HabitFrequency.daily
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter ( 9158): │ #1   _CreateHabitScreenState._buildFrequencySection (package:habitv8/ui/screens/create_habit_screen.dart:408:15)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 🐛 Building frequency section, current frequency: HabitFrequency.daily
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter ( 9158): │ #1   _CreateHabitScreenState._buildFrequencySection (package:habitv8/ui/screens/create_habit_screen.dart:408:15)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 🐛 Building frequency section, current frequency: HabitFrequency.daily
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter ( 9158): │ #1   _CreateHabitScreenState._buildFrequencySection (package:habitv8/ui/screens/create_habit_screen.dart:408:15)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 🐛 Building frequency section, current frequency: HabitFrequency.daily
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/ImeTracker( 9158): com.habittracker.habitv8.debug:ed037c83: onRequestHide at ORIGIN_CLIENT reason HIDE_SOFT_INPUT fromUser false
D/InsetsController( 9158): hide(ime())
D/ImeBackDispatcher( 9158): Preliminary clear (mImeCallbacks.size=1)
D/WindowOnBackDispatcher( 9158): setTopOnBackInvokedCallback (unwrapped): androidx.activity.OnBackPressedDispatcher$Api34Impl$createOnBackAnimationCallback$1@8585178
D/InsetsController( 9158): Setting requestedVisibleTypes to -9 (was -1)
D/CompatChangeReporter( 9158): Compat change id reported: 395521150; UID 10492; state: ENABLED
D/InputConnectionAdaptor( 9158): The input method toggled cursor monitoring off
I/ImeTracker( 9158): system_server:a61a26ab: onCancelled at PHASE_CLIENT_ON_CONTROLS_CHANGED
D/ImeBackDispatcher( 9158): Unregister received callback id=122743935
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter ( 9158): │ #1   _CreateHabitScreenState._buildFrequencySection (package:habitv8/ui/screens/create_habit_screen.dart:408:15)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 🐛 Building frequency section, current frequency: HabitFrequency.daily
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter ( 9158): │ #1   _CreateHabitScreenState._buildFrequencySection (package:habitv8/ui/screens/create_habit_screen.dart:408:15)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 🐛 Building frequency section, current frequency: HabitFrequency.daily
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter ( 9158): │ #1   _CreateHabitScreenState._buildFrequencySection (package:habitv8/ui/screens/create_habit_screen.dart:408:15)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 🐛 Building frequency section, current frequency: HabitFrequency.daily
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter ( 9158): │ #1   _CreateHabitScreenState._buildFrequencySection (package:habitv8/ui/screens/create_habit_screen.dart:408:15)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 🐛 Building frequency section, current frequency: HabitFrequency.daily
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter ( 9158): │ #1   _CreateHabitScreenState._buildFrequencySection (package:habitv8/ui/screens/create_habit_screen.dart:408:15)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 🐛 Building frequency section, current frequency: HabitFrequency.daily
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter ( 9158): │ #1   NotificationService.scheduleHabitNotifications (package:habitv8/services/notification_service.dart:1884:15)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 🐛 Starting notification scheduling for habit: fghjk
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter ( 9158): │ #1   NotificationService.scheduleHabitNotifications (package:habitv8/services/notification_service.dart:1887:15)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 🐛 Notifications enabled: false
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter ( 9158): │ #1   NotificationService.scheduleHabitNotifications (package:habitv8/services/notification_service.dart:1888:15)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 🐛 Alarm enabled: true
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter ( 9158): │ #1   NotificationService.scheduleHabitNotifications (package:habitv8/services/notification_service.dart:1889:15)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 🐛 Notification time: 2025-09-12 13:39:00.000
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   NotificationService._ensureNotificationPermissions (package:habitv8/services/notification_service.dart:281:17)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡 Checking notification permission...
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   NotificationService._ensureNotificationPermissions (package:habitv8/services/notification_service.dart:286:19)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡 Requesting notification permission for scheduling...
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   PermissionService.requestNotificationPermissionWithContext (package:habitv8/services/permission_service.dart:123:17)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡 Requesting notification permission with user context...
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   PermissionService.requestNotificationPermission (package:habitv8/services/permission_service.dart:98:17)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡 Requesting notification permission when needed...
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   AppLifecycleService.didChangeAppLifecycleState (package:habitv8/services/app_lifecycle_service.dart:60:15)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡 📱 App lifecycle state changed to: AppLifecycleState.inactive
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   AppLifecycleService.didChangeAppLifecycleState (package:habitv8/services/app_lifecycle_service.dart:78:19)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡 ⏹️ App inactive
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
D/ImeBackDispatcher( 9158): Clear (mImeCallbacks.size=0)
D/ImeBackDispatcher( 9158): switch root view (mImeCallbacks.size=0)
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   PermissionService.requestNotificationPermission (package:habitv8/services/permission_service.dart:104:17)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡 Notification permission request result: true
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   PermissionService.requestNotificationPermissionWithContext (package:habitv8/services/permission_service.dart:129:19)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡 Notification permission granted successfully
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   PermissionService.hasExactAlarmPermission (package:habitv8/services/permission_service.dart:168:17)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡 Checking exact alarm permission status...
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   PermissionService.hasExactAlarmPermission (package:habitv8/services/permission_service.dart:172:17)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡 Exact alarm permission check result: true (simplified)
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   NotificationService._ensureNotificationPermissions (package:habitv8/services/notification_service.dart:319:19)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡 Exact alarm permission already available
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter ( 9158): │ #1   NotificationService.scheduleHabitNotifications (package:habitv8/services/notification_service.dart:1918:17)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 🐛 Alarms enabled - scheduling alarms instead of notifications
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter ( 9158): │ #1   NotificationService.scheduleHabitAlarms (package:habitv8/services/notification_service.dart:2023:15)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 🐛 Starting alarm scheduling for habit: fghjk
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter ( 9158): │ #1   NotificationService.scheduleHabitAlarms (package:habitv8/services/notification_service.dart:2024:15)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 🐛 Alarm enabled: true
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter ( 9158): │ #1   NotificationService.scheduleHabitAlarms (package:habitv8/services/notification_service.dart:2025:15)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 🐛 Alarm sound: Bright Morning
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter ( 9158): │ #1   NotificationService.scheduleHabitAlarms (package:habitv8/services/notification_service.dart:2026:15)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 🐛 Snooze delay: 10 minutes (fixed default)
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter ( 9158): │ #1   NotificationService.scheduleHabitAlarms (package:habitv8/services/notification_service.dart:2053:17)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 🐛 Scheduling alarm for 13:39
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   HybridAlarmService.cancelHabitAlarms (package:habitv8/services/hybrid_alarm_service.dart:444:15)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡 🔄 Cancelling all alarms for habit:
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   HybridAlarmService.cancelHabitAlarms (package:habitv8/services/hybrid_alarm_service.dart:470:15)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡 ✅ Cancelled alarms for habit
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter ( 9158): │ #1   NotificationService.scheduleHabitAlarms (package:habitv8/services/notification_service.dart:2061:17)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 🐛 Cancelled existing alarms for habit ID: 1757709441364
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter ( 9158): │ #1   NotificationService.scheduleHabitAlarms (package:habitv8/services/notification_service.dart:2064:17)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 🐛 Habit frequency: daily
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter ( 9158): │ #1   NotificationService.scheduleHabitAlarms (package:habitv8/services/notification_service.dart:2068:21)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 🐛 Scheduling daily alarms
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
D/ImeBackDispatcher( 9158): switch root view (mImeCallbacks.size=0)
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   AppLifecycleService.didChangeAppLifecycleState (package:habitv8/services/app_lifecycle_service.dart:60:15)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡 📱 App lifecycle state changed to: AppLifecycleState.resumed
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   AppLifecycleService.didChangeAppLifecycleState (package:habitv8/services/app_lifecycle_service.dart:74:19)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡 ▶️ App resumed
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   AppLifecycleService._handleAppResumed (package:habitv8/services/app_lifecycle_service.dart:113:17)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡 🔄 Handling app resume - re-registering notification callbacks...
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:42:15)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡 🔍 Checking notification callback registration...
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:43:15)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡 📦 Container available: true
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:44:15)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡 🔗 Callback currently set: true
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:55:17)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡 ✅ Notification action callback is properly registered
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   AppLifecycleService._processPendingActionsWithRetry (package:habitv8/services/app_lifecycle_service.dart:136:15)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡 🔄 Scheduling pending action processing attempt 1/5 with 1000ms delay
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   AppLifecycleService._handleAppResumed (package:habitv8/services/app_lifecycle_service.dart:123:17)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡 ✅ App resume handling completed
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   HybridAlarmService.scheduleExactAlarm (package:habitv8/services/hybrid_alarm_service.dart:74:15)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡 🔄 Scheduling exact alarm:
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   HybridAlarmService.scheduleExactAlarm (package:habitv8/services/hybrid_alarm_service.dart:75:15)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡   - Alarm ID: 96
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   HybridAlarmService.scheduleExactAlarm (package:habitv8/services/hybrid_alarm_service.dart:76:15)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡   - Habit: fghjk
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   HybridAlarmService.scheduleExactAlarm (package:habitv8/services/hybrid_alarm_service.dart:77:15)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡   - Scheduled time: 2025-09-12 13:39:00.000
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   HybridAlarmService.scheduleExactAlarm (package:habitv8/services/hybrid_alarm_service.dart:78:15)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡   - Raw sound input: "Bright Morning"
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   HybridAlarmService.scheduleExactAlarm (package:habitv8/services/hybrid_alarm_service.dart:79:15)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡   - Volume: 80% with 1-second fade-in (testing fix)
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.warning (package:habitv8/services/logging_service.dart:24:13)
I/flutter ( 9158): │ #1   HybridAlarmService._getAlarmSoundPath (package:habitv8/services/hybrid_alarm_service.dart:596:19)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ ! Unknown alarm sound "Bright Morning" → default
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   HybridAlarmService.scheduleExactAlarm (package:habitv8/services/hybrid_alarm_service.dart:83:15)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡   - Resolved sound path: "assets/sounds/digital_beep.mp3"
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   HybridAlarmService._preflightCheckAssetAudio (package:habitv8/services/hybrid_alarm_service.dart:609:17)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡 🔍 Preflight: loading asset via rootBundle: assets/sounds/digital_beep.mp3
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   HybridAlarmService._preflightCheckAssetAudio (package:habitv8/services/hybrid_alarm_service.dart:611:17)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡 🔍 Preflight: asset bytes length = 161
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   HybridAlarmService.scheduleExactAlarm (package:habitv8/services/hybrid_alarm_service.dart:102:19)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡   - Sound name mapped to asset: Bright Morning -> assets/sounds/digital_beep.mp3
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   HybridAlarmService.scheduleExactAlarm (package:habitv8/services/hybrid_alarm_service.dart:107:17)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡   - Creating AlarmSettings with path: assets/sounds/digital_beep.mp3
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   HybridAlarmService.scheduleExactAlarm (package:habitv8/services/hybrid_alarm_service.dart:128:17)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡   - AlarmSettings created successfully
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
D/InsetsController( 9158): hide(ime())
I/ImeTracker( 9158): com.habittracker.habitv8.debug:7b41b6ce: onCancelled at PHASE_CLIENT_ALREADY_HIDDEN
D/AlarmApiImpl( 9158): Warning notification turned on.
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   HybridAlarmService.scheduleExactAlarm (package:habitv8/services/hybrid_alarm_service.dart:130:17)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡   - Alarm.set() called successfully
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   HybridAlarmService.scheduleExactAlarm (package:habitv8/services/hybrid_alarm_service.dart:132:17)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡 ✅ Exact alarm scheduled successfully
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   NotificationService._scheduleDailyHabitAlarmsNew (package:habitv8/services/notification_service.dart:3479:15)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡 ✅ Scheduled daily alarms for fghjk
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter ( 9158): │ #1   NotificationService.scheduleHabitAlarms (package:habitv8/services/notification_service.dart:2102:17)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 🐛 Successfully scheduled alarms for habit: fghjk
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   NotificationService.scheduleHabitAlarms (package:habitv8/services/notification_service.dart:2103:17)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡 Successfully scheduled alarms for habit: fghjk
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   HabitService.addHabit (package:habitv8/data/database.dart:409:19)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡 Scheduled notifications/alarms for new habit "fghjk"
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter ( 9158): │ #1   HabitService.addHabit (package:habitv8/data/database.dart:423:19)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 🐛 Calendar sync disabled, skipping sync for new habit "fghjk"
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   _CreateHabitScreenState._saveHabit (package:habitv8/ui/screens/create_habit_screen.dart:1834:19)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡 Health mapping skipped - health integration removed
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter ( 9158): │ #1   NotificationService.scheduleHabitNotifications (package:habitv8/services/notification_service.dart:1884:15)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 🐛 Starting notification scheduling for habit: fghjk
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter ( 9158): │ #1   NotificationService.scheduleHabitNotifications (package:habitv8/services/notification_service.dart:1887:15)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 🐛 Notifications enabled: false
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter ( 9158): │ #1   NotificationService.scheduleHabitNotifications (package:habitv8/services/notification_service.dart:1888:15)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 🐛 Alarm enabled: true
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter ( 9158): │ #1   NotificationService.scheduleHabitNotifications (package:habitv8/services/notification_service.dart:1889:15)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 🐛 Notification time: 2025-09-12 13:39:00.000
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   NotificationService._ensureNotificationPermissions (package:habitv8/services/notification_service.dart:281:17)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡 Checking notification permission...
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   NotificationService._ensureNotificationPermissions (package:habitv8/services/notification_service.dart:297:19)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡 Notification permission already granted
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   PermissionService.hasExactAlarmPermission (package:habitv8/services/permission_service.dart:168:17)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡 Checking exact alarm permission status...
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   PermissionService.hasExactAlarmPermission (package:habitv8/services/permission_service.dart:172:17)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡 Exact alarm permission check result: true (simplified)
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   NotificationService._ensureNotificationPermissions (package:habitv8/services/notification_service.dart:319:19)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡 Exact alarm permission already available
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter ( 9158): │ #1   NotificationService.scheduleHabitNotifications (package:habitv8/services/notification_service.dart:1918:17)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 🐛 Alarms enabled - scheduling alarms instead of notifications
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter ( 9158): │ #1   NotificationService.scheduleHabitAlarms (package:habitv8/services/notification_service.dart:2023:15)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 🐛 Starting alarm scheduling for habit: fghjk
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter ( 9158): │ #1   NotificationService.scheduleHabitAlarms (package:habitv8/services/notification_service.dart:2024:15)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 🐛 Alarm enabled: true
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter ( 9158): │ #1   NotificationService.scheduleHabitAlarms (package:habitv8/services/notification_service.dart:2025:15)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 🐛 Alarm sound: Bright Morning
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter ( 9158): │ #1   NotificationService.scheduleHabitAlarms (package:habitv8/services/notification_service.dart:2026:15)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 🐛 Snooze delay: 10 minutes (fixed default)
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter ( 9158): │ #1   NotificationService.scheduleHabitAlarms (package:habitv8/services/notification_service.dart:2053:17)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 🐛 Scheduling alarm for 13:39
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   HybridAlarmService.cancelHabitAlarms (package:habitv8/services/hybrid_alarm_service.dart:444:15)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡 🔄 Cancelling all alarms for habit:
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   HybridAlarmService.cancelHabitAlarms (package:habitv8/services/hybrid_alarm_service.dart:470:15)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡 ✅ Cancelled alarms for habit
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter ( 9158): │ #1   NotificationService.scheduleHabitAlarms (package:habitv8/services/notification_service.dart:2061:17)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 🐛 Cancelled existing alarms for habit ID: 1757709441364
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter ( 9158): │ #1   NotificationService.scheduleHabitAlarms (package:habitv8/services/notification_service.dart:2064:17)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 🐛 Habit frequency: daily
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter ( 9158): │ #1   NotificationService.scheduleHabitAlarms (package:habitv8/services/notification_service.dart:2068:21)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 🐛 Scheduling daily alarms
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   HybridAlarmService.scheduleExactAlarm (package:habitv8/services/hybrid_alarm_service.dart:74:15)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡 🔄 Scheduling exact alarm:
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   HybridAlarmService.scheduleExactAlarm (package:habitv8/services/hybrid_alarm_service.dart:75:15)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡   - Alarm ID: 96
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   HybridAlarmService.scheduleExactAlarm (package:habitv8/services/hybrid_alarm_service.dart:76:15)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡   - Habit: fghjk
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   HybridAlarmService.scheduleExactAlarm (package:habitv8/services/hybrid_alarm_service.dart:77:15)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡   - Scheduled time: 2025-09-12 13:39:00.000
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   HybridAlarmService.scheduleExactAlarm (package:habitv8/services/hybrid_alarm_service.dart:78:15)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡   - Raw sound input: "Bright Morning"
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   HybridAlarmService.scheduleExactAlarm (package:habitv8/services/hybrid_alarm_service.dart:79:15)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡   - Volume: 80% with 1-second fade-in (testing fix)
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.warning (package:habitv8/services/logging_service.dart:24:13)
I/flutter ( 9158): │ #1   HybridAlarmService._getAlarmSoundPath (package:habitv8/services/hybrid_alarm_service.dart:596:19)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ ! Unknown alarm sound "Bright Morning" → default
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   HybridAlarmService.scheduleExactAlarm (package:habitv8/services/hybrid_alarm_service.dart:83:15)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡   - Resolved sound path: "assets/sounds/digital_beep.mp3"
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   HybridAlarmService._preflightCheckAssetAudio (package:habitv8/services/hybrid_alarm_service.dart:609:17)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡 🔍 Preflight: loading asset via rootBundle: assets/sounds/digital_beep.mp3
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   HybridAlarmService._preflightCheckAssetAudio (package:habitv8/services/hybrid_alarm_service.dart:611:17)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡 🔍 Preflight: asset bytes length = 161
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   HybridAlarmService.scheduleExactAlarm (package:habitv8/services/hybrid_alarm_service.dart:102:19)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡   - Sound name mapped to asset: Bright Morning -> assets/sounds/digital_beep.mp3
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   HybridAlarmService.scheduleExactAlarm (package:habitv8/services/hybrid_alarm_service.dart:107:17)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡   - Creating AlarmSettings with path: assets/sounds/digital_beep.mp3
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   HybridAlarmService.scheduleExactAlarm (package:habitv8/services/hybrid_alarm_service.dart:128:17)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡   - AlarmSettings created successfully
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
D/AlarmApiImpl( 9158): Warning notification is already turned off.
D/AlarmApiImpl( 9158): Alarm stopped notification for 96 was processed successfully by Flutter.
D/AlarmApiImpl( 9158): Warning notification turned on.
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   HybridAlarmService.scheduleExactAlarm (package:habitv8/services/hybrid_alarm_service.dart:130:17)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡   - Alarm.set() called successfully
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   HybridAlarmService.scheduleExactAlarm (package:habitv8/services/hybrid_alarm_service.dart:132:17)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡 ✅ Exact alarm scheduled successfully
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   NotificationService._scheduleDailyHabitAlarmsNew (package:habitv8/services/notification_service.dart:3479:15)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡 ✅ Scheduled daily alarms for fghjk
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter ( 9158): │ #1   NotificationService.scheduleHabitAlarms (package:habitv8/services/notification_service.dart:2102:17)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 🐛 Successfully scheduled alarms for habit: fghjk
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   NotificationService.scheduleHabitAlarms (package:habitv8/services/notification_service.dart:2103:17)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡 Successfully scheduled alarms for habit: fghjk
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   _CreateHabitScreenState._saveHabit (package:habitv8/ui/screens/create_habit_screen.dart:1841:21)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡 Notifications/alarms scheduled successfully for habit: fghjk
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   _CreateHabitScreenState._saveHabit (package:habitv8/ui/screens/create_habit_screen.dart:1865:19)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡 Habit created: fghjk
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter ( 9158): │ #1   _CreateHabitScreenState._buildFrequencySection (package:habitv8/ui/screens/create_habit_screen.dart:408:15)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 🐛 Building frequency section, current frequency: HabitFrequency.daily
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
D/WindowOnBackDispatcher( 9158): setTopOnBackInvokedCallback (unwrapped): android.app.Activity$$ExternalSyntheticLambda0@9bf33e8
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   NotificationService.processPendingActionsManually (package:habitv8/services/notification_service.dart:1228:15)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡 🔄 Manually processing pending actions
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   NotificationService.processPendingActionsManually (package:habitv8/services/notification_service.dart:1232:17)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡 ✅ Using callback to process pending actions
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter ( 9158): │ #1   NotificationService.processPendingActions (package:habitv8/services/notification_service.dart:796:17)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 🐛 🔍 All SharedPreferences keys: [last_midnight_reset, onboarding_completed, hybrid_alarm_data__96, __alarm_id__96]
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter ( 9158): │ #1   NotificationService.processPendingActions (package:habitv8/services/notification_service.dart:803:17)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 🐛 🔍 Method 1 (getStringList): null
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter ( 9158): │ #1   NotificationService.processPendingActions (package:habitv8/services/notification_service.dart:804:17)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 🐛 🔍 Method 2 (get): null
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter ( 9158): │ #1   NotificationService.processPendingActions (package:habitv8/services/notification_service.dart:808:17)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 🐛 🔍 Found 0 pending actions in SharedPreferences
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter ( 9158): │ #1   NotificationService.processPendingActions (package:habitv8/services/notification_service.dart:815:19)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 🐛 No pending notification actions to process in SharedPreferences
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter ( 9158): │ #1   NotificationService._loadActionsFromFile (package:habitv8/services/notification_service.dart:888:17)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 🐛 🔍 File: Checking for actions at path: /data/user/0/com.habittracker.habitv8.debug/app_flutter/pending_notification_actions.json
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter ( 9158): │ #1   NotificationService._loadActionsFromFile (package:habitv8/services/notification_service.dart:891:19)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 🐛 🔍 File: File does not exist
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter ( 9158): │ #1   NotificationService.processPendingActions (package:habitv8/services/notification_service.dart:841:19)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 🐛 No pending actions found in any storage method
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   AppLifecycleService._processPendingActionsWithRetry.<anonymous closure> (package:habitv8/services/app_lifecycle_service.dart:142:19)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡 ✅ Pending actions processed successfully on attempt 1
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:42:15)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡 🔍 Checking notification callback registration...
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:43:15)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡 📦 Container available: true
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:44:15)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡 🔗 Callback currently set: true
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:55:17)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡 ✅ Notification action callback is properly registered
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
D/ImeBackDispatcher( 9158): Clear (mImeCallbacks.size=0)
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   AppLifecycleService.didChangeAppLifecycleState (package:habitv8/services/app_lifecycle_service.dart:60:15)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡 📱 App lifecycle state changed to: AppLifecycleState.inactive
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   AppLifecycleService.didChangeAppLifecycleState (package:habitv8/services/app_lifecycle_service.dart:78:19)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡 ⏹️ App inactive
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
D/VRI[MainActivity]( 9158): visibilityChanged oldVisibility=true newVisibility=false
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   AppLifecycleService.didChangeAppLifecycleState (package:habitv8/services/app_lifecycle_service.dart:60:15)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡 📱 App lifecycle state changed to: AppLifecycleState.hidden
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   AppLifecycleService.didChangeAppLifecycleState (package:habitv8/services/app_lifecycle_service.dart:81:19)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡 👁️ App hidden
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   AppLifecycleService.didChangeAppLifecycleState (package:habitv8/services/app_lifecycle_service.dart:60:15)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡 📱 App lifecycle state changed to: AppLifecycleState.paused
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   AppLifecycleService.didChangeAppLifecycleState (package:habitv8/services/app_lifecycle_service.dart:70:19)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡 ⏸️ App paused - performing background cleanup...
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter ( 9158): │ #1   AppLifecycleService._performBackgroundCleanup (package:habitv8/services/app_lifecycle_service.dart:164:17)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 🐛 🧹 Performing background cleanup...
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter ( 9158): │ #1   AppLifecycleService._performBackgroundCleanup (package:habitv8/services/app_lifecycle_service.dart:169:17)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 🐛 ✅ Background cleanup completed
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
D/ImeBackDispatcher( 9158): Clear (mImeCallbacks.size=0)
D/ImeBackDispatcher( 9158): switch root view (mImeCallbacks.size=0)
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:42:15)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡 🔍 Checking notification callback registration...
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:43:15)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡 📦 Container available: true
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:44:15)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡 🔗 Callback currently set: true
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter ( 9158): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter ( 9158): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:55:17)
I/flutter ( 9158): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter ( 9158): │ 💡 ✅ Notification action callback is properly registered
I/flutter ( 9158): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
D/AudioSystem( 9158): onNewServiceWithAdapter: media.audio_flinger service obtained 0xb4000075889efe80
D/AudioSystem( 9158): getService: checking for service media.audio_flinger: 0xb400007568a16430
E/MediaPlayerNative( 9158): error (1, -2147483648)
W/System.err( 9158): java.io.IOException: Prepare failed.: status=0x1
W/System.err( 9158):    at android.media.MediaPlayer._prepare(Native Method)
W/System.err( 9158):    at android.media.MediaPlayer.prepare(MediaPlayer.java:1339)
W/System.err( 9158):    at com.gdelataillade.alarm.services.AudioService.playAudio-51bEbmg(AudioService.kt:71)
W/System.err( 9158):    at com.gdelataillade.alarm.alarm.AlarmService.onStartCommand(AlarmService.kt:161)
W/System.err( 9158):    at android.app.ActivityThread.handleServiceArgs(ActivityThread.java:5511)
W/System.err( 9158):    at android.app.ActivityThread.-$$Nest$mhandleServiceArgs(Unknown Source:0)
W/System.err( 9158):    at android.app.ActivityThread$H.handleMessage(ActivityThread.java:2654)
W/System.err( 9158):    at android.os.Handler.dispatchMessage(Handler.java:110)
W/System.err( 9158):    at android.os.Looper.dispatchMessage(Looper.java:315)
W/System.err( 9158):    at android.os.Looper.loopOnce(Looper.java:251)
W/System.err( 9158):    at android.os.Looper.loop(Looper.java:349)
W/System.err( 9158):    at android.app.ActivityThread.main(ActivityThread.java:9041)
W/System.err( 9158):    at java.lang.reflect.Method.invoke(Native Method)
W/System.err( 9158):    at com.android.internal.os.RuntimeInit$MethodAndArgsCaller.run(RuntimeInit.java:593)
W/System.err( 9158):    at com.android.internal.os.ZygoteInit.main(ZygoteInit.java:929)
E/AudioService( 9158): Error playing audio: java.io.IOException: Prepare failed.: status=0x1
D/AlarmService( 9158): Turning off the warning notification.
D/AlarmService( 9158): Alarm rang notification for 96 was processed successfully by Flutter.
D/ViewRootImpl( 9158): Skipping stats log for color mode
E/TransactionExecutor( 9158): Failed to execute the transaction: tId:-622861283 ClientTransaction{
E/TransactionExecutor( 9158): tId:-622861283   transactionItems=[
E/TransactionExecutor( 9158): tId:-622861283     NewIntentItem{mActivityToken=android.os.BinderProxy@f470454,intents=[Intent { act=android.intent.action.MAIN cat=[android.intent.category.LAUNCHER] flg=0x10000000 xflg=0x4 pkg=com.habittracker.habitv8.debug cmp=com.habittracker.habitv8.debug/com.habittracker.habitv8.MainActivity }],resume=false}
E/TransactionExecutor( 9158): tId:-622861283     Target activity: com.habittracker.habitv8.MainActivity
E/TransactionExecutor( 9158): tId:-622861283     TopResumedActivityChangeItem{mActivityToken=android.os.BinderProxy@f470454,onTop=true}
E/TransactionExecutor( 9158): tId:-622861283     Target activity: com.habittracker.habitv8.MainActivity
E/TransactionExecutor( 9158): tId:-622861283     ResumeActivityItem{mActivityToken=android.os.BinderProxy@f470454,procState=12,isForward=true,shouldSendCompatFakeFocus=false}
E/TransactionExecutor( 9158): tId:-622861283     Target activity: com.habittracker.habitv8.MainActivity
E/TransactionExecutor( 9158): tId:-622861283     TopResumedActivityChangeItem{mActivityToken=android.os.BinderProxy@f470454,onTop=false}
E/TransactionExecutor( 9158): tId:-622861283     Target activity: com.habittracker.habitv8.MainActivity
E/TransactionExecutor( 9158): tId:-622861283     PauseActivityItem{mActivityToken=android.os.BinderProxy@f470454,finished=false,userLeaving=true,dontReport=false,autoEnteringPip=false}
E/TransactionExecutor( 9158): tId:-622861283     Target activity: com.habittracker.habitv8.MainActivity
E/TransactionExecutor( 9158): tId:-622861283   ]
E/TransactionExecutor( 9158): tId:-622861283 }
D/AndroidRuntime( 9158): Shutting down VM
E/AndroidRuntime( 9158): FATAL EXCEPTION: main
E/AndroidRuntime( 9158): Process: com.habittracker.habitv8.debug, PID: 9158
E/AndroidRuntime( 9158): android.database.StaleDataException: Attempted to access a cursor after it has been closed.
E/AndroidRuntime( 9158):        at android.database.BulkCursorToCursorAdaptor.throwIfCursorIsClosed(BulkCursorToCursorAdaptor.java:63)
E/AndroidRuntime( 9158):        at android.database.BulkCursorToCursorAdaptor.requery(BulkCursorToCursorAdaptor.java:132)
E/AndroidRuntime( 9158):        at android.database.CursorWrapper.requery(CursorWrapper.java:233)
E/AndroidRuntime( 9158):        at android.app.Activity.performRestart(Activity.java:9354)
E/AndroidRuntime( 9158):        at android.app.ActivityThread.performRestartActivity(ActivityThread.java:6151)
E/AndroidRuntime( 9158):        at android.app.servertransaction.TransactionExecutor.performLifecycleSequence(TransactionExecutor.java:239)
E/AndroidRuntime( 9158):        at android.app.servertransaction.TransactionExecutor.cycleToPath(TransactionExecutor.java:194)
E/AndroidRuntime( 9158):        at android.app.servertransaction.TransactionExecutor.executeLifecycleItem(TransactionExecutor.java:166)
E/AndroidRuntime( 9158):        at android.app.servertransaction.TransactionExecutor.executeTransactionItems(TransactionExecutor.java:101)
E/AndroidRuntime( 9158):        at android.app.servertransaction.TransactionExecutor.execute(TransactionExecutor.java:80)
E/AndroidRuntime( 9158):        at android.app.ActivityThread$H.handleMessage(ActivityThread.java:2830)
E/AndroidRuntime( 9158):        at android.os.Handler.dispatchMessage(Handler.java:110)
E/AndroidRuntime( 9158):        at android.os.Looper.dispatchMessage(Looper.java:315)
E/AndroidRuntime( 9158):        at android.os.Looper.loopOnce(Looper.java:251)
E/AndroidRuntime( 9158):        at android.os.Looper.loop(Looper.java:349)
E/AndroidRuntime( 9158):        at android.app.ActivityThread.main(ActivityThread.java:9041)
E/AndroidRuntime( 9158):        at java.lang.reflect.Method.invoke(Native Method)
E/AndroidRuntime( 9158):        at com.android.internal.os.RuntimeInit$MethodAndArgsCaller.run(RuntimeInit.java:593)
E/AndroidRuntime( 9158):        at com.android.internal.os.ZygoteInit.main(ZygoteInit.java:929)
I/Process ( 9158): Sending signal. PID: 9158 SIG: 9
Lost connection to device.