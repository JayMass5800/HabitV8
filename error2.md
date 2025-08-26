W/WindowOnBackDispatcher(16514): OnBackInvokedCallback is not enabled for the application.
W/WindowOnBackDispatcher(16514): Set 'android:enableOnBackInvokedCallback="true"' in the application manifest.

E/AndroidRuntime(16514): FATAL EXCEPTION: main
E/AndroidRuntime(16514): Process: com.habittracker.habitv8.debug, PID: 16514
E/AndroidRuntime(16514): java.lang.NoSuchMethodError: No virtual method getStartZoneOffset()Lj$/time/ZoneOffset; in class Landroid/health/connect/datatypes/StepsRecord; or its super classes (declaration of 'android.health.connect.datatypes.StepsRecord' appears in /apex/com.android.healthfitness/javalib/framework-healthfitness.jar)
E/AndroidRuntime(16514):        at androidx.health.connect.client.impl.platform.records.RecordConvertersKt$$ExternalSyntheticAPIConversion97.m(D8$$SyntheticClass:0)
E/AndroidRuntime(16514):        at androidx.health.connect.client.impl.platform.records.RecordConvertersKt.toSdkStepsRecord(RecordConverters.kt:519)
E/AndroidRuntime(16514):        at androidx.health.connect.client.impl.platform.records.RecordConvertersKt.toSdkRecord(RecordConverters.kt:155)
E/AndroidRuntime(16514):        at androidx.health.connect.client.impl.HealthConnectClientUpsideDownImpl.readRecords(HealthConnectClientUpsideDownImpl.kt:198)
E/AndroidRuntime(16514):        at androidx.health.connect.client.impl.HealthConnectClientUpsideDownImpl$readRecords$1.invokeSuspend(Unknown Source:15)
E/AndroidRuntime(16514):        at kotlin.coroutines.jvm.internal.BaseContinuationImpl.resumeWith(ContinuationImpl.kt:33)
E/AndroidRuntime(16514):        at kotlinx.coroutines.DispatchedTask.run(DispatchedTask.kt:108)
E/AndroidRuntime(16514):        at android.os.Handler.handleCallback(Handler.java:995)
E/AndroidRuntime(16514):        at android.os.Handler.dispatchMessage(Handler.java:103)
E/AndroidRuntime(16514):        at android.os.Looper.loopOnce(Looper.java:248)
E/AndroidRuntime(16514):        at android.os.Looper.loop(Looper.java:338)
E/AndroidRuntime(16514):        at android.app.ActivityThread.main(ActivityThread.java:9067)
E/AndroidRuntime(16514):        at java.lang.reflect.Method.invoke(Native Method)
E/AndroidRuntime(16514):        at com.android.internal.os.RuntimeInit$MethodAndArgsCaller.run(RuntimeInit.java:593)
E/AndroidRuntime(16514):        at com.android.internal.os.ZygoteInit.main(ZygoteInit.java:932)
E/AndroidRuntime(16514):        Suppressed: kotlinx.coroutines.internal.DiagnosticCoroutineContextException: [StandaloneCoroutine{Cancelling}@8c4b61, Dispatchers.Main]
I/Process (16514): Sending signal. PID: 16514 SIG: 9
Lost connection to device.