import 'package:quirk/quirk.dart';

import '../../_prelude.dart';

// Most methods are tested in the DelegatingMap tests.
void main() {
  test('asMap', () {
    final map = ReadOnlyMap.view({'a': 1, 'b': 2, 'c': 3});

    final view = map.asMap();
    check(view).deepEquals(view);
    check(() => view['d'] = 4).throws<UnsupportedError>();
  });

  test('cast', () {
    final map = ReadOnlyMap.view({'a': 1, 'b': 2, 'c': 3});
    final view = map.cast<String, num>();

    check(view.asMap()).deepEquals({'a': 1, 'b': 2, 'c': 3});
  });
}
