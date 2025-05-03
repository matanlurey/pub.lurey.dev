import 'package:quirk/quirk.dart';

import '../../_prelude.dart';

void main() {
  group('orEmpty', () {
    test('null', () {
      final map = null as Map<int, String>?;
      check(map.orEmpty).deepEquals({});
    });

    test('not null', () {
      final map = {1: 'a', 2: 'b', 3: 'c'};
      check(map.orEmpty).deepEquals({1: 'a', 2: 'b', 3: 'c'});
    });
  });

  test('asUnmodifiable', () {
    final map = {1: 'a', 2: 'b', 3: 'c'};
    final unmodifiableMap = map.asUnmodifiable();

    check(unmodifiableMap).deepEquals({1: 'a', 2: 'b', 3: 'c'});
    check(() => unmodifiableMap[1] = 'd').throws<UnsupportedError>();
    check(() => unmodifiableMap.remove(1)).throws<UnsupportedError>();
  });

  group('orderedEquals', () {
    test('equal maps', () {
      final map1 = {1: 'a', 2: 'b', 3: 'c'};
      final map2 = {1: 'a', 2: 'b', 3: 'c'};
      check(map1.orderedEquals(map2)).isTrue();
    });

    test('unequal maps', () {
      final map1 = {1: 'a', 2: 'b', 3: 'c'};
      final map2 = {1: 'a', 2: 'b', 4: 'd'};
      check(map1.orderedEquals(map2)).isFalse();
    });
  });

  group('unorderedEquals', () {
    test('equal maps', () {
      final map1 = {1: 'a', 2: 'b', 3: 'c'};
      final map2 = {3: 'c', 2: 'b', 1: 'a'};
      check(map1.unorderedEquals(map2)).isTrue();
    });

    test('unequal maps', () {
      final map1 = {1: 'a', 2: 'b', 3: 'c'};
      final map2 = {3: 'c', 2: 'b', 4: 'd'};
      check(map1.unorderedEquals(map2)).isFalse();
    });
  });
}
