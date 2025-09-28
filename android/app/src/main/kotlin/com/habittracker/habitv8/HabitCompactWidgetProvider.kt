package com.habittracker.habitv8

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.net.Uri
import android.util.Log
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetBackgroundIntent
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider

open class HabitCompactWidgetProvider : HomeWidgetProvider() {

    companion object {
        const val COMPACT_ACTION_COMPLETE = "com.habittracker.habitv8.COMPACT_COMPLETE"
        const val COMPACT_ACTION_OPEN = "com.habittracker.habitv8.COMPACT_OPEN"
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
        Log.d("HabitCompactWidget", "onUpdate called with ${appWidgetIds.size} widget IDs")
        
        appWidgetIds.forEach { appWidgetId ->
            try {
                val views = RemoteViews(context.packageName, R.layout.widget_compact)
                
                // Set up the ListView with RemoteViewsService (pass theme extras)
                setupListView(context, views, appWidgetId, widgetData)
                
                // Apply theme colors
                applyCompactThemeColors(context, views, widgetData)
                
                // Set up header click handlers
                setupHeaderClickHandlers(context, views, appWidgetId)
                
                // Check if we have habits to show
                val hasHabits = checkForHabits(context)
                val habitCount = getHabitCount(context)
                
                if (hasHabits) {
                    views.setViewVisibility(R.id.compact_habits_list, android.view.View.VISIBLE)
                    views.setViewVisibility(R.id.compact_empty_state, android.view.View.GONE)
                    
                    // Show scroll hint if there are more than 5 habits
                    if (habitCount > 5) {
                        views.setTextViewText(R.id.more_habits_indicator, "Scroll for ${habitCount - 5} more")
                        views.setViewVisibility(R.id.more_habits_indicator, android.view.View.VISIBLE)
                    } else {
                        views.setViewVisibility(R.id.more_habits_indicator, android.view.View.GONE)
                    }
                } else {
                    views.setViewVisibility(R.id.compact_habits_list, android.view.View.GONE)
                    views.setViewVisibility(R.id.compact_empty_state, android.view.View.VISIBLE)
                    views.setViewVisibility(R.id.more_habits_indicator, android.view.View.GONE)
                    setupEmptyStateClickHandler(context, views, appWidgetId)
                }
                
                appWidgetManager.updateAppWidget(appWidgetId, views)
                
                // Notify the ListView that data might have changed
                appWidgetManager.notifyAppWidgetViewDataChanged(appWidgetId, R.id.compact_habits_list)
                
                Log.d("HabitCompactWidget", "Widget update completed for ID: $appWidgetId")
            } catch (e: Exception) {
                Log.e("HabitCompactWidget", "Error updating widget $appWidgetId", e)
            }
        }
    }

    private fun setupListView(context: Context, views: RemoteViews, appWidgetId: Int, widgetData: SharedPreferences) {
        // Resolve theme extras to pass into the service for reliability
        val flutterPrefs = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        val themeModeExtra = widgetData.getString("themeMode", null)
            ?: flutterPrefs.getString("flutter.theme_mode", null)
            ?: flutterPrefs.getString("theme_mode", null)
        val defaultPrimary = 0xFF2196F3.toInt()
        val primaryColorExtra = when {
            widgetData.contains("primaryColor") -> getIntCompat(widgetData, "primaryColor", defaultPrimary)
            flutterPrefs.contains("flutter.primary_color") -> getIntCompat(flutterPrefs, "flutter.primary_color", defaultPrimary)
            flutterPrefs.contains("primary_color") -> getIntCompat(flutterPrefs, "primary_color", defaultPrimary)
            else -> defaultPrimary
        }

        // Create intent for the RemoteViewsService
        val serviceIntent = Intent(context, HabitCompactWidgetService::class.java).apply {
            putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
            putExtra("themeMode", themeModeExtra)
            putExtra("primaryColor", primaryColorExtra)
            data = Uri.parse(toUri(Intent.URI_INTENT_SCHEME))
        }
        
        // Set the RemoteViewsService as the adapter for the ListView
        views.setRemoteAdapter(R.id.compact_habits_list, serviceIntent)
        
        // Set empty view for the ListView
        views.setEmptyView(R.id.compact_habits_list, R.id.compact_empty_state)
        
        // Set up pending intent template for list items
        setupListItemClickTemplate(context, views, appWidgetId)
        
        Log.d("HabitCompactWidget", "ListView setup completed for widget $appWidgetId with theme extras: mode=$themeModeExtra, primary=${Integer.toHexString(primaryColorExtra)}")
    }

