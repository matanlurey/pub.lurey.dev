part of '../iterable.dart';

/// A read-only view of a set.
base class ReadOnlySetView<E>
    with
        _DelegatingIterable<E>, //
        _ReadOnlySet<E>
    implements ReadOnlySet<E> {
  /// Creates a wrapper that forwards all operations to the given set.
  const ReadOnlySetView(this._delegate);

  @override
  final Set<E> _delegate;

  @override
  ReadOnlySet<R> cast<R>() {
    return ReadOnlySetView(_delegate.cast());
  }
}

base mixin _ReadOnlySet<E> /* implements ReadOnlySet<E> */ {
  Set<E> get _delegate;

  bool contains(Object? element) {
    return _delegate.contains(element);
  }

  E? lookup(Object? object) {
    return _delegate.lookup(object);
  }

  bool containsAll(Iterable<Object?> other) {
    return _delegate.containsAll(other);
  }

  Set<E> intersection(Set<Object?> other) {
    return _delegate.intersection(other);
  }

  Set<E> union(Set<E> other) {
    return _delegate.union(other);
  }

  Set<E> difference(Set<Object?> other) {
    return _delegate.difference(other);
  }

  Set<E> asSet() {
    return UnmodifiableSetView(_delegate);
  }
}
