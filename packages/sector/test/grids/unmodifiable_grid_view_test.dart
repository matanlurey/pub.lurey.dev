import '../_prelude.dart';

import '../src/suites/read.dart';
import '../src/suites/unmodifiable.dart';

void main() {
  runUnmodifiableTestSuite(
    () => UnmodifiableGridView(Grid.filled(2, 2, 0)),
    fill: 1,
  );

  runReadOnlyTestSuite(
    <T>(
      Iterable<Iterable<T>> rows,
    ) =>
        UnmodifiableGridView(Grid.fromRows(rows)),
  );
}
