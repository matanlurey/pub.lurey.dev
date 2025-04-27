part of '../../collection.dart';

/// A list that delegates all operations to an underlying implementation.
abstract final class DelegatingList<E> implements List<E> {
  /// Creates a delegating list.
  ///
  /// Can be used to hide the implementation of an list.
  const factory DelegatingList(
    List<E> delegate, //
  ) = _DelegatingList<E>;
}

final class _DelegatingList<E>
    with
        _DelegatingIterableMixin<E>,
        _DelegatingListReadMixin<E>,
        _DelegatingListWriteMixin<E>
    implements DelegatingList<E> {
  const _DelegatingList(this._delegate);
  final List<E> _delegate;
}
