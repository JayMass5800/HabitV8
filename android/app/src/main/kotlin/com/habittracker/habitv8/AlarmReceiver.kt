package com.habittracker.habitv8

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import android.util.Log
import java.io.File

/**
 * Proper Android BroadcastReceiver for handling alarms
 * This receives broadcasts from AlarmManager and starts the foreground AlarmService
 */
class AlarmReceiver : BroadcastReceiver() {
    companion object {
        private const val TAG = "AlarmReceiver"
        const val EXTRA_SOUND_URI = "sound_uri"
        const val EXTRA_HABIT_NAME = "habit_name"
        const val EXTRA_ALARM_ID = "alarm_id"
    }

    override fun onReceive(context: Context, intent: Intent) {
        try {
            Log.i(TAG, "Alarm received: ${intent.action}")
            
            // Get alarm data from intent extras
            val soundUri = intent.getStringExtra(EXTRA_SOUND_URI)
            val habitName = intent.getStringExtra(EXTRA_HABIT_NAME) ?: "Habit Reminder"
            val alarmId = intent.getIntExtra(EXTRA_ALARM_ID, 0)
            
            Log.i(TAG, "Processing alarm for: $habitName (ID: $alarmId)")
            
            // If no sound URI in intent, try to read from stored alarm data
            val finalSoundUri = soundUri ?: readStoredAlarmData(context, alarmId)
            
            // Start the AlarmService directly from the broadcast receiver
            val serviceIntent = Intent(context, AlarmService::class.java).apply {
                putExtra("soundUri", finalSoundUri)
                putExtra("habitName", habitName)
                putExtra("alarmId", alarmId)
            }
            
            // Start foreground service
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                context.startForegroundService(serviceIntent)
            } else {
                context.startService(serviceIntent)
            }
            
            Log.i(TAG, "✅ AlarmService started for: $habitName")
            
        } catch (e: Exception) {
            Log.e(TAG, "❌ Error in AlarmReceiver", e)
        }
    }
    
    /**
     * Try to read stored alarm data if not provided in intent
     */
    private fun readStoredAlarmData(context: Context, alarmId: Int): String? {
        return try {
            val filesDir = context.filesDir
            val documentsDir = File(filesDir.parent, "app_flutter")
            val alarmFile = File(documentsDir, "alarm_data_$alarmId.json")
            
            if (alarmFile.exists()) {
                val content = alarmFile.readText()
                extractJsonValue(content, "alarmSoundUri") 
                    ?: extractJsonValue(content, "alarmSoundName")
                    ?: "content://settings/system/alarm_alert"
            } else {
                Log.w(TAG, "No stored alarm data found for ID: $alarmId")
                "content://settings/system/alarm_alert" // Default alarm sound
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error reading stored alarm data", e)
            "content://settings/system/alarm_alert" // Default alarm sound
        }
    }
    
    /**
     * Simple JSON value extraction (for the specific alarm data format)
     */
    private fun extractJsonValue(json: String, key: String): String? {
        return try {
            val pattern = "\"$key\"\\s*:\\s*\"([^\"]*)\""
            val regex = Regex(pattern)
            val matchResult = regex.find(json)
            val value = matchResult?.groupValues?.get(1)
            if (value.isNullOrEmpty() || value == "default") null else value
        } catch (e: Exception) {
            Log.e(TAG, "Error extracting JSON value for key: $key", e)
            null
        }
    }
}
