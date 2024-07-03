import 'dart:collection';

import '../_prelude.dart';

import '../src/suites/mutable_growable.dart';
import '../src/suites/mutable_in_place.dart';
import '../src/suites/read.dart';

void main() {
  runGrowableTestSuite(SplayTreeGrid.fromRows);
  runReadOnlyTestSuite(SplayTreeGrid.fromRows);
  runMutableInPlaceTestSuite(SplayTreeGrid.fromRows);

  test('SplayTreeGrid.generate can return an empty grid', () {
    final grid = SplayTreeGrid.generate(0, 0, (x, y) => x + y, fill: 0);
    check(grid)
      ..width.equals(0)
      ..height.equals(0);
  });

  test('SplayTreeGrid.generate with a provided fill', () {
    final grid = SplayTreeGrid.generate(2, 2, (x, y) => x + y, fill: 0);
    check(grid).rows.deepEquals([
      [0, 1],
      [1, 2],
    ]);
  });

  test('SplayTreeGrid.from copies a grid', () {
    final grid = Grid.fromRows([
      [1, 2],
      [3, 4],
    ]);
    final copy = SplayTreeGrid.from(grid);
    check(copy.rows).deepEquals(grid.rows);
  });

  test('SplayTreeGrid.fromColumns can return an emtpy grid', () {
    final grid = SplayTreeGrid.fromColumns([]);
    check(grid)
      ..width.equals(0)
      ..height.equals(0);
  });

  test('SplayTreeGrid.fromColumns rewrites the layout', () {
    final grid = SplayTreeGrid.fromColumns([
      [1, 2],
      [3, 4],
    ]);
    check(grid).rows.deepEquals([
      [1, 3],
      [2, 4],
    ]);
  });

  test('SplayTreeGrid.fromRows throws if rows are not rectangular', () {
    check(
      () => SplayTreeGrid.fromRows([
        [1, 2],
        [3],
      ]),
    ).throws<ArgumentError>();
  });

  test('SplayTreeGrid.fromColumns throws if columns are not rectangular', () {
    check(
      () => SplayTreeGrid.fromColumns([
        [1, 2],
        [3],
      ]),
    ).throws<ArgumentError>();
  });

  test('SplayTreeGrid.filled returns a filled sparse grid', () {
    final grid = SplayTreeGrid.filled(2, 2, 0);
    check(grid).rows.deepEquals([
      [0, 0],
      [0, 0],
    ]);
    check(grid.toSparseMap()).isEmpty();
  });

  test('SplayTreeGrid.empty starts empty and can grow', () {
    final grid = SplayTreeGrid.empty(' ');
    check(grid).isEmpty.isTrue();

    grid.rows.insertAt(0, ['a', 'b']);
    check(grid).rows.deepEquals([
      ['a', 'b'],
    ]);
  });

  test('SplayTreeGrid.view from an existing SplayTreeMap with a fill', () {
    final grid = SplayTreeGrid.view(
      SplayTreeMap.of({
        0: 'a',
        1: 'b',
        3: 'c',
      }),
      width: 2,
      height: 2,
      fill: ' ',
    );
    check(grid).rows.deepEquals([
      ['a', 'b'],
      [' ', 'c'],
    ]);
    check(grid.toSparseMap()).deepEquals({
      0: 'a',
      1: 'b',
      3: 'c',
    });
  });

  test('SplayTreeGrid de-duplicates multiple fills', () {
    final grid = SplayTreeGrid.fromRows([
      ['a', ' '],
      [' ', ' '],
    ]);
    check(grid).rows.deepEquals([
      ['a', ' '],
      [' ', ' '],
    ]);
    check(grid.toSparseMap()).deepEquals({
      0: 'a',
    });
  });

  test('SplayTreeGrid fill is not inferred on an empty non-null grid', () {
    check(() => SplayTreeGrid<Object>.fromRows([])).throws<StateError>();
  });

  test('SplayTreeGrid can be travered efficiently', () {
    final grid = SplayTreeGrid.fromRows([
      [1, 2],
      [3, 4],
    ]);
    check(grid.traverse()).deepEquals([1, 2, 3, 4]);
  });
}
