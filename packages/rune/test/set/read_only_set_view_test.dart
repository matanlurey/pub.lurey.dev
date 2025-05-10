import 'package:rune/rune.dart';

import '../prelude.dart';

void main() {
  test('cast', () {
    final numbers = ReadOnlySetView<num>({1, 2, 3});
    final integers = numbers.cast<int>();
    check(integers).deepEquals([1, 2, 3]);
  });

  test('contains', () {
    final set = ReadOnlySetView({1, 2, 3});
    check(set.contains(2)).isTrue();
    check(set.contains(4)).isFalse();
  });

  test('lookup', () {
    final set = ReadOnlySetView({1, 2, 3});
    check(set.lookup(2)).equals(2);
    check(set.lookup(4)).isNull();
  });

  test('containsAll', () {
    final set = ReadOnlySetView({1, 2, 3});
    check(set.containsAll({2, 3})).isTrue();
    check(set.containsAll({2, 4})).isFalse();
  });

  test('intersection', () {
    final set1 = ReadOnlySetView({1, 2, 3});
    final intersection = set1.intersection({2, 3, 4});
    check(intersection).deepEquals({2, 3});
  });

  test('difference', () {
    final set1 = ReadOnlySetView({1, 2, 3});
    final difference = set1.difference({2, 3, 4});
    check(difference).deepEquals({1});
  });

  test('union', () {
    final set1 = ReadOnlySetView({1, 2, 3});
    final union = set1.union({2, 3, 4});
    check(union).deepEquals({1, 2, 3, 4});
  });

  test('asSet', () {
    final set = ReadOnlySetView({1, 2, 3});
    final asSet = set.asSet();
    check(asSet).deepEquals({1, 2, 3});
    check(() => asSet.add(4)).throws<UnsupportedError>();
  });
}
