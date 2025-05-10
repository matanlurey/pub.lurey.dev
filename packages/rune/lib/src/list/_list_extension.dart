part of '../iterable.dart';

/// Additional methods for [List].
extension ListExtension<E> on List<E> {
  /// Returns whether `this` contains every element in [other] in the same
  /// order and no other elements.
  bool deepEquals(Iterable<E> other) {
    if (other is List<E>) {
      if (length != other.length) {
        return false;
      }
      return _deepEqualsList(other);
    }
    return IterableExtension(this).deepEquals(other);
  }

  bool _deepEqualsList(List<E> other) {
    assert(other.length == length, 'Lists must be the same length');
    for (var i = 0; i < length; i++) {
      if (this[i] != other[i]) {
        return false;
      }
    }
    return true;
  }
}
