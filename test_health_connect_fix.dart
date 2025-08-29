import 'package:flutter/services.dart';

/// Test script to verify Health Connect compatibility fix
/// Run this to test if the HeartRateRecord compatibility issue is resolved
void main() async {
  print('🔍 Testing Health Connect Compatibility Fix...\n');

  const platform = MethodChannel('minimal_health_service');

  try {
    // Test 1: Check if Health Connect is available
    print('Test 1: Checking Health Connect availability...');
    final isAvailable = await platform.invokeMethod('isHealthConnectAvailable');
    print('✅ Health Connect available: $isAvailable\n');

    // Test 2: Get Health Connect status
    print('Test 2: Getting Health Connect status...');
    final status = await platform.invokeMethod('getHealthConnectStatus');
    print('✅ Health Connect status: $status\n');

    // Test 3: Check permissions
    print('Test 3: Checking health permissions...');
    final hasPermissions = await platform.invokeMethod('hasPermissions');
    print('✅ Has permissions: $hasPermissions\n');

    // Test 4: Test HeartRate data retrieval (the problematic one)
    print('Test 4: Testing HeartRate data retrieval...');
    final now = DateTime.now().millisecondsSinceEpoch;
    final weekAgo = now - (7 * 24 * 60 * 60 * 1000);

    try {
      final heartRateData = await platform.invokeMethod('getHealthData', {
        'dataType': 'HEART_RATE',
        'startDate': weekAgo,
        'endDate': now,
      });

      print('✅ HeartRate data retrieved successfully!');
      print('   Records count: ${heartRateData.length}');
      if (heartRateData.isNotEmpty) {
        print('   Sample record: ${heartRateData.first}');
      }
      print('');
    } catch (e) {
      print('❌ HeartRate data retrieval failed: $e\n');
    }

    // Test 5: Test other data types to ensure they still work
    print('Test 5: Testing other data types...');
    final dataTypes = ['STEPS', 'SLEEP_IN_BED', 'WATER'];

    for (final dataType in dataTypes) {
      try {
        final data = await platform.invokeMethod('getHealthData', {
          'dataType': dataType,
          'startDate': weekAgo,
          'endDate': now,
        });
        print('✅ $dataType: ${data.length} records');
      } catch (e) {
        print('❌ $dataType failed: $e');
      }
    }

    print('\n🎉 Health Connect compatibility test completed!');
    print(
        'If HeartRate data retrieval succeeded without NoSuchMethodError, the fix is working.');
  } catch (e) {
    print('❌ Test failed with error: $e');
    print(
        'This might indicate the Health Connect client is not properly initialized.');
  }
}
