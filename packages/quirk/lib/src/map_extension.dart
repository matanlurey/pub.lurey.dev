/// Extensions for [Map]s.
extension MapExtension<K, V> on Map<K, V> {
  /// Returns whether `this` contains every key in [other].
  ///
  /// The keys must be equal (as determined by [Object.==]).
  ///
  /// ## Performance
  ///
  /// This method assumes that [length] can be efficiently computed for [other]
  /// in order to early exit if [other] is longer than `this`; otherwise, it
  /// will iterate over [other] to check if every key is contained n `this`. Use
  /// [containsAllKeysIndeterminate] if you annot guarantee that [length] can be
  /// efficiently computed for [other].
  ///
  /// ## Example
  ///
  /// ```dart
  /// final map = {'a': 1, 'b': 2, 'c': 3};
  /// final other = {'b': 2, 'c': 3};
  /// print(map.containsAllKeys(other.keys)); // true
  /// ```
  bool containsAllKeys(Iterable<K> other) {
    if (length < other.length) {
      return false;
    }
    return containsAllKeysIndeterminate(other);
  }

  /// Returns whether `this` contains every key in [other].
  ///
  /// The keys must be equal (as determined by [Object.==]).
  ///
  /// ## Performance
  ///
  /// This method will iterate over [other] to check if every key is contained
  /// in `this`. Use [containsAllKeys] if you can guarantee that [length] can be
  /// efficiently computed for [other].
  ///
  /// ## Example
  ///
  /// ```dart
  /// final map = {'a': 1, 'b': 2, 'c': 3};
  /// final other = {'b': 2, 'c': 3};
  /// print(map.containsAllKeysIndeterminate(other.keys)); // true
  /// ```
  bool containsAllKeysIndeterminate(Iterable<K> other) {
    if (identical(this, other)) {
      return true;
    }
    return other.every(containsKey);
  }

  /// Returns whether `this` contains only the keys in [other].
  ///
  /// The keys must be equal (as determined by [Object.==]).
  ///
  /// ## Performance
  ///
  /// This method assumes that [length] can be efficiently computed for [other]
  /// in order to early exit if [other] is longer than `this`; otherwise, it
  /// will iterate over [other] to check if every key is contained in `this`.
  /// Use [containsOnlyKeysIndeterminate] if you cannot guarantee that [length]
  /// can be efficiently computed for [other].
  bool containsOnlyKeys(Iterable<K> other) {
    if (length != other.length) {
      return false;
    }
    return containsOnlyKeysIndeterminate(other);
  }

  /// Returns whether `this` contains only the keys in [other].
  ///
  /// The keys must be equal (as determined by [Object.==]).
  ///
  /// ## Performance
  ///
  /// This method will iterate over [other] to check if every key is contained
  /// in `this`. Use [containsOnlyKeys] if you can guarantee that [length] can
  /// be efficiently computed for [other].
  ///
  /// ## Example
  ///
  /// ```dart
  /// final map = {'a': 1, 'b': 2, 'c': 3};
  /// final other = {'b': 2, 'c': 3};
  /// print(map.containsOnlyKeysIndeterminate(other.keys)); // false
  /// ```
  bool containsOnlyKeysIndeterminate(Iterable<K> other) {
    if (identical(this, other)) {
      return true;
    }

    var count = 0;
    for (final key in other) {
      count++;
      if (!containsKey(key)) {
        return false;
      }
    }

    // Check if there are any extra keys in `this`.
    return count == length;
  }

