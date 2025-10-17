import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

/// Simple test script to verify alarm sounds can be played
/// Run with: flutter run test_alarm_sound.dart
void main() {
  runApp(const AlarmSoundTestApp());
}

class AlarmSoundTestApp extends StatelessWidget {
  const AlarmSoundTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alarm Sound Test',
      theme: ThemeData(primarySwatch: Colors.red),
      home: const AlarmSoundTestScreen(),
    );
  }
}

class AlarmSoundTestScreen extends StatefulWidget {
  const AlarmSoundTestScreen({super.key});

  @override
  State<AlarmSoundTestScreen> createState() => _AlarmSoundTestScreenState();
}

class _AlarmSoundTestScreenState extends State<AlarmSoundTestScreen> {
  AudioPlayer? _player;
  String _status = 'Ready to test';
  bool _isPlaying = false;

  final List<String> _testSounds = [
    'sounds/Alarm.mp3',
    'sounds/Alarm_1.mp3',
    'sounds/Wake_Up.mp3',
    'sounds/Bell.mp3',
    'sounds/Best_Alarm.mp3',
  ];

  @override
  void dispose() {
    _player?.dispose();
    super.dispose();
  }

  Future<void> _testSound(String soundUri) async {
    try {
      setState(() {
        _status = '🔊 Testing: $soundUri';
        _isPlaying = true;
      });

      // Stop any existing playback
      await _player?.stop();
      await _player?.dispose();

      // Create new player
      _player = AudioPlayer();

      // Listen for state changes
      _player!.onPlayerStateChanged.listen((state) {
        debugPrint('Player state: $state');
        if (state == PlayerState.completed) {
          setState(() {
            _status = '✅ Completed: $soundUri';
            _isPlaying = false;
          });
        }
      });

      // Listen for errors
      _player!.onPlayerComplete.listen((event) {
        debugPrint('Playback completed');
      });

      // Set volume to max
      await _player!.setVolume(1.0);
      await _player!.setReleaseMode(ReleaseMode.stop);

      // Play the sound
      await _player!.play(AssetSource(soundUri));

      setState(() {
        _status = '✅ Playing: $soundUri';
      });
    } catch (e, stackTrace) {
      setState(() {
        _status = '❌ Error: $e';
        _isPlaying = false;
      });
      debugPrint('Error playing sound: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }

  Future<void> _stopSound() async {
    try {
      await _player?.stop();
      setState(() {
        _status = '⏹️ Stopped';
        _isPlaying = false;
      });
    } catch (e) {
      setState(() {
        _status = '❌ Error stopping: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alarm Sound Test'),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: Colors.red.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  _status,
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (_isPlaying)
              ElevatedButton.icon(
                onPressed: _stopSound,
                icon: const Icon(Icons.stop),
                label: const Text('STOP'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            const SizedBox(height: 20),
            const Text(
              'Test Sounds:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _testSounds.length,
                itemBuilder: (context, index) {
                  final sound = _testSounds[index];
                  final name = sound.split('/').last.replaceAll('.mp3', '');
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.music_note, color: Colors.red),
                      title: Text(name),
                      subtitle: Text(sound),
                      trailing: IconButton(
                        icon: const Icon(Icons.play_arrow),
                        onPressed: _isPlaying ? null : () => _testSound(sound),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
