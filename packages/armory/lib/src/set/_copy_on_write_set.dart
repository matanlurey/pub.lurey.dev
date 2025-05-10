part of '../iterable.dart';

/// A copy-on-write set, or a view of an existing set.
///
/// If the set is not modified, no copy of the set is made.
abstract final class CopyOnWriteSet<E> implements Set<E> {
  /// Creates a copy-on-write view of an existing [set].
  factory CopyOnWriteSet(Set<E> set) = _CopyOnWriteSet<E>;

  @override
  CopyOnWriteSet<R> cast<R>();
}

final class _CopyOnWriteSet<E>
    with _DelegatingIterable<E>, _ReadOnlySet<E>
    implements CopyOnWriteSet<E> {
  _CopyOnWriteSet(this._delegate);

  @override
  Set<E> _delegate;
  var _wasChanged = false;

  void _copyIfPristine() {
    if (_wasChanged) {
      return;
    }
    _delegate = _delegate.toSet();
    _wasChanged = true;
  }

  @override
  CopyOnWriteSet<R> cast<R>() {
    return _CopyOnWriteSet(_delegate.cast());
  }

  @override
  bool add(E value) {
    _copyIfPristine();
    return _delegate.add(value);
  }

  @override
  void addAll(Iterable<E> elements) {
    _copyIfPristine();
    _delegate.addAll(elements);
  }

  @override
  void clear() {
    _copyIfPristine();
    _delegate.clear();
  }

  @override
  bool remove(Object? value) {
    _copyIfPristine();
    return _delegate.remove(value);
  }

  @override
  void removeAll(Iterable<Object?> elements) {
    _copyIfPristine();
    _delegate.removeAll(elements);
  }

  @override
  void removeWhere(bool Function(E element) test) {
    _copyIfPristine();
    _delegate.removeWhere(test);
  }

  @override
  void retainAll(Iterable<Object?> elements) {
    _copyIfPristine();
    _delegate.retainAll(elements);
  }

  @override
  void retainWhere(bool Function(E element) test) {
    _copyIfPristine();
    _delegate.retainWhere(test);
  }
}
