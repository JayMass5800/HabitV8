
Conversation with Gemini
flutter , awesome notifications alarm code example

The awesome_notifications package in Flutter allows you to schedule a notification to act as an alarm using the schedule property with either NotificationInterval or NotificationCalendar. You should also set wakeUpScreen: true and category: NotificationCategory.Alarm in the NotificationContent for proper alarm-like behavior on some platforms.

Here is an example using NotificationInterval to schedule a notification five seconds from the moment the code runs, with an emphasis on alarm-like settings:

Dart
import 'package:awesome_notifications/awesome_notifications.dart';

Future<void> scheduleAlarmNotification() async {
  // Get the local time zone identifier for the schedule
  String localTimeZone = await AwesomeNotifications().getLocalTimeZoneIdentifier();

  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 1, // Unique ID for the notification
      channelKey: 'basic_channel', // Must match one of your initialized channels
      title: 'Alarm! ⏰',
      body: 'Time to wake up or check something!',
      // Set properties for alarm-like behavior
      wakeUpScreen: true,
      category: NotificationCategory.Alarm,
      // You can also add a custom sound in the channel initialization
    ),
    // Schedule the notification to fire after a specific interval
    schedule: NotificationInterval(
      interval: 5, // The notification will fire after 5 seconds
      timeZone: localTimeZone,
      preciseAlarm: true, // For more precise timing
    ),
  );
}

// You must initialize AwesomeNotifications in your main() function:
// void main() {
//   AwesomeNotifications().initialize(
//     null, // Set to null for default app icon, or a resource string
//     [
//       NotificationChannel(
//         channelKey: 'basic_channel',
//         channelName: 'Basic notifications',
//         channelDescription: 'Notification channel for tests',
//         importance: NotificationImportance.Max, // Max importance often helps for alarms
//         playSound: true,
//         criticalAlerts: true,
//         // You can define a custom sound here: sound: 'resource_name',
//       ),
//     ],
//     debug: true,
//   );
//   runApp(const MyApp());
// }
You can also use NotificationCalendar to set a notification for a specific date and time, and set repeats: true for recurring alarms.

Dart
// Example for a daily repeating alarm at 8:00 AM
// (Requires proper channel setup and time zone handling)
await AwesomeNotifications().createNotification(
    content: NotificationContent(
        id: 2,
        channelKey: 'basic_channel',
        title: 'Daily Reminder',
        body: 'It is 8 AM!',
        category: NotificationCategory.Alarm,
        wakeUpScreen: true,
    ),
    schedule: NotificationCalendar(
        hour: 8,
        minute: 0,
        second: 0,
        repeats: true, // Set to true for a daily repeating alarm
        timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier(),
        preciseAlarm: true,
    ),
);
The video provides a comprehensive tutorial on implementing various types of notifications, including scheduled ones, using the Awesome Notifications package.

Flutter Awesome Notification - YouTube

Flutter Awesome Notification - YouTube
Coding Orbit · 33K views


example when using alarm.mp3 sounds

To use a custom sound like alarm.mp3 with your Flutter alarm notification using awesome_notifications, you need to:

Add the sound file to the correct native platform directories.

Initialize the notification channel with the sound.

Schedule the notification using that channel.

Here is a complete example focusing on the Flutter (Dart) code after you've placed the file correctly.

1. File Placement (Required Native Setup)
The awesome_notifications package requires the sound file to be placed in the native projects:

Platform	Directory	Requirement
Android	android/app/src/main/res/raw/	Use lowercase and snake_case for the filename (e.g., alarm.mp3).
iOS	ios/Runner/	Add the file to the root of the Runner folder in Xcode (no extension needed in Dart code).
For this example, assume you've placed the file at:

Android: android/app/src/main/res/raw/alarm.mp3

iOS: ios/Runner/alarm.mp3 (Added to Xcode project)

2. Flutter Code Example
A. Initialization (Setting the Sound on the Channel)
The sound is set when you define the NotificationChannel. You pass the file name without the extension to the sound property.

Dart
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

// 1. Initialize the plugin in your main function
Future<void> initializeAwesomeNotifications() async {
  await AwesomeNotifications().initialize(
    // Null for default app icon, or a resource string for a custom one
    null,
    [
      NotificationChannel(
        channelKey: 'alarm_channel',
        channelName: 'Alarm Notifications',
        channelDescription: 'Channel for high-priority alarm sounds',
        importance: NotificationImportance.Max, // High importance for alarms
        playSound: true,
        // *** This is where you set the custom sound! ***
        // Use the filename without the extension, and without the path.
        // The package handles finding it in the native 'raw' or 'Runner' folders.
        sound: 'alarm', 
        criticalAlerts: true, // Bypasses Do Not Disturb on some devices
      ),
    ],
    debug: true,
  );
  // Request permission if not already granted
  await AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });
}
B. Scheduling the Alarm Notification
Now, you schedule a notification using the alarm_channel and setting the appropriate alarm-like properties.

Dart
Future<void> createCustomSoundAlarm() async {
  String localTimeZone = await AwesomeNotifications().getLocalTimeZoneIdentifier();
  
  // Schedule a notification to fire 10 seconds from now
  int interval = 10; 

  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 101, // Unique ID
      channelKey: 'alarm_channel', // Use the channel with the custom sound
      title: '🚨 Custom Alarm Sound 🚨',
      body: 'This notification uses alarm.mp3!',
      // Properties for true alarm behavior
      wakeUpScreen: true,
      category: NotificationCategory.Alarm,
      autoDismissible: false, // Often alarms stay on screen until dismissed
    ),
    schedule: NotificationInterval(
      interval: interval, 
      timeZone: localTimeZone,
      preciseAlarm: true, // For precise scheduling
      allowWhileIdle: true, // Try to fire even in low-power modes (Android)
    ),
    actionButtons: [
      NotificationActionButton(
        key: 'STOP_ALARM',
        label: 'Stop',
        actionType: ActionType.Dismiss,
      ),
    ],
  );
  
  print('Alarm scheduled for $interval seconds from now on the "alarm_channel".');
}