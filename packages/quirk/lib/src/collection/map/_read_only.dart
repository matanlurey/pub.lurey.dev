part of '../../collection.dart';

/// A read-only view of a map.
///
/// This type exposes the read-only methods of [Map] but by contract does not
/// expose the mutating methods. For APIs that require the full [Map] API, see
/// [asMap].
abstract interface class ReadOnlyMap<K, V> {
  /// Creates a read-only view of a map.
  const factory ReadOnlyMap.view(Map<K, V> delegate) = _ReadOnlyMap<K, V>;

  /// Casts this map to a [Map] with the given key and value types.
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

  /// The value for the given [key], or null if [key] is not in the map.
  ///
  /// See [Map.operator []].
  V? operator [](Object? key);

  /// The map entries of this [Map].
  ///
  /// See [Map.entries].
  Iterable<MapEntry<K, V>> get entries;

  /// Returns a new map where all entries of this map are transformed by the
  /// given [convert] function.
  ///
  /// /// See [Map.map].
  Map<K2, V2> map<K2, V2>(MapEntry<K2, V2> Function(K key, V value) convert);

  /// Applies [action] to each key/value pair of the map.
  ///
  /// /// See [Map.forEach].
  void forEach(void Function(K key, V value) action);

  /// The keys of this [Map].
  ///
  /// See [Map.keys].
  Iterable<K> get keys;

  /// The values of this [Map].
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

  /// Returns an unmodifiable [Map] view of this map.
  Map<K, V> asMap();
}

final class _ReadOnlyMap<K, V>
    with _DelegatingMapReadMixin<K, V>
    implements ReadOnlyMap<K, V> {
  const _ReadOnlyMap(this._delegate);

  @override
  final Map<K, V> _delegate;

  @override
  ReadOnlyMap<RK, RV> cast<RK, RV>() {
    return ReadOnlyMap.view(_delegate.cast());
  }
}
