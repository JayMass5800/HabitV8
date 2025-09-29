package com.habittracker.habitv8

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.net.Uri
import android.util.Log
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetBackgroundIntent
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider
import android.graphics.Color

open class HabitTimelineWidgetProvider : HomeWidgetProvider() {

    companion object {
        const val HABIT_ACTION_COMPLETE = "com.habittracker.habitv8.HABIT_COMPLETE"
        const val HABIT_ACTION_OPEN = "com.habittracker.habitv8.HABIT_OPEN"
        const val EXTRA_HABIT_ID = "habit_id"
    }

    // Safely read Int even if stored as Long/Float/String
    private fun getIntCompat(prefs: SharedPreferences, key: String, default: Int): Int {
        return try {
            when (val v = prefs.all[key]) {
                is Int -> v
                is Long -> v.toInt()
                is Float -> v.toInt()
                is Double -> v.toInt()
                is String -> v.toLongOrNull()?.toInt() ?: v.toIntOrNull() ?: default
                else -> default
            }
        } catch (e: Exception) {
            default
        }
    }

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        Log.d("HabitTimelineWidget", "onUpdate called with ${appWidgetIds.size} widget IDs")
        
        // Check if widget data is stale and try to refresh it
        val lastUpdate = widgetData.getLong("last_update", 0)
        val currentTime = System.currentTimeMillis()
        val dataAge = currentTime - lastUpdate
        val maxDataAge = 30 * 60 * 1000L // 30 minutes
        
        if (dataAge > maxDataAge) {
            Log.w("HabitTimelineWidget", "Widget data is stale (${dataAge / 1000}s old), attempting refresh")
            // Try to refresh data from Flutter preferences as fallback
            refreshWidgetDataFromFlutter(context, widgetData)
            // Also trigger WorkManager update
            WidgetUpdateWorker.triggerImmediateUpdate(context)
            // Force refresh all widgets after fallback data update
            appWidgetIds.forEach { appWidgetId ->
                appWidgetManager.notifyAppWidgetViewDataChanged(appWidgetId, R.id.habits_list)
            }
        }
        
