/flutter (18311): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (18311): │ #1   NotificationScheduler.scheduleHabitNotifications (package:habitv8/services/notifications/notification_scheduler.dart:288:17)
I/flutter (18311): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18311): │ 🐛 Scheduling for 12:20
I/flutter (18311): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18311): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18311): │ HiveError: You need to initialize Hive or provide a path to store the box.
I/flutter (18311): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18311): │ #0   AppLogger.error (package:habitv8/services/logging_service.dart:34:13)
I/flutter (18311): │ #1   ScheduledNotificationStorage.initialize (package:habitv8/services/notifications/scheduled_notification_storage.dart:28:17)
I/flutter (18311): │ #2   <asynchronous suspension>
I/flutter (18311): │ #3   ScheduledNotificationStorage._ensureInitialized (package:habitv8/services/notifications/scheduled_notification_storage.dart:186:7)
I/flutter (18311): │ #4   <asynchronous suspension>
I/flutter (18311): │ #5   ScheduledNotificationStorage.deleteNotification (package:habitv8/services/notifications/scheduled_notification_storage.dart:115:7)
I/flutter (18311): │ #6   <asynchronous suspension>
I/flutter (18311): │ #7   NotificationScheduler.cancelHabitNotifications (package:habitv8/services/notifications/notification_scheduler.dart:708:7)
I/flutter (18311): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18311): │ ⛔ Error initializing ScheduledNotificationStorage
I/flutter (18311): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18311): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18311): │ HiveError: You need to initialize Hive or provide a path to store the box.
I/flutter (18311): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18311): │ #0   AppLogger.error (package:habitv8/services/logging_service.dart:34:13)
I/flutter (18311): │ #1   ScheduledNotificationStorage.deleteNotification (package:habitv8/services/notifications/scheduled_notification_storage.dart:119:17)
I/flutter (18311): │ #2   <asynchronous suspension>
I/flutter (18311): │ #3   NotificationScheduler.cancelHabitNotifications (package:habitv8/services/notifications/notification_scheduler.dart:708:7)
I/flutter (18311): │ #4   <asynchronous suspension>
I/flutter (18311): │ #5   NotificationScheduler.scheduleHabitNotifications (package:habitv8/services/notifications/notification_scheduler.dart:297:9)
I/flutter (18311): │ #6   <asynchronous suspension>
I/flutter (18311): │ #7   NotificationService.scheduleHabitNotifications (package:habitv8/services/notification_service.dart:66:5)
I/flutter (18311): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18311): │ ⛔ Error deleting scheduled notification
I/flutter (18311): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18311): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18311): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (18311): │ #1   NotificationScheduler.cancelHabitNotifications (package:habitv8/services/notifications/notification_scheduler.dart:709:17)
I/flutter (18311): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18311): │ 🐛 💾 Removed notification 7988238 from persistent storage
I/flutter (18311): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18311): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18311): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (18311): │ #1   NotificationScheduler.cancelHabitNotifications (package:habitv8/services/notifications/notification_scheduler.dart:715:15)
I/flutter (18311): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18311): │ 🐛 Cancelled notification with base ID: 7988238
I/flutter (18311): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18311): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18311): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (18311): │ #1   NotificationScheduler.scheduleHabitNotifications (package:habitv8/services/notifications/notification_scheduler.dart:300:19)
I/flutter (18311): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18311): │ 🐛 Cancelled existing notifications for habit ID: 1759948884798
I/flutter (18311): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18311): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18311): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:21:15)
I/flutter (18311): │ #1   NotificationScheduler.scheduleHabitNotifications (package:habitv8/services/notifications/notification_scheduler.dart:311:19)
I/flutter (18311): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18311): │ 🐛 Scheduling RRule-based notifications
I/flutter (18311): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
E/flutter (18311): [ERROR:flutter/runtime/dart_vm_initializer.cc(40)] Unhandled Exception: HiveError: You need to initialize Hive or provide a path to store the box.
E/flutter (18311): #0      BackendManager.open (package:hive/src/backend/vm/backend_manager.dart:21:7)
E/flutter (18311): #1      HiveImpl._openBox (package:hive/src/hive_impl.dart:101:36)
E/flutter (18311): #2      HiveImpl.openBox (package:hive/src/hive_impl.dart:142:18)
E/flutter (18311): #3      ScheduledNotificationStorage.initialize (package:habitv8/services/notifications/scheduled_notification_storage.dart:24:25)
E/flutter (18311): #4      ScheduledNotificationStorage._ensureInitialized (package:habitv8/services/notifications/scheduled_notification_storage.dart:186:13)
E/flutter (18311): #5      ScheduledNotificationStorage.deleteNotification (package:habitv8/services/notifications/scheduled_notification_storage.dart:115:13)
E/flutter (18311): #6      NotificationScheduler.cancelHabitNotifications (package:habitv8/services/notifications/notification_scheduler.dart:708:42)
E/flutter (18311): <asynchronous suspension>
E/flutter (18311): #7      NotificationScheduler.scheduleHabitNotifications (package:habitv8/services/notifications/notification_scheduler.dart:297:9)
E/flutter (18311): <asynchronous suspension>
E/flutter (18311): #8      NotificationService.scheduleHabitNotifications (package:habitv8/services/notification_service.dart:66:5)
E/flutter (18311): <asynchronous suspension>
E/flutter (18311): #9      _EditHabitScreenState._scheduleHabitNotifications (package:habitv8/ui/screens/edit_habit_screen.dart:1802:7)
E/flutter (18311): <asynchronous suspension>
E/flutter (18311): #10     _EditHabitScreenState._saveHabit (package:habitv8/ui/screens/edit_habit_screen.dart:1713:7)
E/flutter (18311): <asynchronous suspension>
E/flutter (18311):
I/r.habitv8.debug(18311): Background young concurrent mark compact GC freed 25MB AllocSpace bytes, 55(17MB) LOS objects, 0% free, 46MB/46MB, paused 87us,2.100ms total 244.295ms
I/r.habitv8.debug(18311): Background concurrent mark compact GC freed 23MB AllocSpace bytes, 57(24MB) LOS objects, 47% free, 106MB/202MB, paused 185us,3.693ms total 565.527ms
I/r.habitv8.debug(18311): Background young concurrent mark compact GC freed 113MB AllocSpace bytes, 238(87MB) LOS objects, 57% free, 70MB/166MB, paused 483us,6.943ms total 362.865ms
I/r.habitv8.debug(18311): Background young concurrent mark compact GC freed 88MB AllocSpace bytes, 175(64MB) LOS objects, 0% free, 211MB/211MB, paused 161us,6.707ms total 1.060s
I/flutter (18311): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18311): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (18311): │ #1   NotificationScheduler._scheduleRRuleHabitNotifications (package:habitv8/services/notifications/notification_scheduler.dart:891:17)
I/flutter (18311): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18311): │ 💡 📅 Scheduled 85 RRule notifications for reboot test
I/flutter (18311): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18311): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (18311): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:26:13)
I/flutter (18311): │ #1   NotificationScheduler.scheduleHabitNotifications (package:habitv8/services/notifications/notification_scheduler.dart:348:17)
I/flutter (18311): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (18311): │ 💡 ✅ Successfully scheduled notifications for habit: reboot test
I/flutter (18311): └───────────────────────────────────────────────────────────────────────────────────