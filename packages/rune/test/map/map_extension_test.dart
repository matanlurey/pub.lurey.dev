import 'package:rune/rune.dart';

import '../prelude.dart';

void main() {
  test('deepEquals(Map)', () {
    final map = {'a': 1, 'b': 2, 'c': 3};
    final map1 = {'a': 1, 'b': 2, 'c': 3};
    final map2 = {'a': 1, 'b': 2, 'c': 4};
    final map3 = {'a': 1, 'b': 2};
    check(map.deepEquals(map1)).isTrue();
    check(map.deepEquals(map2)).isFalse();
    check(map.deepEquals(map3)).isFalse();
  });
}
