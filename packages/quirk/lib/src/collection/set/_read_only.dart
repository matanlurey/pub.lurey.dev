part of '../../collection.dart';

/// A read-only view of a set.
///
/// This type exposes the read-only methods of [Set] (and [Iterable]) but by
/// contract does not expose the mutating methods. For APIs that require the
/// full [Set] API, see [asSet].
abstract interface class ReadOnlySet<E> implements Iterable<E> {
  /// Creates a read-only view of a set.
  const factory ReadOnlySet.view(Set<E> delegate) = _ReadOnlySet<E>;

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

  /// Returns an unmodifiable [Set] view of this set.
  Set<E> asSet();
}

final class _ReadOnlySet<E>
    with
        _DelegatingIterableMixin<E>, //
        _DelegatingSetReadMixin<E>
    implements ReadOnlySet<E> {
  const _ReadOnlySet(this._delegate);

  @override
  final Set<E> _delegate;
}
