import 'package:armory/armory.dart';

import '../prelude.dart';

void main() {
  const create = DelegatingList.new;

  test('cast', () {
    final numbers = create<num>([1, 2, 3]);
    final integers = numbers.cast<int>();
    check(integers).deepEquals([1, 2, 3]);
  });

  test('operator +', () {
    final list1 = create([1, 2]);
    final list2 = create([3, 4]);
    final result = list1 + list2;
    check(result).deepEquals([1, 2, 3, 4]);
  });

  test('operator []=', () {
    final list = create([1, 2, 3]);
    list[1] = 4;
    check(list).deepEquals([1, 4, 3]);
  });

  test('add', () {
    final list = create([1, 2]);
    list.add(3);
    check(list).deepEquals([1, 2, 3]);
  });

  test('addAll', () {
    final list = create([1, 2]);
    list.addAll([3, 4]);
    check(list).deepEquals([1, 2, 3, 4]);
  });

  test('clear', () {
    final list = create([1, 2, 3]);
    list.clear();
    check(list).deepEquals([]);
  });

  test('fillRange', () {
    final list = create([1, 2, 3]);
    list.fillRange(0, 2, 0);
    check(list).deepEquals([0, 0, 3]);
  });

  test('first=', () {
    final list = create([1, 2, 3]);
    list.first = 0;
    check(list).deepEquals([0, 2, 3]);
  });

  test('insert', () {
    final list = create([1, 2, 3]);
    list.insert(1, 4);
    check(list).deepEquals([1, 4, 2, 3]);
  });

  test('insertAll', () {
    final list = create([1, 2, 3]);
    list.insertAll(1, [4, 5]);
    check(list).deepEquals([1, 4, 5, 2, 3]);
  });

  test('last=', () {
    final list = create([1, 2, 3]);
    list.last = 0;
    check(list).deepEquals([1, 2, 0]);
  });

  test('length=', () {
    final list = create([1, 2, 3]);
    list.length = 2;
    check(list).deepEquals([1, 2]);
  });

  test('remove', () {
    final list = create([1, 2, 3]);
    list.remove(2);
    check(list).deepEquals([1, 3]);
  });

  test('removeAt', () {
    final list = create([1, 2, 3]);
    final removed = list.removeAt(1);
    check(removed).equals(2);
    check(list).deepEquals([1, 3]);
  });

  test('removeLast', () {
    final list = create([1, 2, 3]);
    final removed = list.removeLast();
    check(removed).equals(3);
    check(list).deepEquals([1, 2]);
  });

  test('removeRange', () {
    final list = create([1, 2, 3, 4]);
    list.removeRange(1, 3);
    check(list).deepEquals([1, 4]);
  });

  test('removeWhere', () {
    final list = create([1, 2, 3]);
    list.removeWhere((e) => e == 2);
    check(list).deepEquals([1, 3]);
  });

  test('replaceRange', () {
    final list = create([1, 2, 3]);
    list.replaceRange(1, 2, [4, 5]);
    check(list).deepEquals([1, 4, 5, 3]);
  });

  test('retainWhere', () {
    final list = create([1, 2, 3]);
    list.retainWhere((e) => e == 2);
    check(list).deepEquals([2]);
  });

  test('setAll', () {
    final list = create([1, 2, 3]);
    list.setAll(1, [4, 5]);
    check(list).deepEquals([1, 4, 5]);
  });

  test('setRange', () {
    final list = create([1, 2, 3]);
    list.setRange(1, 3, [4, 5]);
    check(list).deepEquals([1, 4, 5]);
  });

  test('shuffle', () {
    final list = create([1, 2, 3]);
    list.shuffle();
    check(list).unorderedEquals([1, 2, 3]);
  });

  test('sort', () {
    final list = create([3, 1, 2]);
    list.sort();
    check(list).deepEquals([1, 2, 3]);
  });
}
