part of '../iterable.dart';

/// A read-only view of another list.
base class ReadOnlyListView<E>
    with
        _DelegatingIterable<E>, //
        _ReadOnlyListView<E>
    implements ReadOnlyList<E> {
  /// Creates a wrapper that forwards all operations to the given list.
  const ReadOnlyListView(this._delegate);

  @override
  final List<E> _delegate;

  @override
  ReadOnlyList<R> cast<R>() {
    return ReadOnlyListView(_delegate.cast());
  }
}

base mixin _ReadOnlyListView<E> {
  List<E> get _delegate;

  E operator [](int index) {
    return _delegate[index];
  }

  Map<int, E> asMap() {
    return _delegate.asMap();
  }

  Iterable<E> getRange(int start, int end) {
    return _delegate.getRange(start, end);
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

  Iterable<E> get reversed {
    return _delegate.reversed;
  }

  List<E> sublist(int start, [int? end]) {
    return _delegate.sublist(start, end);
  }

  List<E> toList({bool growable = true}) {
    return _delegate.toList(growable: growable);
  }

  @override
  String toString() {
    return _delegate.toString();
  }
}
