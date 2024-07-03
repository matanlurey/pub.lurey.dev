import '../../_prelude.dart';

/// Runs a test suite that checks that operations that shrink/grow fail.
void runFixedSizeTestSuite<T>(Grid<T> Function() getGrid, {required T fill}) {
  test('.clear should fail', () {
    final grid = getGrid();
    final cells = grid.traverse(rowMajor()).toList();
    check(grid.clear).throws<UnsupportedError>();
    check(grid.traverse(rowMajor())).deepEquals(cells);
  });

  test('<Rows>.insertAt should fail', () {
    final grid = getGrid();
    final cells = grid.traverse(rowMajor()).toList();
    check(
      () => grid.rows.insertAt(0, [
        for (var x = 0; x < grid.width; x++) fill,
      ]),
    ).throws<UnsupportedError>();
    check(grid.traverse(rowMajor())).deepEquals(cells);
  });

  test('<Rows>.removeAt should fail', () {
    final grid = getGrid();
    final cells = grid.traverse(rowMajor()).toList();
    check(() => grid.rows.removeAt(0)).throws<UnsupportedError>();
    check(grid.traverse(rowMajor())).deepEquals(cells);
  });

  test('<Columns>.insertAt should fail', () {
    final grid = getGrid();
    final cells = grid.traverse(rowMajor()).toList();
    check(
      () => grid.columns.insertAt(0, [
        for (var x = 0; x < grid.height; x++) fill,
      ]),
    ).throws<UnsupportedError>();
    check(grid.traverse(rowMajor())).deepEquals(cells);
  });

  test('<Columns>.removeAt should fail', () {
    final grid = getGrid();
    final cells = grid.traverse(rowMajor()).toList();
    check(() => grid.columns.removeAt(0)).throws<UnsupportedError>();
    check(grid.traverse(rowMajor())).deepEquals(cells);
  });
}
