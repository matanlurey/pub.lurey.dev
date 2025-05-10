part of '../iterable.dart';

/// An [Iterable] that forwards all operations to a base iterable.
base class DelegatingIterable<E> with _DelegatingIterable<E> {
  /// Creates a wrapper that forwards all operations to the given iterable.
  const DelegatingIterable(this._delegate);

  @override
  final Iterable<E> _delegate;
}

base mixin _DelegatingIterable<E> implements Iterable<E> {
  Iterable<E> get _delegate;

  @override
  bool any(bool Function(E element) test) {
    return _delegate.any(test);
  }

  @override
  Iterable<R> cast<R>() {
    return _delegate.cast<R>();
  }

  @override
  bool contains(Object? element) {
    return _delegate.contains(element);
  }

  @override
  E elementAt(int index) {
    return _delegate.elementAt(index);
  }

  @override
  bool every(bool Function(E element) test) {
    return _delegate.every(test);
  }

  @override
  Iterable<T> expand<T>(Iterable<T> Function(E element) toElements) {
    return _delegate.expand(toElements);
  }

  @override
  E get first {
    return _delegate.first;
  }

  @override
  E firstWhere(bool Function(E element) test, {E Function()? orElse}) {
    return _delegate.firstWhere(test, orElse: orElse);
  }

  @override
  T fold<T>(T initialValue, T Function(T previousValue, E element) combine) {
    return _delegate.fold(initialValue, combine);
  }

  @override
  Iterable<E> followedBy(Iterable<E> other) {
    return _delegate.followedBy(other);
  }

  @override
  void forEach(void Function(E element) action) {
    _delegate.forEach(action);
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
  Iterator<E> get iterator {
    return _delegate.iterator;
  }

  @override
  String join([String separator = '']) {
    return _delegate.join(separator);
  }

  @override
  E get last {
    return _delegate.last;
  }

  @override
  E lastWhere(bool Function(E element) test, {E Function()? orElse}) {
    return _delegate.lastWhere(test, orElse: orElse);
  }

  @override
  int get length {
    return _delegate.length;
  }

  @override
  Iterable<T> map<T>(T Function(E e) toElement) {
    return _delegate.map(toElement);
  }

  @override
  E reduce(E Function(E value, E element) combine) {
    return _delegate.reduce(combine);
  }

  @override
  E get single {
    return _delegate.single;
  }

  @override
  E singleWhere(bool Function(E element) test, {E Function()? orElse}) {
    return _delegate.singleWhere(test, orElse: orElse);
  }

  @override
  Iterable<E> skip(int count) {
    return _delegate.skip(count);
  }

  @override
  Iterable<E> skipWhile(bool Function(E value) test) {
    return _delegate.skipWhile(test);
  }

  @override
  Iterable<E> take(int count) {
    return _delegate.take(count);
  }

  @override
  Iterable<E> takeWhile(bool Function(E value) test) {
    return _delegate.takeWhile(test);
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
  Iterable<E> where(bool Function(E element) test) {
    return _delegate.where(test);
  }

  @override
  Iterable<T> whereType<T>() {
    return _delegate.whereType<T>();
  }

  @override
  String toString() {
    return _delegate.toString();
  }
}
