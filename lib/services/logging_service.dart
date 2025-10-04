import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class AppLogger {
  // Optimize logger for production builds - reduce overhead
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: kDebugMode ? 2 : 0, // No stack traces in release
      errorMethodCount: kDebugMode ? 8 : 2, // Minimal error traces in release
      lineLength: 120,
      colors: kDebugMode, // No ANSI colors in release
      printEmojis: kDebugMode, // No emojis in release
      dateTimeFormat: DateTimeFormat.none,
    ),
    level: kDebugMode ? Level.debug : Level.info, // Less verbose in release
  );

  /// Debug logs - only in debug builds to reduce memory overhead
  static void debug(String message) {
    if (kDebugMode) {
      _logger.d(message);
    }
  }

  static void info(String message) {
    _logger.i(message);
  }

  static void warning(String message) {
    _logger.w(message);
  }

  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  /// Verbose logs - only in debug builds
  static void verbose(String message) {
    if (kDebugMode) {
      _logger.t(message);
    }
  }
}
