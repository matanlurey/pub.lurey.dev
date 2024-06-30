import 'package:sector/sector.dart';

import '_prelude.dart';

void runResizableGridTests(
  String testing, {
  required Grid<int> Function(
    int width,
    int height,
    int fill,
  ) filled,
  required Grid<int> Function(
    int width,
    int height,
    int Function(int x, int y),
  ) generate,
  required Grid<int> Function(
    List<int> cells, {
    required int width,
  }) fromCells,
  required Grid<int> Function(
    List<List<int>> rows,
  ) fromRows,
  required Grid<int> Function(
    List<List<int>> columns,
  ) fromColumns,
  required Grid<int> Function(
    Grid<int> grid,
  ) from,
  required Grid<int> Function() empty,
}) {
  test('<$testing>.clear should remove all elements', () {
    final grid = filled(3, 3, 0);
    grid.clear();
    check(grid).isEmpty.isTrue();
  });

  group('<$Rows>.insert', () {
    test('should insert a row at the index', () {
      final grid = filled(3, 3, 0);
      grid.rows.insertAt(1, [1, 2, 3]);
      check(grid).rows.deepEquals([
        [0, 0, 0],
        [1, 2, 3],
        [0, 0, 0],
        [0, 0, 0],
      ]);
    });

    test('should insert a row at the end', () {
      final grid = filled(3, 3, 0);
      grid.rows.insertAt(3, [1, 2, 3]);
      check(grid).rows.deepEquals([
        [0, 0, 0],
        [0, 0, 0],
        [0, 0, 0],
        [1, 2, 3],
      ]);
    });

    test('should insert a row at the beginning', () {
      final grid = filled(3, 3, 0);
      grid.rows.insertAt(0, [1, 2, 3]);
      check(grid).rows.deepEquals([
        [1, 2, 3],
        [0, 0, 0],
        [0, 0, 0],
        [0, 0, 0],
      ]);
    });

    test('should increase the height of the grid', () {
      final grid = filled(3, 3, 0);
      grid.rows.insertAt(3, [1, 2, 3]);
      check(grid).height.equals(4);
    });

    test('should throw if the index is out of bounds', () {
      final grid = filled(3, 3, 0);
      check(() => grid.rows.insertAt(4, [1, 2, 3])).throws<RangeError>();
    });

    test('should throw if the row has the wrong length', () {
      final grid = filled(3, 3, 0);
      check(() => grid.rows.insertAt(1, [1, 2])).throws<ArgumentError>();
    });
  });

  group('<$Rows>.insertFirst', () {
    test('should insert a row at the beginning', () {
      final grid = filled(3, 3, 0);
      grid.rows.insertFirst([1, 2, 3]);
      check(grid).rows.deepEquals([
        [1, 2, 3],
        [0, 0, 0],
        [0, 0, 0],
        [0, 0, 0],
      ]);
    });

    test('should succeed if the grid is empty', () {
      final grid = Grid<int>.empty();
      grid.rows.insertFirst([1, 2, 3]);
      check(grid).rows.deepEquals([
        [1, 2, 3],
      ]);
    });
  });

  group('<$Rows>.insertLast', () {
    test('should insert a row at the end', () {
      final grid = filled(3, 3, 0);
      grid.rows.insertLast([1, 2, 3]);
      check(grid).rows.deepEquals([
        [0, 0, 0],
        [0, 0, 0],
        [0, 0, 0],
        [1, 2, 3],
      ]);
    });

    test('should succeed if the grid is empty', () {
      final grid = Grid<int>.empty();
      grid.rows.insertLast([1, 2, 3]);
      check(grid).rows.deepEquals([
        [1, 2, 3],
      ]);
    });
  });

  group('<$Rows>.remove', () {
    test('should remove a row at the index', () {
      final grid = filled(3, 3, 0);
      grid.rows.removeAt(1);
      check(grid).rows.deepEquals([
        [0, 0, 0],
        [0, 0, 0],
      ]);
    });

    test('should decrease the height of the grid', () {
      final grid = filled(3, 3, 0);
      grid.rows.removeAt(1);
      check(grid).height.equals(2);
    });

    test('should throw if the index is out of bounds', () {
      final grid = filled(3, 3, 0);
      check(() => grid.rows.removeAt(3)).throws<RangeError>();
    });

    test('should throw if the grid is empty', () {
      final grid = Grid<int>.empty();
      check(() => grid.rows.removeAt(0)).throws<RangeError>();
    });
  });

  group('<$Rows>.removeFirst', () {
    test('should remove the first row', () {
      final grid = filled(3, 3, 0);
      grid.rows.removeFirst();
      check(grid).rows.deepEquals([
        [0, 0, 0],
        [0, 0, 0],
      ]);
    });

    test('should decrease the height of the grid', () {
      final grid = filled(3, 3, 0);
      grid.rows.removeFirst();
      check(grid).height.equals(2);
    });

    test('should throw if the grid is empty', () {
      final grid = Grid<int>.empty();
      check(() => grid.rows.removeFirst()).throws<RangeError>();
    });
  });

  group('<$Rows>.removeLast', () {
    test('should remove the last row', () {
      final grid = filled(3, 3, 0);
      grid.rows.removeLast();
      check(grid).rows.deepEquals([
        [0, 0, 0],
        [0, 0, 0],
      ]);
    });

    test('should decrease the height of the grid', () {
      final grid = filled(3, 3, 0);
      grid.rows.removeLast();
      check(grid).height.equals(2);
    });

    test('should throw if the grid is empty', () {
      final grid = Grid<int>.empty();
      check(() => grid.rows.removeLast()).throws<RangeError>();
    });
  });

  group('<$Columns>.insert', () {
    test('should insert a column at the index', () {
      final grid = filled(3, 3, 0);
      grid.columns.insertAt(1, [1, 2, 3]);
      check(grid).rows.deepEquals([
        [0, 1, 0, 0],
        [0, 2, 0, 0],
        [0, 3, 0, 0],
      ]);
    });

    test('should insert a column at the end', () {
      final grid = filled(3, 3, 0);
      grid.columns.insertAt(3, [1, 2, 3]);
      check(grid).rows.deepEquals([
        [0, 0, 0, 1],
        [0, 0, 0, 2],
        [0, 0, 0, 3],
      ]);
    });

    test('should insert a column at the beginning', () {
      final grid = filled(3, 3, 0);
      grid.columns.insertAt(0, [1, 2, 3]);
      check(grid).rows.deepEquals([
        [1, 0, 0, 0],
        [2, 0, 0, 0],
        [3, 0, 0, 0],
      ]);
    });

    test('should increase the width of the grid', () {
      final grid = filled(3, 3, 0);
      grid.columns.insertAt(3, [1, 2, 3]);
      check(grid).width.equals(4);
    });

    test('should throw if the index is out of bounds', () {
      final grid = filled(3, 3, 0);
      check(() => grid.columns.insertAt(4, [1, 2, 3])).throws<RangeError>();
    });

    test('should throw if the column has the wrong length', () {
      final grid = filled(3, 3, 0);
      check(() => grid.columns.insertAt(1, [1, 2])).throws<ArgumentError>();
    });
  });

  group('<$Columns>.insertFirst', () {
    test('should insert a column at the beginning', () {
      final grid = filled(3, 3, 0);
      grid.columns.insertFirst([1, 2, 3]);
      check(grid).rows.deepEquals([
        [1, 0, 0, 0],
        [2, 0, 0, 0],
        [3, 0, 0, 0],
      ]);
    });

    test('should succeed if the grid is empty', () {
      final grid = Grid<int>.empty();
      grid.columns.insertFirst([1, 2, 3]);
      check(grid).rows.deepEquals([
        [1],
        [2],
        [3],
      ]);
    });
  });

  group('<$Columns>.insertLast', () {
    test('should insert a column at the end', () {
      final grid = filled(3, 3, 0);
      grid.columns.insertLast([1, 2, 3]);
      check(grid).rows.deepEquals([
        [0, 0, 0, 1],
        [0, 0, 0, 2],
        [0, 0, 0, 3],
      ]);
    });

    test('should succeed if the grid is empty', () {
      final grid = Grid<int>.empty();
      grid.columns.insertLast([1, 2, 3]);
      check(grid).rows.deepEquals([
        [1],
        [2],
        [3],
      ]);
    });
  });

  group('<$Columns>.remove', () {
    test('should remove a column at the index', () {
      final grid = filled(3, 3, 0);
      grid.columns.removeAt(1);
      check(grid).rows.deepEquals([
        [0, 0],
        [0, 0],
        [0, 0],
      ]);
    });

    test('should decrease the width of the grid', () {
      final grid = filled(3, 3, 0);
      grid.columns.removeAt(1);
      check(grid).width.equals(2);
    });

    test('should throw if the index is out of bounds', () {
      final grid = filled(3, 3, 0);
      check(() => grid.columns.removeAt(3)).throws<RangeError>();
    });

    test('should throw if the grid is empty', () {
      final grid = Grid<int>.empty();
      check(() => grid.columns.removeAt(0)).throws<RangeError>();
    });
  });

  group('<$Columns>.removeFirst', () {
    test('should remove the first column', () {
      final grid = filled(3, 3, 0);
      grid.columns.removeFirst();
      check(grid).rows.deepEquals([
        [0, 0],
        [0, 0],
        [0, 0],
      ]);
    });

    test('should decrease the width of the grid', () {
      final grid = filled(3, 3, 0);
      grid.columns.removeFirst();
      check(grid).width.equals(2);
    });

    test('should throw if the grid is empty', () {
      final grid = Grid<int>.empty();
      check(() => grid.columns.removeFirst()).throws<RangeError>();
    });
  });

  group('<$Columns>.removeLast', () {
    test('should remove the last column', () {
      final grid = filled(3, 3, 0);
      grid.columns.removeLast();
      check(grid).rows.deepEquals([
        [0, 0],
        [0, 0],
        [0, 0],
      ]);
    });

    test('should decrease the width of the grid', () {
      final grid = filled(3, 3, 0);
      grid.columns.removeLast();
      check(grid).width.equals(2);
    });

    test('should throw if the grid is empty', () {
      final grid = Grid<int>.empty();
      check(() => grid.columns.removeLast()).throws<RangeError>();
    });
  });

  test('clear works if the area is the full original area', () {
    final grid = filled(3, 3, 0);
    final subGrid = grid.asSubGrid();
    subGrid.clear();
    check(grid).isEmpty.isTrue();
  });

  test('clear throws if the area is not the full original area', () {
    final grid = filled(3, 3, 0);
    final subGrid = grid.asSubGrid(left: 1, top: 1, width: 2, height: 2);
    check(subGrid.clear).throws<UnsupportedError>();
  });

  test('succeeds when inserting a row in a sub-grid with full width', () {
    final grid = filled(3, 3, 0);
    check(grid).rows.deepEquals([
      [0, 0, 0],
      [0, 0, 0],
      [0, 0, 0],
    ]);

    final subGrid = grid.asSubGrid(left: 0, top: 1, width: 3, height: 2);
    check(subGrid).rows.deepEquals([
      [0, 0, 0],
      [0, 0, 0],
    ]);

    subGrid.rows.insertAt(0, [1, 2, 3]);
    check(subGrid).rows.deepEquals([
      [1, 2, 3],
      [0, 0, 0],
      [0, 0, 0],
    ]);

    check(grid).rows.deepEquals([
      [0, 0, 0],
      [1, 2, 3],
      [0, 0, 0],
      [0, 0, 0],
    ]);
  });

  test('succeeds when inserting a column in a sub-grid with full height', () {
    final grid = filled(3, 3, 0);
    check(grid).rows.deepEquals([
      [0, 0, 0],
      [0, 0, 0],
      [0, 0, 0],
    ]);

    final subGrid = grid.asSubGrid(left: 1, top: 0, width: 2, height: 3);
    check(subGrid).rows.deepEquals([
      [0, 0],
      [0, 0],
      [0, 0],
    ]);

    subGrid.columns.insertAt(0, [1, 2, 3]);
    check(subGrid).rows.deepEquals([
      [1, 0, 0],
      [2, 0, 0],
      [3, 0, 0],
    ]);

    check(grid).rows.deepEquals([
      [0, 1, 0, 0],
      [0, 2, 0, 0],
      [0, 3, 0, 0],
    ]);
  });

  test('succeeds when removing a row in a sub-grid with full width', () {
    final grid = filled(3, 3, 0);
    check(grid).rows.deepEquals([
      [0, 0, 0],
      [0, 0, 0],
      [0, 0, 0],
    ]);

    final subGrid = grid.asSubGrid(left: 0, top: 1, width: 3, height: 2);
    check(subGrid).rows.deepEquals([
      [0, 0, 0],
      [0, 0, 0],
    ]);

    subGrid.rows.removeAt(0);
    check(subGrid).rows.deepEquals([
      [0, 0, 0],
    ]);
  });

  test('succeeds when removing a column in a sub-grid with full height', () {
    final grid = filled(3, 3, 0);
    check(grid).rows.deepEquals([
      [0, 0, 0],
      [0, 0, 0],
      [0, 0, 0],
    ]);

    final subGrid = grid.asSubGrid(left: 1, top: 0, width: 2, height: 3);
    check(subGrid).rows.deepEquals([
      [0, 0],
      [0, 0],
      [0, 0],
    ]);

    subGrid.columns.removeAt(0);
    check(subGrid).rows.deepEquals([
      [0],
      [0],
      [0],
    ]);

    check(grid).rows.deepEquals([
      [0, 0],
      [0, 0],
      [0, 0],
    ]);
  });
}
