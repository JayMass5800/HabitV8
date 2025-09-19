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

# Allow R8 to shrink unused permission_handler classes (removes embedded permission constants)
# If you encounter runtime issues with permission_handler after this change, we can add minimal keeps.
# (Currently no keeps are required for typical Flutter plugin registration.)

# Keep device info classes
-keep class dev.fluttercommunity.plus.device_info.** { *; }

# Keep path provider classes
-keep class io.flutter.plugins.pathprovider.** { *; }

# Keep shared preferences classes
-keep class io.flutter.plugins.sharedpreferences.** { *; }

# Keep calendar plugin classes
-keep class com.builttoroam.devicecalendar.** { *; }

# Keep alarm and notification permission classes
-keep class android.app.AlarmManager { *; }
-keep class android.app.AlarmManager$* { *; }
-keep class android.content.Context { 
    public *** getSystemService(java.lang.String);
}

# Keep exact alarm permission references
-keepclassmembers class * {
    public static final *** *SCHEDULE_EXACT_ALARM*;
}

# Keep notification permission references
-keepclassmembers class * {
    public static final *** *POST_NOTIFICATIONS*;
}

# Keep alarm-related classes that might be used for scheduling
-keep class android.app.PendingIntent { *; }
-keep class android.content.Intent { *; }
-keep class android.os.Build$VERSION { *; }
-keep class android.os.Build$VERSION_CODES { *; }

# ===== Widget Provider Keep Rules =====
# Keep all widget provider classes to prevent R8/ProGuard from obfuscating them
-keep class com.habittracker.habitv8.HabitTimelineWidgetProvider { *; }
-keep class com.habittracker.habitv8.HabitCompactWidgetProvider { *; }

# Keep debug wrapper widget provider classes
-keep class com.habittracker.habitv8.debug.HabitTimelineWidgetProvider { *; }
-keep class com.habittracker.habitv8.debug.HabitCompactWidgetProvider { *; }

# Keep HomeWidget related classes
-keep class es.antonborri.home_widget.** { *; }
-keep class es.antonborri.home_widget.HomeWidgetProvider { *; }
-keep class es.antonborri.home_widget.HomeWidgetBackgroundIntent { *; }
-keep class es.antonborri.home_widget.HomeWidgetLaunchIntent { *; }

# Keep Android AppWidget related classes
-keep class android.appwidget.AppWidgetProvider { *; }
-keep class android.widget.RemoteViews { *; }

# Keep all methods in widget providers that might be called by reflection
-keepclassmembers class com.habittracker.habitv8.** extends android.appwidget.AppWidgetProvider {
    public *;
    protected *;
}

# Keep all methods in HomeWidgetProvider subclasses
-keepclassmembers class * extends es.antonborri.home_widget.HomeWidgetProvider {
    public *;
    protected *;
}
