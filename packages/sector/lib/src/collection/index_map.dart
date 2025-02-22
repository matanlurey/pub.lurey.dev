part of '../collection.dart';

/// A hash map where element iteration order is independent of their hash codes.
///
/// ## Iteration Order
///
/// The keys, [K], have a consistent order that is determined by the sequence
/// of [operator[]=] and [remove] calls (or similar operations):
///
/// ```dart
/// final map = IndexMap<int, String>();
/// map[1] = 'a';
/// map[2] = 'b';
/// map[3] = 'c';
/// map.remove(2);
/// print(map); // {1: 'a', 3: 'c'}
/// ```
///
/// Unlike [LinkedHashMap], [remove] calls (and similar operations) shift
/// the iteration order; a removed element is swapped with the last element
/// in the map, and then removed:
///
/// ```dart
/// final map = IndexMap<int, String>();
/// map[1] = 'a';
/// map[2] = 'b';
/// map[3] = 'c';
/// map.remove(1);
/// print(map); // {3: 'c', 2: 'b'}
/// ```
///
/// ## Index Access
///
/// Like [IndexSet], [IndexMap] provides an additional set of operators.
///
/// [entryAt] returns a specialized key-value pair type, [IndexedMapEntry]. A
/// logical extension to [MapEntry], [IndexedMapEntry] not only contains the
/// `key` and `value`, but also the `index` of the element in the iteration
/// sequence:
///
/// ```dart
/// final map = IndexMap<String, bool>();
/// map['a'] = true;
/// map['b'] = false;
///
/// final entry = map.getEntryAt(1);
/// print(entry.key); // 'b'
/// print(entry.value); // false
/// print(entry.index); // 1
/// ```
///
/// However, unlike even [Map], [IndexMap] can return an [IndexedMapEntry]
/// _even_ if the key is not yet present in the map, giving a powerful and
/// performant way to insert elements at a specific index, using [entryOf] and
/// [IndexedMapEntry.setOrUpdate].
///
/// ```dart
/// final map = IndexMap<String, bool>();
/// map['a'] = true;
///
/// final a = map.tryGet('a');
/// print(a.isPresent); // true
/// print(a.key); // 'a'
/// print(a.value); // true
/// a.value = false;
/// a.setOrUpdate(false);
/// print(map); // {a: false}
///
/// final b = map.tryGet('b');
/// print(b.isAbsent); // false
/// print(b.key); // 'b'
/// print(b.value); // n
///
/// b.setOrUpdate(false);
/// print(map); // {a: false, b: false}
/// ```
///
/// ## Performance
///
/// If you want the properties of [IndexMap], or its strongest performance
/// characteristics fit your workload, it might be the fastest pure Dart [Map]
/// implementation available; for example `package:sector` uses it internally
/// for its graph search algorithms.
///
/// [IndexMap] derives some performance facts from how it is constructed:
///
/// 1. Iteration is as fast as a [List] (~2-3x faster than `dart:collection`).
/// 2. Removals are nearly as fast as [HashMap] (~300-400x faster).
/// 3. Creation is ~2x slower than [HashMap], 5x faster than [LinkedHashMap].
///
/// > [!TIP]
/// > Profile your workload to be sure.
///
/// {@category Collections}
abstract final class IndexMap<K, V> implements Map<K, V> {
  /// Creates an insertion-ordered indexing based [Map].
  ///
  /// ## Equality and Hashing
  ///
  /// If [equals] is provided, it is usd to compare the keys in the table with
  /// new keys. If it is omitted, the key's own [Object.==] is used instead.
  ///
  /// Similarly, if [hashCode] is provided, it is used to produce a hash value
  /// for keys in order to place them in the hash table, and if omitted, the
  /// key's own [Object.hashCode] is used instead.
  ///
  /// The used [equals] and [hashCode] functions must form an equivalence
  /// relation, and must be consistent with each other, so that if
  /// `equals(a, b)` then `hashCode(a) == hashCode(b)`. The hash of an object,
  /// or what it compares equal to, should not change while the object is in
  /// the table. If it does change, the result is unpredictable.
  ///
  /// If you supply one of [equals] or [hashCode], you should supply both.
  ///
  /// Some [equals] and [hashCode] functions might not work for all objects. If
  /// [isValidKey] is provided, it's used to check a potential key which is not
  /// necessarily an instance of [K], like the arguments of `[]`, [remove], and
  /// [containsKey], which are typed as `Object?`. If [isValidKey] returns
  /// `false` for an object, the [equals] and [hashCode] functions are not
  /// called, and no key equal to that object is assumed to be in the map.
  ///
  /// The [isValidKey] function defaults `is E` if omitted.
  @pragma('vm:prefer-inline')
  factory IndexMap({
    bool Function(K e1, K e2)? equals,
    int Function(K e)? hashCode,
    bool Function(Object? potentialKey)? isValidKey,
  }) {
    if (isValidKey == null) {
      if (hashCode == null) {
        if (equals == null) {
          return _IndexMap<K, V>();
        }
        hashCode = _defaultHashCode;
      } else {
        if (identical(identityHashCode, hashCode) &&
            identical(identical, equals)) {
          return IndexMap.identity();
        }
        equals ??= _defaultEquals;
      }
    } else {
      equals ??= _defaultEquals;
      hashCode ??= _defaultHashCode;
    }
    return _IndexMap<K, V>(
      HashMap<K, int>(
        equals: equals,
        hashCode: hashCode,
        isValidKey: isValidKey,
      ),
    );
  }

