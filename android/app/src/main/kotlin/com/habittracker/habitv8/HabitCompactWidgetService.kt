package com.habittracker.habitv8package com.habittracker.habitv8package com.habittracker.habitv8



import android.content.Context

import android.content.Intent

import android.widget.RemoteViewsimport android.content.Contextimport android.content.Context

import android.widget.RemoteViewsService

import android.util.Logimport android.content.Intentimport android.content.Intent

import com.habittracker.habitv8.R

import com.google.gson.Gsonimport android.widget.RemoteViewsimport android.widget.RemoteViews

import com.google.gson.reflect.TypeToken

import android.widget.RemoteViewsServiceimport android.widget.RemoteViewsService

class HabitCompactWidgetService : RemoteViewsService() {

    override fun onGetViewFactory(intent: Intent): RemoteViewsFactory {import android.util.Logimport android.util.Log

        return HabitCompactRemoteViewsFactory(applicationContext, intent)

    }import com.habittracker.habitv8.Rimport com.habittracker.habitv8.R

}



class HabitCompactRemoteViewsFactory(

    private val context: Context,class HabitCompactWidgetService : RemoteViewsService() {class HabitCompactWidgetService : RemoteViewsService() {

    private val intent: Intent

) : RemoteViewsService.RemoteViewsFactory {    override fun onGetViewFactory(intent: Intent): RemoteViewsFactory {    override fun onGetViewFactory(intent: Intent): RemoteViewsFactory {



    private var habits: List<Map<String, Any>> = emptyList()        return HabitCompactRemoteViewsFactory(this.applicationContext, intent)        return HabitCompactRemoteViewsFactory(this.applicationContext, intent)

    private val appWidgetId: Int = intent.getIntExtra(

        "appWidgetId",    }    }

        android.appwidget.AppWidgetManager.INVALID_APPWIDGET_ID

    )}}



    override fun onCreate() {

        Log.d("CompactWidget", "RemoteViewsFactory onCreate")

        loadHabitData()class HabitCompactRemoteViewsFactory(class HabitCompactRemoteViewsFactory(

    }

    private val context: Context,    private val context: Context,

    override fun getCount(): Int {

        val count = habits.size    intent: Intent    intent: Intent

        Log.d("CompactWidget", "getCount: $count")

        return count) : RemoteViewsService.RemoteViewsFactory {) : RemoteViewsService.RemoteViewsFactory {

    }



    override fun getViewAt(position: Int): RemoteViews? {

        Log.d("CompactWidget", "getViewAt position: $position")    private var habits: List<Map<String, Any>> = emptyList()    private var habits: List<Map<String, Any>> = emptyList()

        

        if (position >= habits.size) {    private val appWidgetId: Int = intent.getIntExtra(    private val appWidgetId: Int = intent.getIntExtra(

            Log.w("CompactWidget", "Position $position >= habits size ${habits.size}")

            return getLoadingView()        android.appwidget.AppWidgetManager.EXTRA_APPWIDGET_ID,        android.appwidget.AppWidgetManager.EXTRA_APPWIDGET_ID,

        }

        android.appwidget.AppWidgetManager.INVALID_APPWIDGET_ID        android.appwidget.AppWidgetManager.INVALID_APPWIDGET_ID

        try {

            val habit = habits[position]    )    )

            

            val remoteViews = RemoteViews(context.packageName, R.layout.widget_habit_item)

            

            // Extract habit data    override fun onCreate() {    override fun onCreate() {

            val habitName = habit["name"] as? String ?: "Unknown Habit"

            val scheduledTime = habit["scheduledTime"] as? String ?: "No time set"        Log.d("HabitCompactService", "RemoteViewsFactory onCreate called")        Log.d("HabitCompactService", "RemoteViewsFactory onCreate called")

            val isCompleted = habit["isCompleted"] as? Boolean ?: false

            val colorHex = habit["colorHex"] as? String ?: "#4CAF50"        loadHabitData()        loadHabitData()

            

            // Parse color    }    }

            val color = try {

                android.graphics.Color.parseColor(colorHex)

            } catch (e: Exception) {

                android.graphics.Color.parseColor("#4CAF50")    override fun onDestroy() {    override fun onDestroy() {

            }

                    habits = emptyList()        habits = emptyList()

            // Create display name

            val displayName = if (habitName.length > 20) {    }    }

                habitName.take(17) + "..."

            } else {

                habitName

            }    override fun getCount(): Int {    override fun getCount(): Int {

            

            // Set text content        // Limit compact widget to show max 5 habits for better UX        // Limit compact widget to show max 5 habits for better UX

            remoteViews.setTextViewText(R.id.widget_habit_name, displayName)

            remoteViews.setTextViewText(R.id.widget_habit_time, scheduledTime)        val count = minOf(habits.size, 5)        val count = minOf(habits.size, 5)

            

            // Set visual completion state        Log.d("HabitCompactService", "getCount returning: $count habits (${habits.size} total)")        Log.d("HabitCompactService", "getCount returning: $count habits (${habits.size} total)")

            if (isCompleted) {

                // Set completed visual state        return count        return count

                remoteViews.setInt(R.id.widget_habit_name, "setBackgroundResource", R.drawable.widget_habit_item_completed_background)

                remoteViews.setTextColor(R.id.widget_habit_name, android.graphics.Color.WHITE)    }    }

                remoteViews.setTextColor(R.id.widget_habit_time, android.graphics.Color.WHITE)

                // Add checkmark or completion indicator

                remoteViews.setTextViewText(R.id.widget_habit_name, "$displayName ✓")

            } else {    override fun getViewAt(position: Int): RemoteViews {    override fun getViewAt(position: Int): RemoteViews {

                // Set normal visual state

                remoteViews.setInt(R.id.widget_habit_name, "setBackgroundColor", color)        Log.d("HabitCompactService", "getViewAt position: $position")        Log.d("HabitCompactService", "getViewAt position: $position")

                remoteViews.setTextColor(R.id.widget_habit_name, android.graphics.Color.WHITE)

                remoteViews.setTextColor(R.id.widget_habit_time, android.graphics.Color.GRAY)                

            }

                    if (position >= habits.size || position >= 5) {        if (position >= habits.size || position >= 5) {

            // Set up click intent for navigation to habit details

            val fillInIntent = Intent()            Log.w("HabitCompactService", "Position $position out of bounds")            Log.w("HabitCompactService", "Position $position out of bounds")

            fillInIntent.putExtra("action", "open_habit_detail")

            fillInIntent.putExtra("habitId", habit["id"] as? String ?: "")            return getLoadingView() ?: RemoteViews(context.packageName, R.layout.widget_compact_habit_item)            return getLoadingView() ?: RemoteViews(context.packageName, R.layout.widget_compact_habit_item)

            fillInIntent.putExtra("habitName", habitName)

                    }        }

            // Create edit intent for the edit button

            val habitDetailIntent = Intent()

            habitDetailIntent.putExtra("action", "edit_habit")

            habitDetailIntent.putExtra("habitId", habit["id"] as? String ?: "")        val habit = habits[position]        val habit = habits[position]

            

            Log.d("CompactWidget", "Setting up click for habit: $habitName")        val remoteViews = RemoteViews(context.packageName, R.layout.widget_compact_habit_item)        val remoteViews = RemoteViews(context.packageName, R.layout.widget_compact_habit_item)

            

            // Set click action for the entire item

            remoteViews.setOnClickFillInIntent(R.id.widget_habit_item, fillInIntent)

                    try {        try {

            // Set click action for edit button if it exists

            try {            // Set habit data            // Set habit data

                remoteViews.setOnClickFillInIntent(R.id.widget_edit_button, habitDetailIntent)

            } catch (e: Exception) {            val habitName = habit["name"] as? String ?: "Unknown Habit"            val habitName = habit["name"] as? String ?: "Unknown Habit"

                Log.w("CompactWidget", "Edit button not found in layout: ${e.message}")

            }            val scheduledTime = habit["scheduledTime"] as? String ?: ""            val scheduledTime = habit["scheduledTime"] as? String ?: ""

            

            return remoteViews            val isCompleted = habit["isCompleted"] as? Boolean ?: false            val isCompleted = habit["isCompleted"] as? Boolean ?: false

            

        } catch (e: Exception) {            val colorHex = habit["colorHex"] as? String ?: "#4CAF50"            val colorHex = habit["colorHex"] as? String ?: "#4CAF50"

            Log.e("CompactWidget", "Error creating view at position $position: ${e.message}")

            return getLoadingView()                        

        }

    }            // Parse color safely            // Parse color safely



    override fun getLoadingView(): RemoteViews {            val habitColor = try {            val habitColor = try {

        val remoteViews = RemoteViews(context.packageName, R.layout.widget_habit_item)

        remoteViews.setTextViewText(R.id.widget_habit_name, "Loading...")                android.graphics.Color.parseColor(colorHex)                android.graphics.Color.parseColor(colorHex)

        return remoteViews

    }            } catch (e: Exception) {            } catch (e: Exception) {



    override fun getViewTypeCount(): Int = 1                android.graphics.Color.parseColor("#4CAF50") // Fallback green                android.graphics.Color.parseColor("#4CAF50") // Fallback green



    override fun getItemId(position: Int): Long = position.toLong()            }            }



    override fun hasStableIds(): Boolean = true



    override fun onDataSetChanged() {            // Set habit name - truncate for compact display            // Set habit name - truncate for compact display

        loadHabitData()

    }            val displayName = if (habitName.length > 20) "${habitName.take(17)}..." else habitName            val displayName = if (habitName.length > 20) "${habitName.take(17)}..." else habitName



    override fun onDestroy() {            remoteViews.setTextViewText(R.id.compact_habit_name, displayName)            remoteViews.setTextViewText(R.id.compact_habit_name, displayName)

        habits = emptyList()

    }                        



    private fun loadHabitData() {            // Set scheduled time if available            // Set scheduled time if available

        try {

            val prefs = context.getSharedPreferences("home_widget_preferences", Context.MODE_PRIVATE)            if (scheduledTime.isNotEmpty()) {            if (scheduledTime.isNotEmpty()) {

            val habitsJson = prefs.getString("habits", null)

                            remoteViews.setTextViewText(R.id.compact_habit_time, scheduledTime)                remoteViews.setTextViewText(R.id.compact_habit_time, scheduledTime)

            Log.d("CompactWidget", "Loading habit data from preferences")

            Log.d("CompactWidget", "Habits JSON (first 100 chars): ${habitsJson?.take(100) ?: "null"}")                remoteViews.setViewVisibility(R.id.compact_habit_time, android.view.View.VISIBLE)                remoteViews.setViewVisibility(R.id.compact_habit_time, android.view.View.VISIBLE)

            

            if (habitsJson != null && habitsJson.isNotEmpty()) {            } else {            } else {

                try {

                    val gson = Gson()                remoteViews.setViewVisibility(R.id.compact_habit_time, android.view.View.GONE)                remoteViews.setViewVisibility(R.id.compact_habit_time, android.view.View.GONE)

                    val type = object : TypeToken<List<Map<String, Any>>>() {}.type

                    habits = gson.fromJson(habitsJson, type) ?: emptyList()            }            }

                    

                    Log.d("CompactWidget", "Parsed ${habits.size} habits successfully")

                    

                    // Log first few habits for debugging            // Set color indicator            // Set color indicator

                    habits.take(3).forEachIndexed { index, habit ->

                        Log.d("CompactWidget", "Habit $index: ${habit["name"]} - ${habit["scheduledTime"]}")            remoteViews.setInt(R.id.compact_habit_color_indicator, "setBackgroundColor", habitColor)            remoteViews.setInt(R.id.compact_habit_color_indicator, "setBackgroundColor", habitColor)

                    }

                } catch (e: Exception) {

                    Log.e("CompactWidget", "Error parsing habits JSON: ${e.message}")

                    habits = emptyList()            // Set completion button state and visual indicators            // Set completion button state and visual indicators

                }

            } else {            if (isCompleted) {            if (isCompleted) {

                Log.d("CompactWidget", "No habits data found in preferences")

                habits = emptyList()                // Show completed state with checkmark                // Show completed state with checkmark

            }

        } catch (e: Exception) {                remoteViews.setImageViewResource(R.id.compact_complete_button, R.drawable.ic_check)                remoteViews.setImageViewResource(R.id.compact_complete_button, R.drawable.ic_check)

            Log.e("CompactWidget", "Error loading habit data: ${e.message}")

            habits = emptyList()                remoteViews.setInt(R.id.compact_complete_button, "setColorFilter", android.graphics.Color.parseColor("#4CAF50"))                remoteViews.setInt(R.id.compact_complete_button, "setColorFilter", android.graphics.Color.parseColor("#4CAF50"))

        }

    }                                

}
                // Add visual completion indicators                // Add visual completion indicators

                remoteViews.setFloat(R.id.compact_habit_name, "setAlpha", 0.7f)                remoteViews.setFloat(R.id.compact_habit_name, "setAlpha", 0.7f)

                remoteViews.setFloat(R.id.compact_habit_time, "setAlpha", 0.7f)                remoteViews.setFloat(R.id.compact_habit_time, "setAlpha", 0.7f)

                                

                // Add border to indicate completion                // Add border to indicate completion

                remoteViews.setInt(R.id.compact_habit_item_container, "setBackgroundResource", R.drawable.widget_habit_item_completed_background)                remoteViews.setInt(R.id.compact_habit_item_container, "setBackgroundResource", R.drawable.widget_habit_item_completed_background)

            } else {            } else {

                // Show pending state with outline                // Show pending state with outline

                remoteViews.setImageViewResource(R.id.compact_complete_button, R.drawable.ic_check_circle_outline)                remoteViews.setImageViewResource(R.id.compact_complete_button, R.drawable.ic_check_circle_outline)

                remoteViews.setInt(R.id.compact_complete_button, "setColorFilter", habitColor)                remoteViews.setInt(R.id.compact_complete_button, "setColorFilter", habitColor)

                                

                // Normal opacity for pending habits                // Normal opacity for pending habits

                remoteViews.setFloat(R.id.compact_habit_name, "setAlpha", 1.0f)                remoteViews.setFloat(R.id.compact_habit_name, "setAlpha", 1.0f)

                remoteViews.setFloat(R.id.compact_habit_time, "setAlpha", 1.0f)                remoteViews.setFloat(R.id.compact_habit_time, "setAlpha", 1.0f)

                                

                // Normal background                // Normal background

                remoteViews.setInt(R.id.compact_habit_item_container, "setBackgroundResource", R.drawable.widget_habit_item_background)                remoteViews.setInt(R.id.compact_habit_item_container, "setBackgroundResource", R.drawable.widget_habit_item_background)

            }            }

                remoteViews.setInt(R.id.compact_complete_button, "setColorFilter", habitColor)

            // Set up click intent for completion toggle                remoteViews.setFloat(R.id.compact_habit_name, "setAlpha", 1.0f)

            val fillInIntent = Intent().apply {                remoteViews.setFloat(R.id.compact_habit_time, "setAlpha", 1.0f)

                putExtra("habit_id", habit["id"] as? String ?: "")            }

                putExtra("action", "toggle_completion")

                putExtra("position", position)            // Set up click intent for completion toggle

            }            val fillInIntent = Intent().apply {

            remoteViews.setOnClickFillInIntent(R.id.compact_complete_button, fillInIntent)                putExtra("habit_id", habit["id"] as? String ?: "")

                putExtra("action", "toggle_completion")

            // Set up click intent for opening habit details                putExtra("position", position)

            val habitDetailIntent = Intent().apply {            }

                putExtra("habit_id", habit["id"] as? String ?: "")            remoteViews.setOnClickFillInIntent(R.id.compact_complete_button, fillInIntent)

                putExtra("action", "open_habit")

                putExtra("position", position)            // Set up click intent for opening habit details

            }            val habitDetailIntent = Intent().apply {

            remoteViews.setOnClickFillInIntent(R.id.compact_habit_name, habitDetailIntent)                putExtra("habit_id", habit["id"] as? String ?: "")

                putExtra("action", "open_habit")

            Log.d("HabitCompactService", "Created view for habit: $habitName at position $position")                putExtra("position", position)

            }

        } catch (e: Exception) {            remoteViews.setOnClickFillInIntent(R.id.compact_habit_name, habitDetailIntent)

            Log.e("HabitCompactService", "Error creating view for position $position", e)

            // Return a basic view on error            Log.d("HabitCompactService", "Created view for habit: $habitName at position $position")

            remoteViews.setTextViewText(R.id.compact_habit_name, "Error loading habit")

        }        } catch (e: Exception) {

            Log.e("HabitCompactService", "Error creating view for position $position", e)

        return remoteViews            // Return a basic view on error

    }            remoteViews.setTextViewText(R.id.compact_habit_name, "Error loading habit")

        }

    override fun getLoadingView(): RemoteViews? {

        return RemoteViews(context.packageName, R.layout.widget_compact_habit_item)        return remoteViews

    }    }



    override fun getViewTypeCount(): Int {    override fun getLoadingView(): RemoteViews? {

        return 1        val remoteViews = RemoteViews(context.packageName, R.layout.widget_compact_habit_item)

    }        remoteViews.setTextViewText(R.id.compact_habit_name, "Loading...")

        remoteViews.setViewVisibility(R.id.compact_habit_time, android.view.View.GONE)

    override fun getItemId(position: Int): Long {        remoteViews.setViewVisibility(R.id.compact_complete_button, android.view.View.GONE)

        return position.toLong()        return remoteViews

    }    }



    override fun hasStableIds(): Boolean {    override fun getViewTypeCount(): Int {

        return true        return 1

    }    }



    override fun onDataSetChanged() {    override fun getItemId(position: Int): Long {

        loadHabitData()        return position.toLong()

    }    }



    private fun loadHabitData() {    override fun hasStableIds(): Boolean {

        try {        return true

            // Load habit data from the SAME SharedPreferences that the widget provider uses    }

            val prefs = context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)

            val habitsJson = prefs.getString("habits", null)    override fun onDataSetChanged() {

                    Log.d("HabitCompactService", "onDataSetChanged called - reloading habit data")

            Log.d("HabitCompactService", "Looking for habits data with key: habits in HomeWidgetPreferences")        loadHabitData()

                }

            if (habitsJson != null) {

                Log.d("HabitCompactService", "Found habits JSON: ${habitsJson.take(200)}...")    private fun loadHabitData() {

                        try {

                // Parse JSON data using reflection            // Load habit data from the SAME SharedPreferences that the widget provider uses

                val gson = com.google.gson.Gson()            val prefs = context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)

                val type = com.google.gson.reflect.TypeToken.getParameterized(            val habitsJson = prefs.getString("habits", null)

                    java.util.List::class.java,            

                    Map::class.java            if (habitsJson != null) {

                ).type                Log.d("HabitCompactService", "Found habits JSON: ${habitsJson.take(200)}...")

                habits = gson.fromJson(habitsJson, type) ?: emptyList()                // Parse JSON data using reflection

                Log.d("HabitCompactService", "Loaded ${habits.size} habits from HomeWidgetPreferences")                val gson = com.google.gson.Gson()

                                val type = com.google.gson.reflect.TypeToken.getParameterized(

                // Debug first habit if available                    java.util.List::class.java,

                if (habits.isNotEmpty()) {                    Map::class.java

                    val firstHabit = habits[0]                ).type

                    Log.d("HabitCompactService", "First habit keys: ${firstHabit.keys}")                habits = gson.fromJson(habitsJson, type) ?: emptyList()

                }                Log.d("HabitCompactService", "Loaded ${habits.size} habits from HomeWidgetPreferences")

            } else {            } else {

                Log.d("HabitCompactService", "No habit data found in HomeWidgetPreferences")                habits = emptyList()

                habits = emptyList()                Log.d("HabitCompactService", "No habit data found in HomeWidgetPreferences")

            }                

        } catch (e: Exception) {                // Debug available keys

            Log.e("HabitCompactService", "Error loading habit data", e)                val allKeys = prefs.all.keys

            habits = emptyList()                Log.d("HabitCompactService", "Available keys: $allKeys")

        }            }

    }        } catch (e: Exception) {

}            Log.e("HabitCompactService", "Error loading habit data", e)
            habits = emptyList()
        }
    }
}