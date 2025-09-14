I/FlutterBackgroundExecutor(24075): Starting AlarmService...
I/flutter (24075): [IMPORTANT:flutter/shell/platform/android/android_context_vk_impeller.cc(61)] Using the Impeller rendering backend (Vulkan).
I/AndroidAlarmManagerPlugin(24075): onAttachedToEngine
D/MainActivity(24075): Skipping super.onRestart to avoid cursor requery crash
E/TransactionExecutor(24075): Failed to execute the transaction: tId:-1249197115 ClientTransaction{
E/TransactionExecutor(24075): tId:-1249197115   transactionItems=[
E/TransactionExecutor(24075): tId:-1249197115     TopResumedActivityChangeItem{mActivityToken=android.os.BinderProxy@b5c53b2,onTop=true}
E/TransactionExecutor(24075): tId:-1249197115     Target activity: com.habittracker.habitv8.MainActivity
E/TransactionExecutor(24075): tId:-1249197115     ResumeActivityItem{mActivityToken=android.os.BinderProxy@b5c53b2,procState=2,isForward=false,shouldSendCompatFakeFocus=false}
E/TransactionExecutor(24075): tId:-1249197115     Target activity: com.habittracker.habitv8.MainActivity
E/TransactionExecutor(24075): tId:-1249197115   ]
E/TransactionExecutor(24075): tId:-1249197115 }
D/AndroidRuntime(24075): Shutting down VM
E/AndroidRuntime(24075): FATAL EXCEPTION: main
E/AndroidRuntime(24075): Process: com.habittracker.habitv8.debug, PID: 24075
E/AndroidRuntime(24075): android.util.SuperNotCalledException: Activity {com.habittracker.habitv8.debug/com.habittracker.habitv8.MainActivity} did not call through to super.onRestart()
E/AndroidRuntime(24075):        at android.app.Activity.performRestart(Activity.java:9376)
E/AndroidRuntime(24075):        at android.app.ActivityThread.performRestartActivity(ActivityThread.java:6151)
E/AndroidRuntime(24075):        at android.app.servertransaction.TransactionExecutor.performLifecycleSequence(TransactionExecutor.java:239)
E/AndroidRuntime(24075):        at android.app.servertransaction.TransactionExecutor.cycleToPath(TransactionExecutor.java:194)
E/AndroidRuntime(24075):        at android.app.servertransaction.TransactionExecutor.executeLifecycleItem(TransactionExecutor.java:166)
E/AndroidRuntime(24075):        at android.app.servertransaction.TransactionExecutor.executeTransactionItems(TransactionExecutor.java:101)
E/AndroidRuntime(24075):        at android.app.servertransaction.TransactionExecutor.execute(TransactionExecutor.java:80)
E/AndroidRuntime(24075):        at android.app.ActivityThread$H.handleMessage(ActivityThread.java:2830)
E/AndroidRuntime(24075):        at android.os.Handler.dispatchMessage(Handler.java:110)
E/AndroidRuntime(24075):        at android.os.Looper.dispatchMessage(Looper.java:315)
E/AndroidRuntime(24075):        at android.os.Looper.loopOnce(Looper.java:251)
E/AndroidRuntime(24075):        at android.os.Looper.loop(Looper.java:349)
E/AndroidRuntime(24075):        at android.app.ActivityThread.main(ActivityThread.java:9041)
E/AndroidRuntime(24075):        at java.lang.reflect.Method.invoke(Native Method)
E/AndroidRuntime(24075):        at com.android.internal.os.RuntimeInit$MethodAndArgsCaller.run(RuntimeInit.java:593)
E/AndroidRuntime(24075):        at com.android.internal.os.ZygoteInit.main(ZygoteInit.java:929)
I/Process (24075): Sending signal. PID: 24075 SIG: 9
Lost connection to device.