package com.habittracker.habitv8

import android.app.*
import android.content.Context
import android.content.Intent
import android.media.AudioAttributes
import android.media.AudioFocusRequest
import android.media.AudioManager
import android.media.Ringtone
import android.media.RingtoneManager
import android.net.Uri
import android.os.Build
import android.os.IBinder
import android.os.PowerManager
import androidx.core.app.NotificationCompat

class AlarmService : Service() {
    companion object {
        private const val CHANNEL_ID = "alarm_service_channel"
        private const val NOTIFICATION_ID = 999999
        private var currentRingtone: Ringtone? = null
        private var isServiceRunning = false
        private var wakeLock: PowerManager.WakeLock? = null
        private var audioFocusRequest: AudioFocusRequest? = null
        private var audioManager: AudioManager? = null
        
        fun startAlarmService(context: Context, soundUri: String?, habitName: String?) {
            android.util.Log.i("AlarmService", "startAlarmService called - current running: $isServiceRunning")
            
            // Always try to start the service, even if one appears to be running
            // This ensures robustness in case the previous service was killed
            val intent = Intent(context, AlarmService::class.java).apply {
                putExtra("soundUri", soundUri)
                putExtra("habitName", habitName)
                action = "START_ALARM"
            }
            
            try {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    context.startForegroundService(intent)
                    android.util.Log.i("AlarmService", "Started foreground service")
                } else {
                    context.startService(intent)
                    android.util.Log.i("AlarmService", "Started regular service")
                }
            } catch (e: Exception) {
                android.util.Log.e("AlarmService", "Failed to start service: ${e.message}")
            }
        }
        
