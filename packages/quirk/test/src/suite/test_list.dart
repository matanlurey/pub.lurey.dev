import '../../_prelude.dart';

/// Runs a test suite on the returned list from [create].
void testList(List<E> Function<E>(List<E>) create) {
  test('cast', () {
    final list = create([1, 2, 3]);
    final casted = list.cast<num>();

    check(casted).not((i) => i.identicalTo(list));
    check(casted).deepEquals([1, 2, 3]);
  });

  test('operator []', () {
    final list = create([1, 2, 3]);

    check(list[0]).equals(1);
    check(list[1]).equals(2);
    check(list[2]).equals(3);
  });

  test('reversed', () {
    final list = create([1, 2, 3]);
    final reversed = list.reversed;

    check(reversed).deepEquals([3, 2, 1]);
  });

  test('indexOf', () {
    final list = create([1, 2, 3]);

    check(list.indexOf(2)).equals(1);
    check(list.indexOf(4)).equals(-1);
  });

  test('indexWhere', () {
    final list = create([1, 2, 3]);

    check(list.indexWhere((e) => e > 1)).equals(1);
    check(list.indexWhere((e) => e > 3)).equals(-1);
  });

  test('lastIndexOf', () {
    final list = create([1, 2, 3]);

    check(list.lastIndexOf(2)).equals(1);
    check(list.lastIndexOf(4)).equals(-1);
  });

  test('lastIndexWhere', () {
    final list = create([1, 2, 3]);

    check(list.lastIndexWhere((e) => e < 3)).equals(1);
    check(list.lastIndexWhere((e) => e > 3)).equals(-1);
  });

  test('operator +', () {
    final list = create([1, 2, 3]);
    final other = create([4, 5]);

    final combined = list + other;

    check(combined).deepEquals([1, 2, 3, 4, 5]);
  });

  test('sublist', () {
    final list = create([1, 2, 3]);

    final sublist = list.sublist(1, 3);

    check(sublist).deepEquals([2, 3]);
  });

  test('getRange', () {
    final list = create([1, 2, 3]);

    final range = list.getRange(1, 3);

    check(range).deepEquals([2, 3]);
  });

  test('asMap', () {
    final list = create([1, 2, 3]);

    final map = list.asMap();

    check(map).deepEquals({0: 1, 1: 2, 2: 3});
  });

  test('toString', () {
    final list = create([1, 2, 3]);

    check(list.toString()).equals('[1, 2, 3]');
  });

  test('operator []=', () {
    final list = create([1, 2, 3]);

    list[0] = 4;

    check(list).deepEquals([4, 2, 3]);
  });

  test('first =', () {
    final list = create([1, 2, 3]);

    list.first = 4;

    check(list).deepEquals([4, 2, 3]);
  });

  test('last =', () {
    final list = create([1, 2, 3]);

    list.last = 4;

    check(list).deepEquals([1, 2, 4]);
  });

  test('length =', () {
    final list = create([1, 2, 3]);

    list.length = 2;

    check(list).deepEquals([1, 2]);
  });

  test('add', () {
    final list = create([1, 2, 3]);

    list.add(4);

    check(list).deepEquals([1, 2, 3, 4]);
  });

  test('addAll', () {
    final list = create([1, 2, 3]);
    final other = create([4, 5]);

    list.addAll(other);

    check(list).deepEquals([1, 2, 3, 4, 5]);
  });

  test('sort', () {
    final list = create([3, 1, 2]);

    list.sort();

    check(list).deepEquals([1, 2, 3]);
  });

  test('shuffle', () {
    final list = create([1, 2, 3]);

    list.shuffle();
  });

  test('clear', () {
    final list = create([1, 2, 3]);

    list.clear();

    check(list).deepEquals([]);
  });

  test('insert', () {
    final list = create([1, 2, 3]);

    list.insert(1, 4);

    check(list).deepEquals([1, 4, 2, 3]);
  });

  test('insertAll', () {
    final list = create([1, 2, 3]);
    final other = create([4, 5]);

    list.insertAll(1, other);

    check(list).deepEquals([1, 4, 5, 2, 3]);
  });

  test('setAll', () {
    final list = create([1, 2, 3]);
    final other = create([4, 5]);

    list.setAll(1, other);

    check(list).deepEquals([1, 4, 5]);
  });

  test('remove', () {
    final list = create([1, 2, 3]);

    list.remove(2);

    check(list).deepEquals([1, 3]);
  });

  test('removeAt', () {
    final list = create([1, 2, 3]);

    list.removeAt(1);

    check(list).deepEquals([1, 3]);
  });

  test('removeLast', () {
    final list = create([1, 2, 3]);

    list.removeLast();

    check(list).deepEquals([1, 2]);
  });

  test('removeWhere', () {
    final list = create([1, 2, 3]);

    list.removeWhere((e) => e > 1);

    check(list).deepEquals([1]);
  });

  test('retainWhere', () {
    final list = create([1, 2, 3]);

    list.retainWhere((e) => e > 1);

    check(list).deepEquals([2, 3]);
  });

  test('setRange', () {
    final list = create([1, 2, 3]);
    final other = create([4, 5]);

    list.setRange(1, 3, other);

    check(list).deepEquals([1, 4, 5]);
  });

  test('removeRange', () {
    final list = create([1, 2, 3]);

    list.removeRange(1, 3);

    check(list).deepEquals([1]);
  });

  test('fillRange', () {
    final list = create([1, 2, 3]);

    list.fillRange(1, 3, 4);

    check(list).deepEquals([1, 4, 4]);
  });

  test('replaceRange', () {
    final list = create([1, 2, 3]);
    final other = create([4, 5]);

    list.replaceRange(1, 3, other);

    check(list).deepEquals([1, 4, 5]);
  });
}
