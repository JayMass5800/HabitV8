

Android AlarmManager allows you to access the system alarms.

With the help of AlarmManager in android, you can schedule your application to run at a specific time in the future.

AlarmManager is a bridge between the application and the Android system alarm service. It can send a broadcast to your app (which can be completely terminated by the user) at a scheduled time and your app can then perform any task accordingly.

However, since Android KitKat (API 19) and Android MarshMallow (API 23), Google has added different restrictions on AlarmManager to reduce battery usage. The alarm no longer goes off exactly at the assigned time by default. The system has the ability to defer any alarm in order to optimize the device's performance.

Note: This should be keep in mind that AlarmManager doesn’t keep record of the scheduled alarms after the device is booted. Your application should re-register all the scheduled alarms after the device is booted.

Now it’s time to understand the code behind it :
Step 1. Create a BroadcastReceiver :
First, create a class that extends BroadcastReceiver and implement onReceive() the method in the class
BroadcastReceiver is a class for receiving and handling the broadcast sent to your application. In the system alarm case, it receives broadcast from the system alarm service when the alarm goes off.


Whenever your device reboots the BroadcastReceiver is called and with the help of Intent we can re-register all the alarms using action ACTION_BOOT_COMPLETED .

In the else part you can perform your scheduled task (eg, send alarm notification).

You can read how to send notifications, even with some customization, to your application in this post 👇🏻.

Custom Notifications in android
Here, we are going to give notifications a custom look as your need in your android application.
medium.com

Register this receiver in your AndroidManifest.xml file

<action android:name="android.intent.action.BOOT_COMPLETED"/> is added in <intent-filter> so that we can handle the situation to re-register all the scheduled alarms when the device will reboot.

Step 2: Setup in activity :
Code in the activity to schedule an alarm at any specific time is explained step by step below:

Get AlarmManager instance

AlarmManager is actually a system service and thus can be retrieved from Context.getSystemService() function with parameter Context.ALARM_SERVICE.

Prepare for an intent

Android allows a bundle of information to be sent to a target receiver (i.e. AlarmReceiver, which is defined in step 1) when the alarm goes off.

The designated receiver and the corresponding information can be set in Intent by setting its action and extra. These information can later be retrieved at the onReceive() callback in the designated BroadcastReceiver and action field is checked to ensure the correctness of the system broadcast.

Prepare for a PendingIntent

PendingIntent is a reference pointing to a token maintained by the Android system. Thus, it will still be valid if the application is killed by the user and can be broadcasted at some moment in the future.

2nd parameter of getBroadcast() is requestCode which should be unique for every pendingIntent when you want to schedule multiple alarms.

For your information:

Get Hrithik Sharma’s stories in your inbox
Join Medium for free to get updates from this writer.

Enter your email
Subscribe
There are totally 4 functions for initializing a PendingIntent but only 1 of them is applicable:

PendingIntent.getBroadcast() — Applicable to AlarmManager
PendingIntent.getActivity()
PendingIntent.getActivities()
PendingIntent.getService()
Flags indicate how system should handle the new and existing PendingIntent that have the same Intent. 0 indicates that the system will use its default way to handle the creation of PendingIntent. The following are some examples:

FLAG_UPDATE_CURRENT
FLAG_CANCEL_CURRENT
FLAG_IMMUTABLE
Set the alarm time and sent to system
The best way to set the time of the alarm is by using a Calendar object


The simplest way to set an alarm is using setExactAndAllowWhileIdle() with parameter RTC_WAKEUP. This would tell Android to fire the alarm exactly at the assigned time no matter the system is in doze mode (idle mode).

If you want to repeat your alarm on a particular Day of Week then:


Set the day of the week you want to repeat the alarm to Calendar.DAY_OF_WEEK and use setRepeating() method of alarmManager.

Some more methods of alarmManager :

alarmManager.set()
alarmManager.setExact()
alarmManager.setAlarmClock()
alarmManager.setInExactRepeating()
alarmManager.setRepeating()
alarmManager.setTime()
alarmManager.setTimeZone()
Canceling of an alarm:
However, it is tricky to cancel a PendingIntent since it depends on both the Intent and requestCode used.

The alarm with PendingIntent can be canceled with the following steps:


Note: To cancel a particular scheduled alarm the requestCode used in PendingIntent must be the same as that which is used to register that alarm.

Handling of an alarm event:
AlarmManager provides two ways to listen to an alarm broadcast. They are

Local listener (AlarmManager.OnAlarmListener)
BroadcastReceiver specified at the Intent wrapped inside a PendingIntent.
The implementation of AlarmManager.OnAlarmListener is similar to the one using PendingIntent, instead, it requires a callback and its corresponding Handler:


There is a limitation on AlarmManager.OnAlarmListener over PendingIntent. It cannot work when the corresponding Activity or Fragment is destroyed since the callback object is released at the same time.

However, because PendingIntent is sent to the system alarm service, it can be fired even when the application is killed by the user.

Summary
Android provides an alarm service to notify application at any specific time with the corresponding assigned information stored in Intent.

Along with the evolution of the Android system throughout the years, Android applies more controls of alarm service to optimize battery consumption.

setExactAndAllowWhileIdle() together with WAKE_UP type should only be used when the alarm time must be as exact as possible.

The app developer should bear in mind to re-register all the alarms again when the device is booted since Android does not store any alarms by default.