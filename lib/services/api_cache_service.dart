class ApiCacheService {
  ApiCacheService._();

  static final ApiCacheService instance = ApiCacheService._();
  static const Duration defaultTtl = Duration(minutes: 5);

  final Map<String, _CacheEntry<dynamic>> _cacheStore =
      <String, _CacheEntry<dynamic>>{};

  T? get<T>(String key) {
    final entry = _cacheStore[key];
    if (entry == null) {
      return null;
    }
    if (DateTime.now().isAfter(entry.expiresAt)) {
      _cacheStore.remove(key);
      return null;
    }
    return entry.data as T;
  }

  void set<T>(String key, T value, {Duration ttl = defaultTtl}) {
    _cacheStore[key] = _CacheEntry<T>(
      data: value,
      expiresAt: DateTime.now().add(ttl),
    );
  }

  void invalidateByPrefix(String prefix) {
    final keysToRemove = _cacheStore.keys
        .where((cacheKey) => cacheKey.startsWith(prefix))
        .toList();
    for (final cacheKey in keysToRemove) {
      _cacheStore.remove(cacheKey);
    }
  }

  void clear() {
    _cacheStore.clear();
  }
}

class _CacheEntry<T> {
  final T data;
  final DateTime expiresAt;

  const _CacheEntry({required this.data, required this.expiresAt});
}
