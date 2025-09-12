I/flutter (10101): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
D/ImeBackDispatcher(10101): Clear (mImeCallbacks.size=0)
D/ImeBackDispatcher(10101): switch root view (mImeCallbacks.size=0)
D/ViewRootImpl(10101): Skipping stats log for color mode
E/TransactionExecutor(10101): Failed to execute the transaction: tId:1964437759 ClientTransaction{
E/TransactionExecutor(10101): tId:1964437759   transactionItems=[
E/TransactionExecutor(10101): tId:1964437759     TopResumedActivityChangeItem{mActivityToken=android.os.BinderProxy@4dade3e,onTop=true}
E/TransactionExecutor(10101): tId:1964437759     Target activity: com.habittracker.habitv8.MainActivity
E/TransactionExecutor(10101): tId:1964437759     NewIntentItem{mActivityToken=android.os.BinderProxy@4dade3e,intents=[Intent { act=android.intent.action.MAIN cat=[android.intent.category.LAUNCHER] flg=0x10600000 xflg=0x4 cmp=com.habittracker.habitv8.debug/com.habittracker.habitv8.MainActivity bnds=[218,1628][409,1895] }],resume=true}
E/TransactionExecutor(10101): tId:1964437759     Target activity: com.habittracker.habitv8.MainActivity
E/TransactionExecutor(10101): tId:1964437759     ResumeActivityItem{mActivityToken=android.os.BinderProxy@4dade3e,procState=2,isForward=true,shouldSendCompatFakeFocus=false}
E/TransactionExecutor(10101): tId:1964437759     Target activity: com.habittracker.habitv8.MainActivity
E/TransactionExecutor(10101): tId:1964437759   ]
E/TransactionExecutor(10101): tId:1964437759 }
D/AndroidRuntime(10101): Shutting down VM
E/AndroidRuntime(10101): FATAL EXCEPTION: main
E/AndroidRuntime(10101): Process: com.habittracker.habitv8.debug, PID: 10101
E/AndroidRuntime(10101): android.database.StaleDataException: Attempted to access a cursor after it has been closed.
E/AndroidRuntime(10101):        at android.database.BulkCursorToCursorAdaptor.throwIfCursorIsClosed(BulkCursorToCursorAdaptor.java:63)
E/AndroidRuntime(10101):        at android.database.BulkCursorToCursorAdaptor.requery(BulkCursorToCursorAdaptor.java:132)
E/AndroidRuntime(10101):        at android.database.CursorWrapper.requery(CursorWrapper.java:233)
E/AndroidRuntime(10101):        at android.app.Activity.performRestart(Activity.java:9354)
E/AndroidRuntime(10101):        at android.app.ActivityThread.performRestartActivity(ActivityThread.java:6151)
E/AndroidRuntime(10101):        at android.app.servertransaction.TransactionExecutor.performLifecycleSequence(TransactionExecutor.java:239)
E/AndroidRuntime(10101):        at android.app.servertransaction.TransactionExecutor.cycleToPath(TransactionExecutor.java:194)
E/AndroidRuntime(10101):        at android.app.servertransaction.TransactionExecutor.cycleToPath(TransactionExecutor.java:176)
E/AndroidRuntime(10101):        at android.app.servertransaction.TransactionExecutor.executeNonLifecycleItem(TransactionExecutor.java:129)
E/AndroidRuntime(10101):        at android.app.servertransaction.TransactionExecutor.executeTransactionItems(TransactionExecutor.java:103)
E/AndroidRuntime(10101):        at android.app.servertransaction.TransactionExecutor.execute(TransactionExecutor.java:80)
E/AndroidRuntime(10101):        at android.app.ActivityThread$H.handleMessage(ActivityThread.java:2830)
E/AndroidRuntime(10101):        at android.os.Handler.dispatchMessage(Handler.java:110)
E/AndroidRuntime(10101):        at android.os.Looper.dispatchMessage(Looper.java:315)
E/AndroidRuntime(10101):        at android.os.Looper.loopOnce(Looper.java:251)
E/AndroidRuntime(10101):        at android.os.Looper.loop(Looper.java:349)
E/AndroidRuntime(10101):        at android.app.ActivityThread.main(ActivityThread.java:9041)
E/AndroidRuntime(10101):        at java.lang.reflect.Method.invoke(Native Method)
E/AndroidRuntime(10101):        at com.android.internal.os.RuntimeInit$MethodAndArgsCaller.run(RuntimeInit.java:593)
E/AndroidRuntime(10101):        at com.android.internal.os.ZygoteInit.main(ZygoteInit.java:929)
I/Process (10101): Sending signal. PID: 10101 SIG: 9
Lost connection to device.