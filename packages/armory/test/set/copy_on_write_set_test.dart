import 'package:armory/armory.dart';

import '../prelude.dart';

void main() {
  final create = CopyOnWriteSet.new;

  test('cast', () {
    final numbers = create<num>({1, 2, 3});
    final integers = numbers.cast<int>();
    check(integers).deepEquals({1, 2, 3});
  });

  test('add', () {
    final base = {1, 2};
    final cow = create(base);
    cow.add(3);
    check(cow).deepEquals({1, 2, 3});
    check(base).deepEquals({1, 2});
  });

  test('addAll', () {
    final base = {1, 2};
    final cow = create(base);
    cow.addAll({3, 4});
    check(cow).deepEquals({1, 2, 3, 4});
    check(base).deepEquals({1, 2});
  });

  test('clear', () {
    final base = {1, 2, 3};
    final cow = create(base);
    cow.clear();
    check(cow).deepEquals({});
    check(base).deepEquals({1, 2, 3});
  });

  test('remove', () {
    final base = {1, 2, 3};
    final cow = create(base);
    cow.remove(2);
    check(cow).deepEquals({1, 3});
    check(base).deepEquals({1, 2, 3});
  });

  test('removeAll', () {
    final base = {1, 2, 3};
    final cow = create(base);
    cow.removeAll({2, 3});
    check(cow).deepEquals({1});
    check(base).deepEquals({1, 2, 3});
  });

  test('removeWhere', () {
    final base = {1, 2, 3};
    final cow = create(base);
    cow.removeWhere((element) => element == 2);
    check(cow).deepEquals({1, 3});
    check(base).deepEquals({1, 2, 3});
  });

  test('retainAll', () {
    final base = {1, 2, 3};
    final cow = create(base);
    cow.retainAll({2, 3});
    check(cow).deepEquals({2, 3});
    check(base).deepEquals({1, 2, 3});
  });

  test('retainWhere', () {
    final base = {1, 2, 3};
    final cow = create(base);
    cow.retainWhere((element) => element == 2);
    check(cow).deepEquals({2});
    check(base).deepEquals({1, 2, 3});
  });
}
