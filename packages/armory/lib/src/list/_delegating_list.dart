part of '../iterable.dart';

/// A [List] that forwards all operations to a base list.
base class DelegatingList<E>
    with _DelegatingIterable<E>, _ReadOnlyList<E>, _DelegatingList<E>
    implements List<E> {
  /// Creates a wrapper that forwards all operations to the given list.
  const DelegatingList(this._delegate);

  @override
  final List<E> _delegate;
}

base mixin _DelegatingList<E> implements List<E> {
  List<E> get _delegate;

  @override
  List<R> cast<R>() {
    return _delegate.cast();
  }

  @override
  List<E> operator +(List<E> other) {
    return _delegate + other;
  }

  @override
  void operator []=(int index, E value) {
    _delegate[index] = value;
  }

  @override
  void add(E value) {
    _delegate.add(value);
  }

  @override
  void addAll(Iterable<E> iterable) {
    _delegate.addAll(iterable);
  }

  @override
  void clear() {
    _delegate.clear();
  }

  @override
  void fillRange(int start, int end, [E? fillValue]) {
    _delegate.fillRange(start, end, fillValue);
  }

  @override
  set first(E value) {
    _delegate.first = value;
  }

  @override
  void insert(int index, E element) {
    _delegate.insert(index, element);
  }

  @override
  void insertAll(int index, Iterable<E> iterable) {
    _delegate.insertAll(index, iterable);
  }

  @override
  set last(E value) {
    _delegate.last = value;
  }

  @override
  set length(int newLength) {
    _delegate.length = newLength;
  }

  @override
  bool remove(Object? value) {
    return _delegate.remove(value);
  }

  @override
  E removeAt(int index) {
    return _delegate.removeAt(index);
  }

  @override
  E removeLast() {
    return _delegate.removeLast();
  }

  @override
  void removeRange(int start, int end) {
    _delegate.removeRange(start, end);
  }

  @override
  void removeWhere(bool Function(E element) test) {
    _delegate.removeWhere(test);
  }

  @override
  void replaceRange(int start, int end, Iterable<E> replacements) {
    _delegate.replaceRange(start, end, replacements);
  }

  @override
  void retainWhere(bool Function(E element) test) {
    _delegate.retainWhere(test);
  }

  @override
  void setAll(int index, Iterable<E> iterable) {
    _delegate.setAll(index, iterable);
  }

  @override
  void setRange(int start, int end, Iterable<E> iterable, [int skipCount = 0]) {
    _delegate.setRange(start, end, iterable, skipCount);
  }

  @override
  void shuffle([Random? random]) {
    _delegate.shuffle(random);
  }

  @override
  void sort([int Function(E a, E b)? compare]) {
    _delegate.sort(compare);
  }
}
