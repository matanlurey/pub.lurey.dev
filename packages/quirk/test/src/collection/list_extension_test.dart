import 'package:quirk/quirk.dart';

import '../../_prelude.dart';

void main() {
  group('orEmpty', () {
    test('null', () {
      final list = null as List<int>?;
      check(list.orEmpty).deepEquals([]);
    });

    test('not null', () {
      final list = [1, 2, 3];
      check(list.orEmpty).deepEquals([1, 2, 3]);
    });
  });

  test('asUnmodifiable', () {
    final list = [1, 2, 3];
    final unmodifiableList = list.asUnmodifiable();
    check(unmodifiableList).deepEquals([1, 2, 3]);
    check(() => unmodifiableList.add(4)).throws<UnsupportedError>();
  });
}
