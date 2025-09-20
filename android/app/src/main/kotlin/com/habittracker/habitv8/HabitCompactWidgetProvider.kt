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
                
                // Set up the ListView with RemoteViewsService
                setupListView(context, views, appWidgetId)
                
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

    private fun setupListView(context: Context, views: RemoteViews, appWidgetId: Int) {
        // Create intent for the RemoteViewsService
        val serviceIntent = Intent(context, HabitCompactWidgetService::class.java).apply {
            putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
            data = Uri.parse(toUri(Intent.URI_INTENT_SCHEME))
        }
        
        // Set the RemoteViewsService as the adapter for the ListView
        views.setRemoteAdapter(R.id.compact_habits_list, serviceIntent)
        
        // Set empty view for the ListView
        views.setEmptyView(R.id.compact_habits_list, R.id.compact_empty_state)
        
        // Set up pending intent template for list items
        setupListItemClickTemplate(context, views, appWidgetId)
        
        Log.d("HabitCompactWidget", "ListView setup completed for widget $appWidgetId")
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
            val prefs = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
            val habitsJson = prefs.getString("flutter.habits_data", null)
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
            val themeMode = widgetData.getString("flutter.themeMode", "light") ?: "light"
            val primaryColor = widgetData.getInt("flutter.primaryColor", 0xFF6200EE.toInt())
            
            val isDarkMode = themeMode == "dark"
            
            // Modern theme colors with better contrast - matching timeline widget
            val backgroundColor = if (isDarkMode) 0xFF0F0F0F.toInt() else 0xFFFAFAFA.toInt()
            val surfaceColor = if (isDarkMode) 0xFF1A1A1A.toInt() else 0xFFFFFFFF.toInt()
            
            // Apply dynamic primary color to header background
            views.setInt(R.id.header_layout, "setBackgroundColor", primaryColor)
            
            // Header elements use white text for contrast against colored background
            views.setTextColor(R.id.compact_title, 0xFFFFFFFF.toInt())
            views.setInt(R.id.open_app_button, "setColorFilter", 0xFFFFFFFF.toInt())
            
            // Apply background color to widget root to eliminate white borders
            views.setInt(R.id.compact_widget_root, "setBackgroundColor", backgroundColor)
            
            Log.d("HabitCompactWidget", "Enhanced theme colors applied - isDark: $isDarkMode, primary: ${Integer.toHexString(primaryColor)}")
        } catch (e: Exception) {
            Log.e("HabitCompactWidget", "Error applying enhanced theme colors", e)
        }
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