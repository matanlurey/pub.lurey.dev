import 'package:quirk/quirk.dart';

import '_prelude.dart';
import 'src/inefficient_length_iterable.dart';

void main() {
  group('containsAllKeys', () {
    test('returns true if other is empty', () {
      check({'a': 1, 'b': 2}.containsAllKeys([])).isTrue();
    });

    test('returns true if other is a subset', () {
      check({'a': 1, 'b': 2}.containsAllKeys(['a'])).isTrue();
    });

    test('returns false if other is not a subset', () {
      check({'a': 1, 'b': 2}.containsAllKeys(['c'])).isFalse();
    });

    test('returns false if other is a superset', () {
      check({'a': 1, 'b': 2}.containsAllKeys(['a', 'b', 'c'])).isFalse();
    });
  });

  group('containsAllKeysIndeterminate', () {
    test('returns true if other is identical', () {
      check(
        {
          'a': 1,
          'b': 2,
        }.containsAllKeysIndeterminate(IndeterminateIterable(['a', 'b'])),
      ).isTrue();
    });

    test('returns true if other is a subset', () {
      check(
        {
          'a': 1,
          'b': 2,
        }.containsAllKeysIndeterminate(IndeterminateIterable(['a'])),
      ).isTrue();
    });

    test('returns false if other is not a subset', () {
      check(
        {
          'a': 1,
          'b': 2,
        }.containsAllKeysIndeterminate(IndeterminateIterable(['c'])),
      ).isFalse();
    });

    test('returns false if other is a superset', () {
      check(
        {
          'a': 1,
          'b': 2,
        }.containsAllKeysIndeterminate(IndeterminateIterable(['a', 'b', 'c'])),
      ).isFalse();
    });
  });

  group('containsOnlyKeys', () {
    test('returns false if other is empty', () {
      check({'a': 1, 'b': 2}.containsOnlyKeys([])).isFalse();
    });

    test('returns false if other is a subset', () {
      check({'a': 1, 'b': 2}.containsOnlyKeys(['a'])).isFalse();
    });

    test('returns false if other is not a subset', () {
      check({'a': 1, 'b': 2}.containsOnlyKeys(['c'])).isFalse();
    });

    test('returns true if other is a superset', () {
      check({'a': 1, 'b': 2}.containsOnlyKeys(['a', 'b'])).isTrue();
    });

    test('returns false if other is a superset with different values', () {
      check({'a': 1, 'b': 2}.containsOnlyKeys(['a', 'b', 'c'])).isFalse();
    });
  });

  group('containsOnlyKeysIndeterminate', () {
    test('returns false if other is empty', () {
      check(
        {
          'a': 1,
          'b': 2,
        }.containsOnlyKeysIndeterminate(IndeterminateIterable([])),
      ).isFalse();
    });

    test('returns false if other is a subset', () {
      check(
        {
          'a': 1,
          'b': 2,
        }.containsOnlyKeysIndeterminate(IndeterminateIterable(['a'])),
      ).isFalse();
    });

    test('returns false if other is not a subset', () {
      check(
        {
          'a': 1,
          'b': 2,
        }.containsOnlyKeysIndeterminate(IndeterminateIterable(['c'])),
      ).isFalse();
    });

    test('returns true if other is a superset', () {
      check(
        {
          'a': 1,
          'b': 2,
        }.containsOnlyKeysIndeterminate(IndeterminateIterable(['a', 'b'])),
      ).isTrue();
    });

    test('returns false if other is a superset with different values', () {
      check(
        {
          'a': 1,
          'b': 2,
        }.containsOnlyKeysIndeterminate(IndeterminateIterable(['a', 'b', 'c'])),
      ).isFalse();
    });
  });

  group('containsAllEntries', () {
    test('returns true if other is empty', () {
      check({'a': 1, 'b': 2}.containsAllEntries([])).isTrue();
    });

    test('returns true if other is a subset', () {
      check({'a': 1, 'b': 2}.containsAllEntries([MapEntry('a', 1)])).isTrue();
    });

    test('returns false if other is not a subset', () {
      check({'a': 1, 'b': 2}.containsAllEntries([MapEntry('c', 3)])).isFalse();
    });

    test('returns true if other is exactly the same', () {
      check(
        {
          'a': 1,
          'b': 2,
        }.containsAllEntries([MapEntry('a', 1), MapEntry('b', 2)]),
      ).isTrue();
    });

    test('returns false if other is a superset', () {
      check(
        {'a': 1, 'b': 2}.containsAllEntries([
          MapEntry('a', 1),
          MapEntry('b', 2),
          MapEntry('c', 3),
        ]),
      ).isFalse();
    });
  });

  group('containsAllEntriesIndeterminate', () {
    test('returns true if other is identical', () {
      check(
        {'a': 1, 'b': 2}.containsAllEntriesIndeterminate(
          IndeterminateIterable([MapEntry('a', 1), MapEntry('b', 2)]),
        ),
      ).isTrue();
    });

    test('returns true if other is a subset', () {
      check(
        {'a': 1, 'b': 2}.containsAllEntriesIndeterminate(
          IndeterminateIterable([MapEntry('a', 1)]),
        ),
      ).isTrue();
    });

    test('returns false if other is not a subset', () {
      check(
        {'a': 1, 'b': 2}.containsAllEntriesIndeterminate(
          IndeterminateIterable([MapEntry('c', 3)]),
        ),
      ).isFalse();
    });

    test('returns true if other is exactly the same', () {
      check(
        {'a': 1, 'b': 2}.containsAllEntriesIndeterminate(
          IndeterminateIterable([MapEntry('a', 1), MapEntry('b', 2)]),
        ),
      ).isTrue();
    });

    test('returns false if other is a superset', () {
      check(
        {'a': 1, 'b': 2}.containsAllEntriesIndeterminate(
          IndeterminateIterable([
            MapEntry('a', 1),
            MapEntry('b', 2),
            MapEntry('c', 3),
          ]),
        ),
      ).isFalse();
    });
  });

  group('containsOnlyEntries', () {
    test('returns false if other is empty', () {
      check({'a': 1, 'b': 2}.containsOnlyEntries([])).isFalse();
    });

    test('returns false if other is a subset', () {
      check({'a': 1, 'b': 2}.containsOnlyEntries([MapEntry('a', 1)])).isFalse();
    });

    test('returns false if other is not a subset', () {
      check({'a': 1, 'b': 2}.containsOnlyEntries([MapEntry('c', 3)])).isFalse();
    });

    test('returns true if other is exactly the same', () {
      check(
        {
          'a': 1,
          'b': 2,
        }.containsOnlyEntries([MapEntry('a', 1), MapEntry('b', 2)]),
      ).isTrue();
    });

    test('returns false if other is a superset', () {
      check(
        {'a': 1, 'b': 2}.containsOnlyEntries([
          MapEntry('a', 1),
          MapEntry('b', 2),
          MapEntry('c', 3),
        ]),
      ).isFalse();
    });
  });

  group('containsOnlyEntriesIndeterminate', () {
    test('returns false if other is empty', () {
      check(
        {
          'a': 1,
          'b': 2,
        }.containsOnlyEntriesIndeterminate(IndeterminateIterable([])),
      ).isFalse();
    });

    test('returns false if other is a subset', () {
      check(
        {'a': 1, 'b': 2}.containsOnlyEntriesIndeterminate(
          IndeterminateIterable([MapEntry('a', 1)]),
        ),
      ).isFalse();
    });

    test('returns false if other is not a subset', () {
      check(
        {'a': 1, 'b': 2}.containsOnlyEntriesIndeterminate(
          IndeterminateIterable([MapEntry('c', 3)]),
        ),
      ).isFalse();
    });

    test('returns true if other is exactly the same', () {
      check(
        {'a': 1, 'b': 2}.containsOnlyEntriesIndeterminate(
          IndeterminateIterable([MapEntry('a', 1), MapEntry('b', 2)]),
        ),
      ).isTrue();
    });

    test('returns false if other is a superset', () {
      check(
        {'a': 1, 'b': 2}.containsOnlyEntriesIndeterminate(
          IndeterminateIterable([
            MapEntry('a', 1),
            MapEntry('b', 2),
            MapEntry('c', 3),
          ]),
        ),
      ).isFalse();
    });
  });

  group('IterableOrNullExtension', () {
    group('isNullOrEmpty', () {
      test('returns true if null', () {
        Map<String, int>? map;
        check(map.isNullOrEmpty).isTrue();
      });

      test('returns true if empty', () {
        // Intentional.
        // ignore: unnecessary_nullable_for_final_variable_declarations
        final Map<String, int>? map = {};
        check(map.isNullOrEmpty).isTrue();
      });

      test('returns false if not empty', () {
        // Intentional.
        // ignore: unnecessary_nullable_for_final_variable_declarations
        final Map<String, int>? map = {'a': 1};
        check(map.isNullOrEmpty).isFalse();
      });
    });

    group('orEmpty', () {
      test('returns empty map if null', () {
        Map<String, int>? map;
        check(map.orEmpty).deepEquals({});
      });

      test('returns empty map if empty', () {
        // Intentional.
        // ignore: unnecessary_nullable_for_final_variable_declarations
        final Map<String, int>? map = {};
        check(map.orEmpty).deepEquals({});
      });

      test('returns original map if not empty', () {
        // Intentional.
        // ignore: unnecessary_nullable_for_final_variable_declarations
        final Map<String, int>? map = {'a': 1};
        check(map.orEmpty).deepEquals({'a': 1});
      });
    });
  });
}
