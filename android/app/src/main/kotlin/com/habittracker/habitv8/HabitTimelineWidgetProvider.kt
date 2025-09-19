package com.habittracker.habitv8

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

class HabitTimelineWidgetProvider : HomeWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        appWidgetIds.forEach { widgetId ->
            try {
                // Use direct R reference instead of getIdentifier for release builds
                val views = RemoteViews(context.packageName, R.layout.widget_timeline)
                
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
            val views = RemoteViews(context.packageName, R.layout.widget_timeline)
            
            val headerTitleId = R.id.header_title
            views.setTextViewText(headerTitleId, "Widget Error")
            
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
                "header_date" -> R.id.header_date
                "habits_list" -> R.id.habits_list
                "next_habit_section" -> R.id.next_habit_section
                "empty_state" -> R.id.empty_state
                "habits_scroll" -> R.id.habits_scroll
                "habit_name" -> R.id.habit_name
                "habit_category" -> R.id.habit_category
                "habit_status" -> R.id.habit_status
                "habit_color_indicator" -> R.id.habit_color_indicator
                "habit_time" -> R.id.habit_time
                "complete_button" -> R.id.complete_button
                "edit_button" -> R.id.edit_button
                "next_habit_name" -> R.id.next_habit_name
                "next_habit_time" -> R.id.next_habit_time
                else -> 0
            }
            "layout" -> when (resourceName) {
                "widget_habit_item" -> R.layout.widget_habit_item
                else -> 0
            }
            else -> 0
        }
    }

    private fun updateWidgetContent(
        context: Context,
        views: RemoteViews,
        widgetData: Map<String, Any?>
    ) {
        try {
            // Update header
            val currentDate = widgetData["selectedDate"] as? String ?: getCurrentDateString()
            val formattedDate = formatDateForDisplay(currentDate)
            val headerDateId = getResourceId(context, "header_date", "id")
            views.setTextViewText(headerDateId, formattedDate)
            
            // Update theme colors
            val themeMode = widgetData["themeMode"] as? String ?: "light"
            val primaryColorValue = widgetData["primaryColor"] as? Int ?: 0x6366F1
            applyThemeColors(context, views, themeMode, primaryColorValue)
            
            // Update habits list
            val habitsJson = widgetData["habits"] as? String
            val nextHabitJson = widgetData["nextHabit"] as? String
            
            if (habitsJson != null) {
                updateHabitsList(context, views, habitsJson, nextHabitJson, themeMode, primaryColorValue)
            } else {
                showEmptyState(context, views)
            }
            
        } catch (e: Exception) {
            // Log error and show fallback state
            showErrorState(context, views)
        }
    }

    private fun updateHabitsList(
        context: Context,
        views: RemoteViews,
        habitsJson: String,
        nextHabitJson: String?,
        themeMode: String,
        primaryColor: Int
    ) {
        try {
            val habitsArray = JSONArray(habitsJson)
            
            // Clear existing habit items
            val habitsListId = getResourceId(context, "habits_list", "id")
            views.removeAllViews(habitsListId)
            
            // Show next habit if available
            if (nextHabitJson != null) {
                val nextHabit = JSONObject(nextHabitJson)
                showNextHabit(context, views, nextHabit, primaryColor)
            } else {
                val nextHabitSectionId = getResourceId(context, "next_habit_section", "id")
                views.setViewVisibility(nextHabitSectionId, View.GONE)
            }
            
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
            val statusColor = getStatusColor(status)
            habitItemViews.setInt(habitStatusId, "setBackgroundColor", statusColor)
            
            // Show/hide complete button based on status
            val canComplete = status == "Due" && !isCompleted
            if (canComplete) {
                habitItemViews.setViewVisibility(completeButtonId, View.VISIBLE)
                
                // Set up complete action
                val completeIntent = HomeWidgetBackgroundIntent.getBroadcast(
                    context,
                    android.net.Uri.parse("complete_habit?habitId=$habitId")
                )
                habitItemViews.setOnClickPendingIntent(completeButtonId, completeIntent)
            } else {
                habitItemViews.setViewVisibility(completeButtonId, View.GONE)
            }
            
            // Set up edit action
            try {
                val intent = Intent(context, Class.forName("${context.packageName}.MainActivity"))
                val editIntent = PendingIntent.getActivity(
                    context, 
                    habitId.hashCode(), 
                    intent, 
                    PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                )
                habitItemViews.setOnClickPendingIntent(editButtonId, editIntent)
            } catch (e: Exception) {
                // Ignore if MainActivity can't be found
            }
            
            // Apply strikethrough if completed
            if (isCompleted) {
                habitItemViews.setInt(habitNameId, "setPaintFlags", 
                    android.graphics.Paint.STRIKE_THRU_TEXT_FLAG)
            }
            
            // Add the habit item to the list
            val habitsListId = getResourceId(context, "habits_list", "id")
            views.addView(habitsListId, habitItemViews)
            
        } catch (e: Exception) {
            // Skip this habit item if there's an error
        }
    }

    private fun showNextHabit(context: Context, views: RemoteViews, nextHabit: JSONObject, primaryColor: Int) {
        try {
            val habitName = nextHabit.getString("name")
            val timeDisplay = nextHabit.optString("timeDisplay", "")
            
            val nextHabitNameId = getResourceId(context, "next_habit_name", "id")
            val nextHabitTimeId = getResourceId(context, "next_habit_time", "id")
            val nextHabitSectionId = getResourceId(context, "next_habit_section", "id")
            
            views.setTextViewText(nextHabitNameId, "Next: $habitName")
            
            if (timeDisplay.isNotEmpty()) {
                views.setTextViewText(nextHabitTimeId, timeDisplay)
                views.setViewVisibility(nextHabitTimeId, View.VISIBLE)
            } else {
                views.setViewVisibility(nextHabitTimeId, View.GONE)
            }
            
            views.setViewVisibility(nextHabitSectionId, View.VISIBLE)
            
        } catch (e: Exception) {
            val nextHabitSectionId = getResourceId(context, "next_habit_section", "id")
            views.setViewVisibility(nextHabitSectionId, View.GONE)
        }
    }

    private fun showEmptyState(context: Context, views: RemoteViews) {
        val emptyStateId = getResourceId(context, "empty_state", "id")
        val habitsScrollId = getResourceId(context, "habits_scroll", "id")
        views.setViewVisibility(emptyStateId, View.VISIBLE)
        views.setViewVisibility(habitsScrollId, View.GONE)
    }

    private fun showErrorState(context: Context, views: RemoteViews) {
        val emptyStateId = getResourceId(context, "empty_state", "id")
        val habitsScrollId = getResourceId(context, "habits_scroll", "id")
        val headerTitleId = getResourceId(context, "header_title", "id")
        
        views.setViewVisibility(emptyStateId, View.VISIBLE)
        views.setViewVisibility(habitsScrollId, View.GONE)
        views.setTextViewText(headerTitleId, "Habit Timeline (Error)")
    }

    private fun setupClickHandlers(
        context: Context,
        views: RemoteViews,
        widgetId: Int
    ) {
        try {
            // Refresh button
            val refreshIntent = HomeWidgetBackgroundIntent.getBroadcast(
                context,
                android.net.Uri.parse("refresh_widget")
            )
            val refreshButtonId = getResourceId(context, "refresh_button", "id")
            views.setOnClickPendingIntent(refreshButtonId, refreshIntent)
            
            // Add habit button (in empty state)
            val addIntent = Intent(context, Class.forName("${context.packageName}.MainActivity"))
            val addHabitIntent = PendingIntent.getActivity(
                context, 
                1, 
                addIntent, 
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            val addHabitButtonId = getResourceId(context, "add_habit_button", "id")
            views.setOnClickPendingIntent(addHabitButtonId, addHabitIntent)
            
            // Header click to open timeline
            val timelineIntent = Intent(context, Class.forName("${context.packageName}.MainActivity"))
            val timelinePendingIntent = PendingIntent.getActivity(
                context, 
                2, 
                timelineIntent, 
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            val headerTitleId = getResourceId(context, "header_title", "id")
            views.setOnClickPendingIntent(headerTitleId, timelinePendingIntent)
        } catch (e: Exception) {
            // Ignore click handler setup errors
        }
    }

    private fun applyThemeColors(context: Context, views: RemoteViews, themeMode: String, primaryColor: Int) {
        val isDarkMode = themeMode == "dark"
        
        // Set background colors
        val backgroundColor = if (isDarkMode) 0xFF121212.toInt() else 0xFFFFFFFF.toInt()
        val surfaceColor = if (isDarkMode) 0xFF1E1E1E.toInt() else 0xFFF5F5F5.toInt()
        val textPrimaryColor = if (isDarkMode) 0xFFFFFFFF.toInt() else 0xDD000000.toInt()
        val textSecondaryColor = if (isDarkMode) 0xB3FFFFFF.toInt() else 0x99000000.toInt()
        
        try {
            // Apply theme colors (would be better to use dynamic color resources)
            val timelineIconId = getResourceId(context, "timeline_icon", "id")
            val headerTitleId = getResourceId(context, "header_title", "id")
            val headerDateId = getResourceId(context, "header_date", "id")
            
            views.setInt(timelineIconId, "setColorFilter", primaryColor)
            views.setTextColor(headerTitleId, textPrimaryColor)
            views.setTextColor(headerDateId, textSecondaryColor)
        } catch (e: Exception) {
            // Ignore theme application errors
        }
    }

    private fun getStatusColor(status: String): Int {
        return when (status) {
            "Completed" -> 0xFF4CAF50.toInt()
            "Due" -> 0xFFFF9800.toInt()
            "Missed" -> 0xFFF44336.toInt()
            "Upcoming" -> 0xFF2196F3.toInt()
            else -> 0xFF9E9E9E.toInt()
        }
    }

    private fun formatDateForDisplay(dateString: String): String {
        return try {
            val inputFormat = SimpleDateFormat("yyyy-MM-dd", Locale.getDefault())
            val outputFormat = SimpleDateFormat("EEE, MMM d", Locale.getDefault())
            val date = inputFormat.parse(dateString)
            
            val today = Calendar.getInstance()
            val targetDate = Calendar.getInstance()
            targetDate.time = date
            
            when {
                isSameDay(today, targetDate) -> "Today"
                isYesterday(today, targetDate) -> "Yesterday"
                isTomorrow(today, targetDate) -> "Tomorrow"
                else -> outputFormat.format(date)
            }
        } catch (e: Exception) {
            "Today"
        }
    }

    private fun getCurrentDateString(): String {
        val format = SimpleDateFormat("yyyy-MM-dd", Locale.getDefault())
        return format.format(Date())
    }

    private fun isSameDay(cal1: Calendar, cal2: Calendar): Boolean {
        return cal1.get(Calendar.YEAR) == cal2.get(Calendar.YEAR) &&
                cal1.get(Calendar.DAY_OF_YEAR) == cal2.get(Calendar.DAY_OF_YEAR)
    }

    private fun isYesterday(today: Calendar, target: Calendar): Boolean {
        val yesterday = Calendar.getInstance()
        yesterday.time = today.time
        yesterday.add(Calendar.DAY_OF_YEAR, -1)
        return isSameDay(yesterday, target)
    }

    private fun isTomorrow(today: Calendar, target: Calendar): Boolean {
        val tomorrow = Calendar.getInstance()
        tomorrow.time = today.time
        tomorrow.add(Calendar.DAY_OF_YEAR, 1)
        return isSameDay(tomorrow, target)
    }
}