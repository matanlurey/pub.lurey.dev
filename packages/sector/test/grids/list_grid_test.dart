import '../_prelude.dart';

import '../src/suites/mutable_growable.dart';
import '../src/suites/mutable_in_place.dart';
import '../src/suites/read.dart';

void main() {
  runGrowableTestSuite(Grid.fromRows);
  runReadOnlyTestSuite(Grid.fromRows);
  runMutableInPlaceTestSuite(Grid.fromRows);

  test('List.generate can return an empty grid', () {
    final grid = Grid.generate(0, 0, (x, y) => x + y);
    check(grid)
      ..width.equals(0)
      ..height.equals(0);
  });

  test('ListGrid.from copies a grid', () {
    final grid = Grid.fromRows([
      [1, 2],
      [3, 4],
    ]);
    final copy = Grid.from(grid);
    check(copy.rows).deepEquals(grid.rows);
  });

  test('ListGrid.fromCells can return an empty grid', () {
    final grid = Grid.fromCells([], width: 0);
    check(grid)
      ..width.equals(0)
      ..height.equals(0);
  });

  test('ListGrid.fromCells throws if the cells are not rectangular', () {
    check(() => Grid.fromCells([1, 2, 3], width: 2)).throws<ArgumentError>();
  });

  test('ListGrid.fromCells stores in row-major order', () {
    final grid = Grid.fromCells([1, 2, 3, 4], width: 2);
    check(grid).rows.deepEquals([
      [1, 2],
      [3, 4],
    ]);
  });

  test('ListGrid.fromColumns can return an emtpu grid', () {
    final grid = Grid.fromColumns([]);
    check(grid)
      ..width.equals(0)
      ..height.equals(0);
  });

  test('ListGrid.fromColumns rewrites the layout', () {
    final grid = Grid.fromColumns([
      [1, 2],
      [3, 4],
    ]);
    check(grid).rows.deepEquals([
      [1, 3],
      [2, 4],
    ]);
  });

  test('ListGrid.view can return an empty grid', () {
    final grid = ListGrid.view([], width: 0);
    check(grid)
      ..width.equals(0)
      ..height.equals(0);
  });

  test('ListGrid.view throws if the cells are not rectangular', () {
    check(() => ListGrid.view([1, 2, 3], width: 2)).throws<ArgumentError>();
  });

  test('ListGrid.view stores in row-major order', () {
    final grid = ListGrid.view([1, 2, 3, 4], width: 2);
    check(grid).rows.deepEquals([
      [1, 2],
      [3, 4],
    ]);
  });

  test('ListGrid.fromRows throws if the rows are not rectangular', () {
    check(
      () => Grid.fromRows([
        [1, 2],
        [3],
      ]),
    ).throws<ArgumentError>();
  });

  test('ListGrid.fromColumns throws if the columns are not rectangular', () {
    check(
      () => Grid.fromColumns([
        [1, 2],
        [3],
      ]),
    ).throws<ArgumentError>();
  });
}
