import 'package:flutter/material.dart';
import 'lib/services/minimal_health_channel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print('Testing MINDFULNESS permission fix...');

  // Test: Check if data type is supported
  try {
    final isSupported =
        await MinimalHealthChannel.isDataTypeSupported('MINDFULNESS');
    print('✅ MINDFULNESS data type support check: $isSupported');
  } catch (e) {
    print('❌ Error checking MINDFULNESS support: $e');
  }

  // Test: Try to initialize with MINDFULNESS
  try {
    final initialized = await MinimalHealthChannel.initialize();
    print('✅ MinimalHealthChannel initialization: $initialized');
  } catch (e) {
    print('❌ Error initializing MinimalHealthChannel: $e');
  }

  print('Test completed.');
}
