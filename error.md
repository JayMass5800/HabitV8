setting a habit for two minutes in the future then pressing the complete button results in this 
I/flutter (18804): ❌ DEBUG: No notification action callback set!
I/flutter (18804): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18804): │ #0   AppLogger.warning (package:habitv8/services/logging_service.dart:24:13)
I/flutter (18804): │ #1   NotificationService._handleNotificationAction (package:habitv8/services/notification_service.dart:315:23)
I/flutter (18804): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18804): │ ! ❌ No notification action callback set - action will be lost
I/flutter (18804): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18804): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18804): │ #0   AppLogger.warning (package:habitv8/services/logging_service.dart:24:13)
I/flutter (18804): │ #1   NotificationService._storeActionForLaterProcessing (package:habitv8/services/notification_service.dart:341:15)
I/flutter (18804): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18804): │ ! Storing action for later processing: complete for habit: 1755190732181
I/flutter (18804): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18804): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

setting a habit for one minute in the future and pressing complete results in this error
I/flutter (18804): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (18804): │ #1   NotificationService._handleNotificationAction (package:habitv8/services/notification_service.dart:304:21)
I/flutter (18804): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18804): │ 💡 ✅ Notification cancelled for complete action for habit: 1755190931288
I/flutter (18804): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18804): ❌ DEBUG: No notification action callback set!
I/flutter (18804): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18804): │ #0   AppLogger.warning (package:habitv8/services/logging_service.dart:24:13)
I/flutter (18804): │ #1   NotificationService._handleNotificationAction (package:habitv8/services/notification_service.dart:315:23)
I/flutter (18804): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18804): │ ! ❌ No notification action callback set - action will be lost
I/flutter (18804): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18804): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18804): │ #0   AppLogger.warning (package:habitv8/services/logging_service.dart:24:13)
I/flutter (18804): │ #1   NotificationService._storeActionForLaterProcessing (package:habitv8/services/notification_service.dart:341:15)
I/flutter (18804): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18804): │ ! Storing action for later processing: complete for habit: 1755190931288
I/flutter (18804): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

pressing debug notification system 
I/flutter (18804): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (18804): │ #1   NotificationService._storeActionForLaterProcessing (package:habitv8/services/notification_service.dart:347:15)
I/flutter (18804): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18804): │ 💡 Pending actions queue size: 2
I/flutter (18804): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18804): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18804): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (18804): │ #1   NotificationService.debugNotificationSystem (package:habitv8/services/notification_service.dart:1340:15)
I/flutter (18804): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18804): │ 💡 🔍 === NOTIFICATION SYSTEM DEBUG ===
I/flutter (18804): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18804): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18804): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (18804): │ #1   NotificationService.debugNotificationSystem (package:habitv8/services/notification_service.dart:1341:15)
I/flutter (18804): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18804): │ 💡 🔧 Initialized: true
I/flutter (18804): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18804): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18804): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (18804): │ #1   NotificationService.debugNotificationSystem (package:habitv8/services/notification_service.dart:1342:15)
I/flutter (18804): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18804): │ 💡 📱 Platform: android
I/flutter (18804): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18804): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18804): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (18804): │ #1   NotificationService.debugNotificationSystem (package:habitv8/services/notification_service.dart:1343:15)
I/flutter (18804): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18804): │ 💡 🔗 Callback set: true
I/flutter (18804): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18804): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18804): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (18804): │ #1   NotificationService.debugNotificationSystem (package:habitv8/services/notification_service.dart:1344:15)
I/flutter (18804): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18804): │ 💡 📋 Pending actions: 0
I/flutter (18804): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18804): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18804): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (18804): │ #1   NotificationService.debugNotificationSystem (package:habitv8/services/notification_service.dart:1361:19)
I/flutter (18804): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18804): │ 💡 🔔 Notifications enabled: true
I/flutter (18804): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18804): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18804): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (18804): │ #1   NotificationService.canScheduleExactAlarms (package:habitv8/services/notification_service.dart:1273:21)
I/flutter (18804): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18804): │ 💡 Can schedule exact alarms: true
I/flutter (18804): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18804): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18804): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (18804): │ #1   NotificationService.debugNotificationSystem (package:habitv8/services/notification_service.dart:1364:19)
I/flutter (18804): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18804): │ 💡 ⏰ Can schedule exact alarms: true
I/flutter (18804): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18804): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18804): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (18804): │ #1   NotificationService.debugNotificationSystem (package:habitv8/services/notification_service.dart:1368:15)
I/flutter (18804): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18804): │ 💡 🔍 === END DEBUG ===
I/flutter (18804): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18804): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18804): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (18804): │ #1   _SettingsScreenState._debugNotificationSystem (package:habitv8/ui/screens/settings_screen.dart:1555:17)
I/flutter (18804): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18804): │ 💡 Notification system debug triggered from settings
I/flutter (18804): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18804): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18804): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (18804): │ #1   NotificationService.debugNotificationSystem (package:habitv8/services/notification_service.dart:1340:15)
I/flutter (18804): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18804): │ 💡 🔍 === NOTIFICATION SYSTEM DEBUG ===
I/flutter (18804): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18804): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18804): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (18804): │ #1   NotificationService.debugNotificationSystem (package:habitv8/services/notification_service.dart:1341:15)
I/flutter (18804): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18804): │ 💡 🔧 Initialized: true
I/flutter (18804): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18804): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18804): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (18804): │ #1   NotificationService.debugNotificationSystem (package:habitv8/services/notification_service.dart:1342:15)
I/flutter (18804): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18804): │ 💡 📱 Platform: android
I/flutter (18804): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18804): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18804): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (18804): │ #1   NotificationService.debugNotificationSystem (package:habitv8/services/notification_service.dart:1343:15)
I/flutter (18804): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18804): │ 💡 🔗 Callback set: true
I/flutter (18804): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18804): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18804): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (18804): │ #1   NotificationService.debugNotificationSystem (package:habitv8/services/notification_service.dart:1344:15)
I/flutter (18804): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18804): │ 💡 📋 Pending actions: 0
I/flutter (18804): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18804): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18804): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (18804): │ #1   NotificationService.debugNotificationSystem (package:habitv8/services/notification_service.dart:1361:19)
I/flutter (18804): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18804): │ 💡 🔔 Notifications enabled: true
I/flutter (18804): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18804): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18804): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (18804): │ #1   NotificationService.canScheduleExactAlarms (package:habitv8/services/notification_service.dart:1273:21)
I/flutter (18804): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18804): │ 💡 Can schedule exact alarms: true
I/flutter (18804): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18804): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18804): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (18804): │ #1   NotificationService.debugNotificationSystem (package:habitv8/services/notification_service.dart:1364:19)
I/flutter (18804): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18804): │ 💡 ⏰ Can schedule exact alarms: true
I/flutter (18804): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18804): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18804): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (18804): │ #1   NotificationService.debugNotificationSystem (package:habitv8/services/notification_service.dart:1368:15)
I/flutter (18804): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18804): │ 💡 🔍 === END DEBUG ===
I/flutter (18804): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18804): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18804): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (18804): │ #1   _SettingsScreenState._debugNotificationSystem (package:habitv8/ui/screens/settings_screen.dart:1555:17)
I/flutter (18804): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18804): │ 💡 Notification system debug triggered from settings

