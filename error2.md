I/MinimalHealthPlugin( 3657): getHealthData called with:
I/MinimalHealthPlugin( 3657):   - dataType: HEART_RATE
I/MinimalHealthPlugin( 3657):   - startDate: 1755822147803 (2025-08-22T00:22:27.803Z)
I/MinimalHealthPlugin( 3657):   - endDate: 1756426947803 (2025-08-29T00:22:27.803Z)
I/MinimalHealthPlugin( 3657): Executing Health Connect readRecords request for HEART_RATE...
I/MinimalHealthPlugin( 3657):   Time range: 2025-08-22T00:22:27.803Z to 2025-08-29T00:22:27.803Z
I/MinimalHealthPlugin( 3657):   Duration: 168 hours
I/MinimalHealthPlugin( 3657):   Record type: HeartRateRecord
I/MinimalHealthPlugin( 3657): ⏱️  Starting Health Connect API call at 2025-08-29T00:22:27.826Z
E/MinimalHealthPlugin( 3657): Health Connect version compatibility issue for HEART_RATE: No virtual method getStartZoneOffset()Lj$/time/ZoneOffset; in class Landroid/health/connect/datatypes/HeartRateRecord; or its super classes (declaration of 'android.health.connect.datatypes.HeartRateRecord' appears in /apex/com.android.healthfitness/javalib/framework-healthfitness.jar)
E/MinimalHealthPlugin( 3657): java.lang.NoSuchMethodError: No virtual method getStartZoneOffset()Lj$/time/ZoneOffset; in class Landroid/health/connect/datatypes/HeartRateRecord; or its super classes (declaration of 'android.health.connect.datatypes.HeartRateRecord' appears in /apex/com.android.healthfitness/javalib/framework-healthfitness.jar)
E/MinimalHealthPlugin( 3657):   at androidx.health.connect.client.impl.platform.records.RecordConvertersKt$$ExternalSyntheticAPIConversion42.m(D8$$SyntheticClass:0)
E/MinimalHealthPlugin( 3657):   at androidx.health.connect.client.impl.platform.records.RecordConvertersKt.toSdkHeartRateRecord(RecordConverters.kt:316)
E/MinimalHealthPlugin( 3657):   at androidx.health.connect.client.impl.platform.records.RecordConvertersKt.toSdkRecord(RecordConverters.kt:137)
E/MinimalHealthPlugin( 3657):   at androidx.health.connect.client.impl.HealthConnectClientUpsideDownImpl.readRecords(HealthConnectClientUpsideDownImpl.kt:215)
E/MinimalHealthPlugin( 3657):   at androidx.health.connect.client.impl.HealthConnectClientUpsideDownImpl$readRecords$1.invokeSuspend(Unknown Source:15)
E/MinimalHealthPlugin( 3657):   at kotlin.coroutines.jvm.internal.BaseContinuationImpl.resumeWith(ContinuationImpl.kt:33)
E/MinimalHealthPlugin( 3657):   at kotlinx.coroutines.DispatchedTask.run(DispatchedTask.kt:108)
E/MinimalHealthPlugin( 3657):   at android.os.Handler.handleCallback(Handler.java:995)
E/MinimalHealthPlugin( 3657):   at android.os.Handler.dispatchMessage(Handler.java:103)
E/MinimalHealthPlugin( 3657):   at android.os.Looper.loopOnce(Looper.java:248)
E/MinimalHealthPlugin( 3657):   at android.os.Looper.loop(Looper.java:338)
E/MinimalHealthPlugin( 3657):   at android.app.ActivityThread.main(ActivityThread.java:9067)
E/MinimalHealthPlugin( 3657):   at java.lang.reflect.Method.invoke(Native Method)
E/MinimalHealthPlugin( 3657):   at com.android.internal.os.RuntimeInit$MethodAndArgsCaller.run(RuntimeInit.java:593)
E/MinimalHealthPlugin( 3657):   at com.android.internal.os.ZygoteInit.main(ZygoteInit.java:932)
W/MinimalHealthPlugin( 3657): This may be due to Health Connect version mismatch. Returning empty data.