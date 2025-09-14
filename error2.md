I/flutter (17534): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17534): │ #0   AppLogger.warning (package:habitv8/services/logging_service.dart:24:13)
I/flutter (17534): │ #1   _executeBackgroundAlarm (package:habitv8/alarm_callback.dart:233:17)
I/flutter (17534): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17534): │ ! ! Platform channel sound failed (expected in background), using notification sound: MissingPluginException(No implementation found for method playSystemSound on channel com.habittracker.habitv8/system_sound)
I/flutter (17534): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
E/MethodChannel#dexterous.com/flutter/local_notifications(17534): Failed to handle method call
E/MethodChannel#dexterous.com/flutter/local_notifications(17534): java.lang.NullPointerException: Contextual Actions must contain a valid icon
E/MethodChannel#dexterous.com/flutter/local_notifications(17534):       at android.app.Notification$Action$Builder.checkContextualActionNullFields(Notification.java:2390)
E/MethodChannel#dexterous.com/flutter/local_notifications(17534):       at android.app.Notification$Action$Builder.build(Notification.java:2406)
E/MethodChannel#dexterous.com/flutter/local_notifications(17534):       at androidx.core.app.NotificationCompatBuilder$Api20Impl.build(NotificationCompatBuilder.java:561)
E/MethodChannel#dexterous.com/flutter/local_notifications(17534):       at androidx.core.app.NotificationCompatBuilder.addAction(NotificationCompatBuilder.java:419)
E/MethodChannel#dexterous.com/flutter/local_notifications(17534):       at androidx.core.app.NotificationCompatBuilder.<init>(NotificationCompatBuilder.java:127)
E/MethodChannel#dexterous.com/flutter/local_notifications(17534):       at androidx.core.app.NotificationCompat$Builder.build(NotificationCompat.java:2532)
E/MethodChannel#dexterous.com/flutter/local_notifications(17534):       at com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin.createNotification(FlutterLocalNotificationsPlugin.java:430)
E/MethodChannel#dexterous.com/flutter/local_notifications(17534):       at com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin.showNotification(FlutterLocalNotificationsPlugin.java:1266)
E/MethodChannel#dexterous.com/flutter/local_notifications(17534):       at com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin.show(FlutterLocalNotificationsPlugin.java:1625)
E/MethodChannel#dexterous.com/flutter/local_notifications(17534):       at com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin.onMethodCall(FlutterLocalNotificationsPlugin.java:1431)
E/MethodChannel#dexterous.com/flutter/local_notifications(17534):       at io.flutter.plugin.common.MethodChannel$IncomingMethodCallHandler.onMessage(MethodChannel.java:267)
E/MethodChannel#dexterous.com/flutter/local_notifications(17534):       at io.flutter.embedding.engine.dart.DartMessenger.invokeHandler(DartMessenger.java:292)
E/MethodChannel#dexterous.com/flutter/local_notifications(17534):       at io.flutter.embedding.engine.dart.DartMessenger.lambda$dispatchMessageToQueue$0$io-flutter-embedding-engine-dart-DartMessenger(DartMessenger.java:319)
E/MethodChannel#dexterous.com/flutter/local_notifications(17534):       at io.flutter.embedding.engine.dart.DartMessenger$$ExternalSyntheticLambda0.run(D8$$SyntheticClass:0)
E/MethodChannel#dexterous.com/flutter/local_notifications(17534):       at android.os.Handler.handleCallback(Handler.java:1041)
E/MethodChannel#dexterous.com/flutter/local_notifications(17534):       at android.os.Handler.dispatchMessage(Handler.java:103)
E/MethodChannel#dexterous.com/flutter/local_notifications(17534):       at android.os.Looper.dispatchMessage(Looper.java:315)
E/MethodChannel#dexterous.com/flutter/local_notifications(17534):       at android.os.Looper.loopOnce(Looper.java:251)
E/MethodChannel#dexterous.com/flutter/local_notifications(17534):       at android.os.Looper.loop(Looper.java:349)
E/MethodChannel#dexterous.com/flutter/local_notifications(17534):       at android.app.ActivityThread.main(ActivityThread.java:9041)
E/MethodChannel#dexterous.com/flutter/local_notifications(17534):       at java.lang.reflect.Method.invoke(Native Method)
E/MethodChannel#dexterous.com/flutter/local_notifications(17534):       at com.android.internal.os.RuntimeInit$MethodAndArgsCaller.run(RuntimeInit.java:593)
E/MethodChannel#dexterous.com/flutter/local_notifications(17534):       at com.android.internal.os.ZygoteInit.main(ZygoteInit.java:929)
I/flutter (17534): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17534): │ #0   AppLogger.error (package:habitv8/services/logging_service.dart:28:13)
I/flutter (17534): │ #1   _executeBackgroundAlarm (package:habitv8/alarm_callback.dart:315:15)
I/flutter (17534): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17534): │ ⛔ ❌ Failed to execute background alarm: PlatformException(error, Contextual Actions must contain a valid icon, null, java.lang.NullPointerException: Contextual Actions must contain a valid icon
I/flutter (17534): │ ⛔         at android.app.Notification$Action$Builder.checkContextualActionNullFields(Notification.java:2390)
I/flutter (17534): │ ⛔         at android.app.Notification$Action$Builder.build(Notification.java:2406)
I/flutter (17534): │ ⛔         at androidx.core.app.NotificationCompatBuilder$Api20Impl.build(NotificationCompatBuilder.java:561)
I/flutter (17534): │ ⛔         at androidx.core.app.NotificationCompatBuilder.addAction(NotificationCompatBuilder.java:419)
I/flutter (17534): │ ⛔         at androidx.core.app.NotificationCompatBuilder.<init>(NotificationCompatBuilder.java:127)
I/flutter (17534): │ ⛔         at androidx.core.app.NotificationCompat$Builder.build(NotificationCompat.java:2532)
I/flutter (17534): │ ⛔         at com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin.createNotification(FlutterLocalNotificationsPlugin.java:430)
I/flutter (17534): │ ⛔         at com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin.showNotification(FlutterLocalNotificationsPlugin.java:1266)
I/flutter (17534): │ ⛔         at com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin.show(FlutterLocalNotificationsPlugin.java:1625)
I/flutter (17534): │ ⛔         at com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin.onMethodCall(FlutterLocalNotificationsPlugin.java:1431)
I/flutter (17534): │ ⛔         at io.flutter.plugin.common.MethodChannel$IncomingMethodCallHandler.onMessage(MethodChannel.java:267)
I/flutter (17534): │ ⛔         at io.flutter.embedding.engine.dart.DartMessenger.invokeHandler(DartMessenger.java:292)
I/flutter (17534): │ ⛔         at io.flutter.embedding.engine.dart.DartMessenger.lambda$dispatchMessageToQueue$0$io-flutter-embedding-engine-dart-DartMessenger(DartMessenger.java:319)
I/flutter (17534): │ ⛔         at io.flutter.embedding.engine.dart.DartMessenger$$ExternalSyntheticLambda0.run(D8$$SyntheticClass:0)
I/flutter (17534): │ ⛔         at android.os.Handler.handleCallback(Handler.java:1041)
I/flutter (17534): │ ⛔         at android.os.Handler.dispatchMessage(Handler.java:103)
I/flutter (17534): │ ⛔         at android.os.Looper.dispatchMessage(Looper.java:315)
I/flutter (17534): │ ⛔         at android.os.Looper.loopOnce(Looper.java:251)
I/flutter (17534): │ ⛔         at android.os.Looper.loop(Looper.java:349)
I/flutter (17534): │ ⛔         at android.app.ActivityThread.main(ActivityThread.java:9041)
I/flutter (17534): │ ⛔         at java.lang.reflect.Method.invoke(Native Method)
I/flutter (17534): │ ⛔         at com.android.internal.os.RuntimeInit$MethodAndArgsCaller.run(RuntimeInit.java:593)
I/flutter (17534): │ ⛔         at com.android.internal.os.ZygoteInit.main(ZygoteInit.java:929)
I/flutter (17534): │ ⛔ )
I/flutter (17534): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17534): ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
I/flutter (17534): │ #0   AppLogger.info (package:habitv8/services/logging_service.dart:20:13)
I/flutter (17534): │ #1   _removeAlarmDataFile (package:habitv8/alarm_callback.dart:148:17)
I/flutter (17534): ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
I/flutter (17534): │ 💡 Alarm data file removed for ID: 307883
I/flutter (17534): └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────