i added a new habit to the app but it did not show up on the homescreen widget, when the notification came through presing complete did not update the habit, closing and opening the ap made the haomescreen widget update though but it still did not show completion. here are the logs leading upto the notification, my phone lost connection at that point.


https://docs.page/abausg/home_widget/setup/android has info on flutter widget set up



I/flutter (21923): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (21923): │ #1   AppLifecycleService.didChangeAppLifecycleState (package:habitv8/services/app_lifecycle_service.dart:87:19)
I/flutter (21923): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (21923): │ 💡 ⏹️ App inactive
I/flutter (21923): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (21923): │ #1   AppLifecycleService.didChangeAppLifecycleState (package:habitv8/services/app_lifecycle_service.dart:68:15)
I/flutter (21923): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (21923): │ 💡 📱 App lifecycle state changed to: AppLifecycleState.resumed
I/flutter (21923): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (21923): │ #1   AppLifecycleService.didChangeAppLifecycleState (package:habitv8/services/app_lifecycle_service.dart:83:19)
I/flutter (21923): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (21923): │ 💡 ▶️ App resumed
I/flutter (21923): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (21923): │ #1   AppLifecycleService._handleAppResumed (package:habitv8/services/app_lifecycle_service.dart:130:17)
I/flutter (21923): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (21923): │ 💡 🔄 Handling app resume - re-registering notification callbacks...
I/flutter (21923): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (21923): │ #1   AppLifecycleService._ensureDatabaseConnection (package:habitv8/services/app_lifecycle_service.dart:174:17)
I/flutter (21923): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (21923): │ 🐛 🔗 Ensuring database connection is valid...
I/flutter (21923): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (21923): │ #1   AppLifecycleService._handleAppResumed (package:habitv8/services/app_lifecycle_service.dart:141:21)
I/flutter (21923): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (21923): │ 💡 🔄 Invalidated habitsNotifierProvider to force refresh from database
I/flutter (21923): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (21923): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:43:15)
I/flutter (21923): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (21923): │ 💡 🔍 Checking notification callback registration...
I/flutter (21923): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (21923): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:44:15)
I/flutter (21923): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (21923): │ 💡 📦 Container available: true
I/flutter (21923): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (21923): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:45:15)
I/flutter (21923): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (21923): │ 💡 🔗 Callback currently set: true
I/flutter (21923): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (21923): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:56:17)
I/flutter (21923): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (21923): │ 💡 ✅ Notification action callback is properly registered
I/flutter (21923): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (21923): │ #1   AppLifecycleService._processPendingActionsWithRetry (package:habitv8/services/app_lifecycle_service.dart:227:15)
I/flutter (21923): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (21923): │ 💡 🔄 Scheduling pending action processing attempt 1/5 with 1000ms delay
I/flutter (21923): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (21923): │ #1   AppLifecycleService._refreshWidgetsOnResume (package:habitv8/services/app_lifecycle_service.dart:254:17)
I/flutter (21923): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (21923): │ 🐛 🔄 Force refreshing widgets on app resume...
I/flutter (21923): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (21923): │ #1   AppLifecycleService._checkMissedResetOnResume (package:habitv8/services/app_lifecycle_service.dart:276:17)
I/flutter (21923): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (21923): │ 🐛 🔍 Checking for missed midnight resets on app resume...
I/flutter (21923): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (21923): │ #1   AppLifecycleService._handleAppResumed (package:habitv8/services/app_lifecycle_service.dart:164:17)
I/flutter (21923): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (21923): │ 💡 ✅ App resume handling completed
I/flutter (21923): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
D/VRI[MainActivity](21923): visibilityChanged oldVisibility=false newVisibility=true
I/Choreographer(21923): Skipped 35 frames!  The application may be doing too much work on its main thread.
I/flutter (21923): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (21923): │ #1   AppLifecycleService._ensureDatabaseConnection.<anonymous closure> (package:habitv8/services/app_lifecycle_service.dart:185:23)
I/flutter (21923): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (21923): │ 🐛 ✅ Database connection is healthy
I/flutter (21923): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
D/ImeBackDispatcher(21923): switch root view (mImeCallbacks.size=0)
D/InsetsController(21923): hide(ime())
I/ImeTracker(21923): com.habittracker.habitv8.debug:2cfaf021: onCancelled at PHASE_CLIENT_ALREADY_HIDDEN
I/flutter (21923): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (21923): │ #1   NotificationActionHandler.processPendingActionsManually (package:habitv8/services/notifications/notification_action_handler.dart:787:15)
I/flutter (21923): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (21923): │ 💡 🔄 Manually processing pending actions
I/flutter (21923): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (21923): │ #1   NotificationActionHandler.processPendingActionsManually (package:habitv8/services/notifications/notification_action_handler.dart:791:17)
I/flutter (21923): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (21923): │ 💡 ✅ Using callback to process pending actions
I/flutter (21923): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (21923): │ #1   NotificationActionHandler.processPendingActions (package:habitv8/services/notifications/notification_action_handler.dart:221:17)
I/flutter (21923): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (21923): │ 💡 ⏭️  Skipping - initial pending actions already processed
I/flutter (21923): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (21923): │ #1   AppLifecycleService._processPendingActionsWithRetry.<anonymous closure> (package:habitv8/services/app_lifecycle_service.dart:233:19)
I/flutter (21923): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (21923): │ 💡 ✅ Pending actions processed successfully on attempt 1
I/flutter (21923): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): 🧪 FORCE UPDATE: Starting immediate widget update...
I/flutter (21923): Filtering 1 habits for date 2025-10-05:
I/flutter (21923):   - fghjk: HabitFrequency.daily -> INCLUDED
I/flutter (21923): Result: 1 habits for today
I/flutter (21923): Widget data preparation: Found 1 total habits, 1 for today
I/flutter (21923): 🎨 Getting app theme: ThemeMode.system
I/flutter (21923): 🎨 App is in SYSTEM mode, device brightness: Brightness.dark → dark
I/flutter (21923): 🎨 Final theme mode to send to widgets: dark
I/flutter (21923): 🎨 Using app primary color: 4280391411
I/flutter (21923): 🎯 Widget data prepared: 1 habits in list, JSON length: 180
I/flutter (21923): 🎯 First 200 chars of habits JSON: [{"id":"1759687276264","name":"fghjk","category":"Health","colorValue":4294940672,"isCompleted":true,"status":"Completed","timeDisplay":"11:02","frequency":"HabitFrequency.daily"}]
I/flutter (21923): 🎯 Theme data: dark, primary: 4280391411
I/MainActivity(21923): Widget force refresh triggered for both compact and timeline widgets
I/flutter (21923): 🧪 FORCE UPDATE: Successfully triggered widget refresh via method channel
I/flutter (21923): 🧪 FORCE UPDATE: Completed successfully
I/flutter (21923): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (21923): │ #1   AppLifecycleService._refreshWidgetsOnResume.<anonymous closure> (package:habitv8/services/app_lifecycle_service.dart:261:21)
I/flutter (21923): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (21923): │ 🐛 ✅ Widgets force refreshed successfully on app resume
I/flutter (21923): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): Saved widget theme data: dark, color: 4280391411
I/flutter (21923): Updating widget HabitTimelineWidgetProvider with data keys: [habits, nextHabit, selectedDate, themeMode, primaryColor, lastUpdate]
I/flutter (21923): ✅ Saved habits: length=180, preview=[{"id":"1759687276264","name":"fghjk","category":"Health","colorValue":4294940672,"isCompleted":true,"status":"Completed","timeDisplay":"11:02","frequ...
I/flutter (21923): ✅ Saved nextHabit: null
I/flutter (21923): ✅ Saved selectedDate: 2025-10-05
I/flutter (21923): ✅ Saved themeMode: dark
W/JobInfo (21923): Requested important-while-foreground flag for job18 is ignored and takes no effect
D/WM-SystemJobScheduler(21923): Scheduling work ID 286a4d69-da25-4ce6-a126-318fde78ad9cJob ID 18
I/flutter (21923): ✅ Saved primaryColor: 4280391411
I/flutter (21923): ✅ Saved lastUpdate: 1759689137887
D/WM-GreedyScheduler(21923): Starting work for 286a4d69-da25-4ce6-a126-318fde78ad9c
D/WM-SystemJobService(21923): onStartJob for WorkGenerationalId(workSpecId=286a4d69-da25-4ce6-a126-318fde78ad9c, generation=0)
D/WM-Processor(21923): Processor: processing WorkGenerationalId(workSpecId=286a4d69-da25-4ce6-a126-318fde78ad9c, generation=0)
D/WM-Processor(21923): Work WorkGenerationalId(workSpecId=286a4d69-da25-4ce6-a126-318fde78ad9c, generation=0) is already enqueued for processing
D/WM-WorkerWrapper(21923): Starting work for com.habittracker.habitv8.WidgetUpdateWorker
I/WidgetUpdateWorker(21923): Starting widget update work
D/WidgetUpdateWorker(21923): Widget data loaded: 180 characters
D/WidgetUpdateWorker(21923): Updating habits data: 180 characters
D/WidgetUpdateWorker(21923): Processed 1 total habits, 1 for today
D/WidgetUpdateWorker(21923): Theme settings copied: mode=null, color=ffffffff
D/WidgetUpdateWorker(21923): Widget data updated from Flutter preferences
D/WidgetUpdateWorker(21923): Updated 1 timeline widgets
D/HabitTimelineWidget(21923): onUpdate called with 1 widget IDs
D/HabitTimelineWidget(21923): ListView setup completed for widget 21 (service will read fresh theme data)
D/HabitTimelineWidget(21923): Detected theme mode: 'dark'
D/HabitTimelineWidget(21923): Using theme - mode: 'dark', primary: ff2196f3
D/HabitTimelineWidget(21923): Semi-transparent theme applied - isDark: true, bg: 800f0f0f
D/HabitTimelineWidget(21923): Found habits in widgetData
D/HabitTimelineWidget(21923): Widget update completed for ID: 21
I/WidgetUpdateWorker(21923): ✅ Widget update work completed successfully
D/HabitTimelineService(21923): onDataSetChanged called - reloading habit data
D/HabitTimelineService(21923): 🎨 Loading fresh theme data from preferences:
D/HabitTimelineService(21923):   - HomeWidget['themeMode']: dark
D/HabitTimelineService(21923):   - Flutter['flutter.theme_mode']: null
D/HabitTimelineService(21923): 🎨 Final detected theme mode: 'dark'
D/HabitTimelineService(21923): Theme applied - isDark: true, textColor: ffffffff, primary: ff2196f3
D/HabitTimelineService(21923): ✅ Found habits data at key 'habits', length: 180, preview: [{"id":"1759687276264","name":"fghjk","category":"Health","colorValue":4294940672,"isCompleted":true
D/HabitTimelineService(21923): Attempting to load habits from key: habits, Raw length: 180
I/WM-WorkerWrapper(21923): Worker result SUCCESS for Work [ id=286a4d69-da25-4ce6-a126-318fde78ad9c, tags={ com.habittracker.habitv8.WidgetUpdateWorker } ]
D/HabitTimelineService(21923): Loaded 1 habits for timeline widget
D/HabitTimelineService(21923): First habit keys: [id, name, category, colorValue, isCompleted, status, timeDisplay, frequency]
D/HabitTimelineService(21923): getCount returning: 1 habits
D/HabitTimelineService(21923): getViewAt position: 0
D/HabitTimelineService(21923): Created view for habit: fghjk at position 0
D/WM-Processor(21923): Processor 286a4d69-da25-4ce6-a126-318fde78ad9c executed; reschedule = false
D/WM-SystemJobService(21923): 286a4d69-da25-4ce6-a126-318fde78ad9c executed on JobScheduler
D/HabitTimelineService(21923): getCount returning: 1 habits
D/HabitTimelineService(21923): getViewAt position: 0
D/HabitTimelineService(21923): Created view for habit: fghjk at position 0
D/WM-GreedyScheduler(21923): Cancelling work ID 286a4d69-da25-4ce6-a126-318fde78ad9c
D/HabitTimelineService(21923): ⚡ Using cached data (12ms old), skipping reload
D/HabitTimelineService(21923): getCount returning: 1 habits
D/HabitTimelineService(21923): getViewAt position: 0
D/HabitTimelineService(21923): Created view for habit: fghjk at position 0
I/flutter (21923): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (21923): │ #1   MidnightHabitResetService.checkForMissedResetOnAppActive (package:habitv8/services/midnight_habit_reset_service.dart:270:17)
I/flutter (21923): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (21923): │ 🐛 🔍 Checking for missed resets on app activation
I/flutter (21923): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (21923): │ #1   MidnightHabitResetService._checkMissedReset (package:habitv8/services/midnight_habit_reset_service.dart:84:21)
I/flutter (21923): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (21923): │ 🐛 ✅ No missed reset - last reset was today
I/flutter (21923): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (21923): │ #1   AppLifecycleService._checkMissedResetOnResume.<anonymous closure> (package:habitv8/services/app_lifecycle_service.dart:283:21)
I/flutter (21923): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (21923): │ 🐛 ✅ Missed reset check completed on app resume
I/flutter (21923): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): Widget HabitTimelineWidgetProvider update completed
I/flutter (21923): Updating widget HabitCompactWidgetProvider with data keys: [habits, nextHabit, selectedDate, themeMode, primaryColor, lastUpdate]
I/flutter (21923): ✅ Saved habits: length=180, preview=[{"id":"1759687276264","name":"fghjk","category":"Health","colorValue":4294940672,"isCompleted":true,"status":"Completed","timeDisplay":"11:02","frequ...
I/flutter (21923): ✅ Saved nextHabit: null
I/flutter (21923): ✅ Saved selectedDate: 2025-10-05
I/flutter (21923): ✅ Saved themeMode: dark
I/flutter (21923): ✅ Saved primaryColor: 4280391411
I/flutter (21923): ✅ Saved lastUpdate: 1759689137887
I/Choreographer(21923): Skipped 33 frames!  The application may be doing too much work on its main thread.
D/WindowOnBackDispatcher(21923): setTopOnBackInvokedCallback (unwrapped): androidx.activity.OnBackPressedDispatcher$Api34Impl$createOnBackAnimationCallback$1@3775d15
I/flutter (21923): Widget HabitCompactWidgetProvider update completed
I/flutter (21923): ✅ All widgets updated successfully (debounced)
I/ImeTracker(21923): com.habittracker.habitv8.debug:df50f747: onRequestShow at ORIGIN_CLIENT reason SHOW_SOFT_INPUT fromUser false
I/HWUI    (21923): Using FreeType backend (prop=Auto)
D/InsetsController(21923): show(ime())
D/ImeBackDispatcher(21923): Undo preliminary clear (mImeCallbacks.size=0)
D/InsetsController(21923): Setting requestedVisibleTypes to -1 (was -9)
D/InputConnectionAdaptor(21923): The input method toggled cursor monitoring on
D/ImeBackDispatcher(21923): Register received callback id=213350146 priority=0
D/WindowOnBackDispatcher(21923): setTopOnBackInvokedCallback (unwrapped): android.view.ImeBackAnimationController@384f1d0
W/InteractionJankMonitor(21923): Initializing without READ_DEVICE_CONFIG permission. enabled=false, interval=1, missedFrameThreshold=3, frameTimeThreshold=64, package=com.habittracker.habitv8.debug
I/ImeTracker(21923): com.habittracker.habitv8.debug:df50f747: onShown
I/ImeTracker(21923): com.habittracker.habitv8.debug:5c77078c: onRequestHide at ORIGIN_CLIENT reason HIDE_SOFT_INPUT fromUser false
D/InsetsController(21923): hide(ime())
D/ImeBackDispatcher(21923): Preliminary clear (mImeCallbacks.size=1)
D/WindowOnBackDispatcher(21923): setTopOnBackInvokedCallback (unwrapped): androidx.activity.OnBackPressedDispatcher$Api34Impl$createOnBackAnimationCallback$1@3775d15
D/InsetsController(21923): Setting requestedVisibleTypes to -9 (was -1)
D/CompatChangeReporter(21923): Compat change id reported: 395521150; UID 10597; state: ENABLED
D/InputConnectionAdaptor(21923): The input method toggled cursor monitoring off
D/ImeBackDispatcher(21923): Unregister received callback id=213350146
I/ImeTracker(21923): system_server:cabcd984: onCancelled at PHASE_CLIENT_ON_CONTROLS_CHANGED
I/flutter (21923): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (21923): │ #1   _CreateHabitScreenV2State._generateRRuleFromSimpleMode (package:habitv8/ui/screens/create_habit_screen_v2.dart:1702:17)
I/flutter (21923): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (21923): │ 💡 ✅ Generated RRule from simple mode: FREQ=DAILY
I/flutter (21923): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (21923): │ #1   NotificationScheduler.cancelHabitNotificationsByHabitId (package:habitv8/services/notifications/notification_scheduler.dart:674:15)
I/flutter (21923): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (21923): │ 🐛 🚫 Starting notification cancellation for habit: 1759689150846
I/flutter (21923): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (21923): │ #1   NotificationScheduler.scheduleHabitNotifications (package:habitv8/services/notifications/notification_scheduler.dart:207:15)
I/flutter (21923): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (21923): │ 🐛 Starting notification scheduling for habit: fghjkgfh (isNewHabit: true)
I/flutter (21923): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (21923): │ #1   NotificationScheduler.scheduleHabitNotifications (package:habitv8/services/notifications/notification_scheduler.dart:210:15)
I/flutter (21923): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (21923): │ 🐛 Notifications enabled: true
I/flutter (21923): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (21923): │ #1   NotificationCore.ensureNotificationPermissions (package:habitv8/services/notifications/notification_core.dart:280:17)
I/flutter (21923): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (21923): │ 💡 Checking notification permission...
I/flutter (21923): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (21923): │ #1   NotificationCore.ensureNotificationPermissions (package:habitv8/services/notifications/notification_core.dart:296:19)
I/flutter (21923): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (21923): │ 💡 Notification permission already granted
I/flutter (21923): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (21923): │ #1   PermissionService.hasExactAlarmPermission (package:habitv8/services/permission_service.dart:143:17)
I/flutter (21923): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (21923): │ 💡 Checking exact alarm permission status...
I/flutter (21923): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (21923): │ #1   PermissionService.hasExactAlarmPermission (package:habitv8/services/permission_service.dart:147:17)
I/flutter (21923): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (21923): │ 💡 Exact alarm permission check result: true (simplified)
I/flutter (21923): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (21923): │ #1   NotificationCore.ensureNotificationPermissions (package:habitv8/services/notifications/notification_core.dart:318:19)
I/flutter (21923): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (21923): │ 💡 Exact alarm permission already available
I/flutter (21923): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (21923): │ #1   NotificationScheduler.scheduleHabitNotifications (package:habitv8/services/notifications/notification_scheduler.dart:267:17)
I/flutter (21923): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (21923): │ 🐛 Scheduling for 11:33
I/flutter (21923): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (21923): │ #1   NotificationScheduler.scheduleHabitNotifications (package:habitv8/services/notifications/notification_scheduler.dart:283:19)
I/flutter (21923): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (21923): │ 🐛 Skipping notification cancellation - new habit with no existing notifications
I/flutter (21923): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (21923): │ #1   NotificationScheduler.scheduleHabitNotifications (package:habitv8/services/notifications/notification_scheduler.dart:290:19)
I/flutter (21923): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (21923): │ 🐛 Scheduling RRule-based notifications
I/flutter (21923): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/r.habitv8.debug(21923): Background young concurrent mark compact GC freed 8464KB AllocSpace bytes, 37(6460KB) LOS objects, 0% free, 34MB/34MB, paused 96us,1.530ms total 137.259ms
I/flutter (21923): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (21923): │ #1   NotificationScheduler._scheduleRRuleHabitNotifications (package:habitv8/services/notifications/notification_scheduler.dart:833:17)
I/flutter (21923): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (21923): │ 💡 📅 Scheduled 85 RRule notifications for fghjkgfh
I/flutter (21923): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (21923): │ #1   NotificationScheduler.scheduleHabitNotifications (package:habitv8/services/notifications/notification_scheduler.dart:327:17)
I/flutter (21923): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (21923): │ 💡 ✅ Successfully scheduled notifications for habit: fghjkgfh
I/flutter (21923): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (21923): │ #1   NotificationAlarmScheduler.scheduleHabitAlarms (package:habitv8/services/notifications/notification_alarm_scheduler.dart:30:15)
I/flutter (21923): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (21923): │ 🐛 Starting alarm scheduling for habit: fghjkgfh
I/flutter (21923): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (21923): │ #1   NotificationAlarmScheduler.scheduleHabitAlarms (package:habitv8/services/notifications/notification_alarm_scheduler.dart:31:15)
I/flutter (21923): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (21923): │ 🐛 Alarm enabled: false
I/flutter (21923): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (21923): │ #1   NotificationAlarmScheduler.scheduleHabitAlarms (package:habitv8/services/notifications/notification_alarm_scheduler.dart:32:15)
I/flutter (21923): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (21923): │ 🐛 Alarm sound: null
I/flutter (21923): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (21923): │ #1   NotificationAlarmScheduler.scheduleHabitAlarms (package:habitv8/services/notifications/notification_alarm_scheduler.dart:33:15)
I/flutter (21923): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (21923): │ 🐛 Alarm sound URI: null
I/flutter (21923): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (21923): │ #1   NotificationAlarmScheduler.scheduleHabitAlarms (package:habitv8/services/notifications/notification_alarm_scheduler.dart:37:17)
I/flutter (21923): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (21923): │ 🐛 Skipping alarms - disabled
I/flutter (21923): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (21923): │ #1   NotificationAlarmScheduler.scheduleHabitAlarms (package:habitv8/services/notifications/notification_alarm_scheduler.dart:38:17)
I/flutter (21923): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (21923): │ 💡 Alarms disabled for habit: fghjkgfh
I/flutter (21923): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (21923): │ #1   HabitService.addHabit (package:habitv8/data/database.dart:639:21)
I/flutter (21923): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (21923): │ 💡 Scheduled notifications/alarms for new habit "fghjkgfh"
I/flutter (21923): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (21923): │ #1   HabitService.addHabit (package:habitv8/data/database.dart:653:21)
I/flutter (21923): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (21923): │ 🐛 Calendar sync disabled, skipping sync for new habit "fghjkgfh"
I/flutter (21923): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (21923): │ #1   _CreateHabitScreenV2State._saveHabit (package:habitv8/ui/screens/create_habit_screen_v2.dart:1486:19)
I/flutter (21923): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (21923): │ 💡 Habit created: fghjkgfh
I/flutter (21923): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/WidgetUpdateWorker(21923): ✅ Immediate widget update triggered
I/MainActivity(21923): Immediate widget update triggered via WidgetUpdateWorker
I/flutter (21923): Android widget immediate update triggered
W/JobInfo (21923): Requested important-while-foreground flag for job19 is ignored and takes no effect
D/WM-SystemJobScheduler(21923): Scheduling work ID 4b6518fe-6fd1-4d54-a405-9a305febc796Job ID 19
D/WM-GreedyScheduler(21923): Starting work for 4b6518fe-6fd1-4d54-a405-9a305febc796
D/WM-Processor(21923): Processor: processing WorkGenerationalId(workSpecId=4b6518fe-6fd1-4d54-a405-9a305febc796, generation=0)
D/WM-WorkerWrapper(21923): Starting work for com.habittracker.habitv8.WidgetUpdateWorker
I/WidgetUpdateWorker(21923): Starting widget update work
D/WindowOnBackDispatcher(21923): setTopOnBackInvokedCallback (unwrapped): android.app.Activity$$ExternalSyntheticLambda0@506b971
D/WidgetUpdateWorker(21923): Widget data loaded: 180 characters
D/WidgetUpdateWorker(21923): Updating habits data: 180 characters
D/WM-SystemJobService(21923): onStartJob for WorkGenerationalId(workSpecId=4b6518fe-6fd1-4d54-a405-9a305febc796, generation=0)
D/WM-Processor(21923): Work WorkGenerationalId(workSpecId=4b6518fe-6fd1-4d54-a405-9a305febc796, generation=0) is already enqueued for processing
D/WidgetUpdateWorker(21923): Processed 1 total habits, 1 for today
D/WidgetUpdateWorker(21923): Theme settings copied: mode=null, color=ffffffff
D/WidgetUpdateWorker(21923): Widget data updated from Flutter preferences
D/WidgetUpdateWorker(21923): Updated 1 timeline widgets
D/HabitTimelineWidget(21923): onUpdate called with 1 widget IDs
D/HabitTimelineWidget(21923): ListView setup completed for widget 21 (service will read fresh theme data)
D/HabitTimelineWidget(21923): Detected theme mode: 'dark'
D/HabitTimelineWidget(21923): Using theme - mode: 'dark', primary: ff2196f3
D/HabitTimelineWidget(21923): Semi-transparent theme applied - isDark: true, bg: 800f0f0f
D/HabitTimelineWidget(21923): Found habits in widgetData
D/HabitTimelineWidget(21923): Widget update completed for ID: 21
I/WidgetUpdateWorker(21923): ✅ Widget update work completed successfully
I/WM-WorkerWrapper(21923): Worker result SUCCESS for Work [ id=4b6518fe-6fd1-4d54-a405-9a305febc796, tags={ com.habittracker.habitv8.WidgetUpdateWorker,immediate_widget_update } ]
D/WM-Processor(21923): Processor 4b6518fe-6fd1-4d54-a405-9a305febc796 executed; reschedule = false
D/WM-SystemJobService(21923): 4b6518fe-6fd1-4d54-a405-9a305febc796 executed on JobScheduler
D/HabitTimelineService(21923): onDataSetChanged called - reloading habit data
D/HabitTimelineService(21923): 🎨 Loading fresh theme data from preferences:
D/HabitTimelineService(21923):   - HomeWidget['themeMode']: dark
D/HabitTimelineService(21923):   - Flutter['flutter.theme_mode']: null
D/HabitTimelineService(21923): 🎨 Final detected theme mode: 'dark'
D/HabitTimelineService(21923): Theme applied - isDark: true, textColor: ffffffff, primary: ff2196f3
D/WM-GreedyScheduler(21923): Cancelling work ID 4b6518fe-6fd1-4d54-a405-9a305febc796
D/HabitTimelineService(21923): ✅ Found habits data at key 'habits', length: 180, preview: [{"id":"1759687276264","name":"fghjk","category":"Health","colorValue":4294940672,"isCompleted":true
D/HabitTimelineService(21923): Attempting to load habits from key: habits, Raw length: 180
D/HabitTimelineService(21923): Loaded 1 habits for timeline widget
D/HabitTimelineService(21923): First habit keys: [id, name, category, colorValue, isCompleted, status, timeDisplay, frequency]
D/HabitTimelineService(21923): getCount returning: 1 habits
D/HabitTimelineService(21923): getViewAt position: 0
D/HabitTimelineService(21923): Created view for habit: fghjk at position 0
D/HabitTimelineService(21923): getCount returning: 1 habits
D/HabitTimelineService(21923): getViewAt position: 0
D/HabitTimelineService(21923): Created view for habit: fghjk at position 0
D/HabitTimelineService(21923): ⚡ Using cached data (11ms old), skipping reload
D/HabitTimelineService(21923): getCount returning: 1 habits
D/HabitTimelineService(21923): getViewAt position: 0
D/HabitTimelineService(21923): Created view for habit: fghjk at position 0
I/flutter (21923): Filtering 2 habits for date 2025-10-05:
I/flutter (21923):   - fghjk: HabitFrequency.daily -> INCLUDED
I/flutter (21923):   - fghjkgfh: HabitFrequency.daily -> INCLUDED
I/flutter (21923): Result: 2 habits for today
I/flutter (21923): Widget data preparation: Found 2 total habits, 2 for today
I/flutter (21923): 🎨 Getting app theme: ThemeMode.system
I/flutter (21923): 🎨 App is in SYSTEM mode, device brightness: Brightness.dark → dark
I/flutter (21923): 🎨 Final theme mode to send to widgets: dark
I/flutter (21923): 🎨 Using app primary color: 4280391411
I/flutter (21923): 🎯 Widget data prepared: 2 habits in list, JSON length: 357
I/flutter (21923): 🎯 First 200 chars of habits JSON: [{"id":"1759687276264","name":"fghjk","category":"Health","colorValue":4294940672,"isCompleted":true,"status":"Completed","timeDisplay":"11:02","frequency":"HabitFrequency.daily"},{"id":"1759689150846
I/flutter (21923): 🎯 Theme data: dark, primary: 4280391411
I/flutter (21923): Saved widget theme data: dark, color: 4280391411
I/flutter (21923): Updating widget HabitTimelineWidgetProvider with data keys: [habits, nextHabit, selectedDate, themeMode, primaryColor, lastUpdate]
I/flutter (21923): ✅ Saved habits: length=357, preview=[{"id":"1759687276264","name":"fghjk","category":"Health","colorValue":4294940672,"isCompleted":true,"status":"Completed","timeDisplay":"11:02","frequ...
I/flutter (21923): ✅ Saved nextHabit: {"id":"1759689150846","name":"fghjkgfh","category":"Health","colorValue":4280391411,"isCompleted":fa...
I/flutter (21923): ✅ Saved selectedDate: 2025-10-05
I/flutter (21923): ✅ Saved themeMode: dark
I/flutter (21923): ✅ Saved primaryColor: 4280391411
I/flutter (21923): ✅ Saved lastUpdate: 1759689152893
I/flutter (21923): Widget HabitTimelineWidgetProvider update completed
I/flutter (21923): Updating widget HabitCompactWidgetProvider with data keys: [habits, nextHabit, selectedDate, themeMode, primaryColor, lastUpdate]
I/flutter (21923): ✅ Saved habits: length=357, preview=[{"id":"1759687276264","name":"fghjk","category":"Health","colorValue":4294940672,"isCompleted":true,"status":"Completed","timeDisplay":"11:02","frequ...
I/flutter (21923): ✅ Saved nextHabit: {"id":"1759689150846","name":"fghjkgfh","category":"Health","colorValue":4280391411,"isCompleted":fa...
I/flutter (21923): ✅ Saved selectedDate: 2025-10-05
I/flutter (21923): ✅ Saved themeMode: dark
I/flutter (21923): ✅ Saved primaryColor: 4280391411
I/flutter (21923): ✅ Saved lastUpdate: 1759689152893
I/flutter (21923): Widget HabitCompactWidgetProvider update completed
I/flutter (21923): ✅ All widgets updated successfully (debounced)
D/WindowOnBackDispatcher(21923): setTopOnBackInvokedCallback (unwrapped): androidx.activity.OnBackPressedDispatcher$Api34Impl$createOnBackAnimationCallback$1@3775d15
D/WindowOnBackDispatcher(21923): setTopOnBackInvokedCallback (unwrapped): android.app.Activity$$ExternalSyntheticLambda0@506b971
I/flutter (21923): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (21923): │ #1   AppLifecycleService.didChangeAppLifecycleState (package:habitv8/services/app_lifecycle_service.dart:68:15)
I/flutter (21923): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (21923): │ 💡 📱 App lifecycle state changed to: AppLifecycleState.inactive
I/flutter (21923): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (21923): │ #1   AppLifecycleService.didChangeAppLifecycleState (package:habitv8/services/app_lifecycle_service.dart:87:19)
I/flutter (21923): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (21923): │ 💡 ⏹️ App inactive
I/flutter (21923): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/MainActivity(21923): onPause: Preserving alarm sound if playing
D/VRI[MainActivity](21923): visibilityChanged oldVisibility=true newVisibility=false
I/flutter (21923): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (21923): │ #1   AppLifecycleService.didChangeAppLifecycleState (package:habitv8/services/app_lifecycle_service.dart:68:15)
I/flutter (21923): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (21923): │ 💡 📱 App lifecycle state changed to: AppLifecycleState.hidden
I/flutter (21923): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (21923): │ #1   AppLifecycleService.didChangeAppLifecycleState (package:habitv8/services/app_lifecycle_service.dart:90:19)
I/flutter (21923): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (21923): │ 💡 👁️ App hidden
I/flutter (21923): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (21923): │ #1   AppLifecycleService.didChangeAppLifecycleState (package:habitv8/services/app_lifecycle_service.dart:68:15)
I/flutter (21923): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (21923): │ 💡 📱 App lifecycle state changed to: AppLifecycleState.paused
I/flutter (21923): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (21923): │ #1   AppLifecycleService.didChangeAppLifecycleState (package:habitv8/services/app_lifecycle_service.dart:78:19)
I/flutter (21923): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (21923): │ 💡 ⏸️ App paused - performing background cleanup...
I/flutter (21923): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (21923): │ #1   AppLifecycleService._performBackgroundCleanup (package:habitv8/services/app_lifecycle_service.dart:299:17)
I/flutter (21923): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (21923): │ 🐛 🧹 Performing background cleanup...
I/flutter (21923): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (21923): │ #1   AppLifecycleService._performBackgroundCleanup (package:habitv8/services/app_lifecycle_service.dart:304:17)
I/flutter (21923): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (21923): │ 🐛 ✅ Background cleanup completed
I/flutter (21923): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
D/ImeBackDispatcher(21923): Clear (mImeCallbacks.size=0)
D/ImeBackDispatcher(21923): switch root view (mImeCallbacks.size=0)
I/flutter (21923): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (21923): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:43:15)
I/flutter (21923): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (21923): │ 💡 🔍 Checking notification callback registration...
I/flutter (21923): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (21923): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:44:15)
I/flutter (21923): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (21923): │ 💡 📦 Container available: true
I/flutter (21923): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (21923): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:45:15)
I/flutter (21923): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (21923): │ 💡 🔗 Callback currently set: true
I/flutter (21923): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (21923): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (21923): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:56:17)
I/flutter (21923): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (21923): │ 💡 ✅ Notification action callback is properly registered
I/flutter (21923): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
Lost connection to device.
PS C:\HabitV8> 