  /// Returns whether `this` contains every key-value pair in [other].
  ///
  /// The key-value pairs must be equal (as determined by [Object.==]).
  ///
  /// ## Performance
  ///
  /// This method assumes that [length] can be efficiently computed for both
  /// [other] in order to early exit if [other] is longer than `this`;
  /// otherwise, it will iterate over [other] to check if every key-value pair
  /// is contained in `this`. Use [containsAllEntriesIndeterminate] if you
  /// cannot guarantee that [length] can be efficiently computed for [other].
  ///
  /// ## Example
  ///
  /// ```dart
  /// final map = {'a': 1, 'b': 2, 'c': 3};
  /// final other = {'b': 2, 'c': 3};
  /// print(map.containsAllEntries(other.entries)); // true
  /// ```
  bool containsAllEntries(Iterable<MapEntry<K, V>> other) {
    if (length < other.length) {
      return false;
    }
    return containsAllEntriesIndeterminate(other);
  }

  /// Returns whether `this` contains every key-value pair in [other].
  ///
  /// The key-value pairs must be equal (as determined by [Object.==]).
  ///
  /// ## Performance
  ///
  /// This method will iterate over [other] to check if every key-value pair is
  /// contained in `this`. Use [containsAllEntries] if you can guarantee that
  /// [length] can be efficiently computed for [other].
  ///
  /// ## Example
  ///
  /// ```dart
  /// final map = {'a': 1, 'b': 2, 'c': 3};
  /// final other = {'b': 2, 'c': 3};
  /// print(map.containsAllEntriesIndeterminate(other.entries)); // true
  /// ```
  bool containsAllEntriesIndeterminate(Iterable<MapEntry<K, V>> other) {
    if (identical(this, other)) {
      return true;
    }
    return other.every((entry) => this[entry.key] == entry.value);
  }

  /// Returns whether `this` contains only the key-value pairs in [other].
  ///
  /// The key-value pairs must be equal (as determined by [Object.==]) and in
  /// the same order.
  ///
  /// ## Performance
  ///
  /// This method assumes that [length] can be efficiently computed for both
  /// [other] in order to early exit if [other] is longer than `this`;
  /// otherwise, it will iterate over [other] to check if every key-value pair
  /// is contained in `this`. Use [containsOnlyEntriesIndeterminate] if you
  /// cannot guarantee that [length] can be efficiently computed for [other].
  ///
  /// ## Example
  ///
  /// ```dart
  /// final map = {'a': 1, 'b': 2, 'c': 3};
  /// final other = {'b': 2, 'c': 3};
  /// print(map.containsOnlyEntries(other.entries)); // false
  /// ```
  bool containsOnlyEntries(Iterable<MapEntry<K, V>> other) {
    if (length != other.length) {
      return false;
    }
    return containsOnlyEntriesIndeterminate(other);
  }

  /// Returns whether `this` contains only the key-value pairs in [other].
  ///
  /// The key-value pairs must be equal (as determined by [Object.==]) and in
  /// the same order.
  ///
  /// ## Performance
  ///
  /// This method will iterate over [other] to check if every key-value pair is
  /// contained in `this`. Use [containsOnlyEntries] if you can guarantee that
  /// [length] can be efficiently computed for [other].
  ///
  /// ## Example
  ///
  /// ```dart
  /// final map = {'a': 1, 'b': 2, 'c': 3};
  /// final other = {'b': 2, 'c': 3};
  /// print(map.containsOnlyEntriesIndeterminate(other.entries)); // false
  /// ```
  bool containsOnlyEntriesIndeterminate(Iterable<MapEntry<K, V>> other) {
    if (identical(this, other)) {
      return true;
    }

    var count = 0;
    for (final entry in other) {
      count++;
      if (this[entry.key] != entry.value) {
        return false;
      }
    }

    // Check if there are any extra entries in `this`.
    return count == length;
  }
}

/// Extension for nullable [Map]s.
extension NullableMapExtension<K, V> on Map<K, V>? {
  /// Returns whether `this` or null or empty.
  bool get isNullOrEmpty {
    if (this case final map?) {
      return map.isEmpty;
    }
    return true;
  }

  /// Returns an empty map if `this` is null, otherwise returns `this`.
  Map<K, V> get orEmpty {
    if (this case final map?) {
      return map;
    }
    return {};
  }
}
