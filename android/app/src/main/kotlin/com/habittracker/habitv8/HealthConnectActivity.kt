package com.habittracker.habitv8

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.util.Log
import androidx.activity.ComponentActivity
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
    
    // Define all required permissions including background permission
    private val permissions = setOf(
        HealthPermission.getReadPermission(StepsRecord::class),
        HealthPermission.getReadPermission(ActiveCaloriesBurnedRecord::class),
        HealthPermission.getReadPermission(TotalCaloriesBurnedRecord::class),
        HealthPermission.getReadPermission(SleepSessionRecord::class),
        HealthPermission.getReadPermission(HydrationRecord::class),
        HealthPermission.getReadPermission(WeightRecord::class),
        HealthPermission.getReadPermission(HeartRateRecord::class),
        BACKGROUND_HEALTH_PERMISSION
    )
    
    // Create the permission launcher using the new Health Connect API
    private val requestPermissionLauncher = registerForActivityResult(
        PermissionController.createRequestPermissionResultContract()
    ) { granted ->
        val allGranted = granted.containsAll(permissions)
        val backgroundGranted = granted.contains(BACKGROUND_HEALTH_PERMISSION)
        
        Log.i(TAG, "Permission request completed")
        Log.i(TAG, "All permissions granted: $allGranted")
        Log.i(TAG, "Background permission granted: $backgroundGranted")
        
        // Always finish the activity after permission request
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
        
        // Check and request permissions
        lifecycleScope.launch {
            try {
                val grantedPermissions = healthConnectClient.permissionController.getGrantedPermissions()
                
                if (grantedPermissions.containsAll(permissions)) {
                    Log.i(TAG, "All permissions already granted")
                    finish()
                } else {
                    Log.i(TAG, "Requesting permissions: ${permissions.joinToString()}")
                    requestPermissionLauncher.launch(permissions)
                }
            } catch (e: Exception) {
                Log.e(TAG, "Error checking permissions", e)
                finish()
            }
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
}
