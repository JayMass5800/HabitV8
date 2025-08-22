# Add project specific ProGuard rules here.
# You can control the set of applied configuration files using the
# proguardFiles setting in build.gradle.
#
# For more details, see
#   http://developer.android.com/guide/developing/tools/proguard.html

# If your project uses WebView with JS, uncomment the following
# and specify the fully qualified class name to the JavaScript interface
# class:
#-keepclassmembers class fqcn.of.javascript.interface.for.webview {
#   public *;
#}

# Uncomment this to preserve the line number information for
# debugging stack traces.
#-keepattributes SourceFile,LineNumberTable

# If you keep the line number information, uncomment this to
# hide the original source file name.
#-renamesourcefileattribute SourceFile

# Keep TensorFlow Lite classes
-keep class org.tensorflow.lite.** { *; }
-keep class org.tensorflow.lite.gpu.** { *; }
-dontwarn org.tensorflow.lite.gpu.GpuDelegateFactory$Options

# Google Play Core - Split Install warnings
-dontwarn com.google.android.play.core.splitcompat.SplitCompatApplication
-dontwarn com.google.android.play.core.splitinstall.SplitInstallException
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManager
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManagerFactory
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest$Builder
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest
-dontwarn com.google.android.play.core.splitinstall.SplitInstallSessionState
-dontwarn com.google.android.play.core.splitinstall.SplitInstallStateUpdatedListener
-dontwarn com.google.android.play.core.tasks.OnFailureListener
-dontwarn com.google.android.play.core.tasks.OnSuccessListener
-dontwarn com.google.android.play.core.tasks.Task

# Keep Flutter and Dart related classes
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Flutter Local Notifications - Prevent obfuscation of classes used by Gson
-keep class com.dexterous.** { *; }
-keep class com.dexterous.flutterlocalnotifications.** { *; }
-keepattributes Signature
-keepattributes *Annotation*
-keepattributes EnclosingMethod
-keepattributes InnerClasses

# Gson specific rules for flutter_local_notifications
-keep class com.google.gson.reflect.TypeToken { *; }
-keep class * extends com.google.gson.reflect.TypeToken
-keep public class * implements java.lang.reflect.Type
-keep class com.google.gson.** { *; }
-keep class * implements com.google.gson.TypeAdapterFactory
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer

# Keep notification model classes that might be serialized
-keep class com.dexterous.flutterlocalnotifications.models.** { *; }

# Keep notification related classes
-keep class com.dexterous.** { *; }
-keep class androidx.work.** { *; }

# Keep health plugin classes and all permission references
-keep class cachet.plugins.health.** { *; }
-keep class androidx.health.** { *; }
-keep class androidx.health.connect.** { *; }
-keep class androidx.health.platform.** { *; }

# Explicitly keep heart rate permission references
-keepclassmembers class * {
    public static final *** *HEART_RATE*;
}

# Keep health permission metadata
-keep class androidx.health.platform.client.** { *; }
-keep class androidx.health.connect.client.** { *; }
-keep class androidx.health.connect.client.permission.** { *; }
-keep class androidx.health.connect.client.records.** { *; }
-keep class androidx.health.connect.client.aggregate.** { *; }
-keep class androidx.health.connect.client.changes.** { *; }
-keep class androidx.health.connect.client.time.** { *; }
-keep class androidx.health.connect.client.request.** { *; }
-keep class androidx.health.connect.client.response.** { *; }

# Keep heart rate and calories specific classes
-keep class androidx.health.connect.client.records.HeartRateRecord { *; }
-keep class androidx.health.connect.client.records.HeartRateRecord$* { *; }
-keep class androidx.health.connect.client.records.TotalCaloriesBurnedRecord { *; }
-keep class androidx.health.connect.client.records.TotalCaloriesBurnedRecord$* { *; }
-keep class androidx.health.connect.client.records.ActiveCaloriesBurnedRecord { *; }
-keep class androidx.health.connect.client.records.ActiveCaloriesBurnedRecord$* { *; }
-keep class androidx.health.connect.client.permission.HealthPermission { *; }

# Explicitly keep heart rate and calories permissions
-keepclassmembers class androidx.health.connect.client.permission.HealthPermission {
    public static final *** READ_HEART_RATE;
    public static final *** READ_TOTAL_CALORIES_BURNED;
    public static final *** READ_ACTIVE_CALORIES_BURNED;
}

# Keep background health data access permissions
-keepclassmembers class * {
    public static final *** *READ_HEALTH_DATA_IN_BACKGROUND*;
}

# Keep activity recognition permissions and classes
-keep class com.google.android.gms.location.ActivityRecognition { *; }
-keep class com.google.android.gms.location.ActivityRecognitionClient { *; }
-keep class com.google.android.gms.location.ActivityRecognitionResult { *; }
-keep class com.google.android.gms.location.DetectedActivity { *; }
-keep class android.app.PendingIntent { *; }

# Keep activity recognition permission
-keepclassmembers class * {
    public static final *** *ACTIVITY_RECOGNITION*;
}

# Keep background service classes
-keep class **.HealthHabitBackgroundService { *; }
-keep class **.HealthService { *; }
-keep class **.BackgroundWorker { *; }
-keep class androidx.work.** { *; }

# Keep permission handler classes
-keep class com.baseflow.permissionhandler.** { *; }

# Keep device info classes
-keep class dev.fluttercommunity.plus.device_info.** { *; }

# Keep path provider classes
-keep class io.flutter.plugins.pathprovider.** { *; }

# Keep shared preferences classes
-keep class io.flutter.plugins.sharedpreferences.** { *; }

# Keep calendar plugin classes
-keep class com.builttoroam.devicecalendar.** { *; }
