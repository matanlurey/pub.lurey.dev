import '../../_prelude.dart';

/// Runs a test suite on the returned map from [create].
void testMap(Map<K, V> Function<K, V>(Map<K, V>) create) {
  test('cast', () {
    final map = create({'a': 1, 'b': 2});
    final casted = map.cast<String, num>();

    check(casted).not((i) => i.identicalTo(map));
    check(casted).deepEquals({'a': 1, 'b': 2});
  });

  test('containsValue', () {
    final map = create({'a': 1, 'b': 2});

    check(map.containsValue(2)).isTrue();
    check(map.containsValue(3)).isFalse();
  });

  test('containsKey', () {
    final map = create({'a': 1, 'b': 2});

    check(map.containsKey('b')).isTrue();
    check(map.containsKey('c')).isFalse();
  });

  test('operator []', () {
    final map = create({'a': 1, 'b': 2});

    check(map['a']).equals(1);
    check(map['b']).equals(2);
    check(map['c']).isNull();
  });

  test('entries', () {
    final map = create({'a': 1, 'b': 2});

    check(map.entries.first).has((e) => e.key, 'key').equals('a');
    check(map.entries.first).has((e) => e.value, 'value').equals(1);
    check(map.entries.last).has((e) => e.key, 'key').equals('b');
    check(map.entries.last).has((e) => e.value, 'value').equals(2);
  });

  test('map', () {
    final map = create({'a': 1, 'b': 2});
    final mapped = map.map(
      (key, value) => MapEntry(key.toUpperCase(), value * 2),
    );

    check(mapped).deepEquals({'A': 2, 'B': 4});
  });

  test('forEach', () {
    final map = create({'a': 1, 'b': 2});
    final result = <String, int>{};

    map.forEach((key, value) {
      result[key] = value * 2;
    });

    check(result).deepEquals({'a': 2, 'b': 4});
  });

  test('keys', () {
    final map = create({'a': 1, 'b': 2});

    check(map.keys).deepEquals(['a', 'b']);
  });

  test('values', () {
    final map = create({'a': 1, 'b': 2});

    check(map.values).deepEquals([1, 2]);
  });

  test('length', () {
    final map = create({'a': 1, 'b': 2});

    check(map.length).equals(2);
  });

  test('isEmpty', () {
    final map = create({});

    check(map.isEmpty).isTrue();
  });

  test('isNotEmpty', () {
    final map = create({'a': 1});

    check(map.isNotEmpty).isTrue();
  });

  test('operator []=', () {
    final map = create({'a': 1, 'b': 2});

    map['a'] = 3;

    check(map).deepEquals({'a': 3, 'b': 2});
  });

  test('addEntries', () {
    final map = create({'a': 1, 'b': 2});

    map.addEntries([MapEntry('c', 3), MapEntry('d', 4)]);

    check(map).deepEquals({'a': 1, 'b': 2, 'c': 3, 'd': 4});
  });

  test('update', () {
    final map = create({'a': 1, 'b': 2});

    map.update('a', (value) => value + 1, ifAbsent: () => 0);

    check(map).deepEquals({'a': 2, 'b': 2});
  });

  test('updateAll', () {
    final map = create({'a': 1, 'b': 2});

    map.updateAll((key, value) => value * 2);

    check(map).deepEquals({'a': 2, 'b': 4});
  });

  test('removeWhere', () {
    final map = create({'a': 1, 'b': 2, 'c': 3});

    map.removeWhere((key, value) => value > 1);

    check(map).deepEquals({'a': 1});
  });

  test('putIfAbsent', () {
    final map = create({'a': 1, 'b': 2});

    map.putIfAbsent('c', () => 3);

    check(map).deepEquals({'a': 1, 'b': 2, 'c': 3});
  });

  test('addAll', () {
    final map = create({'a': 1, 'b': 2});

    map.addAll({'c': 3, 'd': 4});

    check(map).deepEquals({'a': 1, 'b': 2, 'c': 3, 'd': 4});
  });

  test('remove', () {
    final map = create({'a': 1, 'b': 2});

    map.remove('a');

    check(map).deepEquals({'b': 2});
  });

  test('clear', () {
    final map = create({'a': 1, 'b': 2});

    map.clear();

    check(map).deepEquals({});
  });
}
