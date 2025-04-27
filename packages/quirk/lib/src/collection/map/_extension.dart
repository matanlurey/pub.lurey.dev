part of '../../collection.dart';

/// Extension methods for [Map] or `null`.
extension NullableMapExtension<K, V> on Map<K, V>? {
  /// Returns an empty map if `this` is `null`.
  ///
  /// Otherwise, returns `this`.
  Map<K, V> get orEmpty => this ?? const {};
}
