import 'package:checks/checks.dart';
import 'package:quirk/quirk.dart';
import 'package:test/test.dart';

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
}
