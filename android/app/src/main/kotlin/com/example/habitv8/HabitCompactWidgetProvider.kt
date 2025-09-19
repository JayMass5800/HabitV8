package com.example.habitv8

import android.appwidget.AppWidgetManager
import android.content.Context
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
        widgetData: Map<String, Any?>
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.widget_compact)
            
            // Update widget with current data
            updateCompactWidgetContent(context, views, widgetData)
            
            // Set up click handlers
            setupCompactClickHandlers(context, views, widgetId)
            
            appWidgetManager.updateAppWidget(widgetId, views)
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
            val primaryColorValue = widgetData["primaryColor"] as? Int ?: 0x6366F1
            applyCompactThemeColors(views, themeMode, primaryColorValue)
            
            // Update habits list
            val habitsJson = widgetData["habits"] as? String
            
            if (habitsJson != null) {
                updateCompactHabitsList(context, views, habitsJson, themeMode, primaryColorValue)
            } else {
                showCompactEmptyState(views)
            }
            
        } catch (e: Exception) {
            showCompactErrorState(views)
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
            views.removeAllViews(R.id.compact_habits_list)
            
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
                showCompactEmptyState(views)
            } else {
                views.setViewVisibility(R.id.compact_empty_state, View.GONE)
                
                // Add compact habit items
                dueHabits.forEach { habit ->
                    addCompactHabitItem(context, views, habit, themeMode, primaryColor)
                }
                
                // Show "more habits" indicator if there are additional habits
                val remainingHabits = habitsArray.length() - dueHabits.size
                if (remainingHabits > 0) {
                    views.setTextViewText(R.id.more_habits_indicator, "+$remainingHabits more habits")
                    views.setViewVisibility(R.id.more_habits_indicator, View.VISIBLE)
                } else {
                    views.setViewVisibility(R.id.more_habits_indicator, View.GONE)
                }
            }
            
        } catch (e: Exception) {
            showCompactErrorState(views)
        }
    }

    private fun addCompactHabitItem(
        context: Context,
        views: RemoteViews,
        habit: JSONObject,
        themeMode: String,
        primaryColor: Int
    ) {
        val habitItemViews = RemoteViews(context.packageName, R.layout.widget_compact_habit_item)
        
        try {
            // Set habit details
            val habitName = habit.getString("name")
            val habitColor = habit.optInt("colorValue", primaryColor)
            val habitId = habit.getString("id")
            val timeDisplay = habit.optString("timeDisplay", "")
            
            // Update compact habit item views
            habitItemViews.setTextViewText(R.id.compact_habit_name, habitName)
            
            // Set habit color
            habitItemViews.setInt(R.id.compact_habit_color_indicator, "setBackgroundColor", habitColor)
            
            // Show/hide time if available
            if (timeDisplay.isNotEmpty()) {
                habitItemViews.setTextViewText(R.id.compact_habit_time, timeDisplay)
                habitItemViews.setViewVisibility(R.id.compact_habit_time, View.VISIBLE)
            } else {
                habitItemViews.setViewVisibility(R.id.compact_habit_time, View.GONE)
            }
            
            // Set up complete action
            val completeIntent = HomeWidgetBackgroundIntent.getBroadcast(
                context,
                "complete_habit",
                mapOf("habitId" to habitId)
            )
            habitItemViews.setOnClickPendingIntent(R.id.compact_complete_button, completeIntent)
            
            // Add the habit item to the list
            views.addView(R.id.compact_habits_list, habitItemViews)
            
        } catch (e: Exception) {
            // Skip this habit item if there's an error
        }
    }

    private fun showCompactEmptyState(views: RemoteViews) {
        views.setViewVisibility(R.id.compact_empty_state, View.VISIBLE)
        views.setViewVisibility(R.id.more_habits_indicator, View.GONE)
    }

    private fun showCompactErrorState(views: RemoteViews) {
        views.setViewVisibility(R.id.compact_empty_state, View.VISIBLE)
        views.setTextViewText(R.id.compact_empty_state, "Error loading habits")
        views.setViewVisibility(R.id.more_habits_indicator, View.GONE)
    }

    private fun setupCompactClickHandlers(
        context: Context,
        views: RemoteViews,
        widgetId: Int
    ) {
        // Open app button
        val openAppIntent = HomeWidgetLaunchIntent.getActivity(
            context,
            MainActivity::class.java,
            mapOf("route" to "/timeline")
        )
        views.setOnClickPendingIntent(R.id.open_app_button, openAppIntent)
        
        // Header click to open timeline
        views.setOnClickPendingIntent(R.id.compact_habits_list, openAppIntent)
    }

    private fun applyCompactThemeColors(views: RemoteViews, themeMode: String, primaryColor: Int) {
        val isDarkMode = themeMode == "dark"
        
        // Set text colors
        val textPrimaryColor = if (isDarkMode) 0xFFFFFFFF.toInt() else 0xDD000000.toInt()
        val textSecondaryColor = if (isDarkMode) 0xB3FFFFFF.toInt() else 0x99000000.toInt()
        
        // Apply theme colors
        views.setTextColor(R.id.compact_empty_state, textSecondaryColor)
        views.setTextColor(R.id.more_habits_indicator, textSecondaryColor)
    }
}