  /// Creates an [IndexMap] that uses [identical] and [identityHashCode].
  ///
  /// Equivalent to:
  /// ```dart
  /// IndexMap(equals: identical, hashCode: identityHashCode)
  /// ```
  factory IndexMap.identity() => _IndexMap<K, V>(HashMap.identity());

  /// Creates an [IndexMap] from [other].
  factory IndexMap.from(Map<K, V> other) {
    final map = IndexMap<K, V>();
    map.addAll(other);
    return map;
  }

  /// Creates an [IndexMap] from [entries].
  factory IndexMap.fromEntries(Iterable<MapEntry<K, V>> entries) {
    final map = IndexMap<K, V>();
    for (final entry in entries) {
      map[entry.key] = entry.value;
    }
    return map;
  }

  /// Returns the map entry at the given [index].
  ///
  /// The [index] must be a valid index of this map, which means that `index`
  /// must be non-negative and less than [length].
  ///
  /// ## Lifecycle
  ///
  /// The returned entry can be used to update the value at the index, using
  /// [IndexedMapEntry.setOrUpdate], but should not be stored for later use, as
  /// it may become invalid after a map operation.
  ///
  /// ## Example
  ///
  /// ```dart
  /// final map = IndexMap<String, bool>();
  ///
  /// map['a'] = true;
  /// map['b'] = false;
  ///
  /// final entry = map.entryAt(1);
  /// print(entry.key); // 'b'
  /// print(entry.value); // false
  /// print(entry.index); // 1
  ///
  /// entry.setOrUpdate(true);
  /// print(map); // {a: true, b: true}
  /// ```
  @doNotStore
  PresentMapEntry<K, V> entryAt(int index);

  /// Returns the map entry for the given [key].
  ///
  /// If the key is not present in the map, an [AbsentMapEntry] is returned.
  ///
  /// ## Lifecycle
  ///
  /// The returned entry can be used to insert the key-value pair into the map
  /// at a specific index, using [IndexedMapEntry.setOrUpdate], but should not
  /// be stored for later use, as it may become invalid after a map operation.
  ///
  /// ## Example
  ///
  /// ```dart
  /// final map = IndexMap<String, bool>();
  ///
  /// final a = map.entryOf('a');
  /// print(a.isPresent); // false
  /// print(a.key); // 'a'
  /// print(a.value); // null
  ///
  /// a.setOrUpdate(true);
  /// print(map); // {a: true}
  /// ```
  @doNotStore
  IndexedMapEntry<K, V> entryOf(K key);
}

final class _IndexMap<K, V> with MapBase<K, V> implements IndexMap<K, V> {
  _IndexMap([HashMap<K, int>? indices])
    : _indices = indices ?? HashMap<K, int>();
  final HashMap<K, int> _indices;
  final _entries = <PresentMapEntry<K, V>>[];

  @override
  int get length => _indices.length;

  @override
  bool get isEmpty => _indices.isEmpty;

  @override
  bool get isNotEmpty => _indices.isNotEmpty;

  @override
  void clear() {
    _indices.clear();
    _entries.clear();
  }

  @override
  void forEach(void Function(K key, V value) action) {
    for (final entry in _entries) {
      action(entry.key, entry.value);
    }
  }

  @override
  V putIfAbsent(K key, V Function() ifAbsent) {
    final index = _indices[key];
    if (index == null) {
      final value = ifAbsent();
      _indices[key] = _entries.length;
      _entries.add(PresentMapEntry._(key, _entries.length, value));
      return value;
    }
    return _entries[index].value;
  }

  @override
  IndexedMapEntry<K, V> entryOf(K key) {
    final index = _indices[key];
    if (index == null) {
      return AbsentMapEntry._(this, key);
    }
    return _entries[index];
  }

  @override
  PresentMapEntry<K, V> entryAt(int index) {
    return _entries[index];
  }

  @override
  bool containsKey(Object? key) => _indices.containsKey(key);

  @override
  Iterable<K> get keys => _entries.map((e) => e.key);

  @override
  Iterable<V> get values => _entries.map((e) => e.value);

  @override
  Iterable<MapEntry<K, V>> get entries {
    return _entries.map((e) => MapEntry(e.key, e.value));
  }

  @override
  V? remove(Object? key) {
    final index = _indices[key];
    if (index == null) {
      return null;
    }

    final result = _removeSwap(_entries, index).value;

    // Remove the last index from the map.
    _indices.remove(key);

    // Remap the moved entry.
    if (index < _entries.length) {
      _indices[_entries[index].key] = index;
    }

    return result;
  }

  @override
  void operator []=(K key, V value) {
    var index = _indices[key];
    if (index == null) {
      index = _indices[key] = _entries.length;
      _entries.add(PresentMapEntry._(key, index, value));
    } else {
      _entries[index].setOrUpdate(value);
    }
  }

  @override
  V? operator [](Object? key) {
    final index = _indices[key];
    return index == null ? null : _entries[index].value;
  }

  @override
  bool containsValue(Object? value) {
    for (final entry in _entries) {
      if (entry.value == value) {
        return true;
      }
    }
    return false;
  }

  @override
  V update(K key, V Function(V value) update, {V Function()? ifAbsent}) {
    switch (entryOf(key)) {
      case final PresentMapEntry<K, V> present:
        present.setOrUpdate(update(present.value));
        return present.value;
      case final AbsentMapEntry<K, V> absent:
        if (ifAbsent == null) {
          throw StateError('Key not found: $key');
        }
        return absent.putIfAbsent(ifAbsent);
    }
  }

  @override
  void updateAll(V Function(K key, V value) update) {
    for (final entry in _entries) {
      entry.setOrUpdate(update(entry.key, entry.value));
    }
  }
}
