import '../../_prelude.dart';

import 'mutable_fixed.dart';

/// Runs a test suite that checks that operations that mutate fail.
void runUnmodifiableTestSuite<T>(
  Grid<T> Function() getGrid, {
  required T fill,
}) {
  runFixedSizeTestSuite(getGrid, fill: fill);

  test('.set should fail', () {
    final grid = getGrid();
    final cells = grid.traverse().toList();
    check(() => grid.set(0, 0, fill)).throws<UnsupportedError>();
    check(grid.traverse()).deepEquals(cells);
  });

  test('.setUnchecked should fail', () {
    final grid = getGrid();
    final cells = grid.traverse().toList();
    check(() => grid.setUnchecked(0, 0, fill)).throws<UnsupportedError>();
    check(grid.traverse()).deepEquals(cells);
  });
}
