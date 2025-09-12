/flutter (27136): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27136): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (27136): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:42:15)
I/flutter (27136): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27136): │ 💡 🔍 Checking notification callback registration...
I/flutter (27136): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27136): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27136): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (27136): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:43:15)
I/flutter (27136): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27136): │ 💡 📦 Container available: false
I/flutter (27136): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27136): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27136): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (27136): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:44:15)
I/flutter (27136): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27136): │ 💡 🔗 Callback currently set: false
I/flutter (27136): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27136): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (27136): │ #0   AppLogger.error (package:habitv8/services/logging_service.dart:28:13)
I/flutter (27136): │ #1   NotificationActionService.ensureCallbackRegistered (package:habitv8/services/notification_action_service.dart:57:17)
I/flutter (27136): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (27136): │ ⛔ ❌ Container is null - cannot register callback








flutter (27136): │ 🐛 ✅ Background cleanup completed
I/flutter (27136): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/Choreographer(27136): Skipped 79 frames!  The application may be doing too much work on its main thread.
D/ImeBackDispatcher(27136): Clear (mImeCallbacks.size=0)
D/ImeBackDispatcher(27136): switch root view (mImeCallbacks.size=0)
E/MediaPlayerNative(27136): error (1, -2147483648)
W/System.err(27136): java.io.IOException: Prepare failed.: status=0x1
W/System.err(27136):    at android.media.MediaPlayer._prepare(Native Method)
W/System.err(27136):    at android.media.MediaPlayer.prepare(MediaPlayer.java:1339)
W/System.err(27136):    at com.gdelataillade.alarm.services.AudioService.playAudio-51bEbmg(AudioService.kt:71)
W/System.err(27136):    at com.gdelataillade.alarm.alarm.AlarmService.onStartCommand(AlarmService.kt:161)
W/System.err(27136):    at android.app.ActivityThread.handleServiceArgs(ActivityThread.java:5511)
W/System.err(27136):    at android.app.ActivityThread.-$$Nest$mhandleServiceArgs(Unknown Source:0)
W/System.err(27136):    at android.app.ActivityThread$H.handleMessage(ActivityThread.java:2654)
W/System.err(27136):    at android.os.Handler.dispatchMessage(Handler.java:110)
W/System.err(27136):    at android.os.Looper.dispatchMessage(Looper.java:315)
W/System.err(27136):    at android.os.Looper.loopOnce(Looper.java:251)
W/System.err(27136):    at android.os.Looper.loop(Looper.java:349)
W/System.err(27136):    at android.app.ActivityThread.main(ActivityThread.java:9041)
W/System.err(27136):    at java.lang.reflect.Method.invoke(Native Method)
W/System.err(27136):    at com.android.internal.os.RuntimeInit$MethodAndArgsCaller.run(RuntimeInit.java:593)
W/System.err(27136):    at com.android.internal.os.ZygoteInit.main(ZygoteInit.java:929)
E/AudioService(27136): Error playing audio: java.io.IOException: Prepare failed.: status=0x1
D/AlarmService(27136): Turning off the warning notification.
D/AlarmService(27136): Alarm rang notification for 96 was processed successfully by Flutter.
E/TransactionExecutor(27136): Failed to execute the transaction: tId:388867847 ClientTransaction{
E/TransactionExecutor(27136): tId:388867847   transactionItems=[
E/TransactionExecutor(27136): tId:388867847     NewIntentItem{mActivityToken=android.os.BinderProxy@fa23ef9,intents=[Intent { act=android.intent.action.MAIN cat=[android.intent.category.LAUNCHER] flg=0x10000000 xflg=0x4 pkg=com.habittracker.habitv8.debug cmp=com.habittracker.habitv8.debug/com.habittracker.habitv8.MainActivity }],resume=false}
E/TransactionExecutor(27136): tId:388867847     Target activity: com.habittracker.habitv8.MainActivity
E/TransactionExecutor(27136): tId:388867847     TopResumedActivityChangeItem{mActivityToken=android.os.BinderProxy@fa23ef9,onTop=true}
E/TransactionExecutor(27136): tId:388867847     Target activity: com.habittracker.habitv8.MainActivity
E/TransactionExecutor(27136): tId:388867847     ResumeActivityItem{mActivityToken=android.os.BinderProxy@fa23ef9,procState=12,isForward=true,shouldSendCompatFakeFocus=false}
E/TransactionExecutor(27136): tId:388867847     Target activity: com.habittracker.habitv8.MainActivity
E/TransactionExecutor(27136): tId:388867847     TopResumedActivityChangeItem{mActivityToken=android.os.BinderProxy@fa23ef9,onTop=false}
E/TransactionExecutor(27136): tId:388867847     Target activity: com.habittracker.habitv8.MainActivity
E/TransactionExecutor(27136): tId:388867847     PauseActivityItem{mActivityToken=android.os.BinderProxy@fa23ef9,finished=false,userLeaving=true,dontReport=false,autoEnteringPip=false}
E/TransactionExecutor(27136): tId:388867847     Target activity: com.habittracker.habitv8.MainActivity
E/TransactionExecutor(27136): tId:388867847   ]
E/TransactionExecutor(27136): tId:388867847 }
D/AndroidRuntime(27136): Shutting down VM
E/AndroidRuntime(27136): FATAL EXCEPTION: main
E/AndroidRuntime(27136): Process: com.habittracker.habitv8.debug, PID: 27136
E/AndroidRuntime(27136): android.database.StaleDataException: Attempted to access a cursor after it has been closed.
E/AndroidRuntime(27136):        at android.database.BulkCursorToCursorAdaptor.throwIfCursorIsClosed(BulkCursorToCursorAdaptor.java:63)
E/AndroidRuntime(27136):        at android.database.BulkCursorToCursorAdaptor.requery(BulkCursorToCursorAdaptor.java:132)
E/AndroidRuntime(27136):        at android.database.CursorWrapper.requery(CursorWrapper.java:233)
E/AndroidRuntime(27136):        at android.app.Activity.performRestart(Activity.java:9354)
E/AndroidRuntime(27136):        at android.app.ActivityThread.performRestartActivity(ActivityThread.java:6151)
E/AndroidRuntime(27136):        at android.app.servertransaction.TransactionExecutor.performLifecycleSequence(TransactionExecutor.java:239)
E/AndroidRuntime(27136):        at android.app.servertransaction.TransactionExecutor.cycleToPath(TransactionExecutor.java:194)
E/AndroidRuntime(27136):        at android.app.servertransaction.TransactionExecutor.executeLifecycleItem(TransactionExecutor.java:166)
E/AndroidRuntime(27136):        at android.app.servertransaction.TransactionExecutor.executeTransactionItems(TransactionExecutor.java:101)
E/AndroidRuntime(27136):        at android.app.servertransaction.TransactionExecutor.execute(TransactionExecutor.java:80)
E/AndroidRuntime(27136):        at android.app.ActivityThread$H.handleMessage(ActivityThread.java:2830)
E/AndroidRuntime(27136):        at android.os.Handler.dispatchMessage(Handler.java:110)
E/AndroidRuntime(27136):        at android.os.Looper.dispatchMessage(Looper.java:315)
E/AndroidRuntime(27136):        at android.os.Looper.loopOnce(Looper.java:251)
E/AndroidRuntime(27136):        at android.os.Looper.loop(Looper.java:349)
E/AndroidRuntime(27136):        at android.app.ActivityThread.main(ActivityThread.java:9041)
E/AndroidRuntime(27136):        at java.lang.reflect.Method.invoke(Native Method)
E/AndroidRuntime(27136):        at com.android.internal.os.RuntimeInit$MethodAndArgsCaller.run(RuntimeInit.java:593)
E/AndroidRuntime(27136):        at com.android.internal.os.ZygoteInit.main(ZygoteInit.java:929)
I/Process (27136): Sending signal. PID: 27136 SIG: 9
Lost connection to device.
