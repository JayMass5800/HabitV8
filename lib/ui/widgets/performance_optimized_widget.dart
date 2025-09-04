import 'package:flutter/material.dart';

/// A widget that optimizes performance by preventing unnecessary rebuilds
/// when the data hasn't actually changed
class PerformanceOptimizedWidget<T> extends StatefulWidget {
  final T data;
  final Widget Function(BuildContext context, T data) builder;
  final bool Function(T oldData, T newData)? shouldRebuild;

  const PerformanceOptimizedWidget({
    super.key,
    required this.data,
    required this.builder,
    this.shouldRebuild,
  });

  @override
  State<PerformanceOptimizedWidget<T>> createState() =>
      _PerformanceOptimizedWidgetState<T>();
}

class _PerformanceOptimizedWidgetState<T>
    extends State<PerformanceOptimizedWidget<T>> {
  late T _cachedData;
  late Widget _cachedWidget;

  @override
  void initState() {
    super.initState();
    _cachedData = widget.data;
    _cachedWidget = widget.builder(context, _cachedData);
  }

  @override
  void didUpdateWidget(PerformanceOptimizedWidget<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Check if we should rebuild
    final shouldRebuild =
        widget.shouldRebuild?.call(_cachedData, widget.data) ??
            (_cachedData != widget.data);

    if (shouldRebuild) {
      _cachedData = widget.data;
      _cachedWidget = widget.builder(context, _cachedData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _cachedWidget;
  }
}

/// A mixin that provides performance optimization utilities
mixin PerformanceOptimizationMixin<T extends StatefulWidget> on State<T> {
  final Map<String, dynamic> _cache = {};
  final Map<String, DateTime> _cacheTimestamps = {};

  /// Cache a value with an optional expiry duration
  void cacheValue(String key, dynamic value, [Duration? expiry]) {
    _cache[key] = value;
    if (expiry != null) {
      _cacheTimestamps[key] = DateTime.now().add(expiry);
    }
  }

  /// Get a cached value, returns null if not found or expired
  V? getCachedValue<V>(String key) {
    final timestamp = _cacheTimestamps[key];
    if (timestamp != null && DateTime.now().isAfter(timestamp)) {
      _cache.remove(key);
      _cacheTimestamps.remove(key);
      return null;
    }
    return _cache[key] as V?;
  }

  /// Clear all cached values
  void clearCache() {
    _cache.clear();
    _cacheTimestamps.clear();
  }

  /// Clear a specific cached value
  void clearCachedValue(String key) {
    _cache.remove(key);
    _cacheTimestamps.remove(key);
  }

  @override
  void dispose() {
    clearCache();
    super.dispose();
  }
}

/// A widget that debounces rebuilds to prevent excessive updates
class DebouncedWidget extends StatefulWidget {
  final Widget child;
  final Duration debounceTime;

  const DebouncedWidget({
    super.key,
    required this.child,
    this.debounceTime = const Duration(milliseconds: 100),
  });

  @override
  State<DebouncedWidget> createState() => _DebouncedWidgetState();
}

class _DebouncedWidgetState extends State<DebouncedWidget> {
  Widget? _cachedChild;
  DateTime? _lastUpdateTime;

  @override
  void initState() {
    super.initState();
    _cachedChild = widget.child;
    _lastUpdateTime = DateTime.now();
  }

  @override
  void didUpdateWidget(DebouncedWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    final now = DateTime.now();
    if (_lastUpdateTime == null ||
        now.difference(_lastUpdateTime!) >= widget.debounceTime) {
      _cachedChild = widget.child;
      _lastUpdateTime = now;
    }
  }

  @override
  Widget build(BuildContext context) {
    return _cachedChild ?? widget.child;
  }
}
