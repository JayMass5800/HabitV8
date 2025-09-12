I/flutter (26777): [IMPORTANT:flutter/shell/platform/android/android_context_vk_impeller.cc(62)] Using the Impeller rendering backend (Vulkan).
I/flutter (26777): Background sync: Starting health data sync...
I/flutter (26777): [Health] Health Connect available: true
I/flutter (26777): [Health][pre] HEART_RATE => denied
I/flutter (26777): [Health][pre] RESTING_HEART_RATE => denied
I/flutter (26777): [Health][pre] SLEEP_ASLEEP => denied
I/flutter (26777): [Health][pre] STEPS => denied
I/flutter (26777): [Health][pre] ACTIVE_ENERGY_BURNED => denied
I/flutter (26777): [Health][pre] WEIGHT => denied
I/flutter (26777): [Health][pre] WATER => denied
I/flutter (26777): [Health][pre] TOTAL_CALORIES_BURNED => denied
I/flutter (26777): Error requesting permissions: PlatformException(PermissionHandler.PermissionManager, Unable to detect current Android Activity., null, null)
I/flutter (26777): [Health] Authorization batch failed
I/flutter (26777): [Health][post-request (batch=false)] HEART_RATE => denied
I/flutter (26777): [Health][post-request (batch=false)] RESTING_HEART_RATE => denied
I/flutter (26777): [Health][post-request (batch=false)] SLEEP_ASLEEP => denied
I/flutter (26777): [Health][post-request (batch=false)] STEPS => denied
I/flutter (26777): [Health][post-request (batch=false)] ACTIVE_ENERGY_BURNED => denied
I/flutter (26777): [Health][post-request (batch=false)] WEIGHT => denied
I/flutter (26777): [Health][post-request (batch=false)] WATER => denied
I/flutter (26777): [Health][post-request (batch=false)] TOTAL_CALORIES_BURNED => denied
I/flutter (26777): Error initializing health service: Exception: Health permissions not granted
I/flutter (26777): Background sync: Failed to initialize health service
E/MediaPlayerNative(16136): error (1, -2147483648)
W/System.err(16136): java.io.IOException: Prepare failed.: status=0x1
W/System.err(16136):    at android.media.MediaPlayer._prepare(Native Method)
W/System.err(16136):    at android.media.MediaPlayer.prepare(MediaPlayer.java:1339)
W/System.err(16136):    at com.gdelataillade.alarm.services.AudioService.playAudio-51bEbmg(AudioService.kt:71)
W/System.err(16136):    at com.gdelataillade.alarm.alarm.AlarmService.onStartCommand(AlarmService.kt:161)
W/System.err(16136):    at android.app.ActivityThread.handleServiceArgs(ActivityThread.java:5511)
W/System.err(16136):    at android.app.ActivityThread.-$$Nest$mhandleServiceArgs(Unknown Source:0)
W/System.err(16136):    at android.app.ActivityThread$H.handleMessage(ActivityThread.java:2654)
W/System.err(16136):    at android.os.Handler.dispatchMessage(Handler.java:110)
W/System.err(16136):    at android.os.Looper.dispatchMessage(Looper.java:315)
W/System.err(16136):    at android.os.Looper.loopOnce(Looper.java:251)
W/System.err(16136):    at android.os.Looper.loop(Looper.java:349)
W/System.err(16136):    at android.app.ActivityThread.main(ActivityThread.java:9041)
W/System.err(16136):    at java.lang.reflect.Method.invoke(Native Method)
W/System.err(16136):    at com.android.internal.os.RuntimeInit$MethodAndArgsCaller.run(RuntimeInit.java:593)
W/System.err(16136):    at com.android.internal.os.ZygoteInit.main(ZygoteInit.java:929)
E/AudioService(16136): Error playing audio: java.io.IOException: Prepare failed.: status=0x1
D/AlarmService(16136): Turning off the warning notification.
D/ViewRootImpl(16136): Skipping stats log for color mode
E/TransactionExecutor(16136): Failed to execute the transaction: tId:1308032481 ClientTransaction{
E/TransactionExecutor(16136): tId:1308032481   transactionItems=[
E/TransactionExecutor(16136): tId:1308032481     NewIntentItem{mActivityToken=android.os.BinderProxy@720ab26,intents=[Intent { act=android.intent.action.MAIN cat=[android.intent.category.LAUNCHER] flg=0x10400000 xflg=0x4 pkg=com.habittracker.habitv8.debug cmp=com.habittracker.habitv8.debug/com.habittracker.habitv8.MainActivity }],resume=false}
E/TransactionExecutor(16136): tId:1308032481     Target activity: com.habittracker.habitv8.MainActivity
E/TransactionExecutor(16136): tId:1308032481     TopResumedActivityChangeItem{mActivityToken=android.os.BinderProxy@720ab26,onTop=true}
E/TransactionExecutor(16136): tId:1308032481     Target activity: com.habittracker.habitv8.MainActivity
E/TransactionExecutor(16136): tId:1308032481     ResumeActivityItem{mActivityToken=android.os.BinderProxy@720ab26,procState=12,isForward=true,shouldSendCompatFakeFocus=false}
E/TransactionExecutor(16136): tId:1308032481     Target activity: com.habittracker.habitv8.MainActivity
E/TransactionExecutor(16136): tId:1308032481     TopResumedActivityChangeItem{mActivityToken=android.os.BinderProxy@720ab26,onTop=false}
E/TransactionExecutor(16136): tId:1308032481     Target activity: com.habittracker.habitv8.MainActivity
E/TransactionExecutor(16136): tId:1308032481     PauseActivityItem{mActivityToken=android.os.BinderProxy@720ab26,finished=false,userLeaving=true,dontReport=false,autoEnteringPip=false}
E/TransactionExecutor(16136): tId:1308032481     Target activity: com.habittracker.habitv8.MainActivity
E/TransactionExecutor(16136): tId:1308032481   ]
E/TransactionExecutor(16136): tId:1308032481 }
D/AndroidRuntime(16136): Shutting down VM
E/AndroidRuntime(16136): FATAL EXCEPTION: main
E/AndroidRuntime(16136): Process: com.habittracker.habitv8.debug, PID: 16136
E/AndroidRuntime(16136): android.database.StaleDataException: Attempted to access a cursor after it has been closed.
E/AndroidRuntime(16136):        at android.database.BulkCursorToCursorAdaptor.throwIfCursorIsClosed(BulkCursorToCursorAdaptor.java:63)
E/AndroidRuntime(16136):        at android.database.BulkCursorToCursorAdaptor.requery(BulkCursorToCursorAdaptor.java:132)
E/AndroidRuntime(16136):        at android.database.CursorWrapper.requery(CursorWrapper.java:233)
E/AndroidRuntime(16136):        at android.app.Activity.performRestart(Activity.java:9354)
E/AndroidRuntime(16136):        at android.app.ActivityThread.performRestartActivity(ActivityThread.java:6151)
E/AndroidRuntime(16136):        at android.app.servertransaction.TransactionExecutor.performLifecycleSequence(TransactionExecutor.java:239)
E/AndroidRuntime(16136):        at android.app.servertransaction.TransactionExecutor.cycleToPath(TransactionExecutor.java:194)
E/AndroidRuntime(16136):        at android.app.servertransaction.TransactionExecutor.executeLifecycleItem(TransactionExecutor.java:166)
E/AndroidRuntime(16136):        at android.app.servertransaction.TransactionExecutor.executeTransactionItems(TransactionExecutor.java:101)
E/AndroidRuntime(16136):        at android.app.servertransaction.TransactionExecutor.execute(TransactionExecutor.java:80)
E/AndroidRuntime(16136):        at android.app.ActivityThread$H.handleMessage(ActivityThread.java:2830)
E/AndroidRuntime(16136):        at android.os.Handler.dispatchMessage(Handler.java:110)
E/AndroidRuntime(16136):        at android.os.Looper.dispatchMessage(Looper.java:315)
E/AndroidRuntime(16136):        at android.os.Looper.loopOnce(Looper.java:251)
E/AndroidRuntime(16136):        at android.os.Looper.loop(Looper.java:349)
E/AndroidRuntime(16136):        at android.app.ActivityThread.main(ActivityThread.java:9041)
E/AndroidRuntime(16136):        at java.lang.reflect.Method.invoke(Native Method)
E/AndroidRuntime(16136):        at com.android.internal.os.RuntimeInit$MethodAndArgsCaller.run(RuntimeInit.java:593)
E/AndroidRuntime(16136):        at com.android.internal.os.ZygoteInit.main(ZygoteInit.java:929)
I/Process (16136): Sending signal. PID: 16136 SIG: 9







