part of '../../collection.dart';

/// Extension methods for [Iterable].
extension IterableExtension<E> on Iterable<E> {
  /// Returns whether `this` contains every element of [other] at least once.
  ///
  /// This method returns the same result as:
  /// ```dart
  /// other.every(contains);
  /// ```
  ///
  /// ... but can be more efficient, trading space for time.
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
  /// If `this` is a [Set], `O(1)`.
  ///
  /// Otherwise, `O(n)` where `n` is the number of elements in `this`.
  ///
  /// ## Example
  ///
  /// ```dart
  /// [1, 2, 3].containsEvery([1, 2]); // true
  /// [1, 2, 3].containsEvery([1, 2, 2]); // true
  /// [1, 2, 3].containsEvery([1, 2, 4]); // false
  /// ```
  bool containsAtLeastOnce(Iterable<E> other) {
    if (this case final Set<E> set) {
      return set.containsAll(other);
    }
    final elements = other.toSet();
    for (final element in this) {
      if (elements.remove(element) && elements.isEmpty) {
        return true;
      }
    }
    return elements.isEmpty;
  }

  /// Returns whether `this` contains only every element of [other] in the same
  /// order.
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
  /// [1, 2, 3].orderedEquals([1, 2, 3]); // true
  /// [1, 2, 3].orderedEquals([1, 2]); // false
  /// [1, 2, 3].orderedEquals([1, 2, 4]); // false
  bool orderedEquals(Iterable<E> other) {
    final thisIterator = iterator;
    final otherIterator = other.iterator;
    while (thisIterator.moveNext() && otherIterator.moveNext()) {
      if (thisIterator.current != otherIterator.current) {
        return false;
      }
    }
    return !thisIterator.moveNext() && !otherIterator.moveNext();
  }

  /// Returns whether `this` contains only every element of [other] in any
  /// order.
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
  /// If both `this` is a [Set], `O(1)`.
  ///
  /// `O(n^2)` where `n` is the number of elements in `this`.
  ///
  /// ## Example
  ///
  /// ```dart
  /// [1, 2, 3].unorderedEquals([1, 2, 3]); // true
  /// [1, 2, 3].unorderedEquals([3, 1, 2]); // true
  /// [1, 2, 3].unorderedEquals([1, 2]); // false
  /// [1, 2, 3].unorderedEquals([1, 2, 3, 4]); // false
  /// ```
  bool unorderedEquals(Iterable<E> other) {
    if (this case final Set<E> set) {
      return set.containsAll(other);
    }

    final count = <E, int>{};
    for (final element in this) {
      count[element] = (count[element] ?? 0) + 1;
    }

    // Now countdown the elements in `other`.
    // If at any point we go below zero, we have a mismatch.
    for (final element in other) {
      final currentCount = count[element];
      if (currentCount == null || currentCount <= 0) {
        return false;
      }
      count[element] = currentCount - 1;
    }

    // If we have any elements left, we have a mismatch.
    for (final element in count.values) {
      if (element > 0) {
        return false;
      }
    }

    return true;
  }

  /// Returns `this` as an unmodifiable [List].
  List<E> toUnmodifiableList() {
    return List.unmodifiable(this);
  }

  /// Returns `this` as an unmodifiable [Set].
  Set<E> toUnmodifiableSet() {
    return Set.unmodifiable(this);
  }
}

/// Extension methods for [Iterable] or `null`.
extension NullableIterableExtension<E> on Iterable<E>? {
  /// Whether `this` is `null` or empty.
  bool get isNullOrEmpty => this?.isEmpty ?? true;

  /// Returns an empty iterable if `this` is `null`.
  ///
  /// Otherwise, returns `this`.
  Iterable<E> get orEmpty => this ?? const Iterable.empty();
}
