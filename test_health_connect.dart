import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(HealthConnectTestApp());
}

class HealthConnectTestApp extends StatelessWidget {
  const HealthConnectTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health Connect Test',
      home: HealthConnectTestScreen(),
    );
  }
}

class HealthConnectTestScreen extends StatefulWidget {
  const HealthConnectTestScreen({super.key});

  @override
  _HealthConnectTestScreenState createState() =>
      _HealthConnectTestScreenState();
}

class _HealthConnectTestScreenState extends State<HealthConnectTestScreen> {
  static const platform = MethodChannel('minimal_health_service');

  String _status = 'Not tested';
  List<Map<String, dynamic>> _healthData = [];
  bool _hasPermissions = false;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    try {
      final bool hasPermissions = await platform.invokeMethod('hasPermissions');
      setState(() {
        _hasPermissions = hasPermissions;
        _status = hasPermissions ? 'Permissions granted' : 'Permissions needed';
      });
    } catch (e) {
      setState(() {
        _status = 'Error checking permissions: $e';
      });
    }
  }

  Future<void> _requestPermissions() async {
    try {
      final bool granted = await platform.invokeMethod('requestPermissions');
      setState(() {
        _hasPermissions = granted;
        _status = granted ? 'Permissions granted' : 'Permissions denied';
      });
    } catch (e) {
      setState(() {
        _status = 'Error requesting permissions: $e';
      });
    }
  }

  Future<void> _getStepsData() async {
    try {
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);

      final List<dynamic> data = await platform.invokeMethod('getHealthData', {
        'dataType': 'STEPS',
        'startDate': startOfDay.millisecondsSinceEpoch,
        'endDate': now.millisecondsSinceEpoch,
      });

      setState(() {
        _healthData = data.cast<Map<String, dynamic>>();
        _status = 'Retrieved ${data.length} step records';
      });
    } catch (e) {
      setState(() {
        _status = 'Error getting steps data: $e';
      });
    }
  }

  Future<void> _getHeartRateData() async {
    try {
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);

      final List<dynamic> data = await platform.invokeMethod('getHealthData', {
        'dataType': 'HEART_RATE',
        'startDate': startOfDay.millisecondsSinceEpoch,
        'endDate': now.millisecondsSinceEpoch,
      });

      setState(() {
        _healthData = data.cast<Map<String, dynamic>>();
        _status = 'Retrieved ${data.length} heart rate records';
      });
    } catch (e) {
      setState(() {
        _status = 'Error getting heart rate data: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Health Connect Test'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Status:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(_status),
                    SizedBox(height: 8),
                    Text('Has Permissions: $_hasPermissions'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _checkPermissions,
              child: Text('Check Permissions'),
            ),
            ElevatedButton(
              onPressed: _hasPermissions ? null : _requestPermissions,
              child: Text('Request Permissions'),
            ),
            ElevatedButton(
              onPressed: _hasPermissions ? _getStepsData : null,
              child: Text('Get Steps Data'),
            ),
            ElevatedButton(
              onPressed: _hasPermissions ? _getHeartRateData : null,
              child: Text('Get Heart Rate Data'),
            ),
            SizedBox(height: 16),
            Expanded(
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Health Data:',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _healthData.length,
                          itemBuilder: (context, index) {
                            final record = _healthData[index];
                            return ListTile(
                              title:
                                  Text('${record['value']} ${record['unit']}'),
                              subtitle: Text(
                                  '${DateTime.fromMillisecondsSinceEpoch(record['timestamp'])}'),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
