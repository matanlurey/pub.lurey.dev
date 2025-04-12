import 'package:quirk/quirk.dart';

import '_prelude.dart';

void main() {
  group('containsAllAtLeastOnce', () {
    test('returns true if the same instance', () {
      final list = [1, 2, 3];
      check(list.containsAllAtLeastOnce(list)).isTrue();
    });

    test('returns true if elements contained at least once', () {
      final list = [1, 2, 3];
      final other = [2, 3];
      check(list.containsAllAtLeastOnce(other)).isTrue();
    });

    test('returns false if not elements contained at least once', () {
      final list = [1, 2, 3];
      final other = [2, 3, 4];
      check(list.containsAllAtLeastOnce(other)).isFalse();
    });
  });

  group('containsAll', () {
    test('returns true if the same instance', () {
      final list = [1, 2, 3];
      check(list.containsAll(list)).isTrue();
    });

    test('returns true if elements contained same number of times', () {
      final list = [1, 2, 3, 3];
      final other = [2, 3, 3];
      check(list.containsAll(other)).isTrue();
    });

    test('returns false if elements not contained same number of times', () {
      final list = [1, 2, 3, 3];
      final other = [2, 3, 3, 3];
      check(list.containsAll(other)).isFalse();
    });
  });

  group('containsOnly', () {
    test('returns true if the same instance', () {
      final list = [1, 2, 3];
      check(list.containsOnly(list)).isTrue();
    });

    test('returns false if elements are contained but extra exist', () {
      final list = [1, 2, 3, 3];
      final other = [2, 3, 3];
      check(list.containsOnly(other)).isFalse();
    });

    test('returns false if elements not contained same number of times', () {
      final list = [1, 2, 3, 3];
      final other = [2, 3, 3, 3];
      check(list.containsOnly(other)).isFalse();
    });

    test('returns false if elements not contained at least once', () {
      final list = [1, 2, 3];
      final other = [2, 3, 4];
      check(list.containsOnly(other)).isFalse();
    });

    group('set optimization', () {
      test('returns true if the same instance', () {
        final set = {1, 2, 3};
        check(set.containsOnly(set)).isTrue();
      });

      test('returns true if the same elements', () {
        final set = {1, 2, 3};
        check(set.containsOnly({...set})).isTrue();
      });

      test('returns false if elements are contained but extra exist', () {
        final list = [1, 2, 3, 3];
        final other = {2, 3};
        check(list.containsOnly(other)).isFalse();
      });

      test('returns false if elements not contained at least once', () {
        final list = [1, 2, 3];
        final other = {2, 3, 4};
        check(list.containsOnly(other)).isFalse();
      });
    });
  });

  group('containsOnlyUnordered', () {
    test('returns true if the same instance', () {
      final list = [1, 2, 3];
      check(list.containsOnlyUnordered(list)).isTrue();
    });

    test('returns false if elements are contained but extra exist', () {
      final list = [1, 2, 3, 3];
      final other = [2, 3, 3];
      check(list.containsOnlyUnordered(other)).isFalse();
    });

    test('returns false if elements not contained same number of times', () {
      final list = [1, 2, 3, 3];
      final other = [2, 3, 3, 3];
      check(list.containsOnlyUnordered(other)).isFalse();
    });

    test('returns false if elements not contained at least once', () {
      final list = [1, 2, 3];
      final other = [2, 3, 4];
      check(list.containsOnlyUnordered(other)).isFalse();
    });
  });

  group('toSetRejectDuplicates', () {
    test('returns a set with no duplicates', () {
      final list = [1, 2, 3];
      final set = list.toSetRejectDuplicates();
      check(set).deepEquals({1, 2, 3});
    });

    test('throws an error if duplicates exist', () {
      final list = [1, 2, 3, 3];
      check(list.toSetRejectDuplicates).throws<ArgumentError>();
    });
  });

  group('toUnmodifiableSet', () {
    test('returns an unmodifiable set', () {
      final list = [1, 2, 3];
      final set = list.toUnmodifiableSet();
      check(set).deepEquals({1, 2, 3});
      check(() => set.add(4)).throws<UnsupportedError>();
    });
  });

  group('toUnmodifiableSetRejectDuplicates', () {
    test('returns an unmodifiable set with no duplicates', () {
      final list = [1, 2, 3];
      final set = list.toUnmodifiableSetRejectDuplicates();
      check(set).deepEquals({1, 2, 3});
    });

    test('throws an error if duplicates exist', () {
      final list = [1, 2, 3, 3];
      check(list.toUnmodifiableSetRejectDuplicates).throws<ArgumentError>();
    });
  });
}
