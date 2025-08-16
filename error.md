Step-by-Step Plan for Application Improvement

Phase 1: Stats Page Enhancement
Update Stats Page Structure
Modify stats page to work with new categories across all time periods (weekly, monthly, yearly)
Implement data sufficiency checks for monthly and yearly views
Add placeholder messages for insufficient data periods (2 weeks for monthly, 2 months for yearly)
Create consistent category-based analytics across all time periods

Phase 2: Insights Page Consolidation
Integrate Health Dashboard Components
Move overview, analytics, and insights from health integration dashboard into main insights pages
Keep settings and help sections in their current locations
Create unified insights layout that's habit-focused with integrated health data
Implement conditional health data display (only when health data is activated)
Remove health integration link from all habits page header

Phase 3: Habit Creation & Editing Consistency
Expand Category Suggestions

Extend suggested category feature to cover all habit types (not just health)
Create comprehensive category suggestion system for all habit categories
Update habit edit screen to match creation screen layout and functionality
Ensure consistent UI/UX between creation and editing flows
Improve Habit Suggestions

Convert health-based habit suggestions to dropdown section
Include suggestions for all habit types
Conditionally show health-related habits when health data is activated
Create more comprehensive and contextual habit suggestions

Phase 4: UI/UX Consistency & Flow
Design Consistency

Standardize layouts across all screens
Implement consistent navigation patterns
Ensure uniform styling and component usage
Create smooth transitions between sections
Data Flow Optimization

Reduce scattered data presentation
Create logical information hierarchy
Implement progressive disclosure for complex features
Ensure data consistency across all views
Implementation Priority:
High Priority: Stats page updates and insights consolidation (core user experience)
Medium Priority: Habit creation/editing consistency (user workflow improvement)
Lower Priority: UI polish and advanced suggestions (enhancement features)


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