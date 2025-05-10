part of '../map.dart';

/// A copy-on-write map, or view of an existing map.
///
/// If the map is not modified, no copy of the map is made.
abstract final class CopyOnWriteMap<K, V> implements Map<K, V> {
  /// Creates a copy-on-write view of an existing [map].
  factory CopyOnWriteMap(Map<K, V> map) = _CopyOnWriteMap<K, V>;

  @override
  CopyOnWriteMap<RK, RV> cast<RK, RV>();
}

final class _CopyOnWriteMap<K, V>
    with _ReadOnlyMap<K, V>
    implements CopyOnWriteMap<K, V> {
  _CopyOnWriteMap(this._delegate);

  @override
  Map<K, V> _delegate;
  var _wasChanged = false;

  void _copyIfPristine() {
    if (_wasChanged) {
      return;
    }
    _delegate = {..._delegate};
    _wasChanged = true;
  }

  @override
  CopyOnWriteMap<RK, RV> cast<RK, RV>() {
    return _CopyOnWriteMap(_delegate.cast());
  }

  @override
  void operator []=(K key, V value) {
    _copyIfPristine();
    _delegate[key] = value;
  }

  @override
  void addAll(Map<K, V> other) {
    _copyIfPristine();
    _delegate.addAll(other);
  }

  @override
  void addEntries(Iterable<MapEntry<K, V>> newEntries) {
    _copyIfPristine();
    _delegate.addEntries(newEntries);
  }

  @override
  void clear() {
    _copyIfPristine();
    _delegate.clear();
  }

  @override
  V putIfAbsent(K key, V Function() ifAbsent) {
    _copyIfPristine();
    return _delegate.putIfAbsent(key, ifAbsent);
  }

  @override
  V? remove(Object? key) {
    _copyIfPristine();
    return _delegate.remove(key);
  }

  @override
  void removeWhere(bool Function(K key, V value) test) {
    _copyIfPristine();
    _delegate.removeWhere(test);
  }

  @override
  V update(K key, V Function(V value) update, {V Function()? ifAbsent}) {
    _copyIfPristine();
    return _delegate.update(key, update, ifAbsent: ifAbsent);
  }

  @override
  void updateAll(V Function(K key, V value) update) {
    _copyIfPristine();
    _delegate.updateAll(update);
  }
}
