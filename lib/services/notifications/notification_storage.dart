import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import '../logging_service.dart';

/// Handles persistent storage of notification actions across app restarts.
///
/// This service uses dual storage (SharedPreferences + file) for reliability.
/// Actions are stored when the app is in background and processed when app opens.
class NotificationStorage {
  static const String _prefsKey = 'pending_notification_actions';
  static const String _fileName = 'pending_notification_actions.json';
  static const String _lockFileName = 'pending_notification_actions.lock';
  static const int _maxLockAttempts = 50;
  static const Duration _lockRetryDelay = Duration(milliseconds: 100);
  static const Duration _maxActionAge = Duration(hours: 24);

  /// Store notification action for later processing when app is opened
  static Future<void> storeAction(String habitId, String action) async {
    try {
      AppLogger.info(
          'Storing action for later processing: $action for habit $habitId');

      // Create action entry with timestamp
      final actionEntry = {
        'habitId': habitId,
        'action': action,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };

      // Use both SharedPreferences and file storage for reliability
      await Future.wait([
        _storeActionInSharedPreferences(actionEntry),
        _storeActionInFile(actionEntry),
      ]);

      AppLogger.info(
          'Successfully stored pending action: $action for habit $habitId');
    } catch (e) {
      AppLogger.error('Error storing action for later processing', e);
    }
  }

  /// Store action in SharedPreferences
  static Future<void> _storeActionInSharedPreferences(
      Map<String, dynamic> actionEntry) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Get existing pending actions
      final existingActions = prefs.getStringList(_prefsKey) ?? [];

      // Add new action to the list
      existingActions.add(jsonEncode(actionEntry));

      // Store updated list
      await prefs.setStringList(_prefsKey, existingActions);

