package com.habittracker.habitv8

import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.util.Log

/**
 * Helper class for triggering widget updates from any context
 * (Activity, BroadcastReceiver, Service, etc.)
 * 
 * This is the RELIABLE way to update widgets when the app is closed,
 * because it uses native Android broadcasts instead of Flutter platform channels.
 */
object WidgetUpdateHelper {
    private const val TAG = "WidgetUpdateHelper"
    
    /**
     * Force all widgets to refresh their data and UI
     * This works even when the Flutter engine is not running
     * 
     * @param context Any Android context (Activity, Service, BroadcastReceiver, etc.)
     */
    fun forceWidgetRefresh(context: Context) {
        try {
            Log.i(TAG, "🔄 Force widget refresh requested from ${context.javaClass.simpleName}")
            
            // Get AppWidgetManager
            val appWidgetManager = AppWidgetManager.getInstance(context)
            
            // Get all widget IDs for timeline widgets
            val timelineWidgetIds = appWidgetManager.getAppWidgetIds(
                ComponentName(context, HabitTimelineWidgetProvider::class.java)
            )
            
            // Get all widget IDs for compact widgets
            val compactWidgetIds = appWidgetManager.getAppWidgetIds(
                ComponentName(context, HabitCompactWidgetProvider::class.java)
            )
            
            Log.i(TAG, "Found ${timelineWidgetIds.size} timeline widgets, ${compactWidgetIds.size} compact widgets")
            
            // CRITICAL: Directly notify ListView to reload data (this calls onDataSetChanged)
            timelineWidgetIds.forEach { widgetId ->
                appWidgetManager.notifyAppWidgetViewDataChanged(widgetId, R.id.habits_list)
                Log.i(TAG, "✅ Notified timeline widget $widgetId to reload data")
            }
            
            compactWidgetIds.forEach { widgetId ->
                appWidgetManager.notifyAppWidgetViewDataChanged(widgetId, R.id.compact_habits_list)
                Log.i(TAG, "✅ Notified compact widget $widgetId to reload data")
            }
            
            // Also send broadcast to trigger onUpdate() for header/footer updates
            val timelineIntent = Intent(context, HabitTimelineWidgetProvider::class.java)
            timelineIntent.action = AppWidgetManager.ACTION_APPWIDGET_UPDATE
            timelineIntent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, timelineWidgetIds)
            context.sendBroadcast(timelineIntent)
            
            val compactIntent = Intent(context, HabitCompactWidgetProvider::class.java)
            compactIntent.action = AppWidgetManager.ACTION_APPWIDGET_UPDATE
            compactIntent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, compactWidgetIds)
            context.sendBroadcast(compactIntent)
            
            Log.i(TAG, "✅ Widget force refresh completed successfully")
        } catch (e: Exception) {
            Log.e(TAG, "❌ Failed to force widget refresh: ${e.message}", e)
        }
    }
    
    /**
     * Send a broadcast to trigger habit completion widget update
     * This is called from Dart code after completing a habit
     * 
     * @param context Any Android context
     */
    fun sendHabitCompletionBroadcast(context: Context) {
        try {
            Log.i(TAG, "📢 Sending habit completion broadcast")
            
            val intent = Intent(context, HabitCompletionReceiver::class.java)
            intent.action = "com.habittracker.habitv8.HABIT_COMPLETED"
            context.sendBroadcast(intent)
            
            Log.i(TAG, "✅ Habit completion broadcast sent")
        } catch (e: Exception) {
            Log.e(TAG, "❌ Failed to send habit completion broadcast: ${e.message}", e)
        }
    }
}