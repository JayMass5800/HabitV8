 Here are precise, up-to-date instructions for connecting your Android app to the Health Connect API, complete with code examples and explanations. As of late 2025, Health Connect is integrated directly into the Android framework starting from Android 14 (API level 34).

1. Setting Up Your Project
First, you need to configure your app's build.gradle.kts (or build.gradle) file and your AndroidManifest.xml.

Add Dependencies
In your module-level build.gradle.kts file, add the dependency for the Health Connect client library.

Kotlin

// build.gradle.kts (Module :app)

dependencies {
    // ... other dependencies
    implementation("androidx.health.connect:connect-client:1.1.0-alpha07")
}
Declare Permissions in the Manifest
You must declare the specific read/write permissions your app needs in the AndroidManifest.xml. Users will grant these permissions through a centralized Health Connect screen.

For example, if your app needs to read steps and write heart rate data, you would add:

XML

<manifest ...>
    <uses-permission android:name="android.permission.health.READ_STEPS" />
    <uses-permission android:name="android.permission.health.WRITE_HEART_RATE" />
    <application ...>
        <activity
            android:name=".HealthConnectActivity"
            android:exported="true">
            <intent-filter>
                <action android:name="androidx.health.ACTION_SHOW_PERMISSIONS_RATIONALE" />
            </intent-filter>
        </activity>
    </application>
</manifest>
You also need to declare a specific activity to handle the permission rationale intent, which explains why your app needs access.

2. Checking Availability and Requesting Permissions
Before performing any operations, you must check if Health Connect is available on the device and request the necessary permissions from the user.

Step 1: Get the HealthConnectClient
The HealthConnectClient is your main entry point to the API. It's best to instantiate it once and reuse it.

Kotlin

val healthConnectClient by lazy { HealthConnectClient.getOrCreate(context) }
Step 2: Check Availability
Verify that Health Connect is installed and available.

Kotlin

fun checkAvailability() {
    val availabilityStatus = HealthConnectClient.getSdkStatus(context)
    if (availabilityStatus == HealthConnectClient.SDK_UNAVAILABLE) {
        return // API is not available on this device
    }
    if (availabilityStatus == HealthConnectClient.SDK_UNAVAILABLE_PROVIDER_UPDATE_REQUIRED) {
        // Optional: Redirect user to update Health Connect on the Play Store
        val uri = "market://details?id=com.google.android.apps.healthdata&url=healthconnect%3A%2F%2Fonboarding"
        context.startActivity(Intent(Intent.ACTION_VIEW, Uri.parse(uri)))
        return
    }
    // Health Connect is available, proceed to check permissions
}
Step 3: Check and Request Permissions
This is the most critical step. You create a set of permissions your app needs and launch a contract to request them.

Kotlin

import androidx.activity.result.contract.ActivityResultContracts
import androidx.health.connect.client.HealthConnectClient
import androidx.health.connect.client.permission.HealthPermission
import androidx.health.connect.client.records.HeartRateRecord
import androidx.health.connect.client.records.StepsRecord

// Set of permissions to request
val PERMISSIONS =
    setOf(
        HealthPermission.getReadPermission(StepsRecord::class),
        HealthPermission.getWritePermission(HeartRateRecord::class)
    )

// Create an ActivityResultLauncher to handle the permission result
val requestPermissionActivityContract = ActivityResultContracts.RequestMultiplePermissions()

val requestPermissions = registerForActivityResult(requestPermissionActivityContract) { granted ->
    if (granted.all { it.value }) {
        // Permissions were granted, you can now read/write data
        Log.d("HealthConnect", "All permissions granted!")
    } else {
        // Permissions were denied, handle this case gracefully
        Log.e("HealthConnect", "Permissions denied.")
    }
}

// Function to check and request permissions
suspend fun checkAndRequestPermissions() {
    val granted = healthConnectClient.permissionController.getGrantedPermissions()
    if (granted.containsAll(PERMISSIONS)) {
        // All permissions are already granted
        Log.d("HealthConnect", "Permissions already granted.")
    } else {
        // Launch the permission request screen
        requestPermissions.launch(PERMISSIONS)
    }
}
3. Writing Data to Health Connect
Writing data involves creating a list of Record objects and passing them to the client.

Example: Writing a Heart Rate Record
Let's say you want to record a heart rate measurement. Each record needs a start time, end time, and the relevant data points.

Kotlin

import androidx.health.connect.client.records.HeartRateRecord
import androidx.health.connect.client.records.metadata.DataOrigin
import androidx.health.connect.client.records.metadata.Metadata
import java.time.Instant

suspend fun writeHeartRateData() {
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
            metadata = Metadata(dataOrigin = DataOrigin(packageName = "com.yourapp.package_name"))
        )

        val records = listOf(heartRateRecord)
        val response = healthConnectClient.insertRecords(records)
        Log.d("HealthConnect", "Successfully inserted ${response.recordIdsList.size} records.")

    } catch (e: Exception) {
        Log.e("HealthConnect", "Error writing heart rate data: ${e.message}")
    }
}
Explanation:

HeartRateRecord: The specific class for heart rate data. Other types include StepsRecord, DistanceRecord, SleepSessionRecord, etc.

Sample: Represents a single data point within a time interval.

Metadata: Essential for tracking the source of the data. You must provide your app's package name in the DataOrigin.

4. Reading Data from Health Connect
Reading data involves creating a ReadRecordsRequest specifying the record type and the time range you're interested in.

Example: Reading Step Count for Today
Here’s how to read the total number of steps taken today.

Kotlin

import androidx.health.connect.client.request.ReadRecordsRequest
import androidx.health.connect.client.records.StepsRecord
import androidx.health.connect.client.time.TimeRangeFilter
import java.time.Instant
import java.time.ZonedDateTime

suspend fun readStepsToday() {
    try {
        val startOfDay = ZonedDateTime.now().toLocalDate().atStartOfDay(ZonedDateTime.now().zone).toInstant()
        val now = Instant.now()

        val request = ReadRecordsRequest(
            recordType = StepsRecord::class,
            timeRangeFilter = TimeRangeFilter.between(startOfDay, now)
        )

        val response = healthConnectClient.readRecords(request)
        for (record in response.records) {
            val stepCount = record.count
            val startTime = record.startTime
            val endTime = record.endTime
            Log.d("HealthConnect", "Steps: $stepCount between $startTime and $endTime")
        }
    } catch (e: Exception) {
        Log.e("HealthConnect", "Error reading steps data: ${e.message}")
    }
}
Explanation:

ReadRecordsRequest: The object used to define your query. You specify the recordType and a timeRangeFilter.

TimeRangeFilter: Defines the period for which you want to retrieve data. Here, we query from the beginning of today until the current moment.

The result is a list of StepsRecord objects, which you can iterate through to process the data.