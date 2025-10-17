package com.habittracker.habitv8

import android.app.Activity
import android.app.AlarmManager
import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.database.Cursor
import android.media.AudioAttributes
import android.media.Ringtone
import android.media.RingtoneManager
import android.net.Uri
import android.os.Build
import android.os.Bundle
import androidx.activity.enableEdgeToEdge
import androidx.core.view.WindowCompat
import androidx.work.OneTimeWorkRequestBuilder
import androidx.work.PeriodicWorkRequestBuilder
import androidx.work.WorkManager
import androidx.work.Constraints
import androidx.work.NetworkType
import androidx.work.ExistingPeriodicWorkPolicy
import java.util.concurrent.TimeUnit
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterFragmentActivity() {
    private val RINGTONE_CHANNEL = "com.habittracker.habitv8/ringtones"
    private val SYSTEM_SOUND_CHANNEL = "com.habittracker.habitv8/system_sound"
    private val NATIVE_ALARM_CHANNEL = "com.habittracker.habitv8/native_alarm"
    private val ANDROID_RESOURCES_CHANNEL = "habitv8/android_resources"
    private val WIDGET_UPDATE_CHANNEL = "com.habittracker.habitv8/widget_update"
    private val RINGTONE_PICKER_REQUEST_CODE = 1

    private var previewRingtone: Ringtone? = null
    private var methodChannelResult: MethodChannel.Result? = null
    
    // Keep a static reference to the alarm ringtone to control it
    companion object {
        private var alarmRingtone: Ringtone? = null
        // CRITICAL FIX: Track looping timers to restart alarms
        private val alarmLoopingTimers = mutableMapOf<Int, android.os.Handler>()
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        // Enable edge-to-edge display for Android 15+ compatibility
        // This addresses the deprecated API warning from Google Play Store
        // Use enableEdgeToEdge() as recommended by Google for backward compatibility
        enableEdgeToEdge()
        
        super.onCreate(savedInstanceState)
        
        // Additional edge-to-edge configuration for all versions
        // This ensures proper handling of system bars and insets
        WindowCompat.setDecorFitsSystemWindows(window, false)
    }

    override fun onRestart() {
        // Clean up any stale state before restart but preserve alarm sound
        stopPreview() // Only stop preview ringtone, not alarm
        try {
            android.util.Log.i("MainActivity", "onRestart: Preserving alarm sound if playing")
            super.onRestart()
        } catch (e: android.database.StaleDataException) {
            // Catch framework requery crash and continue
            android.util.Log.w("MainActivity", "StaleDataException during onRestart; continuing", e)
        } catch (e: Exception) {
            android.util.Log.e("MainActivity", "Error during onRestart: ${e.message}", e)
        }
    }

    // Removed hidden-API reflection cleanup to avoid hiddenapi enforcement issues
    // and crashes on modern Android versions

    override fun onPause() {
        try {
            // Don't stop alarm sound on pause - it should continue until user acts
            android.util.Log.i("MainActivity", "onPause: Preserving alarm sound if playing")
            super.onPause()
        } catch (e: Exception) {
            android.util.Log.e("MainActivity", "Error during pause: ${e.message}")
        }
    }

    override fun onResume() {
        try {
            // Don't restart or stop alarm sound on resume - let it continue
            android.util.Log.i("MainActivity", "onResume: Preserving alarm sound state")
            super.onResume()
        } catch (e: Exception) {
            android.util.Log.e("MainActivity", "Error during resume: ${e.message}")
        }
    }

    override fun onNewIntent(intent: Intent) {
        try {
            android.util.Log.d("MainActivity", "onNewIntent called with action: ${intent.action}")

            // Handle complete alarm action
            if ("COMPLETE_ALARM" == intent.action) {
                val habitId = intent.getStringExtra("habitId")
                val habitName = intent.getStringExtra("habitName")
                
                android.util.Log.i("MainActivity", "Complete alarm action received for: $habitName")
                
                // Notify Flutter about the completion via method channel
                flutterEngine?.dartExecutor?.binaryMessenger?.let { messenger ->
                    val channel = MethodChannel(messenger, "com.habittracker.habitv8/alarm_complete")
                    channel.invokeMethod("onAlarmComplete", mapOf(
                        "habitId" to habitId,
                        "habitName" to habitName
                    ))
                }
                
                setIntent(intent)
                super.onNewIntent(intent)
                return
            }

            // Handle snooze alarm action
            if ("SNOOZE_ALARM" == intent.action) {
                val habitId = intent.getStringExtra("habitId")
                val habitName = intent.getStringExtra("habitName")
                val soundUri = intent.getStringExtra("soundUri")
                
                android.util.Log.i("MainActivity", "Snooze alarm action received for: $habitName")
                
                // Notify Flutter about the snooze via method channel
                flutterEngine?.dartExecutor?.binaryMessenger?.let { messenger ->
                    val channel = MethodChannel(messenger, "com.habittracker.habitv8/alarm_snooze")
                    channel.invokeMethod("onAlarmSnooze", mapOf(
                        "habitId" to habitId,
                        "habitName" to habitName,
                        "soundUri" to soundUri
                    ))
                }
                
                setIntent(intent)
                super.onNewIntent(intent)
                return
            }

            // CRITICAL FIX: Don't restart app on notification interactions - preserve alarm service
            if ("SELECT_NOTIFICATION" == intent.action || "SELECT_FOREGROUND_NOTIFICATION" == intent.action) {
                setIntent(intent)
                android.util.Log.i("MainActivity", "Notification interaction - preserving alarm service and continuing normally")
                // Just handle the intent normally without restarting the app
                // This prevents the alarm service from being killed
                super.onNewIntent(intent)
                return
            }

            super.onNewIntent(intent)
            setIntent(intent)
        } catch (e: android.database.StaleDataException) {
            android.util.Log.w("MainActivity", "StaleDataException in onNewIntent - handling gracefully", e)
            try { setIntent(intent) } catch (_: Exception) {}
        } catch (e: Exception) {
            android.util.Log.e("MainActivity", "Error in onNewIntent: ${e.message}", e)
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Background widget update channel - works from background isolates
        // This channel uses application context, not activity context, so it works
        // even when the app is fully closed and a background isolate is running
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.habittracker.habitv8/background_widget_update").setMethodCallHandler { call, result ->
            when (call.method) {
                "updateWidgets" -> {
                    try {
                        android.util.Log.i("BackgroundWidget", "🔄 Widget update requested from background isolate")
                        
                        // Use application context to update widgets
                        // This works even when MainActivity is not running
                        val context = applicationContext
                        WidgetUpdateHelper.forceWidgetRefresh(context)
                        WidgetUpdateWorker.triggerImmediateUpdate(context)
                        
                        android.util.Log.i("BackgroundWidget", "✅ Widget update completed from background")
                        result.success(true)
                    } catch (e: Exception) {
                        android.util.Log.e("BackgroundWidget", "❌ Failed to update widgets from background", e)
                        result.error("WIDGET_UPDATE_ERROR", e.message, null)
                    }
                }
                else -> result.notImplemented()
            }
        }

        // Android Resources channel for accessing string resources and billing configuration
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, ANDROID_RESOURCES_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getStringResource" -> {
                    val resourceName = call.argument<String>("resourceName")
                    if (resourceName != null) {
                        try {
                            val resourceId = resources.getIdentifier(resourceName, "string", packageName)
                            if (resourceId != 0) {
                                val value = getString(resourceId)
                                result.success(value)
                            } else {
                                result.error("RESOURCE_NOT_FOUND", "String resource not found: $resourceName", null)
                            }
                        } catch (e: Exception) {
                            result.error("RESOURCE_ERROR", "Failed to get string resource: ${e.message}", null)
                        }
                    } else {
                        result.error("INVALID_ARGUMENT", "resourceName is required", null)
                    }
                }
                "getBillingStrings" -> {
                    try {
                        val billingStrings = mapOf(
                            "product_premium_lifetime_access" to getString(R.string.product_premium_lifetime_access),
                            "product_premium_title" to getString(R.string.product_premium_title),
                            "product_premium_description" to getString(R.string.product_premium_description),
                            "billing_unavailable" to getString(R.string.billing_unavailable),
                            "product_not_found" to getString(R.string.product_not_found),
                            "purchase_failed" to getString(R.string.purchase_failed),
                            "purchase_successful" to getString(R.string.purchase_successful),
                            "restore_successful" to getString(R.string.restore_successful),
                            "no_purchases_found" to getString(R.string.no_purchases_found)
                        )
                        result.success(billingStrings)
                    } catch (e: Exception) {
                        result.error("BILLING_STRINGS_ERROR", "Failed to get billing strings: ${e.message}", null)
                    }
                }
                else -> result.notImplemented()
            }
        }

        // Ringtone listing/preview channel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, RINGTONE_CHANNEL).setMethodCallHandler { call, result ->
            // Check if activity is still valid before processing method calls
            if (isFinishing || isDestroyed) {
                result.error("ACTIVITY_INVALID", "Activity is no longer valid", null)
                return@setMethodCallHandler
            }
            
            when (call.method) {
                "list" -> {
                    try {
                        result.success(listRingtones())
                    } catch (e: Exception) {
                        result.error("RINGTONE_ERROR", "Failed to list ringtones: ${e.message}", null)
                    }
                }
                "preview" -> {
                    val uriStr = call.argument<String>("uri")
                    if (uriStr == null) {
                        result.error("ARG", "uri is required", null)
                    } else {
                        try {
                            previewRingtone(uriStr)
                            result.success(true)
                        } catch (e: Exception) {
                            result.error("PREVIEW_ERROR", "Failed to preview ringtone: ${e.message}", null)
                        }
                    }
                }
                "stop" -> {
                    try {
                        stopPreview()
                        result.success(true)
                    } catch (e: Exception) {
                        result.error("STOP_ERROR", "Failed to stop preview: ${e.message}", null)
                    }
                }
                else -> result.notImplemented()
            }
        }
        
        // System sound channel for alarm sound playback and picker
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, SYSTEM_SOUND_CHANNEL).setMethodCallHandler { call, result ->
            // Check if activity is still valid before processing method calls
            if (isFinishing || isDestroyed) {
                result.error("ACTIVITY_INVALID", "Activity is no longer valid", null)
                return@setMethodCallHandler
            }

            when (call.method) {
                "openRingtonePicker" -> {
                    this.methodChannelResult = result
                    openRingtonePicker()
                }
                "playSystemSound" -> {
                    val soundUri: String? = call.argument("soundUri")
                    val volume: Double? = call.argument("volume")
                    val loop: Boolean? = call.argument("loop")
                    val habitName: String? = call.argument("habitName")
                    try {
                        // Note: Alarm playback now handled by awesome_notifications
                        // This is kept for preview functionality only
                        playSystemSound(soundUri, volume ?: 0.8, loop ?: false, habitName)
                        result.success(true)
                    } catch (e: Exception) {
                        result.error("SOUND_ERROR", "Failed to play system sound: ", null)
                    }
                }
                "stopSystemSound" -> {
                    try {
                        // Stop any ringtones playing directly (preview only)
                        stopSystemSound()
                        result.success(true)
                    } catch (e: Exception) {
                        result.error("STOP_ERROR", "Failed to stop system sound: ", null)
                    }
                }
                "getSystemRingtones" -> {
                    try {
                        result.success(getSystemRingtones())
                    } catch (e: Exception) {
                        result.error("RINGTONE_ERROR", "Failed to get system ringtones: ", null)
                    }
                }
                else -> result.notImplemented()
            }
        }
        
        // CRITICAL: Native alarm sound handler for proper alarm playback
        // This bypasses AudioPlayer and uses Android's RingtoneManager directly
        // which properly handles alarm audio streams and audio focus
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, NATIVE_ALARM_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "playAlarmSound" -> {
                    val alarmId: Int? = call.argument("alarmId")
                    val soundUri: String? = call.argument("soundUri")
                    val volume: Double? = call.argument("volume")
                    
                    if (alarmId == null) {
                        result.error("MISSING_ARG", "alarmId is required", null)
                        return@setMethodCallHandler
                    }
                    
                    try {
                        android.util.Log.i("NativeAlarm", "🚨 Playing native alarm sound for ID: $alarmId, URI: $soundUri")
                        playNativeAlarmSound(alarmId, soundUri, volume ?: 1.0)
                        result.success(true)
                    } catch (e: Exception) {
                        android.util.Log.e("NativeAlarm", "❌ Failed to play native alarm: ${e.message}", e)
                        result.error("ALARM_ERROR", "Failed to play alarm: ${e.message}", null)
                    }
                }
                "stopAlarmSound" -> {
                    val alarmId: Int? = call.argument("alarmId")
                    
                    if (alarmId == null) {
                        result.error("MISSING_ARG", "alarmId is required", null)
                        return@setMethodCallHandler
                    }
                    
                    try {
                        android.util.Log.i("NativeAlarm", "🔇 Stopping native alarm sound for ID: $alarmId")
                        android.util.Log.i("NativeAlarm", "   Active alarms: ${activeAlarmRingtones.keys}")
                        stopNativeAlarmSound(alarmId)
                        android.util.Log.i("NativeAlarm", "   Remaining active alarms: ${activeAlarmRingtones.keys}")
                        result.success(true)
                    } catch (e: Exception) {
                        android.util.Log.e("NativeAlarm", "❌ Failed to stop alarm: ${e.message}", e)
                        result.error("STOP_ERROR", "Failed to stop alarm: ${e.message}", null)
                    }
                }
                "stopAllAlarms" -> {
                    // EMERGENCY STOP - stops ALL active alarms
                    try {
                        android.util.Log.e("NativeAlarm", "🚨 EMERGENCY STOP - stopping ALL alarms!")
                        android.util.Log.e("NativeAlarm", "   Active alarms before stop: ${activeAlarmRingtones.keys}")
                        val alarmIds = activeAlarmRingtones.keys.toList()
                        for (id in alarmIds) {
                            stopNativeAlarmSound(id)
                        }
                        android.util.Log.i("NativeAlarm", "✅ All alarms stopped")
                        result.success(true)
                    } catch (e: Exception) {
                        android.util.Log.e("NativeAlarm", "❌ Failed to stop all alarms: ${e.message}", e)
                        result.error("STOP_ALL_ERROR", "Failed to stop all alarms: ${e.message}", null)
                    }
                }
                else -> result.notImplemented()
            }
        }
        
        // Widget update channel for triggering WorkManager updates
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, WIDGET_UPDATE_CHANNEL).setMethodCallHandler { call, result ->
            // Check if activity is still valid before processing method calls
            if (isFinishing || isDestroyed) {
                result.error("ACTIVITY_INVALID", "Activity is no longer valid", null)
                return@setMethodCallHandler
            }

            when (call.method) {
                "triggerWidgetUpdate" -> {
                    try {
                        // Trigger immediate widget update via WorkManager
                        val updateRequest = OneTimeWorkRequestBuilder<WidgetUpdateWorker>().build()
                        WorkManager.getInstance(this).enqueue(updateRequest)
                        
                        result.success(true)
                        android.util.Log.i("MainActivity", "Widget update triggered via WorkManager")
                    } catch (e: Exception) {
                        result.error("WIDGET_UPDATE_ERROR", "Failed to trigger widget update: ${e.message}", null)
                        android.util.Log.e("MainActivity", "Failed to trigger widget update", e)
                    }
                }
                "forceWidgetRefresh" -> {
                    try {
                        android.util.Log.i("MainActivity", "🔄 Force widget refresh requested")
                        
                        // Get AppWidgetManager
                        val appWidgetManager = AppWidgetManager.getInstance(this)
                        
                        // Get all widget IDs for timeline widgets
                        val timelineWidgetIds = appWidgetManager.getAppWidgetIds(
                            ComponentName(this, HabitTimelineWidgetProvider::class.java)
                        )
                        
                        // Get all widget IDs for compact widgets
                        val compactWidgetIds = appWidgetManager.getAppWidgetIds(
                            ComponentName(this, HabitCompactWidgetProvider::class.java)
                        )
                        
                        android.util.Log.i("MainActivity", "Found ${timelineWidgetIds.size} timeline widgets, ${compactWidgetIds.size} compact widgets")
                        
                        // CRITICAL: Directly notify ListView to reload data (this calls onDataSetChanged)
                        timelineWidgetIds.forEach { widgetId ->
                            appWidgetManager.notifyAppWidgetViewDataChanged(widgetId, R.id.habits_list)
                            android.util.Log.i("MainActivity", "✅ Notified timeline widget $widgetId to reload data")
                        }
                        
                        compactWidgetIds.forEach { widgetId ->
                            appWidgetManager.notifyAppWidgetViewDataChanged(widgetId, R.id.compact_habits_list)
                            android.util.Log.i("MainActivity", "✅ Notified compact widget $widgetId to reload data")
                        }
                        
                        // Also send broadcast to trigger onUpdate() for header/footer updates
                        val timelineIntent = Intent(this, HabitTimelineWidgetProvider::class.java)
                        timelineIntent.action = "android.appwidget.action.APPWIDGET_UPDATE"
                        timelineIntent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, timelineWidgetIds)
                        sendBroadcast(timelineIntent)
                        
                        val compactIntent = Intent(this, HabitCompactWidgetProvider::class.java)
                        compactIntent.action = "android.appwidget.action.APPWIDGET_UPDATE"
                        compactIntent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, compactWidgetIds)
                        sendBroadcast(compactIntent)
                        
                        result.success(true)
                        android.util.Log.i("MainActivity", "✅ Widget force refresh completed successfully")
                    } catch (e: Exception) {
                        result.error("WIDGET_REFRESH_ERROR", "Failed to force widget refresh: ${e.message}", null)
                        android.util.Log.e("MainActivity", "Failed to force widget refresh", e)
                    }
                }
                "schedulePeriodicUpdates" -> {
                    try {
                        // Use the centralized scheduling method from WidgetUpdateWorker
                        WidgetUpdateWorker.schedulePeriodicUpdates(this)
                        
                        result.success(true)
                        android.util.Log.i("MainActivity", "Periodic widget updates scheduled via WidgetUpdateWorker")
                    } catch (e: Exception) {
                        result.error("SCHEDULE_ERROR", "Failed to schedule periodic updates: ${e.message}", null)
                        android.util.Log.e("MainActivity", "Failed to schedule periodic updates", e)
                    }
                }
                "triggerImmediateUpdate" -> {
                    try {
                        // Use the centralized method from WidgetUpdateWorker
                        WidgetUpdateWorker.triggerImmediateUpdate(this)
                        
                        result.success(true)
                        android.util.Log.i("MainActivity", "Immediate widget update triggered via WidgetUpdateWorker")
                    } catch (e: Exception) {
                        result.error("UPDATE_ERROR", "Failed to trigger immediate update: ${e.message}", null)
                        android.util.Log.e("MainActivity", "Failed to trigger immediate update", e)
                    }
                }
                "sendHabitCompletionBroadcast" -> {
                    try {
                        android.util.Log.i("MainActivity", "📢 Sending habit completion broadcast from Dart")
                        
                        // Use the helper to send broadcast
                        // This will trigger HabitCompletionReceiver which updates widgets
                        WidgetUpdateHelper.sendHabitCompletionBroadcast(this)
                        
                        result.success(true)
                        android.util.Log.i("MainActivity", "✅ Habit completion broadcast sent successfully")
                    } catch (e: Exception) {
                        result.error("BROADCAST_ERROR", "Failed to send habit completion broadcast: ${e.message}", null)
                        android.util.Log.e("MainActivity", "Failed to send broadcast", e)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun listRingtones(): List<Map<String, String>> {
        val out = mutableListOf<Map<String, String>>()

        fun query(type: Int, label: String) {
            // Check if activity is still valid before accessing cursors
            if (isFinishing || isDestroyed) {
                return
            }
            
            var manager: RingtoneManager? = null
            var cursor: Cursor? = null
            
            try {
                manager = RingtoneManager(applicationContext)
                manager.setType(type)
                cursor = manager.cursor
                
                // Enhanced cursor validation
                if (cursor?.isClosed != false) {
                    android.util.Log.w("MainActivity", "Cursor unavailable for $label sounds")
                    return
                }
                
                while (cursor.moveToNext() && !isFinishing && !isDestroyed) {
                    try {
                        val title = cursor.getString(RingtoneManager.TITLE_COLUMN_INDEX) ?: label
                        val uri: Uri = manager.getRingtoneUri(cursor.position)
                        
                        if (uri != null) {
                            out.add(
                                mapOf(
                                    "name" to title,
                                    "uri" to uri.toString(),
                                    "type" to "system"
                                )
                            )
                        }
                    } catch (e: Exception) {
                        android.util.Log.w("MainActivity", "Error processing ringtone item: ${e.message}")
                        continue
                    }
                }
            } catch (e: Exception) {
                // Log error but don't crash the app
                android.util.Log.e("MainActivity", "Error querying ringtones: ${e.message}")
            } finally {
                // Enhanced cleanup with logging
                try {
                    cursor?.let { c ->
                        if (!c.isClosed) {
                            c.close()
                            android.util.Log.d("MainActivity", "Cursor closed for $label sounds")
                        }
                    }
                } catch (e: Exception) {
                    android.util.Log.e("MainActivity", "Error closing cursor: ${e.message}")
                }
                
                // Clear references
                cursor = null
                manager = null
            }
        }

        // Include common types
        query(RingtoneManager.TYPE_ALARM, "Alarm")
        query(RingtoneManager.TYPE_RINGTONE, "Ringtone")
        query(RingtoneManager.TYPE_NOTIFICATION, "Notification")

        return out
    }

    private fun previewRingtone(uriStr: String) {
        try {
            stopPreview()
            val uri = Uri.parse(uriStr)
            
            // Use context with attribution tag for Android 11+ (API 30+)
            val context = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                applicationContext.createAttributionContext("alarm_sound_preview")
            } else {
                applicationContext
            }
            
            previewRingtone = RingtoneManager.getRingtone(context, uri)
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                previewRingtone?.audioAttributes = AudioAttributes.Builder()
                    .setUsage(AudioAttributes.USAGE_ALARM)
                    .setContentType(AudioAttributes.CONTENT_TYPE_MUSIC)
                    .build()
            }
            previewRingtone?.play()
        } catch (e: Exception) {
            android.util.Log.e("MainActivity", "Error previewing ringtone: ${e.message}", e)
        }
    }

    private fun stopPreview() {
        try {
            previewRingtone?.stop()
            previewRingtone = null
        } catch (_: Exception) {
        }
    }

    // System sound management methods
    private fun openRingtonePicker() {
        val intent = Intent(RingtoneManager.ACTION_RINGTONE_PICKER).apply {
            putExtra(RingtoneManager.EXTRA_RINGTONE_TYPE, RingtoneManager.TYPE_ALARM)
            putExtra(RingtoneManager.EXTRA_RINGTONE_TITLE, "Select Alarm Sound")
            putExtra(RingtoneManager.EXTRA_RINGTONE_SHOW_DEFAULT, true)
            putExtra(RingtoneManager.EXTRA_RINGTONE_SHOW_SILENT, false)
        }
        startActivityForResult(intent, RINGTONE_PICKER_REQUEST_CODE)
    }

    private fun playSystemSound(soundUri: String?, volume: Double, loop: Boolean, habitName: String?) {
        try {
            android.util.Log.i("MainActivity", "=== ALARM SOUND DEBUG ===")
            android.util.Log.i("MainActivity", "Attempting to play sound for: ${habitName ?: "Unknown"}")
            android.util.Log.i("MainActivity", "Sound URI: $soundUri")
            android.util.Log.i("MainActivity", "Volume: $volume, Loop: $loop")
            
            // Stop any currently playing alarm sound
            stopSystemSound()
            
            val uri = if (soundUri != null && soundUri != "default") {
                android.util.Log.i("MainActivity", "Using custom sound URI: $soundUri")
                Uri.parse(soundUri)
            } else {
                android.util.Log.i("MainActivity", "Using default alarm sound")
                RingtoneManager.getDefaultUri(RingtoneManager.TYPE_ALARM)
            }
            
            android.util.Log.i("MainActivity", "Final URI: $uri")
            
            // Use context with attribution tag for Android 11+ (API 30+)
            val context = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                applicationContext.createAttributionContext("alarm_sound")
            } else {
                applicationContext
            }
            
            alarmRingtone = RingtoneManager.getRingtone(context, uri)
            
            if (alarmRingtone == null) {
                android.util.Log.e("MainActivity", "❌ FAILED: RingtoneManager.getRingtone returned null!")
                throw Exception("Failed to create ringtone from URI: $uri")
            }
            
            alarmRingtone?.isLooping = loop
            
            // Set proper audio attributes for alarm sounds - use ALARM stream for persistence
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                alarmRingtone?.audioAttributes = AudioAttributes.Builder()
                    .setUsage(AudioAttributes.USAGE_ALARM)
                    .setContentType(AudioAttributes.CONTENT_TYPE_MUSIC)
                    .setFlags(AudioAttributes.FLAG_AUDIBILITY_ENFORCED)
                    .build()
                android.util.Log.i("MainActivity", "✅ Audio attributes set for API ${Build.VERSION.SDK_INT}")
            }
            
            // Set initial volume to 30% for gradual increase
            alarmRingtone?.volume = 0.3f
            
            android.util.Log.i("MainActivity", "Starting playback...")
            alarmRingtone?.play()
            
            // Verify it's actually playing
            val isPlaying = alarmRingtone?.isPlaying ?: false
            android.util.Log.i("MainActivity", "✅ Ringtone.isPlaying = $isPlaying")
            
            if (!isPlaying) {
                android.util.Log.e("MainActivity", "❌ WARNING: Ringtone is not playing after play() call")
            }
            
            // Gradually increase volume over 10 seconds
            if (isPlaying) {
                startVolumeGradualIncrease()
            }
            
            android.util.Log.i("MainActivity", "🔊 System sound playback initiated for: ${habitName ?: "Unknown"}")

        } catch (e: Exception) {
            android.util.Log.e("MainActivity", "❌ CRITICAL ERROR playing system sound: ${e.message}", e)
            throw e
        }
    }
    
    private fun startVolumeGradualIncrease() {
        val handler = android.os.Handler(android.os.Looper.getMainLooper())
        var currentVolumeStep = 3 // Start at 30%
        val maxVolumeStep = 10 // Max 100%
        val stepDuration = 1000L // 1 second per step
        
        val volumeIncreaseRunnable = object : Runnable {
            override fun run() {
                try {
                    if (alarmRingtone?.isPlaying == true && currentVolumeStep <= maxVolumeStep) {
                        val volume = currentVolumeStep / 10.0f
                        alarmRingtone?.volume = volume
                        android.util.Log.d("MainActivity", "📈 Volume increased to: ${(volume * 100).toInt()}%")
                        
                        currentVolumeStep++
                        if (currentVolumeStep <= maxVolumeStep) {
                            handler.postDelayed(this, stepDuration)
                        }
                    }
                } catch (e: Exception) {
                    android.util.Log.e("MainActivity", "Error in volume increase: ${e.message}")
                }
            }
        }
        
        handler.postDelayed(volumeIncreaseRunnable, stepDuration)
    }

    private fun stopSystemSound() {
        try {
            if (alarmRingtone?.isPlaying == true) {
                android.util.Log.i("MainActivity", "🔇 Stopping alarm sound...")
                alarmRingtone?.stop()
                android.util.Log.i("MainActivity", "✅ Alarm sound stopped")
            } else {
                android.util.Log.i("MainActivity", "ℹ️ No alarm sound playing to stop")
            }
            alarmRingtone = null
        } catch (e: Exception) {
            android.util.Log.e("MainActivity", "❌ Error stopping system sound: ${e.message}")
            // Don't rethrow - try to continue gracefully
            alarmRingtone = null
        }
    }

    // ==================== NATIVE ALARM SOUND HANDLERS ====================
    
    /// Map to track active alarm ringtones per alarm ID
    private val activeAlarmRingtones = mutableMapOf<Int, Ringtone>()
    
    /// Play alarm sound using native Android Ringtone API
    /// This properly handles:
    /// - Alarm audio stream (bypasses silent mode)
    /// - Audio focus (maintains during device interactions)
    /// - Speaker routing (plays through speaker)
    private fun playNativeAlarmSound(alarmId: Int, soundUri: String?, volume: Double) {
        try {
            // Stop any existing alarm for this ID
            stopNativeAlarmSound(alarmId)
            
            val uri = when {
                soundUri != null && soundUri != "default" -> {
                    // Check if this is an asset path (e.g., "sounds/Alarm.mp3")
                    if (soundUri.startsWith("sounds/") || !soundUri.contains("://")) {
                        getAssetUri(soundUri)
                    } else {
                        // Try to parse as a URI
                        try {
                            Uri.parse(soundUri)
                        } catch (e: Exception) {
                            android.util.Log.w("NativeAlarm", "Failed to parse URI, using default: $soundUri")
                            RingtoneManager.getDefaultUri(RingtoneManager.TYPE_ALARM)
                        }
                    }
                }
                else -> RingtoneManager.getDefaultUri(RingtoneManager.TYPE_ALARM)
            }
            
            val ringtone = RingtoneManager.getRingtone(applicationContext, uri)
            
            // Set audio attributes for ALARM stream
            // This is critical - it makes the alarm bypass silent/vibrate modes
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                val audioAttributes = AudioAttributes.Builder()
                    .setUsage(AudioAttributes.USAGE_ALARM)
                    .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                    .build()
                ringtone.audioAttributes = audioAttributes
            }
            
            // CRITICAL FIX: Implement looping since Ringtone API doesn't support it natively
            // Android's Ringtone.play() only plays once, so we need to restart it automatically
            activeAlarmRingtones[alarmId] = ringtone
            
            // Initial play
            ringtone.play()
            android.util.Log.i("NativeAlarm", "✅ Started native alarm sound for ID: $alarmId")
            
            // Setup looping mechanism using Handler
            // Restart the alarm every 3 seconds so it loops continuously
            val handler = android.os.Handler(android.os.Looper.getMainLooper())
            val runnable = object : Runnable {
                override fun run() {
                    try {
                        // Check if alarm is still active
                        if (activeAlarmRingtones.containsKey(alarmId)) {
                            // Restart the ringtone
                            if (!ringtone.isPlaying) {
                                ringtone.play()
                                android.util.Log.d("NativeAlarm", "🔄 Restarted looping alarm for ID: $alarmId")
                            }
                            // Schedule next loop in 3 seconds
                            handler.postDelayed(this, 3000)
                        } else {
                            // Alarm was stopped, remove the handler
                            alarmLoopingTimers.remove(alarmId)
                            android.util.Log.d("NativeAlarm", "⏸️ Stopped looping handler for ID: $alarmId")
                        }
                    } catch (e: Exception) {
                        android.util.Log.e("NativeAlarm", "Error in looping handler: ${e.message}")
                    }
                }
            }
            
            handler.postDelayed(runnable, 3000)
            alarmLoopingTimers[alarmId] = handler
            
            android.util.Log.i("NativeAlarm", "🔔 Alarm looping setup complete for ID: $alarmId")
            android.util.Log.i("NativeAlarm", "   URI: $uri")
            android.util.Log.i("NativeAlarm", "   Volume: $volume")
            
        } catch (e: Exception) {
            android.util.Log.e("NativeAlarm", "❌ Failed to play native alarm: ${e.message}", e)
            throw e
        }
    }
    
    /// Convert asset path to playable URI
    /// Extracts asset file to cache directory and returns file:// URI
    private fun getAssetUri(assetPath: String): Uri {
        return try {
            // Normalize the path (remove leading "sounds/")
            val normalizedPath = if (assetPath.startsWith("sounds/")) {
                assetPath.substring(7)  // Remove "sounds/" prefix
            } else {
                assetPath
            }
            
            android.util.Log.d("NativeAlarm", "🔍 Loading asset: $normalizedPath")
            
            // Get the asset file descriptor
            val assetManager = applicationContext.assets
            
            // Try to open the asset
            var inputStream: java.io.InputStream? = null
            try {
                inputStream = assetManager.open(normalizedPath)
                android.util.Log.d("NativeAlarm", "✅ Asset opened successfully: $normalizedPath")
            } catch (e: java.io.IOException) {
                android.util.Log.e("NativeAlarm", "❌ Failed to open asset: $normalizedPath - ${e.message}")
                // List available assets for debugging
                try {
                    val list = assetManager.list("sounds") ?: emptyArray()
                    android.util.Log.e("NativeAlarm", "Available sounds: ${list.joinToString(", ")}")
                } catch (e2: Exception) {
                    android.util.Log.e("NativeAlarm", "Could not list sounds directory")
                }
                throw e
            }
            
            // Create cache file with proper cleanup
            val cacheDir = applicationContext.cacheDir
            val cacheFile = java.io.File(cacheDir, "alarm_${System.currentTimeMillis()}_${normalizedPath.hashCode()}.mp3")
            
            android.util.Log.d("NativeAlarm", "📁 Extracting to: ${cacheFile.absolutePath}")
            
            // Copy asset to cache
            inputStream.use { input ->
                cacheFile.outputStream().use { output ->
                    input.copyTo(output)
                }
            }
            
            android.util.Log.i("NativeAlarm", "✅ Asset extracted successfully: ${cacheFile.absolutePath} (${cacheFile.length()} bytes)")
            
            // Return file:// URI
            Uri.fromFile(cacheFile)
        } catch (e: Exception) {
            android.util.Log.e("NativeAlarm", "❌ FAILED to load asset $assetPath: ${e.message}", e)
            android.util.Log.w("NativeAlarm", "🔔 Falling back to system alarm sound")
            RingtoneManager.getDefaultUri(RingtoneManager.TYPE_ALARM)
        }
    }
    
    /// Stop alarm sound for a specific alarm ID
    private fun stopNativeAlarmSound(alarmId: Int) {
        try {
            // CRITICAL FIX: Also stop the looping handler
            val handler = alarmLoopingTimers[alarmId]
            if (handler != null) {
                handler.removeCallbacksAndMessages(null)
                alarmLoopingTimers.remove(alarmId)
                android.util.Log.d("NativeAlarm", "🔇 Stopped looping handler for alarm ID: $alarmId")
            }
            
            val ringtone = activeAlarmRingtones[alarmId]
            if (ringtone != null && ringtone.isPlaying) {
                ringtone.stop()
                activeAlarmRingtones.remove(alarmId)
                android.util.Log.i("NativeAlarm", "✅ Stopped native alarm sound for ID: $alarmId")
            } else {
                android.util.Log.d("NativeAlarm", "ℹ️ No active alarm for ID: $alarmId")
                activeAlarmRingtones.remove(alarmId)
            }
        } catch (e: Exception) {
            android.util.Log.e("NativeAlarm", "❌ Error stopping alarm for ID: $alarmId: ${e.message}", e)
            activeAlarmRingtones.remove(alarmId)
            alarmLoopingTimers.remove(alarmId)
        }
    }

    private fun getSystemRingtones(): List<Map<String, String>> {
        val out = mutableListOf<Map<String, String>>()

        fun queryRingtones(type: Int, label: String) {
            if (isFinishing || isDestroyed) return
            
            var manager: RingtoneManager? = null
            var cursor: Cursor? = null
            
            try {
                manager = RingtoneManager(applicationContext)
                manager.setType(type)
                cursor = manager.cursor
                
                // Additional safety checks
                if (cursor?.isClosed != false) {
                    android.util.Log.w("MainActivity", "Cursor is null or closed for $label ringtones")
                    return
                }
                
                // Use indexOfOrThrow to ensure we have valid column indices
                val titleColumnIndex = try {
                    cursor.getColumnIndexOrThrow(RingtoneManager.TITLE_COLUMN_INDEX.toString())
                } catch (e: Exception) {
                    android.util.Log.w("MainActivity", "Using fallback column index for $label")
                    RingtoneManager.TITLE_COLUMN_INDEX
                }
                
                while (cursor.moveToNext() && !isFinishing && !isDestroyed) {
                    try {
                        val title = cursor.getString(titleColumnIndex) ?: "$label Sound"
                        val uri: Uri = manager.getRingtoneUri(cursor.position)
                        
                        // Validate URI before adding
                        if (uri != null) {
                            out.add(
                                mapOf(
                                    "name" to title,
                                    "uri" to uri.toString(),
                                    "type" to "system_$label"
                                )
                            )
                        }
                    } catch (e: Exception) {
                        android.util.Log.w("MainActivity", "Error processing ringtone at position ${cursor.position}: ${e.message}")
                        // Continue to next item instead of breaking
                        continue
                    }
                }
            } catch (e: Exception) {
                android.util.Log.e("MainActivity", "Error querying $label ringtones: ${e.message}")
            } finally {
                // Enhanced cleanup
                try {
                    cursor?.let { c ->
                        if (!c.isClosed) {
                            c.close()
                            android.util.Log.d("MainActivity", "Cursor closed for $label ringtones")
                        }
                    }
                } catch (e: Exception) {
                    android.util.Log.e("MainActivity", "Error closing cursor for $label: ${e.message}")
                }
                
                // Clear references
                cursor = null
                manager = null
            }
        }

        // Query all alarm, ringtone, and notification sounds with proper labeling
        queryRingtones(RingtoneManager.TYPE_ALARM, "alarm")
        queryRingtones(RingtoneManager.TYPE_RINGTONE, "ringtone")
        queryRingtones(RingtoneManager.TYPE_NOTIFICATION, "notification")

        return out
    }

    // Handle the result from the ringtone picker
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == RINGTONE_PICKER_REQUEST_CODE && resultCode == Activity.RESULT_OK) {
            val uri: Uri? = data?.getParcelableExtra(RingtoneManager.EXTRA_RINGTONE_PICKED_URI)
            if (uri != null) {
                // Use context with attribution tag for Android 11+ (API 30+)
                val context = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                    applicationContext.createAttributionContext("alarm_sound_picker")
                } else {
                    applicationContext
                }
                
                val ringtone = RingtoneManager.getRingtone(context, uri)
                val name = ringtone.getTitle(context)
                val resultData = mapOf("uri" to uri.toString(), "name" to name)
                methodChannelResult?.success(resultData)
            } else {
                methodChannelResult?.success(null) // No ringtone was selected
            }
        } else {
             methodChannelResult?.error("PICKER_ERROR", "Ringtone picker was cancelled or failed.", null)
        }
    }

    override fun onDestroy() {
        try {
            // Clean up any previewing ringtones to prevent state issues
            stopPreview()
            // Clean up any alarm sounds
            stopSystemSound()
        } catch (e: Exception) {
            android.util.Log.e("MainActivity", "Error during cleanup: ${e.message}")
        }
        super.onDestroy()
    }
    
    // Note: Native alarm scheduling methods (scheduleNativeAlarm, cancelNativeAlarm) removed
    // All alarm functionality now handled by awesome_notifications package
    // See lib/services/alarm_service.dart for the new implementation
}
