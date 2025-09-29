package com.habittracker.habitv8

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log

/**
 * Broadcast receiver that triggers widget updates in response to system events
 * like time changes, date changes, and other relevant system broadcasts.
 */
class WidgetUpdateReceiver : BroadcastReceiver() {

    companion object {
        private const val TAG = "WidgetUpdateReceiver"
    }

    override fun onReceive(context: Context, intent: Intent) {
        try {
            Log.d(TAG, "Received broadcast: ${intent.action}")
            
            when (intent.action) {
                Intent.ACTION_TIME_CHANGED,
                Intent.ACTION_DATE_CHANGED,
                Intent.ACTION_TIMEZONE_CHANGED,
                "android.intent.action.TIME_SET" -> {
                    Log.i(TAG, "Time/date changed, triggering widget update")
                    WidgetUpdateWorker.triggerImmediateUpdate(context)
                }
                Intent.ACTION_SCREEN_ON -> {
                    Log.d(TAG, "Screen turned on, scheduling widget update")
                    // Trigger immediate update and reschedule periodic updates
                    WidgetUpdateWorker.triggerImmediateUpdate(context)
                    // Also reschedule periodic updates in case they were killed
                    WidgetUpdateWorker.schedulePeriodicUpdates(context)
                }
                Intent.ACTION_USER_PRESENT -> {
                    Log.d(TAG, "User unlocked device, triggering widget update")
                    // Trigger immediate update and reschedule periodic updates
                    WidgetUpdateWorker.triggerImmediateUpdate(context)
                    // Also reschedule periodic updates in case they were killed
                    WidgetUpdateWorker.schedulePeriodicUpdates(context)
                }
                Intent.ACTION_DREAMING_STOPPED -> {
                    Log.d(TAG, "Device stopped dreaming (screensaver), triggering widget update")
                    WidgetUpdateWorker.triggerImmediateUpdate(context)
                    WidgetUpdateWorker.schedulePeriodicUpdates(context)
                }
                Intent.ACTION_POWER_CONNECTED,
                Intent.ACTION_POWER_DISCONNECTED -> {
                    Log.d(TAG, "Power state changed, triggering widget update")
                    WidgetUpdateWorker.triggerImmediateUpdate(context)
                }
                "com.habittracker.habitv8.UPDATE_WIDGETS" -> {
                    Log.i(TAG, "Custom widget update broadcast received")
                    WidgetUpdateWorker.triggerImmediateUpdate(context)
                }
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error handling broadcast", e)
        }
    }
}