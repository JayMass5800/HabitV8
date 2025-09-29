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
         */
        fun schedulePeriodicUpdates(context: Context) {
            try {
                // More lenient constraints to survive battery optimization
                val constraints = Constraints.Builder()
                    .setRequiredNetworkType(NetworkType.NOT_REQUIRED)
                    .setRequiresBatteryNotLow(false)
                    .setRequiresCharging(false)
                    .setRequiresDeviceIdle(false)
                    .setRequiresStorageNotLow(false)
                    .build()

                val periodicWorkRequest = PeriodicWorkRequestBuilder<WidgetUpdateWorker>(
                    15, TimeUnit.MINUTES // Update every 15 minutes
                )
                    .setConstraints(constraints)
                    .addTag("widget_updates")
                    .setBackoffCriteria(
                        BackoffPolicy.EXPONENTIAL,
                        30000L, // 30 seconds minimum backoff
                        TimeUnit.MILLISECONDS
                    )
                    .setInitialDelay(1, TimeUnit.MINUTES) // Start after 1 minute
                    .build()

                WorkManager.getInstance(context)
                    .enqueueUniquePeriodicWork(
                        WORK_NAME,
                        ExistingPeriodicWorkPolicy.UPDATE, // Use UPDATE instead of KEEP
                        periodicWorkRequest
                    )

                Log.i(TAG, "✅ Periodic widget updates scheduled (every 15 minutes)")
                
                // Also schedule a more frequent fallback update
                scheduleFallbackUpdates(context)
                
            } catch (e: Exception) {
                Log.e(TAG, "❌ Error scheduling periodic widget updates", e)
            }
        }
        
        /**
         * Schedule more frequent fallback updates to handle battery optimization
         */
        private fun scheduleFallbackUpdates(context: Context) {
            try {
                // Very lenient constraints for fallback updates
                val fallbackConstraints = Constraints.Builder()
                    .setRequiredNetworkType(NetworkType.NOT_REQUIRED)
                    .build()

                val fallbackWorkRequest = PeriodicWorkRequestBuilder<WidgetUpdateWorker>(
                    1, TimeUnit.HOURS // Fallback every hour
                )
                    .setConstraints(fallbackConstraints)
                    .addTag("widget_fallback_updates")
                    .setBackoffCriteria(
                        BackoffPolicy.EXPONENTIAL,
                        60000L, // 1 minute minimum backoff
                        TimeUnit.MILLISECONDS
                    )
                    .build()

                WorkManager.getInstance(context)
                    .enqueueUniquePeriodicWork(
                        "widget_fallback_work",
                        ExistingPeriodicWorkPolicy.UPDATE,
                        fallbackWorkRequest
                    )

                Log.i(TAG, "✅ Fallback widget updates scheduled (every hour)")
            } catch (e: Exception) {
                Log.e(TAG, "❌ Error scheduling fallback widget updates", e)
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
            
            // Try to get habits data from HomeWidgetPreferences first (Flutter's home_widget plugin saves here)
            var habitsJson = widgetPrefs.getString("habits", null)
                ?: widgetPrefs.getString("today_habits", null)
                ?: widgetPrefs.getString("habits_data", null)
            
            // If not found in HomeWidget prefs, try FlutterSharedPreferences as fallback
            if (habitsJson.isNullOrBlank() || habitsJson == "[]") {
                habitsJson = flutterPrefs.getString("flutter.habits_data", null)
                    ?: flutterPrefs.getString("flutter.habits", null)
                    ?: "[]"
            }
            
            Log.d(TAG, "Widget data loaded: ${habitsJson.length} characters")
            
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
            
            // Only update habits data if we have actual data (don't overwrite with empty data)
            if (habitsJson.isNotEmpty() && habitsJson != "[]") {
                editor.putString("habits", habitsJson)
                editor.putString("habits_data", habitsJson)
                Log.d(TAG, "Updating habits data: ${habitsJson.length} characters")
            } else {
                // Don't overwrite - keep existing data
                Log.d(TAG, "Skipping habits update - no new data to write (would be empty array)")
            }
            
            // Process habits for today's display
            if (habitsJson.isNotEmpty() && habitsJson != "[]") {
                val gson = Gson()
                val type = object : TypeToken<List<Map<String, Any>>>() {}.type
                val habitsList: List<Map<String, Any>> = gson.fromJson(habitsJson, type) ?: emptyList()
                
                // Filter and process habits for today
                val todayHabits = filterHabitsForToday(habitsList)
                val processedHabitsJson = gson.toJson(todayHabits)
                
                editor.putString("today_habits", processedHabitsJson)
                editor.putInt("habit_count", habitsList.size)
                editor.putInt("today_habit_count", todayHabits.size)
                
                Log.d(TAG, "Processed ${habitsList.size} total habits, ${todayHabits.size} for today")
            } else {
                editor.putString("today_habits", "[]")
                editor.putInt("habit_count", 0)
                editor.putInt("today_habit_count", 0)
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
    
    private fun filterHabitsForToday(habitsList: List<Map<String, Any>>): List<Map<String, Any>> {
        val today = Calendar.getInstance()
        val todayDateString = SimpleDateFormat("yyyy-MM-dd", Locale.getDefault()).format(today.time)
        
        return habitsList.filter { habit ->
            shouldShowHabitToday(habit, today, todayDateString)
        }
    }
    
    private fun shouldShowHabitToday(habit: Map<String, Any>, today: Calendar, todayDateString: String): Boolean {
        try {
            // Check if habit is active and should be shown today
            val isActive = habit["isActive"] as? Boolean ?: true
            if (!isActive) return false
            
            // Check frequency and scheduling
            val frequency = habit["frequency"] as? String ?: "daily"
            
            return when (frequency.lowercase()) {
                "daily" -> true
                "weekly" -> {
                    // Check if today matches the weekly schedule
                    val selectedWeekdays = habit["selectedWeekdays"] as? List<*>
                    val todayOfWeek = today.get(Calendar.DAY_OF_WEEK) - 1 // 0 = Sunday
                    selectedWeekdays?.contains(todayOfWeek) ?: true
                }
                "monthly" -> {
                    // Check if today matches the monthly schedule
                    val selectedMonthDays = habit["selectedMonthDays"] as? List<*>
                    val todayOfMonth = today.get(Calendar.DAY_OF_MONTH)
                    selectedMonthDays?.contains(todayOfMonth) ?: true
                }
                "yearly" -> {
                    // Check if today matches the yearly schedule
                    val selectedYearlyDates = habit["selectedYearlyDates"] as? List<*>
                    if (selectedYearlyDates.isNullOrEmpty()) {
                        // If no specific dates selected, show by default
                        true
                    } else {
                        // Check if today's date (MM-dd format) matches any selected yearly dates
                        selectedYearlyDates.any { dateStr ->
                            try {
                                val yearlyDate = dateStr.toString()
                                // Extract MM-dd from yyyy-MM-dd format
                                if (yearlyDate.length >= 10) {
                                    val monthDay = yearlyDate.substring(5) // Get MM-dd part
                                    val todayMonthDay = String.format("%02d-%02d", 
                                        today.get(Calendar.MONTH) + 1, 
                                        today.get(Calendar.DAY_OF_MONTH))
                                    monthDay == todayMonthDay
                                } else {
                                    false
                                }
                            } catch (e: Exception) {
                                Log.w(TAG, "Error parsing yearly date: $dateStr", e)
                                false
                            }
                        }
                    }
                }
                "hourly" -> {
                    // Hourly habits should show if they have times scheduled for today
                    val hourlyTimes = habit["hourlyTimes"] as? List<*>
                    hourlyTimes?.isNotEmpty() == true
                }
                "single" -> {
                    // Single habits should show if their scheduled date is today
                    val singleDateTime = habit["singleDateTime"] as? String
                    if (singleDateTime != null) {
                        try {
                            val singleDate = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss", Locale.getDefault()).parse(singleDateTime)
                            if (singleDate != null) {
                                val singleDateString = SimpleDateFormat("yyyy-MM-dd", Locale.getDefault()).format(singleDate)
                                singleDateString == todayDateString
                            } else {
                                false
                            }
                        } catch (e: Exception) {
                            Log.w(TAG, "Error parsing single date: $singleDateTime", e)
                            false
                        }
                    } else {
                        false
                    }
                }
                else -> true // Show other frequencies by default
            }
        } catch (e: Exception) {
            Log.w(TAG, "Error filtering habit for today: ${habit["name"]}", e)
            return true // Show by default if there's an error
        }
    }
    
    private fun copyThemeSettings(flutterPrefs: SharedPreferences, widgetEditor: SharedPreferences.Editor) {
        try {
            // Copy theme mode
            val themeMode = flutterPrefs.getString("flutter.theme_mode", null)
                ?: flutterPrefs.getString("flutter.themeMode", null)
            if (themeMode != null) {
                widgetEditor.putString("themeMode", themeMode)
            }
            
            // Copy primary color
            val primaryColor = flutterPrefs.getInt("flutter.primary_color", -1)
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