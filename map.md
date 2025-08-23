Android 16 (API Level 36) has indeed continued to refine the permissions landscape, building on the changes from previous versions.

The fundamental principles for exact alarms remain the same, but with a new emphasis on a more user-friendly and streamlined approach for developers with valid use cases. For a habit tracking app, the core strategy should still be to use the USE_EXACT_ALARM permission.

Here's a breakdown of how the process applies to Android 16, with some additional context:

The USE_EXACT_ALARM Permission: The Android 16 Approach
Android 16 further solidifies USE_EXACT_ALARM as the preferred and most appropriate permission for apps like a habit tracker. It's designed specifically for apps where precise, user-initiated alarms are a core part of the app's functionality.

Automatic Grant: The system recognizes that for certain app categories (including reminders and habit trackers), this permission is essential. Therefore, when a user installs an app that declares USE_EXACT_ALARM, the permission is automatically granted. This is a huge win for user experience as it removes a friction point during the onboarding process.

No Manual Request: Unlike SCHEDULE_EXACT_ALARM on Android 13+, you do not need to redirect the user to a settings page to request the permission. The permission is granted as part of the app installation.

Google Play Policy: Google's policy for apps requesting USE_EXACT_ALARM is a crucial part of this. To get your app approved on the Play Store, you must declare in your app submission that your app's core functionality requires precise alarms. For a habit tracker, this is a clear and justifiable reason.

Implementing Exact Alarms in Your Android 16 App
The code you write will be cleaner and simpler because you don't need to handle the manual permission request flow.

1. Declare the Permission in AndroidManifest.xml
This is the only permission you need to declare for modern Android versions (Android 13+).

XML

<uses-permission android:name="android.permission.USE_EXACT_ALARM" />
As a best practice for backward compatibility, you can use the maxSdkVersion attribute to support older devices that only have SCHEDULE_EXACT_ALARM.

XML

<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM" android:maxSdkVersion="32" />
<uses-permission android:name="android.permission.USE_EXACT_ALARM" />
2. Schedule the Alarm
Your code can now proceed directly to scheduling the alarm without a pre-check, as the permission is guaranteed to be granted if your app is installed on an Android 16 device.

Example (Kotlin):

Kotlin

val alarmManager: AlarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
val alarmIntent = ... // Your PendingIntent for the alarm

// Schedule an exact alarm.
// The system will ensure this alarm is delivered at the specified time.
alarmManager.setExactAndAllowWhileIdle(
    AlarmManager.RTC_WAKEUP,
    alarmTimeInMillis,
    alarmIntent
)
The setExactAndAllowWhileIdle() method is often preferred for habit trackers because it ensures the alarm fires even if the device is in Doze mode (low-power state).

3. Handling User Disablement (A Minor Consideration)
While the USE_EXACT_ALARM permission cannot be revoked by the user, the user can still disable notifications for your app, which would prevent the alarm from appearing as a notification. It's always a good practice to:

Check Notification Permissions: Use NotificationManagerCompat.areNotificationsEnabled() to check if the user has disabled notifications for your app.

Prompt the User: If notifications are disabled, you can show a message or a button that takes the user directly to your app's notification settings page to enable them.

Summary for Android 16
For a habit tracking app, the developer experience for enabling exact alarms is significantly improved with Android 16.

Declare USE_EXACT_ALARM in your manifest.

Do not prompt the user for a runtime permission; it's granted automatically upon installation.

Ensure your app's core functionality justifies the permission for Google Play approval.

Continue to check for general notification permissions to provide the best user experience.

The evolution of these permissions shows that Google is moving toward a model where apps with a genuine need for background operations and precise timing can get them without a clumsy user-facing flow, while still protecting users from abuse by other apps.