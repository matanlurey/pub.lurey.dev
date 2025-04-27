import 'package:quirk/quirk.dart';

import '../../_prelude.dart';

void main() {
  group('containsAtLeastOnce', () {
    test('<Set>', () {
      final set = {1, 2, 3};
      check(set.containsAtLeastOnce([1, 2, 3])).isTrue();
    });

    test('every element contained once', () {
      final list = [1, 2, 3];
      check(list.containsAtLeastOnce([1, 2])).isTrue();
    });

    test('every element contained with duplicates', () {
      final list = [1, 2, 3];
      check(list.containsAtLeastOnce([1, 2, 2])).isTrue();
    });

    test('not every element contained', () {
      final list = [1, 2, 3];
      check(list.containsAtLeastOnce([1, 2, 4])).isFalse();
    });

    test('empty list', () {
      final list = <int>[];
      check(list.containsAtLeastOnce([1, 2, 3])).isFalse();
    });
  });

  group('orderedEquals', () {
    test('same elements in same order', () {
      final list = [1, 2, 3];
      check(list.orderedEquals([1, 2, 3])).isTrue();
    });

    test('same elements in different order', () {
      final list = [1, 2, 3];
      check(list.orderedEquals([3, 2, 1])).isFalse();
    });

    test('different elements', () {
      final list = [1, 2, 3];
      check(list.orderedEquals([4, 5, 6])).isFalse();
    });

    test('empty list', () {
      final list = <int>[];
      check(list.orderedEquals([])).isTrue();
    });
  });

  group('unorderedEquals', () {
    test('<Set>', () {
      final set = {1, 2, 3};
      check(set.unorderedEquals([1, 2, 3])).isTrue();
    });

    test('same elements in same order', () {
      final list = [1, 2, 3];
      check(list.unorderedEquals([1, 2, 3])).isTrue();
    });

    test('same elements in different order', () {
      final list = [1, 2, 3];
      check(list.unorderedEquals([3, 2, 1])).isTrue();
    });

    test('different elements', () {
      final list = [1, 2, 3];
      check(list.unorderedEquals([4, 5, 6])).isFalse();
    });

    test('empty list', () {
      final list = <int>[];
      check(list.unorderedEquals([])).isTrue();
    });
  });

  test('toUnmodifiableList', () {
    final list = [1, 2, 3].toUnmodifiableList();

    check(list).deepEquals([1, 2, 3]);
    check(() => list.add(4)).throws<UnsupportedError>();
  });

  test('toUnmodifiableSet', () {
    final set = [1, 2, 3].toUnmodifiableSet();

    check(set).deepEquals({1, 2, 3});
    check(() => set.add(4)).throws<UnsupportedError>();
  });

  group('isNullOrEmpty', () {
    test('null', () {
      final list = null as List<int>?;
      check(list.isNullOrEmpty).isTrue();
    });

    test('empty', () {
      final list = <int>[];
      check(list.isNullOrEmpty).isTrue();
    });

    test('not empty', () {
      final list = [1, 2, 3];
      check(list.isNullOrEmpty).isFalse();
    });
  });

  group('orEmpty', () {
    test('null', () {
      final list = null as Iterable<int>?;
      check(list.orEmpty).deepEquals([]);
    });

    test('not null', () {
      final list = [1, 2, 3] as Iterable<int>;
      check(list.orEmpty).deepEquals([1, 2, 3]);
    });
  });
}
