import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../screens/ai_settings_screen.dart';

/// Widget that shows AI insights status and guides users through setup
class AIStatusBanner extends StatefulWidget {
  final bool isAIAvailable;
  final int habitCount;
  final int completionCount;

  const AIStatusBanner({
    super.key,
    required this.isAIAvailable,
    required this.habitCount,
    required this.completionCount,
  });

  @override
  State<AIStatusBanner> createState() => _AIStatusBannerState();
}

class _AIStatusBannerState extends State<AIStatusBanner> {
  final _secureStorage = const FlutterSecureStorage();
  bool _isAIEnabled = false;
  bool _hasApiKey = false;
  String _statusMessage = '';
  Color _statusColor = Colors.grey;
  IconData _statusIcon = Icons.info;

  @override
  void initState() {
    super.initState();
    _checkAIStatus();
  }

  Future<void> _checkAIStatus() async {
    final enableAI =
        await _secureStorage.read(key: 'enable_ai_insights') == 'true';
    final openAiKey = await _secureStorage.read(key: 'openai_api_key') ?? '';
    final geminiKey = await _secureStorage.read(key: 'gemini_api_key') ?? '';
    final hasKey = openAiKey.isNotEmpty || geminiKey.isNotEmpty;

    setState(() {
      _isAIEnabled = enableAI;
      _hasApiKey = hasKey;
      _updateStatus();
    });
  }

  void _updateStatus() {
    if (!_isAIEnabled && !_hasApiKey) {
      _statusMessage = 'AI insights available - tap to enable';
      _statusColor = Colors.blue;
      _statusIcon = Icons.psychology_outlined;
    } else if (!_isAIEnabled && _hasApiKey) {
      _statusMessage = 'AI configured but disabled - tap to enable';
      _statusColor = Colors.orange;
      _statusIcon = Icons.toggle_off;
    } else if (_isAIEnabled && !_hasApiKey) {
      _statusMessage = 'AI enabled but no API key - tap to configure';
      _statusColor = Colors.red;
      _statusIcon = Icons.key_off;
    } else if (_isAIEnabled && _hasApiKey) {
      if (widget.habitCount < 1) {
        _statusMessage = 'AI ready - create habits to get insights';
        _statusColor = Colors.green;
        _statusIcon = Icons.add_circle_outline;
      } else if (widget.completionCount < 5) {
        _statusMessage = 'AI ready - complete more habits for better insights';
        _statusColor = Colors.green;
        _statusIcon = Icons.trending_up;
      } else {
        _statusMessage = 'AI insights active';
        _statusColor = Colors.green;
        _statusIcon = Icons.auto_awesome;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Don't show banner if AI is fully working
    if (_isAIEnabled &&
        _hasApiKey &&
        widget.habitCount > 0 &&
        widget.completionCount >= 5) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _statusColor.withValues(alpha: 0.3)),
      ),
      child: InkWell(
        onTap: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AISettingsScreen()),
          );
          _checkAIStatus(); // Refresh status after returning
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(_statusIcon, color: _statusColor, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _statusMessage,
                  style: TextStyle(
                    color: _statusColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: _statusColor,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
