import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../services/enhanced_insights_service.dart';

/// Debug panel for AI insights development and troubleshooting
class AIInsightsDebugPanel extends StatefulWidget {
  final int habitCount;
  final int completionCount;

  const AIInsightsDebugPanel({
    super.key,
    required this.habitCount,
    required this.completionCount,
  });

  @override
  State<AIInsightsDebugPanel> createState() => _AIInsightsDebugPanelState();
}

class _AIInsightsDebugPanelState extends State<AIInsightsDebugPanel> {
  final _secureStorage = const FlutterSecureStorage();
  final _enhancedInsights = EnhancedInsightsService();

  bool _isAIEnabled = false;
  String _openAiKey = '';
  String _geminiKey = '';
  String _preferredProvider = '';
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _loadDebugInfo();
  }

  Future<void> _loadDebugInfo() async {
    final enableAI =
        await _secureStorage.read(key: 'enable_ai_insights') == 'true';
    final openAiKey = await _secureStorage.read(key: 'openai_api_key') ?? '';
    final geminiKey = await _secureStorage.read(key: 'gemini_api_key') ?? '';
    final preferredProvider =
        await _secureStorage.read(key: 'preferred_ai_provider') ?? 'None';

    if (mounted) {
      setState(() {
        _isAIEnabled = enableAI;
        _openAiKey = openAiKey;
        _geminiKey = geminiKey;
        _preferredProvider = preferredProvider;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Only show in debug mode
    if (const bool.fromEnvironment('dart.vm.product')) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  const Icon(Icons.bug_report, color: Colors.orange, size: 18),
                  const SizedBox(width: 8),
                  const Text(
                    'Debug Info',
                    style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.orange,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
          if (_isExpanded) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDebugRow('AI Enabled', _isAIEnabled ? '✅ Yes' : '❌ No'),
                  _buildDebugRow(
                      'OpenAI Key',
                      _openAiKey.isEmpty
                          ? '❌ Missing'
                          : '✅ Set (${_openAiKey.length} chars)'),
                  _buildDebugRow(
                      'Gemini Key',
                      _geminiKey.isEmpty
                          ? '❌ Missing'
                          : '✅ Set (${_geminiKey.length} chars)'),
                  _buildDebugRow('Preferred Provider', _preferredProvider),
                  _buildDebugRow('AI Available',
                      _enhancedInsights.isAIAvailable ? '✅ Yes' : '❌ No'),
                  _buildDebugRow('Available Providers',
                      _enhancedInsights.availableAIProviders.join(', ')),
                  const Divider(),
                  _buildDebugRow('Habit Count', '${widget.habitCount}'),
                  _buildDebugRow(
                      'Completion Count', '${widget.completionCount}'),
                  _buildDebugRow(
                      'Min Data Threshold',
                      widget.completionCount >= 5
                          ? '✅ Met'
                          : '❌ Need ${5 - widget.completionCount} more'),
                  const SizedBox(height: 8),
                  const Text(
                    'Troubleshooting:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  if (!_isAIEnabled)
                    const Text('• Enable AI in settings',
                        style: TextStyle(fontSize: 12)),
                  if (_isAIEnabled && _openAiKey.isEmpty && _geminiKey.isEmpty)
                    const Text('• Add API key in settings',
                        style: TextStyle(fontSize: 12)),
                  if (widget.habitCount == 0)
                    const Text('• Create at least one habit',
                        style: TextStyle(fontSize: 12)),
                  if (widget.completionCount < 5)
                    const Text('• Complete more habits for better insights',
                        style: TextStyle(fontSize: 12)),
                  if (_isAIEnabled &&
                      (_openAiKey.isNotEmpty || _geminiKey.isNotEmpty) &&
                      widget.completionCount >= 5)
                    const Text(
                        '• AI should be working! Check network connectivity',
                        style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDebugRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
