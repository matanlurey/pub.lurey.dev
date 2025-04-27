part of '../../collection.dart';

/// An internal mixin that delegates all operations to [_delegate].
///
/// Used as an implementation detail for other classes in this library.
base mixin _DelegatingIterableMixin<E> implements Iterable<E> {
  /// All operations are delegated to this iterable.
  Iterable<E> get _delegate;

  @override
  Iterator<E> get iterator {
    return _delegate.iterator;
  }

  @override
  Iterable<R> cast<R>() {
    return _delegate.cast();
  }

  @override
  Iterable<E> followedBy(Iterable<E> other) {
    return _delegate.followedBy(other);
  }

  @override
  Iterable<T> map<T>(T Function(E e) f) {
    return _delegate.map(f);
  }

  @override
  Iterable<E> where(bool Function(E element) test) {
    return _delegate.where(test);
  }

  @override
  Iterable<T> whereType<T>() {
    return _delegate.whereType();
  }

  @override
  Iterable<T> expand<T>(Iterable<T> Function(E element) f) {
    return _delegate.expand(f);
  }

  @override
  bool contains(Object? element) {
    return _delegate.contains(element);
  }

  @override
  void forEach(void Function(E element) f) {
    _delegate.forEach(f);
  }

  @override
  E reduce(E Function(E previousValue, E element) combine) {
    return _delegate.reduce(combine);
  }

  @override
  T fold<T>(T initialValue, T Function(T previousValue, E element) combine) {
    return _delegate.fold(initialValue, combine);
  }

  @override
  bool every(bool Function(E element) test) {
    return _delegate.every(test);
  }

  @override
  String join([String separator = '']) {
    return _delegate.join(separator);
  }

  @override
  bool any(bool Function(E element) test) {
    return _delegate.any(test);
  }

  @override
  List<E> toList({bool growable = true}) {
    return _delegate.toList(growable: growable);
  }

  @override
  Set<E> toSet() {
    return _delegate.toSet();
  }

  @override
  int get length {
    return _delegate.length;
  }

  @override
  bool get isEmpty {
    return _delegate.isEmpty;
  }

  @override
  bool get isNotEmpty {
    return _delegate.isNotEmpty;
  }

  @override
  Iterable<E> take(int n) {
    return _delegate.take(n);
  }

  @override
  Iterable<E> takeWhile(bool Function(E value) test) {
    return _delegate.takeWhile(test);
  }

  @override
  Iterable<E> skip(int n) {
    return _delegate.skip(n);
  }

  @override
  Iterable<E> skipWhile(bool Function(E value) test) {
    return _delegate.skipWhile(test);
  }

  @override
  E get first {
    return _delegate.first;
  }

  @override
  E get last {
    return _delegate.last;
  }

  @override
  E get single {
    return _delegate.single;
  }

  @override
  E firstWhere(bool Function(E element) test, {E Function()? orElse}) {
    return _delegate.firstWhere(test, orElse: orElse);
  }

  @override
  E lastWhere(bool Function(E element) test, {E Function()? orElse}) {
    return _delegate.lastWhere(test, orElse: orElse);
  }

  @override
  E singleWhere(bool Function(E element) test, {E Function()? orElse}) {
    return _delegate.singleWhere(test, orElse: orElse);
  }

  @override
  E elementAt(int index) {
    return _delegate.elementAt(index);
  }

  @override
  String toString() {
    return IterableBase.iterableToShortString(_delegate);
  }
}
