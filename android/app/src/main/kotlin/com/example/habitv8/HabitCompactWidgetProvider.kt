package com.example.habitv8

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.view.View
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetBackgroundIntent
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider
import org.json.JSONArray
import org.json.JSONObject

class HabitCompactWidgetProvider : HomeWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        appWidgetIds.forEach { widgetId ->
            try {
                val layoutId = context.resources.getIdentifier("widget_compact", "layout", context.packageName)
                if (layoutId == 0) {
                    // Fallback to hardcoded resource ID if dynamic lookup fails
                    // This shouldn't happen, but provides a safety net
                    return@forEach
                }
                
                val views = RemoteViews(context.packageName, layoutId)
                
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
            val layoutId = context.resources.getIdentifier("widget_compact", "layout", context.packageName)
            if (layoutId != 0) {
                val views = RemoteViews(context.packageName, layoutId)
                
                val emptyStateId = getResourceId(context, "compact_empty_state", "id")
                if (emptyStateId != 0) {
                    views.setViewVisibility(emptyStateId, View.VISIBLE)
                    views.setTextViewText(emptyStateId, "Widget Error")
                }
                
                appWidgetManager.updateAppWidget(widgetId, views)
            }
        } catch (e: Exception) {
            // If even the error widget fails, there's nothing more we can do
        }
    }

    // Helper function to get resource ID by name
    private fun getResourceId(context: Context, resourceName: String, resourceType: String): Int {
        val resourceId = context.resources.getIdentifier(resourceName, resourceType, context.packageName)
        if (resourceId == 0) {
            // Log the missing resource for debugging
            // In production, you might want to use proper logging
        }
        return resourceId
    }

    private fun updateCompactWidgetContent(
        context: Context,
        views: RemoteViews,
        widgetData: Map<String, Any?>
    ) {
        try {
            // Update theme colors
            val themeMode = widgetData["themeMode"] as? String ?: "light"
            val primaryColorValue = widgetData["primaryColor"] as? Int ?: 0x6366F1
            applyCompactThemeColors(views, themeMode, primaryColorValue)
            
            // Update habits list
            val habitsJson = widgetData["habits"] as? String
            
            if (habitsJson != null) {
                updateCompactHabitsList(context, views, habitsJson, themeMode, primaryColorValue)
            } else {
                showCompactEmptyState(context, views)
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
            
            // Clear existing habit items
            val habitsListId = getResourceId(context, "compact_habits_list", "id")
            views.removeAllViews(habitsListId)
            
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
                showCompactEmptyState(context, views)
            } else {
                val emptyStateId = getResourceId(context, "compact_empty_state", "id")
                views.setViewVisibility(emptyStateId, View.GONE)
                
                // Add compact habit items
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
        val habitItemViews = RemoteViews(context.packageName, habitItemLayoutId)
        
        try {
            // Set habit details
            val habitName = habit.getString("name")
            val habitColor = habit.optInt("colorValue", primaryColor)
            val habitId = habit.getString("id")
            val timeDisplay = habit.optString("timeDisplay", "")
            
            // Update compact habit item views
            val habitNameId = getResourceId(context, "compact_habit_name", "id")
            val habitColorId = getResourceId(context, "compact_habit_color_indicator", "id")
            val habitTimeId = getResourceId(context, "compact_habit_time", "id")
            val completeButtonId = getResourceId(context, "compact_complete_button", "id")
            
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

    private fun showCompactEmptyState(context: Context, views: RemoteViews) {
        val emptyStateId = getResourceId(context, "compact_empty_state", "id")
        val moreHabitsId = getResourceId(context, "more_habits_indicator", "id")
        views.setViewVisibility(emptyStateId, View.VISIBLE)
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