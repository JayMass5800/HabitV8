The background refresh for habit completions or the UI up date isn't working, I hit complete on a habit and it is not upddating the widgets or home screen to show completion, i'm not seeing much in the logs for it but here they are










I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (18211): │ #1   NotificationStorage.loadAllActions (package:habitv8/services/notifications/notification_storage.dart:261:17)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 🐛 🔍 Method 2 (get): null
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (18211): │ #1   NotificationStorage.loadAllActions (package:habitv8/services/notifications/notification_storage.dart:265:17)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 🐛 🔍 Found 0 pending actions in SharedPreferences
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (18211): │ #1   NotificationStorage.loadAllActions (package:habitv8/services/notifications/notification_storage.dart:272:19)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 🐛 No pending notification actions to process in SharedPreferences
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/Choreographer(18211): Skipped 46 frames!  The application may be doing too much work on its main thread.
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (18211): │ #1   NotificationStorage.loadActionsFromFile (package:habitv8/services/notifications/notification_storage.dart:339:17)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 🐛 🔍 File: Checking for actions at path: /data/user/0/com.habittracker.habitv8.debug/app_flutter/pending_notification_actions.json
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (18211): │ #1   SubscriptionService._checkAndStartTrial (package:habitv8/services/subscription_service.dart:100:17)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 💡 🎉 Trial period started for new user at: 2025-10-05 11:00:50.678251
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (18211): │ #1   SubscriptionService._checkAndStartTrial (package:habitv8/services/subscription_service.dart:101:17)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 💡 🎉 Trial will expire after 30 days on: 2025-11-04 10:00:50.678251
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (18211): │ #1   NotificationStorage.loadActionsFromFile (package:habitv8/services/notifications/notification_storage.dart:342:19)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 🐛 🔍 File: File does not exist
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (18211): │ #1   NotificationStorage.loadAllActions (package:habitv8/services/notifications/notification_storage.dart:297:19)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 🐛 No pending actions found in any storage method
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (18211): │ #1   NotificationActionHandler.processPendingActions (package:habitv8/services/notifications/notification_action_handler.dart:223:15)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 💡 Found 0 actions in storage
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (18211): │ #1   NotificationActionHandler.processPendingActions (package:habitv8/services/notifications/notification_action_handler.dart:283:17)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 💡 📭 No pending actions to process
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (18211): │ #1   NotificationActionHandler.processPendingActions (package:habitv8/services/notifications/notification_action_handler.dart:288:15)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 💡 ✅ Initial pending actions processing complete
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
V/Configuration(18211): Updating configuration, locales updated from [en_US] to [en]
D/ImeBackDispatcher(18211): switch root view (mImeCallbacks.size=0)
D/InsetsController(18211): hide(ime())
I/ImeTracker(18211): com.habittracker.habitv8.debug:9ba1d7a7: onCancelled at PHASE_CLIENT_ALREADY_HIDDEN
V/Configuration(18211): Updating configuration, locales updated from [en] to [en_US]
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (18211): │ #1   SubscriptionService.initialize (package:habitv8/services/subscription_service.dart:49:17)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 💡 SubscriptionService initialized successfully
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
D/WindowOnBackDispatcher(18211): setTopOnBackInvokedCallback (unwrapped): androidx.activity.OnBackPressedDispatcher$Api34Impl$createOnBackAnimationCallback$1@c84648e
D/WindowOnBackDispatcher(18211): setTopOnBackInvokedCallback (unwrapped): android.app.Activity$$ExternalSyntheticLambda0@8e6bc39
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (18211): │ #1   PurchaseStreamService.initialize (package:habitv8/services/purchase_stream_service.dart:27:17)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 💡 🛒 Initializing PurchaseStreamService...
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): Old widget preferences cleaned up
I/flutter (18211): Periodic widget updates started (every 15 minutes)
I/WidgetUpdateWorker(18211): ✅ Periodic widget updates scheduled (every 15 minutes)
I/WidgetUpdateWorker(18211): ✅ Fallback widget updates scheduled (every hour)
I/MainActivity(18211): Periodic widget updates scheduled via WidgetUpdateWorker
I/flutter (18211): Android WorkManager widget updates scheduled
I/flutter (18211): Widget integration initialized successfully
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (18211): │ #1   _initializeWidgetService (package:habitv8/main.dart:230:15)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 💡 ✅ Widget integration service initialized successfully
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (18211): │ #1   PurchaseStreamService.initialize (package:habitv8/services/purchase_stream_service.dart:50:17)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 💡 ✅ PurchaseStreamService initialized successfully
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (18211): │ #1   _checkForExistingPurchasesQuietly (package:habitv8/main.dart:191:15)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 💡 🔍 Checking for existing purchases (device loss recovery)...
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
D/WM-SystemJobScheduler(18211): Scheduling work ID 1de2c9b0-5c27-406b-b6ba-e761b74798c8Job ID 0
W/JobInfo (18211): Requested important-while-foreground flag for job1 is ignored and takes no effect
D/WM-SystemJobScheduler(18211): Scheduling work ID 40358056-cf02-48b5-a672-4a88bf0e30b9Job ID 1
D/WM-GreedyScheduler(18211): Starting work for 40358056-cf02-48b5-a672-4a88bf0e30b9
D/WM-Processor(18211): Processor: processing WorkGenerationalId(workSpecId=40358056-cf02-48b5-a672-4a88bf0e30b9, generation=0)
D/WM-PackageManagerHelper(18211): androidx.work.impl.background.systemalarm.RescheduleReceiver enabled
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (18211): │ #1   _checkForExistingPurchasesQuietly (package:habitv8/main.dart:206:15)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 💡 ✅ Purchase restoration check completed
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (18211): │ #1   _initializeSubscriptionService (package:habitv8/main.dart:180:15)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 💡 ✅ Subscription service initialized successfully
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
D/WM-WorkerWrapper(18211): Starting work for com.habittracker.habitv8.WidgetUpdateWorker
I/WidgetUpdateWorker(18211): Starting widget update work
D/WM-SystemJobService(18211): onStartJob for WorkGenerationalId(workSpecId=40358056-cf02-48b5-a672-4a88bf0e30b9, generation=0)
D/WM-Processor(18211): Work WorkGenerationalId(workSpecId=40358056-cf02-48b5-a672-4a88bf0e30b9, generation=0) is already enqueued for processing
D/WidgetUpdateWorker(18211): Widget data loaded: 2 characters
D/WidgetUpdateWorker(18211): Skipping habits update - no new data to write (would be empty array)
D/WidgetUpdateWorker(18211): Theme settings copied: mode=null, color=ffffffff
D/WidgetUpdateWorker(18211): Widget data updated from Flutter preferences
I/WidgetUpdateWorker(18211): ✅ Widget update work completed successfully
I/WM-WorkerWrapper(18211): Worker result SUCCESS for Work [ id=40358056-cf02-48b5-a672-4a88bf0e30b9, tags={ com.habittracker.habitv8.WidgetUpdateWorker,widget_fallback_updates } ]
D/WM-Processor(18211): Processor 40358056-cf02-48b5-a672-4a88bf0e30b9 executed; reschedule = false
D/WM-SystemJobService(18211): 40358056-cf02-48b5-a672-4a88bf0e30b9 executed on JobScheduler
D/WM-GreedyScheduler(18211): Cancelling work ID 40358056-cf02-48b5-a672-4a88bf0e30b9
D/WM-SystemJobScheduler(18211): Scheduling work ID 40358056-cf02-48b5-a672-4a88bf0e30b9Job ID 1
I/flutter (18211): Filtering 0 habits for date 2025-10-05:
I/flutter (18211): Result: 0 habits for today
I/flutter (18211): Widget data preparation: Found 0 total habits, 0 for today
I/flutter (18211): 🎨 Getting app theme: ThemeMode.system
I/flutter (18211): 🎨 App is in SYSTEM mode, device brightness: Brightness.dark → dark
I/flutter (18211): 🎨 Final theme mode to send to widgets: dark
I/flutter (18211): 🎨 Using app primary color: 4280391411
I/flutter (18211): 🎯 Widget data prepared: 0 habits in list, JSON length: 2
I/flutter (18211): 🎯 First 200 chars of habits JSON: []
I/flutter (18211): 🎯 Theme data: dark, primary: 4280391411
I/flutter (18211): Saved widget theme data: dark, color: 4280391411
I/flutter (18211): Updating widget HabitTimelineWidgetProvider with data keys: [habits, nextHabit, selectedDate, themeMode, primaryColor, lastUpdate]
I/flutter (18211): ✅ Saved habits: length=2, preview=[]
I/flutter (18211): ✅ Saved nextHabit: null
I/flutter (18211): ✅ Saved selectedDate: 2025-10-05
I/flutter (18211): ✅ Saved themeMode: dark
I/flutter (18211): ✅ Saved primaryColor: 4280391411
I/flutter (18211): ✅ Saved lastUpdate: 1759687252854
I/flutter (18211): Widget HabitTimelineWidgetProvider update completed
I/flutter (18211): Updating widget HabitCompactWidgetProvider with data keys: [habits, nextHabit, selectedDate, themeMode, primaryColor, lastUpdate]
I/flutter (18211): ✅ Saved habits: length=2, preview=[]
I/flutter (18211): ✅ Saved nextHabit: null
I/flutter (18211): ✅ Saved selectedDate: 2025-10-05
I/flutter (18211): ✅ Saved themeMode: dark
I/flutter (18211): ✅ Saved primaryColor: 4280391411
I/flutter (18211): ✅ Saved lastUpdate: 1759687252854
I/flutter (18211): Widget HabitCompactWidgetProvider update completed
I/flutter (18211): ✅ All widgets updated successfully (debounced)
D/WindowOnBackDispatcher(18211): setTopOnBackInvokedCallback (unwrapped): androidx.activity.OnBackPressedDispatcher$Api34Impl$createOnBackAnimationCallback$1@c84648e
D/WindowOnBackDispatcher(18211): setTopOnBackInvokedCallback (unwrapped): android.app.Activity$$ExternalSyntheticLambda0@8e6bc39
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (18211): │ #1   MidnightHabitResetService.initialize (package:habitv8/services/midnight_habit_reset_service.dart:23:17)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 💡 🌙 Initializing Midnight Habit Reset Service
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (18211): │ #1   MidnightHabitResetService._startMidnightTimer (package:habitv8/services/midnight_habit_reset_service.dart:48:15)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 💡 ⏰ Next midnight reset in: 12h 59m
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (18211): │ #1   MidnightHabitResetService._startMidnightTimer (package:habitv8/services/midnight_habit_reset_service.dart:61:15)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 💡 🌙 Midnight reset timer started
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (18211): │ #1   MidnightHabitResetService._checkMissedReset (package:habitv8/services/midnight_habit_reset_service.dart:88:19)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 💡 🆕 First time running, performing initial reset
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (18211): │ #1   MidnightHabitResetService._performMidnightReset (package:habitv8/services/midnight_habit_reset_service.dart:100:17)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 💡 🌙 Performing midnight habit reset at 2025-10-05T11:00:54.393458
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (18211): │ #1   MidnightHabitResetService._performMidnightReset (package:habitv8/services/midnight_habit_reset_service.dart:109:17)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 💡 🔄 Processing 0 active habits for reset
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (18211): │ #1   MidnightHabitResetService._performMidnightReset (package:habitv8/services/midnight_habit_reset_service.dart:130:19)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 💡 🔄 Updating widgets with fresh data for new day...
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (18211): │ #1   MidnightHabitResetService._performMidnightReset (package:habitv8/services/midnight_habit_reset_service.dart:132:19)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 💡 ✅ Widgets updated successfully
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): 🧪 FORCE UPDATE: Starting immediate widget update...
I/flutter (18211): Filtering 0 habits for date 2025-10-05:
I/flutter (18211): Result: 0 habits for today
I/flutter (18211): Widget data preparation: Found 0 total habits, 0 for today
I/flutter (18211): 🎨 Getting app theme: ThemeMode.system
I/flutter (18211): 🎨 App is in SYSTEM mode, device brightness: Brightness.dark → dark
I/flutter (18211): 🎨 Final theme mode to send to widgets: dark
I/flutter (18211): 🎨 Using app primary color: 4280391411
I/flutter (18211): 🎯 Widget data prepared: 0 habits in list, JSON length: 2
I/flutter (18211): 🎯 First 200 chars of habits JSON: []
I/flutter (18211): 🎯 Theme data: dark, primary: 4280391411
I/MainActivity(18211): Widget force refresh triggered for both compact and timeline widgets
I/flutter (18211): 🧪 FORCE UPDATE: Successfully triggered widget refresh via method channel
I/flutter (18211): 🧪 FORCE UPDATE: Completed successfully
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (18211): │ #1   MidnightHabitResetService._performMidnightReset (package:habitv8/services/midnight_habit_reset_service.dart:137:21)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 💡 ✅ Android WorkManager widget update triggered
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): Saved widget theme data: dark, color: 4280391411
I/flutter (18211): Updating widget HabitTimelineWidgetProvider with data keys: [habits, nextHabit, selectedDate, themeMode, primaryColor, lastUpdate]
W/JobInfo (18211): Requested important-while-foreground flag for job2 is ignored and takes no effect
D/WM-SystemJobScheduler(18211): Scheduling work ID db4867d8-08e1-4bf5-bee2-8be0e278fb40Job ID 2
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (18211): │ #1   MidnightHabitResetService._performMidnightReset (package:habitv8/services/midnight_habit_reset_service.dart:161:17)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 💡 ✅ Midnight reset completed: 0 reset, 0 errors
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (18211): │ #1   MidnightHabitResetService.initialize (package:habitv8/services/midnight_habit_reset_service.dart:32:17)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 💡 ✅ Midnight Habit Reset Service initialized successfully
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ✅ Saved habits: length=2, preview=[]
I/flutter (18211): ✅ Saved nextHabit: null
D/WM-GreedyScheduler(18211): Starting work for db4867d8-08e1-4bf5-bee2-8be0e278fb40
I/flutter (18211): ✅ Saved selectedDate: 2025-10-05
D/WM-SystemJobService(18211): onStartJob for WorkGenerationalId(workSpecId=db4867d8-08e1-4bf5-bee2-8be0e278fb40, generation=0)
I/flutter (18211): ✅ Saved themeMode: dark
D/WM-Processor(18211): Processor: processing WorkGenerationalId(workSpecId=db4867d8-08e1-4bf5-bee2-8be0e278fb40, generation=0)
I/flutter (18211): ✅ Saved primaryColor: 4280391411
D/WM-Processor(18211): Work WorkGenerationalId(workSpecId=db4867d8-08e1-4bf5-bee2-8be0e278fb40, generation=0) is already enqueued for processing
I/flutter (18211): ✅ Saved lastUpdate: 1759687254704
D/WM-WorkerWrapper(18211): Starting work for com.habittracker.habitv8.WidgetUpdateWorker
I/WidgetUpdateWorker(18211): Starting widget update work
D/WidgetUpdateWorker(18211): Widget data loaded: 2 characters
D/WidgetUpdateWorker(18211): Skipping habits update - no new data to write (would be empty array)
D/WidgetUpdateWorker(18211): Theme settings copied: mode=null, color=ffffffff
D/WidgetUpdateWorker(18211): Widget data updated from Flutter preferences
I/WidgetUpdateWorker(18211): ✅ Widget update work completed successfully
I/WM-WorkerWrapper(18211): Worker result SUCCESS for Work [ id=db4867d8-08e1-4bf5-bee2-8be0e278fb40, tags={ com.habittracker.habitv8.WidgetUpdateWorker } ]
D/WM-Processor(18211): Processor db4867d8-08e1-4bf5-bee2-8be0e278fb40 executed; reschedule = false
D/WM-SystemJobService(18211): db4867d8-08e1-4bf5-bee2-8be0e278fb40 executed on JobScheduler
D/WM-GreedyScheduler(18211): Cancelling work ID db4867d8-08e1-4bf5-bee2-8be0e278fb40
D/ProfileInstaller(18211): Installing profile for com.habittracker.habitv8.debug
I/flutter (18211): Widget HabitTimelineWidgetProvider update completed
I/flutter (18211): Updating widget HabitCompactWidgetProvider with data keys: [habits, nextHabit, selectedDate, themeMode, primaryColor, lastUpdate]
I/flutter (18211): ✅ Saved habits: length=2, preview=[]
I/flutter (18211): ✅ Saved nextHabit: null
I/flutter (18211): ✅ Saved selectedDate: 2025-10-05
I/flutter (18211): ✅ Saved themeMode: dark
I/flutter (18211): ✅ Saved primaryColor: 4280391411
I/flutter (18211): ✅ Saved lastUpdate: 1759687254704
D/WindowOnBackDispatcher(18211): setTopOnBackInvokedCallback (unwrapped): androidx.activity.OnBackPressedDispatcher$Api34Impl$createOnBackAnimationCallback$1@c84648e
I/flutter (18211): Widget HabitCompactWidgetProvider update completed
I/flutter (18211): ✅ All widgets updated successfully (debounced)
I/ImeTracker(18211): com.habittracker.habitv8.debug:19ce18e9: onRequestShow at ORIGIN_CLIENT reason SHOW_SOFT_INPUT fromUser false
I/HWUI    (18211): Using FreeType backend (prop=Auto)
D/InsetsController(18211): show(ime())
D/ImeBackDispatcher(18211): Undo preliminary clear (mImeCallbacks.size=0)
D/InsetsController(18211): Setting requestedVisibleTypes to -1 (was -9)
D/InputConnectionAdaptor(18211): The input method toggled cursor monitoring on
D/ImeBackDispatcher(18211): Register received callback id=213350146 priority=0
D/WindowOnBackDispatcher(18211): setTopOnBackInvokedCallback (unwrapped): android.view.ImeBackAnimationController@5599757
W/InteractionJankMonitor(18211): Initializing without READ_DEVICE_CONFIG permission. enabled=false, interval=1, missedFrameThreshold=3, frameTimeThreshold=64, package=com.habittracker.habitv8.debug
I/ImeTracker(18211): com.habittracker.habitv8.debug:19ce18e9: onShown
I/ImeTracker(18211): com.habittracker.habitv8.debug:ef68e236: onRequestHide at ORIGIN_CLIENT reason HIDE_SOFT_INPUT fromUser false
D/InsetsController(18211): hide(ime())
D/ImeBackDispatcher(18211): Preliminary clear (mImeCallbacks.size=1)
D/WindowOnBackDispatcher(18211): setTopOnBackInvokedCallback (unwrapped): androidx.activity.OnBackPressedDispatcher$Api34Impl$createOnBackAnimationCallback$1@c84648e
D/InsetsController(18211): Setting requestedVisibleTypes to -9 (was -1)
D/CompatChangeReporter(18211): Compat change id reported: 395521150; UID 10597; state: ENABLED
D/InputConnectionAdaptor(18211): The input method toggled cursor monitoring off
I/ImeTracker(18211): system_server:b68b74e5: onCancelled at PHASE_CLIENT_ON_CONTROLS_CHANGED
D/ImeBackDispatcher(18211): Unregister received callback id=213350146
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (18211): │ #1   _CreateHabitScreenV2State._generateRRuleFromSimpleMode (package:habitv8/ui/screens/create_habit_screen_v2.dart:1702:17)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 💡 ✅ Generated RRule from simple mode: FREQ=DAILY
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (18211): │ #1   NotificationScheduler.cancelHabitNotificationsByHabitId (package:habitv8/services/notifications/notification_scheduler.dart:674:15)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 🐛 🚫 Starting notification cancellation for habit: 1759687276264
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (18211): │ #1   NotificationScheduler.scheduleHabitNotifications (package:habitv8/services/notifications/notification_scheduler.dart:207:15)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 🐛 Starting notification scheduling for habit: fghjk (isNewHabit: true)
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (18211): │ #1   NotificationScheduler.scheduleHabitNotifications (package:habitv8/services/notifications/notification_scheduler.dart:210:15)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 🐛 Notifications enabled: true
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (18211): │ #1   NotificationCore.ensureNotificationPermissions (package:habitv8/services/notifications/notification_core.dart:280:17)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 💡 Checking notification permission...
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (18211): │ #1   NotificationCore.ensureNotificationPermissions (package:habitv8/services/notifications/notification_core.dart:285:19)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 💡 Requesting notification permission for scheduling...
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (18211): │ #1   PermissionService.requestNotificationPermissionWithContext (package:habitv8/services/permission_service.dart:98:17)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 💡 Requesting notification permission with user context...
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (18211): │ #1   PermissionService.requestNotificationPermission (package:habitv8/services/permission_service.dart:73:17)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 💡 Requesting notification permission when needed...
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/MainActivity(18211): onPause: Preserving alarm sound if playing
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (18211): │ #1   AppLifecycleService.didChangeAppLifecycleState (package:habitv8/services/app_lifecycle_service.dart:68:15)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 💡 📱 App lifecycle state changed to: AppLifecycleState.inactive
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (18211): │ #1   AppLifecycleService.didChangeAppLifecycleState (package:habitv8/services/app_lifecycle_service.dart:87:19)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 💡 ⏹️ App inactive
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
D/ImeBackDispatcher(18211): Clear (mImeCallbacks.size=0)
D/ImeBackDispatcher(18211): switch root view (mImeCallbacks.size=0)
I/MainActivity(18211): onResume: Preserving alarm sound state
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (18211): │ #1   PermissionService.requestNotificationPermission (package:habitv8/services/permission_service.dart:79:17)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 💡 Notification permission request result: true
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (18211): │ #1   PermissionService.requestNotificationPermissionWithContext (package:habitv8/services/permission_service.dart:104:19)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 💡 Notification permission granted successfully
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (18211): │ #1   PermissionService.hasExactAlarmPermission (package:habitv8/services/permission_service.dart:143:17)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 💡 Checking exact alarm permission status...
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (18211): │ #1   PermissionService.hasExactAlarmPermission (package:habitv8/services/permission_service.dart:147:17)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 💡 Exact alarm permission check result: true (simplified)
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (18211): │ #1   NotificationCore.ensureNotificationPermissions (package:habitv8/services/notifications/notification_core.dart:318:19)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 💡 Exact alarm permission already available
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (18211): │ #1   NotificationScheduler.scheduleHabitNotifications (package:habitv8/services/notifications/notification_scheduler.dart:267:17)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 🐛 Scheduling for 11:2
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (18211): │ #1   NotificationScheduler.scheduleHabitNotifications (package:habitv8/services/notifications/notification_scheduler.dart:283:19)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 🐛 Skipping notification cancellation - new habit with no existing notifications
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (18211): │ #1   NotificationScheduler.scheduleHabitNotifications (package:habitv8/services/notifications/notification_scheduler.dart:290:19)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 🐛 Scheduling RRule-based notifications
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
D/ImeBackDispatcher(18211): switch root view (mImeCallbacks.size=0)
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (18211): │ #1   AppLifecycleService.didChangeAppLifecycleState (package:habitv8/services/app_lifecycle_service.dart:68:15)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 💡 📱 App lifecycle state changed to: AppLifecycleState.resumed
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (18211): │ #1   AppLifecycleService.didChangeAppLifecycleState (package:habitv8/services/app_lifecycle_service.dart:83:19)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 💡 ▶️ App resumed
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (18211): │ #1   AppLifecycleService._handleAppResumed (package:habitv8/services/app_lifecycle_service.dart:130:17)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 💡 🔄 Handling app resume - re-registering notification callbacks...
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (18211): │ #1   AppLifecycleService._ensureDatabaseConnection (package:habitv8/services/app_lifecycle_service.dart:174:17)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 🐛 🔗 Ensuring database connection is valid...
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (18211): │ #1   AppLifecycleService._handleAppResumed (package:habitv8/services/app_lifecycle_service.dart:141:21)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 💡 🔄 Invalidated habitsNotifierProvider to force refresh from database
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (18211): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:43:15)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 💡 🔍 Checking notification callback registration...
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (18211): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:44:15)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 💡 📦 Container available: true
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (18211): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:45:15)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 💡 🔗 Callback currently set: true
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (18211): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:56:17)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 💡 ✅ Notification action callback is properly registered
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (18211): │ #1   AppLifecycleService._processPendingActionsWithRetry (package:habitv8/services/app_lifecycle_service.dart:227:15)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 💡 🔄 Scheduling pending action processing attempt 1/5 with 1000ms delay
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (18211): │ #1   AppLifecycleService._refreshWidgetsOnResume (package:habitv8/services/app_lifecycle_service.dart:254:17)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 🐛 🔄 Force refreshing widgets on app resume...
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (18211): │ #1   AppLifecycleService._checkMissedResetOnResume (package:habitv8/services/app_lifecycle_service.dart:276:17)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 🐛 🔍 Checking for missed midnight resets on app resume...
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (18211): │ #1   AppLifecycleService._handleAppResumed (package:habitv8/services/app_lifecycle_service.dart:164:17)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 💡 ✅ App resume handling completed
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
D/InsetsController(18211): hide(ime())
I/ImeTracker(18211): com.habittracker.habitv8.debug:eb2fa013: onCancelled at PHASE_CLIENT_ALREADY_HIDDEN
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (18211): │ #1   AppLifecycleService._ensureDatabaseConnection.<anonymous closure> (package:habitv8/services/app_lifecycle_service.dart:185:23)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 🐛 ✅ Database connection is healthy
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (18211): │ #1   NotificationScheduler._scheduleRRuleHabitNotifications (package:habitv8/services/notifications/notification_scheduler.dart:833:17)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 💡 📅 Scheduled 85 RRule notifications for fghjk
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (18211): │ #1   NotificationScheduler.scheduleHabitNotifications (package:habitv8/services/notifications/notification_scheduler.dart:327:17)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 💡 ✅ Successfully scheduled notifications for habit: fghjk
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (18211): │ #1   NotificationAlarmScheduler.scheduleHabitAlarms (package:habitv8/services/notifications/notification_alarm_scheduler.dart:30:15)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 🐛 Starting alarm scheduling for habit: fghjk
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (18211): │ #1   NotificationAlarmScheduler.scheduleHabitAlarms (package:habitv8/services/notifications/notification_alarm_scheduler.dart:31:15)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 🐛 Alarm enabled: false
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (18211): │ #1   NotificationAlarmScheduler.scheduleHabitAlarms (package:habitv8/services/notifications/notification_alarm_scheduler.dart:32:15)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 🐛 Alarm sound: null
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (18211): │ #1   NotificationAlarmScheduler.scheduleHabitAlarms (package:habitv8/services/notifications/notification_alarm_scheduler.dart:33:15)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 🐛 Alarm sound URI: null
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (18211): │ #1   NotificationAlarmScheduler.scheduleHabitAlarms (package:habitv8/services/notifications/notification_alarm_scheduler.dart:37:17)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 🐛 Skipping alarms - disabled
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (18211): │ #1   NotificationAlarmScheduler.scheduleHabitAlarms (package:habitv8/services/notifications/notification_alarm_scheduler.dart:38:17)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 💡 Alarms disabled for habit: fghjk
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (18211): │ #1   HabitService.addHabit (package:habitv8/data/database.dart:639:21)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 💡 Scheduled notifications/alarms for new habit "fghjk"
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (18211): │ #1   HabitService.addHabit (package:habitv8/data/database.dart:653:21)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 🐛 Calendar sync disabled, skipping sync for new habit "fghjk"
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (18211): │ #1   _CreateHabitScreenV2State._saveHabit (package:habitv8/ui/screens/create_habit_screen_v2.dart:1486:19)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 💡 Habit created: fghjk
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/WidgetUpdateWorker(18211): ✅ Immediate widget update triggered
I/MainActivity(18211): Immediate widget update triggered via WidgetUpdateWorker
I/flutter (18211): Android widget immediate update triggered
I/r.habitv8.debug(18211): Background young concurrent mark compact GC freed 12MB AllocSpace bytes, 89(10MB) LOS objects, 73% free, 7665KB/28MB, paused 69us,15.546ms total 56.454ms
W/JobInfo (18211): Requested important-while-foreground flag for job3 is ignored and takes no effect
D/WM-SystemJobScheduler(18211): Scheduling work ID 6dfd513a-a9f6-44be-9dc1-01f4e38e30e9Job ID 3
D/WindowOnBackDispatcher(18211): setTopOnBackInvokedCallback (unwrapped): android.app.Activity$$ExternalSyntheticLambda0@8e6bc39
D/WM-GreedyScheduler(18211): Starting work for 6dfd513a-a9f6-44be-9dc1-01f4e38e30e9
D/WM-Processor(18211): Processor: processing WorkGenerationalId(workSpecId=6dfd513a-a9f6-44be-9dc1-01f4e38e30e9, generation=0)
D/WM-SystemJobService(18211): onStartJob for WorkGenerationalId(workSpecId=6dfd513a-a9f6-44be-9dc1-01f4e38e30e9, generation=0)
D/WM-WorkerWrapper(18211): Starting work for com.habittracker.habitv8.WidgetUpdateWorker
D/WM-Processor(18211): Work WorkGenerationalId(workSpecId=6dfd513a-a9f6-44be-9dc1-01f4e38e30e9, generation=0) is already enqueued for processing
I/WidgetUpdateWorker(18211): Starting widget update work
D/WidgetUpdateWorker(18211): Widget data loaded: 2 characters
D/WidgetUpdateWorker(18211): Skipping habits update - no new data to write (would be empty array)
D/WidgetUpdateWorker(18211): Theme settings copied: mode=null, color=ffffffff
D/WidgetUpdateWorker(18211): Widget data updated from Flutter preferences
I/WidgetUpdateWorker(18211): ✅ Widget update work completed successfully
I/WM-WorkerWrapper(18211): Worker result SUCCESS for Work [ id=6dfd513a-a9f6-44be-9dc1-01f4e38e30e9, tags={ com.habittracker.habitv8.WidgetUpdateWorker,immediate_widget_update } ]
D/WM-Processor(18211): Processor 6dfd513a-a9f6-44be-9dc1-01f4e38e30e9 executed; reschedule = false
D/WM-SystemJobService(18211): 6dfd513a-a9f6-44be-9dc1-01f4e38e30e9 executed on JobScheduler
D/WM-GreedyScheduler(18211): Cancelling work ID 6dfd513a-a9f6-44be-9dc1-01f4e38e30e9
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (18211): │ #1   NotificationActionHandler.processPendingActionsManually (package:habitv8/services/notifications/notification_action_handler.dart:779:15)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 💡 🔄 Manually processing pending actions
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (18211): │ #1   NotificationActionHandler.processPendingActionsManually (package:habitv8/services/notifications/notification_action_handler.dart:783:17)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 💡 ✅ Using callback to process pending actions
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (18211): │ #1   NotificationActionHandler.processPendingActions (package:habitv8/services/notifications/notification_action_handler.dart:213:17)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 💡 ⏭️  Skipping - initial pending actions already processed
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (18211): │ #1   AppLifecycleService._processPendingActionsWithRetry.<anonymous closure> (package:habitv8/services/app_lifecycle_service.dart:233:19)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 💡 ✅ Pending actions processed successfully on attempt 1
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): Filtering 1 habits for date 2025-10-05:
I/flutter (18211):   - fghjk: HabitFrequency.daily -> INCLUDED
I/flutter (18211): Result: 1 habits for today
I/flutter (18211): Widget data preparation: Found 1 total habits, 1 for today
I/flutter (18211): 🎨 Getting app theme: ThemeMode.system
I/flutter (18211): 🎨 App is in SYSTEM mode, device brightness: Brightness.dark → dark
I/flutter (18211): 🎨 Final theme mode to send to widgets: dark
I/flutter (18211): 🎨 Using app primary color: 4280391411
I/flutter (18211): 🎯 Widget data prepared: 1 habits in list, JSON length: 175
I/flutter (18211): 🎯 First 200 chars of habits JSON: [{"id":"1759687276264","name":"fghjk","category":"Health","colorValue":4294940672,"isCompleted":false,"status":"Due","timeDisplay":"11:02","frequency":"HabitFrequency.daily"}]
I/flutter (18211): 🎯 Theme data: dark, primary: 4280391411
I/flutter (18211): Saved widget theme data: dark, color: 4280391411
I/flutter (18211): Updating widget HabitTimelineWidgetProvider with data keys: [habits, nextHabit, selectedDate, themeMode, primaryColor, lastUpdate]
I/flutter (18211): ✅ Saved habits: length=175, preview=[{"id":"1759687276264","name":"fghjk","category":"Health","colorValue":4294940672,"isCompleted":false,"status":"Due","timeDisplay":"11:02","frequency"...
I/flutter (18211): ✅ Saved nextHabit: {"id":"1759687276264","name":"fghjk","category":"Health","colorValue":4294940672,"isCompleted":false...
I/flutter (18211): ✅ Saved selectedDate: 2025-10-05
I/flutter (18211): ✅ Saved themeMode: dark
I/flutter (18211): ✅ Saved primaryColor: 4280391411
I/flutter (18211): ✅ Saved lastUpdate: 1759687278790
I/flutter (18211): Widget HabitTimelineWidgetProvider update completed
I/flutter (18211): Updating widget HabitCompactWidgetProvider with data keys: [habits, nextHabit, selectedDate, themeMode, primaryColor, lastUpdate]
I/flutter (18211): ✅ Saved habits: length=175, preview=[{"id":"1759687276264","name":"fghjk","category":"Health","colorValue":4294940672,"isCompleted":false,"status":"Due","timeDisplay":"11:02","frequency"...
I/flutter (18211): ✅ Saved nextHabit: {"id":"1759687276264","name":"fghjk","category":"Health","colorValue":4294940672,"isCompleted":false...
I/flutter (18211): ✅ Saved selectedDate: 2025-10-05
I/flutter (18211): ✅ Saved themeMode: dark
I/flutter (18211): ✅ Saved primaryColor: 4280391411
I/flutter (18211): ✅ Saved lastUpdate: 1759687278790
I/flutter (18211): 🧪 FORCE UPDATE: Starting immediate widget update...
I/flutter (18211): ⏱️ Widget update already pending, will schedule another
I/flutter (18211): Widget HabitCompactWidgetProvider update completed
I/flutter (18211): ✅ All widgets updated successfully (debounced)
I/MainActivity(18211): Widget force refresh triggered for both compact and timeline widgets
I/flutter (18211): 🧪 FORCE UPDATE: Successfully triggered widget refresh via method channel
I/flutter (18211): 🧪 FORCE UPDATE: Completed successfully
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (18211): │ #1   AppLifecycleService._refreshWidgetsOnResume.<anonymous closure> (package:habitv8/services/app_lifecycle_service.dart:261:21)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 🐛 ✅ Widgets force refreshed successfully on app resume
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
W/JobInfo (18211): Requested important-while-foreground flag for job4 is ignored and takes no effect
D/WM-SystemJobScheduler(18211): Scheduling work ID 41f4d521-d7af-4800-b79c-1fa2f9076ff3Job ID 4
D/WM-GreedyScheduler(18211): Starting work for 41f4d521-d7af-4800-b79c-1fa2f9076ff3
D/WM-Processor(18211): Processor: processing WorkGenerationalId(workSpecId=41f4d521-d7af-4800-b79c-1fa2f9076ff3, generation=0)
D/WM-SystemJobService(18211): onStartJob for WorkGenerationalId(workSpecId=41f4d521-d7af-4800-b79c-1fa2f9076ff3, generation=0)
D/WM-WorkerWrapper(18211): Starting work for com.habittracker.habitv8.WidgetUpdateWorker
D/WM-Processor(18211): Work WorkGenerationalId(workSpecId=41f4d521-d7af-4800-b79c-1fa2f9076ff3, generation=0) is already enqueued for processing
I/WidgetUpdateWorker(18211): Starting widget update work
D/WidgetUpdateWorker(18211): Widget data loaded: 175 characters
D/WidgetUpdateWorker(18211): Updating habits data: 175 characters
D/WidgetUpdateWorker(18211): Processed 1 total habits, 1 for today
D/WidgetUpdateWorker(18211): Theme settings copied: mode=null, color=ffffffff
D/WidgetUpdateWorker(18211): Widget data updated from Flutter preferences
I/WidgetUpdateWorker(18211): ✅ Widget update work completed successfully
I/WM-WorkerWrapper(18211): Worker result SUCCESS for Work [ id=41f4d521-d7af-4800-b79c-1fa2f9076ff3, tags={ com.habittracker.habitv8.WidgetUpdateWorker } ]
D/WM-Processor(18211): Processor 41f4d521-d7af-4800-b79c-1fa2f9076ff3 executed; reschedule = false
D/WM-SystemJobService(18211): 41f4d521-d7af-4800-b79c-1fa2f9076ff3 executed on JobScheduler
D/WM-GreedyScheduler(18211): Cancelling work ID 41f4d521-d7af-4800-b79c-1fa2f9076ff3
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (18211): │ #1   MidnightHabitResetService.checkForMissedResetOnAppActive (package:habitv8/services/midnight_habit_reset_service.dart:270:17)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 🐛 🔍 Checking for missed resets on app activation
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (18211): │ #1   MidnightHabitResetService._checkMissedReset (package:habitv8/services/midnight_habit_reset_service.dart:84:21)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 🐛 ✅ No missed reset - last reset was today
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (18211): │ #1   AppLifecycleService._checkMissedResetOnResume.<anonymous closure> (package:habitv8/services/app_lifecycle_service.dart:283:21)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 🐛 ✅ Missed reset check completed on app resume
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): Filtering 1 habits for date 2025-10-05:
I/flutter (18211):   - fghjk: HabitFrequency.daily -> INCLUDED
I/flutter (18211): Result: 1 habits for today
I/flutter (18211): Widget data preparation: Found 1 total habits, 1 for today
I/flutter (18211): 🎨 Getting app theme: ThemeMode.system
I/flutter (18211): 🎨 App is in SYSTEM mode, device brightness: Brightness.dark → dark
I/flutter (18211): 🎨 Final theme mode to send to widgets: dark
I/flutter (18211): 🎨 Using app primary color: 4280391411
I/flutter (18211): 🎯 Widget data prepared: 1 habits in list, JSON length: 175
I/flutter (18211): 🎯 First 200 chars of habits JSON: [{"id":"1759687276264","name":"fghjk","category":"Health","colorValue":4294940672,"isCompleted":false,"status":"Due","timeDisplay":"11:02","frequency":"HabitFrequency.daily"}]
I/flutter (18211): 🎯 Theme data: dark, primary: 4280391411
I/flutter (18211): Saved widget theme data: dark, color: 4280391411
I/flutter (18211): Updating widget HabitTimelineWidgetProvider with data keys: [habits, nextHabit, selectedDate, themeMode, primaryColor, lastUpdate]
I/flutter (18211): ✅ Saved habits: length=175, preview=[{"id":"1759687276264","name":"fghjk","category":"Health","colorValue":4294940672,"isCompleted":false,"status":"Due","timeDisplay":"11:02","frequency"...
I/flutter (18211): ✅ Saved nextHabit: {"id":"1759687276264","name":"fghjk","category":"Health","colorValue":4294940672,"isCompleted":false...
I/flutter (18211): ✅ Saved selectedDate: 2025-10-05
I/flutter (18211): ✅ Saved themeMode: dark
I/flutter (18211): ✅ Saved primaryColor: 4280391411
I/flutter (18211): ✅ Saved lastUpdate: 1759687279672
I/flutter (18211): Widget HabitTimelineWidgetProvider update completed
I/flutter (18211): Updating widget HabitCompactWidgetProvider with data keys: [habits, nextHabit, selectedDate, themeMode, primaryColor, lastUpdate]
I/flutter (18211): ✅ Saved habits: length=175, preview=[{"id":"1759687276264","name":"fghjk","category":"Health","colorValue":4294940672,"isCompleted":false,"status":"Due","timeDisplay":"11:02","frequency"...
I/flutter (18211): ✅ Saved nextHabit: {"id":"1759687276264","name":"fghjk","category":"Health","colorValue":4294940672,"isCompleted":false...
I/flutter (18211): ✅ Saved selectedDate: 2025-10-05
I/flutter (18211): ✅ Saved themeMode: dark
I/flutter (18211): ✅ Saved primaryColor: 4280391411
I/flutter (18211): ✅ Saved lastUpdate: 1759687279672
I/flutter (18211): Widget HabitCompactWidgetProvider update completed
I/flutter (18211): ✅ All widgets updated successfully (debounced)
I/TRuntime.CctTransportBackend(18211): Making request to: https://firebaselogging.googleapis.com/v0cc/log/batch?format=json_proto3
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (18211): │ #1   AppLifecycleService.didChangeAppLifecycleState (package:habitv8/services/app_lifecycle_service.dart:68:15)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 💡 📱 App lifecycle state changed to: AppLifecycleState.inactive
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (18211): │ #1   AppLifecycleService.didChangeAppLifecycleState (package:habitv8/services/app_lifecycle_service.dart:87:19)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 💡 ⏹️ App inactive
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/TRuntime.CctTransportBackend(18211): Status Code: 200
I/MainActivity(18211): onPause: Preserving alarm sound if playing
D/VRI[MainActivity](18211): visibilityChanged oldVisibility=true newVisibility=false
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (18211): │ #1   AppLifecycleService.didChangeAppLifecycleState (package:habitv8/services/app_lifecycle_service.dart:68:15)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 💡 📱 App lifecycle state changed to: AppLifecycleState.hidden
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (18211): │ #1   AppLifecycleService.didChangeAppLifecycleState (package:habitv8/services/app_lifecycle_service.dart:90:19)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 💡 👁️ App hidden
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (18211): │ #1   AppLifecycleService.didChangeAppLifecycleState (package:habitv8/services/app_lifecycle_service.dart:68:15)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 💡 📱 App lifecycle state changed to: AppLifecycleState.paused
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (18211): │ #1   AppLifecycleService.didChangeAppLifecycleState (package:habitv8/services/app_lifecycle_service.dart:78:19)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 💡 ⏸️ App paused - performing background cleanup...
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (18211): │ #1   AppLifecycleService._performBackgroundCleanup (package:habitv8/services/app_lifecycle_service.dart:299:17)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 🐛 🧹 Performing background cleanup...
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (18211): │ #1   AppLifecycleService._performBackgroundCleanup (package:habitv8/services/app_lifecycle_service.dart:304:17)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 🐛 ✅ Background cleanup completed
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
D/ImeBackDispatcher(18211): Clear (mImeCallbacks.size=0)
D/ImeBackDispatcher(18211): switch root view (mImeCallbacks.size=0)
D/HabitTimelineWidget(18211): Widget enabled - scheduling periodic updates
I/WidgetUpdateWorker(18211): ✅ Periodic widget updates scheduled (every 15 minutes)
I/WidgetUpdateWorker(18211): ✅ Fallback widget updates scheduled (every hour)
D/HabitTimelineWidget(18211): onUpdate called with 1 widget IDs
D/HabitTimelineWidget(18211): ListView setup completed for widget 21 (service will read fresh theme data)
D/HabitTimelineWidget(18211): Detected theme mode: 'dark'
D/HabitTimelineWidget(18211): Using theme - mode: 'dark', primary: ff2196f3
D/HabitTimelineWidget(18211): Semi-transparent theme applied - isDark: true, bg: 800f0f0f
D/HabitTimelineWidget(18211): Found habits in widgetData
D/HabitTimelineWidget(18211): Widget update completed for ID: 21
D/WM-GreedyScheduler(18211): Cancelling work ID 1de2c9b0-5c27-406b-b6ba-e761b74798c8
D/HabitTimelineService(18211): onGetViewFactory called - creating new factory
D/HabitTimelineService(18211): RemoteViewsFactory onCreate called
D/HabitTimelineService(18211): 🎨 Loading fresh theme data from preferences:
D/HabitTimelineService(18211):   - HomeWidget['themeMode']: dark
D/HabitTimelineService(18211):   - Flutter['flutter.theme_mode']: null
D/HabitTimelineService(18211): 🎨 Final detected theme mode: 'dark'
D/HabitTimelineService(18211): Theme applied - isDark: true, textColor: ffffffff, primary: ff2196f3
D/WM-SystemJobScheduler(18211): Scheduling work ID 1de2c9b0-5c27-406b-b6ba-e761b74798c8Job ID 5
D/HabitTimelineService(18211): ✅ Found habits data at key 'habits', length: 175, preview: [{"id":"1759687276264","name":"fghjk","category":"Health","colorValue":4294940672,"isCompleted":fals
D/HabitTimelineService(18211): Attempting to load habits from key: habits, Raw length: 175
D/HabitTimelineService(18211): Loaded 1 habits for timeline widget
D/HabitTimelineService(18211): First habit keys: [id, name, category, colorValue, isCompleted, status, timeDisplay, frequency]
D/WM-GreedyScheduler(18211): Cancelling work ID 40358056-cf02-48b5-a672-4a88bf0e30b9
D/HabitTimelineService(18211): getCount returning: 1 habits
D/HabitTimelineService(18211): getViewAt position: 0
D/HabitTimelineService(18211): Created view for habit: fghjk at position 0
D/WM-SystemJobScheduler(18211): Scheduling work ID 40358056-cf02-48b5-a672-4a88bf0e30b9Job ID 6
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (18211): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:43:15)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 💡 🔍 Checking notification callback registration...
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (18211): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:44:15)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 💡 📦 Container available: true
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (18211): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:45:15)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 💡 🔗 Callback currently set: true
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (18211): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:56:17)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 💡 ✅ Notification action callback is properly registered
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
D/WM-DelayedWorkTracker(18211): Scheduling work 1de2c9b0-5c27-406b-b6ba-e761b74798c8
D/WM-GreedyScheduler(18211): Starting work for 1de2c9b0-5c27-406b-b6ba-e761b74798c8
D/WM-Processor(18211): Processor: processing WorkGenerationalId(workSpecId=1de2c9b0-5c27-406b-b6ba-e761b74798c8, generation=1)
D/WM-WorkerWrapper(18211): Starting work for com.habittracker.habitv8.WidgetUpdateWorker
I/WidgetUpdateWorker(18211): Starting widget update work
D/WidgetUpdateWorker(18211): Widget data loaded: 175 characters
D/WidgetUpdateWorker(18211): Updating habits data: 175 characters
D/WidgetUpdateWorker(18211): Processed 1 total habits, 1 for today
D/WidgetUpdateWorker(18211): Theme settings copied: mode=null, color=ffffffff
D/WidgetUpdateWorker(18211): Widget data updated from Flutter preferences
D/WidgetUpdateWorker(18211): Updated 1 timeline widgets
D/HabitTimelineWidget(18211): onUpdate called with 1 widget IDs
D/HabitTimelineWidget(18211): ListView setup completed for widget 21 (service will read fresh theme data)
D/HabitTimelineWidget(18211): Detected theme mode: 'dark'
D/HabitTimelineWidget(18211): Using theme - mode: 'dark', primary: ff2196f3
D/HabitTimelineWidget(18211): Semi-transparent theme applied - isDark: true, bg: 800f0f0f
D/HabitTimelineWidget(18211): Found habits in widgetData
D/HabitTimelineWidget(18211): Widget update completed for ID: 21
I/WidgetUpdateWorker(18211): ✅ Widget update work completed successfully
D/HabitTimelineService(18211): onDataSetChanged called - reloading habit data
D/HabitTimelineService(18211): 🎨 Loading fresh theme data from preferences:
I/WM-WorkerWrapper(18211): Worker result SUCCESS for Work [ id=1de2c9b0-5c27-406b-b6ba-e761b74798c8, tags={ com.habittracker.habitv8.WidgetUpdateWorker,widget_updates } ]
D/HabitTimelineService(18211):   - HomeWidget['themeMode']: dark
D/WM-Processor(18211): Processor 1de2c9b0-5c27-406b-b6ba-e761b74798c8 executed; reschedule = false
D/HabitTimelineService(18211):   - Flutter['flutter.theme_mode']: null
D/HabitTimelineService(18211): 🎨 Final detected theme mode: 'dark'
D/HabitTimelineService(18211): Theme applied - isDark: true, textColor: ffffffff, primary: ff2196f3
D/HabitTimelineService(18211): ✅ Found habits data at key 'habits', length: 175, preview: [{"id":"1759687276264","name":"fghjk","category":"Health","colorValue":4294940672,"isCompleted":fals
D/HabitTimelineService(18211): Attempting to load habits from key: habits, Raw length: 175
D/HabitTimelineService(18211): Loaded 1 habits for timeline widget
D/HabitTimelineService(18211): First habit keys: [id, name, category, colorValue, isCompleted, status, timeDisplay, frequency]
D/WM-GreedyScheduler(18211): Cancelling work ID 1de2c9b0-5c27-406b-b6ba-e761b74798c8
D/HabitTimelineService(18211): getCount returning: 1 habits
D/HabitTimelineService(18211): getViewAt position: 0
D/HabitTimelineService(18211): Created view for habit: fghjk at position 0
D/WM-SystemJobScheduler(18211): Scheduling work ID 1de2c9b0-5c27-406b-b6ba-e761b74798c8Job ID 7
D/HabitTimelineService(18211): getCount returning: 1 habits
D/HabitTimelineService(18211): getViewAt position: 0
D/HabitTimelineService(18211): Created view for habit: fghjk at position 0
D/HabitTimelineService(18211): ⚡ Using cached data (32ms old), skipping reload
D/HabitTimelineService(18211): getCount returning: 1 habits
D/HabitTimelineService(18211): getViewAt position: 0
D/HabitTimelineService(18211): Created view for habit: fghjk at position 0
I/flutter (18211): [IMPORTANT:flutter/shell/platform/android/android_context_vk_impeller.cc(62)] Using the Impeller rendering backend (Vulkan).
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (18211): │ #1   onBackgroundNotificationResponse (package:habitv8/services/notifications/notification_action_handler.dart:24:15)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 💡 🔔 BACKGROUND notification response received
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (18211): │ #1   onBackgroundNotificationResponse (package:habitv8/services/notifications/notification_action_handler.dart:25:15)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 💡 Background action ID: complete
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (18211): │ #1   onBackgroundNotificationResponse (package:habitv8/services/notifications/notification_action_handler.dart:26:15)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 💡 Background payload: {"habitId":"1759687276264","type":"habit_reminder"}
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (18211): │ #1   onBackgroundNotificationResponse (package:habitv8/services/notifications/notification_action_handler.dart:30:15)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 💡 ✅ Hive initialized in background handler
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (18211): │ #1   onBackgroundNotificationResponse (package:habitv8/services/notifications/notification_action_handler.dart:38:21)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 💡 Extracted habitId from payload: 1759687276264
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (18211): │ #1   onBackgroundNotificationResponse (package:habitv8/services/notifications/notification_action_handler.dart:42:23)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 💡 Processing background action: complete
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (18211): │ #1   NotificationActionHandler.completeHabitInBackground (package:habitv8/services/notifications/notification_action_handler.dart:180:17)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 💡 ⚙️ Completing habit in background: 1759687276264
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (18211): │ #1   AchievementsService.awardXP (package:habitv8/services/achievements_service.dart:782:17)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 💡 Awarded 10 XP for Getting Started. Total: 10
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (18211): │ #1   AchievementsService._unlockAchievement (package:habitv8/services/achievements_service.dart:904:19)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 💡 Achievement unlocked: Getting Started
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (18211): │ #1   AchievementsService.awardXP (package:habitv8/services/achievements_service.dart:782:17)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 💡 Awarded 75 XP for Perfect Week. Total: 85
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (18211): │ #1   AchievementsService._unlockAchievement (package:habitv8/services/achievements_service.dart:904:19)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 💡 Achievement unlocked: Perfect Week
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (18211): │ #1   AchievementsService.awardXP (package:habitv8/services/achievements_service.dart:782:17)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 💡 Awarded 300 XP for Flawless Month. Total: 385
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (18211): │ #1   AchievementsService._handleLevelUp (package:habitv8/services/achievements_service.dart:922:15)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 💡 Level up! 1 -> 2
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (18211): │ #1   AchievementsService._unlockAchievement (package:habitv8/services/achievements_service.dart:904:19)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 💡 Achievement unlocked: Flawless Month
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (18211): │ #1   HabitService._checkForAchievements (package:habitv8/data/database.dart:1384:19)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 💡 3 new achievement(s) unlocked
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (18211): │ #1   HabitService._checkForAchievements (package:habitv8/data/database.dart:1386:21)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 💡 Achievement unlocked: Getting Started
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (18211): │ #1   HabitService._checkForAchievements (package:habitv8/data/database.dart:1386:21)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 💡 Achievement unlocked: Perfect Week
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (18211): │ #1   HabitService._checkForAchievements (package:habitv8/data/database.dart:1386:21)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 💡 Achievement unlocked: Flawless Month
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (18211): │ #1   HabitService.markHabitComplete (package:habitv8/data/database.dart:1032:21)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 🐛 Calendar sync disabled, skipping completion sync for habit "fghjk"
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (18211): │ #1   NotificationActionHandler.completeHabitInBackground (package:habitv8/services/notifications/notification_action_handler.dart:195:17)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 💡 ✅ Habit completed in background: fghjk
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (18211): │ #1   NotificationActionHandler.completeHabitInBackground (package:habitv8/services/notifications/notification_action_handler.dart:200:19)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 💡 ✅ Widget updated after background completion
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (18211): │ #1   onBackgroundNotificationResponse (package:habitv8/services/notifications/notification_action_handler.dart:52:15)
I/flutter (18211): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18211): │ 💡 ✅ Background notification response processed
I/flutter (18211): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18211): Filtering 1 habits for date 2025-10-05:
I/flutter (18211):   - fghjk: HabitFrequency.daily -> INCLUDED
I/flutter (18211): Result: 1 habits for today
I/flutter (18211): Widget data preparation: Found 1 total habits, 1 for today
I/flutter (18211): 🎨 Getting app theme: ThemeMode.system
I/flutter (18211): 🎨 App is in SYSTEM mode, device brightness: Brightness.light → light
I/flutter (18211): 🎨 Final theme mode to send to widgets: light
I/flutter (18211): 🎨 Using app primary color: 4280391411
I/flutter (18211): 🎯 Widget data prepared: 1 habits in list, JSON length: 180
I/flutter (18211): 🎯 First 200 chars of habits JSON: [{"id":"1759687276264","name":"fghjk","category":"Health","colorValue":4294940672,"isCompleted":true,"status":"Completed","timeDisplay":"11:02","frequency":"HabitFrequency.daily"}]
I/flutter (18211): 🎯 Theme data: light, primary: 4280391411
I/flutter (18211): Saved widget theme data: light, color: 4280391411
I/flutter (18211): Updating widget HabitTimelineWidgetProvider with data keys: [habits, nextHabit, selectedDate, themeMode, primaryColor, lastUpdate]
I/flutter (18211): ✅ Saved habits: length=180, preview=[{"id":"1759687276264","name":"fghjk","category":"Health","colorValue":4294940672,"isCompleted":true,"status":"Completed","timeDisplay":"11:02","frequ...
I/flutter (18211): ✅ Saved nextHabit: null
I/flutter (18211): ✅ Saved selectedDate: 2025-10-05
I/flutter (18211): ✅ Saved themeMode: light
I/flutter (18211): ✅ Saved primaryColor: 4280391411
I/flutter (18211): ✅ Saved lastUpdate: 1759687332081
I/flutter (18211): Widget HabitTimelineWidgetProvider update completed
I/flutter (18211): Updating widget HabitCompactWidgetProvider with data keys: [habits, nextHabit, selectedDate, themeMode, primaryColor, lastUpdate]
I/flutter (18211): ✅ Saved habits: length=180, preview=[{"id":"1759687276264","name":"fghjk","category":"Health","colorValue":4294940672,"isCompleted":true,"status":"Completed","timeDisplay":"11:02","frequ...
I/flutter (18211): ✅ Saved nextHabit: null
I/flutter (18211): ✅ Saved selectedDate: 2025-10-05
I/flutter (18211): ✅ Saved themeMode: light
I/flutter (18211): ✅ Saved primaryColor: 4280391411
I/flutter (18211): ✅ Saved lastUpdate: 1759687332081
I/flutter (18211): Widget HabitCompactWidgetProvider update completed
I/flutter (18211): ✅ All widgets updated successfully (debounced)