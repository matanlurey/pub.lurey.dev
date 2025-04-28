part of '../../collection.dart';

/// An internal mixin that delegates all read operations to [_delegate].
///
/// Used as an implementation detail for other classes in this library.
base mixin _DelegatingListReadMixin<E> {
  /// All operations are delegated to this list.
  List<E> get _delegate;

  E operator [](int index) {
    return _delegate[index];
  }

  Iterable<E> get reversed {
    return _delegate.reversed;
  }

  int indexOf(E element, [int start = 0]) {
    return _delegate.indexOf(element, start);
  }

  int indexWhere(bool Function(E element) test, [int start = 0]) {
    return _delegate.indexWhere(test, start);
  }

  int lastIndexOf(E element, [int? start]) {
    return _delegate.lastIndexOf(element, start);
  }

  int lastIndexWhere(bool Function(E element) test, [int? start]) {
    return _delegate.lastIndexWhere(test, start);
  }

  List<E> operator +(List<E> other) {
    return _delegate + other;
  }

  List<E> sublist(int start, [int? end]) {
    return _delegate.sublist(start, end);
  }

  Iterable<E> getRange(int start, int end) {
    return _delegate.getRange(start, end);
  }

  Map<int, E> asMap() {
    return _delegate.asMap();
  }

  List<E> asList() {
    return _delegate.asUnmodifiable();
  }

  @override
  String toString() {
    return ListBase.listToString(_delegate);
  }
}

/// An internal mixin that delegates all write operations to [_delegate].
///
/// Used as an implementation detail for other classes in this library.
base mixin _DelegatingListWriteMixin<E> implements List<E> {
  /// All operations are delegated to this list.
  List<E> get _delegate;

  @override
  void operator []=(int index, E value) {
    _delegate[index] = value;
  }

  @override
  set first(E value) {
    _delegate.first = value;
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
  void add(E value) {
    _delegate.add(value);
  }

  @override
  void addAll(Iterable<E> iterable) {
    _delegate.addAll(iterable);
  }

  @override
  void sort([int Function(E a, E b)? compare]) {
    _delegate.sort(compare);
  }

  @override
  void shuffle([Random? random]) {
    _delegate.shuffle(random);
  }

  @override
  void clear() {
    _delegate.clear();
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
  void setAll(int index, Iterable<E> iterable) {
    _delegate.setAll(index, iterable);
  }

  @override
  bool remove(Object? element) {
    return _delegate.remove(element);
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
  void removeWhere(bool Function(E element) test) {
    _delegate.removeWhere(test);
  }

  @override
  void retainWhere(bool Function(E element) test) {
    _delegate.retainWhere(test);
  }

  @override
  void setRange(int start, int end, Iterable<E> iterable, [int skipCount = 0]) {
    _delegate.setRange(start, end, iterable, skipCount);
  }

  @override
  void removeRange(int start, int end) {
    _delegate.removeRange(start, end);
  }

  @override
  void fillRange(int start, int end, [E? fillValue]) {
    _delegate.fillRange(start, end, fillValue);
  }

  @override
  void replaceRange(int start, int end, Iterable<E> replacement) {
    _delegate.replaceRange(start, end, replacement);
  }
}
