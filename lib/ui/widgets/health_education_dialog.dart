import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Educational dialog explaining Health Connect data flow and privacy
/// Helps users understand how health data is gathered and used
class HealthEducationDialog extends StatelessWidget {
  const HealthEducationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.health_and_safety, color: Colors.green),
          SizedBox(width: 8),
          Text('Health Data Integration'),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'How Health Data Works',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            
            _buildInfoSection(
              icon: Icons.smartphone,
              title: 'Data Sources',
              description: 'Health data comes from:\n'
                  '• Your phone\'s built-in sensors\n'
                  '• Connected fitness trackers (Fitbit, Garmin, etc.)\n'
                  '• Health apps you use\n'
                  '• Manual entries you make',
            ),
            
            const SizedBox(height: 16),
            
            _buildInfoSection(
              icon: Icons.security,
              title: 'Privacy & Security',
              description: 'Your health data is:\n'
                  '• Processed locally on your device only\n'
                  '• Never sent to external servers\n'
                  '• Used only to enhance your habit tracking\n'
                  '• Controlled entirely by you',
            ),
            
            const SizedBox(height: 16),
            
            _buildInfoSection(
              icon: Icons.insights,
              title: 'How We Use It',
              description: 'Health data helps by:\n'
                  '• Automatically tracking fitness habits\n'
                  '• Providing personalized insights\n'
                  '• Correlating habits with health metrics\n'
                  '• Suggesting optimal habit timing',
            ),
            
            const SizedBox(height: 16),
            
            _buildInfoSection(
              icon: Icons.tune,
              title: 'You\'re In Control',
              description: 'You can:\n'
                  '• Grant or deny specific data types\n'
                  '• Revoke permissions anytime\n'
                  '• Use the app without health data\n'
                  '• Manage permissions in Health Connect',
            ),
            
            const SizedBox(height: 20),
            
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info, color: Colors.blue),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'We only request access to 6 essential data types: Steps, Active Energy, Sleep, Water intake, Mindfulness, and Weight.',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => _openHealthConnectSettings(),
          child: const Text('Health Connect Settings'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Not Now'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Enable Health Data'),
        ),
      ],
    );
  }

  Widget _buildInfoSection({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[700],
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _openHealthConnectSettings() async {
    try {
      // Try to open Health Connect settings
      const url = 'package:com.google.android.apps.healthdata';
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        // Fallback to general app settings
        const settingsUrl = 'package:com.android.settings';
        if (await canLaunchUrl(Uri.parse(settingsUrl))) {
          await launchUrl(Uri.parse(settingsUrl));
        }
      }
    } catch (e) {
      // If all else fails, do nothing
      print('Could not open settings: $e');
    }
  }

  /// Show the health education dialog
  static Future<bool?> show(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const HealthEducationDialog(),
    );
  }
}