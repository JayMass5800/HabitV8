# No Print Statements Rule

## Rule: Never use print() statements in Flutter/Dart code

### ❌ FORBIDDEN:
```dart
print('Debug message');
print('Error: $error');
```

### ✅ REQUIRED INSTEAD:
```dart
// Use the project's logging service
AppLogger.info('Debug message');
AppLogger.error('Error: $error');

// For development/debugging only (with ignore comment):
// ignore: avoid_print
print('Temporary debug - remove before commit');
```

### Why This Rule Exists:
1. **Production Safety**: Print statements appear in production logs and can expose sensitive information
2. **Performance**: Print statements can impact performance in production
3. **Consistency**: Using a structured logging system provides better control and formatting
4. **Debugging**: Proper logging allows for better filtering and log levels

### Available Logging Methods:
- `AppLogger.debug()` - Debug information
- `AppLogger.info()` - General information  
- `AppLogger.warning()` - Warning messages
- `AppLogger.error()` - Error messages with optional stack traces
- `AppLogger.verbose()` - Verbose/trace information

### Exceptions:
- Test files may use print statements for test output
- Temporary debugging during development (must be removed before commit)
- Scripts that are not part of the main application (like build scripts)

**This rule is enforced by Flutter analyze and will show as an ERROR.**


	"message": "'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss.\nTry replacing the use of the deprecated member with the replacement.