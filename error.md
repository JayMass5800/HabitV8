tter (11604): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
E/TransactionExecutor(11604): Failed to execute the transaction: tId:1395825619 ClientTransaction{
E/TransactionExecutor(11604): tId:1395825619   transactionItems=[
E/TransactionExecutor(11604): tId:1395825619     NewIntentItem{mActivityToken=android.os.BinderProxy@2dbb49f,intents=[Intent { act=SELECT_NOTIFICATION cat=[android.intent.category.LAUNCHER] flg=0x10000000 xflg=0x4 pkg=com.habittracker.habitv8.debug cmp=com.habittracker.habitv8.debug/com.habittracker.habitv8.MainActivity (has extras) }],resume=false}
E/TransactionExecutor(11604): tId:1395825619     Target activity: com.habittracker.habitv8.MainActivity
E/TransactionExecutor(11604): tId:1395825619     TopResumedActivityChangeItem{mActivityToken=android.os.BinderProxy@2dbb49f,onTop=true}
E/TransactionExecutor(11604): tId:1395825619     Target activity: com.habittracker.habitv8.MainActivity
E/TransactionExecutor(11604): tId:1395825619     ResumeActivityItem{mActivityToken=android.os.BinderProxy@2dbb49f,procState=12,isForward=true,shouldSendCompatFakeFocus=false}
E/TransactionExecutor(11604): tId:1395825619     Target activity: com.habittracker.habitv8.MainActivity
E/TransactionExecutor(11604): tId:1395825619     TopResumedActivityChangeItem{mActivityToken=android.os.BinderProxy@2dbb49f,onTop=false}
E/TransactionExecutor(11604): tId:1395825619     Target activity: com.habittracker.habitv8.MainActivity
E/TransactionExecutor(11604): tId:1395825619     PauseActivityItem{mActivityToken=android.os.BinderProxy@2dbb49f,finished=false,userLeaving=true,dontReport=false,autoEnteringPip=false}
E/TransactionExecutor(11604): tId:1395825619     Target activity: com.habittracker.habitv8.MainActivity
E/TransactionExecutor(11604): tId:1395825619   ]
E/TransactionExecutor(11604): tId:1395825619 }
D/AndroidRuntime(11604): Shutting down VM
E/AndroidRuntime(11604): FATAL EXCEPTION: main
E/AndroidRuntime(11604): Process: com.habittracker.habitv8.debug, PID: 11604
E/AndroidRuntime(11604): android.database.StaleDataException: Attempted to access a cursor after it has been closed.
E/AndroidRuntime(11604):        at android.database.BulkCursorToCursorAdaptor.throwIfCursorIsClosed(BulkCursorToCursorAdaptor.java:63)
E/AndroidRuntime(11604):        at android.database.BulkCursorToCursorAdaptor.requery(BulkCursorToCursorAdaptor.java:132)
E/AndroidRuntime(11604):        at android.database.CursorWrapper.requery(CursorWrapper.java:233)
E/AndroidRuntime(11604):        at android.app.Activity.performRestart(Activity.java:9354)
E/AndroidRuntime(11604):        at android.app.ActivityThread.performRestartActivity(ActivityThread.java:6151)
E/AndroidRuntime(11604):        at android.app.servertransaction.TransactionExecutor.performLifecycleSequence(TransactionExecutor.java:239)
E/AndroidRuntime(11604):        at android.app.servertransaction.TransactionExecutor.cycleToPath(TransactionExecutor.java:194)
E/AndroidRuntime(11604):        at android.app.servertransaction.TransactionExecutor.executeLifecycleItem(TransactionExecutor.java:166)
E/AndroidRuntime(11604):        at android.app.servertransaction.TransactionExecutor.executeTransactionItems(TransactionExecutor.java:101)
E/AndroidRuntime(11604):        at android.app.servertransaction.TransactionExecutor.execute(TransactionExecutor.java:80)
E/AndroidRuntime(11604):        at android.app.ActivityThread$H.handleMessage(ActivityThread.java:2830)
E/AndroidRuntime(11604):        at android.os.Handler.dispatchMessage(Handler.java:110)
E/AndroidRuntime(11604):        at android.os.Looper.dispatchMessage(Looper.java:315)
E/AndroidRuntime(11604):        at android.os.Looper.loopOnce(Looper.java:251)
E/AndroidRuntime(11604):        at android.os.Looper.loop(Looper.java:349)
E/AndroidRuntime(11604):        at android.app.ActivityThread.main(ActivityThread.java:9041)
E/AndroidRuntime(11604):        at java.lang.reflect.Method.invoke(Native Method)
E/AndroidRuntime(11604):        at com.android.internal.os.RuntimeInit$MethodAndArgsCaller.run(RuntimeInit.java:593)
E/AndroidRuntime(11604):        at com.android.inter