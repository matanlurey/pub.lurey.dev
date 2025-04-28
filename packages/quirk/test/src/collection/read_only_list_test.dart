import 'package:quirk/quirk.dart';

import '../../_prelude.dart';

// Most methods are tested in the DelegatingList tests.
void main() {
  test('asList', () {
    final list = ReadOnlyList.view([1, 2, 3]);
    final view = list.asList();

    check(view).deepEquals(view);
    check(() => view.add(4)).throws<UnsupportedError>();
  });

  test('cast', () {
    final list = ReadOnlyList.view([1, 2, 3]);
    final view = list.cast<num>();

    check(view).deepEquals(view);
  });
}
