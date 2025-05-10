part of '../iterable.dart';

/// A copy-on-write list, or a view of an existing list.
///
/// If the list is not modified, no copy of the list is made.
abstract final class CopyOnWriteList<E> implements List<E> {
  /// Creates a copy-on-write view of an existing [list].
  factory CopyOnWriteList(List<E> list) = _CopyOnWriteList<E>;

  @override
  CopyOnWriteList<R> cast<R>();
}

final class _CopyOnWriteList<E>
    with _DelegatingIterable<E>, _ReadOnlyList<E>
    implements CopyOnWriteList<E> {
  _CopyOnWriteList(this._delegate);

  @override
  List<E> _delegate;
  var _wasChanged = false;

  void _copyIfPristine() {
    if (_wasChanged) {
      return;
    }
    _delegate = _delegate.toList();
    _wasChanged = true;
  }

  @override
  CopyOnWriteList<R> cast<R>() {
    return _CopyOnWriteList(_delegate.cast());
  }

  @override
  List<E> operator +(List<E> other) {
    return _delegate + other;
  }

  @override
  void operator []=(int index, E value) {
    _copyIfPristine();
    _delegate[index] = value;
  }

  @override
  void add(E value) {
    _copyIfPristine();
    _delegate.add(value);
  }

  @override
  void addAll(Iterable<E> iterable) {
    _copyIfPristine();
    _delegate.addAll(iterable);
  }

  @override
  void clear() {
    _copyIfPristine();
    _delegate.clear();
  }

  @override
  void fillRange(int start, int end, [E? fillValue]) {
    _copyIfPristine();
    _delegate.fillRange(start, end, fillValue);
  }

  @override
  set first(E value) {
    _copyIfPristine();
    _delegate.first = value;
  }

  @override
  void insert(int index, E element) {
    _copyIfPristine();
    _delegate.insert(index, element);
  }

  @override
  void insertAll(int index, Iterable<E> iterable) {
    _copyIfPristine();
    _delegate.insertAll(index, iterable);
  }

  @override
  set last(E value) {
    _copyIfPristine();
    _delegate.last = value;
  }

  @override
  set length(int newLength) {
    _copyIfPristine();
    _delegate.length = newLength;
  }

  @override
  bool remove(Object? value) {
    _copyIfPristine();
    return _delegate.remove(value);
  }

  @override
  E removeAt(int index) {
    _copyIfPristine();
    return _delegate.removeAt(index);
  }

  @override
  E removeLast() {
    _copyIfPristine();
    return _delegate.removeLast();
  }

  @override
  void removeRange(int start, int end) {
    _copyIfPristine();
    _delegate.removeRange(start, end);
  }

  @override
  void removeWhere(bool Function(E element) test) {
    _copyIfPristine();
    _delegate.removeWhere(test);
  }

  @override
  void replaceRange(int start, int end, Iterable<E> replacements) {
    _copyIfPristine();
    _delegate.replaceRange(start, end, replacements);
  }

  @override
  void retainWhere(bool Function(E element) test) {
    _copyIfPristine();
    _delegate.retainWhere(test);
  }

  @override
  void setAll(int index, Iterable<E> iterable) {
    _copyIfPristine();
    _delegate.setAll(index, iterable);
  }

  @override
  void setRange(int start, int end, Iterable<E> iterable, [int skipCount = 0]) {
    _copyIfPristine();
    _delegate.setRange(start, end, iterable, skipCount);
  }

  @override
  void shuffle([Random? random]) {
    _copyIfPristine();
    _delegate.shuffle(random);
  }

  @override
  void sort([int Function(E a, E b)? compare]) {
    _copyIfPristine();
    _delegate.sort(compare);
  }
}