    private fun setupListItemClickTemplate(context: Context, views: RemoteViews, appWidgetId: Int) {
        // Create pending intent template for habit completion
        val completePendingIntent = Intent(context, HabitCompactWidgetProvider::class.java).apply {
            action = COMPACT_ACTION_COMPLETE
            putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
            data = Uri.parse(toUri(Intent.URI_INTENT_SCHEME))
        }
        
        val completePendingIntentTemplate = PendingIntent.getBroadcast(
            context, 
            0, 
            completePendingIntent, 
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        
        views.setPendingIntentTemplate(R.id.compact_habits_list, completePendingIntentTemplate)
    }

    private fun setupHeaderClickHandlers(context: Context, views: RemoteViews, appWidgetId: Int) {
        // Add Habit button - open app to create habit screen
        val addHabitIntent = Intent(context, MainActivity::class.java).apply {
            putExtra("screen", "create_habit")
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
        }
        val addHabitPendingIntent = PendingIntent.getActivity(
            context,
            appWidgetId + 2000, // Unique request code for compact widget
            addHabitIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        views.setOnClickPendingIntent(R.id.compact_add_habit_button, addHabitPendingIntent)
        
        // Title and icon click to open app
        val openAppPendingIntent = HomeWidgetLaunchIntent.getActivity(context, MainActivity::class.java)
        views.setOnClickPendingIntent(R.id.compact_title, openAppPendingIntent)
        views.setOnClickPendingIntent(R.id.open_app_button, openAppPendingIntent)
    }

    private fun setupEmptyStateClickHandler(context: Context, views: RemoteViews, appWidgetId: Int) {
        val openAppPendingIntent = HomeWidgetLaunchIntent.getActivity(context, MainActivity::class.java)
        views.setOnClickPendingIntent(R.id.compact_empty_state, openAppPendingIntent)
    }

    private fun checkForHabits(context: Context): Boolean {
        return try {
            val prefs = context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)
            val habitsJson = prefs.getString("habits", null)
                ?: prefs.getString("home_widget.string.habits", null)
                ?: prefs.getString("habits_data", null)
            !habitsJson.isNullOrEmpty() && habitsJson != "[]"
        } catch (e: Exception) {
            Log.e("HabitCompactWidget", "Error checking for habits", e)
            false
        }
    }

    private fun getHabitCount(context: Context): Int {
        return try {
            val prefs = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
            val habitsJson = prefs.getString("flutter.habits_data", null)
            if (!habitsJson.isNullOrEmpty() && habitsJson != "[]") {
                val gson = com.google.gson.Gson()
                val type = com.google.gson.reflect.TypeToken.getParameterized(
                    java.util.List::class.java,
                    Map::class.java
                ).type
                val habitsList: List<Map<String, Any>> = gson.fromJson(habitsJson, type) ?: emptyList()
                habitsList.size
            } else {
                0
            }
        } catch (e: Exception) {
            Log.e("HabitCompactWidget", "Error getting habit count", e)
            0
        }
    }

    private fun applyCompactThemeColors(context: Context, views: RemoteViews, widgetData: SharedPreferences) {
        try {
            // Read theme mode from widget data first, then from app prefs, else fall back to system
            var themeMode = widgetData.getString("themeMode", null)
                ?: widgetData.getString("home_widget.double.themeMode", null)
                ?: widgetData.getString("flutter.theme_mode", null) // from ThemeService via shared_preferences
                ?: widgetData.getString("flutter.themeMode", null) // legacy/camelCase fallback

            // If no explicit theme mode is found, check system theme
            if (themeMode == null) {
                val systemNightMode = context.resources.configuration.uiMode and 
                    android.content.res.Configuration.UI_MODE_NIGHT_MASK
                themeMode = when (systemNightMode) {
                    android.content.res.Configuration.UI_MODE_NIGHT_YES -> "dark"
                    android.content.res.Configuration.UI_MODE_NIGHT_NO -> "light"
                    else -> "light"
                }
                Log.d("HabitCompactWidget", "No saved theme found, using system theme: $themeMode")
            }
            
            Log.d("HabitCompactWidget", "Detected theme mode: '$themeMode'")
            
            // Read primary color from widget data first, then from app prefs; default to app's default blue
            val primaryColor = when {
                widgetData.contains("primaryColor") -> widgetData.getInt("primaryColor", 0xFF2196F3.toInt())
                widgetData.contains("home_widget.double.primaryColor") -> {
                    try {
                        widgetData.getFloat("home_widget.double.primaryColor", 0xFF2196F3.toFloat()).toInt()
                    } catch (e: Exception) {
                        0xFF2196F3.toInt()
                    }
                }
                widgetData.contains("flutter.primary_color") -> widgetData.getInt("flutter.primary_color", 0xFF2196F3.toInt())
                widgetData.contains("flutter.primaryColor") -> widgetData.getInt("flutter.primaryColor", 0xFF2196F3.toInt())
                else -> 0xFF2196F3.toInt()
            }
            
            Log.d("HabitCompactWidget", "Using theme - mode: '$themeMode', primary: ${Integer.toHexString(primaryColor)}")
            
            val isDarkMode = themeMode.equals("dark", ignoreCase = true)
            
            // 50% opacity backgrounds (50% transparency) - 0x80 = 128/255 = 50%
            val backgroundColor = if (isDarkMode) 0x800F0F0F.toInt() else 0x80FAFAFA.toInt()
            
            // Apply semi-transparent colors with error handling
            try {
                views.setInt(R.id.compact_widget_root, "setBackgroundColor", backgroundColor)
                views.setInt(R.id.header_layout, "setBackgroundColor", primaryColor) // Keep header fully opaque
                views.setTextColor(R.id.compact_title, 0xFFFFFFFF.toInt())
                views.setInt(R.id.open_app_button, "setColorFilter", 0xFFFFFFFF.toInt())
            } catch (e: Exception) {
                Log.e("HabitCompactWidget", "Error applying specific colors, using fallbacks", e)
                // Fallback to ensure widget has some background
                views.setInt(R.id.compact_widget_root, "setBackgroundColor", 0x80FAFAFA.toInt())
            }
            
            Log.d("HabitCompactWidget", "Semi-transparent theme applied - isDark: $isDarkMode, bg: ${Integer.toHexString(backgroundColor)}")
        } catch (e: Exception) {
            Log.e("HabitCompactWidget", "Error applying compact theme colors, using fallback", e)
            // Emergency fallback with transparency
            try {
                views.setInt(R.id.compact_widget_root, "setBackgroundColor", 0x80FAFAFA.toInt())
                views.setInt(R.id.header_layout, "setBackgroundColor", 0xFF2196F3.toInt())
            } catch (fallbackError: Exception) {
                Log.e("HabitCompactWidget", "Even fallback failed", fallbackError)
            }
        }
    }

    override fun onEnabled(context: Context) {
        super.onEnabled(context)
        Log.d("HabitCompactWidget", "Widget enabled - scheduling periodic updates")
        WidgetUpdateWorker.schedulePeriodicUpdates(context)
    }
    
    override fun onDisabled(context: Context) {
        super.onDisabled(context)
        Log.d("HabitCompactWidget", "All widgets disabled")
        // Note: We don't cancel WorkManager here as timeline widgets might still be active
    }

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)
        
