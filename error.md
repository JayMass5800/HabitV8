/flutter (19617): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (19617): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (19617): │ #1   _removeAlarmDataFile (package:habitv8/alarm_callback.dart:127:17)
I/flutter (19617): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (19617): │ 💡 Alarm data file removed for ID: 300707
I/flutter (19617): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
D/ViewRootImpl(19617): Skipping stats log for color mode
E/TransactionExecutor(19617): Failed to execute the transaction: tId:1276794255 ClientTransaction{
E/TransactionExecutor(19617): tId:1276794255   transactionItems=[
E/TransactionExecutor(19617): tId:1276794255     NewIntentItem{mActivityToken=android.os.BinderProxy@5b11bd,intents=[Intent { act=SELECT_NOTIFICATION cat=[android.intent.category.LAUNCHER] flg=0x10000000 xflg=0x4 pkg=com.habittracker.habitv8.debug cmp=com.habittracker.habitv8.debug/com.habittracker.habitv8.MainActivity (has extras) }],resume=false}
E/TransactionExecutor(19617): tId:1276794255     Target activity: com.habittracker.habitv8.MainActivity
E/TransactionExecutor(19617): tId:1276794255     TopResumedActivityChangeItem{mActivityToken=android.os.BinderProxy@5b11bd,onTop=true}
E/TransactionExecutor(19617): tId:1276794255     Target activity: com.habittracker.habitv8.MainActivity
E/TransactionExecutor(19617): tId:1276794255     ResumeActivityItem{mActivityToken=android.os.BinderProxy@5b11bd,procState=12,isForward=true,shouldSendCompatFakeFocus=false}
E/TransactionExecutor(19617): tId:1276794255     Target activity: com.habittracker.habitv8.MainActivity
E/TransactionExecutor(19617): tId:1276794255     TopResumedActivityChangeItem{mActivityToken=android.os.BinderProxy@5b11bd,onTop=false}
E/TransactionExecutor(19617): tId:1276794255     Target activity: com.habittracker.habitv8.MainActivity
E/TransactionExecutor(19617): tId:1276794255     PauseActivityItem{mActivityToken=android.os.BinderProxy@5b11bd,finished=false,userLeaving=true,dontReport=false,autoEnteringPip=false}
E/TransactionExecutor(19617): tId:1276794255     Target activity: com.habittracker.habitv8.MainActivity
E/TransactionExecutor(19617): tId:1276794255   ]
E/TransactionExecutor(19617): tId:1276794255 }
D/AndroidRuntime(19617): Shutting down VM
E/AndroidRuntime(19617): FATAL EXCEPTION: main
E/AndroidRuntime(19617): Process: com.habittracker.habitv8.debug, PID: 19617
E/AndroidRuntime(19617): android.database.StaleDataException: Attempted to access a cursor after it has been closed.
E/AndroidRuntime(19617):        at android.database.BulkCursorToCursorAdaptor.throwIfCursorIsClosed(BulkCursorToCursorAdaptor.java:63)
E/AndroidRuntime(19617):        at android.database.BulkCursorToCursorAdaptor.requery(BulkCursorToCursorAdaptor.java:132)
E/AndroidRuntime(19617):        at android.database.CursorWrapper.requery(CursorWrapper.java:233)
E/AndroidRuntime(19617):        at android.app.Activity.performRestart(Activity.java:9354)
E/AndroidRuntime(19617):        at android.app.ActivityThread.performRestartActivity(ActivityThread.java:6151)
E/AndroidRuntime(19617):        at android.app.servertransaction.TransactionExecutor.performLifecycleSequence(TransactionExecutor.java:239)
E/AndroidRuntime(19617):        at android.app.servertransaction.TransactionExecutor.cycleToPath(TransactionExecutor.java:194)
E/AndroidRuntime(19617):        at android.app.servertransaction.TransactionExecutor.executeLifecycleItem(TransactionExecutor.java:166)
E/AndroidRuntime(19617):        at android.app.servertransaction.TransactionExecutor.executeTransactionItems(TransactionExecutor.java:101)
E/AndroidRuntime(19617):        at android.app.servertransaction.TransactionExecutor.execute(TransactionExecutor.java:80)
E/AndroidRuntime(19617):        at android.app.ActivityThread$H.handleMessage(ActivityThread.java:2830)
E/AndroidRuntime(19617):        at android.os.Handler.dispatchMessage(Handler.java:110)
E/AndroidRuntime(19617):        at android.os.Looper.dispatchMessage(Looper.java:315)
E/AndroidRuntime(19617):        at android.os.Looper.loopOnce(Looper.java:251)
E/AndroidRuntime(19617):        at android.os.Looper.loop(Looper.java:349)
E/AndroidRuntime(19617):        at android.app.ActivityThread.main(ActivityThread.java:9041)
E/AndroidRuntime(19617):        at java.lang.reflect.Method.invoke(Native Method)
E/AndroidRuntime(19617):        at com.android.internal.os.RuntimeInit$MethodAndArgsCaller.run(RuntimeInit.java:593)
E/AndroidRuntime(19617):        at com.android.internal.os.ZygoteInit.main(ZygoteInit.java:929)
I/Process (19617): Sending signal. PID: 19617 SIG: 9
Lost connection to device.