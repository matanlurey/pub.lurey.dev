import 'package:meta/meta.dart';

import '../prelude.dart';

void main() {
  test('should create an IndexMap with a stable iteration order', () {
    final map = IndexMap<String, int>();

    map['a'] = 1;
    map['b'] = 2;
    map['c'] = 3;

    check(map).containsKey('a');
    check(map).containsKey('b');
    check(map).containsKey('c');

    check(map).deepEquals({
      'a': 1,
      'b': 2,
      'c': 3,
    });
  });

  test('should create from another map', () {
    final map = IndexMap<String, int>.from({
      'a': 1,
      'b': 2,
      'c': 3,
    });

    check(map).deepEquals({
      'a': 1,
      'b': 2,
      'c': 3,
    });
  });

  test('should create from other entries', () {
    final map = IndexMap<String, int>.fromEntries([
      MapEntry('a', 1),
      MapEntry('b', 2),
      MapEntry('c', 3),
    ]);

    check(map).deepEquals({
      'a': 1,
      'b': 2,
      'c': 3,
    });
  });

  test('should not add, nor re-order, when an element exists', () {
    final map = IndexMap<String, int>();

    check(map['a'] = 1).equals(1);
    check(map['b'] = 2).equals(2);
    check(map['a'] = 3).equals(3);

    check(map).deepEquals({
      'a': 3,
      'b': 2,
    });
  });

  test('should provide entryAt access to map entries', () {
    final map = IndexMap<String, int>();

    map['a'] = 1;

    check(map.entryAt(0))
      ..has((p) => p.key, 'key').equals('a')
      ..has((p) => p.value, 'value').equals(1)
      ..has((p) => p.index, 'index').equals(0);
    check(() => map.entryAt(1)).throws<Error>();
  });

  test('should be able to set elements with setOrUpdate', () {
    final map = IndexMap<String, int>();

    map['a'] = 1;
    map['b'] = 2;
    map['c'] = 3;

    map.entryAt(0).setOrUpdate(4);
    map.entryAt(1).setOrUpdate(5);
    map.entryAt(2).setOrUpdate(6);

    check(map).deepEquals({
      'a': 4,
      'b': 5,
      'c': 6,
    });

    map.entryOf('d').setOrUpdate(7);

    check(map).deepEquals({
      'a': 4,
      'b': 5,
      'c': 6,
      'd': 7,
    });
  });

  test('remove swaps elements with the last element', () {
    final map = IndexMap<String, int>();

    map['a'] = 1;
    map['b'] = 2;
    map['c'] = 3;

    map.remove('a');

    check(map).deepEquals({
      'c': 3,
      'b': 2,
    });
  });

  test('should clear all elements', () {
    final map = IndexMap<String, int>();

    map['a'] = 1;
    map['b'] = 2;
    map['c'] = 3;

    map.clear();
    check(map).isEmpty();
  });

  test('sanity test rest of the Map API', () {
    final map = IndexMap<String, int>();

    check(map).isEmpty();

    map['a'] = 1;
    map['b'] = 2;
    check(map).isNotEmpty();

    final copy = IndexMap<String, int>();
    map.forEach((key, value) {
      copy[key] = value;
    });
    check(copy).deepEquals(map);

    map.putIfAbsent('a', () => 3);
    check(map['a']).equals(1);

    map.putIfAbsent('c', () => 3);
    check(map).deepEquals({
      'a': 1,
      'b': 2,
      'c': 3,
    });

    check(map.keys).deepEquals(['a', 'b', 'c']);
    check(map.values).deepEquals([1, 2, 3]);
    check(map.entries.map((m) => (m.key, m.value))).deepEquals([
      ('a', 1),
      ('b', 2),
      ('c', 3),
    ]);

    check(map).containsValue(1);
  });

  test('update does stuff', () {
    final map = IndexMap<String, int>();

    map['a'] = 1;
    map['b'] = 2;
    map['c'] = 3;

    map.update('a', (value) => value + 1, ifAbsent: () => 0);
    map.update('d', (value) => value + 1, ifAbsent: () => 0);

    check(map).deepEquals({
      'a': 2,
      'b': 2,
      'c': 3,
      'd': 0,
    });

    check(() => map.update('e', (value) => value + 1)).throws<Error>();

    map.updateAll((key, value) => value + 1);

    check(map).deepEquals({
      'a': 3,
      'b': 3,
      'c': 4,
      'd': 1,
    });
  });

  test('supports identity equality', () {
    final map = IndexMap<_BadHash, int>.identity();

    final a = _BadHash();
    final b = _BadHash();
    final c = _BadHash();

    map[a] = 1;
    map[b] = 2;
    map[c] = 3;

    check(map[a]).equals(1);
    check(map[b]).equals(2);
    check(map[c]).equals(3);

    final other = IndexMap<_BadHash, int>(
      equals: identical,
      hashCode: identityHashCode,
    );

    other[a] = 1;
    other[b] = 2;

    check(other[a]).equals(1);
    check(other[b]).equals(2);
  });

  test('supports custom equality', () {
    final map = IndexMap<String, int>(
      equals: (a, b) => a.toLowerCase() == b.toLowerCase(),
      hashCode: (e) => e.toLowerCase().hashCode,
    );

    map['a'] = 1;
    map['A'] = 2;
    map['b'] = 3;

    check(map).deepEquals({
      'a': 2,
      'b': 3,
    });
  });

  test('supports totally borked custom equality (no hashCode)', () {
    final map = IndexMap<String, int>(
      equals: (a, b) => false,
    );

    map['a'] = 1;
    map['b'] = 2;

    check(map).deepEquals({
      'a': 1,
      'b': 2,
    });
  });

  test('supports totally borked custom equality (no equals)', () {
    final map = IndexMap<String, int>(
      hashCode: (e) => 0,
    );

    map['a'] = 1;
    map['b'] = 2;

    check(map).deepEquals({
      'a': 1,
      'b': 2,
    });
  });

  test('entries have useful fields', () {
    final map = IndexMap<String, int>();
    map['a'] = 1;

    final a = map.entryOf('a');
    check(a.isPresent).isTrue();
    check(a.isAbsent).isFalse();
    check(a.putIfAbsent(() => 2)).equals(1);

    final b = map.entryOf('b');
    check(b.isPresent).isFalse();
    check(b.isAbsent).isTrue();
    check(b.index).equals(1);
    check(b.value).isNull();
    check(map.length).equals(1);
  });

  test('when an absent entry is inserted, it still works', () {
    final map = IndexMap<String, int>();

    final a = map.entryOf('a');
    a.setOrUpdate(1);
    check(map).deepEquals({'a': 1});

    a.setOrUpdate(2);
    check(map).deepEquals({'a': 2});

    a.putIfAbsent(() => 3);
    check(map).deepEquals({'a': 2});
  });
}

@immutable
final class _BadHash {
  @override
  int get hashCode => 0;

  @override
  bool operator ==(Object other) => other is _BadHash;
}
