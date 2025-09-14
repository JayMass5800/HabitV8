I/Choreographer(24578): Skipped 70 frames!  The application may be doing too much work on its main thread.
D/ImeBackDispatcher(24578): Clear (mImeCallbacks.size=0)
D/ImeBackDispatcher(24578): switch root view (mImeCallbacks.size=0)
D/ImeBackDispatcher(24578): Clear (mImeCallbacks.size=0)
W/JobInfo (24578): Job 'com.habittracker.habitv8.debug/dev.fluttercommunity.plus.androidalarmmanager.AlarmService#1984' has a deadline with no functional constraints. The deadline won't improve job execution latency. Consider removing the deadline.
I/flutter (24578): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (24578): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (24578): │ #1   playAlarmSound (package:habitv8/alarm_callback.dart:15:15)
I/flutter (24578): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (24578): │ 💡 Alarm fired for ID: 303754
I/flutter (24578): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
W/AlarmService(24578): Attempted to start a duplicate background isolate. Returning...
I/flutter (24578): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (24578): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (24578): │ #1   playAlarmSound (package:habitv8/alarm_callback.dart:21:17)
I/flutter (24578): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (24578): │ 💡 AndroidAlarmManager initialized for isolate
I/flutter (24578): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (24578): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (24578): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (24578): │ #1   _executeBackgroundAlarm (package:habitv8/alarm_callback.dart:142:15)
I/flutter (24578): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (24578): │ 💡 🔊 Executing background alarm for: asd with sound: Jump-Start (URI: )
I/flutter (24578): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (24578): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (24578): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (24578): │ #1   _executeBackgroundAlarm (package:habitv8/alarm_callback.dart:256:15)
I/flutter (24578): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (24578): │ 💡 ✅ Background alarm executed for: asd
I/flutter (24578): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (24578): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (24578): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (24578): │ #1   _removeAlarmDataFile (package:habitv8/alarm_callback.dart:127:17)
I/flutter (24578): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (24578): │ 💡 Alarm data file removed for ID: 303754
I/flutter (24578): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
D/MainActivity(24578): onNewIntent called with action: SELECT_NOTIFICATION
D/MainActivity(24578): Handled SELECT_NOTIFICATION without calling super.onNewIntent
E/TransactionExecutor(24578): Failed to execute the transaction: tId:533345967 ClientTransaction{
E/TransactionExecutor(24578): tId:533345967   transactionItems=[
E/TransactionExecutor(24578): tId:533345967     NewIntentItem{mActivityToken=android.os.BinderProxy@5b11bd,intents=[Intent { act=SELECT_NOTIFICATION cat=[android.intent.category.LAUNCHER] flg=0x10000000 xflg=0x4 pkg=com.habittracker.habitv8.debug cmp=com.habittracker.habitv8.debug/com.habittracker.habitv8.MainActivity (has extras) }],resume=false}
E/TransactionExecutor(24578): tId:533345967     Target activity: com.habittracker.habitv8.MainActivity
E/TransactionExecutor(24578): tId:533345967     TopResumedActivityChangeItem{mActivityToken=android.os.BinderProxy@5b11bd,onTop=true}
E/TransactionExecutor(24578): tId:533345967     Target activity: com.habittracker.habitv8.MainActivity
E/TransactionExecutor(24578): tId:533345967     ResumeActivityItem{mActivityToken=android.os.BinderProxy@5b11bd,procState=12,isForward=true,shouldSendCompatFakeFocus=false}
E/TransactionExecutor(24578): tId:533345967     Target activity: com.habittracker.habitv8.MainActivity
E/TransactionExecutor(24578): tId:533345967     TopResumedActivityChangeItem{mActivityToken=android.os.BinderProxy@5b11bd,onTop=false}
E/TransactionExecutor(24578): tId:533345967     Target activity: com.habittracker.habitv8.MainActivity
E/TransactionExecutor(24578): tId:533345967     PauseActivityItem{mActivityToken=android.os.BinderProxy@5b11bd,finished=false,userLeaving=true,dontReport=false,autoEnteringPip=false}
E/TransactionExecutor(24578): tId:533345967     Target activity: com.habittracker.habitv8.MainActivity
E/TransactionExecutor(24578): tId:533345967   ]
E/TransactionExecutor(24578): tId:533345967 }
D/AndroidRuntime(24578): Shutting down VM
E/AndroidRuntime(24578): FATAL EXCEPTION: main
E/AndroidRuntime(24578): Process: com.habittracker.habitv8.debug, PID: 24578
E/AndroidRuntime(24578): android.database.StaleDataException: Attempted to access a cursor after it has been closed.
E/AndroidRuntime(24578):        at android.database.BulkCursorToCursorAdaptor.throwIfCursorIsClosed(BulkCursorToCursorAdaptor.java:63)
E/AndroidRuntime(24578):        at android.database.BulkCursorToCursorAdaptor.requery(BulkCursorToCursorAdaptor.java:132)
E/AndroidRuntime(24578):        at android.database.CursorWrapper.requery(CursorWrapper.java:233)
E/AndroidRuntime(24578):        at android.app.Activity.performRestart(Activity.java:9354)
E/AndroidRuntime(24578):        at android.app.ActivityThread.performRestartActivity(ActivityThread.java:6151)
E/AndroidRuntime(24578):        at android.app.servertransaction.TransactionExecutor.performLifecycleSequence(TransactionExecutor.java:239)
E/AndroidRuntime(24578):        at android.app.servertransaction.TransactionExecutor.cycleToPath(TransactionExecutor.java:194)
E/AndroidRuntime(24578):        at android.app.servertransaction.TransactionExecutor.executeLifecycleItem(TransactionExecutor.java:166)
E/AndroidRuntime(24578):        at android.app.servertransaction.TransactionExecutor.executeTransactionItems(TransactionExecutor.java:101)
E/AndroidRuntime(24578):        at android.app.servertransaction.TransactionExecutor.execute(TransactionExecutor.java:80)
E/AndroidRuntime(24578):        at android.app.ActivityThread$H.handleMessage(ActivityThread.java:2830)
E/AndroidRuntime(24578):        at android.os.Handler.dispatchMessage(Handler.java:110)
E/AndroidRuntime(24578):        at android.os.Looper.dispatchMessage(Looper.java:315)
E/AndroidRuntime(24578):        at android.os.Looper.loopOnce(Looper.java:251)
E/AndroidRuntime(24578):        at android.os.Looper.loop(Looper.java:349)
E/AndroidRuntime(24578):        at android.app.ActivityThread.main(ActivityThread.java:9041)
E/AndroidRuntime(24578):        at java.lang.reflect.Method.invoke(Native Method)
E/AndroidRuntime(24578):        at com.android.internal.os.RuntimeInit$MethodAndArgsCaller.run(RuntimeInit.java:593)
E/AndroidRuntime(24578):        at com.android.internal.os.ZygoteInit.main(ZygoteInit.java:929)
I/Process (24578): Sending signal. PID: 24578 SIG: 9
Lost connection to device.