import 'dart:collection';

/// Extensions for [Iterable]s.
extension IterableExtension<T> on Iterable<T> {
  /// Returns whether `this` contains every element in [other] at least once.
  ///
  /// The elements must be equal (as determined by [Object.==]).
  ///
  /// ## Performance
  ///
  /// This method assumes that [length] can be efficiently computed for both
  /// `this` and [other] in order to early exit if [other] is longer than
  /// `this`; otherwise, it will iterate over [other] to check if every element
  /// is contained in `this`. Use [containsAllAtLeastOnceIndeterminate] if you
  /// cannot guarantee that [length] can be efficiently computed for both
  /// [other] and `this`.
  ///
  /// ## Example
  ///
  /// ```dart
  /// final list = [1, 2, 3];
  /// final other = [2, 3];
  /// print(list.containsAllAtLeastOnce(other)); // true
  /// ```
  bool containsAllAtLeastOnce(Iterable<T> other) {
    if (length < other.length) {
      return false;
    }
    return containsAllAtLeastOnceIndeterminate(other);
  }

  /// Returns whether `this` contains every element in [other] at least once.
  ///
  /// The elements must be equal (as determined by [Object.==]).
  ///
  /// ## Performance
  ///
  /// This method will iterate over [other] to check if every element is
  /// contained in `this`. Use [containsAllAtLeastOnce] if you can guarantee
  /// that [length] can be efficiently computed for both `this` and [other].
  ///
  /// ## Example
  ///
  /// ```dart
  /// final list = [1, 2, 3];
  /// final other = [2, 3];
  /// print(list.containsAllAtLeastOnceIndeterminate(other)); // true
  /// ```
  bool containsAllAtLeastOnceIndeterminate(Iterable<T> other) {
    if (identical(this, other)) {
      return true;
    }
    return other.every(contains);
  }

  /// Returns whether `this` contains every element in [other] the same number
  /// of times.
  ///
  /// The elements must be equal (as determined by [Object.==]).
  ///
  /// ## Performance
  ///
  /// This method assumes that [length] can be efficiently computed for both
  /// `this` and [other] in order to early exit if [other] is longer than
  /// `this`; otherwise, it will iterate over [other] to check if every element
  /// is contained in `this`. Use [containsAllIndeterminate] if you cannot
  /// guarantee that [length] can be efficiently computed for both [other] and
  /// `this`.
  ///
  /// ## Example
  ///
  /// ```dart
  /// final list = [1, 2, 3, 3];
  /// final other = [2, 3, 3];
  /// print(list.containsAll(other)); // true
  /// ```
  bool containsAll(Iterable<T> other) {
    if (length < other.length) {
      return false;
    }
    return containsAllIndeterminate(other);
  }

  /// Returns whether `this` contains every element in [other] the same number
  /// of times.
  ///
  /// The elements must be equal (as determined by [Object.==]).
  ///
  /// ## Performance
  ///
  /// This method will iterate over [other] to check if every element is
  /// contained in `this`. Use [containsAll] if you can guarantee that [length]
  /// can be efficiently computed for both `this` and [other].
  ///
  /// ## Example
  ///
  /// ```dart
  /// final list = [1, 2, 3, 3];
  /// final other = [2, 3, 3];
  /// print(list.containsAllIndeterminate(other)); // true
  /// ```
  bool containsAllIndeterminate(Iterable<T> other) {
    if (identical(this, other)) {
      return true;
    }
    final counts = HashMap<T, int>();
    for (final element in this) {
      counts[element] = (counts[element] ?? 0) + 1;
    }
    for (final element in other) {
      final count = counts[element];
      if (count == null || count == 0) {
        return false;
      }
      counts[element] = count - 1;
    }
    return true;
  }

  /// Returns whether `this` contains only the elements in [other].
  ///
  /// The elements must be equal (as determined by [Object.==]) and the order
  /// must be the same.
  ///
  /// ## Performance
  ///
  /// This method assumes that [length] can be efficiently computed for both
  /// `this` and [other] in order to early exit if [other] is longer than
  /// `this`; otherwise, it will iterate over [other] to check if every element
  /// is contained in `this`. Use [containsOnlyIndeterminate] if you cannot
  /// guarantee that [length] can be efficiently computed for both [other] and
  /// `this`.
  ///
  /// ## Example
  ///
  /// ```dart
  /// final list = [1, 2, 3];
  /// final other = [1, 2, 3];
  /// print(list.containsOnly(other)); // true
  /// ```
  bool containsOnly(Iterable<T> other) {
    if (length != other.length) {
      return false;
    }
    return containsOnlyIndeterminate(other);
  }

