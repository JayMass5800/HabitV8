A notification can offer up to three action buttons that let the user respond quickly, such as to snooze a reminder or to reply to a text message. But these action buttons must not duplicate the action performed when the user taps the notification.



Figure 3. A notification with one action button.

To add an action button, pass a PendingIntent to the addAction() method. This is like setting up the notification's default tap action, except instead of launching an activity, you can do other things such as start a BroadcastReceiver that performs a job in the background so that the action doesn't interrupt the app that's already open.

For example, the following code shows how to send a broadcast to a specific receiver:

Kotlin
Java

val ACTION_SNOOZE = "snooze"

<b>val snoozeIntent = Intent(this, MyBroadcastReceiver::class.java).apply {
    action = ACTION_SNOOZE
    putExtra(EXTRA_NOTIFICATION_ID, 0)
}
val snoozePendingIntent: PendingIntent =
    PendingIntent.getBroadcast(this, 0, snoozeIntent, 0)</b>
val builder = NotificationCompat.Builder(this, CHANNEL_ID)
        .setSmallIcon(R.drawable.notification_icon)
        .setContentTitle("My notification")
        .setContentText("Hello World!")
        .setPriority(NotificationCompat.PRIORITY_DEFAULT)
        .setContentIntent(pendingIntent)
        <b>.addAction(R.drawable.ic_snooze, getString(R.string.snooze),
                snoozePendingIntent)</b>
For more information about building a BroadcastReceiver to run background work, see the Broadcasts overview.

If you're instead trying to build a notification with media playback buttons, such as to pause and skip tracks, see how to create a notification with media controls.

Note: In Android 10 (API level 29) and later, the platform automatically generates notification action buttons if an app doesn't provide its own. If you don't want your app's notifications to display any suggested replies or actions, you can opt-out of system-generated replies and actions by using setAllowGeneratedReplies() and setAllowSystemGeneratedContextualActions().
Add a direct reply action
The direct reply action, introduced in Android 7.0 (API level 24), lets users enter text directly into the notification. The text is then delivered to your app without opening an activity. For example, you can use a direct reply action to let users reply to text messages or update task lists from within the notification.



Figure 4. Tapping the "Reply" button opens the text input.

The direct reply action appears as an additional button in the notification that opens a text input. When the user finishes typing, the system attaches the text response to the intent you specify for the notification action and sends the intent to your app.

Add the reply button
To create a notification action that supports direct reply, follow these steps:

Create an instance of RemoteInput.Builder that you can add to your notification action. This class's constructor accepts a string that the system uses as the key for the text input. Your app later uses that key to retrieve the text of the input. * {Kotlin} ```kotlin // Key for the string that's delivered in the action's intent. private val KEY_TEXT_REPLY = "key_text_reply" var replyLabel: String = resources.getString(R.string.reply_label) var remoteInput: RemoteInput = RemoteInput.Builder(KEY_TEXT_REPLY).run { setLabel(replyLabel) build() } ``` * {Java} ```java // Key for the string that's delivered in the action's intent. private static final String KEY_TEXT_REPLY = "key_text_reply"; String replyLabel = getResources().getString(R.string.reply_label); RemoteInput remoteInput = new RemoteInput.Builder(KEY_TEXT_REPLY) .setLabel(replyLabel) .build(); ```
Create a PendingIntent for the reply action. * {Kotlin} ```kotlin // Build a PendingIntent for the reply action to trigger. var replyPendingIntent: PendingIntent = PendingIntent.getBroadcast(applicationContext, conversation.getConversationId(), getMessageReplyIntent(conversation.getConversationId()), PendingIntent.FLAG_UPDATE_CURRENT) ``` * {Java} ```java // Build a PendingIntent for the reply action to trigger. PendingIntent replyPendingIntent = PendingIntent.getBroadcast(getApplicationContext(), conversation.getConversationId(), getMessageReplyIntent(conversation.getConversationId()), PendingIntent.FLAG_UPDATE_CURRENT); ```
Caution: If you reuse a PendingIntent, a user might reply to a different conversation than the one they intend. You must provide a request code that is different for each conversation or provide an intent that doesn't return true when you call equals() on the reply intent of any other conversation. The conversation ID is frequently passed as part of the intent's extras bundle, but is ignored when you call equals().
Attach the RemoteInput object to an action using addRemoteInput(). * {Kotlin} ```kotlin // Create the reply action and add the remote input. var action: NotificationCompat.Action = NotificationCompat.Action.Builder(R.drawable.ic_reply_icon, getString(R.string.label), replyPendingIntent) .addRemoteInput(remoteInput) .build() ``` * {Java} ```java // Create the reply action and add the remote input. NotificationCompat.Action action = new NotificationCompat.Action.Builder(R.drawable.ic_reply_icon, getString(R.string.label), replyPendingIntent) .addRemoteInput(remoteInput) .build(); ```
Apply the action to a notification and issue the notification. * {Kotlin} ```kotlin // Build the notification and add the action. val newMessageNotification = Notification.Builder(context, CHANNEL_ID) .setSmallIcon(R.drawable.ic_message) .setContentTitle(getString(R.string.title)) .setContentText(getString(R.string.content)) .addAction(action) .build() // Issue the notification. with(NotificationManagerCompat.from(this)) { notificationManager.notify(notificationId, newMessageNotification) } ``` * {Java} ```java // Build the notification and add the action. Notification newMessageNotification = new Notification.Builder(context, CHANNEL_ID) .setSmallIcon(R.drawable.ic_message) .setContentTitle(getString(R.string.title)) .setContentText(getString(R.string.content)) .addAction(action) .build(); // Issue the notification. NotificationManagerCompat notificationManager = NotificationManagerCompat.from(this); notificationManager.notify(notificationId, newMessageNotification); ```
The system prompts the user to input a response when they trigger the notification action, as shown in figure 4.