I/flutter (15685): │ 💡 Complete action callback executed for habit: 1757638263819
I/flutter (15685): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15685): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15685): │ Exception: Habit service is still loading
I/flutter (15685): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15685): │ #0   AppLogger.error (package:habitv8/services/logging_service.dart:28:13)
I/flutter (15685): │ #1   NotificationActionService._handleCompleteAction (package:habitv8/services/notification_action_service.dart:245:17)
I/flutter (15685): │ #2   <asynchronous suspension>
I/flutter (15685): │ #3   NotificationActionService._handleNotificationAction (package:habitv8/services/notification_action_service.dart:84:11)
I/flutter (15685): │ #4   <asynchronous suspension>
I/flutter (15685): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15685): │ ⛔ Error in _handleCompleteAction for habit 1757638263819
I/flutter (15685): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15685): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15685): │ #0   AppLogger.error (package:habitv8/services/logging_service.dart:28:13)
I/flutter (15685): │ #1   NotificationActionService._handleCompleteAction (package:habitv8/services/notification_action_service.dart:246:17)
I/flutter (15685): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15685): │ ⛔ Stack trace: #0      NotificationActionService._handleCompleteAction.<anonymous closure> (package:habitv8/services/notification_action_service.dart:135:11)
I/flutter (15685): │ ⛔ #1      AsyncValueX.when (package:riverpod/src/common.dart:735:32)
I/flutter (15685): │ ⛔ #2      NotificationActionService._handleCompleteAction (package:habitv8/services/notification_action_service.dart:131:52)
I/flutter (15685): │ ⛔ #3      NotificationActionService._handleNotificationAction (package:habitv8/services/notification_action_service.dart:84:17)
I/flutter (15685): │ ⛔ #4      NotificationService._completeHabitFromNotification (package:habitv8/services/notification_service.dart:3759:30)
I/flutter (15685): │ ⛔ #5      NotificationService._processStoredAction (package:habitv8/services/notification_service.dart:1000:17)
I/flutter (15685): │ ⛔ #6      NotificationService._processActionsFromFile (package:habitv8/services/notification_service.dart:973:15)
I/flutter (15685): │ ⛔ #7      NotificationService.processPendingActions (package:habitv8/services/notification_service.dart:819:17)
I/flutter (15685): │ ⛔ <asynchronous suspension>
I/flutter (15685): │ ⛔ #8      NotificationService.processPendingActionsManually (package:habitv8/services/notification_service.dart:1214:7)
I/flutter (15685): │ ⛔ <asynchronous suspension>
I/flutter (15685): │ ⛔
I/flutter (15685): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15685): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15685): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (15685): │ #1   NotificationActionService._handleNotificationAction (package:habitv8/services/notification_action_service.dart:85:21)
I/flutter (15685): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15685): │ 💡 _handleCompleteAction completed for habit: 1757638263819
I/flutter (15685): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15685): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15685): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (15685): │ #1   NotificationService._processActionsFromFile (package:habitv8/services/notification_service.dart:981:19)
I/flutter (15685): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15685): │ 💡 Cleared processed actions from file
I/flutter (15685): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/r.habitv8.debug(15685): Background concurrent mark compact GC freed 9630KB AllocSpace bytes, 13(324KB) LOS objects, 87% free, 3409KB/27MB, paused 565us,5.655ms total 94.118ms
I/flutter (15685): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15685): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (15685): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:42:15)
I/flutter (15685): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15685): │ 💡 🔍 Checking notification callback registration...
I/flutter (15685): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15685): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15685): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (15685): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:43:15)
I/flutter (15685): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15685): │ 💡 📦 Container available: true
I/flutter (15685): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15685): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15685): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (15685): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:44:15)
I/flutter (15685): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15685): │ 💡 🔗 Callback currently set: true
I/flutter (15685): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15685): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (15685): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (15685): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:55:17)
I/flutter (15685): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (15685): │ 💡 ✅ Notification action callback is properly registered
I/flutter (15685): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
Lost connection to device.
PS C:\HabitV8>