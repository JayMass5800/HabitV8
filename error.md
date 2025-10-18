That behavior—where the alarm sound stops immediately upon any interaction (like unlocking the phone or viewing the notification)—is a common configuration issue for persistent alarms, and it directly relates to how your notification is being dismissed or handled by the system.The key to fixing this lies in combining three critical settings in your Flutter code (using awesome_notifications): Insistence, Foreground Service/Ongoing Event, and Auto-Dismissal.Here is the breakdown and the specific settings you need to ensure the alarm plays until a button is explicitly pressed:1. Set the Notification as Insistent and OngoingFor a true alarm, the notification must be both Insistent (to keep the sound going) and an Ongoing Event (to prevent swiping it away).SettingCode PropertyValue to UsePurposeInsistentinsistenttrueCrucial: Keeps the sound and vibration looping until the user dismisses the notification.Ongoing EventongoingtruePrevents the user from swiping away the notification from the tray.No Auto-DismissautoDismissiblefalseEnsures the notification remains active until a button action is taken.Required Code Example (in NotificationContent):DartNotificationContent(
  id: 101, 
  channelKey: 'alarm_channel', 
  title: '🚨 Custom Alarm Sound 🚨',
  body: 'Press "Stop" to silence the alarm.',
  
  // *** CRITICAL ALARM SETTINGS ***
  insistent: true,             // Keeps the sound/vibration looping
  ongoing: true,               // Prevents swiping the notification away
  autoDismissible: false,      // Requires an action button to dismiss
  
  wakeUpScreen: true,
  category: NotificationCategory.Alarm,
),
Note: The INSISTENT flag is the primary control for ensuring the audio continues to play on a loop rather than just a single chime.2. Implement the Action Button HandlerSince you set autoDismissible: false, the alarm will now continue ringing until one of the action buttons is pressed. You must ensure your button handling code explicitly cancels or dismisses the notification.When you define your action button (e.g., "Stop Alarm"), make sure its ActionType is set correctly:Required Code Example (in createNotification):DartactionButtons: [
  NotificationActionButton(
    key: 'STOP_ALARM',
    label: 'Stop',
    actionType: ActionType.Dismiss, // <-- This is the key setting
    // The Dismiss action type automatically stops the alarm and removes the notification.
  ),
],
If you use ActionType.Default or another type, you must then manually call the dismissal function inside your action handler:Dart// If using ActionType.Default, you must manually cancel:
AwesomeNotifications().cancel(notificationId); 
// OR
AwesomeNotifications().dismiss(notificationId); 
By ensuring the notification is marked as insistent, ongoing, and only removable via a button set to dismiss, you force the alarm to remain active (sound and notification screen) until the user takes the explicit action you've provided