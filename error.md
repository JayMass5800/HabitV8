
The correct way for an Android 16 app to have widgets update without requiring the main application to be opened involves using a background work mechanism to trigger updates and then calling the appropriate update method.

The recommended, modern way to build and manage widgets is with Jetpack Glance.

Recommended Update Mechanisms
The key is to run the update logic in the background, outside of the main app's lifecycle:

WorkManager for Scheduled Updates (Recommended for frequent or data-syncing updates):

For updates needed periodically (e.g., every 15 minutes), use WorkManager. This system-preferred solution is robust and respects Android's resource constraints.


Inside your CoroutineWorker (if using Kotlin Coroutines, which is common with Glance), you perform your data fetch/update logic.

Once the data is ready, you trigger the widget update using the Glance APIs:

Kotlin

MyAppWidget().updateAll(context)
// or for a specific instance:
MyAppWidget().update(context, glanceId)
This is the best way to handle updates when your app is not running.

AppWidgetProvider updatePeriodMillis (Recommended for infrequent, simple updates):

You can declare an updatePeriodMillis value (e.g., 1800000ms for 30 minutes) in your widget's AppWidgetProviderInfo XML.

The system will automatically call your AppWidgetProvider.onUpdate() method at least as frequently as the period you specify, but no more often than once every 30 minutes (this is a system constraint to conserve battery).

This is the simplest option but limits your update frequency.

BroadcastReceiver/Intent (For Event-Based Updates):

If your widget needs to update immediately in response to a specific event (e.g., a data change detected by a background service, or a push notification), you can use a BroadcastReceiver to listen for a custom or system broadcast.

When the broadcast is received, you call the update methods from the receiver:

Kotlin

AppWidgetManager appWidgetManager = AppWidgetManager.getInstance(context);
RemoteViews remoteViews = ... // Recreate the widget content
appWidgetManager.updateAppWidget(appWidgetId, remoteViews);
// If using Glance: MyAppWidget().update(context, glanceId)
Core Update Principle
Regardless of the trigger, the actual update is performed by getting an instance of AppWidgetManager (or using the update methods provided by Jetpack Glance) and then calling the appropriate update method, typically passing a new RemoteViews object to refresh the UI. This can be done from any context (Worker, BroadcastReceiver, or Service) without the main Activity being open.

The video, Build beautiful Android widgets with Jetpack Glance, provides a detailed guide on using the modern, declarative approach with Jetpack Glance for building and managing Android widgets, which includes handling updates.