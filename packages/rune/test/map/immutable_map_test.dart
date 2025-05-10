import 'package:rune/rune.dart';

import '../prelude.dart';

void main() {
  group('ImmutableMap', () {
    test('copies the original map', () {
      final original = {'a': 1, 'b': 2};
      final immutableMap = ImmutableMap(original);
      check(immutableMap.asMap()).deepEquals({'a': 1, 'b': 2});
    });

    test('fromEntries', () {
      final entries = [MapEntry('a', 1), MapEntry('b', 2)];
      final immutableMap = ImmutableMap.fromEntries(entries);
      check(immutableMap.asMap()).deepEquals({'a': 1, 'b': 2});
    });

    test('operator ==', () {
      final a = ImmutableMap({'a': 1, 'b': 2});
      final b = ImmutableMap({'a': 1, 'b': 2});
      check(a).equals(b);
    });

    test('hashCode', () {
      final a = ImmutableMap({'a': 1, 'b': 2});
      final b = ImmutableMap({'a': 1, 'b': 2});
      check(a.hashCode).equals(b.hashCode);
    });

    test('runtimeType', () {
      final map = ImmutableMap({'a': 1, 'b': 2});
      check(map.runtimeType).equals(ImmutableMap);
    });

    test('cast', () {
      final numbers = ImmutableMap<String, num>({'a': 1, 'b': 2});
      final integers = numbers.cast<String, int>();
      check(integers.asMap()).deepEquals({'a': 1, 'b': 2});
    });
  });

  group('ImmutableMap.unsafe', () {
    test('does not copy the original map', () {
      final original = {'a': 1, 'b': 2};
      final immutableMap = ImmutableMap.unsafe(original);
      check(immutableMap.asMap()).deepEquals({'a': 1, 'b': 2});
    });

    test('operator ==', () {
      final a = ImmutableMap.unsafe({'a': 1, 'b': 2});
      final b = ImmutableMap.unsafe({'a': 1, 'b': 2});
      check(a).equals(b);
    });

    test('hashCode', () {
      final a = ImmutableMap.unsafe({'a': 1, 'b': 2});
      final b = ImmutableMap.unsafe({'a': 1, 'b': 2});
      check(a.hashCode).equals(b.hashCode);
    });

    test('runtimeType', () {
      final map = ImmutableMap.unsafe({'a': 1, 'b': 2});
      check(map.runtimeType).equals(ImmutableMap);
    });
  });
}
