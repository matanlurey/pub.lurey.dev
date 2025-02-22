part of '../collection.dart';

/// Returns a [StateError] with the message 'No elements'.
Error _noElements() => StateError('No elements');

/// Returns a [StateError] with the message 'More than one element'.
Error _moreThanOneElement() => StateError('More than one element');

/// An [Iterable] for classes that have an efficient fixed [length] property.
///
/// All methods are implemented in terms of [length] and [elementAt].
///
/// {@category Collections}
abstract base class FixedLengthIterable<E> extends Iterable<E> {
  /// Creates a new fixed length iterable.
  const FixedLengthIterable();

  /// Returns the number of elements in the iterable.
  @override
  @mustBeOverridden
  int get length;

  @override
  @mustBeOverridden
  E elementAt(int index);

  @override
  Iterator<E> get iterator => _EfficientFixedLengthIterator(this);

  @override
  void forEach(void Function(E element) action) {
    for (var i = 0; i < length; i++) {
      action(elementAt(i));
    }
  }

  @override
  bool get isEmpty => length == 0;

  @override
  bool get isNotEmpty => !isEmpty;

  @override
  E get first {
    if (isEmpty) {
      throw _noElements();
    }
    return elementAt(0);
  }

  @override
  E get last {
    if (isEmpty) {
      throw _noElements();
    }
    return elementAt(length - 1);
  }

  @override
  E get single {
    if (isEmpty) {
      throw _noElements();
    }
    if (length > 1) {
      throw _moreThanOneElement();
    }
    return elementAt(0);
  }

  @override
  bool every(bool Function(E element) test) {
    for (var i = 0; i < length; i++) {
      if (!test(elementAt(i))) {
        return false;
      }
    }
    return true;
  }

  @override
  bool any(bool Function(E element) test) {
    for (var i = 0; i < length; i++) {
      if (test(elementAt(i))) {
        return true;
      }
    }
    return false;
  }

  @override
  E firstWhere(bool Function(E element) test, {E Function()? orElse}) {
    for (var i = 0; i < length; i++) {
      final element = elementAt(i);
      if (test(element)) {
        return element;
      }
    }
    if (orElse != null) {
      return orElse();
    }
    throw _noElements();
  }

  @override
  E lastWhere(bool Function(E element) test, {E Function()? orElse}) {
    for (var i = length - 1; i >= 0; i--) {
      final element = elementAt(i);
      if (test(element)) {
        return element;
      }
    }
    if (orElse != null) {
      return orElse();
    }
    throw _noElements();
  }

  @override
  E singleWhere(bool Function(E element) test, {E Function()? orElse}) {
    late E result;
    var match = false;
    for (var i = 0; i < length; i++) {
      final element = elementAt(i);
      if (test(element)) {
        if (match) {
          throw _moreThanOneElement();
        }
        result = element;
        match = true;
      }
    }
    if (!match) {
      if (orElse != null) {
        return orElse();
      }
      throw _noElements();
    }
    return result;
  }

  @override
  String join([String separator = '']) {
    if (isEmpty) {
      return '';
    }
    final buffer = StringBuffer();
    buffer.write(elementAt(0));
    for (var i = 1; i < length; i++) {
      buffer.write(separator);
      buffer.write(elementAt(i));
    }
    return buffer.toString();
  }

  @override
  E reduce(E Function(E value, E element) combine) {
    if (isEmpty) {
      throw _noElements();
    }
    var value = elementAt(0);
    for (var i = 1; i < length; i++) {
      value = combine(value, elementAt(i));
    }
    return value;
  }

  @override
  T fold<T>(T initialValue, T Function(T previousValue, E element) combine) {
    var value = initialValue;
    for (var i = 0; i < length; i++) {
      value = combine(value, elementAt(i));
    }
    return value;
  }

  @override
  Iterable<E> skip(int count) {
    if (count >= length) {
      return const Iterable.empty();
    }
    return _SubRangeIterable(this, count);
  }

  @override
  Iterable<E> take(int count) {
    if (count >= length) {
      return this;
    }
    return _SubRangeIterable(this, 0, count);
  }

  @override
  List<E> toList({bool growable = true}) {
    if (isEmpty) {
      return List<E>.empty(growable: growable);
    }
    final list = List<E>.filled(length, elementAt(0), growable: growable);
    for (var i = 1; i < length; i++) {
      list[i] = elementAt(i);
    }
    return list;
  }
}

final class _SubRangeIterable<E> extends FixedLengthIterable<E> {
  _SubRangeIterable(this._iterable, this._start, [int? count])
    : _endOrLength = count == null ? null : _start + count {
    RangeError.checkNotNegative(_start, 'start');
    if (count != null) {
      RangeError.checkValueInInterval(count, _start, _iterable.length, 'count');
    }
  }

  final FixedLengthIterable<E> _iterable;
  final int _start;
  final int? _endOrLength;

  @override
  int get length => (_endOrLength ?? _iterable.length) - _start;

  @override
  E elementAt(int index) {
    RangeError.checkValidIndex(index, this);
    return _iterable.elementAt(_start + index);
  }

  @override
  Iterable<E> skip(int count) {
    final newStart = _start + count;
    if (newStart >= _iterable.length) {
      return const Iterable.empty();
    }
    return _SubRangeIterable(_iterable, newStart, _endOrLength);
  }

  @override
  Iterable<E> take(int count) {
    final oldLength = _endOrLength ?? _iterable.length;
    final newLength = math.min(count, oldLength); // coverage:ignore-line
    return _SubRangeIterable(_iterable, _start, newLength);
  }
}

final class _EfficientFixedLengthIterator<E> implements Iterator<E> {
  _EfficientFixedLengthIterator(this._iterable);

  final FixedLengthIterable<E> _iterable;
  var _index = -1;

  @override
  E get current => _iterable.elementAt(_index);

  @override
  @pragma('vm:prefer-inline')
  bool moveNext() => ++_index < _iterable.length;
}
