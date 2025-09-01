import 'package:flutter/material.dart';
import 'package:habitv8/services/simple_health_service.dart';
import 'package:habitv8/services/logging_service.dart';

class HealthTestScreen extends StatefulWidget {
  const HealthTestScreen({super.key});

  @override
  State<HealthTestScreen> createState() => _HealthTestScreenState();
}

class _HealthTestScreenState extends State<HealthTestScreen> {
  final AppLogger _logger = AppLogger();
  bool _isLoading = false;
  Map<String, dynamic>? _permissionStatus;
  List<Map<String, dynamic>> _stepsData = [];
  List<Map<String, dynamic>> _heartRateData = [];
  List<Map<String, dynamic>> _sleepData = [];

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    setState(() => _isLoading = true);

    try {
      final status = await SimpleHealthService.checkPermissions();
      setState(() => _permissionStatus = status);
      _logger.info('Permission status updated: $status');
    } catch (e) {
      _logger.error('Failed to check permissions: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _testHealthData() async {
    setState(() => _isLoading = true);

    try {
      final endTime = DateTime.now();
      final startTime = endTime.subtract(const Duration(hours: 24));

      _logger.info('Testing health data retrieval...');

      // Get steps data
      final steps = await SimpleHealthService.getStepsData(
        startTime: startTime,
        endTime: endTime,
      );

      // Get heart rate data
      final heartRate = await SimpleHealthService.getHeartRateData(
        startTime: startTime,
        endTime: endTime,
      );

      // Get sleep data
      final sleep = await SimpleHealthService.getSleepData(
        startTime: startTime,
        endTime: endTime,
      );

      setState(() {
        _stepsData = steps;
        _heartRateData = heartRate;
        _sleepData = sleep;
      });

      _logger.info('Health data test completed');
    } catch (e) {
      _logger.error('Health data test failed: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Connect Test'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Permission Status Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Permission Status',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    if (_permissionStatus != null) ...[
                      Text(
                          'All Permissions: ${_permissionStatus!['hasAllPermissions']}'),
                      Text('Granted: ${_permissionStatus!['grantedCount']}'),
                      Text('Required: ${_permissionStatus!['requiredCount']}'),
                    ] else
                      const Text('Loading permissions...'),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _checkPermissions,
                      child: const Text('Refresh Permissions'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Test Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _testHealthData,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Test Health Data (Last 24h)'),
              ),
            ),

            const SizedBox(height: 16),

            // Results
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Steps Data
                    _buildDataCard(
                      'Steps Data',
                      _stepsData,
                      Icons.directions_walk,
                    ),

                    const SizedBox(height: 16),

                    // Heart Rate Data
                    _buildDataCard(
                      'Heart Rate Data',
                      _heartRateData,
                      Icons.favorite,
                    ),

                    const SizedBox(height: 16),

                    // Sleep Data
                    _buildDataCard(
                      'Sleep Data',
                      _sleepData,
                      Icons.bedtime,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataCard(
      String title, List<Map<String, dynamic>> data, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Records found: ${data.length}'),
            if (data.isNotEmpty) ...[
              const SizedBox(height: 8),
              const Text('Sample data:',
                  style: TextStyle(fontWeight: FontWeight.w500)),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  data.first.toString(),
                  style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
                ),
              ),
            ] else
              const Text('No data found', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
