package com.habittracker.habitv8

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log

/**
 * Bridge receiver that intercepts notification actions and triggers widget updates
 * BEFORE the Dart background handler runs.
 * 
 * This solves the problem where widgets don't update when the app is fully closed
 * because the Dart background isolate cannot reliably send broadcasts.
 * 
 * This receiver runs in the native Android context and can reliably trigger
 * widget updates regardless of the app's state.
 */
class NotificationWidgetBridge : BroadcastReceiver() {

    companion object {
        private const val TAG = "NotificationWidgetBridge"
        
        // Awesome Notifications action broadcast
        private const val ACTION_NOTIFICATION = "me.carda.awesome_notifications.NOTIFICATION_ACTION"
        
        // Action keys that indicate habit completion
        private val COMPLETION_ACTIONS = setOf("COMPLETE", "complete", "mark_complete")
    }

    override fun onReceive(context: Context, intent: Intent) {
        try {
            Log.d(TAG, "📨 Received broadcast: ${intent.action}")
            
            // Log all extras for debugging
            val extras = intent.extras
            if (extras != null) {
                Log.d(TAG, "Intent extras:")
                for (key in extras.keySet()) {
                    Log.d(TAG, "  $key = ${extras.get(key)}")
                }
            }
            
            // Check if this is a notification action
            if (intent.action == ACTION_NOTIFICATION) {
                // Try multiple possible keys for the action
                val actionKey = intent.getStringExtra("actionKey") 
                    ?: intent.getStringExtra("action")
                    ?: intent.getStringExtra("buttonKey")
                    
                Log.d(TAG, "Action key: $actionKey")
                
                // If this is a completion action, trigger widget update immediately
                if (actionKey != null && COMPLETION_ACTIONS.contains(actionKey)) {
                    Log.i(TAG, "🎯 Completion action detected, triggering widget update")
                    
                    // Trigger immediate widget refresh using native APIs
                    // This works even when the app is fully closed
                    WidgetUpdateHelper.forceWidgetRefresh(context)
                    
                    // Also trigger WorkManager update as backup
                    WidgetUpdateWorker.triggerImmediateUpdate(context)
                    
                    Log.i(TAG, "✅ Widget update triggered from notification action")
                } else {
                    Log.d(TAG, "Not a completion action (key='$actionKey'), skipping widget update")
                }
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error handling notification action", e)
        }
    }
}