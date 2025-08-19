package com.habittracker.habitv8

import android.content.Intent
import android.content.SharedPreferences
import android.os.Build
import android.os.Bundle
import androidx.core.view.WindowCompat
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterFragmentActivity() {
    private val CHANNEL = "com.habittracker.habitv8/health_service"
    private lateinit var sharedPreferences: SharedPreferences
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        // Initialize shared preferences
        sharedPreferences = getSharedPreferences("com.habittracker.habitv8.health", MODE_PRIVATE)
        
        // Enable edge-to-edge display for Android 15+ compatibility
        // This addresses the deprecated API warning from Google Play Store
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            // For Android 11+ (API 30+), use the modern edge-to-edge API
            WindowCompat.setDecorFitsSystemWindows(window, false)
        } else {
            // For older versions, maintain compatibility
            @Suppress("DEPRECATION")
            window.statusBarColor = android.graphics.Color.TRANSPARENT
            @Suppress("DEPRECATION")
            window.navigationBarColor = android.graphics.Color.TRANSPARENT
        }
        
        // Start health monitoring service if enabled
        if (sharedPreferences.getBoolean("health_monitoring_enabled", false)) {
            startHealthMonitoringService()
        }
    }
    
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        // Register our minimal health plugin
        flutterEngine.plugins.add(MinimalHealthPlugin())
        
        // Set up method channel for controlling the health monitoring service
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "startHealthMonitoring" -> {
                    startHealthMonitoringService()
                    sharedPreferences.edit().putBoolean("health_monitoring_enabled", true).apply()
                    result.success(true)
                }
                "stopHealthMonitoring" -> {
                    stopHealthMonitoringService()
                    sharedPreferences.edit().putBoolean("health_monitoring_enabled", false).apply()
                    result.success(true)
                }
                "isHealthMonitoringRunning" -> {
                    result.success(sharedPreferences.getBoolean("health_monitoring_enabled", false))
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
    
    private fun startHealthMonitoringService() {
        HealthMonitoringService.startService(this)
    }
    
    private fun stopHealthMonitoringService() {
        HealthMonitoringService.stopService(this)
    }
}