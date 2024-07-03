import 'dart:collection';

import 'package:meta/meta.dart';

/// A list that can have gaps between elements.
///
/// This list is optimized for sparse data, where most elements are empty.
///
/// > [!Note]
/// > This class is not intended to be used directly, and is not a real [List].
@internal
final class SparseList<T> {
  /// Creates a new sparse list with the provided [length] and [fill] value.
  ///
  /// The [length] must be non-negative.
  ///
  /// The [equals] function is used to compare elements for equality. If not
  /// provided, the default equality operator is used.
  factory SparseList.filled(
    int length, {
    required T fill,
    bool Function(T, T)? equals,
  }) {
    RangeError.checkNotNegative(length, 'length');
    return SparseList._(SplayTreeMap(), fill, length, equals ?? _defaultEquals);
  }

  /// Creates a new sparse list from the provided [elements].
  ///
  /// The [elements] must be an iterable of elements, where the position of the
  /// element in the iterable is the index in the list. The [fill] value is used
  /// to represent empty elements in the list.
  ///
  /// The [equals] function is used to compare elements for equality. If not
  /// provided, the default equality operator is used.
  factory SparseList.from(
    Iterable<T> elements, {
    required T fill,
    bool Function(T, T)? equals,
  }) {
    final cells = SplayTreeMap<int, T>();
    final isEqual = equals ?? _defaultEquals;
    for (var index = 0; index < elements.length; index++) {
      final value = elements.elementAt(index);
      if (!isEqual(value, fill)) {
        cells[index] = value;
      }
    }
    return SparseList._(cells, fill, elements.length, isEqual);
  }

  /// Creates a new sparse list using the provided [elements] map.
  ///
  /// The [elements] map must be a map of elements, where the key is the index
  /// in the list. The [fill] value is used to represent empty elements in the
  /// list.
  ///
  /// The [length] must be non-negative, and must be greater than or equal to
  /// the maximum key in the [elements] map. If the [length] is greater than the
  /// maximum key, the fill value is used for all elements between the maximum
  /// key and the length.
  ///
  /// The [equals] function is used to compare elements for equality. If not
  /// provided, the default equality operator is used.
  factory SparseList.view(
    SplayTreeMap<int, T> elements, {
    required int length,
    required T fill,
    bool Function(T, T)? equals,
  }) {
    RangeError.checkNotNegative(length, 'length');
    if (elements.lastKey() case final int key when key >= length) {
      throw ArgumentError.value(
        length,
        'length',
        'Length must be greater than the maximum key in the elements map.',
      );
    }
    return SparseList._(elements, fill, length, equals ?? _defaultEquals);
  }

  SparseList._(this._elements, this.fill, this._length, this._equals);

  static bool _defaultEquals<T>(T a, T b) => a == b;
  final bool Function(T, T) _equals;

  final SplayTreeMap<int, T> _elements;

  /// The fill value for the list.
  ///
  /// This is the value that is used to represent empty elements in the list.
  final T fill;

  /// Length of the list.
  ///
  /// This is the number of elements in the list, not the number of non-empty
  /// elements. That is, the length is the maximum index that can be accessed,
  /// similar to a normal list.
  int get length => _length;
  int _length;

  /// The number of non-empty elements in the list.
  int get nonEmptyLength => _elements.length;

  /// Returns the element at the given [index].
  T operator [](int index) {
    RangeError.checkValidIndex(index, this);
    return _elements[index] ?? fill;
  }

  /// Sets the element at the given [index] to the provided [value].
  ///
  /// If the [value] is equal to the fill value, no memory is allocated.
  void operator []=(int index, T value) {
    RangeError.checkValidIndex(index, this);
    if (_equals(value, fill)) {
      _elements.remove(index);
    } else {
      _elements[index] = value;
    }
  }

  /// Removes the range of elements from [start] to [end] (exclusive).
  ///
  /// This will shift all elements after [end] to the left by the number of
  /// elements removed, which is an `O(n)` operation where `n` is the number of
  /// elements after [end].
  void removeRange(int start, int end) {
    // Remove the range of elements from [start] to [end] (exclusive).
    RangeError.checkValidRange(start, end, length);
    for (var i = start; i < end; i++) {
      _elements.remove(i);
    }

    // Shift all elements after [end] to the left.
    // We only need to shift elements that are non-empty.
    final shift = end - start;
    final keys = _elements.keys.toList();
    for (final key in keys) {
      if (key >= end && _elements.containsKey(key)) {
        _elements[key - shift] = _elements.remove(key) as T;
      }
    }

    _length -= shift;
  }

  /// Inserts [values] into the list at the given [index].
  ///
  /// This will shift all elements after [index] to the right by the number of
  /// elements inserted, which is an `O(n)` operation where `n` is the number of
  /// elements after [index].
  void insertAll(int index, Iterable<T> values) {
    RangeError.checkValueInInterval(index, 0, length, 'index');
    final valuesList = List.of(values);

    // Make room for the new elements.
    // Shift all elements >= index to the right.
    for (var i = length - 1; i >= index; i--) {
      if (_elements.containsKey(i)) {
        _elements[i + valuesList.length] = _elements.remove(i) as T;
      }
    }

    // Insert the new elements.
    for (var i = 0; i < valuesList.length; i++) {
      final value = valuesList[i];
      if (!_equals(value, fill)) {
        _elements[index + i] = value;
      }
    }

    _length += valuesList.length;
  }

  /// Returns `true` if the list contains the provided [element].
  bool contains(T element) {
    if (element == fill) {
      return nonEmptyLength < length;
    }
    return _elements.containsValue(element);
  }

  /// Returns a list of all elements as a dense (non-sparse) list.
  ///
  /// The returned list will have the same length as the sparse list, and the
  /// fill value will be used for any empty elements.
  List<T> toDenseList() {
    final list = List<T>.filled(length, fill);
    for (final entry in _elements.entries) {
      list[entry.key] = entry.value;
    }
    return list;
  }

  /// Returns a map of all elements as a sparse map.
  ///
  /// The returned map will have the same length as the sparse list, with the
  /// fill value omitted.
  Map<int, T> toSparseMap() => Map<int, T>.from(_elements);
}
