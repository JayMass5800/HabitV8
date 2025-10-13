import 'dart:io';
import 'package:flutter/services.dart';
import 'logging_service.dart';

/// Service for accessing system ringtones on Android
class RingtoneService {
  static const MethodChannel _ringtoneChannel =
      MethodChannel('com.habittracker.habitv8/ringtones');

  /// Get all available system ringtones (Android only)
  /// Returns a list of maps with 'name', 'uri', and 'type' keys
  static Future<List<Map<String, String>>> getSystemRingtones() async {
    if (!Platform.isAndroid) {
      AppLogger.warning('System ringtones only available on Android');
      return [];
    }

    try {
      final result = await _ringtoneChannel.invokeMethod('list');

      if (result == null) {
        AppLogger.warning('No ringtones returned from platform channel');
        return [];
      }

      // Convert the result to List<Map<String, String>>
      final List<Map<String, String>> ringtones = [];

      for (final item in result as List) {
        if (item is Map) {
          ringtones.add({
            'name': item['name']?.toString() ?? 'Unknown',
            'uri': item['uri']?.toString() ?? '',
            'type': item['type']?.toString() ?? 'system',
          });
        }
      }

      AppLogger.info('Retrieved ${ringtones.length} system ringtones');
      return ringtones;
    } catch (e) {
      AppLogger.error('Failed to get system ringtones', e);
      return [];
    }
  }

  /// Preview a ringtone by URI
  static Future<void> previewRingtone(String uri) async {
    if (!Platform.isAndroid) {
      AppLogger.warning('Ringtone preview only available on Android');
      return;
    }

    try {
      await _ringtoneChannel.invokeMethod('preview', {'uri': uri});
      AppLogger.debug('Playing ringtone preview: $uri');
    } catch (e) {
      AppLogger.error('Failed to preview ringtone', e);
    }
  }

  /// Stop any currently playing ringtone preview
  static Future<void> stopPreview() async {
    if (!Platform.isAndroid) {
      return;
    }

    try {
      await _ringtoneChannel.invokeMethod('stop');
      AppLogger.debug('Stopped ringtone preview');
    } catch (e) {
      AppLogger.error('Failed to stop ringtone preview', e);
    }
  }
}
