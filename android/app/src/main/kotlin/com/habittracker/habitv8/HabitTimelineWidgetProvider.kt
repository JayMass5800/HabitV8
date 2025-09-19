package com.habittracker.habitv8

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.util.Log
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

open class HabitTimelineWidgetProvider : HomeWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        android.util.Log.d("HabitTimelineWidget", "onUpdate called with ${appWidgetIds.size} widget IDs: ${appWidgetIds.contentToString()}")
        android.util.Log.d("HabitTimelineWidget", "SharedPreferences keys: ${widgetData.all.keys}")
        
        appWidgetIds.forEach { widgetId ->
            android.util.Log.d("HabitTimelineWidget", "Processing widget ID: $widgetId")
            try {
                // Use direct R reference instead of getIdentifier for release builds
                val views = RemoteViews(context.packageName, R.layout.widget_timeline)
                
                // Convert SharedPreferences to Map for compatibility
                val dataMap = widgetData.all
                android.util.Log.d("HabitTimelineWidget", "Data map has ${dataMap.size} entries for widget $widgetId")
                
                // Update widget with current data
                updateWidgetContent(context, views, dataMap)
                
                // Set up click handlers
                setupClickHandlers(context, views, widgetId)
                
                android.util.Log.d("HabitTimelineWidget", "Calling appWidgetManager.updateAppWidget for ID: $widgetId")
                appWidgetManager.updateAppWidget(widgetId, views)
                android.util.Log.d("HabitTimelineWidget", "Widget update completed for ID: $widgetId")
            } catch (e: Exception) {
                android.util.Log.e("HabitTimelineWidget", "Exception updating widget $widgetId", e)
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
                "header_title" -> R.id.header_title
                "habits_list" -> R.id.habits_list
                "next_habit_section" -> R.id.next_habit_section
                "empty_state" -> R.id.empty_state
                "habits_list" -> R.id.habits_list
                "habit_name" -> R.id.habit_name
                "habit_category" -> R.id.habit_category
                "habit_status" -> R.id.habit_status
                "habit_color_indicator" -> R.id.habit_color_indicator
                "habit_time" -> R.id.habit_time
                "complete_button" -> R.id.complete_button
                "edit_button" -> R.id.edit_button
                "next_habit_name" -> R.id.next_habit_name
                "next_habit_time" -> R.id.next_habit_time
                "refresh_button" -> R.id.refresh_button
                "timeline_icon" -> R.id.timeline_icon
                "habits_container" -> R.id.habits_container
                "add_habit_button" -> R.id.add_habit_button
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
            android.util.Log.d("HabitTimelineWidget", "Starting widget content update")
            android.util.Log.d("HabitTimelineWidget", "Widget data keys: ${widgetData.keys}")
            
            // Read individual keys as stored by Flutter - use HomeWidgetPreferences
            val sharedPreferences = context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)
            val habitsJson = sharedPreferences.getString("habits", null) ?: "[]"
            val nextHabitJson = sharedPreferences.getString("nextHabit", null)
            val selectedDate = sharedPreferences.getString("selectedDate", "") ?: ""
            val themeMode = sharedPreferences.getString("themeMode", "light") ?: "light"
            val primaryColor = sharedPreferences.getLong("primaryColor", 0x6366F1L).toInt()
            
            android.util.Log.d("HabitTimelineWidget", "Habits JSON: $habitsJson")
            android.util.Log.d("HabitTimelineWidget", "Selected date: $selectedDate")
            android.util.Log.d("HabitTimelineWidget", "Theme mode: $themeMode")
            android.util.Log.d("HabitTimelineWidget", "Primary color: $primaryColor")
            
            // Format and display date
            val formattedDate = formatDateForDisplay(selectedDate)
            val headerDateId = getResourceId(context, "header_date", "id")
            android.util.Log.d("HabitTimelineWidget", "Formatted date: $formattedDate, headerDateId: $headerDateId")
            views.setTextViewText(headerDateId, formattedDate)
            
            // Apply theme colors
            android.util.Log.d("HabitTimelineWidget", "Applying theme colors")
            applyThemeColors(context, views, themeMode, primaryColor)
            
            // Parse habits array and next habit
            val habitsArray = JSONArray(habitsJson)
            val nextHabitObject = if (nextHabitJson != null) JSONObject(nextHabitJson) else null
            
            android.util.Log.d("HabitTimelineWidget", "Habits array length: ${habitsArray.length()}")
            android.util.Log.d("HabitTimelineWidget", "Has next habit: ${nextHabitObject != null}")
            
            if (habitsArray.length() > 0) {
                android.util.Log.d("HabitTimelineWidget", "Updating habits list with ${habitsArray.length()} habits")
                updateHabitsListFromArray(context, views, habitsArray, nextHabitObject, themeMode, primaryColor)
            } else {
                android.util.Log.d("HabitTimelineWidget", "Showing empty state - no habits in array")
                showEmptyState(context, views, "No habits yet")
            }
            
        } catch (e: Exception) {
            android.util.Log.e("HabitTimelineWidget", "Exception in updateWidgetContent", e)
            // Log error and show fallback state
            showErrorState(context, views)
        }
    }

    private fun updateHabitsListFromArray(
        context: Context,
        views: RemoteViews,
        habitsArray: JSONArray,
        nextHabitObject: JSONObject?,
        themeMode: String,
        primaryColor: Int
    ) {
        try {
            android.util.Log.d("HabitTimelineWidget", "Processing ${habitsArray.length()} habits from array")
            
            // Clear existing habit items
            val habitsListId = getResourceId(context, "habits_list", "id")
            if (habitsListId == 0) {
                android.util.Log.e("HabitTimelineWidget", "Failed to get habits list resource ID")
                showEmptyState(context, views, "Widget error")
                return
            }
            android.util.Log.d("HabitTimelineWidget", "Clearing existing habits from list ID: $habitsListId")
            views.removeAllViews(habitsListId)
            
            // Show next habit if available
            if (nextHabitObject != null) {
                android.util.Log.d("HabitTimelineWidget", "Showing next habit: ${nextHabitObject.optString("name", "Unknown")}")
                showNextHabit(context, views, nextHabitObject, primaryColor)
            } else {
                android.util.Log.d("HabitTimelineWidget", "No next habit to show")
                val nextHabitSectionId = getResourceId(context, "next_habit_section", "id")
                views.setViewVisibility(nextHabitSectionId, View.GONE)
            }
            
            // Show habits or empty state
            if (habitsArray.length() == 0) {
                android.util.Log.d("HabitTimelineWidget", "No habits in array, showing completion message")
                showEmptyState(context, views, "All habits completed!")
            } else {
                android.util.Log.d("HabitTimelineWidget", "Processing ${habitsArray.length()} habits")
                val emptyStateId = getResourceId(context, "empty_state", "id")
                val habitsScrollId = getResourceId(context, "habits_list", "id")
                views.setViewVisibility(emptyStateId, View.GONE)
                views.setViewVisibility(habitsScrollId, View.VISIBLE)
                
                // Add habit items (limit to prevent performance issues)
                val maxHabits = Math.min(habitsArray.length(), 10)
                android.util.Log.d("HabitTimelineWidget", "Adding $maxHabits habit items to widget")
                for (i in 0 until maxHabits) {
                    val habit = habitsArray.getJSONObject(i)
                    android.util.Log.d("HabitTimelineWidget", "Adding habit $i: ${habit.optString("name", "Unknown")}")
                    addHabitItem(context, views, habit, themeMode, primaryColor)
                }
            }
            android.util.Log.d("HabitTimelineWidget", "updateHabitsListFromArray completed successfully")
            
        } catch (e: Exception) {
            android.util.Log.e("HabitTimelineWidget", "Exception in updateHabitsListFromArray", e)
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
            android.util.Log.d("HabitTimelineWidget", "Parsing habits JSON: $habitsJson")
            val habitsArray = JSONArray(habitsJson)
            android.util.Log.d("HabitTimelineWidget", "Parsed ${habitsArray.length()} habits")
            
            // Clear existing habit items
            val habitsListId = getResourceId(context, "habits_list", "id")
            if (habitsListId == 0) {
                android.util.Log.e("HabitTimelineWidget", "Failed to get habits list resource ID")
                showEmptyState(context, views, "Widget error")
                return
            }
            android.util.Log.d("HabitTimelineWidget", "Clearing existing habits from list ID: $habitsListId")
            views.removeAllViews(habitsListId)
            
            // Show next habit if available
            if (nextHabitJson != null) {
                android.util.Log.d("HabitTimelineWidget", "Showing next habit: $nextHabitJson")
                val nextHabit = JSONObject(nextHabitJson)
                showNextHabit(context, views, nextHabit, primaryColor)
            } else {
                android.util.Log.d("HabitTimelineWidget", "No next habit to show")
                val nextHabitSectionId = getResourceId(context, "next_habit_section", "id")
                views.setViewVisibility(nextHabitSectionId, View.GONE)
            }
            
            // Show habits or empty state
            if (habitsArray.length() == 0) {
                android.util.Log.d("HabitTimelineWidget", "No habits in array, showing completion message")
                showEmptyState(context, views, "All habits completed!")
            } else {
                android.util.Log.d("HabitTimelineWidget", "Processing ${habitsArray.length()} habits")
                val emptyStateId = getResourceId(context, "empty_state", "id")
                val habitsScrollId = getResourceId(context, "habits_list", "id")
                views.setViewVisibility(emptyStateId, View.GONE)
                views.setViewVisibility(habitsScrollId, View.VISIBLE)
                
                // Add habit items (limit to prevent performance issues)
                val maxHabits = Math.min(habitsArray.length(), 10)
                android.util.Log.d("HabitTimelineWidget", "Adding $maxHabits habit items to widget")
                for (i in 0 until maxHabits) {
                    val habit = habitsArray.getJSONObject(i)
                    android.util.Log.d("HabitTimelineWidget", "Adding habit $i: ${habit.optString("name", "Unknown")}")
                    addHabitItem(context, views, habit, themeMode, primaryColor)
                }
            }
            android.util.Log.d("HabitTimelineWidget", "updateHabitsList completed successfully")
            
        } catch (e: Exception) {
            android.util.Log.e("HabitTimelineWidget", "Exception in updateHabitsList", e)
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
        if (habitItemLayoutId == 0) {
            Log.e("HabitTimelineWidget", "Failed to get habit item layout resource")
            return
        }
        
        val habitItemViews = RemoteViews(context.packageName, habitItemLayoutId)
        
        try {
            // Set habit details with defensive access
            val habitName = habit.optString("name", "Unnamed Habit")
            val habitCategory = habit.optString("category", "")
            val habitColor = habit.optInt("colorValue", primaryColor)
            val habitId = habit.optString("id", "unknown")
            val isCompleted = habit.optBoolean("isCompleted", false)
            val status = habit.optString("status", "Due")
            val timeDisplay = habit.optString("timeDisplay", "")
            
            // Validate essential data
            if (habitName.isEmpty() || habitId == "unknown") {
                Log.w("HabitTimelineWidget", "Skipping habit with missing essential data")
                return // Skip this habit if essential data is missing
            }
            
            // Update habit item views
            val habitNameId = getResourceId(context, "habit_name", "id")
            val habitCategoryId = getResourceId(context, "habit_category", "id")
            val habitStatusId = getResourceId(context, "habit_status", "id")
            val habitColorIndicatorId = getResourceId(context, "habit_color_indicator", "id")
            val habitTimeId = getResourceId(context, "habit_time", "id")
            val completeButtonId = getResourceId(context, "complete_button", "id")
            val editButtonId = getResourceId(context, "edit_button", "id")
            
            // Validate all resource IDs before using them
            if (habitNameId == 0 || habitCategoryId == 0 || habitStatusId == 0 || 
                habitColorIndicatorId == 0 || habitTimeId == 0 || completeButtonId == 0 || editButtonId == 0) {
                Log.e("HabitTimelineWidget", "Failed to get required resource IDs")
                return
            }
            
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
                val intent = Intent(context, MainActivity::class.java)
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

    private fun showEmptyState(context: Context, views: RemoteViews, message: String = "All habits completed!") {
        val emptyStateId = getResourceId(context, "empty_state", "id")
        val habitsScrollId = getResourceId(context, "habits_list", "id")
        views.setViewVisibility(emptyStateId, View.VISIBLE)
        views.setViewVisibility(habitsScrollId, View.GONE)
        // Note: Timeline widget uses fixed text in layout - message parameter is for consistency
    }

    private fun showErrorState(context: Context, views: RemoteViews) {
        val emptyStateId = getResourceId(context, "empty_state", "id")
        val habitsScrollId = getResourceId(context, "habits_list", "id")
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
            
            // Add habit button (in empty state) - navigate to create habit page
            val addIntent = Intent(context, MainActivity::class.java)
            addIntent.putExtra("widget_action", "create_habit")
            val addHabitPendingIntent = PendingIntent.getActivity(
                context, 
                1, 
                addIntent, 
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            val addHabitButtonId = getResourceId(context, "add_habit_button", "id")
            views.setOnClickPendingIntent(addHabitButtonId, addHabitPendingIntent)
            
            // Header click to open timeline
            val timelineIntent = Intent(context, MainActivity::class.java)
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
        try {
            val isDarkMode = themeMode == "dark"
            
            // Modern theme colors with better contrast
            val backgroundColor = if (isDarkMode) 0xFF0F0F0F.toInt() else 0xFFFAFAFA.toInt()
            val surfaceColor = if (isDarkMode) 0xFF1A1A1A.toInt() else 0xFFFFFFFF.toInt()
            val textPrimaryColor = if (isDarkMode) 0xFFFFFFFF.toInt() else 0xDE000000.toInt()
            val textSecondaryColor = if (isDarkMode) 0xB3FFFFFF.toInt() else 0x8A000000.toInt()
            
            // Apply theme colors with comprehensive coverage
            val timelineIconId = getResourceId(context, "timeline_icon", "id")
            val headerTitleId = getResourceId(context, "header_title", "id")
            val headerDateId = getResourceId(context, "header_date", "id")
            val refreshButtonId = getResourceId(context, "refresh_button", "id")
            val headerLayoutId = getResourceId(context, "header_layout", "id")
            val habitsContainerId = getResourceId(context, "habits_container", "id")
            
            // Apply dynamic primary color to header background - this makes the biggest visual impact
            if (headerLayoutId != 0) {
                views.setInt(headerLayoutId, "setBackgroundColor", primaryColor)
            }
            
            // Header elements use white text for contrast against colored background
            if (timelineIconId != 0) views.setInt(timelineIconId, "setColorFilter", 0xFFFFFFFF.toInt())
            if (headerTitleId != 0) views.setTextColor(headerTitleId, 0xFFFFFFFF.toInt())
            if (headerDateId != 0) views.setTextColor(headerDateId, 0xFFFFFFFF.toInt())
            if (refreshButtonId != 0) views.setInt(refreshButtonId, "setColorFilter", 0xFFFFFFFF.toInt())
            
            // Apply theme-appropriate background to main content areas
            if (habitsContainerId != 0) {
                views.setInt(habitsContainerId, "setBackgroundColor", backgroundColor)
            }
            
            android.util.Log.d("HabitTimelineWidget", "Enhanced theme colors applied - isDark: $isDarkMode, primaryColor: ${Integer.toHexString(primaryColor)}")
            
        } catch (e: Exception) {
            android.util.Log.e("HabitTimelineWidget", "Error applying enhanced theme colors", e)
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
