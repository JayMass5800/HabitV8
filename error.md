D/ImeBackDispatcher(17544): Clear (mImeCallbacks.size=0)
D/ImeBackDispatcher(17544): switch root view (mImeCallbacks.size=0)
D/ViewRootImpl(17544): Skipping stats log for color mode
E/TransactionExecutor(17544): Failed to execute the transaction: tId:2113527192 ClientTransaction{
E/TransactionExecutor(17544): tId:2113527192   transactionItems=[
E/TransactionExecutor(17544): tId:2113527192     TopResumedActivityChangeItem{mActivityToken=android.os.BinderProxy@2dbb49f,onTop=true}
E/TransactionExecutor(17544): tId:2113527192     Target activity: com.habittracker.habitv8.MainActivity
E/TransactionExecutor(17544): tId:2113527192     NewIntentItem{mActivityToken=android.os.BinderProxy@2dbb49f,intents=[Intent { act=SELECT_FOREGROUND_NOTIFICATION cat=[android.intent.category.LAUNCHER] flg=0x10400000 xflg=0x4 pkg=com.habittracker.habitv8.debug cmp=com.habittracker.habitv8.debug/com.habittracker.habitv8.MainActivity (has extras) }],resume=true}
E/TransactionExecutor(17544): tId:2113527192     Target activity: com.habittracker.habitv8.MainActivity
E/TransactionExecutor(17544): tId:2113527192     ResumeActivityItem{mActivityToken=android.os.BinderProxy@2dbb49f,procState=2,isForward=true,shouldSendCompatFakeFocus=false}
E/TransactionExecutor(17544): tId:2113527192     Target activity: com.habittracker.habitv8.MainActivity
E/TransactionExecutor(17544): tId:2113527192   ]
E/TransactionExecutor(17544): tId:2113527192 }
D/AndroidRuntime(17544): Shutting down VM
E/AndroidRuntime(17544): FATAL EXCEPTION: main
E/AndroidRuntime(17544): Process: com.habittracker.habitv8.debug, PID: 17544
E/AndroidRuntime(17544): android.database.StaleDataException: Attempted to access a cursor after it has been closed.
E/AndroidRuntime(17544):        at android.database.BulkCursorToCursorAdaptor.throwIfCursorIsClosed(BulkCursorToCursorAdaptor.java:63)
E/AndroidRuntime(17544):        at android.database.BulkCursorToCursorAdaptor.requery(BulkCursorToCursorAdaptor.java:132)
E/AndroidRuntime(17544):        at android.database.CursorWrapper.requery(CursorWrapper.java:233)
E/AndroidRuntime(17544):        at android.app.Activity.performRestart(Activity.java:9354)
E/AndroidRuntime(17544):        at android.app.ActivityThread.performRestartActivity(ActivityThread.java:6151)
E/AndroidRuntime(17544):        at android.app.servertransaction.TransactionExecutor.performLifecycleSequence(TransactionExecutor.java:239)
E/AndroidRuntime(17544):        at android.app.servertransaction.TransactionExecutor.cycleToPath(TransactionExecutor.java:194)
E/AndroidRuntime(17544):        at android.app.servertransaction.TransactionExecutor.cycleToPath(TransactionExecutor.java:176)
E/AndroidRuntime(17544):        at android.app.servertransaction.TransactionExecutor.executeNonLifecycleItem(TransactionExecutor.java:129)
E/AndroidRuntime(17544):        at android.app.servertransaction.TransactionExecutor.executeTransactionItems(TransactionExecutor.java:103)
E/AndroidRuntime(17544):        at android.app.servertransaction.TransactionExecutor.execute(TransactionExecutor.java:80)
E/AndroidRuntime(17544):        at android.app.ActivityThread$H.handleMessage(ActivityThread.java:2830)
E/AndroidRuntime(17544):        at android.os.Handler.dispatchMessage(Handler.java:110)
E/AndroidRuntime(17544):        at android.os.Looper.dispatchMessage(Looper.java:315)
E/AndroidRuntime(17544):        at android.os.Looper.loopOnce(Looper.java:251)
E/AndroidRuntime(17544):        at android.os.Looper.loop(Looper.java:349)
E/AndroidRuntime(17544):        at android.app.ActivityThread.main(ActivityThread.java:9041)
E/AndroidRuntime(17544):        at java.lang.reflect.Method.invoke(Native Method)
E/AndroidRuntime(17544):        at com.android.internal.os.RuntimeInit$MethodAndArgsCaller.run(RuntimeInit.java:593)
E/AndroidRuntime(17544):        at com.android.internal.os.ZygoteInit.main(ZygoteInit.java:929)
I/Process (17544): Sending signal. PID: 17544 SIG: 9
Lost connection to device.
PS C:\HabitV8> 