        appWidgetIds.forEach { appWidgetId ->
            try {
                val views = RemoteViews(context.packageName, R.layout.widget_timeline)
                
                // Set up the ListView with RemoteViewsService
                setupListView(context, views, appWidgetId)
                
                // Apply theme colors
                applyThemeColors(context, views, widgetData)
                
                // Set up header click handlers
                setupHeaderClickHandlers(context, views, appWidgetId)
                
                // Check if we have habits to show (pass widgetData to check fallback data too)
                val hasHabits = checkForHabits(context, widgetData)
                if (hasHabits) {
                    views.setViewVisibility(R.id.habits_list, android.view.View.VISIBLE)
                    views.setViewVisibility(R.id.empty_state, android.view.View.GONE)
                } else {
                    views.setViewVisibility(R.id.habits_list, android.view.View.GONE)
                    views.setViewVisibility(R.id.empty_state, android.view.View.VISIBLE)
                    setupEmptyStateClickHandler(context, views, appWidgetId)
                }
                
                appWidgetManager.updateAppWidget(appWidgetId, views)
                
                // Notify the ListView that data might have changed
                appWidgetManager.notifyAppWidgetViewDataChanged(appWidgetId, R.id.habits_list)
                
                Log.d("HabitTimelineWidget", "Widget update completed for ID: $appWidgetId")
            } catch (e: Exception) {
                Log.e("HabitTimelineWidget", "Error updating widget $appWidgetId", e)
            }
        }
    }

    private fun setupListView(context: Context, views: RemoteViews, appWidgetId: Int) {
        // Resolve theme extras to pass into the service for reliability
        val widgetData = context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)
        val flutterPrefs = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        val themeModeExtra = widgetData.getString("themeMode", null)
            ?: flutterPrefs.getString("flutter.theme_mode", null)
            ?: flutterPrefs.getString("theme_mode", null)
        val defaultPrimary = 0xFF6200EE.toInt()
        val primaryColorExtra = when {
            widgetData.contains("primaryColor") -> getIntCompat(widgetData, "primaryColor", defaultPrimary)
            flutterPrefs.contains("flutter.primary_color") -> getIntCompat(flutterPrefs, "flutter.primary_color", defaultPrimary)
            flutterPrefs.contains("primary_color") -> getIntCompat(flutterPrefs, "primary_color", defaultPrimary)
            else -> defaultPrimary
        }

        // Create intent for the RemoteViewsService
        val serviceIntent = Intent(context, HabitTimelineWidgetService::class.java).apply {
            putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
            putExtra("themeMode", themeModeExtra)
            putExtra("primaryColor", primaryColorExtra)
            data = Uri.parse(toUri(Intent.URI_INTENT_SCHEME))
        }
        
        // Set the RemoteViewsService as the adapter for the ListView
        views.setRemoteAdapter(R.id.habits_list, serviceIntent)
        
        // Set empty view for the ListView
        views.setEmptyView(R.id.habits_list, R.id.empty_state)
        
        // Set up pending intent template for list items
        setupListItemClickTemplate(context, views, appWidgetId)
        
        Log.d("HabitTimelineWidget", "ListView setup completed for widget $appWidgetId with theme extras: mode=$themeModeExtra, primary=${Integer.toHexString(primaryColorExtra)}")
    }

    private fun setupListItemClickTemplate(context: Context, views: RemoteViews, appWidgetId: Int) {
        // Create pending intent template for habit completion
        val completePendingIntent = Intent(context, HabitTimelineWidgetProvider::class.java).apply {
            action = HABIT_ACTION_COMPLETE
            putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
            data = Uri.parse(toUri(Intent.URI_INTENT_SCHEME))
        }
        
        val completePendingIntentTemplate = PendingIntent.getBroadcast(
            context, 
            0, 
            completePendingIntent, 
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        
        views.setPendingIntentTemplate(R.id.habits_list, completePendingIntentTemplate)
    }

    private fun setupHeaderClickHandlers(context: Context, views: RemoteViews, appWidgetId: Int) {
        // Refresh button
        val refreshIntent = Intent(context, HabitTimelineWidgetProvider::class.java).apply {
            action = AppWidgetManager.ACTION_APPWIDGET_UPDATE
            putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, intArrayOf(appWidgetId))
        }
        val refreshPendingIntent = PendingIntent.getBroadcast(
            context, 
            appWidgetId, 
            refreshIntent, 
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        views.setOnClickPendingIntent(R.id.refresh_button, refreshPendingIntent)
        
        // Add Habit button - open app to create habit screen
        val addHabitIntent = Intent(context, MainActivity::class.java).apply {
            putExtra("screen", "create_habit")
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
        }
        val addHabitPendingIntent = PendingIntent.getActivity(
            context,
            appWidgetId + 1000, // Unique request code
            addHabitIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        views.setOnClickPendingIntent(R.id.add_habit_button, addHabitPendingIntent)
        
        // Title click to open app
        val openAppPendingIntent = HomeWidgetLaunchIntent.getActivity(context, MainActivity::class.java)
        views.setOnClickPendingIntent(R.id.header_title, openAppPendingIntent)
    }

    private fun setupEmptyStateClickHandler(context: Context, views: RemoteViews, appWidgetId: Int) {
        val openAppPendingIntent = HomeWidgetLaunchIntent.getActivity(context, MainActivity::class.java)
        views.setOnClickPendingIntent(R.id.add_habit_button, openAppPendingIntent)
    }

    private fun checkForHabits(context: Context, widgetData: SharedPreferences? = null): Boolean {
        return try {
            // First try to check from the provided widgetData (used after fallback refresh)
            if (widgetData != null) {
                val habitsJson = widgetData.getString("habits", null)
                    ?: widgetData.getString("habits_data", null)
                if (!habitsJson.isNullOrEmpty() && habitsJson != "[]") {
                    Log.d("HabitTimelineWidget", "Found habits in widgetData")
                    return true
                }
            }
            
            // Fallback to HomeWidgetPreferences
            val prefs = context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)
            val habitsJson = prefs.getString("habits", null)
                ?: prefs.getString("home_widget.string.habits", null)
                ?: prefs.getString("habits_data", null)
            val hasHabits = !habitsJson.isNullOrEmpty() && habitsJson != "[]"
            
            Log.d("HabitTimelineWidget", "checkForHabits result: $hasHabits (from ${if (widgetData != null) "widgetData + " else ""}HomeWidgetPreferences)")
            hasHabits
        } catch (e: Exception) {
            Log.e("HabitTimelineWidget", "Error checking for habits", e)
            false
        }
    }

    private fun applyThemeColors(context: Context, views: RemoteViews, widgetData: SharedPreferences) {
        try {
            // Read theme mode from widget data first, then from app prefs, else fall back to system
            var themeMode = widgetData.getString("themeMode", null)
                ?: widgetData.getString("home_widget.double.themeMode", null)
                ?: widgetData.getString("flutter.theme_mode", null) // from ThemeService via shared_preferences
                ?: widgetData.getString("flutter.themeMode", null) // legacy/camelCase fallback

            if (themeMode == null) {
                val systemNightMode = context.resources.configuration.uiMode and
                    android.content.res.Configuration.UI_MODE_NIGHT_MASK
                themeMode = when (systemNightMode) {
                    android.content.res.Configuration.UI_MODE_NIGHT_YES -> "dark"
                    android.content.res.Configuration.UI_MODE_NIGHT_NO -> "light"
                    else -> "light"
                }
                Log.d("HabitTimelineWidget", "No saved theme found, using system theme: $themeMode")
            }

            Log.d("HabitTimelineWidget", "Detected theme mode: '$themeMode'")

            // Read primary color from widget data first, then from app prefs; default to app's default blue
            val defaultPrimary = 0xFF2196F3.toInt()
            val primaryColor = when {
                widgetData.contains("primaryColor") -> getIntCompat(widgetData, "primaryColor", defaultPrimary)
                widgetData.contains("home_widget.double.primaryColor") -> {
                    try {
                        widgetData.getFloat("home_widget.double.primaryColor", defaultPrimary.toFloat()).toInt()
                    } catch (e: Exception) {
                        defaultPrimary
                    }
                }
                widgetData.contains("flutter.primary_color") -> getIntCompat(widgetData, "flutter.primary_color", defaultPrimary)
                widgetData.contains("flutter.primaryColor") -> getIntCompat(widgetData, "flutter.primaryColor", defaultPrimary)
                else -> defaultPrimary
            }

            Log.d("HabitTimelineWidget", "Using theme - mode: '$themeMode', primary: ${Integer.toHexString(primaryColor)}")

            val isDarkMode = themeMode.equals("dark", ignoreCase = true)

            // 50% opacity backgrounds (50% transparency)
            val backgroundColor = if (isDarkMode) 0x800F0F0F.toInt() else 0x80FAFAFA.toInt()

            // Apply colors with error handling
            try {
                views.setInt(R.id.widget_root, "setBackgroundColor", backgroundColor)
                views.setInt(R.id.header_layout, "setBackgroundColor", primaryColor) // Keep header fully opaque
                views.setTextColor(R.id.header_title, 0xFFFFFFFF.toInt())
                views.setInt(R.id.refresh_button, "setColorFilter", 0xFFFFFFFF.toInt())
            } catch (e: Exception) {
                Log.e("HabitTimelineWidget", "Error applying specific colors, using fallbacks", e)
                // Fallback to ensure widget has some background
                views.setInt(R.id.widget_root, "setBackgroundColor", 0x99FAFAFA.toInt())
            }

            Log.d("HabitTimelineWidget", "Semi-transparent theme applied - isDark: $isDarkMode, bg: ${Integer.toHexString(backgroundColor)}")
        } catch (e: Exception) {
            Log.e("HabitTimelineWidget", "Error applying theme colors, using fallback", e)
            // Emergency fallback with transparency
            try {
                views.setInt(R.id.widget_root, "setBackgroundColor", 0x80FAFAFA.toInt())
                views.setInt(R.id.header_layout, "setBackgroundColor", 0xFF2196F3.toInt())
            } catch (fallbackError: Exception) {
                Log.e("HabitTimelineWidget", "Even fallback failed", fallbackError)
            }
        }
    }

    override fun onEnabled(context: Context) {
        super.onEnabled(context)
        Log.d("HabitTimelineWidget", "Widget enabled - scheduling periodic updates")
        WidgetUpdateWorker.schedulePeriodicUpdates(context)
    }
    
    override fun onDisabled(context: Context) {
        super.onDisabled(context)
        Log.d("HabitTimelineWidget", "All widgets disabled")
        // Note: We don't cancel WorkManager here as compact widgets might still be active
    }

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)
        
        when (intent.action) {
            HABIT_ACTION_COMPLETE -> {
                handleHabitComplete(context, intent)
            }
            HABIT_ACTION_OPEN -> {
                handleHabitOpen(context, intent)
            }
        }
    }

    private fun handleHabitComplete(context: Context, intent: Intent) {
        val habitId = intent.getStringExtra(EXTRA_HABIT_ID)
        Log.d("HabitTimelineWidget", "Habit completion requested for ID: $habitId")
        
        // Send the completion action to Flutter via home_widget
        val backgroundPendingIntent = HomeWidgetBackgroundIntent.getBroadcast(
            context,
            Uri.parse("habitv8://habit/complete?id=$habitId")
        )
        try {
            backgroundPendingIntent.send()
        } catch (e: Exception) {
            Log.e("HabitTimelineWidget", "Error sending background intent", e)
        }
        
        // Refresh the widget after a short delay
        val appWidgetId = intent.getIntExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, -1)
        if (appWidgetId != -1) {
            val appWidgetManager = AppWidgetManager.getInstance(context)
            appWidgetManager.notifyAppWidgetViewDataChanged(appWidgetId, R.id.habits_list)
        }
    }

    private fun handleHabitOpen(context: Context, intent: Intent) {
        val habitId = intent.getStringExtra(EXTRA_HABIT_ID)
        Log.d("HabitTimelineWidget", "Opening habit details for ID: $habitId")
        
        // Open the app with the specific habit  
        val openAppPendingIntent = HomeWidgetLaunchIntent.getActivity(
            context, 
            MainActivity::class.java,
            Uri.parse("habitv8://habit/details?id=$habitId")
        )
        
        // Convert PendingIntent to Intent and start activity
        try {
            openAppPendingIntent.send()
        } catch (e: Exception) {
            Log.e("HabitTimelineWidget", "Error opening habit details", e)
            // Fallback to just opening the app
            val fallbackIntent = HomeWidgetLaunchIntent.getActivity(context, MainActivity::class.java)
            fallbackIntent.send()
        }
    }
    
    /**
     * Fallback method to refresh widget data directly from Flutter preferences
     * when WorkManager updates fail or are delayed
     */
    private fun refreshWidgetDataFromFlutter(context: Context, widgetData: SharedPreferences) {
        try {
            Log.d("HabitTimelineWidget", "Attempting fallback data refresh from Flutter preferences")
            
            // Read current habit data from Flutter shared preferences
            val flutterPrefs = context.getSharedPreferences(
                "FlutterSharedPreferences", 
                Context.MODE_PRIVATE
            )
            
            // Get habits data
            val habitsJson = flutterPrefs.getString("flutter.habits_data", null)
                ?: flutterPrefs.getString("flutter.habits", null)
            
            if (!habitsJson.isNullOrEmpty() && habitsJson != "[]") {
                // Update BOTH widget preferences and HomeWidgetPreferences with fresh data
                // This ensures both the widget provider and ListView services have the data
                
                // Update the passed widgetData
                val widgetEditor = widgetData.edit()
                widgetEditor.putString("habits", habitsJson)
                widgetEditor.putString("habits_data", habitsJson)
                widgetEditor.putLong("last_update", System.currentTimeMillis())
                
                // Also update HomeWidgetPreferences (used by ListView services)
                val homeWidgetPrefs = context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)
                val homeEditor = homeWidgetPrefs.edit()
                homeEditor.putString("habits", habitsJson)
                homeEditor.putString("habits_data", habitsJson)
                homeEditor.putLong("last_update", System.currentTimeMillis())
                
                // Copy theme settings to both
                val themeMode = flutterPrefs.getString("flutter.theme_mode", null)
                    ?: flutterPrefs.getString("flutter.themeMode", null)
                if (themeMode != null) {
                    widgetEditor.putString("themeMode", themeMode)
                    homeEditor.putString("themeMode", themeMode)
                }
                
                val primaryColor = flutterPrefs.getInt("flutter.primary_color", -1)
                if (primaryColor != -1) {
                    widgetEditor.putInt("primaryColor", primaryColor)
                    homeEditor.putInt("primaryColor", primaryColor)
                }
                
                // Apply both updates
                widgetEditor.apply()
                homeEditor.apply()
                
                Log.d("HabitTimelineWidget", "✅ Fallback data refresh successful (updated both widgetData and HomeWidgetPreferences)")
            } else {
                Log.w("HabitTimelineWidget", "No habit data found in Flutter preferences for fallback")
            }
        } catch (e: Exception) {
            Log.e("HabitTimelineWidget", "❌ Error during fallback data refresh", e)
        }
    }
}