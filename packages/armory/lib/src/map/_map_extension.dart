part of '../map.dart';

/// Additional methods for [Map].
extension MapExtension<K, V> on Map<K, V> {
  /// Returns whether `this` contains every element in [other] in the same
  /// order and no other elements.
  bool deepEquals(Map<K, V> other) {
    if (length != other.length) {
      return false;
    }
    return _deepEqualsMap(other);
  }

  bool _deepEqualsMap(Map<K, V> other) {
    assert(other.length == length, 'Maps must be the same length');
    for (final entry in entries) {
      if (!other.containsKey(entry.key) || other[entry.key] != entry.value) {
        return false;
      }
    }
    return true;
  }
}
