package com.habittracker.habitv8

import android.app.*
import android.content.Context
import android.content.Intent
import android.media.AudioAttributes
import android.media.Ringtone
import android.media.RingtoneManager
import android.net.Uri
import android.os.Build
import android.os.IBinder
import androidx.core.app.NotificationCompat

class AlarmService : Service() {
    companion object {
        private const val CHANNEL_ID = "alarm_service_channel"
        private const val NOTIFICATION_ID = 999999
        private var currentRingtone: Ringtone? = null
        private var isServiceRunning = false
        
        fun startAlarmService(context: Context, soundUri: String?, habitName: String?) {
            if (isServiceRunning) return
            
            val intent = Intent(context, AlarmService::class.java).apply {
                putExtra("soundUri", soundUri)
                putExtra("habitName", habitName)
                action = "START_ALARM"
            }
            
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                context.startForegroundService(intent)
            } else {
                context.startService(intent)
            }
        }
        
        fun stopAlarmService(context: Context) {
            val intent = Intent(context, AlarmService::class.java).apply {
                action = "STOP_ALARM"
            }
            context.startService(intent)
        }
    }

    override fun onCreate() {
        super.onCreate()
        createNotificationChannel()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
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
        return START_NOT_STICKY
    }

    private fun startAlarm(soundUri: String?, habitName: String) {
        isServiceRunning = true
        
        // Create foreground notification
        val notification = createAlarmNotification(habitName)
        startForeground(NOTIFICATION_ID, notification)
        
        // Start playing alarm sound
        try {
            val uri = if (soundUri != null && soundUri != "default") {
                Uri.parse(soundUri)
            } else {
                RingtoneManager.getDefaultUri(RingtoneManager.TYPE_ALARM)
            }
            
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
                
                // Gradually increase volume
                startVolumeIncrease(ringtone)
            }
        } catch (e: Exception) {
            android.util.Log.e("AlarmService", "Error starting alarm: ${e.message}")
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
        try {
            currentRingtone?.stop()
            currentRingtone = null
            isServiceRunning = false
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
            }
            
            val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(channel)
        }
    }

    override fun onBind(intent: Intent?): IBinder? = null
}