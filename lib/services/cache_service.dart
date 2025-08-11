
/// A smart caching service for computed values with automatic invalidation
class CacheService {
  static final CacheService _instance = CacheService._internal();
  factory CacheService() => _instance;
  CacheService._internal();

  // Cache storage with expiration times
  final Map<String, _CacheEntry> _cache = {};

  // Dependencies tracking - which cache keys depend on which data sources
  final Map<String, Set<String>> _dependencies = {};

  // Data version tracking to detect changes
  final Map<String, int> _dataVersions = {};

  /// Get a cached value or compute it if not cached/expired
  T getOrCompute<T>(
    String key,
    T Function() computeFunction, {
    Duration? ttl,
    List<String>? dependsOn,
  }) {
    final now = DateTime.now();
    final entry = _cache[key];

    // Check if cache is valid
    if (entry != null &&
        (entry.expiresAt == null || entry.expiresAt!.isAfter(now)) &&
        _areDependenciesValid(key)) {
      return entry.value as T;
    }

    // Compute new value
    final value = computeFunction();

    // Store in cache
    _cache[key] = _CacheEntry(
      value: value,
      createdAt: now,
      expiresAt: ttl != null ? now.add(ttl) : null,
    );

    // Track dependencies
    if (dependsOn != null) {
      _dependencies[key] = dependsOn.toSet();
    }

    return value;
  }

  /// Invalidate cache entries that depend on the given data source
  void invalidateDependents(String dataSource) {
    final keysToRemove = <String>[];

    _dependencies.forEach((key, dependencies) {
      if (dependencies.contains(dataSource)) {
        keysToRemove.add(key);
      }
    });

    for (final key in keysToRemove) {
      _cache.remove(key);
      _dependencies.remove(key);
    }

    // Update data version to track changes
    _dataVersions[dataSource] = (_dataVersions[dataSource] ?? 0) + 1;
  }

  /// Clear specific cache entry
  void invalidate(String key) {
    _cache.remove(key);
    _dependencies.remove(key);
  }

  /// Clear all cache entries
  void clearAll() {
    _cache.clear();
    _dependencies.clear();
    _dataVersions.clear();
  }

  /// Check if dependencies are still valid
  bool _areDependenciesValid(String key) {
    final dependencies = _dependencies[key];
    if (dependencies == null) return true;

    final entry = _cache[key];
    if (entry == null) return false;

    // Check if any dependency has been updated since cache entry was created
    for (final dep in dependencies) {
      final depVersion = _dataVersions[dep] ?? 0;
      final entryCreationVersion = entry.dependencyVersions[dep] ?? 0;
      if (depVersion > entryCreationVersion) {
        return false;
      }
    }

    return true;
  }

  /// Get cache statistics for monitoring
  CacheStats getStats() {
    final now = DateTime.now();
    var validEntries = 0;
    var expiredEntries = 0;

    _cache.forEach((key, entry) {
      if (entry.expiresAt == null || entry.expiresAt!.isAfter(now)) {
        validEntries++;
      } else {
        expiredEntries++;
      }
    });

    return CacheStats(
      totalEntries: _cache.length,
      validEntries: validEntries,
      expiredEntries: expiredEntries,
      dependencies: _dependencies.length,
    );
  }

  /// Clear expired entries to free memory
  void cleanup() {
    final now = DateTime.now();
    final keysToRemove = <String>[];

    _cache.forEach((key, entry) {
      if (entry.expiresAt != null && entry.expiresAt!.isBefore(now)) {
        keysToRemove.add(key);
      }
    });

    for (final key in keysToRemove) {
      _cache.remove(key);
      _dependencies.remove(key);
    }
  }
}

class _CacheEntry {
  final dynamic value;
  final DateTime createdAt;
  final DateTime? expiresAt;
  final Map<String, int> dependencyVersions;

  _CacheEntry({
    required this.value,
    required this.createdAt,
    this.expiresAt,
  }) : dependencyVersions = Map.from(CacheService()._dataVersions);
}

class CacheStats {
  final int totalEntries;
  final int validEntries;
  final int expiredEntries;
  final int dependencies;

  CacheStats({
    required this.totalEntries,
    required this.validEntries,
    required this.expiredEntries,
    required this.dependencies,
  });

  double get hitRate {
    final total = totalEntries;
    return total > 0 ? validEntries / total : 0.0;
  }
}
