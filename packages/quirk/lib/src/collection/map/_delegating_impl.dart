part of '../../collection.dart';

/// A map that delegates all operations to an underlying implementation.
abstract final class DelegatingMap<K, V> implements Map<K, V> {
  /// Creates a delegating map.
  ///
  /// Can be used to hide the implementation of a map.
  const factory DelegatingMap.view(
    Map<K, V> delegate, //
  ) = _DelegatingMap<K, V>;
}

final class _DelegatingMap<K, V>
    with _DelegatingMapReadMixin<K, V>, _DelegatingMapWriteMixin<K, V>
    implements DelegatingMap<K, V> {
  const _DelegatingMap(this._delegate);
  final Map<K, V> _delegate;

  @override
  _DelegatingMap<RK, RV> cast<RK, RV>() {
    return _DelegatingMap<RK, RV>(_delegate.cast());
  }
}
