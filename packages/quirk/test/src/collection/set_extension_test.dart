import 'package:quirk/quirk.dart';

import '../../_prelude.dart';

void main() {
  group('orEmpty', () {
    test('null', () {
      final set = null as Set<int>?;
      check(set.orEmpty).deepEquals({});
    });

    test('not null', () {
      final set = {1, 2, 3};
      check(set.orEmpty).deepEquals({1, 2, 3});
    });
  });

  test('asUnmodifiable', () {
    final set = {1, 2, 3};
    final unmodifiableSet = set.asUnmodifiable();

    check(unmodifiableSet).deepEquals({1, 2, 3});
    check(() => unmodifiableSet.add(4)).throws<UnsupportedError>();
    check(() => unmodifiableSet.remove(1)).throws<UnsupportedError>();
  });
}
