part of '../collection.dart';

/// A hash set where element iteration order is independent of their hash codes.
///
/// ## Iteration Order
///
/// The keys, [E], have a consistent order that is determined by the sequence
/// of [add] and [remove] calls (or similar operations):
///
/// ```dart
/// final set = IndexSet<int>();
/// set.add(1);
/// set.add(2);
/// set.add(3);
/// set.remove(2);
/// print(set); // {1, 3}
/// ```
///
/// Unlike [LinkedHashSet], [remove] calls (and similar operations) shift
/// the iteration order; a removed element is swapped with the last element
/// in the set, and then removed:
///
/// ```dart
/// final set = IndexSet<int>();
/// set.add(1);
/// set.add(2);
/// set.add(3);
/// set.remove(1);
/// print(set); // {3, 2}
/// ```
///
/// ## Index Access
///
/// [IndexSet] provides an additional set of operators, [operator[]] and
/// [operator[]=], to access elements by their order in the iteration sequence;
/// the index is zero-based and must be within bounds (`0 <= index < length`):
///
/// ```dart
/// final set = IndexSet<int>();
/// set.add(1);
/// set.add(2);
/// print(set[0]); // 1
/// print(set[1]); // 2
/// ```
///
/// ## Performance
///
/// If you want the properties of [IndexSet], or its strongest performance
/// characteristics fit your workload, it might be the fastest pure Dart [Set]
/// implementation available; for example `package:sector` uses it internally
/// for its graph search algorithms.
///
/// [IndexSet] derives some performance facts from how it is constructed:
///
/// 1. Iteration is as fast as a [List] (~2-3x faster than `dart:collection`).
/// 2. Removals are nearly as fast as [HashSet] (~300-400x faster).
/// 3. Creation is ~2x slower than [HashSet], 5x faster than [LinkedHashSet].
///
/// > [!TIP]
/// > Profile your workload to be sure.
///
/// {@category Collections}
abstract final class IndexSet<E> implements Set<E> {
  /// Creates an insertion-ordered indexing based [Set].
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
  /// necessarily an instance of [E], like the arguments of `[]`, [remove], and
  /// [contains], which are typed as `Object?`. If [isValidKey] returns `false`
  /// for an object, the [equals] and [hashCode] functions are not called, and
  /// no key equal to that object is assumed to be in the set.
  ///
  /// The [isValidKey] function defaults `is E` if omitted.
  @pragma('vm:prefer-inline')
  factory IndexSet({
    bool Function(E e1, E e2)? equals,
    int Function(E e)? hashCode,
    bool Function(Object? potentialKey)? isValidKey,
  }) {
    if (isValidKey == null) {
      if (hashCode == null) {
        if (equals == null) {
          return _IndexSet();
        }
        hashCode = _defaultHashCode;
      } else {
        if (identical(identityHashCode, hashCode) &&
            identical(identical, equals)) {
          return IndexSet.identity();
        }
        equals ??= _defaultEquals;
      }
    } else {
      equals ??= _defaultEquals;
      hashCode ??= _defaultHashCode;
    }
    return _CustomIndexSet(
      equals: equals,
      hashCode: hashCode,
      isValidKey: isValidKey,
    );
  }

  /// Creates an [IndexSet] from [elements].
  factory IndexSet.from(Iterable<E> elements) {
    final set = IndexSet<E>();
    set.addAll(elements);
    return set;
  }

  /// Creates an [IndexSet] that uses [identical] and [identityHashCode].
  ///
  /// Equivalent to:
  /// ```dart
  /// IndexSet(equals: identical, hashCode: identityHashCode)
  /// ```
  factory IndexSet.identity() = _IdentityIndexSet<E>;

  /// The key at the given [index] in the iteration order.
  ///
  /// The [index] must be a valid index of this set, which means that `index`
  /// must be non-negative and less than [length].
  E operator [](int index);

  /// Sets the element at the given [index] in the set to [value].
  ///
  /// The [index] must be a valid index of this set, which means that `index`
  /// must be non-negative and less than [length].
  void operator []=(int index, E value);
}

final class _IndexSet<E> with SetBase<E> implements IndexSet<E> {
  _IndexSet([
    HashMap<E, int>? indices,
  ]) : _indices = indices ?? HashMap();
  final HashMap<E, int> _indices;
  final _entries = <E>[];

