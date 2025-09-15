package com.habittracker.habitv8

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.media.AudioAttributes
import android.media.AudioManager
import android.media.MediaPlayer
import android.media.Ringtone
import android.media.RingtoneManager
import android.net.Uri
import android.os.Build
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import android.os.PowerManager
import android.os.VibrationEffect
import android.os.Vibrator
import android.os.VibratorManager
import android.util.Log
import androidx.core.app.NotificationCompat

/**
 * A foreground service that plays alarm sounds continuously and reliably.
 * This service is designed to be resilient against system optimizations and
 * will continue playing alarm sounds even when the app is in the background.
 */
class AlarmService : Service() {
    companion object {
        private const val TAG = "AlarmService"
        private const val NOTIFICATION_ID = 1001
        private const val CHANNEL_ID = "habit_alarm_service"
        private const val CHANNEL_NAME = "Habit Alarm Service"
        private const val CHANNEL_DESCRIPTION = "Plays alarm sounds for habit reminders"
        
        // Static method to start the service from MainActivity or other components
        fun startAlarmService(context: Context, soundUri: String?, habitName: String?) {
            try {
                Log.i(TAG, "🚀 Starting AlarmService for habit: ")
                val intent = Intent(context, AlarmService::class.java).apply {
                    putExtra("soundUri", soundUri)
                    putExtra("habitName", habitName ?: "Habit Reminder")
                }
                
                // Use startForegroundService for Android 8.0+ (API 26+)
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    context.startForegroundService(intent)
                } else {
                    context.startService(intent)
                }
                Log.i(TAG, "✅ AlarmService start request sent")
            } catch (e: Exception) {
                Log.e(TAG, "❌ Failed to start AlarmService: ", e)
            }
        }
    }

    private var mediaPlayer: MediaPlayer? = null
    private var ringtone: Ringtone? = null
    private var wakeLock: PowerManager.WakeLock? = null
    private var vibrator: Vibrator? = null
    private var soundUri: Uri? = null
    private var habitName: String = "Habit Reminder"
    private var volumeHandler: Handler? = null
    private var volumeRunnable: Runnable? = null
    private var isVolumeIncreasing = false
    private var isDestroying = false

    override fun onCreate() {
        super.onCreate()
        Log.i(TAG, "AlarmService onCreate")
        
        // Initialize vibrator
        vibrator = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            val vibratorManager = getSystemService(Context.VIBRATOR_MANAGER_SERVICE) as VibratorManager
            vibratorManager.defaultVibrator
        } else {
            @Suppress("DEPRECATION")
            getSystemService(Context.VIBRATOR_SERVICE) as Vibrator
        }
        
        // Acquire wake lock to keep CPU running
        val powerManager = getSystemService(Context.POWER_SERVICE) as PowerManager
        wakeLock = powerManager.newWakeLock(
            PowerManager.PARTIAL_WAKE_LOCK or PowerManager.ACQUIRE_CAUSES_WAKEUP,
            "HabitV8:AlarmServiceWakeLock"
        ).apply {
            acquire(10*60*1000L) // 10 minutes max
        }
        
        volumeHandler = Handler(Looper.getMainLooper())
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        Log.i(TAG, "AlarmService onStartCommand")
        
        // Extract data from intent
        val soundUriString = intent?.getStringExtra("soundUri")
        val alarmId = intent?.getIntExtra("alarmId", 0) ?: 0
        habitName = intent?.getStringExtra("habitName") ?: "Habit Reminder"
        
        Log.i(TAG, "Starting alarm service for: $habitName (ID: $alarmId)")
        
        // Create notification channel and start foreground service
        createNotificationChannel()
        startForeground(NOTIFICATION_ID, createNotification())
        
        // Start playing the alarm sound
        if (soundUriString != null && soundUriString.isNotEmpty()) {
            try {
                soundUri = Uri.parse(soundUriString)
                playAlarmSound(soundUri!!)
            } catch (e: Exception) {
                Log.e(TAG, "Failed to parse sound URI: $soundUriString", e)
                // Fall back to default alarm sound
                soundUri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_ALARM)
                playAlarmSound(soundUri!!)
            }
        } else {
            // Use default alarm sound if none provided
            soundUri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_ALARM)
            playAlarmSound(soundUri!!)
        }
        
        // Start vibration pattern
        startVibration()
        
        return START_STICKY
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID,
                CHANNEL_NAME,
                NotificationManager.IMPORTANCE_HIGH
            ).apply {
                description = CHANNEL_DESCRIPTION
                setSound(null, null) // No sound from notification channel - we handle sound separately
                enableVibration(false) // No vibration from notification channel - we handle vibration separately
                setBypassDnd(true) // Bypass Do Not Disturb
                lockscreenVisibility = Notification.VISIBILITY_PUBLIC
            }
            
            val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(channel)
        }
    }

    private fun createNotification(): Notification {
        // Create an intent to open the app when notification is tapped
        val intent = packageManager.getLaunchIntentForPackage(packageName)?.apply {
            flags = Intent.FLAG_ACTIVITY_CLEAR_TOP or Intent.FLAG_ACTIVITY_SINGLE_TOP
        }
        
        val pendingIntent = PendingIntent.getActivity(
            this,
            0,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        
        // Create stop action
        val stopIntent = Intent(this, AlarmService::class.java).apply {
            action = "STOP_ALARM"
        }
        
        val stopPendingIntent = PendingIntent.getService(
            this,
            1,
            stopIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        
        // Build the notification
        return NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle("🔔 ")
            .setContentText("Tap to open app or use controls to manage alarm")
            .setSmallIcon(android.R.drawable.ic_lock_idle_alarm)
            .setPriority(NotificationCompat.PRIORITY_MAX)
            .setCategory(NotificationCompat.CATEGORY_ALARM)
            .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
            .setOngoing(true) // Cannot be dismissed by swiping
            .setAutoCancel(false)
            .setContentIntent(pendingIntent)
            .addAction(android.R.drawable.ic_delete, "Stop Alarm", stopPendingIntent)
            .build()
    }

    private fun playAlarmSound(uri: Uri) {
        try {
            Log.i(TAG, "Playing alarm sound: ")
            
            // Stop any existing playback
            stopAlarmSound()
            
            // Try using MediaPlayer first (more reliable for continuous playback)
            try {
                mediaPlayer = MediaPlayer().apply {
                    setDataSource(applicationContext, uri)
                    
                    // Configure audio attributes for alarm
                    setAudioAttributes(
                        AudioAttributes.Builder()
                            .setUsage(AudioAttributes.USAGE_ALARM)
                            .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                            .setFlags(AudioAttributes.FLAG_AUDIBILITY_ENFORCED)
                            .build()
                    )
                    
                    // Set to loop continuously
                    isLooping = true
                    
                    // Start at lower volume and increase gradually
                    setVolume(0.3f, 0.3f)
                    
                    // Prepare and start playback
                    prepare()
                    start()
                    
                    Log.i(TAG, "MediaPlayer started successfully")
                    
                    // Start volume increase
                    startVolumeIncrease()
                }
                return
            } catch (e: Exception) {
                Log.e(TAG, "MediaPlayer failed, falling back to Ringtone: ", e)
                mediaPlayer?.release()
                mediaPlayer = null
            }
            
            // Fallback to Ringtone API
            ringtone = RingtoneManager.getRingtone(applicationContext, uri).apply {
                // Set audio attributes for alarm
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                    setAudioAttributes(
                        AudioAttributes.Builder()
                            .setUsage(AudioAttributes.USAGE_ALARM)
                            .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                            .setFlags(AudioAttributes.FLAG_AUDIBILITY_ENFORCED)
                            .build()
                    )
                } else {
                    @Suppress("DEPRECATION")
                    streamType = AudioManager.STREAM_ALARM
                }
                
                // Set initial volume
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                    volume = 0.3f
                }
                
                // Start playback
                play()
                Log.i(TAG, "Ringtone started successfully")
                
                // Start volume increase
                startVolumeIncrease()
            }
        } catch (e: Exception) {
            Log.e(TAG, "Failed to play alarm sound: ", e)
        }
    }

    private fun startVolumeIncrease() {
        if (isVolumeIncreasing) return
        
        isVolumeIncreasing = true
        var currentStep = 3 // Start at 30%
        val maxStep = 10 // Max 100%
        
        volumeRunnable = object : Runnable {
            override fun run() {
                if (isDestroying) return
                
                try {
                    if (currentStep <= maxStep) {
                        val volume = currentStep / 10.0f
                        
                        // Apply volume to active player
                        if (mediaPlayer != null && mediaPlayer?.isPlaying == true) {
                            mediaPlayer?.setVolume(volume, volume)
                        } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P && 
                                  ringtone != null && ringtone?.isPlaying == true) {
                            ringtone?.volume = volume
                        }
                        
                        Log.d(TAG, "Volume increased to %")
                        
                        currentStep++
                        if (currentStep <= maxStep) {
                            volumeHandler?.postDelayed(this, 1000) // 1 second between steps
                        }
                    }
                } catch (e: Exception) {
                    Log.e(TAG, "Error during volume increase: ", e)
                }
            }
        }
        
        volumeHandler?.postDelayed(volumeRunnable!!, 1000)
    }

    private fun startVibration() {
        if (vibrator?.hasVibrator() != true) {
            Log.i(TAG, "Device does not support vibration")
            return
        }
        
        try {
            // Create a pattern with increasing intensity
            // Format: [delay1, duration1, delay2, duration2, ...]
            val pattern = longArrayOf(0, 500, 500, 700, 500, 900, 500, 1100)
            
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                // Use VibrationEffect for modern devices
                val effect = VibrationEffect.createWaveform(
                    pattern,
                    intArrayOf(0, 50, 0, 100, 0, 150, 0, 200),
                    0 // Repeat indefinitely
                )
                vibrator?.vibrate(effect)
            } else {
                // Legacy vibration
                @Suppress("DEPRECATION")
                vibrator?.vibrate(pattern, 0) // Repeat indefinitely
            }
            
            Log.i(TAG, "Vibration pattern started")
        } catch (e: Exception) {
            Log.e(TAG, "Failed to start vibration: ", e)
        }
    }

    private fun stopVibration() {
        try {
            vibrator?.cancel()
            Log.i(TAG, "Vibration stopped")
        } catch (e: Exception) {
            Log.e(TAG, "Error stopping vibration: ", e)
        }
    }

    private fun stopAlarmSound() {
        try {
            // Stop MediaPlayer if active
            if (mediaPlayer != null) {
                if (mediaPlayer?.isPlaying == true) {
                    mediaPlayer?.stop()
                }
                mediaPlayer?.release()
                mediaPlayer = null
                Log.i(TAG, "MediaPlayer stopped and released")
            }
            
            // Stop Ringtone if active
            if (ringtone?.isPlaying == true) {
                ringtone?.stop()
                ringtone = null
                Log.i(TAG, "Ringtone stopped")
            }
            
            // Cancel volume increase
            volumeHandler?.removeCallbacks(volumeRunnable ?: return)
            isVolumeIncreasing = false
            
            Log.i(TAG, "All alarm sounds stopped")
        } catch (e: Exception) {
            Log.e(TAG, "Error stopping alarm sound: ", e)
        }
    }

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

    override fun onDestroy() {
        Log.i(TAG, "AlarmService onDestroy")
        isDestroying = true
        
        // Stop all sounds and vibrations
        stopAlarmSound()
        stopVibration()
        
        // Release wake lock
        if (wakeLock?.isHeld == true) {
            try {
                wakeLock?.release()
                Log.i(TAG, "Wake lock released")
            } catch (e: Exception) {
                Log.e(TAG, "Error releasing wake lock: ", e)
            }
        }
        
        super.onDestroy()
    }
}
