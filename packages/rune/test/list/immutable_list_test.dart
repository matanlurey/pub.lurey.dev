import 'package:rune/rune.dart';

import '../prelude.dart';

void main() {
  group('ImmutableList', () {
    test('copies the original list', () {
      final original = [1, 2, 3];
      final immutableList = ImmutableList(original);
      check(immutableList).deepEquals(original);
    });

    test('operator ==', () {
      final a = ImmutableList([1, 2, 3]);
      final b = ImmutableList([1, 2, 3]);
      check(a).equals(b);
    });

    test('hashCode', () {
      final a = ImmutableList([1, 2, 3]);
      final b = ImmutableList([1, 2, 3]);
      check(a.hashCode).equals(b.hashCode);
    });

    test('runtimeType', () {
      final list = ImmutableList([1, 2, 3]);
      check(list.runtimeType).equals(ImmutableList);
    });

    test('cast', () {
      final numbers = ImmutableList<num>([1, 2, 3]);
      final integers = numbers.cast<int>();
      check(integers).deepEquals([1, 2, 3]);
    });
  });

  group('ImmutableList.unsafe', () {
    test('does not copy the original list', () {
      final original = [1, 2, 3];
      final immutableList = ImmutableList.unsafe(original);
      check(immutableList).deepEquals(original);
    });

    test('operator ==', () {
      final a = ImmutableList.unsafe([1, 2, 3]);
      final b = ImmutableList.unsafe([1, 2, 3]);
      check(a).equals(b);
    });

    test('hashCode', () {
      final a = ImmutableList.unsafe([1, 2, 3]);
      final b = ImmutableList.unsafe([1, 2, 3]);
      check(a.hashCode).equals(b.hashCode);
    });

    test('runtimeType', () {
      final list = ImmutableList.unsafe([1, 2, 3]);
      check(list.runtimeType).equals(ImmutableList);
    });
  });
}
