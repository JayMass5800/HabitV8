package com.habittracker.habitv8

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.util.Log
import android.view.View
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetBackgroundIntent
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider
import org.json.JSONArray
import org.json.JSONObject

open class HabitCompactWidgetProvider : HomeWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        appWidgetIds.forEach { widgetId ->
            try {
                // Use direct R reference instead of getIdentifier for release builds
                val views = RemoteViews(context.packageName, R.layout.widget_compact)
                
                // Convert SharedPreferences to Map for compatibility
                val dataMap = widgetData.all
                
                // Update widget with current data
                updateCompactWidgetContent(context, views, dataMap)
                
                // Set up click handlers
                setupCompactClickHandlers(context, views, widgetId)
                
                appWidgetManager.updateAppWidget(widgetId, views)
            } catch (e: Exception) {
                // Create a minimal error widget
                createErrorWidget(context, appWidgetManager, widgetId)
            }
        }
    }
    
    private fun createErrorWidget(context: Context, appWidgetManager: AppWidgetManager, widgetId: Int) {
        try {
            val views = RemoteViews(context.packageName, R.layout.widget_compact)
            
            val emptyStateId = getResourceId(context, "compact_empty_state", "id")
            if (emptyStateId != 0) {
                views.setViewVisibility(emptyStateId, View.VISIBLE)
                views.setTextViewText(emptyStateId, "Widget Error")
            }
            
            appWidgetManager.updateAppWidget(widgetId, views)
        } catch (e: Exception) {
            // If even the error widget fails, there's nothing more we can do
        }
    }

    // Helper function to get resource ID by name
    private fun getResourceId(context: Context, resourceName: String, resourceType: String): Int {
        // Use direct R class references instead of getIdentifier for release builds
        return when (resourceType) {
            "id" -> when (resourceName) {
                "compact_empty_state" -> R.id.compact_empty_state
                "compact_habits_list" -> R.id.compact_habits_list
                "more_habits_indicator" -> R.id.more_habits_indicator
                "compact_habit_name" -> R.id.compact_habit_name
                "compact_habit_color_indicator" -> R.id.compact_habit_color_indicator
                "compact_habit_time" -> R.id.compact_habit_time
                "compact_complete_button" -> R.id.compact_complete_button
                "open_app_button" -> R.id.open_app_button
                else -> 0
            }
            "layout" -> when (resourceName) {
                "widget_compact_habit_item" -> R.layout.widget_compact_habit_item
                else -> 0
            }
            else -> 0
        }
    }

    private fun updateCompactWidgetContent(
        context: Context,
        views: RemoteViews,
        widgetData: Map<String, Any?>
    ) {
        try {
            // Update theme colors
            val themeMode = widgetData["themeMode"] as? String ?: "light"
            val primaryColorValue = widgetData["primaryColor"] as? Int ?: 0xFF6366F1.toInt()
            applyCompactThemeColors(views, themeMode, primaryColorValue)
            
            // Update habits list
            val habitsJson = widgetData["habits"] as? String
            
            if (habitsJson != null && habitsJson.isNotEmpty() && habitsJson != "[]") {
                updateCompactHabitsList(context, views, habitsJson, themeMode, primaryColorValue)
            } else {
                showCompactEmptyState(context, views, "No habits yet")
            }
            
        } catch (e: Exception) {
            showCompactErrorState(context, views)
        }
    }

    private fun updateCompactHabitsList(
        context: Context,
        views: RemoteViews,
        habitsJson: String,
        themeMode: String,
        primaryColor: Int
    ) {
        try {
            val habitsArray = JSONArray(habitsJson)
            
            // DO NOT clear children yet - get habits list ID first
            val habitsListId = getResourceId(context, "compact_habits_list", "id")
            if (habitsListId == 0) {
                Log.e("HabitCompactWidget", "Failed to get habits list resource ID")
                showCompactEmptyState(context, views, "Widget error")
                return
            }
            
            // Filter to only due habits and limit to 3
            val dueHabits = mutableListOf<JSONObject>()
            for (i in 0 until habitsArray.length()) {
                val habit = habitsArray.getJSONObject(i)
                val status = habit.optString("status", "Due")
                val isCompleted = habit.optBoolean("isCompleted", false)
                
                if (status == "Due" && !isCompleted) {
                    dueHabits.add(habit)
                    if (dueHabits.size >= 3) break
                }
            }
            
            if (dueHabits.isEmpty()) {
                // Check if there were any habits at all
                if (habitsArray.length() == 0) {
                    showCompactEmptyState(context, views, "No habits yet")
                } else {
                    // There are habits but all are completed
                    showCompactEmptyState(context, views, "All habits completed!")
                }
            } else {
                val emptyStateId = getResourceId(context, "compact_empty_state", "id")
                views.setViewVisibility(emptyStateId, View.GONE)
                
                // Now clear and add items
                views.removeAllViews(habitsListId)
                dueHabits.forEach { habit ->
                    addCompactHabitItem(context, views, habit, themeMode, primaryColor)
                }
                
                // Show "more habits" indicator if there are additional habits
                val remainingHabits = habitsArray.length() - dueHabits.size
                val moreHabitsId = getResourceId(context, "more_habits_indicator", "id")
                if (remainingHabits > 0) {
                    views.setTextViewText(moreHabitsId, "+$remainingHabits more habits")
                    views.setViewVisibility(moreHabitsId, View.VISIBLE)
                } else {
                    views.setViewVisibility(moreHabitsId, View.GONE)
                }
            }
            
        } catch (e: Exception) {
            // Error in updateCompactHabitsList - show error state
            showCompactErrorState(context, views)
        }
    }

    private fun addCompactHabitItem(
        context: Context,
        views: RemoteViews,
        habit: JSONObject,
        themeMode: String,
        primaryColor: Int
    ) {
        val habitItemLayoutId = getResourceId(context, "widget_compact_habit_item", "layout")
        if (habitItemLayoutId == 0) {
            Log.e("HabitCompactWidget", "Failed to get habit item layout resource")
            return
        }
        
        val habitItemViews = RemoteViews(context.packageName, habitItemLayoutId)
        
        try {
            // Set habit details with defensive access
            val habitName = habit.optString("name", "Unnamed Habit")
            val habitColor = habit.optInt("colorValue", primaryColor)
            val habitId = habit.optString("id", "unknown")
            val timeDisplay = habit.optString("timeDisplay", "")
            
            // Validate essential data
            if (habitName.isEmpty() || habitId == "unknown") {
                Log.w("HabitCompactWidget", "Skipping habit with missing essential data")
                return // Skip this habit if essential data is missing
            }
            
            // Update compact habit item views
            val habitNameId = getResourceId(context, "compact_habit_name", "id")
            val habitColorId = getResourceId(context, "compact_habit_color_indicator", "id")
            val habitTimeId = getResourceId(context, "compact_habit_time", "id")
            val completeButtonId = getResourceId(context, "compact_complete_button", "id")
            
            // Validate all resource IDs before using them
            if (habitNameId == 0 || habitColorId == 0 || habitTimeId == 0 || completeButtonId == 0) {
                Log.e("HabitCompactWidget", "Failed to get required resource IDs")
                return
            }
            
            habitItemViews.setTextViewText(habitNameId, habitName)
            
            // Set habit color
            habitItemViews.setInt(habitColorId, "setBackgroundColor", habitColor)
            
            // Show/hide time if available
            if (timeDisplay.isNotEmpty()) {
                habitItemViews.setTextViewText(habitTimeId, timeDisplay)
                habitItemViews.setViewVisibility(habitTimeId, View.VISIBLE)
            } else {
                habitItemViews.setViewVisibility(habitTimeId, View.GONE)
            }
            
            // Set up complete action
            val completeIntent = HomeWidgetBackgroundIntent.getBroadcast(
                context,
                android.net.Uri.parse("complete_habit?habitId=$habitId")
            )
            habitItemViews.setOnClickPendingIntent(completeButtonId, completeIntent)
            
            // Add the habit item to the list
            val habitsListId = getResourceId(context, "compact_habits_list", "id")
            views.addView(habitsListId, habitItemViews)
            
        } catch (e: Exception) {
            // Skip this habit item if there's an error
        }
    }

    private fun showCompactEmptyState(context: Context, views: RemoteViews, message: String = "All habits completed!") {
        val emptyStateId = getResourceId(context, "compact_empty_state", "id")
        val moreHabitsId = getResourceId(context, "more_habits_indicator", "id")
        views.setViewVisibility(emptyStateId, View.VISIBLE)
        views.setTextViewText(emptyStateId, message)
        views.setViewVisibility(moreHabitsId, View.GONE)
    }

    private fun showCompactErrorState(context: Context, views: RemoteViews) {
        val emptyStateId = getResourceId(context, "compact_empty_state", "id")
        val moreHabitsId = getResourceId(context, "more_habits_indicator", "id")
        views.setViewVisibility(emptyStateId, View.VISIBLE)
        views.setTextViewText(emptyStateId, "Error loading habits")
        views.setViewVisibility(moreHabitsId, View.GONE)
    }

    private fun setupCompactClickHandlers(
        context: Context,
        views: RemoteViews,
        widgetId: Int
    ) {
        try {
            // Open app button - Use a simple intent approach
            val intent = Intent(context, Class.forName("${context.packageName}.MainActivity"))
            val pendingIntent = PendingIntent.getActivity(
                context, 
                0, 
                intent, 
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            
            val openAppButtonId = getResourceId(context, "open_app_button", "id")
            val habitsListId = getResourceId(context, "compact_habits_list", "id")
            
            views.setOnClickPendingIntent(openAppButtonId, pendingIntent)
            
            // Header click to open timeline
            views.setOnClickPendingIntent(habitsListId, pendingIntent)
        } catch (e: Exception) {
            // Ignore click handler setup errors
        }
    }

    private fun applyCompactThemeColors(views: RemoteViews, themeMode: String, primaryColor: Int) {
        val isDarkMode = themeMode == "dark"
        
        // Set text colors
        val textPrimaryColor = if (isDarkMode) 0xFFFFFFFF.toInt() else 0xDD000000.toInt()
        val textSecondaryColor = if (isDarkMode) 0xB3FFFFFF.toInt() else 0x99000000.toInt()
        
        // Apply theme colors would go here if we had the specific view IDs
        // For now, we'll skip this to avoid more R. references
    }
}