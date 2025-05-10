part of '../iterable.dart';

/// Additional methods for [Set].
extension SetExtension<E> on Set<E> {
  /// Returns whether `this` contains every element in [other] and no other
  /// elements.
  bool deepEquals(Iterable<E> other) {
    if (other is Set<E>) {
      if (length != other.length) {
        return false;
      }
      return _deepEqualsSet(other);
    }
    return _deepEqualsIterable(other);
  }

  bool _deepEqualsIterable(Iterable<E> other) {
    var count = 0;
    for (final element in other) {
      if (!contains(element)) {
        return false;
      }
      count++;
    }
    return count == length;
  }

  bool _deepEqualsSet(Set<E> other) {
    assert(other.length == length, 'Sets must be the same length');
    return containsAll(other);
  }
}
