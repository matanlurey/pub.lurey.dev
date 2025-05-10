import 'package:rune/rune.dart';

import '../prelude.dart';

void main() {
  const create = DelegatingSet.new;

  test('cast', () {
    final numbers = create<num>({1, 2, 3});
    final integers = numbers.cast<int>();
    check(integers).deepEquals({1, 2, 3});
  });

  test('add', () {
    final set = create({1, 2});
    set.add(3);
    check(set).deepEquals({1, 2, 3});
  });

  test('addAll', () {
    final set = create({1, 2});
    set.addAll({3, 4});
    check(set).deepEquals({1, 2, 3, 4});
  });

  test('clear', () {
    final set = create({1, 2, 3});
    set.clear();
    check(set).deepEquals({});
  });

  test('remove', () {
    final set = create({1, 2, 3});
    set.remove(2);
    check(set).deepEquals({1, 3});
  });

  test('removeAll', () {
    final set = create({1, 2, 3});
    set.removeAll({2, 3});
    check(set).deepEquals({1});
  });

  test('removeWhere', () {
    final set = create({1, 2, 3});
    set.removeWhere((element) => element == 2);
    check(set).deepEquals({1, 3});
  });

  test('retainAll', () {
    final set = create({1, 2, 3});
    set.retainAll({2, 3});
    check(set).deepEquals({2, 3});
  });

  test('retainWhere', () {
    final set = create({1, 2, 3});
    set.retainWhere((element) => element == 2);
    check(set).deepEquals({2});
  });
}
