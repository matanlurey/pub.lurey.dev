import 'package:armory/armory.dart';

import '../prelude.dart';

void main() {
  test('deepEquals(Iterable)', () {
    final list = [1, 2, 3];
    final it1 = [1, 2, 3].map((e) => e);
    final it2 = [1, 2, 4].map((e) => e);
    final it3 = [1, 2].map((e) => e);
    check(list.deepEquals(it1)).isTrue();
    check(list.deepEquals(it2)).isFalse();
    check(list.deepEquals(it3)).isFalse();
  });

  test('deepEquals(List)', () {
    final list = [1, 2, 3];
    final list1 = [1, 2, 3];
    final list2 = [1, 2, 4];
    final list3 = [1, 2];
    check(list.deepEquals(list1)).isTrue();
    check(list.deepEquals(list2)).isFalse();
    check(list.deepEquals(list3)).isFalse();
  });
}
