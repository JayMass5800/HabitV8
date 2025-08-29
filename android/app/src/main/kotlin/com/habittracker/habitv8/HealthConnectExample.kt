package com.habittracker.habitv8

import android.content.Context
import android.util.Log
import androidx.health.connect.client.HealthConnectClient
import androidx.health.connect.client.permission.HealthPermission
import androidx.health.connect.client.records.HeartRateRecord
import androidx.health.connect.client.records.StepsRecord
import androidx.health.connect.client.records.metadata.DataOrigin
import androidx.health.connect.client.records.metadata.Metadata
import androidx.health.connect.client.request.ReadRecordsRequest
import androidx.health.connect.client.time.TimeRangeFilter
import java.time.Instant
import java.time.ZonedDateTime

/**
 * Example implementation following the exact Health Connect API instructions from error2.md
 * 
 * This class demonstrates the proper way to:
 * 1. Check Health Connect availability
 * 2. Request permissions
 * 3. Read data from Health Connect
 * 4. Write data to Health Connect
 */
class HealthConnectExample(private val context: Context) {
    
    companion object {
        private const val TAG = "HealthConnectExample"
    }
    
    // Health Connect client - lazy initialization as per instructions
    private val healthConnectClient by lazy { HealthConnectClient.getOrCreate(context) }
    
    // Set of permissions to request as per instructions
    private val PERMISSIONS = setOf(
        HealthPermission.getReadPermission(StepsRecord::class),
        HealthPermission.getWritePermission(HeartRateRecord::class)
    )
    
    /**
     * Check availability as per Health Connect API instructions
     */
    fun checkAvailability(): Boolean {
        val availabilityStatus = HealthConnectClient.getSdkStatus(context)
        
        when (availabilityStatus) {
            HealthConnectClient.SDK_UNAVAILABLE -> {
                Log.e(TAG, "Health Connect SDK is unavailable")
                return false
            }
            HealthConnectClient.SDK_UNAVAILABLE_PROVIDER_UPDATE_REQUIRED -> {
                Log.w(TAG, "Health Connect provider update required")
                // Optional: Redirect user to update Health Connect on the Play Store
                // val uri = "market://details?id=com.google.android.apps.healthdata&url=healthconnect%3A%2F%2Fonboarding"
                // context.startActivity(Intent(Intent.ACTION_VIEW, Uri.parse(uri)))
                return false
            }
            else -> {
                Log.i(TAG, "Health Connect is available")
                return true
            }
        }
    }
    
    /**
     * Check and request permissions as per Health Connect API instructions
     */
    suspend fun checkAndRequestPermissions(): Boolean {
        try {
            val granted = healthConnectClient.permissionController.getGrantedPermissions()
            
            if (granted.containsAll(PERMISSIONS)) {
                Log.d(TAG, "Permissions already granted.")
                return true
            } else {
                Log.i(TAG, "Permissions need to be requested")
                // In a real implementation, you would launch the permission request here
                // This example just returns false to indicate permissions are needed
                return false
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error checking permissions", e)
            return false
        }
    }
    
    /**
     * Write heart rate data as per Health Connect API instructions
     */
    suspend fun writeHeartRateData(): Boolean {
        try {
            val startTime = Instant.now().minusSeconds(10)
            val endTime = Instant.now()

            val samples = listOf(
                HeartRateRecord.Sample(time = startTime, beatsPerMinute = 85L),
                HeartRateRecord.Sample(time = endTime, beatsPerMinute = 88L)
            )

            val heartRateRecord = HeartRateRecord(
                startTime = startTime,
                startZoneOffset = null,
                endTime = endTime,
                endZoneOffset = null,
                samples = samples,
                metadata = Metadata(dataOrigin = DataOrigin(packageName = context.packageName))
            )

            val records = listOf(heartRateRecord)
            val response = healthConnectClient.insertRecords(records)
            Log.d(TAG, "Successfully inserted ${response.recordIdsList.size} records.")
            return true

        } catch (e: Exception) {
            Log.e(TAG, "Error writing heart rate data: ${e.message}")
            return false
        }
    }
    
    /**
     * Read step count for today as per Health Connect API instructions
     */
    suspend fun readStepsToday(): Int {
        try {
            val startOfDay = ZonedDateTime.now().toLocalDate().atStartOfDay(ZonedDateTime.now().zone).toInstant()
            val now = Instant.now()

            val request = ReadRecordsRequest(
                recordType = StepsRecord::class,
                timeRangeFilter = TimeRangeFilter.between(startOfDay, now)
            )

            val response = healthConnectClient.readRecords(request)
            var totalSteps = 0L
            
            for (record in response.records) {
                val stepCount = record.count
                val startTime = record.startTime
                val endTime = record.endTime
                Log.d(TAG, "Steps: $stepCount between $startTime and $endTime")
                totalSteps += stepCount
            }
            
            Log.i(TAG, "Total steps today: $totalSteps")
            return totalSteps.toInt()
            
        } catch (e: Exception) {
            Log.e(TAG, "Error reading steps data: ${e.message}")
            return 0
        }
    }
}