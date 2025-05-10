import 'package:rune/rune.dart';

import '../prelude.dart';

void main() {
  final create = CopyOnWriteList.new;

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
    final base = [1, 2, 3];
    final cow = create(base);
    cow[1] = 4;
    check(cow).deepEquals([1, 4, 3]);
    check(base).deepEquals([1, 2, 3]);
  });

  test('add', () {
    final base = [1, 2];
    final cow = create(base);
    cow.add(3);
    check(cow).deepEquals([1, 2, 3]);
    check(base).deepEquals([1, 2]);
  });

  test('addAll', () {
    final base = [1, 2];
    final cow = create(base);
    cow.addAll([3, 4]);
    check(cow).deepEquals([1, 2, 3, 4]);
    check(base).deepEquals([1, 2]);
  });

  test('clear', () {
    final base = [1, 2, 3];
    final cow = create(base);
    cow.clear();
    check(cow).deepEquals([]);
    check(base).deepEquals([1, 2, 3]);
  });

  test('fillRange', () {
    final base = [1, 2, 3];
    final cow = create(base);
    cow.fillRange(0, 2, 0);
    check(cow).deepEquals([0, 0, 3]);
    check(base).deepEquals([1, 2, 3]);
  });

  test('fillRange', () {
    final base = [1, 2, 3];
    final cow = create(base);
    cow.fillRange(0, 2, 0);
    check(cow).deepEquals([0, 0, 3]);
    check(base).deepEquals([1, 2, 3]);
  });

  test('first=', () {
    final base = [1, 2, 3];
    final cow = create(base);
    cow.first = 0;
    check(cow).deepEquals([0, 2, 3]);
    check(base).deepEquals([1, 2, 3]);
  });

  test('insert', () {
    final base = [1, 2, 3];
    final cow = create(base);
    cow.insert(1, 4);
    check(cow).deepEquals([1, 4, 2, 3]);
    check(base).deepEquals([1, 2, 3]);
  });

  test('insertAll', () {
    final base = [1, 2, 3];
    final cow = create(base);
    cow.insertAll(1, [4, 5]);
    check(cow).deepEquals([1, 4, 5, 2, 3]);
    check(base).deepEquals([1, 2, 3]);
  });

  test('last=', () {
    final base = [1, 2, 3];
    final cow = create(base);
    cow.last = 0;
    check(cow).deepEquals([1, 2, 0]);
    check(base).deepEquals([1, 2, 3]);
  });

  test('length=', () {
    final base = [1, 2, 3];
    final cow = create(base);
    cow.length = 2;
    check(cow).deepEquals([1, 2]);
    check(base).deepEquals([1, 2, 3]);
  });

  test('remove', () {
    final base = [1, 2, 3];
    final cow = create(base);
    cow.remove(2);
    check(cow).deepEquals([1, 3]);
    check(base).deepEquals([1, 2, 3]);
  });

  test('removeAt', () {
    final base = [1, 2, 3];
    final cow = create(base);
    cow.removeAt(1);
    check(cow).deepEquals([1, 3]);
    check(base).deepEquals([1, 2, 3]);
  });

  test('removeLast', () {
    final base = [1, 2, 3];
    final cow = create(base);
    cow.removeLast();
    check(cow).deepEquals([1, 2]);
    check(base).deepEquals([1, 2, 3]);
  });

  test('removeRange', () {
    final base = [1, 2, 3];
    final cow = create(base);
    cow.removeRange(0, 2);
    check(cow).deepEquals([3]);
    check(base).deepEquals([1, 2, 3]);
  });

  test('removeWhere', () {
    final base = [1, 2, 3];
    final cow = create(base);
    cow.removeWhere((e) => e == 2);
    check(cow).deepEquals([1, 3]);
    check(base).deepEquals([1, 2, 3]);
  });

  test('replaceRange', () {
    final base = [1, 2, 3];
    final cow = create(base);
    cow.replaceRange(0, 2, [4, 5]);
    check(cow).deepEquals([4, 5, 3]);
    check(base).deepEquals([1, 2, 3]);
  });

  test('retainWhere', () {
    final base = [1, 2, 3];
    final cow = create(base);
    cow.retainWhere((e) => e == 2);
    check(cow).deepEquals([2]);
    check(base).deepEquals([1, 2, 3]);
  });

  test('setAll', () {
    final base = [1, 2, 3];
    final cow = create(base);
    cow.setAll(0, [4, 5]);
    check(cow).deepEquals([4, 5, 3]);
    check(base).deepEquals([1, 2, 3]);
  });

  test('setRange', () {
    final base = [1, 2, 3];
    final cow = create(base);
    cow.setRange(0, 2, [4, 5]);
    check(cow).deepEquals([4, 5, 3]);
    check(base).deepEquals([1, 2, 3]);
  });

  test('shuffle', () {
    final base = [1, 2, 3];
    final cow = create(base);
    cow.shuffle();
    check(cow).unorderedEquals([1, 2, 3]);
    check(base).deepEquals([1, 2, 3]);
  });

  test('sort', () {
    final base = [3, 1, 2];
    final cow = create(base);
    cow.sort();
    check(cow).deepEquals([1, 2, 3]);
    check(base).deepEquals([3, 1, 2]);
  });
}
