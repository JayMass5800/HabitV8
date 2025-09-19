package com.habittracker.habitv8.debug

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

/**
 * Debug-specific widget provider for compact widget
 * This class is identical to the main provider but resides in the debug package namespace
 */
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
                
                // Show error state
                val emptyStateId = context.resources.getIdentifier("compact_empty_state", "id", context.packageName)
                if (emptyStateId != 0) {
                    views.setViewVisibility(emptyStateId, View.VISIBLE)
                    views.setTextViewText(emptyStateId, "Widget Error")
                }
                
                appWidgetManager.updateAppWidget(widgetId, views)
            }
        } catch (e: Exception) {
            // Last resort: minimal widget
        }
    }
    
    private fun updateCompactWidgetContent(context: Context, views: RemoteViews, dataMap: Map<String, *>) {
        try {
            // Get theme data
            val themeMode = dataMap["themeMode"] as? String ?: "system"
            val primaryColorString = dataMap["primaryColor"] as? String ?: "#2196F3"
            val primaryColor = android.graphics.Color.parseColor(primaryColorString)
            
            // Get habits data
            val habitsJson = dataMap["habits"] as? String ?: "[]"
            val habitsArray = JSONArray(habitsJson)
            
            // Show habits or empty state
            if (habitsArray.length() == 0) {
                showCompactEmptyState(context, views)
            } else {
                val emptyStateId = getResourceId(context, "compact_empty_state", "id")
                val habitsListId = getResourceId(context, "compact_habits_list", "id")
                
                views.setViewVisibility(emptyStateId, View.GONE)
                views.setViewVisibility(habitsListId, View.VISIBLE)
                
                // Clear existing habit items
                views.removeAllViews(habitsListId)
                
                // Get due habits (limited to 3 for compact widget)
                val dueHabits = mutableListOf<JSONObject>()
                for (i in 0 until habitsArray.length()) {
                    val habit = habitsArray.getJSONObject(i)
                    val status = habit.optString("status", "Due")
                    val isCompleted = habit.optBoolean("isCompleted", false)
                    
                    if (!isCompleted && (status == "Due" || status == "Missed")) {
                        dueHabits.add(habit)
                        if (dueHabits.size >= 3) break
                    }
                }
                
                // Add habit items
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
        val habitsListId = getResourceId(context, "compact_habits_list", "id")
        
        views.setViewVisibility(emptyStateId, View.VISIBLE)
        views.setViewVisibility(habitsListId, View.GONE)
        views.setTextViewText(emptyStateId, "No due habits")
    }
    
    private fun showCompactErrorState(context: Context, views: RemoteViews) {
        val emptyStateId = getResourceId(context, "compact_empty_state", "id")
        val habitsListId = getResourceId(context, "compact_habits_list", "id")
        
        views.setViewVisibility(emptyStateId, View.VISIBLE)
        views.setViewVisibility(habitsListId, View.GONE)
        views.setTextViewText(emptyStateId, "Error loading habits")
    }
    
    private fun setupCompactClickHandlers(context: Context, views: RemoteViews, widgetId: Int) {
        try {
            // Set up add habit button
            val addHabitButtonId = getResourceId(context, "add_habit_button", "id")
            val addHabitIntent = HomeWidgetLaunchIntent.getActivity(
                context,
                Class.forName("com.habittracker.habitv8.MainActivity"),
                android.net.Uri.parse("add_habit")
            )
            views.setOnClickPendingIntent(addHabitButtonId, addHabitIntent)
            
            // Main widget click to open app
            val openAppIntent = HomeWidgetLaunchIntent.getActivity(
                context,
                Class.forName("com.habittracker.habitv8.MainActivity")
            )
            
            // Set click handler for the entire widget background
            views.setOnClickPendingIntent(android.R.id.background, openAppIntent)
            
        } catch (e: Exception) {
            // Continue without click handlers
        }
    }
    
    private fun getResourceId(context: Context, name: String, type: String): Int {
        return context.resources.getIdentifier(name, type, context.packageName)
    }
}