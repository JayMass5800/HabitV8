package com.habittracker.habitv8

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import android.util.Log
import androidx.work.*
import java.util.concurrent.TimeUnit

/**
 * Android 15+ compatible boot receiver that uses WorkManager instead of starting
 * foreground services directly from BOOT_COMPLETED broadcast.
 * 
 * This prevents crashes on Android 15+ where starting certain foreground service
 * types from BOOT_COMPLETED is restricted.
 */
class Android15CompatBootReceiver : BroadcastReceiver() {
    companion object {
        private const val TAG = "Android15CompatBootReceiver"
        private const val BOOT_WORK_NAME = "habitv8_boot_completion_work"
    }

    override fun onReceive(context: Context, intent: Intent) {
        try {
            Log.i(TAG, "Boot completed: ${intent.action}")
            
            when (intent.action) {
                Intent.ACTION_BOOT_COMPLETED,
                Intent.ACTION_MY_PACKAGE_REPLACED,
                "android.intent.action.QUICKBOOT_POWERON" -> {
                    handleBootCompleted(context)
                }
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error handling boot completion", e)
        }
    }
    
    private fun handleBootCompleted(context: Context) {
        try {
            Log.i(TAG, "Scheduling post-boot notification renewal work")
            
            // Use WorkManager to handle notification rescheduling instead of starting
            // foreground services directly from the broadcast receiver
            val constraints = Constraints.Builder()
                .setRequiredNetworkType(NetworkType.NOT_REQUIRED)
                .setRequiresBatteryNotLow(false)
                .setRequiresCharging(false)
                .setRequiresDeviceIdle(false)
                .build()
            
            val bootWorkRequest = OneTimeWorkRequestBuilder<BootCompletionWorker>()
                .setConstraints(constraints)
                .setInitialDelay(30, TimeUnit.SECONDS) // Give system time to stabilize
                .addTag("boot_completion")
                .build()
            
            WorkManager.getInstance(context)
                .enqueueUniqueWork(
                    BOOT_WORK_NAME,
                    ExistingWorkPolicy.REPLACE,
                    bootWorkRequest
                )
            
            Log.i(TAG, "✅ Boot completion work scheduled successfully")
        } catch (e: Exception) {
            Log.e(TAG, "❌ Error scheduling boot completion work", e)
        }
    }
}

/**
 * WorkManager worker that handles the actual notification rescheduling after boot.
 * This runs in a background context and can safely reschedule notifications
 * without violating Android 15+ foreground service restrictions.
 */
class BootCompletionWorker(
    context: Context,
    workerParams: WorkerParameters
) : Worker(context, workerParams) {
    
    companion object {
        private const val TAG = "BootCompletionWorker"
    }
    
    override fun doWork(): Result {
        return try {
            Log.i(TAG, "Starting boot completion work")
            
            // Initialize FlutterEngine and trigger notification rescheduling
            // This approach avoids starting foreground services from BOOT_COMPLETED
            val sharedPrefs = applicationContext.getSharedPreferences(
                "flutter.habitv8.preferences", 
                Context.MODE_PRIVATE
            )
            
            // Set a flag that the Flutter app can check on next startup
            sharedPrefs.edit()
                .putBoolean("needs_notification_reschedule_after_boot", true)
                .putLong("boot_completion_timestamp", System.currentTimeMillis())
                .apply()
            
            Log.i(TAG, "✅ Boot completion flag set for Flutter app")
            
            // Optionally trigger the Flutter app to start if needed
            // This is safer than starting foreground services directly
            try {
                val launchIntent = applicationContext.packageManager
                    .getLaunchIntentForPackage(applicationContext.packageName)
                
                if (launchIntent != null) {
                    launchIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                    launchIntent.putExtra("auto_start_reason", "boot_completion")
                    applicationContext.startActivity(launchIntent)
                    Log.i(TAG, "✅ Flutter app started for notification rescheduling")
                }
            } catch (e: Exception) {
                Log.w(TAG, "Could not auto-start app after boot (this is normal): ${e.message}")
                // This is not critical - the app will handle rescheduling on next manual start
            }
            
            Result.success()
        } catch (e: Exception) {
            Log.e(TAG, "❌ Error in boot completion work", e)
            Result.failure()
        }
    }
}