part of '../../collection.dart';

/// A list that, upon modifiction, creates a copy of the underlying list.
abstract final class CopyOnWriteList<E> implements List<E> {
  /// Creates a list that copies the underlying list on modification.
  factory CopyOnWriteList(List<E> delegate) = _CopyOnWriteList<E>;
}

final class _CopyOnWriteList<E>
    with
        _DelegatingIterableMixin<E>, //
        _DelegatingListReadMixin<E>
    implements CopyOnWriteList<E> {
  _CopyOnWriteList(this._delegate);

  @override
  List<E> _delegate;

  var _isOriginal = true;
  void _copyIfOriginal() {
    if (_isOriginal) {
      _isOriginal = false;
      _delegate = [..._delegate];
    }
  }

  @override
  void operator []=(int index, E value) {
    _copyIfOriginal();
    _delegate[index] = value;
  }

  @override
  set first(E value) {
    _copyIfOriginal();
    _delegate.first = value;
  }

  @override
  set last(E value) {
    _copyIfOriginal();
    _delegate.last = value;
  }

  @override
  set length(int newLength) {
    _copyIfOriginal();
    _delegate.length = newLength;
  }

  @override
  void add(E value) {
    _copyIfOriginal();
    _delegate.add(value);
  }

  @override
  void addAll(Iterable<E> iterable) {
    _copyIfOriginal();
    _delegate.addAll(iterable);
  }

  @override
  void sort([int Function(E a, E b)? compare]) {
    _copyIfOriginal();
    _delegate.sort(compare);
  }

  @override
  void shuffle([Random? random]) {
    _copyIfOriginal();
    _delegate.shuffle(random);
  }

  @override
  void clear() {
    _copyIfOriginal();
    _delegate.clear();
  }

  @override
  void insert(int index, E element) {
    _copyIfOriginal();
    _delegate.insert(index, element);
  }

  @override
  void insertAll(int index, Iterable<E> iterable) {
    _copyIfOriginal();
    _delegate.insertAll(index, iterable);
  }

  @override
  void setAll(int index, Iterable<E> iterable) {
    _copyIfOriginal();
    _delegate.setAll(index, iterable);
  }

  @override
  bool remove(Object? element) {
    _copyIfOriginal();
    return _delegate.remove(element);
  }

  @override
  E removeAt(int index) {
    _copyIfOriginal();
    return _delegate.removeAt(index);
  }

  @override
  E removeLast() {
    _copyIfOriginal();
    return _delegate.removeLast();
  }

  @override
  void removeWhere(bool Function(E element) test) {
    _copyIfOriginal();
    _delegate.removeWhere(test);
  }

  @override
  void retainWhere(bool Function(E element) test) {
    _copyIfOriginal();
    _delegate.retainWhere(test);
  }

  @override
  void setRange(int start, int end, Iterable<E> iterable, [int skipCount = 0]) {
    _copyIfOriginal();
    _delegate.setRange(start, end, iterable, skipCount);
  }

  @override
  void removeRange(int start, int end) {
    _copyIfOriginal();
    _delegate.removeRange(start, end);
  }

  @override
  void fillRange(int start, int end, [E? fillValue]) {
    _copyIfOriginal();
    _delegate.fillRange(start, end, fillValue);
  }

  @override
  void replaceRange(int start, int end, Iterable<E> replacement) {
    _copyIfOriginal();
    _delegate.replaceRange(start, end, replacement);
  }
}
