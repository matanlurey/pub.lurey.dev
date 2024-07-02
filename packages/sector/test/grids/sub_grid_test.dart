import '../_prelude.dart';

import '../src/suites/mutable_in_place.dart';
import '../src/suites/read.dart';

void main() {
  Grid<T> subGridViewFromRows<T>(Iterable<Iterable<T>> rows) {
    final grid = Grid.fromRows(rows);
    return grid.asSubGrid();
  }

  runMutableInPlaceTestSuite(subGridViewFromRows);
  runReadOnlyTestSuite(subGridViewFromRows);

  group('SubGrid mutations', () {
    test('clear is OK if the view is complete', () {
      final grid = Grid.fromRows([
        [1, 2],
        [3, 4],
      ]);
      final view = grid.asSubGrid(left: 0, top: 0, width: 2, height: 2);
      view.clear();
      check(grid.rows).deepEquals([]);
    });

    test('clear throws if the view is incomplete', () {
      final grid = Grid.fromRows([
        [1, 2],
        [3, 4],
      ]);
      final view = grid.asSubGrid(left: 0, top: 0, width: 1, height: 1);
      check(view.clear).throws<UnsupportedError>();
    });

    test('set and get delegates to the underlying grid', () {
      final grid = Grid.fromRows([
        [1, 2],
        [3, 4],
      ]);
      final view = grid.asSubGrid(left: 0, top: 0, width: 2, height: 2);
      view.set(0, 0, 5);
      check(view.get(0, 0)).equals(5);
      check(grid).rows.deepEquals([
        [5, 2],
        [3, 4],
      ]);
    });

    test('cannot insert into a partial grid', () {
      final grid = Grid.fromRows([
        [1, 2],
        [3, 4],
      ]);
      final view = grid.asSubGrid(left: 0, top: 0, width: 1, height: 1);
      check(() => view.rows.insertAt(0, [5])).throws<UnsupportedError>();
      check(() => view.columns.insertAt(0, [5])).throws<UnsupportedError>();
    });

    test('cannot remove from a partial grid', () {
      final grid = Grid.fromRows([
        [1, 2],
        [3, 4],
      ]);
      final view = grid.asSubGrid(left: 0, top: 0, width: 1, height: 1);
      check(() => view.rows.removeAt(0)).throws<UnsupportedError>();
      check(() => view.columns.removeAt(0)).throws<UnsupportedError>();
    });

    test('can insert a row into a full-width grid', () {
      final grid = Grid.fromRows([
        [1, 2],
        [3, 4],
      ]);
      final view = grid.asSubGrid(left: 0, top: 0, width: 2, height: 2);
      view.rows.insertAt(0, [5, 6]);
      check(grid).rows.deepEquals([
        [5, 6],
        [1, 2],
        [3, 4],
      ]);
    });

    test('can insert a column into a full-height grid', () {
      final grid = Grid.fromRows([
        [1, 2],
        [3, 4],
      ]);
      final view = grid.asSubGrid(left: 0, top: 0, width: 2, height: 2);
      view.columns.insertAt(0, [5, 6]);
      check(grid).rows.deepEquals([
        [5, 1, 2],
        [6, 3, 4],
      ]);
    });

    test('can remove a row from a full-width grid', () {
      final grid = Grid.fromRows([
        [1, 2],
        [3, 4],
        [5, 6],
      ]);
      final view = grid.asSubGrid(left: 0, top: 0, width: 2, height: 3);
      view.rows.removeAt(0);
      check(grid).rows.deepEquals([
        [3, 4],
        [5, 6],
      ]);
    });

    test('can remove a column from a full-height grid', () {
      final grid = Grid.fromRows([
        [1, 2, 3],
        [4, 5, 6],
      ]);
      final view = grid.asSubGrid(left: 0, top: 0, width: 3, height: 2);
      view.columns.removeAt(0);
      check(grid).rows.deepEquals([
        [2, 3],
        [5, 6],
      ]);
    });
  });
}
