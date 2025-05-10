import 'package:armory/armory.dart';

import '../prelude.dart';

void main() {
  test('cast', () {
    final numbers = ReadOnlyMapView<String, num>({'a': 1, 'b': 2, 'c': 3});
    final integers = numbers.cast<String, int>();
    check(integers.asMap()).deepEquals({'a': 1, 'b': 2, 'c': 3});
  });

  test('keys', () {
    final map = ReadOnlyMapView({'a': 1, 'b': 2, 'c': 3});
    check(map.keys).deepEquals(['a', 'b', 'c']);
  });

  test('values', () {
    final map = ReadOnlyMapView({'a': 1, 'b': 2, 'c': 3});
    check(map.values).deepEquals([1, 2, 3]);
  });

  test('entries', () {
    final map = ReadOnlyMapView({'a': 1, 'b': 2, 'c': 3});
    check(
      map.entries.map((e) => (e.key, e.value)),
    ).deepEquals([('a', 1), ('b', 2), ('c', 3)]);
  });

  test('map', () {
    final map = ReadOnlyMapView({'a': 1, 'b': 2, 'c': 3});
    check(
      map.map((key, value) => MapEntry(key.toUpperCase(), value * 2)),
    ).deepEquals({'A': 2, 'B': 4, 'C': 6});
  });

  test('forEach', () {
    final map = ReadOnlyMapView({'a': 1, 'b': 2, 'c': 3});
    final result = <String, int>{};
    map.forEach((key, value) {
      result[key] = value * 2;
    });
    check(result).deepEquals({'a': 2, 'b': 4, 'c': 6});
  });

  test('containsKey', () {
    final map = ReadOnlyMapView({'a': 1, 'b': 2, 'c': 3});
    check(map.containsKey('a')).isTrue();
    check(map.containsKey('z')).isFalse();
  });

  test('containsValue', () {
    final map = ReadOnlyMapView({'a': 1, 'b': 2, 'c': 3});
    check(map.containsValue(2)).isTrue();
    check(map.containsValue(99)).isFalse();
  });

  test('length', () {
    final map = ReadOnlyMapView({'a': 1, 'b': 2, 'c': 3});
    check(map.length).equals(3);
  });

  test('isEmpty', () {
    final emptyMap = ReadOnlyMapView({});
    check(emptyMap.isEmpty).isTrue();

    final nonEmptyMap = ReadOnlyMapView({'a': 1});
    check(nonEmptyMap.isEmpty).isFalse();
  });

  test('isNotEmpty', () {
    final emptyMap = ReadOnlyMapView({});
    check(emptyMap.isNotEmpty).isFalse();

    final nonEmptyMap = ReadOnlyMapView({'a': 1});
    check(nonEmptyMap.isNotEmpty).isTrue();
  });

  test('operator []', () {
    final map = ReadOnlyMapView({'a': 1, 'b': 2, 'c': 3});
    check(map['a']).equals(1);
    check(map['z']).isNull();
  });

  test('asMap', () {
    final map = ReadOnlyMapView({'a': 1, 'b': 2, 'c': 3});
    check(map.asMap()).deepEquals({'a': 1, 'b': 2, 'c': 3});
  });
}
