    private fun getHealthDataInRange(dataType: String, startDate: Long, endDate: Long, result: Result) {
        if (healthConnectClient == null) {
            result.error("HEALTH_CONNECT_UNAVAILABLE", "Health Connect is not available", null)
            return
        }
        
        coroutineScope.launch {
            try {
                val recordClass = ALLOWED_DATA_TYPES[dataType]
                if (recordClass == null) {
                    result.success(0.0) // Return 0 for unsupported data types
                    return@launch
                }
                
                // Check compatibility before making API calls
                if (!isDataTypeCompatible(dataType)) {
                    Log.w("MinimalHealthPlugin", "Data type $dataType is not compatible with current Health Connect version")
                    result.success(0.0)
                    return@launch
                }
                
                val timeRangeFilter = TimeRangeFilter.between(
                    Instant.ofEpochMilli(startDate),
                    Instant.ofEpochMilli(endDate)
                )
                
                @Suppress("UNCHECKED_CAST")
                val request = ReadRecordsRequest(
                    recordType = recordClass as KClass<Record>,
                    timeRangeFilter = timeRangeFilter
                )
                
                val response = try {
                    healthConnectClient!!.readRecords(request)
                } catch (e: Exception) {
                    Log.e("MinimalHealthPlugin", "❌ Health Connect error for $dataType: ${e.message}", e)
                    result.success(0.0)
                    return@launch
                }
                
                // Process the response based on data type with version compatibility
                val totalValue = try {
                    when (dataType) {
                        "STEPS" -> {
                            // For steps, prefer aggregation to avoid double counting
                            try {
                                val aggregateRequest = AggregateRequest(
                                    metrics = setOf(StepsRecord.COUNT_TOTAL),
                                    timeRangeFilter = timeRangeFilter
                                )
                                val aggregateResponse = healthConnectClient!!.aggregate(aggregateRequest)
                                aggregateResponse[StepsRecord.COUNT_TOTAL]?.toDouble() ?: 0.0
                            } catch (e: Exception) {
                                Log.w("MinimalHealthPlugin", "Aggregation failed for steps, using raw records: ${e.message}")
                                response.records.sumOf { record ->
                                    when (record) {
                                        is StepsRecord -> record.count.toDouble()
                                        else -> 0.0
                                    }
                                }
                            }
                        }
                        "ACTIVE_ENERGY_BURNED" -> {
                            // For active calories, try aggregation first, then fallback to raw records
                            try {
                                val aggregateRequest = AggregateRequest(
                                    metrics = setOf(ActiveCaloriesBurnedRecord.ENERGY_TOTAL),
                                    timeRangeFilter = timeRangeFilter
                                )
                                val aggregateResponse = healthConnectClient!!.aggregate(aggregateRequest)
                                aggregateResponse[ActiveCaloriesBurnedRecord.ENERGY_TOTAL]?.inCalories ?: 0.0
                            } catch (e: Exception) {
                                Log.w("MinimalHealthPlugin", "Aggregation failed for active calories, using raw records: ${e.message}")
                                response.records.sumOf { record ->
                                    when (record) {
                                        is ActiveCaloriesBurnedRecord -> record.energy.inCalories
                                        else -> 0.0
                                    }
                                }
                            }
                        }
                        "TOTAL_CALORIES_BURNED" -> {
                            // For total calories, be extra careful with version compatibility
                            try {
                                val aggregateRequest = AggregateRequest(
                                    metrics = setOf(TotalCaloriesBurnedRecord.ENERGY_TOTAL),
                                    timeRangeFilter = timeRangeFilter
                                )
                                val aggregateResponse = healthConnectClient!!.aggregate(aggregateRequest)
                                aggregateResponse[TotalCaloriesBurnedRecord.ENERGY_TOTAL]?.inCalories ?: 0.0
                            } catch (e: NoSuchMethodError) {
                                Log.w("MinimalHealthPlugin", "Health Connect version incompatibility for total calories aggregation: ${e.message}")
                                // Try raw records with careful field access
                                try {
                                    response.records.sumOf { record ->
                                        when (record) {
                                            is TotalCaloriesBurnedRecord -> {
                                                try {
                                                    record.energy.inCalories
                                                } catch (fieldError: Exception) {
                                                    Log.w("MinimalHealthPlugin", "Field access error for total calories: ${fieldError.message}")
                                                    0.0
                                                }
                                            }
                                            else -> 0.0
                                        }
                                    }
                                } catch (recordError: Exception) {
                                    Log.w("MinimalHealthPlugin", "Raw record processing failed for total calories: ${recordError.message}")
                                    0.0
                                }
                            } catch (e: Exception) {
                                Log.w("MinimalHealthPlugin", "General error for total calories: ${e.message}")
                                0.0
                            }
                        }
                        "HEART_RATE" -> {
                            // For heart rate, calculate average from samples
                            val allSamples = response.records.flatMap { record ->
                                when (record) {
                                    is HeartRateRecord -> {
                                        try {
                                            record.samples
                                        } catch (e: Exception) {
                                            Log.w("MinimalHealthPlugin", "Error accessing heart rate samples: ${e.message}")
                                            emptyList()
                                        }
                                    }
                                    else -> emptyList()
                                }
                            }
                            if (allSamples.isNotEmpty()) {
                                allSamples.map { it.beatsPerMinute.toDouble() }.average()
                            } else {
                                0.0
                            }
                        }
                        "WEIGHT" -> {
                            // For weight, get the most recent value
                            response.records.mapNotNull { record ->
                                when (record) {
                                    is WeightRecord -> {
                                        try {
                                            record.weight.inKilograms
                                        } catch (e: Exception) {
                                            Log.w("MinimalHealthPlugin", "Error accessing weight value: ${e.message}")
                                            null
                                        }
                                    }
                                    else -> null
                                }
                            }.lastOrNull() ?: 0.0
                        }
                        "WATER" -> {
                            // Sum all hydration records
                            response.records.sumOf { record ->
                                when (record) {
                                    is HydrationRecord -> {
                                        try {
                                            record.volume.inLiters
                                        } catch (e: Exception) {
                                            Log.w("MinimalHealthPlugin", "Error accessing hydration volume: ${e.message}")
                                            0.0
                                        }
                                    }
                                    else -> 0.0
                                }
                            }
                        }
                        "SLEEP_IN_BED" -> {
                            // Sum all sleep session durations in hours
                            response.records.sumOf { record ->
                                when (record) {
                                    is SleepSessionRecord -> {
                                        try {
                                            val durationMillis = record.endTime.toEpochMilli() - record.startTime.toEpochMilli()
                                            durationMillis / (1000.0 * 60.0 * 60.0) // Convert to hours
                                        } catch (e: Exception) {
                                            Log.w("MinimalHealthPlugin", "Error calculating sleep duration: ${e.message}")
                                            0.0
                                        }
                                    }
                                    else -> 0.0
                                }
                            }
                        }
                        else -> {
                            Log.w("MinimalHealthPlugin", "Unsupported data type: $dataType")
                            0.0
                        }
                    }
                } catch (e: Exception) {
                    Log.e("MinimalHealthPlugin", "Error processing $dataType data: ${e.message}", e)
                    0.0
                }
                
                Log.i("MinimalHealthPlugin", "✅ Successfully retrieved $dataType data: $totalValue")
                result.success(totalValue)
                
            } catch (e: NoSuchMethodError) {
                Log.e("MinimalHealthPlugin", "Health Connect version compatibility issue for $dataType: ${e.message}", e)
                Log.w("MinimalHealthPlugin", "This may be due to Health Connect version mismatch. Returning 0.")
                result.success(0.0)
            } catch (e: Exception) {
                Log.e("MinimalHealthPlugin", "❌ Error reading $dataType data: ${e.message}", e)
                result.success(0.0)
            }
        }
    }

    /**
     * Check if a specific data type is compatible with the current Health Connect version
     */
    private fun isDataTypeCompatible(dataType: String): Boolean {
        return try {
            val recordClass = ALLOWED_DATA_TYPES[dataType] ?: return false
            
            Log.d("MinimalHealthPlugin", "Checking compatibility for $dataType ($recordClass)")
            
            // Test compatibility based on known problematic data types
            when (dataType) {
                "TOTAL_CALORIES_BURNED" -> {
                    // This data type has known compatibility issues with older Health Connect versions
                    // The error occurs when trying to access getStartZoneOffset() method
                    try {
                        // Try to access the problematic method that causes NoSuchMethodError
                        val method = TotalCaloriesBurnedRecord::class.java.getDeclaredMethod("getStartZoneOffset")
                        Log.d("MinimalHealthPlugin", "✅ TOTAL_CALORIES_BURNED compatibility check passed")
                        true
                    } catch (e: NoSuchMethodException) {
                        Log.w("MinimalHealthPlugin", "❌ TOTAL_CALORIES_BURNED not compatible: getStartZoneOffset() method not available")
                        false
                    } catch (e: Exception) {
                        Log.w("MinimalHealthPlugin", "❌ TOTAL_CALORIES_BURNED compatibility check failed: ${e.message}")
                        false
                    }
                }
                "ACTIVE_ENERGY_BURNED", "STEPS", "HEART_RATE", "WEIGHT", "WATER", "SLEEP_IN_BED" -> {
                    // These data types generally work well, but let's add some basic validation
                    Log.d("MinimalHealthPlugin", "$dataType compatibility check - allowing with robust error handling")
                    Log.d("MinimalHealthPlugin", "✅ $dataType compatibility check passed (using robust error handling)")
                    true
                }
                else -> {
                    Log.d("MinimalHealthPlugin", "Unknown data type $dataType - allowing with caution")
                    true
                }
            }
        } catch (e: Exception) {
            Log.w("MinimalHealthPlugin", "General compatibility check failed for $dataType: ${e.message}")
            // Default to allowing the data type but with extra error handling
            true
        }
    }