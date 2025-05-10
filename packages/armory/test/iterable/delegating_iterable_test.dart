import 'package:armory/armory.dart';

import '../prelude.dart';

void main() {
  const create = DelegatingIterable.new;

  test('any', () {
    check(create([1, 2, 3]).any((e) => e == 2)).isTrue();
    check(create([1, 2, 3]).any((e) => e == 4)).isFalse();
  });

  test('cast', () {
    final numbers = create<num>([1, 2, 3]);
    final integers = numbers.cast<int>();
    check(integers).deepEquals([1, 2, 3]);
  });

  test('contains', () {
    check(create([1, 2, 3]).contains(2)).isTrue();
    check(create([1, 2, 3]).contains(4)).isFalse();
  });

  test('elementAt', () {
    check(create([1, 2, 3]).elementAt(1)).equals(2);
    check(() => create([1, 2, 3]).elementAt(3)).throws<RangeError>();
  });

  test('every', () {
    check(create([1, 2, 3]).every((e) => e > 0)).isTrue();
    check(create([1, 2, -3]).every((e) => e > 0)).isFalse();
  });

  test('expand', () {
    final result = create([1, 2]).expand((e) => [e, e * 2]);
    check(result).deepEquals([1, 2, 2, 4]);
  });

  test('first', () {
    check(create([1, 2, 3]).first).equals(1);
    check(() => create([]).first).throws<StateError>();
  });

  test('firstWhere', () {
    check(create([1, 2, 3]).firstWhere((e) => e == 2)).equals(2);
    check(
      () => create([1, 2, 3]).firstWhere((e) => e == 4),
    ).throws<StateError>();
    check(
      create([1, 2, 3]).firstWhere((e) => e == 4, orElse: () => -1),
    ).equals(-1);
  });

  test('fold', () {
    final result = create([1, 2, 3]).fold(0, (prev, e) => prev + e);
    check(result).equals(6);
  });

  test('followedBy', () {
    final result = create([1, 2]).followedBy([3, 4]);
    check(result).deepEquals([1, 2, 3, 4]);
  });

  test('forEach', () {
    final list = <int>[];
    create([1, 2, 3]).forEach(list.add);
    check(list).deepEquals([1, 2, 3]);
  });

  test('isEmpty', () {
    check(create([]).isEmpty).isTrue();
    check(create([1]).isEmpty).isFalse();
  });

  test('isNotEmpty', () {
    check(create([]).isNotEmpty).isFalse();
    check(create([1]).isNotEmpty).isTrue();
  });

  test('iterator', () {
    final iterator = create([1, 2, 3]).iterator;
    check(iterator.moveNext()).isTrue();
    check(iterator.current).equals(1);
    check(iterator.moveNext()).isTrue();
    check(iterator.current).equals(2);
    check(iterator.moveNext()).isTrue();
    check(iterator.current).equals(3);
    check(iterator.moveNext()).isFalse();
  });

  test('join', () {
    check(create([1, 2, 3]).join()).equals('123');
    check(create([1, 2, 3]).join(', ')).equals('1, 2, 3');
  });

  test('last', () {
    check(create([1, 2, 3]).last).equals(3);
    check(() => create([]).last).throws<StateError>();
  });

  test('lastWhere', () {
    check(create([1, 2, 3]).lastWhere((e) => e == 2)).equals(2);
    check(
      () => create([1, 2, 3]).lastWhere((e) => e == 4),
    ).throws<StateError>();
    check(
      create([1, 2, 3]).lastWhere((e) => e == 4, orElse: () => -1),
    ).equals(-1);
  });

  test('length', () {
    check(create([1, 2, 3]).length).equals(3);
    check(create([]).length).equals(0);
  });

  test('map', () {
    final result = create([1, 2, 3]).map((e) => e * 2);
    check(result).deepEquals([2, 4, 6]);
  });

  test('reduce', () {
    final result = create([1, 2, 3]).reduce((prev, e) => prev + e);
    check(result).equals(6);
  });

  test('single', () {
    check(create([1]).single).equals(1);
    check(() => create([]).single).throws<StateError>();
    check(() => create([1, 2]).single).throws<StateError>();
  });

  test('singleWhere', () {
    check(create([1, 2, 3]).singleWhere((e) => e == 2)).equals(2);
    check(
      () => create([1, 2, 3]).singleWhere((e) => e == 4),
    ).throws<StateError>();
    check(
      create([1, 2, 3]).singleWhere((e) => e == 4, orElse: () => -1),
    ).equals(-1);
  });

  test('skip', () {
    final result = create([1, 2, 3]).skip(1);
    check(result).deepEquals([2, 3]);
  });

  test('skipWhile', () {
    final result = create([1, 2, 3]).skipWhile((e) => e < 2);
    check(result).deepEquals([2, 3]);
  });

  test('take', () {
    final result = create([1, 2, 3]).take(2);
    check(result).deepEquals([1, 2]);
  });

  test('takeWhile', () {
    final result = create([1, 2, 3]).takeWhile((e) => e < 2);
    check(result).deepEquals([1]);
  });

  test('toList', () {
    final result = create([1, 2, 3]).toList();
    check(result).deepEquals([1, 2, 3]);
  });

  test('toSet', () {
    final result = create([1, 2, 3]).toSet();
    check(result).deepEquals({1, 2, 3});
  });

  test('where', () {
    final result = create([1, 2, 3]).where((e) => e > 1);
    check(result).deepEquals([2, 3]);
  });

  test('whereType', () {
    final result = create([1, '2', 3]).whereType<int>();
    check(result).deepEquals([1, 3]);
  });

  test('toString', () {
    check(create([1, 2, 3]).toString()).equals('[1, 2, 3]');
    check(create([]).toString()).equals('[]');
  });
}
