package com.habittracker.habitv8

import android.app.Activity
import android.app.AlarmManager
import android.app.PendingIntent
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
                        if (loop == true) {
                            // For looping alarms, use the foreground service
                            AlarmService.startAlarmService(this, soundUri, habitName)
                            result.success(true)
                        } else {
                            // For previews, use the old method
                            playSystemSound(soundUri, volume ?: 0.8, loop ?: false, habitName)
                            result.success(true)
                        }
                    } catch (e: Exception) {
                        result.error("SOUND_ERROR", "Failed to play system sound: ", null)
                    }
                }
                "stopSystemSound" -> {
                    try {
                        // Stop both the foreground service and any playing ringtones
                        val intent = Intent(this, AlarmService::class.java)
                        stopService(intent)
                        
                        // Also stop any ringtones playing directly
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
        
        // Native alarm scheduling channel (simple and reliable)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, NATIVE_ALARM_CHANNEL).setMethodCallHandler { call, result ->
            // Check if activity is still valid before processing method calls
            if (isFinishing || isDestroyed) {
                result.error("ACTIVITY_INVALID", "Activity is no longer valid", null)
                return@setMethodCallHandler
            }

            when (call.method) {
                "scheduleNativeAlarm" -> {
                    try {
                        val alarmId = call.argument<Int>("alarmId") ?: 0
                        val triggerTimeMillis = call.argument<Long>("triggerTimeMillis") ?: 0L
                        val soundUri = call.argument<String>("soundUri")
                        val habitName = call.argument<String>("habitName") ?: "Habit Reminder"
                        
                        scheduleNativeAlarm(alarmId, triggerTimeMillis, soundUri, habitName)
                        result.success(true)
                        android.util.Log.i("MainActivity", "Native alarm scheduled for: $habitName")
                    } catch (e: Exception) {
                        result.error("ALARM_ERROR", "Failed to schedule native alarm: ${e.message}", null)
                        android.util.Log.e("MainActivity", "Failed to schedule native alarm", e)
                    }
                }
                "cancelNativeAlarm" -> {
                    try {
                        val alarmId = call.argument<Int>("alarmId") ?: 0
                        cancelNativeAlarm(alarmId)
                        result.success(true)
                        android.util.Log.i("MainActivity", "Native alarm cancelled: $alarmId")
                    } catch (e: Exception) {
                        result.error("ALARM_ERROR", "Failed to cancel native alarm: ${e.message}", null)
                        android.util.Log.e("MainActivity", "Failed to cancel native alarm", e)
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
                        // Force immediate widget refresh by directly updating the widget provider
                        val intent = Intent(this, HabitCompactWidgetProvider::class.java)
                        intent.action = "android.appwidget.action.APPWIDGET_UPDATE"
                        sendBroadcast(intent)
                        
                        // Also trigger WorkManager update for good measure
                        val updateRequest = OneTimeWorkRequestBuilder<WidgetUpdateWorker>().build()
                        WorkManager.getInstance(this).enqueue(updateRequest)
                        
                        result.success(true)
                        android.util.Log.i("MainActivity", "Widget force refresh triggered")
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
            previewRingtone = RingtoneManager.getRingtone(applicationContext, uri)
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                previewRingtone?.audioAttributes = AudioAttributes.Builder()
                    .setUsage(AudioAttributes.USAGE_ALARM)
                    .setContentType(AudioAttributes.CONTENT_TYPE_MUSIC)
                    .build()
            }
            previewRingtone?.play()
        } catch (_: Exception) {
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
            
            alarmRingtone = RingtoneManager.getRingtone(applicationContext, uri)
            
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
                val ringtone = RingtoneManager.getRingtone(applicationContext, uri)
                val name = ringtone.getTitle(applicationContext)
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
    
    /**
     * Schedule a native Android alarm using AlarmManager
     * This properly integrates with the Android system and works reliably
     */
    private fun scheduleNativeAlarm(alarmId: Int, triggerTimeMillis: Long, soundUri: String?, habitName: String) {
        try {
            val alarmManager = getSystemService(Context.ALARM_SERVICE) as AlarmManager
            
            // Create intent for AlarmReceiver
            val intent = Intent(this, AlarmReceiver::class.java).apply {
                putExtra(AlarmReceiver.EXTRA_ALARM_ID, alarmId)
                putExtra(AlarmReceiver.EXTRA_SOUND_URI, soundUri)
                putExtra(AlarmReceiver.EXTRA_HABIT_NAME, habitName)
            }
            
            // Create PendingIntent with unique request code based on alarm ID
            val pendingIntent = PendingIntent.getBroadcast(
                this, 
                alarmId, 
                intent, 
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            
            // Use exact alarm for habit reminders (user-facing feature)
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                // Check if we can schedule exact alarms
                if (alarmManager.canScheduleExactAlarms()) {
                    alarmManager.setExactAndAllowWhileIdle(
                        AlarmManager.RTC_WAKEUP,
                        triggerTimeMillis,
                        pendingIntent
                    )
                } else {
                    // Fall back to inexact alarm if exact alarms not permitted
                    alarmManager.setAndAllowWhileIdle(
                        AlarmManager.RTC_WAKEUP,
                        triggerTimeMillis,
                        pendingIntent
                    )
                }
            } else {
                // For older Android versions, use exact alarm
                alarmManager.setExactAndAllowWhileIdle(
                    AlarmManager.RTC_WAKEUP,
                    triggerTimeMillis,
                    pendingIntent
                )
            }
            
            android.util.Log.i("MainActivity", "Native alarm scheduled for ${java.util.Date(triggerTimeMillis)}")
            
        } catch (e: Exception) {
            android.util.Log.e("MainActivity", "Error scheduling native alarm", e)
            throw e
        }
    }
    
    /**
     * Cancel a previously scheduled native alarm
     */
    private fun cancelNativeAlarm(alarmId: Int) {
        try {
            val alarmManager = getSystemService(Context.ALARM_SERVICE) as AlarmManager
            
            // Create the same intent used for scheduling
            val intent = Intent(this, AlarmReceiver::class.java)
            val pendingIntent = PendingIntent.getBroadcast(
                this, 
                alarmId, 
                intent, 
                PendingIntent.FLAG_NO_CREATE or PendingIntent.FLAG_IMMUTABLE
            )
            
            // Cancel the alarm if it exists
            pendingIntent?.let {
                alarmManager.cancel(it)
                it.cancel()
                android.util.Log.i("MainActivity", "Native alarm cancelled: $alarmId")
            }
            
        } catch (e: Exception) {
            android.util.Log.e("MainActivity", "Error cancelling native alarm", e)
            throw e
        }
    }
}
