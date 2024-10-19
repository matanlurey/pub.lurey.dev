import 'package:iota/iota.dart';

import '_prelude.dart';

void main() {
  test('does nothing', () {
    check(noop).returnsNormally();
  });
}