        fun stopAlarmService(context: Context) {
            android.util.Log.i("AlarmService", "stopAlarmService called")
            val intent = Intent(context, AlarmService::class.java).apply {
                action = "STOP_ALARM"
            }
            try {
                context.startService(intent)
            } catch (e: Exception) {
                android.util.Log.e("AlarmService", "Failed to stop service: ${e.message}")
            }
        }
    }

    override fun onCreate() {
        super.onCreate()
        android.util.Log.i("AlarmService", "AlarmService onCreate")
        createNotificationChannel()
        
        // Get audio manager for audio focus
        audioManager = getSystemService(Context.AUDIO_SERVICE) as AudioManager
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        android.util.Log.i("AlarmService", "onStartCommand with action: ${intent?.action}")
        
        when (intent?.action) {
            "START_ALARM" -> {
                val soundUri = intent.getStringExtra("soundUri")
                val habitName = intent.getStringExtra("habitName") ?: "Habit"
                startAlarm(soundUri, habitName)
            }
            "STOP_ALARM" -> {
                stopAlarm()
                stopSelf()
            }
        }
        
        // Return START_STICKY to restart service if killed by system
        return START_STICKY
    }

    private fun startAlarm(soundUri: String?, habitName: String) {
        android.util.Log.i("AlarmService", "startAlarm called with sound: $soundUri")
        
        // Stop any existing alarm first
        if (isServiceRunning) {
            stopAlarm()
        }
        
        isServiceRunning = true
        
        // Acquire wake lock to prevent device from sleeping
        val powerManager = getSystemService(Context.POWER_SERVICE) as PowerManager
        wakeLock = powerManager.newWakeLock(
            PowerManager.PARTIAL_WAKE_LOCK,
            "HabitV8:AlarmWakeLock"
        )
        wakeLock?.acquire(30 * 60 * 1000L) // 30 minutes max
        
        // Request audio focus to ensure alarm can play over other audio
        requestAudioFocus()
        
        // Create foreground notification
        val notification = createAlarmNotification(habitName)
        startForeground(NOTIFICATION_ID, notification)
        
        // Start playing alarm sound
        try {
            val uri = if (soundUri != null && soundUri != "default" && soundUri.isNotEmpty()) {
                android.util.Log.i("AlarmService", "Using custom sound URI: $soundUri")
                Uri.parse(soundUri)
            } else {
                android.util.Log.i("AlarmService", "Using default alarm sound")
                RingtoneManager.getDefaultUri(RingtoneManager.TYPE_ALARM)
            }
            
            android.util.Log.i("AlarmService", "Final URI: $uri")
            
            currentRingtone = RingtoneManager.getRingtone(applicationContext, uri)
            currentRingtone?.let { ringtone ->
                ringtone.isLooping = true
                
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                    ringtone.audioAttributes = AudioAttributes.Builder()
                        .setUsage(AudioAttributes.USAGE_ALARM)
                        .setContentType(AudioAttributes.CONTENT_TYPE_MUSIC)
                        .setFlags(AudioAttributes.FLAG_AUDIBILITY_ENFORCED)
                        .build()
                }
                
                // Start with low volume and gradually increase
                ringtone.volume = 0.3f
                ringtone.play()
                android.util.Log.i("AlarmService", "Alarm sound started playing")
                
                // Gradually increase volume
                startVolumeIncrease(ringtone)
            } ?: run {
                android.util.Log.e("AlarmService", "Failed to create ringtone for URI: $uri")
            }
        } catch (e: Exception) {
            android.util.Log.e("AlarmService", "Error starting alarm sound: ${e.message}")
        }
    }
    
    private fun requestAudioFocus() {
        audioManager?.let { am ->
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                audioFocusRequest = AudioFocusRequest.Builder(AudioManager.AUDIOFOCUS_GAIN)
                    .setAudioAttributes(
                        AudioAttributes.Builder()
                            .setUsage(AudioAttributes.USAGE_ALARM)
                            .setContentType(AudioAttributes.CONTENT_TYPE_MUSIC)
                            .build()
                    )
                    .setOnAudioFocusChangeListener { focusChange ->
                        android.util.Log.i("AlarmService", "Audio focus changed: $focusChange")
                        // Don't stop alarm on focus loss - alarms should be persistent
                    }
                    .build()
                
                val result = am.requestAudioFocus(audioFocusRequest!!)
                android.util.Log.i("AlarmService", "Audio focus request result: $result")
            } else {
                @Suppress("DEPRECATION")
                val result = am.requestAudioFocus(
                    { focusChange ->
                        android.util.Log.i("AlarmService", "Audio focus changed: $focusChange")
                        // Don't stop alarm on focus loss - alarms should be persistent
                    },
                    AudioManager.STREAM_ALARM,
                    AudioManager.AUDIOFOCUS_GAIN
                )
                android.util.Log.i("AlarmService", "Audio focus request result: $result")
            }
        }
    }
    
    private fun startVolumeIncrease(ringtone: Ringtone) {
        val handler = android.os.Handler(android.os.Looper.getMainLooper())
        var volumeStep = 3 // Start at 30%
        
        val volumeRunnable = object : Runnable {
            override fun run() {
                try {
                    if (ringtone.isPlaying && volumeStep <= 10) {
                        val volume = volumeStep / 10.0f
                        ringtone.volume = volume
                        volumeStep++
                        
                        if (volumeStep <= 10) {
                            handler.postDelayed(this, 1000) // Increase every second
                        }
                    }
                } catch (e: Exception) {
                    android.util.Log.e("AlarmService", "Error in volume increase: ${e.message}")
                }
            }
        }
        
        handler.postDelayed(volumeRunnable, 1000)
    }

    private fun stopAlarm() {
        android.util.Log.i("AlarmService", "stopAlarm called")
        
        try {
            // Release audio focus
            audioManager?.let { am ->
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    audioFocusRequest?.let { am.abandonAudioFocusRequest(it) }
                } else {
                    @Suppress("DEPRECATION")
                    am.abandonAudioFocus(null)
                }
            }
            
            // Stop ringtone
            currentRingtone?.stop()
            currentRingtone = null
            
            // Release wake lock
            wakeLock?.let { 
                if (it.isHeld) {
                    it.release()
                }
            }
            wakeLock = null
            
            isServiceRunning = false
            android.util.Log.i("AlarmService", "Alarm stopped successfully")
        } catch (e: Exception) {
            android.util.Log.e("AlarmService", "Error stopping alarm: ${e.message}")
        }
    }

    private fun createAlarmNotification(habitName: String): Notification {
        val stopIntent = Intent(this, AlarmService::class.java).apply {
            action = "STOP_ALARM"
        }
        val stopPendingIntent = PendingIntent.getService(
            this, 0, stopIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        return NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle("Habit Alarm: $habitName")
            .setContentText("Alarm is playing - tap to stop")
            .setSmallIcon(android.R.drawable.ic_dialog_alert)
            .setCategory(NotificationCompat.CATEGORY_ALARM)
            .setPriority(NotificationCompat.PRIORITY_MAX)
            .setOngoing(true)
            .setAutoCancel(false)
            .addAction(
                android.R.drawable.ic_menu_close_clear_cancel,
                "STOP ALARM",
                stopPendingIntent
            )
            .build()
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID,
                "Alarm Service",
                NotificationManager.IMPORTANCE_HIGH
            ).apply {
                description = "Foreground service for alarm playback"
                setSound(null, null) // Disable channel sound - we play through Ringtone
                enableVibration(false) // Disable channel vibration - alarm controls its own
                setShowBadge(false)
            }
            
            val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(channel)
        }
    }

    override fun onBind(intent: Intent?): IBinder? = null
    
    override fun onDestroy() {
        android.util.Log.i("AlarmService", "onDestroy called")
        stopAlarm()
        super.onDestroy()
    }
}