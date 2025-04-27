part of '../../collection.dart';

/// A map that, upon modification, creates a copy of the underlying map.
abstract final class CopyOnWriteMap<K, V> implements Map<K, V> {
  /// Creates a map that copies the underlying map on modification.
  factory CopyOnWriteMap(Map<K, V> delegate) = _CopyOnWriteMap<K, V>;
}

final class _CopyOnWriteMap<K, V>
    with _DelegatingMapReadMixin<K, V>
    implements CopyOnWriteMap<K, V> {
  _CopyOnWriteMap(this._delegate);

  @override
  Map<K, V> _delegate;

  var _isOriginal = true;
  void _copyIfOriginal() {
    if (_isOriginal) {
      _isOriginal = false;
      _delegate = {..._delegate};
    }
  }

  @override
  void operator []=(K key, V value) {
    _copyIfOriginal();
    _delegate[key] = value;
  }

  @override
  void addEntries(Iterable<MapEntry<K, V>> entries) {
    _copyIfOriginal();
    _delegate.addEntries(entries);
  }

  @override
  V update(K key, V Function(V value) update, {V Function()? ifAbsent}) {
    _copyIfOriginal();
    return _delegate.update(key, update, ifAbsent: ifAbsent);
  }

  @override
  void updateAll(V Function(K key, V value) update) {
    _copyIfOriginal();
    _delegate.updateAll(update);
  }

  @override
  void removeWhere(bool Function(K key, V value) test) {
    _copyIfOriginal();
    _delegate.removeWhere(test);
  }

  @override
  V putIfAbsent(K key, V Function() ifAbsent) {
    _copyIfOriginal();
    return _delegate.putIfAbsent(key, ifAbsent);
  }

  @override
  void addAll(Map<K, V> other) {
    _copyIfOriginal();
    _delegate.addAll(other);
  }

  @override
  V? remove(Object? key) {
    _copyIfOriginal();
    return _delegate.remove(key);
  }

  @override
  void clear() {
    _copyIfOriginal();
    _delegate.clear();
  }
}
