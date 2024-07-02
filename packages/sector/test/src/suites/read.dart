import '../../_prelude.dart';

/// Run a test suite that only reads from the grid.
void runReadOnlyTestSuite(
  Grid<T> Function<T>(
    Iterable<Iterable<T>> rows,
  ) fromRows,
) {
  test('contains should return true if the cell if found', () {
    final grid = fromRows([
      [1, 2],
      [3, 4],
    ]);
    check(grid.contains(2)).isTrue();
  });

  test('contains should return false if the cell is not found', () {
    final grid = fromRows([
      [1, 2],
      [3, 4],
    ]);
    check(grid.contains(5)).isFalse();
  });

  test('subGrid should return a sub-grid', () {
    final grid = fromRows([
      [1, 2, 3],
      [4, 5, 6],
    ]);
    final subGrid = grid.subGrid(left: 1, top: 0, width: 2, height: 2);
    check(subGrid).rows.deepEquals([
      [2, 3],
      [5, 6],
    ]);
  });

  test('subGrid should return a sub-grid with a default width/height', () {
    final grid = fromRows([
      [1, 2, 3],
      [4, 5, 6],
    ]);
    final subGrid = grid.subGrid(left: 1, top: 0);
    check(subGrid).rows.deepEquals([
      [2, 3],
      [5, 6],
    ]);
  });

  test('subGrid throws if the sub-grid is out of bounds', () {
    final grid = fromRows([
      [1, 2, 3],
      [4, 5, 6],
    ]);
    check(
      () => grid.subGrid(left: 2, top: 0, width: 2, height: 2),
    ).throws<RangeError>();
    check(
      () => grid.subGrid(left: 0, top: 1, width: 2, height: 2),
    ).throws<RangeError>();
  });

  test('asSubGrid should return a sub-grid', () {
    final grid = fromRows([
      [1, 2, 3],
      [4, 5, 6],
    ]);
    final subGrid = grid.asSubGrid(left: 1, top: 0, width: 2, height: 2);
    check(subGrid).rows.deepEquals([
      [2, 3],
      [5, 6],
    ]);
  });

  test('asSubGrid should return a sub-grid with a default width/height', () {
    final grid = fromRows([
      [1, 2, 3],
      [4, 5, 6],
    ]);
    final subGrid = grid.asSubGrid(left: 1, top: 0);
    check(subGrid).rows.deepEquals([
      [2, 3],
      [5, 6],
    ]);
  });

  test('asSubGrid throws if the sub-grid is out of bounds', () {
    final grid = fromRows([
      [1, 2, 3],
      [4, 5, 6],
    ]);
    check(
      () => grid.asSubGrid(left: 2, top: 0, width: 2, height: 2),
    ).throws<RangeError>();
    check(
      () => grid.asSubGrid(left: 0, top: 1, width: 2, height: 2),
    ).throws<RangeError>();
  });

  test('rows should return the rows', () {
    final grid = fromRows([
      [1, 2],
      [3, 4],
    ]);
    check(grid.rows).deepEquals([
      [1, 2],
      [3, 4],
    ]);
  });

  test('columns should return the columns', () {
    final grid = fromRows([
      [1, 2],
      [3, 4],
    ]);
    check(grid.columns).deepEquals([
      [1, 3],
      [2, 4],
    ]);
  });

  test('should return a cute toString()', () {
    final grid = fromRows([
      [1, 2, 3],
      [4, 5, 6],
    ]);
    check(grid.toString()).equals(
      '┌───────┐\n'
      '│ 1 2 3 │\n'
      '│ 4 5 6 │\n'
      '└───────┘',
    );
  });
}
