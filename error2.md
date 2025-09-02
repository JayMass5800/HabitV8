The following example shows you how to read raw data as part of the common workflow.
Tip: For further guidance on reading raw data, take a look at the Android Developer video for reading and writing data in Health Connect.
Read data
Health Connect allows apps to read data from the datastore when the app is in the foreground and background:
Foreground reads: You can normally read data from Health Connect when your app is in the foreground. In these cases, you may consider using a foreground service to run this operation in case the user or system places your app in the background during a read operation.
Background reads: By requesting an extra permission from the user, you can read data after the user or system places your app in the background. See the complete background read example.
The Steps data type in Health Connect captures the number of steps a user has taken between readings. Step counts represent a common measurement across health, fitness, and wellness platforms. Health Connect makes it simple to read and write step count data.
To read records, create a ReadRecordsRequest and supply it when you call readRecords.
Note: For cumulative types like StepsRecord, use aggregate() instead of readRecords() to avoid double counting from multiple sources and improve accuracy. See Read aggregated data for more information.
The following example shows how to read step count data for a user within a certain time. For an extended example with SensorManager, see the step count data guide.
suspend fun readHeartRateByTimeRange(
    healthConnectClient: HealthConnectClient,
    startTime: Instant,
    endTime: Instant
) {
    try {
        val response = healthConnectClient.readRecords(
            ReadRecordsRequest(
                HeartRateRecord::class,
                timeRangeFilter = TimeRangeFilter.between(startTime, endTime)
            )
        )
        for (record in response.records) {
            // Process each record
        }
    } catch (e: Exception) {
        // Run error handling here
    }
}

You can also read your data in an aggregated manner using aggregate.
suspend fun readStepsByTimeRange(
    healthConnectClient: HealthConnectClient,
    startTime: Instant,
    endTime: Instant
) {
    try {
        val response = healthConnectClient.aggregate(
            AggregateRequest(
                metrics = setOf(StepsRecord.COUNT_TOTAL),
                timeRangeFilter = TimeRangeFilter.between(startTime, endTime)
            )
        )
        // The result may be null if no data is available in the time range
        val stepCount = response[StepsRecord.COUNT_TOTAL]
    } catch (e: Exception) {
        // Run error handling here
    }
}

Note: If you're interested in obtaining calculated data such as averages and totals, it is recommended to use aggregation. You can set smaller time slices whenever you aggregate. The aggregation API also contains logic to handle duplicate records, and lessens the chances of rate limiting.
Background read example
To read data in the background, declare the following permission in your manifest file:
<application>
  <uses-permission android:name="android.permission.health.READ_HEALTH_DATA_IN_BACKGROUND" />
...
</application>

The following example shows how to read step count data in the background for a user within a certain time by using WorkManager:
class ScheduleWorker(private val appContext: Context, workerParams: WorkerParameters):
    CoroutineWorker(appContext, workerParams) {

    override suspend fun doWork(): Result {
        // Read data and process it.
        ...

        // Return success indicating successful data retrieval
        return Result.success()
    }
}

if (healthConnectClient
    .features
    .getFeatureStatus(
    HealthConnectFeatures.FEATURE_READ_HEALTH_DATA_IN_BACKGROUND
    ) == HealthConnectFeatures.FEATURE_STATUS_AVAILABLE) {

    // Check if necessary permission is granted
    val grantedPermissions = healthConnectClient.permissionController.getGrantedPermissions()

    if (PERMISSION_READ_HEALTH_DATA_IN_BACKGROUND !in grantedPermissions) {
        // Perform read in foreground
        ...
    } else {
        // Schedule the periodic work request in background
        val periodicWorkRequest = PeriodicWorkRequestBuilder<ScheduleWorker>(1, TimeUnit.HOURS)
            .build()

        WorkManager.getInstance(context).enqueueUniquePeriodicWork(
            "read_health_connect",
            ExistingPeriodicWorkPolicy.KEEP,
            periodicWorkRequest
        )
    }
} else {
  // Background reading is not available, perform read in foreground
  ...
}

Note: If the user doesn't grant all of the permissions that are required for background reads, you app should still run, and it should perform as many tasks as it can with the permissions that the user granted.
The ReadRecordsRequest parameter has a default pageSize value of 1000. If the number of records in a single readResponse exceeds the pageSize of the request, you need to iterate over all pages of the response to retrieve all records by using pageToken. However, be careful to avoid rate-limiting concerns.
pageToken read example
It is recommended to use pageToken for reading records to retrieve all available data from the requested time period.
The following example shows how to read all records until all page tokens have been exhausted:
val type = HeartRateRecord::class
val endTime = Instant.now()
val startTime = endTime.minus(Duration.ofDays(7))

try {
    var pageToken: String? = null
    do {
        val readResponse =
            healthConnectClient.readRecords(
                ReadRecordsRequest(
                    recordType = type,
                    timeRangeFilter = TimeRangeFilter.between(
                        startTime,
                        endTime
                    ),
                    pageToken = pageToken
                )
            )
        val records = readResponse.records
        // Do something with records
        pageToken = readResponse.pageToken
    } while (pageToken != null)
} catch (quotaError: IllegalStateException) {
    // Backoff
}

For information about best practices when reading large datasets, refer to Plan to avoid rate limiting.
Read previously written data
If an app has written records to Health Connect before, it is possible for that app to read historical data. This is applicable for scenarios in which the app needs to resync with Health Connect after the user has reinstalled it.
Some read restrictions apply:
For Android 14 and higher
No historical limit on an app reading its own data.
30-day limit on an app reading other data.
For Android 13 and lower
30-day limit on app reading any data.
The restrictions can be removed by requesting a Read permission.
To read historical data, you need to indicate the package name as a DataOrigin object in the dataOriginFilter parameter of your ReadRecordsRequest.
The following example shows how to indicate a package name when reading heart rate records:
try {
    val response =  healthConnectClient.readRecords(
        ReadRecordsRequest(
            recordType = HeartRateRecord::class,
            timeRangeFilter = TimeRangeFilter.between(startTime, endTime),
            dataOriginFilter = setOf(DataOrigin("com.my.package.name"))
        )
    )
    for (record in response.records) {
        // Process each record
    }
} catch (e: Exception) {
    // Run error handling here
}

Read data older than 30 days
By default, all applications can read data from Health Connect for up to 30 days prior to when any permission was first granted.
If you need to extend read permissions beyond any of the default restrictions, request the PERMISSION_READ_HEALTH_DATA_HISTORY. Otherwise, without this permission, an attempt to read records older than 30 days results in an error.



Sign in
API reference
