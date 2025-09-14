package com.habittracker.habitv8

import android.app.Activity
import android.content.Intent
import android.database.Cursor
import android.media.AudioAttributes
import android.media.Ringtone
import android.media.RingtoneManager
import android.net.Uri
import android.os.Build
import android.os.Bundle
import androidx.core.view.WindowCompat
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterFragmentActivity() {
    private val RINGTONE_CHANNEL = "com.habittracker.habitv8/ringtones"
    private val SYSTEM_SOUND_CHANNEL = "com.habittracker.habitv8/system_sound"
    private val RINGTONE_PICKER_REQUEST_CODE = 1

    private var previewRingtone: Ringtone? = null
    private var methodChannelResult: MethodChannel.Result? = null
    
    // Keep a static reference to the alarm ringtone to control it
    companion object {
        private var alarmRingtone: Ringtone? = null
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Enable edge-to-edge display for Android 15+ compatibility
        // This addresses the deprecated API warning from Google Play Store
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            // For Android 11+ (API 30+), use the modern edge-to-edge API
            WindowCompat.setDecorFitsSystemWindows(window, false)
        } else {
            // For older versions, maintain compatibility
            @Suppress("DEPRECATION")
            window.statusBarColor = android.graphics.Color.TRANSPARENT
            @Suppress("DEPRECATION")
            window.navigationBarColor = android.graphics.Color.TRANSPARENT
        }
    }

    override fun onRestart() {
        // Clean up any stale state before restart to prevent cursor issues
        stopPreview()
        
        // Proactively clear legacy managed cursors to avoid framework requery crash
        try { 
            clearManagedCursors() 
        } catch (_: Exception) {
            // Ignore errors during cleanup
        }
        
        try {
            super.onRestart()
        } catch (e: android.database.StaleDataException) {
            // Handle StaleDataException during activity restart
            android.util.Log.w("MainActivity", "StaleDataException caught during restart - recovering gracefully", e)
            
            // Don't call recreate() immediately as it can cause infinite loops
            // Instead, just skip the super.onRestart() call and let the activity continue
            return
        } catch (e: Exception) {
            android.util.Log.e("MainActivity", "Error during restart: ${e.message}", e)
            // For other exceptions, still try to continue
        }
    }

    /**
     * Clears Activity.mManagedCursors via reflection to prevent StaleDataException
     * on Activity.performRestart requery.
     */
    private fun clearManagedCursors() {
        try {
            // Clear managed cursors to prevent requery on stale cursors
            val managedCursorsField = android.app.Activity::class.java.getDeclaredField("mManagedCursors")
            managedCursorsField.isAccessible = true
            val managedCursors = managedCursorsField.get(this) as? MutableList<*>
            
            if (managedCursors != null && managedCursors.isNotEmpty()) {
                android.util.Log.d("MainActivity", "Clearing ${managedCursors.size} managed cursors")
                
                // Try to close each cursor individually before clearing the list
                managedCursors.forEach { managedCursor ->
                    try {
                        // Get the cursor from the ManagedCursor object
                        val cursorField = managedCursor?.javaClass?.getDeclaredField("mCursor")
                        cursorField?.isAccessible = true
                        val cursor = cursorField?.get(managedCursor) as? Cursor
                        
                        if (cursor != null && !cursor.isClosed) {
                            cursor.close()
                        }
                    } catch (_: Exception) {
                        // Ignore individual cursor cleanup errors
                    }
                }
                
                managedCursors.clear()
                android.util.Log.d("MainActivity", "Successfully cleared managed cursors")
            }
        } catch (e: Exception) {
            android.util.Log.w("MainActivity", "Could not clear managed cursors: ${e.message}")
        }
    }

    override fun onPause() {
        // Clean up cursors before going to background to prevent StaleDataException on resume
        try {
            clearManagedCursors()
            super.onPause()
        } catch (e: Exception) {
            android.util.Log.e("MainActivity", "Error during pause: ${e.message}")
        }
    }

    override fun onResume() {
        try {
            super.onResume()
        } catch (e: Exception) {
            android.util.Log.e("MainActivity", "Error during resume: ${e.message}")
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

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
                        playSystemSound(soundUri, volume ?: 0.8, loop ?: true, habitName)
                        result.success(null)
                    } catch (e: Exception) {
                        result.error("PLAY_ERROR", "Failed to play system sound: ${e.message}", null)
                    }
                }
                "stopSystemSound" -> {
                    try {
                        stopSystemSound()
                        result.success(null)
                    } catch (e: Exception) {
                        result.error("STOP_ERROR", "Failed to stop system sound: ${e.message}", null)
                    }
                }
                "getSystemRingtones" -> {
                    try {
                        result.success(getSystemRingtones())
                    } catch (e: Exception) {
                        result.error("RINGTONES_ERROR", "Failed to get system ringtones: ${e.message}", null)
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
            
            var cursor: Cursor? = null
            try {
                val manager = RingtoneManager(this)
                manager.setType(type)
                cursor = manager.cursor
                
                // Check if cursor is valid
                if (cursor == null || cursor.isClosed) {
                    return
                }
                
                while (cursor.moveToNext()) {
                    val title = cursor.getString(RingtoneManager.TITLE_COLUMN_INDEX) ?: label
                    val uri: Uri = manager.getRingtoneUri(cursor.position)
                    out.add(
                        mapOf(
                            "name" to title,
                            "uri" to uri.toString(),
                            "type" to "system"
                        )
                    )
                }
            } catch (e: Exception) {
                // Log error but don't crash the app
                android.util.Log.e("MainActivity", "Error querying ringtones: ${e.message}")
            } finally {
                // Safely close cursor
                try {
                    cursor?.close()
                } catch (e: Exception) {
                    android.util.Log.e("MainActivity", "Error closing cursor: ${e.message}")
                }
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
            previewRingtone = RingtoneManager.getRingtone(this, uri)
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
            
            // Set proper audio attributes for alarm sounds
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                alarmRingtone?.audioAttributes = AudioAttributes.Builder()
                    .setUsage(AudioAttributes.USAGE_ALARM)
                    .setContentType(AudioAttributes.CONTENT_TYPE_MUSIC)
                    .build()
                android.util.Log.i("MainActivity", "✅ Audio attributes set for API ${Build.VERSION.SDK_INT}")
            }
            
            android.util.Log.i("MainActivity", "Starting playback...")
            alarmRingtone?.play()
            
            // Verify it's actually playing
            val isPlaying = alarmRingtone?.isPlaying ?: false
            android.util.Log.i("MainActivity", "✅ Ringtone.isPlaying = $isPlaying")
            
            if (!isPlaying) {
                android.util.Log.e("MainActivity", "❌ WARNING: Ringtone is not playing after play() call")
            }
            
            android.util.Log.i("MainActivity", "🔊 System sound playback initiated for: ${habitName ?: "Unknown"}")

        } catch (e: Exception) {
            android.util.Log.e("MainActivity", "❌ CRITICAL ERROR playing system sound: ${e.message}", e)
            throw e
        }
    }

    private fun stopSystemSound() {
        try {
            alarmRingtone?.takeIf { it.isPlaying }?.stop()
            alarmRingtone = null
        } catch (e: Exception) {
            android.util.Log.e("MainActivity", "Error stopping system sound: ${e.message}")
            throw e
        }
    }

    private fun getSystemRingtones(): List<Map<String, String>> {
        val out = mutableListOf<Map<String, String>>()

        fun queryRingtones(type: Int, label: String) {
            if (isFinishing || isDestroyed) return
            
            var cursor: Cursor? = null
            try {
                val manager = RingtoneManager(this)
                manager.setType(type)
                cursor = manager.cursor
                
                if (cursor == null || cursor.isClosed) return
                
                while (cursor.moveToNext()) {
                    val title = cursor.getString(RingtoneManager.TITLE_COLUMN_INDEX) ?: "$label Sound"
                    val uri: Uri = manager.getRingtoneUri(cursor.position)
                    out.add(
                        mapOf(
                            "name" to title,
                            "uri" to uri.toString(),
                            "type" to label.lowercase()
                        )
                    )
                }
            } catch (e: Exception) {
                android.util.Log.e("MainActivity", "Error querying $label ringtones: ${e.message}")
            } finally {
                try {
                    cursor?.close()
                } catch (e: Exception) {
                    android.util.Log.e("MainActivity", "Error closing cursor: ${e.message}")
                }
            }
        }

        // Query all alarm, ringtone, and notification sounds
        queryRingtones(RingtoneManager.TYPE_ALARM, "Alarm")
        queryRingtones(RingtoneManager.TYPE_RINGTONE, "Ringtone")
        queryRingtones(RingtoneManager.TYPE_NOTIFICATION, "Notification")

        return out
    }

    // Handle the result from the ringtone picker
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == RINGTONE_PICKER_REQUEST_CODE && resultCode == Activity.RESULT_OK) {
            val uri: Uri? = data?.getParcelableExtra(RingtoneManager.EXTRA_RINGTONE_PICKED_URI)
            if (uri != null) {
                val ringtone = RingtoneManager.getRingtone(this, uri)
                val name = ringtone.getTitle(this)
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
}