The stats page needs to be updated to work with the new catagories for all sections ,weekly , monthly, yearly ... monthly and yearly need to have a two week and two month delay in showing data at first, they should display a message stating more data needs gathering before analysis will be visible so analysis will be more useful.


The insights pages need updating. Integrate the overview, analytics and insights from the health integration dashboard into the insights pages leave the settings and help sections where they are, update the layout and design it should be general habit focused but with full health data integrated too, however the health data should only show up when health data is activated. Remove the health integration link at the top of the all habits page.


lets expand the suggested category feature on the habit creation page to cover all habit types not just health types. and update the habit edit screen to be a match to the creation screen for consistency and ease of use.

Let's change the health based habit suggestions on the habit creation page to be a drop down section that suggests habits of all types and when health data is activated includes health related habits .


the snooze notification button doesnt seem to actualy work, it closes the notification but never sends a reminder, here are he flutter logs from pressing it, it looks like its working so perhaps its the notification scheduling thats at fault for this button?

Showing Pixel 9 Pro XL logs:
I/flutter (27990): 🚨🚨🚨 FLUTTER NOTIFICATION HANDLER CALLED! 🚨🚨🚨
I/flutter (27990): 🔔 Notification ID: 14824845
I/flutter (27990): 🔔 Action ID: snooze
I/flutter (27990): 🔔 Response Type: NotificationResponseType.selectedNotificationAction
I/flutter (27990): 🔔 Payload: {"habitId":"1755370786674","type":"habit_reminder"}
I/flutter (27990): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27990): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (27990): │ #1   NotificationService._onNotificationTapped (package:habitv8/services/notification_service.dart:219:15)
I/flutter (27990): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27990): │ 💡 === NOTIFICATION RESPONSE DEBUG ===
I/flutter (27990): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27990): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27990): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (27990): │ #1   NotificationService._onNotificationTapped (package:habitv8/services/notification_service.dart:220:15)
I/flutter (27990): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27990): │ 💡 🔔 NOTIFICATION RECEIVED!
I/flutter (27990): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27990): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27990): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (27990): │ #1   NotificationService._onNotificationTapped (package:habitv8/services/notification_service.dart:221:15)
I/flutter (27990): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27990): │ 💡 Notification ID: 14824845
I/flutter (27990): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27990): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27990): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (27990): │ #1   NotificationService._onNotificationTapped (package:habitv8/services/notification_service.dart:222:15)
I/flutter (27990): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27990): │ 💡 Action ID: snooze
I/flutter (27990): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27990): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27990): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (27990): │ #1   NotificationService._onNotificationTapped (package:habitv8/services/notification_service.dart:223:15)
I/flutter (27990): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27990): │ 💡 Input: null
I/flutter (27990): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27990): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27990): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (27990): │ #1   NotificationService._onNotificationTapped (package:habitv8/services/notification_service.dart:224:15)
I/flutter (27990): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27990): │ 💡 Payload: {"habitId":"1755370786674","type":"habit_reminder"}
I/flutter (27990): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27990): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27990): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (27990): │ #1   NotificationService._onNotificationTapped (package:habitv8/services/notification_service.dart:225:15)
I/flutter (27990): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27990): │ 💡 Notification response type: NotificationResponseType.selectedNotificationAction
I/flutter (27990): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27990): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27990): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (27990): │ #1   NotificationService._onNotificationTapped (package:habitv8/services/notification_service.dart:228:15)
I/flutter (27990): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27990): │ 💡 Raw notification response: Instance of 'NotificationResponse'
I/flutter (27990): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27990):  ACTION BUTTON DETECTED: snooze
I/flutter (27990): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27990): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (27990): │ #1   NotificationService._onNotificationTapped (package:habitv8/services/notification_service.dart:233:17)
I/flutter (27990): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27990): │ 💡  ACTION BUTTON PRESSED: snooze
I/flutter (27990): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27990): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27990): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (27990): │ #1   NotificationService._onNotificationTapped (package:habitv8/services/notification_service.dart:234:17)
I/flutter (27990): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27990): │ 💡 Response type for action: NotificationResponseType.selectedNotificationAction
I/flutter (27990): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27990): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27990): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (27990): │ #1   NotificationService._onNotificationTapped (package:habitv8/services/notification_service.dart:235:17)
I/flutter (27990): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27990): │ 💡 Action button working! Processing action...
I/flutter (27990): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27990): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27990): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (27990): │ #1   NotificationService._onNotificationTapped (package:habitv8/services/notification_service.dart:242:15)
I/flutter (27990): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27990): │ 💡 ✅ Notification handler called successfully
I/flutter (27990): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27990): 📦 Processing payload: {"habitId":"1755370786674","type":"habit_reminder"}
I/flutter (27990): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27990): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (27990): │ #1   NotificationService._onNotificationTapped (package:habitv8/services/notification_service.dart:247:17)
I/flutter (27990): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27990): │ 💡 Processing notification with payload: {"habitId":"1755370786674","type":"habit_reminder"}
I/flutter (27990): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27990): 🎯 Parsed habitId: 1755370786674
I/flutter (27990): ⚡ Parsed action: snooze
I/flutter (27990): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27990): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (27990): │ #1   NotificationService._onNotificationTapped (package:habitv8/services/notification_service.dart:256:19)
I/flutter (27990): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27990): │ 💡 Parsed habitId: 1755370786674
I/flutter (27990): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27990): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27990): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (27990): │ #1   NotificationService._onNotificationTapped (package:habitv8/services/notification_service.dart:257:19)
I/flutter (27990): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27990): │ 💡 Parsed action: snooze
I/flutter (27990): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27990): 🚀 CALLING _handleNotificationAction with: snooze, 1755370786674
I/flutter (27990): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27990): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (27990): │ #1   NotificationService._onNotificationTapped (package:habitv8/services/notification_service.dart:263:23)
I/flutter (27990): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27990): │ 💡 Processing action button: snooze for habit: 1755370786674
I/flutter (27990): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27990): 🚀 DEBUG: _handleNotificationAction called with habitId: 1755370786674, action: snooze
I/flutter (27990): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27990): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (27990): │ #1   NotificationService._handleNotificationAction (package:habitv8/services/notification_service.dart:292:15)
I/flutter (27990): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27990): │ 💡 Handling notification action: snooze for habit: 1755370786674
I/flutter (27990): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27990): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27990): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (27990): │ #1   NotificationService.ensureCallbackIsSet (package:habitv8/services/notification_service.dart:406:15)
I/flutter (27990): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27990): │ 💡 🔍 Callback check: SET
I/flutter (27990): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27990): 🔄 DEBUG: Normalized action: snooze
I/flutter (27990): 😴 DEBUG: Processing snooze action for habit: 1755370786674
I/flutter (27990): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27990): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (27990): │ #1   NotificationService._handleNotificationAction (package:habitv8/services/notification_service.dart:336:21)
I/flutter (27990): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27990): │ 💡 😴 Processing snooze action for habit: 1755370786674
I/flutter (27990): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27990): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27990): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (27990): │ #1   NotificationService._handleSnoozeAction (package:habitv8/services/notification_service.dart:418:17)
I/flutter (27990): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27990): │ 💡 🔔 Starting snooze process for habit: 1755370786674 (notification ID: 973610029)
I/flutter (27990): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27990): ✅ _onNotificationTapped completed
I/flutter (27990): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27990): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (27990): │ #1   NotificationService._handleSnoozeAction (package:habitv8/services/notification_service.dart:422:17)
I/flutter (27990): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27990): │ 💡 ❌ Cancelled current notification for habit: 1755370786674
I/flutter (27990): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27990): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27990): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (27990): │ #1   NotificationService._handleSnoozeAction (package:habitv8/services/notification_service.dart:426:17)
I/flutter (27990): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27990): │ 💡 😴 Snooze action processed - notification dismissed
I/flutter (27990): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27990): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27990): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (27990): │ #1   NotificationActionService._handleNotificationAction (package:habitv8/services/notification_action_service.dart:39:15)
I/flutter (27990): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27990): │ 💡 Processing notification action: snooze for habit: 1755370786674
I/flutter (27990): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27990): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27990): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (27990): │ #1   NotificationActionService._handleNotificationAction (package:habitv8/services/notification_action_service.dart:50:21)
I/flutter (27990): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27990): │ 💡 Habit snoozed: 1755370786674
I/flutter (27990): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27990): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27990): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (27990): │ #1   NotificationService._handleSnoozeAction (package:habitv8/services/notification_service.dart:431:19)
I/flutter (27990): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27990): │ 💡 📞 Snooze action callback executed for habit: 1755370786674
I/flutter (27990): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27990): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27990): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (27990): │ #1   NotificationService._handleSnoozeAction (package:habitv8/services/notification_service.dart:436:17)
I/flutter (27990): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27990): │ 💡 ✅ Snooze action completed for habit: 1755370786674
I/flutter (27990): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27990): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27990): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (27990): │ #1   NotificationService._handleNotificationAction (package:habitv8/services/notification_service.dart:339:21)
I/flutter (27990): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27990): │ 💡 ✅ Snooze action completed for habit: 1755370786674
I/flutter (27990): └──────────────────────────────────────────────────────────────────────────────────────────────────────────────