  /// Returns whether `this` contains only the elements in [other].
  ///
  /// The elements must be equal (as determined by [Object.==]) and the order
  /// must be the same.
  ///
  /// ## Performance
  ///
  /// This method will iterate over [other] to check if every element is
  /// contained in `this`. Use [containsOnly] if you can guarantee that [length]
  /// can be efficiently computed for both `this` and [other].
  ///
  /// ## Example
  ///
  /// ```dart
  /// final list = [1, 2, 3];
  /// final other = [1, 2, 3];
  /// print(list.containsOnlyIndeterminate(other)); // true
  /// ```
  bool containsOnlyIndeterminate(Iterable<T> other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is Set<T>) {
      return _containsOnlyIndeterminateSet(other);
    }
    final iterator = other.iterator;
    for (final element in this) {
      if (!iterator.moveNext() || element != iterator.current) {
        return false;
      }
    }
    // coverage:ignore-start
    throw StateError('Unreachable');
    // coverage:ignore-end
  }

  bool _containsOnlyIndeterminateSet(Set<T> other) {
    var found = 0;
    for (final element in other) {
      if (!contains(element)) {
        return false;
      }
      found++;
    }
    return found == length;
  }

  /// Returns whether `this` contains only the elements in [other] in any order.
  ///
  /// The elements must be equal (as determined by [Object.==]).
  ///
  /// ## Performance
  ///
  /// This method assumes that [length] can be efficiently computed for both
  /// `this` and [other] in order to early exit if [other] is longer than
  /// `this`; otherwise, it will iterate over [other] to check if every element
  /// is contained in `this`. Use [containsOnlyUnorderedIndeterminate] if you
  /// cannot guarantee that [length] can be efficiently computed for both
  /// [other] and `this`.
  ///
  /// ## Example
  ///
  /// ```dart
  /// final list = [1, 2, 3];
  /// final other = [3, 2, 1];
  /// print(list.containsOnlyUnordered(other)); // true
  /// ```
  bool containsOnlyUnordered(Iterable<T> other) {
    if (length != other.length) {
      return false;
    }
    return containsOnlyUnorderedIndeterminate(other);
  }

  /// Returns whether `this` contains only the elements in [other] in any order.
  ///
  /// The elements must be equal (as determined by [Object.==]).
  ///
  /// ## Performance
  ///
  /// This method will iterate over [other] to check if every element is
  /// contained in `this`. Use [containsOnlyUnordered] if you can guarantee that
  /// [length] can be efficiently computed for both `this` and [other].
  ///
  /// ## Example
  ///
  /// ```dart
  /// final list = [1, 2, 3];
  /// final other = [3, 2, 1];
  /// print(list.containsOnlyUnorderedIndeterminate(other)); // true
  /// ```
  bool containsOnlyUnorderedIndeterminate(Iterable<T> other) {
    if (identical(this, other)) {
      return true;
    }
    final counts = HashMap<T, int>();
    for (final element in this) {
      counts[element] = (counts[element] ?? 0) + 1;
    }
    for (final element in other) {
      final count = counts[element];
      if (count == null || count == 0) {
        return false;
      }
      counts[element] = count - 1;
    }
    return true;
  }

  /// Returns `this` as a [Set].
  ///
  /// Each element in `this` must be unique (as determined by [Object.==]).
  ///
  /// ## Example
  ///
  /// ```dart
  /// final list = [1, 2, 3, 3];
  ///
  /// print(list.toSet()); // {1, 2, 3}
  /// print(list.toSetRejectDuplicates()); // Throws
  /// ```
  Set<T> toSetRejectDuplicates({String? name, String? message}) {
    final set = toSet();
    if (set.length != length) {
      throw ArgumentError.value(
        this,
        name,
        message ?? 'Duplicate elements found',
      );
    }
    return set;
  }

  /// Returns `this` as an unmodifiable [Set].
  ///
  /// ## Example
  ///
  /// ```dart
  /// final list = [1, 2, 3, 3];
  ///
  /// print(list.toUnmodifiableSet()); // {1, 2, 3}
  /// ```
  Set<T> toUnmodifiableSet() => Set.unmodifiable(this);

  /// Returns `this` as an unmodifiable [Set].
  ///
  /// Each element in `this` must be unique (as determined by [Object.==]).
  ///
  /// ## Example
  ///
  /// ```dart
  /// final list = [1, 2, 3, 3];
  ///
  /// print(list.toUnmodifiableSet()); // {1, 2, 3}
  /// print(list.toUnmodifiableSetRejectDuplicates()); // Throws
  /// ```
  Set<T> toUnmodifiableSetRejectDuplicates({String? name, String? message}) {
    final set = toUnmodifiableSet();
    if (set.length != length) {
      throw ArgumentError.value(
        this,
        name,
        message ?? 'Duplicate elements found',
      );
    }
    return set;
  }
}
