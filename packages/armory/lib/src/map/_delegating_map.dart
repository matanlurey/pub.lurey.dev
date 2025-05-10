part of '../map.dart';

/// A [Map] that forwards all operations to a base map.
base class DelegatingMap<K, V>
    with _ReadOnlyMap<K, V>, _DelegatingMap<K, V>
    implements Map<K, V> {
  /// Creates a wrapper that forwards all operations to the given map.
  const DelegatingMap(this._delegate);

  @override
  final Map<K, V> _delegate;
}

base mixin _DelegatingMap<K, V> implements Map<K, V> {
  Map<K, V> get _delegate;

  @override
  void operator []=(K key, V value) {
    _delegate[key] = value;
  }

  @override
  void addAll(Map<K, V> other) {
    _delegate.addAll(other);
  }

  @override
  void addEntries(Iterable<MapEntry<K, V>> newEntries) {
    _delegate.addEntries(newEntries);
  }

  @override
  Map<RK, RV> cast<RK, RV>() {
    return _delegate.cast<RK, RV>();
  }

  @override
  void clear() {
    _delegate.clear();
  }

  @override
  V putIfAbsent(K key, V Function() ifAbsent) {
    return _delegate.putIfAbsent(key, ifAbsent);
  }

  @override
  V? remove(Object? key) {
    return _delegate.remove(key);
  }

  @override
  void removeWhere(bool Function(K key, V value) test) {
    _delegate.removeWhere(test);
  }

  @override
  V update(K key, V Function(V value) update, {V Function()? ifAbsent}) {
    return _delegate.update(key, update, ifAbsent: ifAbsent);
  }

  @override
  void updateAll(V Function(K key, V value) update) {
    _delegate.updateAll(update);
  }
}
