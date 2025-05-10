import 'package:rune/rune.dart';

import '../prelude.dart';

void main() {
  final create = CopyOnWriteMap.new;

  test('cast', () {
    final numbers = create<String, num>({'a': 1, 'b': 2, 'c': 3});
    final integers = numbers.cast<String, int>();
    check(integers).deepEquals({'a': 1, 'b': 2, 'c': 3});
  });

  test('operator []=', () {
    final base = {'a': 1, 'b': 2};
    final cow = create(base);
    cow['c'] = 3;
    check(cow).deepEquals({'a': 1, 'b': 2, 'c': 3});
  });

  test('addAll', () {
    final base = {'a': 1, 'b': 2};
    final cow = create(base);
    cow.addAll({'c': 3, 'd': 4});
    check(cow).deepEquals({'a': 1, 'b': 2, 'c': 3, 'd': 4});
    check(base).deepEquals({'a': 1, 'b': 2});
  });

  test('addEntries', () {
    final base = {'a': 1, 'b': 2};
    final cow = create(base);
    cow.addEntries([MapEntry('c', 3), MapEntry('d', 4)]);
    check(cow).deepEquals({'a': 1, 'b': 2, 'c': 3, 'd': 4});
    check(base).deepEquals({'a': 1, 'b': 2});
  });

  test('clear', () {
    final base = {'a': 1, 'b': 2, 'c': 3};
    final cow = create(base);
    cow.clear();
    check(cow).deepEquals({});
    check(base).deepEquals({'a': 1, 'b': 2, 'c': 3});
  });

  test('putIfAbsent', () {
    final base = {'a': 1, 'b': 2};
    final cow = create(base);
    cow.putIfAbsent('c', () => 3);
    check(cow).deepEquals({'a': 1, 'b': 2, 'c': 3});
    check(base).deepEquals({'a': 1, 'b': 2});
  });

  test('remove', () {
    final base = {'a': 1, 'b': 2, 'c': 3};
    final cow = create(base);
    cow.remove('b');
    check(cow).deepEquals({'a': 1, 'c': 3});
    check(base).deepEquals({'a': 1, 'b': 2, 'c': 3});
  });

  test('removeWhere', () {
    final base = {'a': 1, 'b': 2, 'c': 3};
    final cow = create(base);
    cow.removeWhere((key, value) => key == 'b');
    check(cow).deepEquals({'a': 1, 'c': 3});
    check(base).deepEquals({'a': 1, 'b': 2, 'c': 3});
  });

  test('update', () {
    final base = {'a': 1, 'b': 2};
    final cow = create(base);
    cow.update('a', (value) => value + 1);
    check(cow).deepEquals({'a': 2, 'b': 2});
    check(base).deepEquals({'a': 1, 'b': 2});
  });

  test('updateAll', () {
    final base = {'a': 1, 'b': 2};
    final cow = create(base);
    cow.updateAll((key, value) => value + 1);
    check(cow).deepEquals({'a': 2, 'b': 3});
    check(base).deepEquals({'a': 1, 'b': 2});
  });
}
