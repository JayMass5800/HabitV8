package com.habittracker.habitv8

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import androidx.work.*
import java.util.concurrent.TimeUnit

/**
 * Boot receiver specifically for rescheduling notifications after device reboot.
 * 
 * This receiver is triggered by BOOT_COMPLETED and schedules a WorkManager task
 * to reschedule all notifications. This approach is compatible with Android 15+
 * restrictions on starting foreground services from boot receivers.
 */
class NotificationBootReceiver : BroadcastReceiver() {
    companion object {
        private const val TAG = "NotificationBootReceiver"
        private const val NOTIFICATION_RESCHEDULE_WORK = "notification_reschedule_after_boot"
    }

    override fun onReceive(context: Context, intent: Intent) {
        try {
            Log.i(TAG, "📱 Boot completed: ${intent.action}")
            
            when (intent.action) {
                Intent.ACTION_BOOT_COMPLETED,
                Intent.ACTION_MY_PACKAGE_REPLACED,
                "android.intent.action.QUICKBOOT_POWERON" -> {
                    handleBootCompleted(context)
                }
            }
        } catch (e: Exception) {
            Log.e(TAG, "❌ Error handling boot completion", e)
        }
    }
    
    private fun handleBootCompleted(context: Context) {
        try {
            Log.i(TAG, "🔄 Scheduling notification rescheduling work")
            
            // Set flag in SharedPreferences to indicate boot completion
            // This will be checked by the Flutter app when it starts
            val sharedPrefs = context.getSharedPreferences(
                "FlutterSharedPreferences", 
                Context.MODE_PRIVATE
            )
            
            sharedPrefs.edit()
                .putBoolean("flutter.needs_notification_reschedule_after_boot", true)
                .putLong("flutter.boot_completion_timestamp", System.currentTimeMillis())
                .apply()
            
            Log.i(TAG, "✅ Boot completion flags set in SharedPreferences")
            
            // Schedule WorkManager task to reschedule notifications
            // This runs after a short delay to allow the system to stabilize
            val constraints = Constraints.Builder()
                .setRequiredNetworkType(NetworkType.NOT_REQUIRED)
                .setRequiresBatteryNotLow(false)
                .setRequiresCharging(false)
                .setRequiresDeviceIdle(false)
                .build()
            
            val rescheduleWorkRequest = OneTimeWorkRequestBuilder<NotificationRescheduleWorker>()
                .setConstraints(constraints)
                .setInitialDelay(30, TimeUnit.SECONDS) // Give system time to stabilize
                .addTag("notification_reschedule")
                .addTag("boot_completion")
                .build()
            
            WorkManager.getInstance(context)
                .enqueueUniqueWork(
                    NOTIFICATION_RESCHEDULE_WORK,
                    ExistingWorkPolicy.REPLACE,
                    rescheduleWorkRequest
                )
            
            Log.i(TAG, "✅ Notification rescheduling work scheduled successfully")
            Log.i(TAG, "   Work will execute in 30 seconds to allow system stabilization")
        } catch (e: Exception) {
            Log.e(TAG, "❌ Error scheduling notification rescheduling work", e)
        }
    }
}

/**
 * WorkManager worker that handles notification rescheduling after boot.
 * 
 * This worker attempts to launch the Flutter app in the background to trigger
 * notification rescheduling. If the app cannot be launched (due to lack of
 * AUTO-START permission), the notifications will be rescheduled when the user
 * manually opens the app.
 */
class NotificationRescheduleWorker(
    context: Context,
    workerParams: WorkerParameters
) : Worker(context, workerParams) {
    
    companion object {
        private const val TAG = "NotificationRescheduleWorker"
    }
    
    override fun doWork(): Result {
        return try {
            Log.i(TAG, "🔄 Starting notification rescheduling work")
            
            // Try to launch the app in background to trigger notification rescheduling
            // This requires AUTO-START permission on most devices
            try {
                val launchIntent = applicationContext.packageManager
                    .getLaunchIntentForPackage(applicationContext.packageName)
                
                if (launchIntent != null) {
                    launchIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                    launchIntent.addFlags(Intent.FLAG_ACTIVITY_NO_ANIMATION)
                    launchIntent.addFlags(Intent.FLAG_FROM_BACKGROUND)
                    launchIntent.putExtra("auto_start_reason", "notification_reschedule")
                    launchIntent.putExtra("run_in_background", true)
                    applicationContext.startActivity(launchIntent)
                    
                    Log.i(TAG, "✅ App auto-started in background for notification rescheduling")
                    Log.i(TAG, "   This allows notifications to be rescheduled without user opening app")
                    Log.i(TAG, "   Requires AUTO-START permission on Xiaomi/Huawei/Oppo/etc.")
                } else {
                    Log.w(TAG, "⚠️ Could not get launch intent for app")
                }
            } catch (e: Exception) {
                Log.w(TAG, "⚠️ Could not auto-start app after boot: ${e.message}")
                Log.w(TAG, "   This is normal if AUTO-START permission is not granted")
                Log.w(TAG, "   User must manually open app to reschedule notifications")
                // This is not critical - fallback: user opens app, flag is checked, notifications rescheduled
            }
            
            // Schedule periodic widget updates as well
            WidgetUpdateWorker.schedulePeriodicUpdates(applicationContext)
            
            Log.i(TAG, "✅ Notification rescheduling work completed")
            Result.success()
        } catch (e: Exception) {
            Log.e(TAG, "❌ Error in notification rescheduling work", e)
            Result.failure()
        }
    }
}