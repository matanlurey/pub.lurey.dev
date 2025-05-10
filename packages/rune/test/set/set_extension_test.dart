import 'package:rune/rune.dart';

import '../prelude.dart';

void main() {
  test('deepEquals(Iterable)', () {
    final set = {1, 2, 3};
    final it1 = {1, 2, 3}.map((e) => e);
    final it2 = {1, 2, 4}.map((e) => e);
    final it3 = {1, 2}.map((e) => e);
    check(set.deepEquals(it1)).isTrue();
    check(set.deepEquals(it2)).isFalse();
    check(set.deepEquals(it3)).isFalse();
  });

  test('deepEquals(Set)', () {
    final set = {1, 2, 3};
    final set1 = {1, 2, 3};
    final set2 = {1, 2, 4};
    final set3 = {1, 2};
    check(set.deepEquals(set1)).isTrue();
    check(set.deepEquals(set2)).isFalse();
    check(set.deepEquals(set3)).isFalse();
  });
}
