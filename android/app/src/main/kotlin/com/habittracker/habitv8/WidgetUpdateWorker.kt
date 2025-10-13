package com.habittracker.habitv8

import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Context
import android.content.SharedPreferences
import android.util.Log
import androidx.work.*
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import java.text.SimpleDateFormat
import java.util.*
import java.util.concurrent.TimeUnit

/**
 * WorkManager worker that updates widgets independently from the main app.
 * This ensures widgets stay up-to-date even when the app is not running.
 */
class WidgetUpdateWorker(
    context: Context,
    workerParams: WorkerParameters
) : Worker(context, workerParams) {

    companion object {
        private const val TAG = "WidgetUpdateWorker"
        private const val WORK_NAME = "widget_update_work"
        
        /**
         * Schedule periodic widget updates using WorkManager
         * 
         * HYBRID APPROACH: Combines event-driven updates with periodic safety net
         * Widget updates are handled by:
         * 1. Isar database listeners (event-driven, instant updates) - PRIMARY
         * 2. Periodic WorkManager (every 30 minutes) - SAFETY NET for race conditions
         * 3. Midnight reset service (daily habit resets)
         * 4. Critical system broadcasts (DATE_CHANGED, TIMEZONE_CHANGED)
         * 
         * The 30-minute periodic update catches any missed updates from race conditions
         * while still being battery-friendly (only 48 wake-ups per day vs 96+).
         */
        fun schedulePeriodicUpdates(context: Context) {
            try {
                // Cancel any existing periodic work first
                WorkManager.getInstance(context).cancelUniqueWork(WORK_NAME)
                WorkManager.getInstance(context).cancelUniqueWork("widget_fallback_work")
                
                // Schedule periodic updates every 30 minutes as a safety net
                val constraints = Constraints.Builder()
                    .setRequiresBatteryNotLow(false) // Run even on low battery
                    .build()
                
                val periodicWorkRequest = PeriodicWorkRequestBuilder<WidgetUpdateWorker>(
                    30, TimeUnit.MINUTES, // Run every 30 minutes
                    5, TimeUnit.MINUTES   // Flex interval (can run 5 minutes early/late)
                )
                    .setConstraints(constraints)
                    .addTag("widget_periodic_update")
                    .build()
                
                WorkManager.getInstance(context).enqueueUniquePeriodicWork(
                    WORK_NAME,
                    ExistingPeriodicWorkPolicy.KEEP, // Keep existing if already scheduled
                    periodicWorkRequest
                )
                
                Log.i(TAG, "✅ Periodic widget updates scheduled (every 30 minutes as safety net)")
                Log.i(TAG, "   Primary updates via Isar listeners (event-driven)")
            } catch (e: Exception) {
                Log.e(TAG, "❌ Error scheduling periodic widget updates", e)
            }
        }
        
        /**
         * Trigger an immediate widget update
         */
        fun triggerImmediateUpdate(context: Context) {
            try {
                val immediateWorkRequest = OneTimeWorkRequestBuilder<WidgetUpdateWorker>()
                    .addTag("immediate_widget_update")
                    .build()

                WorkManager.getInstance(context)
                    .enqueueUniqueWork(
                        "immediate_widget_update",
                        ExistingWorkPolicy.REPLACE,
                        immediateWorkRequest
                    )

                Log.i(TAG, "✅ Immediate widget update triggered")
            } catch (e: Exception) {
                Log.e(TAG, "❌ Error triggering immediate widget update", e)
            }
        }
    }

    override fun doWork(): Result {
        return try {
            Log.i(TAG, "Starting widget update work")
            
            // Update widget data from current habit state
            updateWidgetData()
            
            // Trigger widget UI updates
            updateAllWidgets()
            
            Log.i(TAG, "✅ Widget update work completed successfully")
            Result.success()
        } catch (e: Exception) {
            Log.e(TAG, "❌ Error in widget update work", e)
            Result.retry()
        }
    }
    
    private fun updateWidgetData() {
        try {
            // Read from HomeWidget preferences first (where Flutter saves data via home_widget plugin)
            val widgetPrefs = applicationContext.getSharedPreferences(
                "HomeWidgetPreferences", 
                Context.MODE_PRIVATE
            )
            
            val flutterPrefs = applicationContext.getSharedPreferences(
                "FlutterSharedPreferences", 
                Context.MODE_PRIVATE
            )
            
            // Try to get habits data from HomeWidgetPreferences ONLY
            // CRITICAL: Do NOT fall back to FlutterSharedPreferences as it may contain unfiltered/stale data
            // Flutter's home_widget plugin saves filtered today's habits to HomeWidgetPreferences
            var habitsJson = widgetPrefs.getString("habits", null)
                ?: widgetPrefs.getString("today_habits", null)
                ?: widgetPrefs.getString("habits_data", null)
                ?: "[]"
            
            Log.d(TAG, "Widget data loaded from HomeWidgetPreferences: ${habitsJson.length} characters")
            
            // Process and update widget-specific data
            processHabitDataForWidgets(habitsJson, flutterPrefs)
            
            Log.d(TAG, "Widget data updated from Flutter preferences")
        } catch (e: Exception) {
            Log.e(TAG, "Error updating widget data", e)
        }
    }
    
    private fun processHabitDataForWidgets(habitsJson: String, flutterPrefs: SharedPreferences) {
        try {
            val widgetPrefs = applicationContext.getSharedPreferences(
                "HomeWidgetPreferences", 
                Context.MODE_PRIVATE
            )
            
            val editor = widgetPrefs.edit()
            
            // IMPORTANT: habitsJson already contains ONLY today's habits (filtered by Flutter)
            // We just need to save it to the appropriate keys for widgets to read
            if (habitsJson.isNotEmpty() && habitsJson != "[]") {
                val gson = Gson()
                val type = object : TypeToken<List<Map<String, Any>>>() {}.type
                val habitsList: List<Map<String, Any>> = gson.fromJson(habitsJson, type) ?: emptyList()
                
                // Save today's habits to all relevant keys (no filtering needed - already filtered by Flutter)
                editor.putString("habits", habitsJson)
                editor.putString("habits_data", habitsJson)
                editor.putString("today_habits", habitsJson)
                editor.putInt("habit_count", habitsList.size)
                editor.putInt("today_habit_count", habitsList.size)
                
                Log.d(TAG, "✅ Updated widget data with ${habitsList.size} today's habits (pre-filtered by Flutter)")
            } else {
                // Don't overwrite with empty data - keep existing data
                Log.d(TAG, "⏭️ Skipping widget update - no habit data to write (empty array)")
            }
            
            // Copy theme settings from Flutter preferences
            copyThemeSettings(flutterPrefs, editor)
            
            // Update timestamp
            editor.putLong("last_update", System.currentTimeMillis())
            
            editor.apply()
            
        } catch (e: Exception) {
            Log.e(TAG, "Error processing habit data for widgets", e)
        }
    }
    
    // NOTE: Filtering logic removed - Flutter now handles all habit filtering
    // The worker receives pre-filtered today's habits from Flutter via HomeWidgetPreferences
    
    private fun copyThemeSettings(flutterPrefs: SharedPreferences, widgetEditor: SharedPreferences.Editor) {
        try {
            // Copy theme mode
            val themeMode = flutterPrefs.getString("flutter.theme_mode", null)
                ?: flutterPrefs.getString("flutter.themeMode", null)
            if (themeMode != null) {
                widgetEditor.putString("themeMode", themeMode)
            }
            
            // Copy primary color (Flutter stores integers as Long on Android)
            val primaryColor = try {
                flutterPrefs.getLong("flutter.primary_color", -1L).toInt()
            } catch (e: Exception) {
                try {
                    flutterPrefs.getInt("flutter.primary_color", -1)
                } catch (e2: Exception) {
                    -1
                }
            }
            if (primaryColor != -1) {
                widgetEditor.putInt("primaryColor", primaryColor)
            }
            
            Log.d(TAG, "Theme settings copied: mode=$themeMode, color=${Integer.toHexString(primaryColor)}")
        } catch (e: Exception) {
            Log.e(TAG, "Error copying theme settings", e)
        }
    }
    
    private fun updateAllWidgets() {
        try {
            val appWidgetManager = AppWidgetManager.getInstance(applicationContext)
            
            // Update Timeline Widgets
            val timelineComponent = ComponentName(applicationContext, HabitTimelineWidgetProvider::class.java)
            val timelineWidgetIds = appWidgetManager.getAppWidgetIds(timelineComponent)
            if (timelineWidgetIds.isNotEmpty()) {
                appWidgetManager.notifyAppWidgetViewDataChanged(timelineWidgetIds, R.id.habits_list)
                Log.d(TAG, "Updated ${timelineWidgetIds.size} timeline widgets")
            }
            
            // Update Compact Widgets
            val compactComponent = ComponentName(applicationContext, HabitCompactWidgetProvider::class.java)
            val compactWidgetIds = appWidgetManager.getAppWidgetIds(compactComponent)
            if (compactWidgetIds.isNotEmpty()) {
                appWidgetManager.notifyAppWidgetViewDataChanged(compactWidgetIds, R.id.compact_habits_list)
                Log.d(TAG, "Updated ${compactWidgetIds.size} compact widgets")
            }
            
            // Force full widget updates
            if (timelineWidgetIds.isNotEmpty()) {
                val timelineProvider = HabitTimelineWidgetProvider()
                timelineProvider.onUpdate(
                    applicationContext,
                    appWidgetManager,
                    timelineWidgetIds,
                    applicationContext.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)
                )
            }
            
            if (compactWidgetIds.isNotEmpty()) {
                val compactProvider = HabitCompactWidgetProvider()
                compactProvider.onUpdate(
                    applicationContext,
                    appWidgetManager,
                    compactWidgetIds,
                    applicationContext.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)
                )
            }
            
        } catch (e: Exception) {
            Log.e(TAG, "Error updating widgets", e)
        }
    }
}