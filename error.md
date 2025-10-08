
Scheduled local notifications are typically cleared by the operating system (OS) on device reboot as they are not persistent by default, which is why your notification didn't fire. This is a common behavior on both Android and iOS.

To get around this limitation and ensure your notifications are rescheduled after a reboot, you need to implement a mechanism to listen for the device's boot-up event and then re-schedule all pending notifications using the data you've persistently stored in your Isar database.

Here are the steps to achieve this, primarily focusing on Android as it requires specific setup:

1. Add Android Permissions and Receiver
You must inform the Android OS that your app needs to receive the "boot completed" broadcast so it can run code before the user launches the app.

In your android/app/src/main/AndroidManifest.xml file, ensure you have the following permission outside of the <application> tags:

XML

<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
Also, within the <application> tags, the flutter_local_notifications plugin's receiver must be registered. If you're using the recommended setup, this is often handled automatically by the plugin, but for clarity, the receiver that handles the re-scheduling on boot should look like this (you should verify your current plugin setup includes this, it often is included by default):

XML

<receiver 
    android:exported="false" 
    android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver">
    <intent-filter>
        <action android:name="android.intent.action.BOOT_COMPLETED"/>
        <action android:name="android.intent.action.MY_PACKAGE_REPLACED"/>
        <action android:name="android.intent.action.QUICKBOOT_POWERON" />
    </intent-filter>
</receiver>
2. Persistently Store Notification Data
Since the OS clears all scheduled notifications on reboot, your app needs to know which notifications were pending so it can re-schedule them. You are already using an Isar database, which is the perfect tool for this.

Before scheduling a notification, make sure you save all the necessary details to your Isar database:

Notification ID (crucial for re-scheduling and cancellation).

Title and Body.

Scheduled Date/Time.

When you initially schedule a notification with flutter_local_notifications, you would also write a record to your Isar database.

3. Re-schedule Notifications on App Launch
The flutter_local_notifications plugin's ScheduledNotificationBootReceiver (from Step 1) will trigger when the device reboots. This receiver automatically tries to handle re-scheduling. However, the most reliable cross-platform and developer-controlled way to ensure notifications are re-scheduled is to check for and re-schedule pending notifications every time your app starts.

In your main() or initial widget's initState, you need to check if the app is launching after a reboot and re-schedule any pending notifications:

Query Isar: Retrieve all the pending notification records from your Isar database.

Filter/Validate: Iterate through the records. You may want to discard any that are already in the past (unless you want them to fire immediately upon launch).

Re-schedule: For each valid record, call the flutter_local_notifications scheduling method (e.g., zonedSchedule) using the saved data.

Clean Up: Once a notification is fired or cancelled, you should remove it from your Isar database to prevent it from being re-scheduled unnecessarily.

Example Logic in Flutter (Conceptual)
Dart

Future<void> rescheduleNotificationsAfterReboot() async {
    // 1. Get pending records from Isar (concept)
    final pendingNotifications = await isar.notificationSchedules.where().findAll();

    // 2. Clear old notifications from the OS queue (optional but good practice)
    await flutterLocalNotificationsPlugin.cancelAll();

    // 3. Re-schedule each one
    for (final schedule in pendingNotifications) {
        final now = tz.TZDateTime.now(tz.local);
        final scheduledTime = schedule.scheduledTime; // Get from Isar

        // Only re-schedule if it's in the future
        if (scheduledTime.isAfter(now)) {
            await flutterLocalNotificationsPlugin.zonedSchedule(
                schedule.id, // Must be unique
                schedule.title,
                schedule.body,
                scheduledTime,
                // ... other NotificationDetails
            );
        } else {
            // Option to delete past schedules from Isar
            await isar.writeTxn(() async {
                await isar.notificationSchedules.delete(schedule.id);
            });
        }
    }
}

void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    // Initialize your Isar database here
    // ...
    // Call the re-scheduling function on startup
    await rescheduleNotificationsAfterReboot(); 
    runApp(const MyApp());
}
This is a video that shows how to set up scheduled local notifications in a Flutter app, which is the foundation for solving the reboot issue.
Scheduled Notifications • Flutter Tutorial