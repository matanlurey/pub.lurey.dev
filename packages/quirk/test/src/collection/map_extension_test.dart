import 'package:quirk/quirk.dart';

import '../../_prelude.dart';

void main() {
  group('orEmpty', () {
    test('null', () {
      final map = null as Map<int, String>?;
      check(map.orEmpty).deepEquals({});
    });

    test('not null', () {
      final map = {1: 'a', 2: 'b', 3: 'c'};
      check(map.orEmpty).deepEquals({1: 'a', 2: 'b', 3: 'c'});
    });
  });
}
