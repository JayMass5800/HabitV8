package com.habittracker.habitv8.debug

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetBackgroundIntent
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider
import android.graphics.Color
import android.view.View
import org.json.JSONArray
import org.json.JSONObject
import java.text.SimpleDateFormat
import java.util.*

/**
 * Debug-specific widget provider for timeline widget
 * This class is identical to the main provider but resides in the debug package namespace
 */
class HabitTimelineWidgetProvider : HomeWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        appWidgetIds.forEach { widgetId ->
            try {
                val layoutId = context.resources.getIdentifier("widget_timeline", "layout", context.packageName)
                if (layoutId == 0) {
                    // Fallback if dynamic lookup fails
                    return@forEach
                }
                
                val views = RemoteViews(context.packageName, layoutId)
                
                // Convert SharedPreferences to Map for compatibility
                val dataMap = widgetData.all
                
                // Update widget with current data
                updateWidgetContent(context, views, dataMap)
                
                // Set up click handlers
                setupClickHandlers(context, views, widgetId)
                
                appWidgetManager.updateAppWidget(widgetId, views)
            } catch (e: Exception) {
                // Create a minimal error widget
                createErrorWidget(context, appWidgetManager, widgetId)
            }
        }
    }
    
    private fun createErrorWidget(context: Context, appWidgetManager: AppWidgetManager, widgetId: Int) {
        try {
            val layoutId = context.resources.getIdentifier("widget_timeline", "layout", context.packageName)
            if (layoutId != 0) {
                val views = RemoteViews(context.packageName, layoutId)
                
                // Show error state
                val emptyStateId = context.resources.getIdentifier("empty_state", "id", context.packageName)
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
    
    private fun updateWidgetContent(context: Context, views: RemoteViews, dataMap: Map<String, *>) {
        try {
            // Get theme data
            val themeMode = dataMap["themeMode"] as? String ?: "system"
            val primaryColorString = dataMap["primaryColor"] as? String ?: "#2196F3"
            val primaryColor = Color.parseColor(primaryColorString)
            
            // Get habits data
            val habitsJson = dataMap["habits"] as? String ?: "[]"
            val habitsArray = JSONArray(habitsJson)
            
            // Get current date
            val selectedDate = dataMap["selectedDate"] as? String ?: getCurrentDateString()
            
            // Update header
            updateTimelineHeader(context, views, selectedDate, themeMode, primaryColor)
            
            // Show habits or empty state
            if (habitsArray.length() == 0) {
                showEmptyState(context, views)
            } else {
                val emptyStateId = getResourceId(context, "empty_state", "id")
                val habitsScrollId = getResourceId(context, "habits_scroll", "id")
                views.setViewVisibility(emptyStateId, View.GONE)
                views.setViewVisibility(habitsScrollId, View.VISIBLE)
                
                // Add habit items (limit to prevent performance issues)
                val maxHabits = Math.min(habitsArray.length(), 10)
                for (i in 0 until maxHabits) {
                    val habit = habitsArray.getJSONObject(i)
                    addHabitItem(context, views, habit, themeMode, primaryColor)
                }
            }
            
        } catch (e: Exception) {
            showErrorState(context, views)
        }
    }

    private fun addHabitItem(
        context: Context,
        views: RemoteViews,
        habit: JSONObject,
        themeMode: String,
        primaryColor: Int
    ) {
        val habitItemLayoutId = getResourceId(context, "widget_habit_item", "layout")
        val habitItemViews = RemoteViews(context.packageName, habitItemLayoutId)
        
        try {
            // Set habit details
            val habitName = habit.getString("name")
            val habitCategory = habit.optString("category", "")
            val habitColor = habit.optInt("colorValue", primaryColor)
            val habitId = habit.getString("id")
            val isCompleted = habit.optBoolean("isCompleted", false)
            val status = habit.optString("status", "Due")
            val timeDisplay = habit.optString("timeDisplay", "")
            
            // Update habit item views
            val habitNameId = getResourceId(context, "habit_name", "id")
            val habitCategoryId = getResourceId(context, "habit_category", "id")
            val habitStatusId = getResourceId(context, "habit_status", "id")
            val habitColorIndicatorId = getResourceId(context, "habit_color_indicator", "id")
            val habitTimeId = getResourceId(context, "habit_time", "id")
            val completeButtonId = getResourceId(context, "complete_button", "id")
            val editButtonId = getResourceId(context, "edit_button", "id")
            
            habitItemViews.setTextViewText(habitNameId, habitName)
            habitItemViews.setTextViewText(habitCategoryId, habitCategory)
            habitItemViews.setTextViewText(habitStatusId, status)
            
            // Set habit color
            habitItemViews.setInt(habitColorIndicatorId, "setBackgroundColor", habitColor)
            
            // Show/hide time if available
            if (timeDisplay.isNotEmpty()) {
                habitItemViews.setTextViewText(habitTimeId, timeDisplay)
                habitItemViews.setViewVisibility(habitTimeId, View.VISIBLE)
            } else {
                habitItemViews.setViewVisibility(habitTimeId, View.GONE)
            }
            
            // Set status color
            val statusColor = when (status) {
                "Completed" -> getResourceColor(context, "widget_status_completed")
                "Due" -> getResourceColor(context, "widget_status_due")
                "Missed" -> getResourceColor(context, "widget_status_missed")
                "Upcoming" -> getResourceColor(context, "widget_status_upcoming")
                else -> getResourceColor(context, "widget_status_due")
            }
            habitItemViews.setTextColor(habitStatusId, statusColor)
            
            // Set up complete button
            if (!isCompleted && status != "Upcoming") {
                habitItemViews.setViewVisibility(completeButtonId, View.VISIBLE)
                val completeIntent = HomeWidgetBackgroundIntent.getBroadcast(
                    context,
                    android.net.Uri.parse("complete_habit?habitId=$habitId")
                )
                habitItemViews.setOnClickPendingIntent(completeButtonId, completeIntent)
            } else {
                habitItemViews.setViewVisibility(completeButtonId, View.GONE)
            }
            
            // Set up edit button
            val editIntent = HomeWidgetLaunchIntent.getActivity(
                context,
                MainActivity::class.java,
                android.net.Uri.parse("edit_habit?habitId=$habitId")
            )
            habitItemViews.setOnClickPendingIntent(editButtonId, editIntent)
            
            // Add the habit item to the list
            val habitsListId = getResourceId(context, "habits_list", "id")
            views.addView(habitsListId, habitItemViews)
            
        } catch (e: Exception) {
            // Skip this habit item if there's an error
        }
    }
    
    private fun updateTimelineHeader(context: Context, views: RemoteViews, selectedDate: String, themeMode: String, primaryColor: Int) {
        try {
            val headerTitleId = getResourceId(context, "header_title", "id")
            val headerDateId = getResourceId(context, "header_date", "id")
            val refreshButtonId = getResourceId(context, "refresh_button", "id")
            val openAppButtonId = getResourceId(context, "open_app_button", "id")
            
            views.setTextViewText(headerTitleId, "Your Habits")
            views.setTextViewText(headerDateId, formatDateForDisplay(selectedDate))
            
            // Set up refresh button
            val refreshIntent = HomeWidgetBackgroundIntent.getBroadcast(
                context,
                android.net.Uri.parse("refresh_widget")
            )
            views.setOnClickPendingIntent(refreshButtonId, refreshIntent)
            
            // Set up open app button
            val openAppIntent = HomeWidgetLaunchIntent.getActivity(
                context,
                Class.forName("com.habittracker.habitv8.MainActivity")
            )
            views.setOnClickPendingIntent(openAppButtonId, openAppIntent)
            
        } catch (e: Exception) {
            // Continue with default header
        }
    }
    
    private fun showEmptyState(context: Context, views: RemoteViews) {
        val emptyStateId = getResourceId(context, "empty_state", "id")
        val habitsScrollId = getResourceId(context, "habits_scroll", "id")
        
        views.setViewVisibility(emptyStateId, View.VISIBLE)
        views.setViewVisibility(habitsScrollId, View.GONE)
        views.setTextViewText(emptyStateId, "No habits for today")
    }
    
    private fun showErrorState(context: Context, views: RemoteViews) {
        val emptyStateId = getResourceId(context, "empty_state", "id")
        val habitsScrollId = getResourceId(context, "habits_scroll", "id")
        
        views.setViewVisibility(emptyStateId, View.VISIBLE)
        views.setViewVisibility(habitsScrollId, View.GONE)
        views.setTextViewText(emptyStateId, "Error loading habits")
    }
    
    private fun setupClickHandlers(context: Context, views: RemoteViews, widgetId: Int) {
        try {
            // Main widget click to open app
            val openAppIntent = HomeWidgetLaunchIntent.getActivity(
                context,
                Class.forName("com.habittracker.habitv8.MainActivity")
            )
            
            val timelineIconId = getResourceId(context, "timeline_icon", "id")
            views.setOnClickPendingIntent(timelineIconId, openAppIntent)
            
        } catch (e: Exception) {
            // Continue without click handlers
        }
    }
    
    private fun getResourceId(context: Context, name: String, type: String): Int {
        return context.resources.getIdentifier(name, type, context.packageName)
    }
    
    private fun getResourceColor(context: Context, name: String): Int {
        val colorId = getResourceId(context, name, "color")
        return if (colorId != 0) {
            context.getColor(colorId)
        } else {
            Color.GRAY
        }
    }
    
    private fun getCurrentDateString(): String {
        val formatter = SimpleDateFormat("yyyy-MM-dd", Locale.getDefault())
        return formatter.format(Date())
    }
    
    private fun formatDateForDisplay(dateString: String): String {
        return try {
            val inputFormatter = SimpleDateFormat("yyyy-MM-dd", Locale.getDefault())
            val outputFormatter = SimpleDateFormat("MMM d, yyyy", Locale.getDefault())
            val date = inputFormatter.parse(dateString)
            outputFormatter.format(date ?: Date())
        } catch (e: Exception) {
            dateString
        }
    }
}