Retrieve user input from the reply
To receive user input from the notification's reply UI, call RemoteInput.getResultsFromIntent(), passing it the Intent received by your BroadcastReceiver:

Kotlin
Java

private fun getMessageText(intent: Intent): CharSequence? {
    return RemoteInput.getResultsFromIntent(intent)?.getCharSequence(KEY_TEXT_REPLY)
}
After you process the text, update the notification by calling NotificationManagerCompat.notify() with the same ID and tag, if used. This is necessary to hide the direct reply UI and confirm to the user that their reply is received and processed correctly.

Kotlin
Java

// Build a new notification, which informs the user that the system
// handled their interaction with the previous notification.
val repliedNotification = Notification.Builder(context, CHANNEL_ID)
        .setSmallIcon(R.drawable.ic_message)
        .setContentText(getString(R.string.replied))
        .build()

// Issue the new notification.
NotificationManagerCompat.from(this).apply {
    notificationManager.notify(notificationId, repliedNotification)
}
Retrieve other data
Handling other data types works similarly with RemoteInput. The following example uses image as input.

Kotlin

  // Key for the data that's delivered in the action's intent.
  private val KEY_REPLY = "key_reply"
  var replyLabel: String = resources.getString(R.string.reply_label)
  var remoteInput: RemoteInput = RemoteInput.Builder(KEY_REPLY).run {
      setLabel(replyLabel)
      // Allow for image data types in the input
  // This method can be used again to
  // allow for other data types
      setAllowDataType("image/*", true)
      build()
}
Call RemoteInput#getDataResultsFromIntent and extract the corresponding data.

