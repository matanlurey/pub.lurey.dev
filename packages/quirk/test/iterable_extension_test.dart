import 'package:quirk/quirk.dart';

import '_prelude.dart';
import 'src/inefficient_length_iterable.dart';

void main() {
  group('containsAllAtLeastOnce', () {
    test('returns true if other is empty', () {
      check([1, 2, 3].containsAllAtLeastOnce([])).isTrue();
    });

    test('returns true if other is a subset', () {
      check([1, 2, 3].containsAllAtLeastOnce([1, 2])).isTrue();
    });

    test('returns true if other is a subset with repeats', () {
      check([1, 2, 3].containsAllAtLeastOnce([1, 2, 2])).isTrue();
    });

    test('returns false if other is not a subset', () {
      check([1, 2, 3].containsAllAtLeastOnce([1, 4])).isFalse();
    });

    test('returns false if other is a superset', () {
      check([1, 2, 3].containsAllAtLeastOnce([1, 2, 3, 4])).isFalse();
    });
  });

  group('containsAllAtLeastOnceIndeterminate', () {
    test('returns true if other is identical', () {
      final list = IndeterminateIterable([1, 2, 3]);
      check([1, 2, 3].containsAllAtLeastOnceIndeterminate(list)).isTrue();
    });

    test('returns true if other is a subset', () {
      check(
        IndeterminateIterable([
          1,
          2,
          3,
        ]).containsAllAtLeastOnceIndeterminate(IndeterminateIterable([1, 2])),
      ).isTrue();
    });

    test('returns true if other is a subset with repeats', () {
      check(
        IndeterminateIterable(
          [1, 2, 3],
        ).containsAllAtLeastOnceIndeterminate(IndeterminateIterable([1, 2, 2])),
      ).isTrue();
    });

    test('returns false if other is not a subset', () {
      check(
        IndeterminateIterable([
          1,
          2,
          3,
        ]).containsAllAtLeastOnceIndeterminate(IndeterminateIterable([4, 5])),
      ).isFalse();
    });

    test('returns false if other is a superset', () {
      check(
        IndeterminateIterable([1, 2, 3]).containsAllAtLeastOnceIndeterminate(
          IndeterminateIterable([1, 2, 3, 4]),
        ),
      ).isFalse();
    });
  });

  group('containsAll', () {
    test('returns false if other list is larger', () {
      check([1, 2, 3].containsAll([1, 2, 3, 4])).isFalse();
    });

    test('returns false if other list is larger even with duplicates', () {
      check([1, 2, 3].containsAll([1, 1, 2, 2, 3, 3])).isFalse();
    });

    test('returns true if other list is identical', () {
      check([1, 2, 3].containsAll([1, 2, 3])).isTrue();
    });
  });

  group('containsAllIndeterminate', () {
    test('returns false if other list is larger', () {
      final list = IndeterminateIterable([1, 2, 3]);
      check(
        list.containsAllIndeterminate(IndeterminateIterable([1, 2, 3, 4])),
      ).isFalse();
    });

    test('returns false if other list is larger even with duplicates', () {
      final list = IndeterminateIterable([1, 2, 3]);
      check(
        list.containsAllIndeterminate(
          IndeterminateIterable([1, 1, 2, 2, 3, 3]),
        ),
      ).isFalse();
    });

    test('returns true if other list is identical', () {
      final list = IndeterminateIterable([1, 2, 3]);
      check(
        list.containsAllIndeterminate(IndeterminateIterable([1, 2, 3])),
      ).isTrue();
    });

    test('returns true if other list is identical with duplicates', () {
      final list = IndeterminateIterable([1, 1, 2, 3]);
      check(
        list.containsAllIndeterminate(IndeterminateIterable([1, 1])),
      ).isTrue();
    });
  });

  group('containsAllOrdered', () {
    test('returns false if other list is larger', () {
      check([1, 2, 3].containsAllOrdered([1, 2, 3, 4])).isFalse();
    });

    test('returns false if other list is larger even with duplicates', () {
      check([1, 2, 3].containsAllOrdered([1, 1, 2, 2, 3, 3])).isFalse();
    });

    test('returns true if other list is identical', () {
      check([1, 2, 3].containsAllOrdered([1, 2, 3])).isTrue();
    });

    test('returns false if the other is not ordered', () {
      check([1, 2, 3].containsAllOrdered([1, 3, 2])).isFalse();
    });

    test('returns true if this is larger but contains the other ordered', () {
      check([1, 2, 3, 4].containsAllOrdered([2, 3, 4])).isTrue();
    });
  });

  group('containsAllOrderedIndeterminate', () {
    test('returns false if other list is larger', () {
      final list = IndeterminateIterable([1, 2, 3]);
      check(
        list.containsAllOrderedIndeterminate(
          IndeterminateIterable([1, 2, 3, 4]),
        ),
      ).isFalse();
    });

    test('returns false if other list is larger even with duplicates', () {
      final list = IndeterminateIterable([1, 2, 3]);
      check(
        list.containsAllOrderedIndeterminate(
          IndeterminateIterable([1, 1, 2, 2, 3, 3]),
        ),
      ).isFalse();
    });

    test('returns true if other list is identical', () {
      final list = IndeterminateIterable([1, 2, 3]);
      check(
        list.containsAllOrderedIndeterminate(IndeterminateIterable([1, 2, 3])),
      ).isTrue();
    });

    test('returns false if the other is not ordered', () {
      final list = IndeterminateIterable([1, 2, 3]);
      check(
        list.containsAllOrderedIndeterminate(IndeterminateIterable([1, 3, 2])),
      ).isFalse();
    });
  });

  group('containsOnlyOrdered', () {
    test('returns false if other list is larger', () {
      check([1, 2, 3].containsOnlyOrdered([1, 2, 3, 4])).isFalse();
    });

    test('returns false if other list is larger even with duplicates', () {
      check([1, 2, 3].containsOnlyOrdered([1, 1, 2, 2, 3, 3])).isFalse();
    });

    test('returns true if other list is identical', () {
      check([1, 2, 3].containsOnlyOrdered([1, 2, 3])).isTrue();
    });

    test('returns false if the other is not ordered', () {
      check([1, 2, 3].containsOnlyOrdered([1, 3, 2])).isFalse();
    });

    test('returns false if this is larger but contains the other ordered', () {
      check([1, 2, 3].containsOnlyOrdered([2, 3])).isFalse();
    });
  });

  group('containsOnly', () {
    test('returns false if other list is larger', () {
      check([1, 2, 3].containsOnly([1, 2, 3, 4])).isFalse();
    });

    test('returns false if other list is larger even with duplicates', () {
      check([1, 2, 3].containsOnly([1, 1, 2, 2, 3, 3])).isFalse();
    });

    test('returns true if other list is identical', () {
      check([1, 2, 3].containsOnly([1, 2, 3])).isTrue();
    });

    test('returns true if the other is not ordered', () {
      check([1, 2, 3].containsOnly([1, 3, 2])).isTrue();
    });

    test('returns false if this is larger but contains the other ordered', () {
      check([1, 2, 3].containsOnly([2, 3])).isFalse();
    });
  });

  group('containsOnlyIndeterminate', () {
    test('returns false if other list is larger', () {
      final list = IndeterminateIterable([1, 2, 3]);
      check(
        list.containsOnlyOrderedIndeterminate(
          IndeterminateIterable([1, 2, 3, 4]),
        ),
      ).isFalse();
    });

    test('returns false if other list is larger even with duplicates', () {
      final list = IndeterminateIterable([1, 2, 3]);
      check(
        list.containsOnlyOrderedIndeterminate(
          IndeterminateIterable([1, 1, 2, 2, 3, 3]),
        ),
      ).isFalse();
    });

    test('returns true if other list is identical', () {
      final list = IndeterminateIterable([1, 2, 3]);
      check(
        list.containsOnlyOrderedIndeterminate(IndeterminateIterable([1, 2, 3])),
      ).isTrue();
    });

    test('returns false if the other is not ordered', () {
      final list = IndeterminateIterable([1, 2, 3]);
      check(
        list.containsOnlyOrderedIndeterminate(IndeterminateIterable([1, 3, 2])),
      ).isFalse();
    });
  });

  group('containsOnly', () {
    test('returns false if other list is larger', () {
      check([1, 2, 3].containsOnly([1, 2, 3, 4])).isFalse();
    });

    test('returns false if other list is larger even with duplicates', () {
      check([1, 2, 3].containsOnly([1, 1, 2, 2, 3, 3])).isFalse();
    });

    test('returns true if other list is identical', () {
      check([1, 2, 3].containsOnly([1, 2, 3])).isTrue();
    });

    test('returns true if the other is not ordered', () {
      check([1, 2, 3].containsOnly([1, 3, 2])).isTrue();
    });

    test('returns true if other is a set (optimization)', () {
      check([1, 2, 3].containsOnly({1, 2, 3})).isTrue();
    });

    test('returns false if other is a set (optimization)', () {
      check([1, 2, 3].containsOnly({1, 2, 3, 4})).isFalse();
    });
  });

  group('toSetRejectDuplicates', () {
    test('returns a set verifying there are no duplicates', () {
      check([1, 2, 3].toSetRejectDuplicates()).deepEquals({1, 2, 3});
    });

    test('throws an error if there are duplicates', () {
      check(() => [1, 2, 3, 1].toSetRejectDuplicates()).throws<ArgumentError>();
    });
  });

  group('toUnmodifiableSet', () {
    test('returns an unmodifiable set', () {
      final set = [1, 2, 3].toUnmodifiableSet();
      check(set).deepEquals({1, 2, 3});
      check(() => set.add(4)).throws<UnsupportedError>();
    });
  });

  group('toUnmodifiableSetRejectDuplicates', () {
    test('returns an unmodifiable set verifying there are no duplicates', () {
      final set = [1, 2, 3].toUnmodifiableSetRejectDuplicates();
      check(set).deepEquals({1, 2, 3});
      check(() => set.add(4)).throws<UnsupportedError>();
    });

    test('throws an error if there are duplicates', () {
      check(
        () => [1, 2, 3, 1].toUnmodifiableSetRejectDuplicates(),
      ).throws<ArgumentError>();
    });
  });

  group('IterableOrNullExtension', () {
    group('isNullOrEmpty', () {
      test('returns true if iterable is null', () {
        Iterable<int>? iterable;
        check(iterable.isNullOrEmpty).isTrue();
      });

      test('returns true if iterable is empty', () {
        // Intended.
        // ignore: unnecessary_nullable_for_final_variable_declarations
        final Iterable<int>? iterable = [];
        check(iterable.isNullOrEmpty).isTrue();
      });

      test('returns false if iterable is not empty', () {
        // Intended.
        // ignore: unnecessary_nullable_for_final_variable_declarations
        final Iterable<int>? iterable = [1, 2, 3];
        check(iterable.isNullOrEmpty).isFalse();
      });
    });

    group('orEmpty', () {
      test('returns an empty iterable if iterable is null', () {
        Iterable<int>? iterable;
        check(iterable.orEmpty).isEmpty();
      });

      test('returns the iterable if it is not null', () {
        // Intended.
        // ignore: unnecessary_nullable_for_final_variable_declarations
        final Iterable<int>? iterable = [1, 2, 3];
        check(iterable.orEmpty).deepEquals([1, 2, 3]);
      });
    });
  });
}
