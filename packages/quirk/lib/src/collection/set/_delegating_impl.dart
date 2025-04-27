part of '../../collection.dart';

/// A set that delegates all operations to an underlying implementation.
abstract final class DelegatingSet<E> implements Set<E> {
  /// Creates a delegating set.
  ///
  /// Can be used to hide the implementation of a set.
  const factory DelegatingSet(
    Set<E> delegate, //
  ) = _DelegatingSet<E>;
}

final class _DelegatingSet<E>
    with
        _DelegatingIterableMixin<E>,
        _DelegatingSetReadMixin<E>,
        _DelegatingSetWriteMixin<E>
    implements DelegatingSet<E> {
  const _DelegatingSet(this._delegate);
  final Set<E> _delegate;
}
