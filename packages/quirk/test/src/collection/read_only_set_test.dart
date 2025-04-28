import 'package:quirk/quirk.dart';

import '../../_prelude.dart';

// Most methods are tested in the DelegatingList tests.
void main() {
  test('asSet', () {
    final set = ReadOnlySet.view({1, 2, 3});
    final view = set.asSet();

    check(view).deepEquals(view);
    check(() => view.add(4)).throws<UnsupportedError>();
  });

  test('cast', () {
    final set = ReadOnlySet.view({1, 2, 3});
    final view = set.cast<num>();

    check(view).deepEquals(view);
  });
}
