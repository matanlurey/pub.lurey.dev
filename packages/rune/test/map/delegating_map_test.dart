import 'package:rune/rune.dart';

import '../prelude.dart';

void main() {
  const create = DelegatingMap.new;

  test('cast', () {
    final numbers = create<String, num>({'a': 1, 'b': 2, 'c': 3});
    final integers = numbers.cast<String, int>();
    check(integers).deepEquals({'a': 1, 'b': 2, 'c': 3});
  });

  test('operator []=', () {
    final map = create<String, int>({'a': 1, 'b': 2});
    map['c'] = 3;
    check(map).deepEquals({'a': 1, 'b': 2, 'c': 3});
  });

  test('addAll', () {
    final map = create<String, int>({'a': 1, 'b': 2});
    map.addAll({'c': 3, 'd': 4});
    check(map).deepEquals({'a': 1, 'b': 2, 'c': 3, 'd': 4});
  });

  test('addEntries', () {
    final map = create<String, int>({'a': 1, 'b': 2});
    map.addEntries([MapEntry('c', 3), MapEntry('d', 4)]);
    check(map).deepEquals({'a': 1, 'b': 2, 'c': 3, 'd': 4});
  });

  test('clear', () {
    final map = create<String, int>({'a': 1, 'b': 2, 'c': 3});
    map.clear();
    check(map).deepEquals({});
  });

  test('putIfAbsent', () {
    final map = create<String, int>({'a': 1, 'b': 2});
    map.putIfAbsent('c', () => 3);
    check(map).deepEquals({'a': 1, 'b': 2, 'c': 3});
  });

  test('remove', () {
    final map = create<String, int>({'a': 1, 'b': 2, 'c': 3});
    map.remove('b');
    check(map).deepEquals({'a': 1, 'c': 3});
  });

  test('removeWhere', () {
    final map = create<String, int>({'a': 1, 'b': 2, 'c': 3});
    map.removeWhere((key, value) => key == 'b');
    check(map).deepEquals({'a': 1, 'c': 3});
  });

  test('update', () {
    final map = create<String, int>({'a': 1, 'b': 2});
    map.update('a', (value) => value + 1);
    check(map).deepEquals({'a': 2, 'b': 2});
  });

  test('updateAll', () {
    final map = create<String, int>({'a': 1, 'b': 2});
    map.updateAll((key, value) => value + 1);
    check(map).deepEquals({'a': 2, 'b': 3});
  });
}
