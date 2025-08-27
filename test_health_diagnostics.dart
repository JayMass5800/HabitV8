import 'package:flutter/material.dart';
import 'package:habitv8/services/minimal_health_channel.dart';
import 'package:habitv8/services/logging_service.dart';

/// Test script to run Health Connect diagnostics
/// Run this with: flutter run test_health_diagnostics.dart
void main() {
  runApp(HealthDiagnosticsApp());
}

class HealthDiagnosticsApp extends StatelessWidget {
  const HealthDiagnosticsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health Connect Diagnostics',
      home: HealthDiagnosticsScreen(),
    );
  }
}

class HealthDiagnosticsScreen extends StatefulWidget {
  const HealthDiagnosticsScreen({super.key});

  @override
  _HealthDiagnosticsScreenState createState() =>
      _HealthDiagnosticsScreenState();
}

class _HealthDiagnosticsScreenState extends State<HealthDiagnosticsScreen> {
  bool _isRunning = false;
  Map<String, dynamic>? _results;
  String? _error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Health Connect Diagnostics'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Health Connect Diagnostic Tool',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              'This tool will run comprehensive diagnostics on your Health Connect integration to identify why health data is not being retrieved.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _isRunning ? null : _runDiagnostics,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: _isRunning
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        SizedBox(width: 10),
                        Text('Running Diagnostics...'),
                      ],
                    )
                  : Text('Run Health Connect Diagnostics'),
            ),
            SizedBox(height: 20),
            if (_error != null)
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  border: Border.all(color: Colors.red),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Error:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red.shade700,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      _error!,
                      style: TextStyle(color: Colors.red.shade700),
                    ),
                  ],
                ),
              ),
            if (_results != null) ...[
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Diagnostic Results:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 16),
                        _buildResultsWidget(_results!),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _runDiagnostics() async {
    setState(() {
      _isRunning = true;
      _results = null;
      _error = null;
    });

    try {
      AppLogger.info('🚀 Starting Health Connect diagnostics...');

      // Run the native diagnostics
      final results =
          await MinimalHealthChannel.runNativeHealthConnectDiagnostics();

      AppLogger.info('✅ Diagnostics completed successfully');

      setState(() {
        _results = results;
        _isRunning = false;
      });
    } catch (e) {
      AppLogger.error('❌ Diagnostics failed', e);

      setState(() {
        _error = e.toString();
        _isRunning = false;
      });
    }
  }

  Widget _buildResultsWidget(Map<String, dynamic> results) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSection('Device Info', results['deviceInfo']),
        SizedBox(height: 16),
        _buildSection('Health Connect Status', {
          'Available': results['healthConnectAvailable'],
          'Client Initialized': results['clientInitialized'],
          'Permission Count': results['permissionCount'],
        }),
        SizedBox(height: 16),
        if (results['grantedPermissions'] != null)
          _buildPermissionsSection(results['grantedPermissions']),
        SizedBox(height: 16),
        if (results['dataAvailability'] != null)
          _buildDataAvailabilitySection(results['dataAvailability']),
        SizedBox(height: 16),
        if (results['recommendations'] != null)
          _buildRecommendationsSection(results['recommendations']),
      ],
    );
  }

  Widget _buildSection(String title, dynamic data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SizedBox(height: 8),
        if (data is Map)
          ...data.entries.map((entry) => Padding(
                padding: EdgeInsets.only(left: 16, bottom: 4),
                child: Text('${entry.key}: ${entry.value}'),
              ))
        else
          Padding(
            padding: EdgeInsets.only(left: 16),
            child: Text(data.toString()),
          ),
      ],
    );
  }

  Widget _buildPermissionsSection(List<dynamic> permissions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Granted Permissions (${permissions.length})',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SizedBox(height: 8),
        ...permissions.map((permission) => Padding(
              padding: EdgeInsets.only(left: 16, bottom: 2),
              child: Text('✅ $permission'),
            )),
      ],
    );
  }

  Widget _buildDataAvailabilitySection(Map<String, dynamic> dataAvailability) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Data Availability Test Results',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SizedBox(height: 8),
        ...dataAvailability.entries.map((entry) {
          final dataType = entry.key;
          final ranges = entry.value as Map<String, dynamic>;

          return Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dataType,
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                ...ranges.entries.map((rangeEntry) {
                  final rangeName = rangeEntry.key;
                  final rangeData = rangeEntry.value as Map<String, dynamic>;
                  final hasData = rangeData['hasData'] as bool? ?? false;
                  final recordCount = rangeData['recordCount'] ?? 0;
                  final error = rangeData['error'];

                  return Padding(
                    padding: EdgeInsets.only(left: 16, bottom: 2),
                    child: Text(
                      error != null
                          ? '❌ $rangeName: Error - $error'
                          : hasData
                              ? '✅ $rangeName: $recordCount records'
                              : '⚠️ $rangeName: No data',
                      style: TextStyle(
                        color: error != null
                            ? Colors.red
                            : hasData
                                ? Colors.green
                                : Colors.orange,
                      ),
                    ),
                  );
                }),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildRecommendationsSection(List<dynamic> recommendations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recommendations',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SizedBox(height: 8),
        ...recommendations.map((recommendation) => Padding(
              padding: EdgeInsets.only(left: 16, bottom: 4),
              child: Text(
                recommendation.toString(),
                style: TextStyle(
                  color: recommendation.toString().startsWith('❌')
                      ? Colors.red
                      : recommendation.toString().startsWith('✅')
                          ? Colors.green
                          : Colors.black87,
                ),
              ),
            )),
      ],
    );
  }
}
