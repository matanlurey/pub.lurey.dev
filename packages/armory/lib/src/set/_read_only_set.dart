part of '../iterable.dart';

/// A read-only view of a set.
///
/// The underlying set may be mutable, but this class does not provide any
/// methods to modify the set.
abstract interface class ReadOnlySet<E> implements Iterable<E> {
  /// Returns a view of this set as a set of [R] instances.
  ///
  /// If this view contains only instances of [R], all read operations will
  /// work correctly. If any operartion tries to read an element that is not
  /// an instance of [R], the access will throw instead.
  @override
  ReadOnlySet<R> cast<R>();

  /// Whether [value] is in the set.
  ///
  /// See [Set.contains].
  @override
  bool contains(Object? value);

  /// If an object equal to [object] is in the set, return it.
  ///
  /// See [Set.lookup].
  E? lookup(Object? object);

  /// Whether this set contains all the elements of [other].
  ///
  /// See [Set.containsAll].
  bool containsAll(Iterable<Object?> other);

  /// Creates a new set which is the intersection between this set and [other].
  ///
  /// See [Set.intersection].
  Set<E> intersection(Set<Object?> other);

  /// Creates a new set which contains all the elements of this set and [other].
  ///
  /// See [Set.union].
  Set<E> union(Set<E> other);

  /// Creates a new set with the elements of this that are not in [other].
  ///
  /// See [Set.difference].
  Set<E> difference(Set<Object?> other);

  /// An unmodifiable [Set] view of this set.
  ///
  /// Adapts the [ReadOnlySet] to a [Set] where all operations that modify the
  /// set throw an [UnsupportedError].
  Set<E> asSet();
}
