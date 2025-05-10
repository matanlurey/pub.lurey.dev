import 'package:armory/armory.dart';

import '../prelude.dart';

void main() {
  test('is not empty', () {
    final iterable = _SetIterable({1, 2, 3});
    check(iterable).isNotEmpty();
  });

  test('forEach iterates over all elements', () {
    final iterable = _SetIterable({1, 2, 3});
    final elements = <int>[];
    iterable.forEach(elements.add);
    check(elements).deepEquals([1, 2, 3]);
  });

  test('.first on empty throws', () {
    final iterable = _SetIterable<int>(<int>{});
    check(() => iterable.first).throws<StateError>();
  });

  test('.first on one element succeeds', () {
    final iterable = _SetIterable({1});
    check(iterable.first).equals(1);
  });

  test('.last on empty throws', () {
    final iterable = _SetIterable<int>(<int>{});
    check(() => iterable.last).throws<StateError>();
  });

  test('.last on one element succeeds', () {
    final iterable = _SetIterable({1});
    check(iterable.last).equals(1);
  });

  test('.single on empty throws', () {
    final iterable = _SetIterable<int>(<int>{});
    check(() => iterable.single).throws<StateError>();
  });

  test('.single on multiple elements throws', () {
    final iterable = _SetIterable({1, 2});
    check(() => iterable.single).throws<StateError>();
  });

  test('.single on one element succeeds', () {
    final iterable = _SetIterable({1});
    check(iterable.single).equals(1);
  });

  test('every returns true', () {
    final iterable = _SetIterable<Object?>({1, 2, 3});
    check(iterable.every((element) => element is int)).isTrue();
  });

  test('every returns false', () {
    final iterable = _SetIterable({1, 2, 3});
    check(iterable.every((element) => element is String)).isFalse();
  });

  test('any returns true', () {
    final iterable = _SetIterable<Object?>({1, 2, 3});
    check(iterable.any((element) => element is int)).isTrue();
  });

  test('any returns false', () {
    final iterable = _SetIterable({1, 2, 3});
    check(iterable.any((element) => element is String)).isFalse();
  });

  test('firstWhere throws on no match', () {
    final iterable = _SetIterable({1, 2, 3});
    check(
      () => iterable.firstWhere((element) => element is String),
    ).throws<StateError>();
  });

  test('firstWhere orElse triggers', () {
    final iterable = _SetIterable({1, 2, 3});
    check(
      iterable.firstWhere((element) => element is String, orElse: () => 42),
    ).equals(42);
  });

  test('lastWhere throws on no match', () {
    final iterable = _SetIterable({1, 2, 3});
    check(
      () => iterable.lastWhere((element) => element is String),
    ).throws<StateError>();
  });

  test('lastWhere orElse triggers', () {
    final iterable = _SetIterable({1, 2, 3});
    check(
      iterable.lastWhere((element) => element is String, orElse: () => 42),
    ).equals(42);
  });

  test('singleWhere throws on no match', () {
    final iterable = _SetIterable({1, 2, 3});
    check(
      () => iterable.singleWhere((element) => element is String),
    ).throws<StateError>();
  });

  test('singleWhere orElse triggers', () {
    final iterable = _SetIterable({1, 2, 3});
    check(
      iterable.singleWhere((element) => element is String, orElse: () => 42),
    ).equals(42);
  });

  test('singleWhere throws on multiple matches', () {
    final iterable = _SetIterable({1, 2, 3});
    check(
      () => iterable.singleWhere((element) => element >= 1),
    ).throws<StateError>();
  });

  test('join on empty', () {
    final iterable = _SetIterable<int>(<int>{});
    check(iterable.join()).equals('');
  });

  test('join on non-empty', () {
    final iterable = _SetIterable({1, 2, 3});
    check(iterable.join(',')).equals('1,2,3');
  });

  test('reduce throws on empty', () {
    final iterable = _SetIterable<int>(<int>{});
    check(
      () => iterable.reduce((value, element) => value + element),
    ).throws<StateError>();
  });

  test('reduce on non-empty', () {
    final iterable = _SetIterable({1, 2, 3});
    check(iterable.reduce((value, element) => value + element)).equals(6);
  });

  test('fold on empty', () {
    final iterable = _SetIterable<int>(<int>{});
    check(
      iterable.fold(0, (previousValue, element) => previousValue + element),
    ).equals(0);
  });

  test('fold on non-empty', () {
    final iterable = _SetIterable({1, 2, 3});
    check(
      iterable.fold(0, (previousValue, element) => previousValue + element),
    ).equals(6);
  });

  test('skip returns an empty iterable', () {
    final iterable = _SetIterable<int>(<int>{});
    check(iterable.skip(10)).deepEquals([]);
  });

  test('skip returns an iterable', () {
    final iterable = _SetIterable({1, 2, 3, 4, 5});
    check(iterable.skip(2)).deepEquals([3, 4, 5]);
  });

  test('toList returns an empty list', () {
    final iterable = _SetIterable<int>(<int>{});
    check(iterable.toList()).deepEquals([]);
  });

  test('toList returns a list', () {
    final iterable = _SetIterable({1, 2, 3, 4, 5});
    check(iterable.toList()).deepEquals([1, 2, 3, 4, 5]);
  });

  test('take of a take works as expected', () {
    final iterable = _SetIterable({1, 2, 3, 4, 5});
    check(iterable.take(3).take(20)).deepEquals([1, 2, 3]);
  });

  test('subRange.skip works as expected', () {
    final iterable = _SetIterable({1, 2, 3, 4, 5});
    check(iterable.skip(2).skip(1)).deepEquals([4, 5]);
  });
}

/// A dummy set to test [EfficientAccessIterable].
final class _SetIterable<E> extends EfficientAccessIterable<E> {
  const _SetIterable(this._elements);
  final Set<E> _elements;

  @override
  E elementAt(int index) => _elements.elementAt(index);

  @override
  int get length => _elements.length;
}
