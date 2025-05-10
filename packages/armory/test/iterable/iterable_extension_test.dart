import 'package:armory/armory.dart';

import '../prelude.dart';

void main() {
  test('toUnmodifiableList', () {
    final list = [1, 2, 3];
    final unmodifiableList = list.toUnmodifiableList();
    check(unmodifiableList).deepEquals([1, 2, 3]);
    check(() => unmodifiableList[0] = 4).throws<UnsupportedError>();
  });

  test('toImmutableList', () {
    final list = [1, 2, 3];
    final immutableList = list.toImmutableList();
    check(immutableList).equals(ImmutableList([1, 2, 3]));
  });

  test('deepEquals', () {
    final list1 = [1, 2, 3];
    final list2 = [1, 2, 3];
    final list3 = [1, 2, 4];
    final list4 = [1, 2];

    check(list1.deepEquals(list2)).isTrue();
    check(list1.deepEquals(list3)).isFalse();
    check(list1.deepEquals(list4)).isFalse();
  });
}
