I/ImeTracker(13536): com.habittracker.habitv8.debug:8e0814d5: onRequestHide at ORIGIN_CLIENT reason HIDE_SOFT_INPUT fromUser false
D/InsetsController(13536): hide(ime())
D/ImeBackDispatcher(13536): Preliminary clear (mImeCallbacks.size=1)
D/WindowOnBackDispatcher(13536): setTopOnBackInvokedCallback (unwrapped): androidx.activity.OnBackPressedDispatcher$Api34Impl$createOnBackAnimationCallback$1@d235770
D/InsetsController(13536): Setting requestedVisibleTypes to -9 (was -1)
D/CompatChangeReporter(13536): Compat change id reported: 395521150; UID 10476; state: ENABLED
D/InputConnectionAdaptor(13536): The input method toggled cursor monitoring off
D/ImeBackDispatcher(13536): Unregister received callback id=191363132
I/ImeTracker(13536): system_server:eb6522d4: onCancelled at PHASE_CLIENT_ON_CONTROLS_CHANGED
D/AlarmApiImpl(13536): Warning notification is already turned off.
D/AlarmApiImpl(13536): Alarm stopped notification for 999999 was processed successfully by Flutter.
D/AlarmApiImpl(13536): Warning notification is already turned off.
D/AlarmApiImpl(13536): Alarm stopped notification for 999999 was processed successfully by Flutter.
D/AudioSystem(13536): onNewServiceWithAdapter: media.audio_flinger service obtained 0xb400007588a17ab0
D/AudioSystem(13536): getService: checking for service media.audio_flinger: 0xb400007568974c70
D/Ringtone(13536): Successfully created local player
V/MediaPlayer(13536): resetDrmState:  mDrmInfo=null mDrmProvisioningThread=null mPrepareDrmInProgress=false mActiveDrmScheme=false
V/MediaPlayer(13536): cleanDrmObj: mDrmObj=null mDrmSessionId=null
V/MediaPlayer(13536): resetDrmState:  mDrmInfo=null mDrmProvisioningThread=null mPrepareDrmInProgress=false mActiveDrmScheme=false
V/MediaPlayer(13536): cleanDrmObj: mDrmObj=null mDrmSessionId=null
D/Ringtone(13536): Successfully created local player
D/AudioSystem(13536): onNewService: media.audio_policy service obtained 0xb400007568983ae0
D/AudioSystem(13536): getService: checking for service media.audio_policy: 0xb400007568983ae0
D/AlarmApiImpl(13536): Warning notification is already turned off.
V/MediaPlayer(13536): resetDrmState:  mDrmInfo=null mDrmProvisioningThread=null mPrepareDrmInProgress=false mActiveDrmScheme=false
V/MediaPlayer(13536): cleanDrmObj: mDrmObj=null mDrmSessionId=null
V/MediaPlayer(13536): resetDrmState:  mDrmInfo=null mDrmProvisioningThread=null mPrepareDrmInProgress=false mActiveDrmScheme=false
V/MediaPlayer(13536): cleanDrmObj: mDrmObj=null mDrmSessionId=null
D/AlarmApiImpl(13536): Alarm stopped notification for 999999 was processed successfully by Flutter.
D/AlarmApiImpl(13536): Warning notification is already turned off.
D/AlarmApiImpl(13536): Alarm stopped notification for 999999 was processed successfully by Flutter.
D/Ringtone(13536): Successfully created local player
V/MediaPlayer(13536): resetDrmState:  mDrmInfo=null mDrmProvisioningThread=null mPrepareDrmInProgress=false mActiveDrmScheme=false
V/MediaPlayer(13536): cleanDrmObj: mDrmObj=null mDrmSessionId=null
V/MediaPlayer(13536): resetDrmState:  mDrmInfo=null mDrmProvisioningThread=null mPrepareDrmInProgress=false mActiveDrmScheme=false
V/MediaPlayer(13536): cleanDrmObj: mDrmObj=null mDrmSessionId=null
D/Ringtone(13536): Successfully created local player
D/AlarmApiImpl(13536): Warning notification is already turned off.
V/MediaPlayer(13536): resetDrmState:  mDrmInfo=null mDrmProvisioningThread=null mPrepareDrmInProgress=false mActiveDrmScheme=false
V/MediaPlayer(13536): cleanDrmObj: mDrmObj=null mDrmSessionId=null
V/MediaPlayer(13536): resetDrmState:  mDrmInfo=null mDrmProvisioningThread=null mPrepareDrmInProgress=false mActiveDrmScheme=false
V/MediaPlayer(13536): cleanDrmObj: mDrmObj=null mDrmSessionId=null
D/AlarmApiImpl(13536): Alarm stopped notification for 999999 was processed successfully by Flutter.
D/AlarmApiImpl(13536): Warning notification is already turned off.
D/AlarmApiImpl(13536): Alarm stopped notification for 999999 was processed successfully by Flutter.
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (13536): │ #1   _CreateHabitScreenState._buildFrequencySection (package:habitv8/ui/screens/create_habit_screen.dart:407:15)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 🐛 Building frequency section, current frequency: HabitFrequency.daily
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
D/AlarmApiImpl(13536): Warning notification is already turned off.
D/AlarmApiImpl(13536): Alarm stopped notification for 999999 was processed successfully by Flutter.
E/flutter (13536): [ERROR:flutter/runtime/dart_vm_initializer.cc(40)] Unhandled Exception: setState() called after dispose(): _StatefulBuilderState#71f69(lifecycle state: defunct, not mounted)
E/flutter (13536): This error happens if you call setState() on a State object for a widget that no longer appears in the widget tree (e.g., whose parent widget no longer includes the widget in its build). This error can occur when code calls setState() from a timer or an animation callback.
E/flutter (13536): The preferred solution is to cancel the timer or stop listening to the animation in the dispose() callback. Another solution is to check the "mounted" property of this object before calling setState() to ensure the object is still in the tree.
E/flutter (13536): This error might indicate a memory leak if setState() is being called because another object is retaining a reference to this State object after it has been removed from the tree. To avoid memory leaks, consider breaking the reference to this object during dispose().
E/flutter (13536): #0      State.setState.<anonymous closure> (package:flutter/src/widgets/framework.dart:1163:9)
E/flutter (13536): #1      State.setState (package:flutter/src/widgets/framework.dart:1198:6)
E/flutter (13536): #2      _CreateHabitScreenState._selectAlarmSound.<anonymous closure>.<anonymous closure>.<anonymous closure>.<anonymous closure>.<anonymous closure> (package:habitv8/ui/screens/create_habit_screen.dart:1309:53)
E/flutter (13536): <asynchronous suspension>
E/flutter (13536):
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (13536): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:41:15)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 💡 🔍 Checking notification callback registration...
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (13536): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:42:15)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 💡 📦 Container available: true
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (13536): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:43:15)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 💡 🔗 Callback currently set: true
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (13536): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:54:17)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 💡 ✅ Notification action callback is properly registered
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
D/AlarmApiImpl(13536): Warning notification is already turned off.
D/AlarmApiImpl(13536): Alarm stopped notification for 999999 was processed successfully by Flutter.
D/AlarmApiImpl(13536): Warning notification is already turned off.
D/AlarmApiImpl(13536): Alarm stopped notification for 999999 was processed successfully by Flutter.
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (13536): │ #1   _CreateHabitScreenState._buildFrequencySection (package:habitv8/ui/screens/create_habit_screen.dart:407:15)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 🐛 Building frequency section, current frequency: HabitFrequency.daily
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (13536): │ #1   _CreateHabitScreenState._buildFrequencySection (package:habitv8/ui/screens/create_habit_screen.dart:407:15)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 🐛 Building frequency section, current frequency: HabitFrequency.daily
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (13536): │ #1   NotificationService.scheduleHabitNotifications (package:habitv8/services/notification_service.dart:1418:15)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 🐛 Starting notification scheduling for habit: ghost
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (13536): │ #1   NotificationService.scheduleHabitNotifications (package:habitv8/services/notification_service.dart:1421:15)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 🐛 Notifications enabled: false
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (13536): │ #1   NotificationService.scheduleHabitNotifications (package:habitv8/services/notification_service.dart:1422:15)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 🐛 Alarm enabled: true
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (13536): │ #1   NotificationService.scheduleHabitNotifications (package:habitv8/services/notification_service.dart:1423:15)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 🐛 Notification time: 2025-09-09 13:17:00.000
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (13536): │ #1   NotificationService._ensureNotificationPermissions (package:habitv8/services/notification_service.dart:261:17)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 💡 Checking notification permission...
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (13536): │ #1   NotificationService._ensureNotificationPermissions (package:habitv8/services/notification_service.dart:277:19)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 💡 Notification permission already granted
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (13536): │ #1   PermissionService.hasExactAlarmPermission (package:habitv8/services/permission_service.dart:251:17)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 💡 Checking exact alarm permission status...
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (13536): │ #1   HealthService.hasExactAlarmPermission (package:habitv8/services/health_service.dart:428:17)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 💡 Checking exact alarm permission...
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (13536): │ #1   MinimalHealthChannel.hasExactAlarmPermission (package:habitv8/services/minimal_health_channel.dart:278:17)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 💡 Checking exact alarm permission...
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/MinimalHealthPlugin(13536): Method call received: hasExactAlarmPermission
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (13536): │ #1   MinimalHealthChannel.hasExactAlarmPermission (package:habitv8/services/minimal_health_channel.dart:282:17)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 💡 Exact alarm permission status: true
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (13536): │ #1   HealthService.hasExactAlarmPermission (package:habitv8/services/health_service.dart:430:17)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 💡 Exact alarm permission status: true
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (13536): │ #1   PermissionService.hasExactAlarmPermission (package:habitv8/services/permission_service.dart:265:17)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 💡 Exact alarm permission check result: true
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (13536): │ #1   NotificationService._ensureNotificationPermissions (package:habitv8/services/notification_service.dart:299:19)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 💡 Exact alarm permission already available
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (13536): │ #1   NotificationService.scheduleHabitNotifications (package:habitv8/services/notification_service.dart:1452:17)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 🐛 Alarms enabled - scheduling alarms instead of notifications
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (13536): │ #1   NotificationService.scheduleHabitAlarms (package:habitv8/services/notification_service.dart:1550:15)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 🐛 Starting alarm scheduling for habit: ghost
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (13536): │ #1   NotificationService.scheduleHabitAlarms (package:habitv8/services/notification_service.dart:1551:15)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 🐛 Alarm enabled: true
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (13536): │ #1   NotificationService.scheduleHabitAlarms (package:habitv8/services/notification_service.dart:1552:15)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 🐛 Alarm sound: Full of Wonder
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (13536): │ #1   NotificationService.scheduleHabitAlarms (package:habitv8/services/notification_service.dart:1553:15)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 🐛 Snooze delay: 10 minutes (fixed default)
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (13536): │ #1   NotificationService.scheduleHabitAlarms (package:habitv8/services/notification_service.dart:1580:17)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 🐛 Scheduling alarm for 13:17
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (13536): │ #1   HybridAlarmService.cancelHabitAlarms (package:habitv8/services/hybrid_alarm_service.dart:384:15)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 💡 🔄 Cancelling all alarms for habit:
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (13536): │ #1   HybridAlarmService.cancelHabitAlarms (package:habitv8/services/hybrid_alarm_service.dart:410:15)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 💡 ✅ Cancelled alarms for habit
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (13536): │ #1   NotificationService.scheduleHabitAlarms (package:habitv8/services/notification_service.dart:1588:17)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 🐛 Cancelled existing alarms for habit ID: 1757448918238
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (13536): │ #1   NotificationService.scheduleHabitAlarms (package:habitv8/services/notification_service.dart:1591:17)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 🐛 Habit frequency: daily
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (13536): │ #1   NotificationService.scheduleHabitAlarms (package:habitv8/services/notification_service.dart:1595:21)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 🐛 Scheduling daily alarms
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (13536): │ #1   HybridAlarmService.scheduleExactAlarm (package:habitv8/services/hybrid_alarm_service.dart:74:15)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 💡 🔄 Scheduling exact alarm:
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (13536): │ #1   HybridAlarmService.scheduleExactAlarm (package:habitv8/services/hybrid_alarm_service.dart:75:15)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 💡   - Alarm ID: 96
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (13536): │ #1   HybridAlarmService.scheduleExactAlarm (package:habitv8/services/hybrid_alarm_service.dart:76:15)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 💡   - Habit: ghost
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (13536): │ #1   HybridAlarmService.scheduleExactAlarm (package:habitv8/services/hybrid_alarm_service.dart:77:15)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 💡   - Scheduled time: 2025-09-09 13:17:00.000
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (13536): │ #1   HybridAlarmService.scheduleExactAlarm (package:habitv8/services/hybrid_alarm_service.dart:78:15)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 💡   - Sound: Full of Wonder
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
D/AlarmApiImpl(13536): Warning notification turned on.
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (13536): │ #1   HybridAlarmService.scheduleExactAlarm (package:habitv8/services/hybrid_alarm_service.dart:103:17)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 💡 ✅ Exact alarm scheduled successfully
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (13536): │ #1   NotificationService._scheduleDailyHabitAlarmsNew (package:habitv8/services/notification_service.dart:2846:15)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 💡 ✅ Scheduled daily alarms for ghost
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (13536): │ #1   NotificationService.scheduleHabitAlarms (package:habitv8/services/notification_service.dart:1624:17)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 🐛 Successfully scheduled alarms for habit: ghost
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (13536): │ #1   NotificationService.scheduleHabitAlarms (package:habitv8/services/notification_service.dart:1625:17)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 💡 Successfully scheduled alarms for habit: ghost
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (13536): │ #1   HabitService.addHabit (package:habitv8/data/database.dart:120:19)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 💡 Scheduled notifications/alarms for new habit "ghost"
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (13536): │ #1   HabitService.addHabit (package:habitv8/data/database.dart:134:19)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 🐛 Calendar sync disabled, skipping sync for new habit "ghost"
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (13536): │ #1   HealthHabitMappingService.analyzeHabitForHealthMapping (package:habitv8/services/health_habit_mapping_service.dart:868:17)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 💡 Analyzing habit for health mapping: "ghost" (category: Health)
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (13536): │ #1   HealthHabitMappingService.analyzeHabitForHealthMapping (package:habitv8/services/health_habit_mapping_service.dart:871:17)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 💡 Search text: "ghost "
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/MinimalHealthPlugin(13536): Method call received: initialize
I/MinimalHealthPlugin(13536): Initializing MinimalHealthPlugin
I/MinimalHealthPlugin(13536): Plugin initialization result: true
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (13536): │ #1   MinimalHealthChannel.isDataTypeSupported (package:habitv8/services/minimal_health_channel.dart:306:19)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 💡 MINDFULNESS data type support check result: true
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (13536): │ #1   HealthHabitMappingService._isMindfulnessSupported (package:habitv8/services/health_habit_mapping_service.dart:1861:17)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 💡 MINDFULNESS support check result: true
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (13536): │ #1   HealthHabitMappingService.analyzeHabitForHealthMapping (package:habitv8/services/health_habit_mapping_service.dart:930:21)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 💡 Category "health" matched to MEDICATION with score 0.8
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (13536): │ #1   HealthHabitMappingService.analyzeHabitForHealthMapping (package:habitv8/services/health_habit_mapping_service.dart:930:21)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 💡 Category "health" matched to WEIGHT with score 0.7
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (13536): │ #1   HealthHabitMappingService.analyzeHabitForHealthMapping (package:habitv8/services/health_habit_mapping_service.dart:930:21)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 💡 Category "health" matched to HEART_RATE with score 0.7
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (13536): │ #1   HealthHabitMappingService.analyzeHabitForHealthMapping (package:habitv8/services/health_habit_mapping_service.dart:930:21)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 💡 Category "health" matched to STEPS with score 0.6
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (13536): │ #1   HealthHabitMappingService.analyzeHabitForHealthMapping (package:habitv8/services/health_habit_mapping_service.dart:930:21)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 💡 Category "health" matched to SLEEP_IN_BED with score 0.6
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (13536): │ #1   HealthHabitMappingService.analyzeHabitForHealthMapping (package:habitv8/services/health_habit_mapping_service.dart:930:21)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 💡 Category "health" matched to WATER with score 0.6
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (13536): │ #1   HealthHabitMappingService.analyzeHabitForHealthMapping (package:habitv8/services/health_habit_mapping_service.dart:975:21)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 💡 Category-only match for MEDICATION: 0.8
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (13536): │ #1   HealthHabitMappingService.analyzeHabitForHealthMapping (package:habitv8/services/health_habit_mapping_service.dart:975:21)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 💡 Category-only match for WEIGHT: 0.7
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (13536): │ #1   HealthHabitMappingService.analyzeHabitForHealthMapping (package:habitv8/services/health_habit_mapping_service.dart:975:21)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 💡 Category-only match for HEART_RATE: 0.7
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (13536): │ #1   HealthHabitMappingService.analyzeHabitForHealthMapping (package:habitv8/services/health_habit_mapping_service.dart:975:21)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 💡 Category-only match for STEPS: 0.6
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (13536): │ #1   HealthHabitMappingService.analyzeHabitForHealthMapping (package:habitv8/services/health_habit_mapping_service.dart:975:21)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 💡 Category-only match for SLEEP_IN_BED: 0.6
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (13536): │ #1   HealthHabitMappingService.analyzeHabitForHealthMapping (package:habitv8/services/health_habit_mapping_service.dart:975:21)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 💡 Category-only match for WATER: 0.6
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (13536): │ #1   HealthHabitMappingService.analyzeHabitForHealthMapping (package:habitv8/services/health_habit_mapping_service.dart:1039:17)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 💡 Best match for habit "ghost": MEDICATION (score: 0.8)
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (13536): │ #1   HealthHabitMappingService.analyzeHabitForHealthMapping (package:habitv8/services/health_habit_mapping_service.dart:1138:17)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 💡 Created health mapping for habit "ghost": MEDICATION, threshold: 1.0 (moderate)
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (13536): │ #1   _CreateHabitScreenState._saveHabit (package:habitv8/ui/screens/create_habit_screen.dart:1615:23)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 💡 Automatic health mapping found for habit: ghost -> MEDICATION
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (13536): │ #1   NotificationService.scheduleHabitNotifications (package:habitv8/services/notification_service.dart:1418:15)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 🐛 Starting notification scheduling for habit: ghost
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (13536): │ #1   NotificationService.scheduleHabitNotifications (package:habitv8/services/notification_service.dart:1421:15)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 🐛 Notifications enabled: false
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (13536): │ #1   NotificationService.scheduleHabitNotifications (package:habitv8/services/notification_service.dart:1422:15)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 🐛 Alarm enabled: true
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (13536): │ #1   NotificationService.scheduleHabitNotifications (package:habitv8/services/notification_service.dart:1423:15)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 🐛 Notification time: 2025-09-09 13:17:00.000
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (13536): │ #1   NotificationService._ensureNotificationPermissions (package:habitv8/services/notification_service.dart:261:17)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 💡 Checking notification permission...
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (13536): │ #1   NotificationService._ensureNotificationPermissions (package:habitv8/services/notification_service.dart:277:19)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 💡 Notification permission already granted
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (13536): │ #1   PermissionService.hasExactAlarmPermission (package:habitv8/services/permission_service.dart:251:17)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 💡 Checking exact alarm permission status...
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (13536): │ #1   HealthService.hasExactAlarmPermission (package:habitv8/services/health_service.dart:428:17)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 💡 Checking exact alarm permission...
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (13536): │ #1   MinimalHealthChannel.hasExactAlarmPermission (package:habitv8/services/minimal_health_channel.dart:278:17)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 💡 Checking exact alarm permission...
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/MinimalHealthPlugin(13536): Method call received: hasExactAlarmPermission
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (13536): │ #1   MinimalHealthChannel.hasExactAlarmPermission (package:habitv8/services/minimal_health_channel.dart:282:17)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 💡 Exact alarm permission status: true
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (13536): │ #1   HealthService.hasExactAlarmPermission (package:habitv8/services/health_service.dart:430:17)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 💡 Exact alarm permission status: true
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (13536): │ #1   PermissionService.hasExactAlarmPermission (package:habitv8/services/permission_service.dart:265:17)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 💡 Exact alarm permission check result: true
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (13536): │ #1   NotificationService._ensureNotificationPermissions (package:habitv8/services/notification_service.dart:299:19)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 💡 Exact alarm permission already available
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (13536): │ #1   NotificationService.scheduleHabitNotifications (package:habitv8/services/notification_service.dart:1452:17)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 🐛 Alarms enabled - scheduling alarms instead of notifications
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (13536): │ #1   NotificationService.scheduleHabitAlarms (package:habitv8/services/notification_service.dart:1550:15)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 🐛 Starting alarm scheduling for habit: ghost
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (13536): │ #1   NotificationService.scheduleHabitAlarms (package:habitv8/services/notification_service.dart:1551:15)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 🐛 Alarm enabled: true
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (13536): │ #1   NotificationService.scheduleHabitAlarms (package:habitv8/services/notification_service.dart:1552:15)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 🐛 Alarm sound: Full of Wonder
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (13536): │ #1   NotificationService.scheduleHabitAlarms (package:habitv8/services/notification_service.dart:1553:15)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 🐛 Snooze delay: 10 minutes (fixed default)
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (13536): │ #1   NotificationService.scheduleHabitAlarms (package:habitv8/services/notification_service.dart:1580:17)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 🐛 Scheduling alarm for 13:17
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (13536): │ #1   HybridAlarmService.cancelHabitAlarms (package:habitv8/services/hybrid_alarm_service.dart:384:15)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 💡 🔄 Cancelling all alarms for habit:
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (13536): │ #1   HybridAlarmService.cancelHabitAlarms (package:habitv8/services/hybrid_alarm_service.dart:410:15)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 💡 ✅ Cancelled alarms for habit
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (13536): │ #1   NotificationService.scheduleHabitAlarms (package:habitv8/services/notification_service.dart:1588:17)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 🐛 Cancelled existing alarms for habit ID: 1757448918238
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (13536): │ #1   NotificationService.scheduleHabitAlarms (package:habitv8/services/notification_service.dart:1591:17)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 🐛 Habit frequency: daily
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (13536): │ #1   NotificationService.scheduleHabitAlarms (package:habitv8/services/notification_service.dart:1595:21)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 🐛 Scheduling daily alarms
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (13536): │ #1   HybridAlarmService.scheduleExactAlarm (package:habitv8/services/hybrid_alarm_service.dart:74:15)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 💡 🔄 Scheduling exact alarm:
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (13536): │ #1   HybridAlarmService.scheduleExactAlarm (package:habitv8/services/hybrid_alarm_service.dart:75:15)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 💡   - Alarm ID: 96
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (13536): │ #1   HybridAlarmService.scheduleExactAlarm (package:habitv8/services/hybrid_alarm_service.dart:76:15)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 💡   - Habit: ghost
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (13536): │ #1   HybridAlarmService.scheduleExactAlarm (package:habitv8/services/hybrid_alarm_service.dart:77:15)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 💡   - Scheduled time: 2025-09-09 13:17:00.000
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (13536): │ #1   HybridAlarmService.scheduleExactAlarm (package:habitv8/services/hybrid_alarm_service.dart:78:15)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 💡   - Sound: Full of Wonder
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
D/AlarmApiImpl(13536): Warning notification is already turned off.
D/AlarmApiImpl(13536): Alarm stopped notification for 96 was processed successfully by Flutter.
D/AlarmApiImpl(13536): Warning notification turned on.
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (13536): │ #1   HybridAlarmService.scheduleExactAlarm (package:habitv8/services/hybrid_alarm_service.dart:103:17)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 💡 ✅ Exact alarm scheduled successfully
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (13536): │ #1   NotificationService._scheduleDailyHabitAlarmsNew (package:habitv8/services/notification_service.dart:2846:15)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 💡 ✅ Scheduled daily alarms for ghost
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (13536): │ #1   NotificationService.scheduleHabitAlarms (package:habitv8/services/notification_service.dart:1624:17)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 🐛 Successfully scheduled alarms for habit: ghost
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (13536): │ #1   NotificationService.scheduleHabitAlarms (package:habitv8/services/notification_service.dart:1625:17)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 💡 Successfully scheduled alarms for habit: ghost
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (13536): │ #1   _CreateHabitScreenState._saveHabit (package:habitv8/ui/screens/create_habit_screen.dart:1630:21)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 💡 Notifications/alarms scheduled successfully for habit: ghost
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (13536): │ #1   _CreateHabitScreenState._saveHabit (package:habitv8/ui/screens/create_habit_screen.dart:1654:19)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 💡 Habit created: ghost
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (13536): │ #1   _CreateHabitScreenState._buildFrequencySection (package:habitv8/ui/screens/create_habit_screen.dart:407:15)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 🐛 Building frequency section, current frequency: HabitFrequency.daily
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
D/WindowOnBackDispatcher(13536): setTopOnBackInvokedCallback (unwrapped): android.app.Activity$$ExternalSyntheticLambda0@818e102
D/WindowOnBackDispatcher(13536): setTopOnBackInvokedCallback (unwrapped): androidx.activity.OnBackPressedDispatcher$Api34Impl$createOnBackAnimationCallback$1@d235770
D/WindowOnBackDispatcher(13536): setTopOnBackInvokedCallback (unwrapped): android.app.Activity$$ExternalSyntheticLambda0@818e102
D/ImeBackDispatcher(13536): Clear (mImeCallbacks.size=0)
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (13536): │ #1   AppLifecycleService.didChangeAppLifecycleState (package:habitv8/services/app_lifecycle_service.dart:61:15)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 💡 📱 App lifecycle state changed to: AppLifecycleState.inactive
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (13536): │ #1   AppLifecycleService.didChangeAppLifecycleState (package:habitv8/services/app_lifecycle_service.dart:79:19)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 💡 ⏹️ App inactive
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
D/VRI[MainActivity](13536): visibilityChanged oldVisibility=true newVisibility=false
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (13536): │ #1   AppLifecycleService.didChangeAppLifecycleState (package:habitv8/services/app_lifecycle_service.dart:61:15)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 💡 📱 App lifecycle state changed to: AppLifecycleState.hidden
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (13536): │ #1   AppLifecycleService.didChangeAppLifecycleState (package:habitv8/services/app_lifecycle_service.dart:82:19)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 💡 👁️ App hidden
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (13536): │ #1   AppLifecycleService.didChangeAppLifecycleState (package:habitv8/services/app_lifecycle_service.dart:61:15)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 💡 📱 App lifecycle state changed to: AppLifecycleState.paused
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (13536): │ #1   AppLifecycleService.didChangeAppLifecycleState (package:habitv8/services/app_lifecycle_service.dart:71:19)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 💡 ⏸️ App paused - performing background cleanup...
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (13536): │ #1   AppLifecycleService._performBackgroundCleanup (package:habitv8/services/app_lifecycle_service.dart:142:17)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 🐛 🧹 Performing background cleanup...
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.debug (package:habitv8/services/logging_service.dart:16:13)
I/flutter (13536): │ #1   AppLifecycleService._performBackgroundCleanup (package:habitv8/services/app_lifecycle_service.dart:147:17)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 🐛 ✅ Background cleanup completed
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/Choreographer(13536): Skipped 67 frames!  The application may be doing too much work on its main thread.
D/ImeBackDispatcher(13536): Clear (mImeCallbacks.size=0)
D/ImeBackDispatcher(13536): switch root view (mImeCallbacks.size=0)
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (13536): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:41:15)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 💡 🔍 Checking notification callback registration...
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (13536): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:42:15)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 💡 📦 Container available: true
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (13536): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:43:15)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 💡 🔗 Callback currently set: true
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (13536): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (13536): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:54:17)
I/flutter (13536): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (13536): │ 💡 ✅ Notification action callback is properly registered
I/flutter (13536): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
D/ImeBackDispatcher(13536): Clear (mImeCallbacks.size=0)
D/ImeBackDispatcher(13536): Clear (mImeCallbacks.size=0)
E/MediaPlayerNative(13536): error (1, -2147483648)
W/System.err(13536): java.io.IOException: Prepare failed.: status=0x1
W/System.err(13536):    at android.media.MediaPlayer._prepare(Native Method)
W/System.err(13536):    at android.media.MediaPlayer.prepare(MediaPlayer.java:1339)
W/System.err(13536):    at com.gdelataillade.alarm.services.AudioService.playAudio-51bEbmg(AudioService.kt:71)
W/System.err(13536):    at com.gdelataillade.alarm.alarm.AlarmService.onStartCommand(AlarmService.kt:161)
W/System.err(13536):    at android.app.ActivityThread.handleServiceArgs(ActivityThread.java:5511)
W/System.err(13536):    at android.app.ActivityThread.-$$Nest$mhandleServiceArgs(Unknown Source:0)
W/System.err(13536):    at android.app.ActivityThread$H.handleMessage(ActivityThread.java:2654)
W/System.err(13536):    at android.os.Handler.dispatchMessage(Handler.java:110)
W/System.err(13536):    at android.os.Looper.dispatchMessage(Looper.java:315)
W/System.err(13536):    at android.os.Looper.loopOnce(Looper.java:251)
W/System.err(13536):    at android.os.Looper.loop(Looper.java:349)
W/System.err(13536):    at android.app.ActivityThread.main(ActivityThread.java:9041)
W/System.err(13536):    at java.lang.reflect.Method.invoke(Native Method)
W/System.err(13536):    at com.android.internal.os.RuntimeInit$MethodAndArgsCaller.run(RuntimeInit.java:593)
W/System.err(13536):    at com.android.internal.os.ZygoteInit.main(ZygoteInit.java:929)
E/AudioService(13536): Error playing audio: java.io.IOException: Prepare failed.: status=0x1
D/AlarmService(13536): Turning off the warning notification.
D/AlarmService(13536): Alarm rang notification for 96 was processed successfully by Flutter.
E/TransactionExecutor(13536): Failed to execute the transaction: tId:1057327873 ClientTransaction{
E/TransactionExecutor(13536): tId:1057327873   transactionItems=[
E/TransactionExecutor(13536): tId:1057327873     NewIntentItem{mActivityToken=android.os.BinderProxy@bd4b486,intents=[Intent { act=android.intent.action.MAIN cat=[android.intent.category.LAUNCHER] flg=0x10000000 xflg=0x4 pkg=com.habittracker.habitv8.debug cmp=com.habittracker.habitv8.debug/com.habittracker.habitv8.MainActivity }],resume=false}
E/TransactionExecutor(13536): tId:1057327873     Target activity: com.habittracker.habitv8.MainActivity
E/TransactionExecutor(13536): tId:1057327873     TopResumedActivityChangeItem{mActivityToken=android.os.BinderProxy@bd4b486,onTop=true}
E/TransactionExecutor(13536): tId:1057327873     Target activity: com.habittracker.habitv8.MainActivity
E/TransactionExecutor(13536): tId:1057327873     ResumeActivityItem{mActivityToken=android.os.BinderProxy@bd4b486,procState=12,isForward=true,shouldSendCompatFakeFocus=false}
E/TransactionExecutor(13536): tId:1057327873     Target activity: com.habittracker.habitv8.MainActivity
E/TransactionExecutor(13536): tId:1057327873     TopResumedActivityChangeItem{mActivityToken=android.os.BinderProxy@bd4b486,onTop=false}
E/TransactionExecutor(13536): tId:1057327873     Target activity: com.habittracker.habitv8.MainActivity
E/TransactionExecutor(13536): tId:1057327873     PauseActivityItem{mActivityToken=android.os.BinderProxy@bd4b486,finished=false,userLeaving=true,dontReport=false,autoEnteringPip=false}
E/TransactionExecutor(13536): tId:1057327873     Target activity: com.habittracker.habitv8.MainActivity
E/TransactionExecutor(13536): tId:1057327873   ]
E/TransactionExecutor(13536): tId:1057327873 }
D/AndroidRuntime(13536): Shutting down VM
E/AndroidRuntime(13536): FATAL EXCEPTION: main
E/AndroidRuntime(13536): Process: com.habittracker.habitv8.debug, PID: 13536
E/AndroidRuntime(13536): android.database.StaleDataException: Attempted to access a cursor after it has been closed.
E/AndroidRuntime(13536):        at android.database.BulkCursorToCursorAdaptor.throwIfCursorIsClosed(BulkCursorToCursorAdaptor.java:63)
E/AndroidRuntime(13536):        at android.database.BulkCursorToCursorAdaptor.requery(BulkCursorToCursorAdaptor.java:132)
E/AndroidRuntime(13536):        at android.database.CursorWrapper.requery(CursorWrapper.java:233)
E/AndroidRuntime(13536):        at android.app.Activity.performRestart(Activity.java:9354)
E/AndroidRuntime(13536):        at android.app.ActivityThread.performRestartActivity(ActivityThread.java:6151)
E/AndroidRuntime(13536):        at android.app.servertransaction.TransactionExecutor.performLifecycleSequence(TransactionExecutor.java:239)
E/AndroidRuntime(13536):        at android.app.servertransaction.TransactionExecutor.cycleToPath(TransactionExecutor.java:194)
E/AndroidRuntime(13536):        at android.app.servertransaction.TransactionExecutor.executeLifecycleItem(TransactionExecutor.java:166)
E/AndroidRuntime(13536):        at android.app.servertransaction.TransactionExecutor.executeTransactionItems(TransactionExecutor.java:101)
E/AndroidRuntime(13536):        at android.app.servertransaction.TransactionExecutor.execute(TransactionExecutor.java:80)
E/AndroidRuntime(13536):        at android.app.ActivityThread$H.handleMessage(ActivityThread.java:2830)
E/AndroidRuntime(13536):        at android.os.Handler.dispatchMessage(Handler.java:110)
E/AndroidRuntime(13536):        at android.os.Looper.dispatchMessage(Looper.java:315)
E/AndroidRuntime(13536):        at android.os.Looper.loopOnce(Looper.java:251)
E/AndroidRuntime(13536):        at android.os.Looper.loop(Looper.java:349)
E/AndroidRuntime(13536):        at android.app.ActivityThread.main(ActivityThread.java:9041)
E/AndroidRuntime(13536):        at java.lang.reflect.Method.invoke(Native Method)
E/AndroidRuntime(13536):        at com.android.internal.os.RuntimeInit$MethodAndArgsCaller.run(RuntimeInit.java:593)
E/AndroidRuntime(13536):        at com.android.internal.os.ZygoteInit.main(ZygoteInit.java:929)
I/Process (13536): Sending signal. PID: 13536 SIG: 9
Lost connection to device.
PS C:\HabitV8> 