test notification with action buttons gets this 
/flutter (18804): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (18804): │ #1   NotificationService.onBackgroundNotificationResponse (package:habitv8/services/notification_service.dart:179:15)
I/flutter (18804): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18804): │ 💡 Background action ID: complete
I/flutter (18804): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18804): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18804): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (18804): │ #1   NotificationService.onBackgroundNotificationResponse (package:habitv8/services/notification_service.dart:180:15)
I/flutter (18804): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18804): │ 💡 Background payload: {"habitId":"test-habit-id","type":"habit_reminder"}
I/flutter (18804): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18804): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18804): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (18804): │ #1   NotificationService.onBackgroundNotificationResponse (package:habitv8/services/notification_service.dart:181:15)
I/flutter (18804): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18804): │ 💡 Background response type: NotificationResponseType.selectedNotificationAction
I/flutter (18804): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18804): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18804): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (18804): │ #1   NotificationService.onBackgroundNotificationResponse (package:habitv8/services/notification_service.dart:182:15)
I/flutter (18804): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18804): │ 💡 Background input: null
I/flutter (18804): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18804): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18804): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (18804): │ #1   NotificationService.onBackgroundNotificationResponse (package:habitv8/services/notification_service.dart:185:15)
I/flutter (18804): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18804): │ 💡 Raw background response: Instance of 'NotificationResponse'
I/flutter (18804): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18804): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18804): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (18804): │ #1   NotificationService.onBackgroundNotificationResponse (package:habitv8/services/notification_service.dart:196:21)
I/flutter (18804): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18804): │ 💡 Processing background action: complete for habit: test-habit-id
I/flutter (18804): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18804): 🚀 DEBUG: _handleNotificationAction called with habitId: test-habit-id, action: complete
I/flutter (18804): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18804): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (18804): │ #1   NotificationService._handleNotificationAction (package:habitv8/services/notification_service.dart:288:15)
I/flutter (18804): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18804): │ 💡 Handling notification action: complete for habit: test-habit-id
I/flutter (18804): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18804): 🔄 DEBUG: Normalized action: complete
I/flutter (18804): ✅ DEBUG: Processing complete action for habit: test-habit-id
I/flutter (18804): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18804): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (18804): │ #1   NotificationService._handleNotificationAction (package:habitv8/services/notification_service.dart:298:21)
I/flutter (18804): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18804): │ 💡  Processing complete action for habit: test-habit-id
I/flutter (18804): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18804): 🗑️ DEBUG: Notification cancelled with ID: 620174292
I/flutter (18804): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18804): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (18804): │ #1   NotificationService._handleNotificationAction (package:habitv8/services/notification_service.dart:304:21)
I/flutter (18804): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18804): │ 💡 ✅ Notification cancelled for complete action for habit: test-habit-id
I/flutter (18804): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18804): ❌ DEBUG: No notification action callback set!
I/flutter (18804): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18804): │ #0   AppLogger.warning (package:habitv8/services/logging_service.dart:24:13)
I/flutter (18804): │ #1   NotificationService._handleNotificationAction (package:habitv8/services/notification_service.dart:315:23)
I/flutter (18804): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18804): │ ! ❌ No notification action callback set - action will be lost
I/flutter (18804): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18804): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18804): │ #0   AppLogger.warning (package:habitv8/services/logging_service.dart:24:13)
I/flutter (18804): │ #1   NotificationService._storeActionForLaterProcessing (package:habitv8/services/notification_service.dart:341:15)
I/flutter (18804): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18804): │ ! Storing action for later processing: complete for habit: test-habit-id
I/flutter (18804): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18804): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18804): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (18804): │ #1   NotificationService._storeActionForLaterProcessing (package:habitv8/services/notification_service.dart:347:15)
I/flutter (18804): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18804): │ 💡 Pending actions queue size: 4
I/flutter (18804): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────