part of '../map.dart';

/// A read-only view of a map.
///
/// The underlying map may be mutable, but this class does not provide any
/// methods to modify the map.
abstract interface class ReadOnlyMap<K, V> {
  /// Provides a view of this map as having [RK] keys and [RV] instances,
  /// if necessary.
  ///
  /// See [Map.cast].
  ReadOnlyMap<RK, RV> cast<RK, RV>();

  /// Whether this map contains the given [value].
  ///
  /// See [Map.containsValue].
  bool containsValue(Object? value);

  /// Whether this map contains the given [key].
  ///
  /// See [Map.containsKey].
  bool containsKey(Object? key);

  /// The value for the given [key], or `null` if [key] is not in the map.
  ///
  /// See [Map.operator []].
  V? operator [](Object? key);

  /// The map entries of this map.
  ///
  /// See [Map.entries].
  Iterable<MapEntry<K, V>> get entries;

  /// Returns a new map where all entries of this map are transformed by
  /// the given [convert] function.
  ///
  /// See [Map.map].
  Map<K2, V2> map<K2, V2>(MapEntry<K2, V2> Function(K key, V value) convert);

  /// Applies [action] to each key/value pair of the map.
  ///
  /// See [Map.forEach].
  void forEach(void Function(K key, V value) action);

  /// The keys of this map.
  ///
  /// See [Map.keys].
  Iterable<K> get keys;

  /// The values of this map.
  ///
  /// See [Map.values].
  Iterable<V> get values;

  /// The number of key/value pairs in the map.
  ///
  /// See [Map.length].
  int get length;

  /// Whether there is no key/value pair in the map.
  ///
  /// See [Map.isEmpty].
  bool get isEmpty;

  /// Whether there is at least one key/value pair in the map.
  ///
  /// See [Map.isNotEmpty].
  bool get isNotEmpty;

  /// An unmodifiable [Map] view of this map.
  ///
  /// Adapts the [ReadOnlyMap] to a [Map] where all operations that modify the
  /// map throw an [UnsupportedError].
  Map<K, V> asMap();
}
