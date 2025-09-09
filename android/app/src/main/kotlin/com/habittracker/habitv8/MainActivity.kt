package com.habittracker.habitv8

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

    private var previewRingtone: Ringtone? = null

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

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Ringtone listing/preview channel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, RINGTONE_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "list" -> {
                    result.success(listRingtones())
                }
                "preview" -> {
                    val uriStr = call.argument<String>("uri")
                    if (uriStr == null) {
                        result.error("ARG", "uri is required", null)
                    } else {
                        previewRingtone(uriStr)
                        result.success(true)
                    }
                }
                "stop" -> {
                    stopPreview()
                    result.success(true)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun listRingtones(): List<Map<String, String>> {
        val out = mutableListOf<Map<String, String>>()

        fun query(type: Int, label: String) {
            val manager = RingtoneManager(this)
            manager.setType(type)
            val cursor: Cursor = manager.cursor
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
            cursor.close()
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
}