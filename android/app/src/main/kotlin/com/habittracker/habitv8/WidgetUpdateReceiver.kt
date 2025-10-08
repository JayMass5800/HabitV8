package com.habittracker.habitv8

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log

/**
 * Broadcast receiver that triggers widget updates in response to CRITICAL system events.
 * 
 * BATTERY OPTIMIZATION: Only responds to essential events:
 * - Date/time/timezone changes (affects habit scheduling)
 * - Custom update broadcasts (manual triggers)
 * 
 * Removed battery-draining broadcasts:
 * - SCREEN_ON (fires dozens of times per day)
 * - USER_PRESENT (fires every unlock)
 * - DREAMING_STOPPED (not critical for habit tracking)
 * - POWER_CONNECTED/DISCONNECTED (not relevant for habits)
 * 
 * Widget updates are primarily handled by Isar database listeners (event-driven).
 */
class WidgetUpdateReceiver : BroadcastReceiver() {

    companion object {
        private const val TAG = "WidgetUpdateReceiver"
    }

    override fun onReceive(context: Context, intent: Intent) {
        try {
            Log.d(TAG, "Received broadcast: ${intent.action}")
            
            when (intent.action) {
                Intent.ACTION_DATE_CHANGED -> {
                    Log.i(TAG, "Date changed, triggering widget update")
                    // Date change is critical - habits need to reset for new day
                    WidgetUpdateWorker.triggerImmediateUpdate(context)
                }
                Intent.ACTION_TIMEZONE_CHANGED -> {
                    Log.i(TAG, "Timezone changed, triggering widget update")
                    // Timezone change affects all time-based scheduling
                    WidgetUpdateWorker.triggerImmediateUpdate(context)
                }
                Intent.ACTION_TIME_CHANGED,
                "android.intent.action.TIME_SET" -> {
                    Log.i(TAG, "Time changed, triggering widget update")
                    // Time change might affect habit scheduling
                    WidgetUpdateWorker.triggerImmediateUpdate(context)
                }
                "com.habittracker.habitv8.UPDATE_WIDGETS" -> {
                    Log.i(TAG, "Custom widget update broadcast received")
                    WidgetUpdateWorker.triggerImmediateUpdate(context)
                }
                else -> {
                    Log.d(TAG, "Ignoring non-critical broadcast: ${intent.action}")
                }
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error handling broadcast", e)
        }
    }
}