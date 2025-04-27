import '../../_prelude.dart';

/// Runs a test suite on the returned iterable from [create].
void testIterable(Iterable<E> Function<E>(Iterable<E>) create) {
  test('iterator', () {
    final iterable = create([1, 2, 3]);
    final iterator = iterable.iterator;

    check(iterator.moveNext()).isTrue();
    check(iterator.current).equals(1);
    check(iterator.moveNext()).isTrue();
    check(iterator.current).equals(2);
    check(iterator.moveNext()).isTrue();
    check(iterator.current).equals(3);
    check(iterator.moveNext()).isFalse();
  });

  test('cast', () {
    final iterable = create([1, 2, 3]);
    final casted = iterable.cast<num>();

    check(casted).not((i) => i.identicalTo(iterable));
    check(casted).deepEquals([1, 2, 3]);
  });

  test('followedBy', () {
    final iterable = create([1, 2, 3]);
    final followedBy = iterable.followedBy([4, 5]);

    check(followedBy).not((i) => i.identicalTo(iterable));
    check(followedBy).deepEquals([1, 2, 3, 4, 5]);
  });

  test('map', () {
    final iterable = create([1, 2, 3]);
    final mapped = iterable.map((e) => e * 2);

    check(mapped).not((i) => i.identicalTo(iterable));
    check(mapped).deepEquals([2, 4, 6]);
  });

  test('where', () {
    final iterable = create([1, 2, 3]);
    final filtered = iterable.where((e) => e > 1);

    check(filtered).not((i) => i.identicalTo(iterable));
    check(filtered).deepEquals([2, 3]);
  });

  test('whereType', () {
    final iterable = create([1, '2', 3]);
    final filtered = iterable.whereType<int>();

    check(filtered).deepEquals([1, 3]);
  });

  test('expand', () {
    final iterable = create([1, 2, 3]);
    final expanded = iterable.expand((e) => [e, e * 2]);

    check(expanded).not((i) => i.identicalTo(iterable));
    check(expanded).deepEquals([1, 2, 2, 4, 3, 6]);
  });

  test('contains', () {
    final iterable = create([1, 2, 3]);

    check(iterable.contains(2)).isTrue();
    check(iterable.contains(4)).isFalse();
  });

  test('forEach', () {
    final iterable = create([1, 2, 3]);
    final result = <int>[];

    iterable.forEach(result.add);

    check(result).deepEquals([1, 2, 3]);
  });

  test('reduce', () {
    final iterable = create([1, 2, 3]);
    final result = iterable.reduce((a, b) => a + b);

    check(result).equals(6);
  });

  test('fold', () {
    final iterable = create([1, 2, 3]);
    final result = iterable.fold(0, (a, b) => a + b);

    check(result).equals(6);
  });

  test('every', () {
    final iterable = create([1, 2, 3]);

    check(iterable.every((e) => e > 0)).isTrue();
    check(iterable.every((e) => e > 1)).isFalse();
  });

  test('join', () {
    final iterable = create([1, 2, 3]);
    final joined = iterable.join(',');

    check(joined).equals('1,2,3');
  });

  test('any', () {
    final iterable = create([1, 2, 3]);

    check(iterable.any((e) => e > 2)).isTrue();
    check(iterable.any((e) => e > 3)).isFalse();
  });

  test('toList', () {
    final iterable = create([1, 2, 3]);
    final list = iterable.toList();

    check(list).deepEquals([1, 2, 3]);
  });

  test('toSet', () {
    final iterable = create([1, 2, 3]);
    final set = iterable.toSet();

    check(set).deepEquals({1, 2, 3});
  });

  test('length', () {
    final iterable = create([1, 2, 3]);

    check(iterable.length).equals(3);
  });

  test('isEmpty', () {
    final emptyIterable = create([]);
    final nonEmptyIterable = create([1, 2, 3]);

    check(emptyIterable.isEmpty).isTrue();
    check(nonEmptyIterable.isEmpty).isFalse();
  });

  test('isNotEmpty', () {
    final emptyIterable = create([]);
    final nonEmptyIterable = create([1, 2, 3]);

    check(emptyIterable.isNotEmpty).isFalse();
    check(nonEmptyIterable.isNotEmpty).isTrue();
  });

  test('take', () {
    final iterable = create([1, 2, 3]);
    final taken = iterable.take(2);

    check(taken).deepEquals([1, 2]);
  });

  test('takeWhile', () {
    final iterable = create([1, 2, 3]);
    final taken = iterable.takeWhile((e) => e < 3);

    check(taken).deepEquals([1, 2]);
  });

  test('skip', () {
    final iterable = create([1, 2, 3]);
    final skipped = iterable.skip(2);

    check(skipped).deepEquals([3]);
  });

  test('skipWhile', () {
    final iterable = create([1, 2, 3]);
    final skipped = iterable.skipWhile((e) => e < 3);

    check(skipped).deepEquals([3]);
  });

  test('first', () {
    final iterable = create([1, 2, 3]);

    check(iterable.first).equals(1);
  });

  test('last', () {
    final iterable = create([1, 2, 3]);

    check(iterable.last).equals(3);
  });

  test('single', () {
    final iterable = create([1]);

    check(iterable.single).equals(1);
  });

  test('firstWhere', () {
    final iterable = create([1, 2, 3]);
    final first = iterable.firstWhere((e) => e > 1);

    check(first).equals(2);
  });

  test('lastWhere', () {
    final iterable = create([1, 2, 3]);
    final last = iterable.lastWhere((e) => e < 3);

    check(last).equals(2);
  });

  test('singleWhere', () {
    final iterable = create([1]);

    check(iterable.singleWhere((e) => e == 1)).equals(1);
  });

  test('elementAt', () {
    final iterable = create([1, 2, 3]);
    final element = iterable.elementAt(1);

    check(element).equals(2);
  });

  test('toString', () {
    final iterable = create([1, 2, 3]);
    final string = iterable.toString();

    check(string).equals('(1, 2, 3)');
  });
}
