import 'package:flutter/material.dart';
import 'lib/services/health_service.dart';
import 'lib/services/minimal_health_channel.dart';
import 'lib/services/logging_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  AppLogger.info('=== Heart Rate Permission Debug Test ===');
  
  try {
    // Test 1: Initialize health service
    AppLogger.info('\n1. Testing Health Service Initialization...');
    final initialized = await HealthService.initialize();
    AppLogger.info('Health service initialized: $initialized');
    
    // Test 2: Check if Health Connect is available
    AppLogger.info('\n2. Testing Health Connect Availability...');
    final available = await MinimalHealthChannel.isHealthConnectAvailable();
    AppLogger.info('Health Connect available: $available');
    
    // Test 3: Check current permissions status
    AppLogger.info('\n3. Testing Current Permission Status...');
    final hasPermissions = await HealthService.hasPermissions();
    AppLogger.info('Has permissions: $hasPermissions');
    
    // Test 4: Get supported data types
    AppLogger.info('\n4. Testing Supported Data Types...');
    final supportedTypes = MinimalHealthChannel.getSupportedDataTypes();
    AppLogger.info('Supported data types: $supportedTypes');
    AppLogger.info('Heart rate included: ${supportedTypes.contains('HEART_RATE')}');
    
    // Test 5: Request permissions
    AppLogger.info('\n5. Testing Permission Request...');
    final granted = await HealthService.requestPermissions();
    AppLogger.info('Permissions granted: $granted');
    
    // Test 6: Verify permissions after request
    AppLogger.info('\n6. Testing Permission Verification...');
    final hasPermissionsAfter = await HealthService.hasPermissions();
    AppLogger.info('Has permissions after request: $hasPermissionsAfter');
    
    // Test 7: Try to get heart rate data
    AppLogger.info('\n7. Testing Heart Rate Data Access...');
    try {
      final heartRate = await HealthService.getLatestHeartRate();
      AppLogger.info('Latest heart rate: ${heartRate ?? 'No data available'}');
    } catch (e) {
      AppLogger.error('Error getting heart rate data', e);
    }
    
    // Test 8: Try to get resting heart rate
    AppLogger.info('\n8. Testing Resting Heart Rate Data Access...');
    try {
      final restingHR = await HealthService.getRestingHeartRateToday();
      AppLogger.info('Resting heart rate today: ${restingHR ?? 'No data available'}');
    } catch (e) {
      AppLogger.error('Error getting resting heart rate data', e);
    }
    
    AppLogger.info('\n=== Heart Rate Permission Debug Test Complete ===');
    
  } catch (e) {
    AppLogger.error('Error during heart rate permission debug test', e);
  }
}