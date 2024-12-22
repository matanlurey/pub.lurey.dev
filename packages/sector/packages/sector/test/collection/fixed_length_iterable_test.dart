import '../prelude.dart';

void main() {
  test('is not empty', () {
    final iterable = _FixedSet({1, 2, 3});
    check(iterable).isNotEmpty();
  });

  test('.first on empty throws', () {
    final iterable = _FixedSet<int>(<int>{});
    check(() => iterable.first).throws<StateError>();
  });

  test('.last on empty throws', () {
    final iterable = _FixedSet<int>(<int>{});
    check(() => iterable.last).throws<StateError>();
  });

  test('.single on empty throws', () {
    final iterable = _FixedSet<int>(<int>{});
    check(() => iterable.single).throws<StateError>();
  });

  test('.single on one element succeeds', () {
    final iterable = _FixedSet({1});
    check(iterable.single).equals(1);
  });

  test('every returns true', () {
    final iterable = _FixedSet<Object?>({1, 2, 3});
    check(iterable.every((element) => element is int)).isTrue();
  });

  test('every returns false', () {
    final iterable = _FixedSet({1, 2, 3});
    check(iterable.every((element) => element is String)).isFalse();
  });

  test('any returns true', () {
    final iterable = _FixedSet<Object?>({1, 2, 3});
    check(iterable.any((element) => element is int)).isTrue();
  });

  test('any returns false', () {
    final iterable = _FixedSet({1, 2, 3});
    check(iterable.any((element) => element is String)).isFalse();
  });

  test('firstWhere throws on no match', () {
    final iterable = _FixedSet({1, 2, 3});
    check(
      () => iterable.firstWhere((element) => element is String),
    ).throws<StateError>();
  });

  test('lastWhere throws on no match', () {
    final iterable = _FixedSet({1, 2, 3});
    check(
      () => iterable.lastWhere((element) => element is String),
    ).throws<StateError>();
  });

  test('singleWhere throws on no match', () {
    final iterable = _FixedSet({1, 2, 3});
    check(
      () => iterable.singleWhere((element) => element is String),
    ).throws<StateError>();
  });

  test('reduce throws on empty', () {
    final iterable = _FixedSet<int>(<int>{});
    check(
      () => iterable.reduce((value, element) => value + element),
    ).throws<StateError>();
  });

  test('toList returns an empty list', () {
    final iterable = _FixedSet<int>(<int>{});
    check(iterable.toList()).deepEquals([]);
  });

  test('take of a take works as expected', () {
    final iterable = _FixedSet({1, 2, 3, 4, 5});
    check(iterable.take(3).take(20)).deepEquals([1, 2, 3]);
  });
}

/// A dummy set to test [FixedLengthIterable].
final class _FixedSet<E> extends FixedLengthIterable<E> {
  const _FixedSet(this._elements);
  final Set<E> _elements;

  @override
  E elementAt(int index) => _elements.elementAt(index);

  @override
  int get length => _elements.length;
}
