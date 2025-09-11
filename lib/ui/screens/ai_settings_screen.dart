import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../services/enhanced_insights_service.dart';
import '../../services/ai_service.dart';

class AISettingsScreen extends StatefulWidget {
  const AISettingsScreen({super.key});

  @override
  State<AISettingsScreen> createState() => _AISettingsScreenState();
}

class _AISettingsScreenState extends State<AISettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _openAiKeyController = TextEditingController();
  final _geminiKeyController = TextEditingController();
  final _secureStorage = const FlutterSecureStorage();
  final _enhancedInsights = EnhancedInsightsService();
  final _aiService = AIService();

  bool _enableAI = false;
  String _preferredProvider = 'OpenAI';
  bool _isLoading = false;
  bool _obscureKeys = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  @override
  void dispose() {
    _openAiKeyController.dispose();
    _geminiKeyController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    setState(() => _isLoading = true);

    try {
      // Initialize AI service
      await _aiService.initializeApiKeys();

      // Load API keys using AI service
      final openAiKey = await _aiService.getApiKey('openai') ?? '';
      final geminiKey = await _aiService.getApiKey('gemini') ?? '';

      // Load other settings from secure storage
      final enableAI =
          await _secureStorage.read(key: 'enable_ai_insights') == 'true';
      final preferredProvider =
          await _secureStorage.read(key: 'preferred_ai_provider') ?? 'OpenAI';

      setState(() {
        _openAiKeyController.text = openAiKey;
        _geminiKeyController.text = geminiKey;
        _enableAI = enableAI;
        _preferredProvider = preferredProvider;
      });
    } catch (e) {
      _showSnackBar('Error loading settings: $e', isError: true);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveSettings() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Save API keys using AI service
      await _aiService.saveApiKeys(
        openAiKey: _openAiKeyController.text.trim(),
        geminiKey: _geminiKeyController.text.trim(),
      );

      // Save other settings to secure storage
      await _secureStorage.write(
          key: 'enable_ai_insights', value: _enableAI.toString());
      await _secureStorage.write(
          key: 'preferred_ai_provider', value: _preferredProvider);

      _showSnackBar('Settings saved successfully!');
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      _showSnackBar('Error saving settings: $e', isError: true);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Insights Settings'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveSettings,
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // AI Enable Toggle
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.psychology,
                                  color: theme.colorScheme.primary,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'AI-Powered Insights',
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Enable AI-powered insights and personalized recommendations for your habits.',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.7),
                              ),
                            ),
                            const SizedBox(height: 16),
                            SwitchListTile(
                              title: const Text('Enable AI Insights'),
                              subtitle: Text(_enhancedInsights.isAIAvailable
                                  ? 'AI services configured'
                                  : 'Configure API keys below'),
                              value: _enableAI,
                              onChanged: (value) {
                                setState(() => _enableAI = value);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Provider Selection
                    if (_enableAI) ...[
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'AI Provider',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              RadioListTile<String>(
                                title: const Text('OpenAI (ChatGPT)'),
                                subtitle: const Text(
                                    'Most reliable, costs per token'),
                                value: 'OpenAI',
                                groupValue: _preferredProvider,
                                onChanged: (value) {
                                  setState(() => _preferredProvider = value!);
                                },
                              ),
                              RadioListTile<String>(
                                title: const Text('Google Gemini'),
                                subtitle: const Text(
                                    'Fast and efficient, generous free tier'),
                                value: 'Gemini',
                                groupValue: _preferredProvider,
                                onChanged: (value) {
                                  setState(() => _preferredProvider = value!);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // API Keys Section
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'API Keys',
                                    style:
                                        theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    icon: Icon(_obscureKeys
                                        ? Icons.visibility_off
                                        : Icons.visibility),
                                    onPressed: () {
                                      setState(
                                          () => _obscureKeys = !_obscureKeys);
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Your API keys are stored securely on your device and never shared.',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withValues(alpha: 0.6),
                                ),
                              ),
                              const SizedBox(height: 16),

                              // OpenAI Key
                              TextFormField(
                                controller: _openAiKeyController,
                                decoration: InputDecoration(
                                  labelText: 'OpenAI API Key',
                                  hintText: 'sk-...',
                                  border: const OutlineInputBorder(),
                                  prefixIcon: const Icon(Icons.key),
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.help_outline),
                                    onPressed: () => _showApiKeyHelp('OpenAI'),
                                  ),
                                ),
                                obscureText: _obscureKeys,
                                validator:
                                    _preferredProvider == 'OpenAI' && _enableAI
                                        ? (value) {
                                            if (value?.isEmpty ?? true) {
                                              return 'OpenAI API key is required';
                                            }
                                            if (!value!.startsWith('sk-')) {
                                              return 'Invalid OpenAI API key format';
                                            }
                                            return null;
                                          }
                                        : null,
                              ),

                              const SizedBox(height: 16),

                              // Gemini Key
                              TextFormField(
                                controller: _geminiKeyController,
                                decoration: InputDecoration(
                                  labelText: 'Google Gemini API Key',
                                  hintText: 'AIzaSy...',
                                  border: const OutlineInputBorder(),
                                  prefixIcon: const Icon(Icons.key),
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.help_outline),
                                    onPressed: () => _showApiKeyHelp('Gemini'),
                                  ),
                                ),
                                obscureText: _obscureKeys,
                                validator:
                                    _preferredProvider == 'Gemini' && _enableAI
                                        ? (value) {
                                            if (value?.isEmpty ?? true) {
                                              return 'Gemini API key is required';
                                            }
                                            if (!value!.startsWith('AIzaSy')) {
                                              return 'Invalid Gemini API key format';
                                            }
                                            return null;
                                          }
                                        : null,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Privacy Notice
                      Card(
                        color: theme.colorScheme.surfaceContainer,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.privacy_tip,
                                    color: theme.colorScheme.primary,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Privacy Notice',
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'When AI insights are enabled, anonymized habit data (completion rates, categories, trends) will be sent to your chosen AI provider to generate personalized insights. No personal information or habit names are included.',
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 32),

                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _saveSettings,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator()
                            : const Text('Save Settings'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  void _showApiKeyHelp(String provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$provider API Key Help'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (provider == 'OpenAI') ...[
                const Text('To get your OpenAI API key:'),
                const SizedBox(height: 8),
                const Text('1. Visit platform.openai.com'),
                const Text('2. Sign up or log in'),
                const Text('3. Navigate to API Keys section'),
                const Text('4. Create a new secret key'),
                const Text('5. Copy the key that starts with "sk-"'),
                const SizedBox(height: 12),
                const Text(
                  'Note: OpenAI charges per token usage. Check their pricing page for current rates.',
                  style: TextStyle(fontSize: 12),
                ),
              ] else if (provider == 'Gemini') ...[
                const Text('To get your Gemini API key:'),
                const SizedBox(height: 8),
                const Text('1. Visit ai.google.dev'),
                const Text('2. Sign in with your Google account'),
                const Text('3. Go to "Get API Key"'),
                const Text('4. Create a new project or select existing'),
                const Text('5. Generate API key'),
                const SizedBox(height: 12),
                const Text(
                  'Note: Gemini has a generous free tier with rate limits. Check Google AI Studio for details.',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