Kotlin

  import android.app.RemoteInput;
  import android.content.Intent;
  import android.os.Bundle;

  class ReplyReceiver: BroadcastReceiver()  {

      public static final String KEY_DATA = "key_data";

      public static void handleRemoteInput(Intent intent) {
          Bundle dataResults = RemoteInput.getDataResultsFromIntent(intent, KEY_DATA);
          val imageUri: Uri? = dataResults.values.firstOrNull()
          if (imageUri != null) {
              // Extract the image
          try {
                  val inputStream = context.contentResolver.openInputStream(imageUri)
                  val bitmap = BitmapFactory.decodeStream(inputStream)
                  // Display the image
                  // ...
              } catch (e: Exception) {
                  Log.e("ReplyReceiver", "Failed to process image URI", e)
              }
      }
  }
When working with this new notification, use the context that's passed to the receiver's onReceive() method.

Append the reply to the bottom of the notification by calling setRemoteInputHistory(). However, if you're building a messaging app, create a messaging-style notification and append the new message to the conversation.

For more advice for notifications from a messaging apps, see the section about best practices for messaging apps.

Show an urgent message
Your app might need to display an urgent, time-sensitive message, such as an incoming phone call or a ringing alarm. In these situations, you can associate a full-screen intent with your notification.

Caution: Notifications containing full-screen intents are substantially intrusive, so it's important to only use this type of notification for the most urgent, time-sensitive messages.
When the notification is invoked, users see one of the following, depending on the device's lock status:

If the user's device is locked, a full-screen activity appears, covering the lockscreen.
If the user's device is unlocked, the notification appears in an expanded form that includes options for handling or dismissing the notification.
Note: If your app targets Android 10 (API level 29) or later, you must request the USE_FULL_SCREEN_INTENT permission in your app's manifest file for the system to launch the full-screen activity associated with the time-sensitive notification.
The following code snippet demonstrates how to associate your notification with a full-screen intent:

Kotlin
Java

val fullScreenIntent = Intent(this, ImportantActivity::class.java)
val fullScreenPendingIntent = PendingIntent.getActivity(this, 0,
    fullScreenIntent, PendingIntent.FLAG_UPDATE_CURRENT)

var builder = NotificationCompat.Builder(this, CHANNEL_ID)
        .setSmallIcon(R.drawable.notification_icon)
        .setContentTitle("My notification")
        .setContentText("Hello World!")
        .setPriority(NotificationCompat.PRIORITY_DEFAULT)
        <b>.setFullScreenIntent(fullScreenPendingIntent, true)</b>
Set lock screen visibility
To control the level of detail visible in the notification from the lock screen, call setVisibility() and specify one of the following values:

VISIBILITY_PUBLIC: the notification's full content shows on the lock screen.

VISIBILITY_SECRET: no part of the notification shows on the lock screen.

VISIBILITY_PRIVATE: only basic information, such as the notification's icon and the content title, shows on the lock screen. The notification's full content doesn't show.

When you set VISIBILITY_PRIVATE, you can also provide an alternate version of the notification content that hides certain details. For example, an SMS app might display a notification that shows "You have 3 new text messages," but hides the message contents and senders. To provide this alternative notification, first create the alternative notification with NotificationCompat.Builder as usual. Then, attach the alternative notification to the normal notification with setPublicVersion().

Bear in mind that the user always has ultimate control over whether their notifications are visible on the lock screen and can control them based on your app's notification channels.

Update a notification
To update a notification after you issue it, call NotificationManagerCompat.notify() again, passing it the same ID you used before. If the previous notification is dismissed, a new notification is created instead.

You can optionally call setOnlyAlertOnce() so your notification interrupts the user—with sound, vibration, or visual clues—only the first time the notification appears and not for later updates.

Caution: Android applies a rate limit when updating a notification. If you post updates to a notification too frequently—many in less than one second—the system might drop updates.
Remove a notification
Notifications remain visible until one of the following happens:

The user dismisses the notification.
The user taps the notification, if you call setAutoCancel() when you create the notification.
You call cancel() for a specific notification ID. This method also deletes ongoing notifications.
You call cancelAll(), which removes all notifications you previously issued.
The specified duration elapses, if you set a timeout when creating the notification, using setTimeoutAfter(). If required, you can cancel a notification before the specified timeout duration elapses.
Best practices for messaging apps
Consider the best practices listed here when creating notifications for your messaging and chat apps.

Use MessagingStyle
Starting in Android 7.0 (API level 24), Android provides a notification style template specifically for messaging content. Using the NotificationCompat.MessagingStyle class, you can change several of the labels displayed on the notification, including the conversation title, additional messages, and the content view for the notification.

The following code snippet demonstrates how to customize a notification's style using the MessagingStyle class.

Kotlin
Java

val user = Person.Builder()
    .setIcon(userIcon)
    .setName(userName)
    .build()

val notification = NotificationCompat.Builder(this, CHANNEL_ID)
    .setContentTitle("2 new messages with $sender")
    .setContentText(subject)
    .setSmallIcon(R.drawable.new_message)
    .setStyle(NotificationCompat.MessagingStyle(user)
        .addMessage(messages[1].getText(), messages[1].getTime(), messages[1].getPerson())
        .addMessage(messages[2].getText(), messages[2].getTime(), messages[2].getPerson())
    )
    .build()
Starting in Android 9.0 (API level 28), It is also required to use the Person class in order to get an optimal rendering of the notification and its avatars.

When using NotificationCompat.MessagingStyle, do the following:

Call MessagingStyle.setConversationTitle() to set a title for group chats with more than two people. A good conversation title might be the name of the group chat or, if it doesn't have a name, a list of the participants in the conversation. Without this, the message might be mistaken as belonging to a one-to-one conversation with the sender of the most recent message in the conversation.
Use the MessagingStyle.setData() method to include media messages such as images. MIME types of the pattern image/* are supported.
Use Direct Reply
Direct Reply lets a user reply inline to a message.

After a user replies with the inline reply action, use MessagingStyle.addMessage() to update the MessagingStyle notification, and don't retract or cancel the notification. Not cancelling the notification lets the user send multiple replies from the notification.
To make the inline reply action compatible with Wear OS, call Action.WearableExtender.setHintDisplayInlineAction(true).
Use the addHistoricMessage() method to provide context to a direct reply conversation by adding historic messages to the notification.
Enable Smart Reply
To enable Smart Reply, call setAllowGeneratedResponses(true) on the reply action. This causes Smart Reply responses to be available to users when the notification is bridged to a Wear OS device. Smart Reply responses are generated by an entirely on-watch machine learning model using the context provided by the NotificationCompat.MessagingStyle notification, and no data is uploaded to the internet to generate the responses.
Add notification metadata
Assign notification metadata to tell the system how to handle your app notifications when the device is in Do Not Disturb mode. For example, use the addPerson() or setCategory(Notification.CATEGORY_MESSAGE) method to override the Do Not Disturb.
Was this helpful?

Content and code samples on this page are subject to the licenses described in the Content License. Java and OpenJDK are trademarks or registered trademarks of Oracle and/or its affiliates.

Last updated 2025-09-03 UTC.