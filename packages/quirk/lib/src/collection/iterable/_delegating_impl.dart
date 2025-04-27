part of '../../collection.dart';

/// An iterable that delegates all operations to an underlying implementation.
abstract final class DelegatingIterable<E> implements Iterable<E> {
  /// Creates a delegating iterable.
  ///
  /// Can be used to hide the implementation of an iterable.
  const factory DelegatingIterable(
    Iterable<E> delegate, //
  ) = _DelegatingIterable<E>;
}

final class _DelegatingIterable<E>
    with _DelegatingIterableMixin<E>
    implements DelegatingIterable<E> {
  const _DelegatingIterable(this._delegate);
  final Iterable<E> _delegate;
}
