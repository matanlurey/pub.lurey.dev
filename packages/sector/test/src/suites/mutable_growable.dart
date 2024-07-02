import '../../_prelude.dart';

/// Run a test suite that mutates the grid by adding/removing rows/columns.
void runGrowableTestSuite(
  Grid<T> Function<T>(Iterable<Iterable<T>> rows) fromRows,
) {
  test('clear should remove all cells', () {
    final grid = fromRows([
      [1, 2],
      [3, 4],
    ]);
    grid.clear();
    check(grid).isEmpty;
  });

  test('rows.insertAt should add a row', () {
    final grid = fromRows([
      [1, 2],
      [3, 4],
    ]);
    grid.rows.insertAt(0, [5, 6]);
    check(grid).rows.deepEquals([
      [5, 6],
      [1, 2],
      [3, 4],
    ]);
  });

  test('rows.removeAt should remove a row', () {
    final grid = fromRows([
      [1, 2],
      [3, 4],
    ]);
    grid.rows.removeAt(0);
    check(grid).rows.deepEquals([
      [3, 4],
    ]);
  });

  test('columns.insertAt should add a column', () {
    final grid = fromRows([
      [1],
      [2],
    ]);
    grid.columns.insertAt(0, [3, 4]);
    check(grid).rows.deepEquals([
      [3, 1],
      [4, 2],
    ]);
  });

  test('columns.removeAt should remove a column', () {
    final grid = fromRows([
      [1, 2],
      [3, 4],
    ]);
    grid.columns.removeAt(0);
    check(grid).rows.deepEquals([
      [2],
      [4],
    ]);
  });

  test('rows.insertAt can insert in an empty grid', () {
    final grid = fromRows([]);
    grid.rows.insertAt(0, [1, 2]);
    check(grid).rows.deepEquals([
      [1, 2],
    ]);
  });

  test('rows.removeAt can remove the last row', () {
    final grid = fromRows([
      [1, 2],
    ]);
    grid.rows.removeAt(0);
    check(grid).isEmpty;
  });

  test('columns.insertAt can insert in an empty grid', () {
    final grid = fromRows([]);
    grid.columns.insertAt(0, [1, 2]);
    check(grid).rows.deepEquals([
      [1],
      [2],
    ]);
  });

  test('columns.removeAt can remove the last column', () {
    final grid = fromRows([
      [1],
      [2],
    ]);
    grid.columns.removeAt(0);
    check(grid).isEmpty;
  });

  test('rows.insertAt should fail when the length is wrong', () {
    final grid = fromRows([
      [1, 2],
      [3, 4],
    ]);
    check(() => grid.rows.insertAt(0, [5])).throws<ArgumentError>();
  });

  test('columns.insertAt should fail when the length is wrong', () {
    final grid = fromRows([
      [1],
      [2],
    ]);
    check(() => grid.columns.insertAt(0, [3])).throws<ArgumentError>();
  });
}
