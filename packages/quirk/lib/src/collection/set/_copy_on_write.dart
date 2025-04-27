part of '../../collection.dart';

/// A set that, upon modification, creates a copy of the underlying set.
abstract final class CopyOnWriteSet<E> implements Set<E> {
  /// Creates a set that copies the underlying set on modification.
  factory CopyOnWriteSet(Set<E> delegate) = _CopyOnWriteSet<E>;
}

final class _CopyOnWriteSet<E>
    with
        _DelegatingIterableMixin<E>, //
        _DelegatingSetReadMixin<E>
    implements CopyOnWriteSet<E> {
  _CopyOnWriteSet(this._delegate);

  @override
  Set<E> _delegate;

  var _isOriginal = true;
  void _copyIfOriginal() {
    if (_isOriginal) {
      _isOriginal = false;
      _delegate = {..._delegate};
    }
  }

  @override
  bool add(E value) {
    _copyIfOriginal();
    return _delegate.add(value);
  }

  @override
  void addAll(Iterable<E> elements) {
    _copyIfOriginal();
    _delegate.addAll(elements);
  }

  @override
  bool remove(Object? value) {
    _copyIfOriginal();
    return _delegate.remove(value);
  }

  @override
  void removeAll(Iterable<Object?> elements) {
    _copyIfOriginal();
    _delegate.removeAll(elements);
  }

  @override
  void retainAll(Iterable<Object?> elements) {
    _copyIfOriginal();
    _delegate.retainAll(elements);
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
  void clear() {
    _copyIfOriginal();
    _delegate.clear();
  }
}
