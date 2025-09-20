package com.habittracker.habitv8

import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import android.widget.RemoteViewsService
import android.util.Log
import es.antonborri.home_widget.HomeWidgetPlugin
import org.json.JSONArray
import org.json.JSONException
import org.json.JSONObject

class HabitCompactWidgetService : RemoteViewsService() {
    override fun onGetViewFactory(intent: Intent): RemoteViewsFactory {
        return HabitCompactRemoteViewsFactory(this.applicationContext, intent)
    }
}

class HabitCompactRemoteViewsFactory(
    private val context: Context,
    intent: Intent
) : RemoteViewsService.RemoteViewsFactory {

    private var habits = mutableListOf<Map<String, Any>>()
    private var themeMode = ""
    private var primaryColor = 0
    private var textColor = 0
    private var backgroundColor = 0
    private var isDarkMode = false
    private val appWidgetId = intent.getIntExtra(
        android.appwidget.AppWidgetManager.EXTRA_APPWIDGET_ID,
        android.appwidget.AppWidgetManager.INVALID_APPWIDGET_ID
    )
    private val themeModeExtra: String? = intent.getStringExtra("themeMode")
    private val primaryColorExtra: Int = intent.getIntExtra("primaryColor", -1)

    override fun onCreate() {
        Log.d("HabitCompactWidget", "HabitCompactRemoteViewsFactory onCreate called")
        loadThemeData()
        loadHabitData()
    }

    override fun getCount(): Int {
        val count = habits.size.coerceAtMost(3)
        Log.d("HabitCompactWidget", "getCount called, returning: $count")
        return count
    }

    override fun getViewAt(position: Int): RemoteViews? {
        Log.d("HabitCompactWidget", "getViewAt called for position: $position")

        if (position >= habits.size) {
            Log.e("HabitCompactWidget", "Position $position out of bounds")
            return getLoadingView()
        }

        val habit = habits[position]
        val remoteViews = RemoteViews(context.packageName, R.layout.widget_compact_habit_item)

        try {
            // Extract habit data (align keys with Dart payload)
            val habitId = (habit["id"] as? String) ?: (habit["habit_id"] as? String) ?: ""
            val habitName = habit["name"] as? String ?: "Unknown Habit"
            val scheduledTime = habit["timeDisplay"] as? String
                ?: habit["scheduledTime"] as? String ?: ""
            val isCompleted = (habit["isCompleted"] as? Boolean) ?: false
            val colorValue = (habit["colorValue"] as? Number)?.toInt()
            val colorHex = habit["colorHex"] as? String ?: habit["color"] as? String
            val habitStatus = habit["status"] as? String ?: ""

            // Resolve color from value or hex
            val color = when {
                colorValue != null -> colorValue
                !colorHex.isNullOrBlank() -> try { android.graphics.Color.parseColor(colorHex) } catch (_: Exception) { 0xFF4CAF50.toInt() }
                else -> 0xFF4CAF50.toInt()
            }

            // Set habit name
            remoteViews.setTextViewText(R.id.compact_habit_name, habitName)
            remoteViews.setTextColor(R.id.compact_habit_name, textColor)

            // Set time text (hide if empty)
            if (scheduledTime.isNotEmpty()) {
                remoteViews.setTextViewText(R.id.compact_habit_time, scheduledTime)
                remoteViews.setTextColor(R.id.compact_habit_time, textColor)
                remoteViews.setViewVisibility(R.id.compact_habit_time, android.view.View.VISIBLE)
            } else {
                remoteViews.setViewVisibility(R.id.compact_habit_time, android.view.View.GONE)
            }

            // Set color indicator
            remoteViews.setInt(R.id.compact_habit_color_indicator, "setBackgroundColor", color)

            // Set completion button appearance (ImageView drawable + tint)
            if (isCompleted) {
                remoteViews.setImageViewResource(R.id.compact_complete_button, R.drawable.ic_check)
                remoteViews.setInt(R.id.compact_complete_button, "setColorFilter", color)
            } else {
                remoteViews.setImageViewResource(R.id.compact_complete_button, R.drawable.ic_check_circle_outline)
                remoteViews.setInt(R.id.compact_complete_button, "setColorFilter", textColor)
            }

            // Set rounded, semi-transparent background based on theme
            val bgRes = if (isDarkMode) R.drawable.widget_compact_habit_item_bg_dark else R.drawable.widget_compact_habit_item_bg_light
            remoteViews.setInt(R.id.compact_habit_item_container, "setBackgroundResource", bgRes)

            // Set click intent for completion toggle
            val completionIntent = Intent().apply {
                putExtra("habit_id", habitId)
                putExtra("action", "toggle_completion")
                putExtra(android.appwidget.AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
            }
            remoteViews.setOnClickFillInIntent(R.id.compact_complete_button, completionIntent)

            // Set habit name click intent for details
            val detailIntent = Intent().apply {
                putExtra("habit_id", habitId)
                putExtra("action", "open_habit")
                putExtra(android.appwidget.AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
            }
            remoteViews.setOnClickFillInIntent(R.id.compact_habit_name, detailIntent)
            
        } catch (e: Exception) {
            Log.e("HabitCompactWidget", "Error creating view for habit at position $position", e)
        }

        Log.d("HabitCompactWidget", "Created view for habit at position $position")
        return remoteViews
    }

    override fun getLoadingView(): RemoteViews? {
        val loadingView = RemoteViews(context.packageName, R.layout.widget_compact_habit_item)
        loadingView.setTextViewText(R.id.compact_habit_name, "Loading...")
        loadingView.setTextColor(R.id.compact_habit_name, textColor)
        return loadingView
    }

    override fun getViewTypeCount(): Int = 1

    override fun getItemId(position: Int): Long = position.toLong()

    override fun hasStableIds(): Boolean = true

    override fun onDataSetChanged() {
        Log.d("HabitCompactWidget", "onDataSetChanged called")
        loadThemeData()
        loadHabitData()
    }

    override fun onDestroy() {}

    private fun loadHabitData() {
        try {
            val prefs = context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)
            // HomeWidget writes string values; habits is JSON string or may be absent
            val habitsJson = prefs.getString("habits", null)

            if (habitsJson.isNullOrBlank() || habitsJson == "[]") {
                Log.d("HabitCompactWidget", "No habits data found or empty array. Available keys: ${prefs.all.keys}")
                habits = mutableListOf()
                return
            }

            Log.d("HabitCompactWidget", "Raw habits JSON length: ${habitsJson.length}")
            val habitsArray = JSONArray(habitsJson)
            Log.d("HabitCompactWidget", "Parsed habits array with ${habitsArray.length()} items")

            val temp = mutableListOf<Map<String, Any>>()
            for (i in 0 until habitsArray.length()) {
                try {
                    val habitObj = habitsArray.getJSONObject(i)
                    val habitMap = mutableMapOf<String, Any>()
                    val habitKeys = habitObj.keys()
                    while (habitKeys.hasNext()) {
                        val key = habitKeys.next()
                        val value = habitObj.get(key)
                        habitMap[key] = value
                    }
                    temp.add(habitMap)
                } catch (e: Exception) {
                    Log.e("HabitCompactWidget", "Error processing habit at index $i", e)
                }
            }
            habits = temp
            Log.d("HabitCompactWidget", "Final habits list size: ${habits.size}")
        } catch (e: Exception) {
            Log.e("HabitCompactWidget", "Error loading habit data", e)
            habits = mutableListOf()
        }
    }

    private fun loadThemeData() {
        Log.d("HabitCompactWidget", "Loading theme data")
        
        try {
            val prefs = context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)
            val flutterPrefs = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)

            // Read theme mode with robust fallbacks (prefer extras from provider → HomeWidget → Flutter prefs → system)
            var mode = themeModeExtra
                ?: prefs.getString("themeMode", null)
                ?: prefs.getString("home_widget.double.themeMode", null)
                ?: flutterPrefs.getString("flutter.theme_mode", null)
                ?: flutterPrefs.getString("theme_mode", null)

            if (mode == null || mode == "system") {
                val systemNight = context.resources.configuration.uiMode and android.content.res.Configuration.UI_MODE_NIGHT_MASK
                mode = when (systemNight) {
                    android.content.res.Configuration.UI_MODE_NIGHT_YES -> "dark"
                    android.content.res.Configuration.UI_MODE_NIGHT_NO -> "light"
                    else -> "light"
                }
            }
            themeMode = mode
            isDarkMode = themeMode.equals("dark", true)

            // Primary color with integer/float fallbacks; prefer extras from provider
            primaryColor = when {
                primaryColorExtra != -1 -> primaryColorExtra
                prefs.contains("primaryColor") -> prefs.getInt("primaryColor", 0xFF2196F3.toInt())
                prefs.contains("home_widget.double.primaryColor") -> {
                    try { prefs.getFloat("home_widget.double.primaryColor", 0xFF2196F3.toFloat()).toInt() } catch (_: Exception) { 0xFF2196F3.toInt() }
                }
                flutterPrefs.contains("flutter.primary_color") -> flutterPrefs.getInt("flutter.primary_color", 0xFF2196F3.toInt())
                flutterPrefs.contains("primary_color") -> flutterPrefs.getInt("primary_color", 0xFF2196F3.toInt())
                prefs.contains("flutter.primary_color") -> prefs.getInt("flutter.primary_color", 0xFF2196F3.toInt())
                prefs.contains("flutter.primaryColor") -> prefs.getInt("flutter.primaryColor", 0xFF2196F3.toInt())
                else -> 0xFF2196F3.toInt()
            }

            textColor = if (isDarkMode) 0xFFFFFFFF.toInt() else 0xFF000000.toInt()
            backgroundColor = if (isDarkMode) 0xFF121212.toInt() else 0xFFFFFFFF.toInt()

            Log.d("HabitCompactWidget", "Theme loaded - mode: $themeMode, text: ${Integer.toHexString(textColor)}, bg: ${Integer.toHexString(backgroundColor)}, primary: ${Integer.toHexString(primaryColor)}")
        } catch (e: Exception) {
            Log.e("HabitCompactWidget", "Error loading theme data", e)
            isDarkMode = false
            textColor = 0xFF000000.toInt()
            backgroundColor = 0xFFFFFFFF.toInt()
            primaryColor = 0xFF2196F3.toInt()
        }
    }
}