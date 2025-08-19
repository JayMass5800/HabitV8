import 'package:flutter/material.dart';
import '../../services/health_habit_ui_service.dart';
import '../../services/health_service.dart';

/// Test screen to demonstrate the enhanced health permissions system
class HealthPermissionsTestScreen extends StatefulWidget {
  const HealthPermissionsTestScreen({super.key});

  @override
  State<HealthPermissionsTestScreen> createState() =>
      _HealthPermissionsTestScreenState();
}

class _HealthPermissionsTestScreenState
    extends State<HealthPermissionsTestScreen> {
  String _statusLog = '';

  void _addToLog(String message) {
    setState(() {
      _statusLog += '${DateTime.now().toIso8601String()}: $message\n';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Permissions Test'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enhanced Health Permissions System',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'This screen demonstrates the new health permissions system with better user guidance and automatic status detection.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),

            // Main health permissions status widget
            HealthHabitUIService.buildHealthPermissionsStatusWidget(
              context: context,
              onStatusChanged: () {
                _addToLog('Health permissions status changed');
                setState(() {}); // Refresh the screen
              },
            ),

            const SizedBox(height: 24),

            // Test buttons
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Test Actions',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              _addToLog('Testing Health Connect status...');
                              final status =
                                  await HealthService.getHealthConnectStatus();
                              _addToLog('Health Connect status: $status');
                            },
                            child: const Text('Check Status'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              _addToLog('Refreshing permissions...');
                              final result =
                                  await HealthService.refreshPermissions();
                              _addToLog(
                                'Refresh result: ${result.granted} - ${result.message}',
                              );
                              setState(() {}); // Refresh the UI
                            },
                            child: const Text('Refresh'),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              _addToLog('Requesting permissions...');
                              final result =
                                  await HealthService.requestPermissions();
                              _addToLog(
                                'Request result: ${result.granted} - ${result.message}',
                              );
                              if (result.requiresUserAction) {
                                _addToLog(
                                  'User action required: HC=${result.needsHealthConnect}, Manual=${result.needsManualSetup}',
                                );
                              }
                              setState(() {}); // Refresh the UI
                            },
                            child: const Text('Request Permissions'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              _addToLog('Opening Health Connect...');
                              final opened =
                                  await HealthConnectUtils.openHealthConnect();
                              _addToLog('Health Connect opened: $opened');
                            },
                            child: const Text('Open Health Connect'),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    ElevatedButton(
                      onPressed: () {
                        HealthHabitUIService.showHealthPermissionsDialog(
                          context,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 48),
                      ),
                      child: const Text('Show Guided Setup Dialog'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Status log
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Status Log',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _statusLog = '';
                            });
                          },
                          child: const Text('Clear'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      height: 200,
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: SingleChildScrollView(
                        child: Text(
                          _statusLog.isEmpty
                              ? 'No log entries yet...'
                              : _statusLog,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Instructions
            Card(
              color: Colors.blue[50],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info, color: Colors.blue[700]),
                        const SizedBox(width: 8),
                        Text(
                          'How to Test',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.blue[700],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '1. Check the current health permissions status above',
                    ),
                    const Text(
                      '2. Try the "Request Permissions" button to see the guided setup',
                    ),
                    const Text(
                      '3. Use "Open Health Connect" to manually configure permissions',
                    ),
                    const Text(
                      '4. Use "Refresh" to update the status after making changes',
                    ),
                    const Text(
                      '5. Watch the status log for detailed information',
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'The system now provides clear guidance for each state: not installed, installed but not configured, and fully active.',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.blue[600],
                      ),
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
}
