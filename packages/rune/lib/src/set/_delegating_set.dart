part of '../iterable.dart';

/// A [Set] that forwards all operations to a base set.
base class DelegatingSet<E>
    with _DelegatingIterable<E>, _ReadOnlySet<E>, _DelegatingSet<E>
    implements Set<E> {
  /// Creates a wrapper that forwards all operations to the given set.
  const DelegatingSet(this._delegate);

  @override
  final Set<E> _delegate;
}

base mixin _DelegatingSet<E> implements Set<E> {
  Set<E> get _delegate;

  @override
  Set<R> cast<R>() {
    return _delegate.cast();
  }

  @override
  bool add(E value) {
    return _delegate.add(value);
  }

  @override
  void addAll(Iterable<E> elements) {
    _delegate.addAll(elements);
  }

  @override
  void clear() {
    _delegate.clear();
  }

  @override
  bool remove(Object? value) {
    return _delegate.remove(value);
  }

  @override
  void removeAll(Iterable<Object?> elements) {
    _delegate.removeAll(elements);
  }

  @override
  void removeWhere(bool Function(E element) test) {
    _delegate.removeWhere(test);
  }

  @override
  void retainAll(Iterable<Object?> elements) {
    _delegate.retainAll(elements);
  }

  @override
  void retainWhere(bool Function(E element) test) {
    _delegate.retainWhere(test);
  }
}
