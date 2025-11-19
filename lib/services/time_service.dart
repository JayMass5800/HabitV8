import 'package:timezone/timezone.dart' as tz;

/// Provides a single source of truth for timezone-safe time calculations.
///
/// All modules that need to convert between local time and UTC should use this
/// service to ensure we consistently respect the timezone set in `main.dart`.
class TimeService {
  TimeService._();

  /// Singleton instance used across the app.
  static final TimeService instance = TimeService._();

  tz.Location get _location => tz.local;

  /// Returns the current device time in the configured timezone.
  DateTime nowLocal() => tz.TZDateTime.now(_location);

  /// Returns the current UTC time, derived from the configured timezone.
  DateTime nowUtc() => nowLocal().toUtc();

  /// Converts any [dateTime] to the configured local timezone.
  DateTime toLocal(DateTime dateTime) {
    if (dateTime is tz.TZDateTime) {
      return dateTime.location == _location
          ? dateTime
          : tz.TZDateTime.from(dateTime, _location);
    }

    if (dateTime.isUtc) {
      return tz.TZDateTime.from(dateTime, _location);
    }

    return tz.TZDateTime(
      _location,
      dateTime.year,
      dateTime.month,
      dateTime.day,
      dateTime.hour,
      dateTime.minute,
      dateTime.second,
      dateTime.millisecond,
      dateTime.microsecond,
    );
  }

  /// Converts any [dateTime] to UTC using the configured timezone.
  DateTime toUtc(DateTime dateTime) {
    if (dateTime.isUtc) {
      return dateTime;
    }

    if (dateTime is tz.TZDateTime) {
      return dateTime.toUtc();
    }

    final local = tz.TZDateTime(
      _location,
      dateTime.year,
      dateTime.month,
      dateTime.day,
      dateTime.hour,
      dateTime.minute,
      dateTime.second,
      dateTime.millisecond,
      dateTime.microsecond,
    );

    return local.toUtc();
  }

  /// Returns the start of day (00:00) in local time for the provided [dateTime].
  DateTime startOfDayLocal(DateTime dateTime) {
    final local = toLocal(dateTime);
    return tz.TZDateTime(_location, local.year, local.month, local.day);
  }

  /// Returns the end of day (23:59:59.999999) in local time for [dateTime].
  DateTime endOfDayLocal(DateTime dateTime) {
    final start = startOfDayLocal(dateTime);
    return tz.TZDateTime(
      _location,
      start.year,
      start.month,
      start.day,
      23,
      59,
      59,
      999,
      999,
    );
  }

  /// Returns the start of day in UTC for [dateTime].
  DateTime startOfDayUtc(DateTime dateTime) => toUtc(startOfDayLocal(dateTime));

  /// Returns the end of day in UTC for [dateTime].
  DateTime endOfDayUtc(DateTime dateTime) => toUtc(endOfDayLocal(dateTime));

  /// Combines the date component of [dateTime] with the provided time parts.
  DateTime combineDateWithTime(
    DateTime dateTime, {
    required int hour,
    required int minute,
    int second = 0,
    int millisecond = 0,
    int microsecond = 0,
  }) {
    final localDate = toLocal(dateTime);
    return tz.TZDateTime(
      _location,
      localDate.year,
      localDate.month,
      localDate.day,
      hour,
      minute,
      second,
      millisecond,
      microsecond,
    );
  }

  /// Returns the next local midnight relative to [from] (defaults to now).
  DateTime nextMidnightLocal({DateTime? from}) {
    final base = toLocal(from ?? nowLocal());
    return tz.TZDateTime(_location, base.year, base.month, base.day + 1);
  }

  /// Returns the next midnight converted to UTC.
  DateTime nextMidnightUtc({DateTime? from}) => toUtc(nextMidnightLocal(from: from));

  /// Ensures a scheduled time is in the future; otherwise adds [minLead].
  DateTime ensureFutureLocal(
    DateTime desiredLocal, {
    Duration minLead = const Duration(minutes: 1),
  }) {
    final normalized = toLocal(desiredLocal);
    final now = nowLocal();
    if (!normalized.isAfter(now)) {
      return now.add(minLead);
    }
    return normalized;
  }

  /// Checks whether two timestamps fall on the same local calendar day.
  bool isSameLocalDay(DateTime a, DateTime b) {
    final localA = toLocal(a);
    final localB = toLocal(b);
    return localA.year == localB.year &&
        localA.month == localB.month &&
        localA.day == localB.day;
  }

  /// Exposes the active timezone name for diagnostics.
  String get timezoneName => _location.name;
}
