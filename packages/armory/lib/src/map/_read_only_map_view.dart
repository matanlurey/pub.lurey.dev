part of '../map.dart';

/// A read-only view of a map.
base class ReadOnlyMapView<K, V>
    with _ReadOnlyMap<K, V>
    implements ReadOnlyMap<K, V> {
  /// Creates a wrapper that forwards all operations to the given map.
  const ReadOnlyMapView(this._delegate);

  @override
  final Map<K, V> _delegate;

  @override
  ReadOnlyMap<RK, RV> cast<RK, RV>() {
    return ReadOnlyMapView(_delegate.cast());
  }
}

base mixin _ReadOnlyMap<K, V> /* implements ReadOnlyMap<K, V> */ {
  Map<K, V> get _delegate;

  bool containsValue(Object? value) {
    return _delegate.containsValue(value);
  }

  bool containsKey(Object? key) {
    return _delegate.containsKey(key);
  }

  V? operator [](Object? key) {
    return _delegate[key];
  }

  Iterable<MapEntry<K, V>> get entries {
    return _delegate.entries;
  }

  Map<K2, V2> map<K2, V2>(MapEntry<K2, V2> Function(K key, V value) convert) {
    return _delegate.map(convert);
  }

  void forEach(void Function(K key, V value) action) {
    _delegate.forEach(action);
  }

  Iterable<K> get keys {
    return _delegate.keys;
  }

  Iterable<V> get values {
    return _delegate.values;
  }

  int get length {
    return _delegate.length;
  }

  bool get isEmpty {
    return _delegate.isEmpty;
  }

  bool get isNotEmpty {
    return _delegate.isNotEmpty;
  }

  Map<K, V> asMap() {
    return UnmodifiableMapView(_delegate);
  }
}