  @override
  @nonVirtual
  bool remove(Object? key) {
    final index = _indices[key];
    if (index == null) {
      return false;
    }

    final result = _removeSwap(_entries, index);

    // Remove the last index from the map.
    _indices.remove(result);

    // Remap the moved entry.
    if (index < _entries.length) {
      _indices[_entries[index]] = index;
    }

    return true;
  }

  @override
  bool add(E value) {
    // If the key exists, return false.
    if (_indices.containsKey(value)) {
      return false;
    }

    // Add the key to the indices and the entries.
    _indices[value] = length;
    _entries.add(value);
    return true;
  }

  @override
  bool contains(Object? key) => _indices.containsKey(key);

  @override
  E operator [](int index) => _entries[index];

  @override
  void operator []=(int index, E value) => _entries[index] = value;

  @override
  void clear() {
    _indices.clear();
    _entries.clear();
  }

  @override
  E? lookup(Object? object) {
    final index = _indices[object];
    return index == null ? null : _entries[index];
  }

  @override
  Set<E> toSet() => _IndexSet<E>()..addAll(this);

  @override
  int get length => _entries.length;

  @override
  bool get isEmpty => _entries.isEmpty;

  @override
  bool get isNotEmpty => _entries.isNotEmpty;

  @override
  Iterator<E> get iterator => _entries.iterator;

  @override
  Iterable<E> followedBy(Iterable<E> other) => _entries.followedBy(other);

  @override
  Iterable<T> map<T>(T Function(E e) f) => _entries.map(f);

  @override
  Iterable<E> where(bool Function(E element) test) => _entries.where(test);

  @override
  Iterable<T> whereType<T>() => _entries.whereType<T>();

  @override
  Iterable<T> expand<T>(Iterable<T> Function(E element) f) {
    return _entries.expand(f);
  }

  @override
  void forEach(void Function(E element) f) => _entries.forEach(f);

  @override
  E reduce(E Function(E value, E element) combine) => _entries.reduce(combine);

  @override
  T fold<T>(T initialValue, T Function(T previousValue, E element) combine) {
    return _entries.fold(initialValue, combine);
  }

  @override
  bool every(bool Function(E element) test) => _entries.every(test);

  @override
  String join([String separator = '']) => _entries.join(separator);

  @override
  bool any(bool Function(E element) test) => _entries.any(test);

  @override
  List<E> toList({bool growable = true}) => _entries.toList(growable: growable);

  @override
  Iterable<E> take(int count) => _entries.take(count);

  @override
  Iterable<E> takeWhile(bool Function(E value) test) {
    return _entries.takeWhile(test);
  }

  @override
  Iterable<E> skip(int count) => _entries.skip(count);

  @override
  Iterable<E> skipWhile(bool Function(E value) test) {
    return _entries.skipWhile(test);
  }

  @override
  E get first => _entries.first;

  @override
  E get last => _entries.last;

  @override
  E get single => _entries.single;

  @override
  E firstWhere(bool Function(E element) test, {E Function()? orElse}) {
    return _entries.firstWhere(test, orElse: orElse);
  }

  @override
  E lastWhere(bool Function(E element) test, {E Function()? orElse}) {
    return _entries.lastWhere(test, orElse: orElse);
  }

  @override
  E singleWhere(bool Function(E element) test, {E Function()? orElse}) {
    return _entries.singleWhere(test, orElse: orElse);
  }

  @override
  E elementAt(int index) => _entries.elementAt(index);
}

final class _IdentityIndexSet<E> extends _IndexSet<E> {
  _IdentityIndexSet() : super(HashMap.identity());

  @override
  Set<E> toSet() => _IdentityIndexSet<E>()..addAll(this);
}

final class _CustomIndexSet<E> extends _IndexSet<E> {
  _CustomIndexSet({
    required bool Function(E e1, E e2) equals,
    required int Function(E e) hashCode,
    bool Function(Object? potentialKey)? isValidKey,
  })  : _equals = equals,
        _hashCode = hashCode,
        _isValidKey = isValidKey,
        super(
          HashMap(
            equals: equals,
            hashCode: hashCode,
            isValidKey: isValidKey,
          ),
        );

  final bool Function(E e1, E e2) _equals;
  final int Function(E e) _hashCode;
  final bool Function(Object? potentialKey)? _isValidKey;

  @override
  Set<E> toSet() {
    return _CustomIndexSet<E>(
      equals: _equals,
      hashCode: _hashCode,
      isValidKey: _isValidKey,
    )..addAll(this);
  }
}
