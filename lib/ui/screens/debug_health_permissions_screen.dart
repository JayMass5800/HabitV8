import 'package:flutter/material.dart';
import '../../services/health_service.dart';
import '../../services/logging_service.dart';

/// Debug screen to test health permissions
class DebugHealthPermissionsScreen extends StatefulWidget {
  const DebugHealthPermissionsScreen({super.key});

  @override
  State<DebugHealthPermissionsScreen> createState() =>
      _DebugHealthPermissionsScreenState();
}

class _DebugHealthPermissionsScreenState
    extends State<DebugHealthPermissionsScreen> {
  Map<String, bool>? _permissionResults;
  bool _isLoading = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Debug Health Permissions'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Health Permissions Test',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'This screen tests the critical health permissions:\n'
              '• HEART_RATE\n'
              '• ACTIVE_ENERGY_BURNED\n'
              '• TOTAL_CALORIES_BURNED',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _testPermissions,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Test Permissions'),
            ),
            const SizedBox(height: 24),
            if (_error != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red),
                ),
                child: Text(
                  'Error: $_error',
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            if (_permissionResults != null) ...[
              const Text(
                'Permission Test Results:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView(
                  children: _permissionResults!.entries.map((entry) {
                    final isGranted = entry.value;
                    return Card(
                      child: ListTile(
                        leading: Icon(
                          isGranted ? Icons.check_circle : Icons.error,
                          color: isGranted ? Colors.green : Colors.red,
                        ),
                        title: Text(entry.key),
                        subtitle: Text(
                          isGranted
                              ? 'Permission granted and working'
                              : 'Permission denied or not working',
                        ),
                        trailing: Text(
                          isGranted ? 'SUCCESS' : 'FAILED',
                          style: TextStyle(
                            color: isGranted ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _testPermissions() async {
    setState(() {
      _isLoading = true;
      _error = null;
      _permissionResults = null;
    });

    try {
      AppLogger.info('Starting health permissions test...');

      // First check if Health Connect is available
      final isAvailable = await HealthService.isHealthConnectAvailable();
      if (!isAvailable) {
        throw Exception('Health Connect is not available on this device');
      }

      // Request permissions first
      final permissionResult = await HealthService.requestPermissions();
      if (!permissionResult.granted) {
        throw Exception(
          'Health permissions were not granted: ${permissionResult.message}',
        );
      }

      // Test critical permissions
      final results = await HealthService.testCriticalPermissions();

      setState(() {
        _permissionResults = results;
        _isLoading = false;
      });

      AppLogger.info('Health permissions test completed: $results');
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
      AppLogger.error('Health permissions test failed: $e');
    }
  }
}
