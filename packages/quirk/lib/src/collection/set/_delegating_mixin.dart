part of '../../collection.dart';

/// An internal mixin that delegates all read operations to [_delegate].
///
/// Used as an implementation detail for other classes in this library.
base mixin _DelegatingSetReadMixin<E> implements Set<E> {
  /// All operations are delegated to this set.
  Set<E> get _delegate;

  @override
  Set<R> cast<R>() {
    return _delegate.cast();
  }

  @override
  E? lookup(Object? object) {
    return _delegate.lookup(object);
  }

  @override
  bool containsAll(Iterable<Object?> other) {
    return _delegate.containsAll(other);
  }

  @override
  Set<E> intersection(Set<Object?> other) {
    return _delegate.intersection(other);
  }

  @override
  Set<E> union(Set<E> other) {
    return _delegate.union(other);
  }

  @override
  Set<E> difference(Set<Object?> other) {
    return _delegate.difference(other);
  }
}

/// An internal mixin that delegates all write operations to [_delegate].
///
/// Used as an implementation detail for other classes in this library.
base mixin _DelegatingSetWriteMixin<E> implements Set<E> {
  /// All operations are delegated to this set.
  Set<E> get _delegate;

  @override
  bool add(E value) {
    return _delegate.add(value);
  }

  @override
  void addAll(Iterable<E> elements) {
    _delegate.addAll(elements);
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
  void retainAll(Iterable<Object?> elements) {
    _delegate.retainAll(elements);
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
  void clear() {
    _delegate.clear();
  }
}
