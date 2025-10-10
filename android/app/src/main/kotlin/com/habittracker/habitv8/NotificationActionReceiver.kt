package com.habittracker.habitv8

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import android.os.Handler
import android.os.Looper
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.view.FlutterCallbackInformation
import io.flutter.FlutterInjector

/**
 * Pre-warms the Flutter engine before notification actions are processed.
 * 
 * This receiver has HIGHER PRIORITY than flutter_local_notifications'
 * ActionBroadcastReceiver, so it receives the broadcast first and can prepare
 * the Flutter engine before the Dart background handler needs to execute.
 * 
 * CRITICAL: This solves the issue where the Dart background isolate fails to
 * start when the app is completely killed. By starting the Flutter engine
 * proactively, we ensure the background handler can execute successfully.
 */
class NotificationActionReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        Log.d(TAG, "🔔 === NOTIFICATION ACTION INTERCEPTED ===")
        Log.d(TAG, "Action: ${intent.action}")
        
        // Log all extras for debugging
        intent.extras?.let { extras ->
            for (key in extras.keySet()) {
                Log.d(TAG, "Extra[$key]: ${extras.get(key)}")
            }
        }
        
        // Start Flutter engine in background BEFORE the plugin's handler processes it
        try {
            Log.d(TAG, "🚀 Pre-warming Flutter engine for background execution...")
            
            // Create Flutter engine but DON'T execute any Dart code yet
            // Just having the engine initialized helps the plugin's background
            // handler start successfully when the app is killed
            val flutterEngine = FlutterEngine(context.applicationContext)
            
            // NOTE: We do NOT call executeDartEntrypoint() here because:
            // 1. That would run main() and open the app UI (not what we want)
            // 2. flutter_local_notifications will execute the correct background
            //    callback (onBackgroundNotificationResponseIsar) on its own
            // 3. We just need the engine to be available/initialized
            
            Log.d(TAG, "✅ Flutter engine initialized (ready for background handler)")
            
            // Store the engine reference so it stays alive during background execution
            engineCache = flutterEngine
            
        } catch (e: Exception) {
            Log.e(TAG, "⚠️ Failed to initialize Flutter engine: ${e.message}", e)
            // Non-critical - flutter_local_notifications will try to start its own engine
        }
        
        // CRITICAL FIX: Schedule widget update AFTER Dart background handler completes
        // Give the Flutter background handler time to complete the habit in the database
        // Then force widget refresh using native Android APIs (works even when app is killed)
        val actionId = intent.getStringExtra("actionId")
        Log.d(TAG, "Extracted actionId: $actionId")
        
        // Update widgets for any notification action (complete, snooze, etc.)
        // The Dart code will handle the action, we just need to refresh widgets afterwards
        Log.d(TAG, "📱 Notification action detected - scheduling widget update...")
        
        // Schedule widget refresh after 2 seconds (gives Dart code time to complete)
        Handler(Looper.getMainLooper()).postDelayed({
            try {
                Log.d(TAG, "🔄 Triggering widget refresh after notification action...")
                WidgetUpdateHelper.forceWidgetRefresh(context)
                Log.d(TAG, "✅ Widget refresh completed successfully")
                
                // Clean up engine cache after update completes
                engineCache = null
            } catch (e: Exception) {
                Log.e(TAG, "❌ Failed to refresh widgets: ${e.message}", e)
            }
        }, 2000) // 2 second delay
        
        // DO NOT call abortBroadcast() - let the flutter_local_notifications
        // ActionBroadcastReceiver also receive this intent to execute the Dart handler
    }
    
    companion object {
        private const val TAG = "NotifActionPreWarm"
        private var engineCache: FlutterEngine? = null
    }
}