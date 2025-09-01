package com.habittracker.habitv8

import android.Manifest
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Bundle
import android.util.Log
import androidx.activity.ComponentActivity
import androidx.activity.result.contract.ActivityResultContracts
import androidx.core.content.ContextCompat
import androidx.health.connect.client.HealthConnectClient
import androidx.health.connect.client.PermissionController
import androidx.health.connect.client.permission.HealthPermission
import androidx.health.connect.client.records.ActiveCaloriesBurnedRecord
import androidx.health.connect.client.records.HeartRateRecord
import androidx.health.connect.client.records.HydrationRecord
import androidx.health.connect.client.records.SleepSessionRecord
import androidx.health.connect.client.records.StepsRecord
import androidx.health.connect.client.records.TotalCaloriesBurnedRecord
import androidx.health.connect.client.records.WeightRecord
import androidx.health.connect.client.records.MindfulnessSessionRecord
import androidx.lifecycle.lifecycleScope
import kotlinx.coroutines.launch

/**
 * Health Connect Activity for handling permission requests
 * 
 * This activity is launched to request Health Connect permissions
 * using the proper Health Connect API patterns for Android 14+.
 */
class HealthConnectActivity : ComponentActivity() {
    companion object {
        private const val TAG = "HealthConnectActivity"
        
        // Background permission constant
        private const val BACKGROUND_HEALTH_PERMISSION = "android.permission.health.READ_HEALTH_DATA_IN_BACKGROUND"
    }
    
    // Use the permissions from MinimalHealthPlugin
    private val permissions = getHealthPermissions()
    
    // Create the permission launcher using the new Health Connect API
    private val requestPermissionLauncher = registerForActivityResult(
        PermissionController.createRequestPermissionResultContract()
    ) { granted ->
        val allGranted = granted.containsAll(permissions)
        
        Log.i(TAG, "Health Connect permission request completed")
        Log.i(TAG, "Granted permissions: ${granted.size}")
        Log.i(TAG, "All health permissions granted: $allGranted")
        
        granted.forEach { permission ->
            Log.i(TAG, "  ✅ $permission")
        }
        
        // After Health Connect permissions, request activity recognition
        requestActivityRecognitionPermission()
    }
    
    // Create launcher for activity recognition permission
    private val activityRecognitionLauncher = registerForActivityResult(
        ActivityResultContracts.RequestPermission()
    ) { granted ->
        Log.i(TAG, "Activity recognition permission granted: $granted")
        
        // Always finish the activity after all permission requests
        finish()
    }
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        Log.i(TAG, "HealthConnectActivity created")
        
        // Check if Health Connect is available
        val availabilityStatus = HealthConnectClient.getSdkStatus(this)
        Log.i(TAG, "Health Connect SDK status: $availabilityStatus")
        
        when (availabilityStatus) {
            HealthConnectClient.SDK_UNAVAILABLE -> {
                Log.e(TAG, "Health Connect is not available on this device")
                showHealthConnectUnavailable()
                return
            }
            HealthConnectClient.SDK_UNAVAILABLE_PROVIDER_UPDATE_REQUIRED -> {
                Log.w(TAG, "Health Connect provider update required")
                redirectToPlayStore()
                return
            }
        }
        
        // Get Health Connect client
        val healthConnectClient = HealthConnectClient.getOrCreate(this)
        
