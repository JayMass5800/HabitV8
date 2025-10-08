package com.habittracker.habitv8

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log

/**
 * Broadcast receiver that triggers widget updates when habits are completed.
 * 
 * This receiver is triggered by the Flutter notification background handler
 * to ensure widgets update even when the app is completely closed.
 */
class HabitCompletionReceiver : BroadcastReceiver() {

    companion object {
        private const val TAG = "HabitCompletionReceiver"
        const val ACTION_HABIT_COMPLETED = "com.habittracker.habitv8.HABIT_COMPLETED"
        const val EXTRA_HABIT_ID = "habit_id"
    }

    override fun onReceive(context: Context, intent: Intent) {
        try {
            Log.d(TAG, "Received broadcast: ${intent.action}")
            
            when (intent.action) {
                ACTION_HABIT_COMPLETED -> {
                    val habitId = intent.getStringExtra(EXTRA_HABIT_ID)
                    Log.i(TAG, "📢 Habit completed: $habitId, triggering widget update")
                    
                    // IMMEDIATE widget refresh using native Android APIs
                    // This bypasses Flutter platform channels entirely and works
                    // even when the app is completely closed
                    WidgetUpdateHelper.forceWidgetRefresh(context)
                    
                    // Also trigger WorkManager update as a backup
                    // (in case the immediate update fails or for periodic updates)
                    WidgetUpdateWorker.triggerImmediateUpdate(context)
                    
                    Log.i(TAG, "✅ Widget update triggered successfully")
                }
                else -> {
                    Log.d(TAG, "Ignoring unknown broadcast: ${intent.action}")
                }
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error handling broadcast", e)
        }
    }
}