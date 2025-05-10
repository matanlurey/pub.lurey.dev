part of '../iterable.dart';

/// Additional methods for [Iterable].
extension IterableExtension<E> on Iterable<E> {
  /// Returns whether `this` contains every element in [other] in the same
  /// order and no other elements.
  ///
  /// If it is known that both iterables have an efficient [length] getter,
  /// consider checking first:
  /// ```dart
  /// return a.length == b.length && a.deepEquals(b);
  /// ```
  bool deepEquals(Iterable<E> other) {
    final aIterator = iterator;
    final bIterator = other.iterator;
    while (aIterator.moveNext()) {
      if (!bIterator.moveNext()) {
        return false;
      }
      if (aIterator.current != bIterator.current) {
        return false;
      }
    }
    return !bIterator.moveNext();
  }

  /// Returns an unmodifiable view of this iterable.
  ///
  /// This method is equivalent to [toList(growable: false)].
  List<E> toUnmodifiableList() {
    return List.unmodifiable(this);
  }

  /// Returns an immutable copy of this iterable.
  ImmutableList<E> toImmutableList() {
    return ImmutableList(this);
  }
}