        when (intent.action) {
            COMPACT_ACTION_COMPLETE -> {
                handleHabitComplete(context, intent)
            }
            COMPACT_ACTION_OPEN -> {
                handleHabitOpen(context, intent)
            }
        }
    }

    private fun handleHabitComplete(context: Context, intent: Intent) {
        val habitId = intent.getStringExtra(EXTRA_HABIT_ID)
        Log.d("HabitCompactWidget", "Habit completion requested for ID: $habitId")
        
        // Send the completion action to Flutter via home_widget
        val backgroundPendingIntent = HomeWidgetBackgroundIntent.getBroadcast(
            context,
            Uri.parse("habitv8://habit/complete?id=$habitId")
        )
        try {
            backgroundPendingIntent.send()
        } catch (e: Exception) {
            Log.e("HabitCompactWidget", "Error sending background intent", e)
        }
        
        // Refresh the widget after a short delay
        val appWidgetId = intent.getIntExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, -1)
        if (appWidgetId != -1) {
            val appWidgetManager = AppWidgetManager.getInstance(context)
            appWidgetManager.notifyAppWidgetViewDataChanged(appWidgetId, R.id.compact_habits_list)
        }
    }

    private fun handleHabitOpen(context: Context, intent: Intent) {
        val habitId = intent.getStringExtra(EXTRA_HABIT_ID)
        Log.d("HabitCompactWidget", "Opening habit details for ID: $habitId")
        
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
            Log.e("HabitCompactWidget", "Error opening habit details", e)
            // Fallback to just opening the app
            val fallbackIntent = HomeWidgetLaunchIntent.getActivity(context, MainActivity::class.java)
            fallbackIntent.send()
        }
    }
}