        // Check feature availability and request permissions
        lifecycleScope.launch {
            try {
                // Check if mindfulness feature is available
                try {
                    val features = healthConnectClient.features
                    Log.i(TAG, "Health Connect features available: $features")
                    Log.i(TAG, "Note: Mindfulness feature support will be determined during permission request")
                } catch (e: Exception) {
                    Log.w(TAG, "Could not check Health Connect features: ${e.message}")
                }
                
                val grantedPermissions = healthConnectClient.permissionController.getGrantedPermissions()
                
                Log.i(TAG, "Currently granted permissions (${grantedPermissions.size}):")
                grantedPermissions.forEach { permission ->
                    Log.i(TAG, "  ✅ $permission")
                }
                
                Log.i(TAG, "Permissions we want to request (${permissions.size}):")
                permissions.forEach { permission ->
                    val isGranted = grantedPermissions.contains(permission)
                    Log.i(TAG, "  ${if (isGranted) "✅" else "❌"} $permission")
                }
                
                if (grantedPermissions.containsAll(permissions)) {
                    Log.i(TAG, "All health permissions already granted")
                    // Still need to check activity recognition permission
                    requestActivityRecognitionPermission()
                } else {
                    Log.i(TAG, "Requesting ${permissions.size} permissions via Health Connect dialog")
                    Log.i(TAG, "About to launch Health Connect permission dialog with these permissions:")
                    permissions.forEach { permission ->
                        Log.i(TAG, "  🔑 $permission")
                    }
                    requestPermissionLauncher.launch(permissions)
                }
            } catch (e: Exception) {
                Log.e(TAG, "Error checking permissions", e)
                finish()
            }
        }
    }
    
    private fun requestActivityRecognitionPermission() {
        // Check if activity recognition permission is already granted
        val hasPermission = ContextCompat.checkSelfPermission(
            this,
            Manifest.permission.ACTIVITY_RECOGNITION
        ) == PackageManager.PERMISSION_GRANTED
        
        if (hasPermission) {
            Log.i(TAG, "Activity recognition permission already granted")
            finish()
        } else {
            Log.i(TAG, "Requesting activity recognition permission")
            activityRecognitionLauncher.launch(Manifest.permission.ACTIVITY_RECOGNITION)
        }
    }
    
    private fun showHealthConnectUnavailable() {
        // In a real app, you might show a dialog here
        Log.e(TAG, "Health Connect is not available on this device")
        finish()
    }
    
    private fun redirectToPlayStore() {
        try {
            // Use the recommended deep link format for Health Connect
            val uriString = "market://details?id=com.google.android.apps.healthdata&url=healthconnect%3A%2F%2Fonboarding"
            val intent = Intent(Intent.ACTION_VIEW).apply {
                setPackage("com.android.vending")
                data = Uri.parse(uriString)
                putExtra("overlay", true)
                putExtra("callerId", packageName)
            }
            startActivity(intent)
        } catch (e: Exception) {
            Log.e(TAG, "Failed to redirect to Play Store", e)
        }
        finish()
    }
    
    // Get health permissions using the same logic as MinimalHealthPlugin
    private fun getHealthPermissions(): Set<String> {
        val permissions = mutableSetOf<String>()
        
        // Add each permission individually to help with debugging
        try {
            permissions.add(HealthPermission.getReadPermission(StepsRecord::class))
            permissions.add(HealthPermission.getReadPermission(ActiveCaloriesBurnedRecord::class))
            permissions.add(HealthPermission.getReadPermission(TotalCaloriesBurnedRecord::class))
            permissions.add(HealthPermission.getReadPermission(SleepSessionRecord::class))
            permissions.add(HealthPermission.getReadPermission(HydrationRecord::class))
            permissions.add(HealthPermission.getReadPermission(WeightRecord::class))
            permissions.add(HealthPermission.getReadPermission(HeartRateRecord::class))
            
            // Add background health permission - CRITICAL for background monitoring
            permissions.add("android.permission.health.READ_HEALTH_DATA_IN_BACKGROUND")
            Log.i(TAG, "Added background health permission")
            
            // Add mindfulness permission directly - no reflection needed
            permissions.add("android.permission.health.READ_MINDFULNESS")
            Log.i(TAG, "Added mindfulness permission directly")
            
            // Also try to add MindfulnessSessionRecord permission using reflection as backup
            try {
                val mindfulnessClass = Class.forName("androidx.health.connect.client.records.MindfulnessSessionRecord").kotlin as kotlin.reflect.KClass<out androidx.health.connect.client.records.Record>
                permissions.add(HealthPermission.getReadPermission(mindfulnessClass))
                Log.i(TAG, "Added MindfulnessSessionRecord permission via reflection")
            } catch (e: ClassNotFoundException) {
                Log.w(TAG, "MindfulnessSessionRecord permission not available via reflection: ${e.message}")
            } catch (e: Exception) {
                Log.e(TAG, "Error adding MindfulnessSessionRecord permission via reflection: ${e.message}", e)
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error creating health permissions", e)
        }
        
        Log.i(TAG, "Total permissions configured: ${permissions.size}")
        permissions.forEach { permission ->
            Log.i(TAG, "  - Permission: $permission")
        }
        return permissions.toSet()
    }
}

