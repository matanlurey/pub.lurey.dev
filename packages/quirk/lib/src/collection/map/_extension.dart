part of '../../collection.dart';

/// Extension methods for [Map].
extension MapExtension<K, V> on Map<K, V> {
  /// Returns `this` as an unmodifiable [Map].
  Map<K, V> asUnmodifiable() {
    return UnmodifiableMapView(this);
  }

  /// Returns whether `this` has the same entries in the same order as [other].
  ///
  /// ## Performance
  ///
  /// ### Time
  ///
  /// This method has a time complexity of `O(n)` where `n` is the number of
  /// elements in `this`.
  ///
  /// ### Memory
  ///
  /// `O(1)`.
  ///
  /// ## Example
  ///
  /// ```dart
  /// final map1 = {'a': 1, 'b': 2};
  /// final map2 = {'a': 1, 'b': 2};
  /// map1.orderedEqualsEntries(map2.entries); // true
  /// map1.orderedEqualsEntries({'a': 1, 'b': 3}.entries); // false
  /// ```
  bool orderedEquals(Map<K, V> other) {
    if (length != other.length) {
      return false;
    }
    final iterator = other.entries.iterator;
    for (final entry in entries) {
      if (!iterator.moveNext() ||
          entry.key != iterator.current.key ||
          entry.value != iterator.current.value) {
        return false;
      }
    }
    return true;
  }

  /// Returns whether `this` has the same entries in any order as [other].
  ///
  /// ## Performance
  ///
  /// ### Time
  ///
  /// This method has a time complexity of `O(n)` where `n` is the number of
  /// elements in `this`.
  ///
  /// ### Memory
  ///
  /// `O(1)`.
  ///
  /// ## Example
  ///
  /// ```dart
  /// final map1 = {'a': 1, 'b': 2};
  /// final map2 = {'b': 2, 'a': 1};
  /// map1.unorderedEqualsEntries(map2.entries); // true
  /// map1.unorderedEqualsEntries({'a': 1, 'b': 3}.entries); // false
  /// ```
  bool unorderedEquals(Map<K, V> other) {
    if (length != other.length) {
      return false;
    }
    for (final entry in entries) {
      final otherValue = other[entry.key];
      if (otherValue != entry.value) {
        return false;
      }
      if (otherValue == null && !other.containsKey(entry.key)) {
        return false;
      }
    }
    return true;
  }
}

/// Extension methods for [Map] or `null`.
extension NullableMapExtension<K, V> on Map<K, V>? {
  /// Returns an empty map if `this` is `null`.
  ///
  /// Otherwise, returns `this`.
  Map<K, V> get orEmpty => this ?? const {};
}
