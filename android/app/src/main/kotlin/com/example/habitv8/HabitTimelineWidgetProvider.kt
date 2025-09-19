package com.example.habitv8

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
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
        widgetData: Map<String, Any?>
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.widget_timeline)
            
            // Update widget with current data
            updateWidgetContent(context, views, widgetData)
            
            // Set up click handlers
            setupClickHandlers(context, views, widgetId)
            
            appWidgetManager.updateAppWidget(widgetId, views)
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
            views.setTextViewText(R.id.header_date, formattedDate)
            
            // Update theme colors
            val themeMode = widgetData["themeMode"] as? String ?: "light"
            val primaryColorValue = widgetData["primaryColor"] as? Int ?: 0x6366F1
            applyThemeColors(views, themeMode, primaryColorValue)
            
            // Update habits list
            val habitsJson = widgetData["habits"] as? String
            val nextHabitJson = widgetData["nextHabit"] as? String
            
            if (habitsJson != null) {
                updateHabitsList(context, views, habitsJson, nextHabitJson, themeMode, primaryColorValue)
            } else {
                showEmptyState(views)
            }
            
        } catch (e: Exception) {
            // Log error and show fallback state
            showErrorState(views)
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
            views.removeAllViews(R.id.habits_list)
            
            // Show next habit if available
            if (nextHabitJson != null) {
                val nextHabit = JSONObject(nextHabitJson)
                showNextHabit(views, nextHabit, primaryColor)
            } else {
                views.setViewVisibility(R.id.next_habit_section, View.GONE)
            }
            
            // Show habits or empty state
            if (habitsArray.length() == 0) {
                showEmptyState(views)
            } else {
                views.setViewVisibility(R.id.empty_state, View.GONE)
                views.setViewVisibility(R.id.habits_scroll, View.VISIBLE)
                
                // Add habit items (limit to prevent performance issues)
                val maxHabits = Math.min(habitsArray.length(), 10)
                for (i in 0 until maxHabits) {
                    val habit = habitsArray.getJSONObject(i)
                    addHabitItem(context, views, habit, themeMode, primaryColor)
                }
            }
            
        } catch (e: Exception) {
            showErrorState(views)
        }
    }

    private fun addHabitItem(
        context: Context,
        views: RemoteViews,
        habit: JSONObject,
        themeMode: String,
        primaryColor: Int
    ) {
        val habitItemViews = RemoteViews(context.packageName, R.layout.widget_habit_item)
        
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
            habitItemViews.setTextViewText(R.id.habit_name, habitName)
            habitItemViews.setTextViewText(R.id.habit_category, habitCategory)
            habitItemViews.setTextViewText(R.id.habit_status, status)
            
            // Set habit color
            habitItemViews.setInt(R.id.habit_color_indicator, "setBackgroundColor", habitColor)
            
            // Show/hide time if available
            if (timeDisplay.isNotEmpty()) {
                habitItemViews.setTextViewText(R.id.habit_time, timeDisplay)
                habitItemViews.setViewVisibility(R.id.habit_time, View.VISIBLE)
            } else {
                habitItemViews.setViewVisibility(R.id.habit_time, View.GONE)
            }
            
            // Set status color
            val statusColor = getStatusColor(status)
            habitItemViews.setInt(R.id.habit_status, "setBackgroundColor", statusColor)
            
            // Show/hide complete button based on status
            val canComplete = status == "Due" && !isCompleted
            if (canComplete) {
                habitItemViews.setViewVisibility(R.id.complete_button, View.VISIBLE)
                
                // Set up complete action
                val completeIntent = HomeWidgetBackgroundIntent.getBroadcast(
                    context,
                    "complete_habit",
                    mapOf("habitId" to habitId)
                )
                habitItemViews.setOnClickPendingIntent(R.id.complete_button, completeIntent)
            } else {
                habitItemViews.setViewVisibility(R.id.complete_button, View.GONE)
            }
            
            // Set up edit action
            val editIntent = HomeWidgetLaunchIntent.getActivity(
                context,
                MainActivity::class.java,
                mapOf("route" to "/edit-habit/$habitId")
            )
            habitItemViews.setOnClickPendingIntent(R.id.edit_button, editIntent)
            
            // Apply strikethrough if completed
            if (isCompleted) {
                habitItemViews.setInt(R.id.habit_name, "setPaintFlags", 
                    android.graphics.Paint.STRIKE_THRU_TEXT_FLAG)
            }
            
            // Add the habit item to the list
            views.addView(R.id.habits_list, habitItemViews)
            
        } catch (e: Exception) {
            // Skip this habit item if there's an error
        }
    }

    private fun showNextHabit(views: RemoteViews, nextHabit: JSONObject, primaryColor: Int) {
        try {
            val habitName = nextHabit.getString("name")
            val timeDisplay = nextHabit.optString("timeDisplay", "")
            
            views.setTextViewText(R.id.next_habit_name, "Next: $habitName")
            
            if (timeDisplay.isNotEmpty()) {
                views.setTextViewText(R.id.next_habit_time, timeDisplay)
                views.setViewVisibility(R.id.next_habit_time, View.VISIBLE)
            } else {
                views.setViewVisibility(R.id.next_habit_time, View.GONE)
            }
            
            views.setViewVisibility(R.id.next_habit_section, View.VISIBLE)
            
        } catch (e: Exception) {
            views.setViewVisibility(R.id.next_habit_section, View.GONE)
        }
    }

    private fun showEmptyState(views: RemoteViews) {
        views.setViewVisibility(R.id.empty_state, View.VISIBLE)
        views.setViewVisibility(R.id.habits_scroll, View.GONE)
    }

    private fun showErrorState(views: RemoteViews) {
        views.setViewVisibility(R.id.empty_state, View.VISIBLE)
        views.setViewVisibility(R.id.habits_scroll, View.GONE)
        views.setTextViewText(R.id.header_title, "Habit Timeline (Error)")
    }

    private fun setupClickHandlers(
        context: Context,
        views: RemoteViews,
        widgetId: Int
    ) {
        // Refresh button
        val refreshIntent = HomeWidgetBackgroundIntent.getBroadcast(
            context,
            "refresh_widget"
        )
        views.setOnClickPendingIntent(R.id.refresh_button, refreshIntent)
        
        // Add habit button (in empty state)
        val addHabitIntent = HomeWidgetLaunchIntent.getActivity(
            context,
            MainActivity::class.java,
            mapOf("route" to "/create-habit")
        )
        views.setOnClickPendingIntent(R.id.add_habit_button, addHabitIntent)
        
        // Header click to open timeline
        val timelineIntent = HomeWidgetLaunchIntent.getActivity(
            context,
            MainActivity::class.java,
            mapOf("route" to "/timeline")
        )
        views.setOnClickPendingIntent(R.id.header_title, timelineIntent)
    }

    private fun applyThemeColors(views: RemoteViews, themeMode: String, primaryColor: Int) {
        val isDarkMode = themeMode == "dark"
        
        // Set background colors
        val backgroundColor = if (isDarkMode) 0xFF121212.toInt() else 0xFFFFFFFF.toInt()
        val surfaceColor = if (isDarkMode) 0xFF1E1E1E.toInt() else 0xFFF5F5F5.toInt()
        val textPrimaryColor = if (isDarkMode) 0xFFFFFFFF.toInt() else 0xDD000000.toInt()
        val textSecondaryColor = if (isDarkMode) 0xB3FFFFFF.toInt() else 0x99000000.toInt()
        
        // Apply theme colors (would be better to use dynamic color resources)
        views.setInt(R.id.timeline_icon, "setColorFilter", primaryColor)
        views.setTextColor(R.id.header_title, textPrimaryColor)
        views.setTextColor(R.id.header_date, textSecondaryColor)
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