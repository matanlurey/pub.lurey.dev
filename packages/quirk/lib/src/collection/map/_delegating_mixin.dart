part of '../../collection.dart';

/// An internal mixin that delegates all read operations to [_delegate].
///
/// Used as an implementation detail for other classes in this library.
base mixin _DelegatingMapReadMixin<K, V> {
  /// All operations are delegated to this map.
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

  void forEach(void Function(K key, V value) f) {
    _delegate.forEach(f);
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
    return _delegate.asUnmodifiable();
  }
}

/// An internal mixin that delegates all write operations to [_delegate].
///
/// Used as an implementation detail for other classes in this library.
base mixin _DelegatingMapWriteMixin<K, V> implements Map<K, V> {
  /// All operations are delegated to this map.
  Map<K, V> get _delegate;

  @override
  void operator []=(K key, V value) {
    _delegate[key] = value;
  }

  @override
  void addEntries(Iterable<MapEntry<K, V>> entries) {
    _delegate.addEntries(entries);
  }

  @override
  V update(K key, V Function(V value) update, {V Function()? ifAbsent}) {
    return _delegate.update(key, update, ifAbsent: ifAbsent);
  }

  @override
  void updateAll(V Function(K key, V value) update) {
    _delegate.updateAll(update);
  }

  @override
  void removeWhere(bool Function(K key, V value) test) {
    _delegate.removeWhere(test);
  }

  @override
  V putIfAbsent(K key, V Function() ifAbsent) {
    return _delegate.putIfAbsent(key, ifAbsent);
  }

  @override
  void addAll(Map<K, V> other) {
    _delegate.addAll(other);
  }

  @override
  V? remove(Object? key) {
    return _delegate.remove(key);
  }

  @override
  void clear() {
    _delegate.clear();
  }
}
