In Flutter, you can execute Dart code in the background even when the app is not active. This is useful for tasks like fetching real-time data from a server or monitoring certain conditions. The flutter_background_service plugin is a popular choice for implementing background services in Flutter.

Setting Up Background Service

To set up a background service in Flutter, follow these steps:

Add Dependencies: Add the flutter_background_service and flutter_local_notifications plugins to your pubspec.yaml file.

dependencies:
flutter:
sdk: flutter
flutter_background_service: ^5.0.10
flutter_local_notifications: ^9.0.0
Copy
Initialize the Service: Initialize the background service in the main() function.

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> main() async {
WidgetsFlutterBinding.ensureInitialized();
await initializeService();
runApp(MyApp());
}

Future<void> initializeService() async {
final service = FlutterBackgroundService();
await service.configure(
androidConfiguration: AndroidConfiguration(
onStart: onStart,
autoStart: true,
isForegroundMode: true,
notificationChannelId: 'my_foreground',
initialNotificationTitle: 'AWESOME SERVICE',
initialNotificationContent: 'Initializing',
foregroundServiceNotificationId: 888,
),
iosConfiguration: IosConfiguration(
autoStart: true,
onForeground: onStart,
onBackground: onIosBackground,
),
);
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
WidgetsFlutterBinding.ensureInitialized();
DartPluginRegistrant.ensureInitialized();
return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
DartPluginRegistrant.ensureInitialized();
Timer.periodic(const Duration(seconds: 1), (timer) {
print("Service is running: ${DateTime.now()}");
});
}
Copy
Configure Android and iOS: Ensure proper configuration for Android and iOS platforms. Android: Add necessary permissions and service declarations in AndroidManifest.xml. <manifest xmlns:android="http://schemas.android.com/apk/res/android"> <uses-permission android:name="android.permission.FOREGROUND_SERVICE" /> <application> <service android:name="id.flutter.flutter_background_service.BackgroundService" android:foregroundServiceType="location" /> </application> </manifest> iOS: Enable background fetch capability in Xcode and add necessary configurations in Info.plist. <key>BGTaskSchedulerPermittedIdentifiers</key> <array> <string>dev.flutter.background.refresh</string> </array>

Using the Service

To start and stop the background service, you can use the following methods:

void startBackgroundService() {
final service = FlutterBackgroundService();
service.startService();
}

void stopBackgroundService() {
final service = FlutterBackgroundService();
service.invoke("stop");
}
Copy
Important Considerations

Foreground Mode: When isForegroundMode is set to true, a silent notification is displayed according to Android's policy
1
.

Battery Optimization: Disable battery optimization to ensure the service stays active when the app is closed
1
.

iOS Limitations: iOS does not support long-running background services like Android. The onBackground method is executed periodically by the Background Fetch capability provided by iOS
1
.

By following these steps, you can effectively implement background services in your Flutter application, ensuring tasks run smoothly even when the app is not in the foreground