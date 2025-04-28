part of '../../collection.dart';

/// Extension methods for [Map].
extension MapExtension<K, V> on Map<K, V> {
  /// Returns `this` as an unmodifiable [Map].
  Map<K, V> asUnmodifiable() {
    return UnmodifiableMapView(this);
  }
}

/// Extension methods for [Map] or `null`.
extension NullableMapExtension<K, V> on Map<K, V>? {
  /// Returns an empty map if `this` is `null`.
  ///
  /// Otherwise, returns `this`.
  Map<K, V> get orEmpty => this ?? const {};
}
