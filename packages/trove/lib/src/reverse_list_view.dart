@internal
library;

import 'dart:collection';

import 'package:meta/meta.dart';

/// A view of a list in reverse order.
///
/// The items in the list are not copied, but rather a view is created where
/// the first item in the list is the last item in the view and the last item
/// in the list is the first item in the view, and so on.
final class ReverseListView<T> with ListBase<T> {
  /// Creates a view of the provided list in reverse order.
  const ReverseListView(this._delegate);
  final List<T> _delegate;

  @override
  Iterator<T> get iterator => _delegate.reversed.iterator;

  @override
  T operator [](int index) {
    return _delegate[_delegate.length - index - 1];
  }

  @override
  void operator []=(int index, T value) {
    _delegate[_delegate.length - index - 1] = value;
  }

  @override
  int get length => _delegate.length;

  @override
  set length(int newLength) {
    _delegate.length = newLength;
  }

  @override
  String toString() {
    return IterableBase.iterableToFullString(_delegate.reversed, '[', ']');
  }
}