      // Debug: Verify storage
      final verifyActions = prefs.getStringList(_prefsKey) ?? [];
      AppLogger.debug(
          '🔍 SharedPrefs: Verified storage: ${verifyActions.length} actions stored');
      AppLogger.debug(
          '🔍 SharedPrefs: All keys after storage: ${prefs.getKeys().toList()}');
    } catch (e) {
      AppLogger.error('Error storing action in SharedPreferences', e);
    }
  }

  /// Store action in file as backup with file locking to prevent corruption
  static Future<void> _storeActionInFile(
      Map<String, dynamic> actionEntry) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$_fileName';
      final lockFilePath = '${directory.path}/$_lockFileName';
      final file = File(filePath);
      final lockFile = File(lockFilePath);

      AppLogger.debug('🔍 File: Storing action at path: $filePath');

      // Wait for lock to be available (simple file-based locking)
      if (!await _acquireLock(lockFile)) {
        AppLogger.error('🔍 File: Timeout waiting for file lock');
        return;
      }

      try {
        List<Map<String, dynamic>> actions = [];

        // Read existing actions if file exists
        if (await file.exists()) {
          final content = await file.readAsString();
          AppLogger.debug(
              '🔍 File: Existing file content length: ${content.length}');
          if (content.isNotEmpty) {
            try {
              final List<dynamic> jsonList = jsonDecode(content);
              actions = jsonList.cast<Map<String, dynamic>>();
              AppLogger.debug(
                  '🔍 File: Loaded ${actions.length} existing actions');
            } catch (e) {
              AppLogger.error(
                  '🔍 File: Corrupted file detected, starting fresh', e);
              actions = [];
            }
          }
        } else {
          AppLogger.debug('🔍 File: Creating new file');
        }

        // Add new action
        actions.add(actionEntry);

        // Write to temporary file first (atomic write)
        final tempFilePath = '$filePath.tmp';
        final tempFile = File(tempFilePath);
        final jsonContent = jsonEncode(actions);
        await tempFile.writeAsString(jsonContent);

        // Verify temp file was written correctly
        final verifyContent = await tempFile.readAsString();
        if (verifyContent.length != jsonContent.length) {
          throw Exception('Temp file write verification failed');
        }

        // Atomic move from temp to final file
        await tempFile.rename(filePath);

        AppLogger.debug(
            '🔍 File: Stored action in file, total: ${actions.length}');
        AppLogger.debug(
            '🔍 File: Written content length: ${jsonContent.length}');
      } finally {
        // Always remove lock file
        await _releaseLock(lockFile);
      }
    } catch (e) {
      AppLogger.error('Error storing action in file', e);
    }
  }

  /// Remove a specific stored action from both SharedPreferences and file storage
  static Future<void> removeAction(String habitId, String action) async {
    try {
      AppLogger.info('Removing stored action: $action for habit $habitId');

      // Remove from both storages in parallel
      await Future.wait([
        _removeActionFromSharedPreferences(habitId, action),
        _removeActionFromFile(habitId, action),
      ]);

      AppLogger.info(
          'Successfully removed stored action: $action for habit $habitId');
    } catch (e) {
      AppLogger.error('Error removing stored action', e);
    }
  }

  /// Remove action from SharedPreferences
  static Future<void> _removeActionFromSharedPreferences(
      String habitId, String action) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final existingActions = prefs.getStringList(_prefsKey) ?? [];

      // Filter out the matching action
      final filteredActions = existingActions.where((actionString) {
        try {
          final actionData = jsonDecode(actionString) as Map<String, dynamic>;
          return !(actionData['habitId'] == habitId &&
              actionData['action'] == action);
        } catch (e) {
          // Keep malformed entries to avoid data loss
          return true;
        }
      }).toList();

      await prefs.setStringList(_prefsKey, filteredActions);
      AppLogger.debug(
          'Removed action from SharedPreferences. Remaining: ${filteredActions.length}');
    } catch (e) {
      AppLogger.error('Error removing action from SharedPreferences', e);
    }
  }

  /// Remove action from file storage
  static Future<void> _removeActionFromFile(
      String habitId, String action) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$_fileName';
      final lockFilePath = '${directory.path}/$_lockFileName';
      final file = File(filePath);
      final lockFile = File(lockFilePath);

      if (!await file.exists()) {
        return; // Nothing to remove
      }

      // Wait for lock to be available
      if (!await _acquireLock(lockFile)) {
        AppLogger.error('Timeout waiting for file lock during removal');
        return;
      }

      try {
        // Read existing actions
        final content = await file.readAsString();
        if (content.isEmpty) {
          return;
        }

        List<Map<String, dynamic>> actions = [];
        try {
          final List<dynamic> jsonList = jsonDecode(content);
          actions = jsonList.cast<Map<String, dynamic>>();
        } catch (e) {
          AppLogger.error('Corrupted file during removal, keeping as is', e);
          return;
        }

        // Filter out the matching action
        final filteredActions = actions.where((actionEntry) {
          return !(actionEntry['habitId'] == habitId &&
              actionEntry['action'] == action);
        }).toList();

        // Write back the filtered actions
        final jsonContent = jsonEncode(filteredActions);
        await file.writeAsString(jsonContent);

        AppLogger.debug(
            'Removed action from file. Remaining: ${filteredActions.length}');
      } finally {
        // Always remove lock file
        await _releaseLock(lockFile);
      }
    } catch (e) {
      AppLogger.error('Error removing action from file', e);
    }
  }

  /// Load all pending actions from storage
  static Future<List<Map<String, dynamic>>> loadAllActions() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Debug: Check all keys in SharedPreferences
      final allKeys = prefs.getKeys();
      AppLogger.debug('🔍 All SharedPreferences keys: ${allKeys.toList()}');

      // Try multiple approaches to get the data
      final pendingActions1 = prefs.getStringList(_prefsKey);
      final pendingActions2 = prefs.get(_prefsKey);

      AppLogger.debug('🔍 Method 1 (getStringList): $pendingActions1');
      AppLogger.debug('🔍 Method 2 (get): $pendingActions2');

      final pendingActions = pendingActions1 ?? [];

      AppLogger.debug(
          '🔍 Found ${pendingActions.length} pending actions in SharedPreferences');
      if (pendingActions.isNotEmpty) {
        AppLogger.debug('🔍 Pending actions: $pendingActions');
      }

      if (pendingActions.isEmpty) {
        AppLogger.debug(
            'No pending notification actions to process in SharedPreferences');

        // Try alternative storage keys in case there's a mismatch
        final alternativeKeys = [
          'pending_actions',
          'notification_actions',
          'stored_actions'
        ];
        for (final key in alternativeKeys) {
          final altActions = prefs.getStringList(key);
          if (altActions != null && altActions.isNotEmpty) {
            AppLogger.debug(
                '🔍 Found actions under alternative key "$key": $altActions');
          }
        }

        // Try file storage as backup
        final fileActions = await loadActionsFromFile();
        if (fileActions.isNotEmpty) {
          AppLogger.info(
              '🔍 Found ${fileActions.length} actions in file storage');
          return fileActions;
        }

        AppLogger.debug('No pending actions found in any storage method');
        return [];
      }

      // Parse actions from SharedPreferences
      final List<Map<String, dynamic>> parsedActions = [];
      for (final actionString in pendingActions) {
        try {
          final actionData = jsonDecode(actionString) as Map<String, dynamic>;

          // Check if action is not too old
          final timestamp = actionData['timestamp'] as int;
          final actionTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
          final now = DateTime.now();
          final timeDifference = now.difference(actionTime);

          if (timeDifference > _maxActionAge) {
            AppLogger.warning(
                'Skipping old pending action: ${actionData['action']} for habit ${actionData['habitId']} (${timeDifference.inHours} hours old)');
            continue;
          }

          parsedActions.add(actionData);
        } catch (e) {
          AppLogger.error('Error parsing individual pending action', e);
        }
      }

      return parsedActions;
    } catch (e) {
      AppLogger.error('Error loading actions from storage', e);
      return [];
    }
  }

  /// Load actions from file storage with corruption handling
  static Future<List<Map<String, dynamic>>> loadActionsFromFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$_fileName';
      final file = File(filePath);

      AppLogger.debug('🔍 File: Checking for actions at path: $filePath');

      if (!await file.exists()) {
        AppLogger.debug('🔍 File: File does not exist');
        return [];
      }

      final content = await file.readAsString();
      AppLogger.debug('🔍 File: File content length: ${content.length}');

      if (content.isEmpty) {
        AppLogger.debug('🔍 File: File is empty');
        return [];
      }

      try {
        final List<dynamic> jsonList = jsonDecode(content);
        final actions = jsonList.cast<Map<String, dynamic>>();
        AppLogger.debug('🔍 File: Loaded ${actions.length} actions from file');

        // Filter out old actions
        final filteredActions = actions.where((actionData) {
          final timestamp = actionData['timestamp'] as int;
          final actionTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
          final timeDifference = DateTime.now().difference(actionTime);

          if (timeDifference > _maxActionAge) {
            AppLogger.warning(
                'Skipping old action from file: ${actionData['action']} (${timeDifference.inHours} hours old)');
            return false;
          }
          return true;
        }).toList();

        return filteredActions;
      } catch (e) {
        AppLogger.error(
            '🔍 File: JSON parsing failed, file corrupted. Content: $content',
            e);

        // Delete corrupted file to prevent future issues
        try {
          await file.delete();
          AppLogger.info('🔍 File: Deleted corrupted file');
        } catch (deleteError) {
          AppLogger.error(
              '🔍 File: Failed to delete corrupted file', deleteError);
        }

        return [];
      }
    } catch (e) {
      AppLogger.error('Error loading actions from file', e);
      return [];
    }
  }

  /// Clear all stored actions
  static Future<void> clearAll() async {
    try {
      await Future.wait([
        _clearSharedPreferences(),
        _clearFile(),
      ]);
      AppLogger.info('✅ Cleared all stored actions from both storages');
    } catch (e) {
      AppLogger.error('Error clearing all stored actions', e);
    }
  }

  /// Clear actions from SharedPreferences
  static Future<void> _clearSharedPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_prefsKey);
      AppLogger.debug('Cleared actions from SharedPreferences');
    } catch (e) {
      AppLogger.error('Error clearing SharedPreferences', e);
    }
  }

  /// Clear all actions from file storage
  static Future<void> _clearFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$_fileName';
      final lockFilePath = '${directory.path}/$_lockFileName';
      final file = File(filePath);
      final lockFile = File(lockFilePath);

      // Wait for lock to be available
      if (!await _acquireLock(lockFile)) {
        AppLogger.error('Timeout waiting for file lock during clear');
        return;
      }

      try {
        if (await file.exists()) {
          await file.delete();
          AppLogger.info('✅ Cleared all actions from file storage');
        }
      } finally {
        // Always remove lock file
        await _releaseLock(lockFile);
      }
    } catch (e) {
      AppLogger.error('Error clearing actions from file', e);
    }
  }

  /// Acquire file lock (returns true if successful, false if timeout)
  static Future<bool> _acquireLock(File lockFile) async {
    int attempts = 0;
    while (await lockFile.exists() && attempts < _maxLockAttempts) {
      await Future.delayed(_lockRetryDelay);
      attempts++;
    }

    if (attempts >= _maxLockAttempts) {
      return false;
    }

    // Create lock file
    await lockFile.writeAsString('locked');
    return true;
  }

  /// Release file lock
  static Future<void> _releaseLock(File lockFile) async {
    try {
      if (await lockFile.exists()) {
        await lockFile.delete();
      }
    } catch (e) {
      AppLogger.error('Error releasing file lock', e);
    }
  }
}
