import 'package:rune/rune.dart';

import '../prelude.dart';

void main() {
  group('ImmutableSet', () {
    test('copies the original set', () {
      final original = {1, 2, 3};
      final immutableSet = ImmutableSet(original);
      check(immutableSet).deepEquals([1, 2, 3]);
    });

    test('operator ==', () {
      final a = ImmutableSet({1, 2, 3});
      final b = ImmutableSet({1, 2, 3});
      check(a).equals(b);
    });

    test('hashCode', () {
      final a = ImmutableSet({1, 2, 3});
      final b = ImmutableSet({1, 2, 3});
      check(a.hashCode).equals(b.hashCode);
    });

    test('runtimeType', () {
      final set = ImmutableSet({1, 2, 3});
      check(set.runtimeType).equals(ImmutableSet);
    });

    test('cast', () {
      final numbers = ImmutableSet<num>({1, 2, 3});
      final integers = numbers.cast<int>();
      check(integers).deepEquals([1, 2, 3]);
    });
  });

  group('ImmutableSet.unsafe', () {
    test('does not copy the original set', () {
      final original = {1, 2, 3};
      final immutableSet = ImmutableSet.unsafe(original);
      check(immutableSet).deepEquals([1, 2, 3]);
    });

    test('operator ==', () {
      final a = ImmutableSet.unsafe({1, 2, 3});
      final b = ImmutableSet.unsafe({1, 2, 3});
      check(a).equals(b);
    });

    test('hashCode', () {
      final a = ImmutableSet.unsafe({1, 2, 3});
      final b = ImmutableSet.unsafe({1, 2, 3});
      check(a.hashCode).equals(b.hashCode);
    });

    test('runtimeType', () {
      final set = ImmutableSet.unsafe({1, 2, 3});
      check(set.runtimeType).equals(ImmutableSet);
    });
  });
}
