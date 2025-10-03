package com.habittracker.habitv8

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import android.util.Log
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodChannel

/**
 * BroadcastReceiver for handling alarm actions (Complete, Snooze)
 * This receiver handles actions from the alarm notification
 */
class AlarmActionReceiver : BroadcastReceiver() {
    companion object {
        private const val TAG = "AlarmActionReceiver"
        const val ACTION_COMPLETE = "com.habittracker.habitv8.ALARM_COMPLETE"
        const val ACTION_SNOOZE = "com.habittracker.habitv8.ALARM_SNOOZE"
        const val EXTRA_ALARM_ID = "alarm_id"
        const val EXTRA_HABIT_ID = "habit_id"
        const val EXTRA_HABIT_NAME = "habit_name"
        const val EXTRA_SOUND_URI = "sound_uri"
    }

    override fun onReceive(context: Context, intent: Intent) {
        try {
            Log.i(TAG, "Alarm action received: ${intent.action}")
            
            val alarmId = intent.getIntExtra(EXTRA_ALARM_ID, 0)
            val habitId = intent.getStringExtra(EXTRA_HABIT_ID) ?: ""
            val habitName = intent.getStringExtra(EXTRA_HABIT_NAME) ?: "Habit"
            val soundUri = intent.getStringExtra(EXTRA_SOUND_URI)
            
            when (intent.action) {
                ACTION_COMPLETE -> {
                    Log.i(TAG, "Complete action for: $habitName")
                    // Stop the alarm service
                    stopAlarmService(context, alarmId)
                    
                    // Store completion data for Flutter to pick up
                    val prefs = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
                    prefs.edit().apply {
                        putString("flutter.complete_alarm_pending_$habitId", habitId)
                        putString("flutter.complete_alarm_name_$habitId", habitName)
                        putLong("flutter.complete_alarm_time_$habitId", System.currentTimeMillis())
                        apply()
                    }
                    
                    // Try to notify Flutter via method channel if app is running
                    try {
                        notifyFlutterComplete(context, habitId, habitName)
                    } catch (e: Exception) {
                        Log.w(TAG, "Could not notify Flutter immediately, will be picked up on next launch", e)
                    }
                }
                
                ACTION_SNOOZE -> {
                    Log.i(TAG, "Snooze action for: $habitName")
                    // Stop the current alarm
                    stopAlarmService(context, alarmId)
                    
                    // Store snooze data for Flutter to pick up
                    val prefs = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
                    prefs.edit().apply {
                        putString("flutter.snooze_alarm_pending_$habitId", habitId)
                        putString("flutter.snooze_alarm_name_$habitId", habitName)
                        putString("flutter.snooze_alarm_sound_$habitId", soundUri ?: "")
                        putLong("flutter.snooze_alarm_time_$habitId", System.currentTimeMillis())
                        apply()
                    }
                    
                    // Try to notify Flutter via method channel if app is running
                    try {
                        notifyFlutterSnooze(context, habitId, habitName, soundUri)
                    } catch (e: Exception) {
                        Log.w(TAG, "Could not notify Flutter immediately, will be picked up on next launch", e)
                    }
                }
            }
            
        } catch (e: Exception) {
            Log.e(TAG, "Error handling alarm action", e)
        }
    }
    
    private fun stopAlarmService(context: Context, alarmId: Int) {
        // Stop the AlarmService
        val stopIntent = Intent(context, AlarmService::class.java).apply {
            action = "STOP_ALARM"
        }
        context.stopService(stopIntent)
        
        // Also cancel the alarm notification
        val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as android.app.NotificationManager
        notificationManager.cancel(alarmId + 2000)
        
        Log.i(TAG, "Alarm service stopped")
    }
    
    private fun notifyFlutterComplete(context: Context, habitId: String, habitName: String) {
        // This will be called via MainActivity's method channel when the app is running
        val intent = Intent(context, MainActivity::class.java).apply {
            action = "COMPLETE_ALARM"
            putExtra("habitId", habitId)
            putExtra("habitName", habitName)
            flags = Intent.FLAG_ACTIVITY_NEW_TASK
        }
        context.startActivity(intent)
    }
    
    private fun notifyFlutterSnooze(context: Context, habitId: String, habitName: String, soundUri: String?) {
        // This will be called via MainActivity's method channel when the app is running
        val intent = Intent(context, MainActivity::class.java).apply {
            action = "SNOOZE_ALARM"
            putExtra("habitId", habitId)
            putExtra("habitName", habitName)
            putExtra("soundUri", soundUri)
            flags = Intent.FLAG_ACTIVITY_NEW_TASK
        }
        context.startActivity(intent)
    }
}
