part of '../collection.dart';

/// An entry for an present or absent key-value pair in an [IndexMap].
///
/// {@category Collections}
sealed class IndexedMapEntry<K, V> {
  const IndexedMapEntry(this.key);

  /// Returns `true` if the key is present in the map.
  ///
  /// Consider using pattern matching to access [value] and [index]:
  /// ```dart
  /// if (entry is PresentMapEntry<String, bool>) {
  ///   print(entry.key); // 'a'
  ///   print(entry.value); // true
  ///   print(entry.index); // 0
  /// }
  /// ```
  bool get isPresent => false;

  /// Returns `true` if the key is not present in the map.
  bool get isAbsent => !isPresent;

  /// A reference to the entry's key in the map, or the new key to be inserted.
  final K key;

  /// The index where the key-value pair exists.
  ///
  /// If the key is absent, this is the index where the key-value pair would be
  /// inserted.
  int get index;

  /// The value associated with the key, or `null` if the key is absent.
  V? get value;

  /// Sets the value associated with the key.
  ///
  /// If the key is present, the value is updated; otherwise, the key-value pair
  /// is inserted into the map.
  void setOrUpdate(V value);

  /// Inserts the key-value pair into the map if the key is absent.
  ///
  /// If the key is present, the value is not updated.
  ///
  /// Returns the value associated with the key after the operation.
  V putIfAbsent(V Function() ifAbsent);
}

/// An entry for a present key-value pair in an [IndexMap].
///
/// {@category Collections}
final class PresentMapEntry<K, V> extends IndexedMapEntry<K, V> {
  PresentMapEntry._(super.key, this.index, this._value) : super();

  @override
  bool get isPresent => true;

  @override
  final int index;

  @override
  V get value => _value;
  V _value;

  @override
  void setOrUpdate(V value) {
    _value = value;
  }

  @override
  V putIfAbsent(V Function() ifAbsent) => _value;
}

/// An entry for an absent key-value pair in an [IndexMap].
///
/// {@category Collections}
final class AbsentMapEntry<K, V> extends IndexedMapEntry<K, V> {
  AbsentMapEntry._(this._map, super.key);
  final _IndexMap<K, V> _map;

  @override
  bool get isAbsent => true;

  @override
  int get index => _map.length;

  @override
  V? get value => null;

  @override
  @pragma('vm:prefer-inline')
  void setOrUpdate(V value) {
    _map[key] = value;
  }

  @override
  @pragma('vm:prefer-inline')
  V putIfAbsent(V Function() ifAbsent) => _map.putIfAbsent(key, ifAbsent);
}
