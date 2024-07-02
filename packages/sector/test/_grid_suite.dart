import 'package:sector/sector.dart';

import '_prelude.dart';

void runGridTests(
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
  group('$testing.filled', () {
    test('should throw if width is negative', () {
      check(() => filled(-1, 0, 0)).throws<RangeError>();
    });

    test('should throw if height is negative', () {
      check(() => filled(0, -1, 0)).throws<RangeError>();
    });

    test('should return an empty grid if width is 0', () {
      check(filled(0, 3, 0))
        ..isEmpty.isTrue()
        ..width.equals(0)
        ..height.equals(0);
    });

    test('should return an empty grid if height is 0', () {
      check(filled(3, 0, 0))
        ..isEmpty.isTrue()
        ..width.equals(0)
        ..height.equals(0);
    });

    test('should return a filled grid', () {
      final grid = filled(3, 3, 0);
      check(grid).rows.deepEquals([
        [0, 0, 0],
        [0, 0, 0],
        [0, 0, 0],
      ]);
    });
  });

  group('$testing.generate', () {
    test('should throw if width is negative', () {
      check(() => generate(-1, 0, (x, y) => x + y)).throws<RangeError>();
    });

    test('should throw if height is negative', () {
      check(() => generate(0, -1, (x, y) => x + y)).throws<RangeError>();
    });

    test('should return an empty grid if width is 0', () {
      check(generate(0, 3, (x, y) => x + y))
        ..isEmpty.isTrue()
        ..width.equals(0)
        ..height.equals(0);
    });

    test('should return an empty grid if height is 0', () {
      check(generate(3, 0, (x, y) => x + y))
        ..isEmpty.isTrue()
        ..width.equals(0)
        ..height.equals(0);
    });

    test('should return a generated grid', () {
      final grid = generate(3, 3, (x, y) => x + y);
      check(grid).rows.deepEquals([
        [0, 1, 2],
        [1, 2, 3],
        [2, 3, 4],
      ]);
    });
  });

  test('$testing.from should copy an existing grid', () {
    final grid = filled(3, 3, 0);
    final copy = from(grid);
    check(copy).rows.deepEquals(grid.rows);
  });

  group('$testing.fromCells', () {
    test('should throw if width is negative', () {
      check(
        () => fromCells([1, 2, 3, 4], width: -1),
      ).throws<RangeError>();
    });

    test('should throw if width is not a multiple of the cells', () {
      check(
        () => fromCells([1, 2, 3, 4], width: 3),
      ).throws<ArgumentError>();
    });

    test('should return an empty grid if width is 0', () {
      check(fromCells([1, 2, 3, 4], width: 0))
        ..isEmpty.isTrue()
        ..width.equals(0)
        ..height.equals(0);
    });

    test('should return a grid from cells', () {
      final grid = fromCells([1, 2, 3, 4], width: 2);
      check(grid).rows.deepEquals([
        [1, 2],
        [3, 4],
      ]);
    });
  });

  group('$testing.fromRows', () {
    test('should return an empty grid if rows is empty', () {
      check(fromRows([]))
        ..isEmpty.isTrue()
        ..width.equals(0)
        ..height.equals(0);
    });

    test('should throw if rows have different lengths', () {
      check(
        () => fromRows([
          [1, 2],
          [3],
        ]),
      ).throws<ArgumentError>();
    });

    test('should return a grid from rows', () {
      final grid = fromRows([
        [1, 2],
        [3, 4],
      ]);
      check(grid).rows.deepEquals([
        [1, 2],
        [3, 4],
      ]);
    });
  });

  group('$testing.fromColumns', () {
    test('should return an empty grid if columns is empty', () {
      check(fromColumns([]))
        ..isEmpty.isTrue()
        ..width.equals(0)
        ..height.equals(0);
    });

    test('should throw if columns have different lengths', () {
      check(
        () => fromColumns([
          [1, 2],
          [3],
        ]),
      ).throws<ArgumentError>();
    });

    test('should return a grid from columns', () {
      final grid = fromColumns([
        [1, 2],
        [3, 4],
      ]);
      check(grid).rows.deepEquals([
        [1, 3],
        [2, 4],
      ]);
    });
  });

  test('$testing.empty returns an emtpy grid', () {
    final grid = empty();
    check(grid)
      ..isEmpty.isTrue()
      ..width.equals(0)
      ..height.equals(0);
  });

  group('<$testing>.contains', () {
    test('should return false if the grid is empty', () {
      final grid = empty();
      check(grid).containsXY(0, 0).isFalse();
    });

    test('should return false if the coordinates are out of bounds', () {
      final grid = filled(3, 3, 0);
      check(grid).containsXY(3, 3).isFalse();
    });

    test('should return true if the coordinates are in bounds', () {
      final grid = filled(3, 3, 0);
      check(grid).containsXY(1, 1).isTrue();
    });

    test('should return false if the bounds are out of bounds', () {
      final grid = filled(3, 3, 0);
      check(grid).containsXYWH(3, 3, 1, 1).isFalse();
    });

    test('should return true if the bounds are in bounds', () {
      final grid = filled(3, 3, 0);
      check(grid).containsXYWH(1, 1, 1, 1).isTrue();
    });

    test('should return if an element exists', () {
      final grid = filled(3, 3, 0);
      check(grid.contains(0)).isTrue();
    });
  });

  group('<$testing>.get', () {
    test('should throw if the grid is empty', () {
      final grid = empty();
      check(() => grid.get(0, 0)).throws<RangeError>();
    });

    test('should throw if the coordinates are out of bounds', () {
      final grid = filled(3, 3, 0);
      check(() => grid.get(3, 3)).throws<RangeError>();
    });

    test('should return the element at the coordinates', () {
      final grid = filled(3, 3, 0);
      check(grid).at(1, 1).equals(0);
    });
  });

  group('<$testing>.set', () {
    test('should throw if the grid is empty', () {
      final grid = Grid<int>.empty();
      check(() => grid.set(0, 0, 0)).throws<RangeError>();
    });

    test('should throw if the coordinates are out of bounds', () {
      final grid = filled(3, 3, 0);
      check(() => grid.set(3, 3, 0)).throws<RangeError>();
    });

    test('should set the element at the coordinates', () {
      final grid = filled(3, 3, 0);
      grid.set(1, 1, 1);
      check(grid).at(1, 1).equals(1);
    });
  });

  group('<$testing>.rows', () {
    test('should return an iterator of rows', () {
      final grid = filled(3, 3, 0);
      check(grid).rows.deepEquals([
        [0, 0, 0],
        [0, 0, 0],
        [0, 0, 0],
      ]);
    });

    group('<$Rows>.first', () {
      test('should set the first row', () {
        final grid = filled(3, 3, 0);
        grid.rows.first = [1, 2, 3];
        check(grid).rows.deepEquals([
          [1, 2, 3],
          [0, 0, 0],
          [0, 0, 0],
        ]);
      });

      test('should throw if the grid is empty', () {
        final grid = Grid<int>.empty();
        check(() => grid.rows.first = [1, 2, 3]).throws<StateError>();
      });
    });

    group('<$Rows>.last', () {
      test('should set the last row', () {
        final grid = filled(3, 3, 0);
        grid.rows.last = [1, 2, 3];
        check(grid).rows.deepEquals([
          [0, 0, 0],
          [0, 0, 0],
          [1, 2, 3],
        ]);
      });

      test('should throw if the grid is empty', () {
        final grid = empty();
        check(() => grid.rows.last = [1, 2, 3]).throws<StateError>();
      });
    });

    group('<$Rows>.[]=', () {
      test('should set the row at the index', () {
        final grid = filled(3, 3, 0);
        grid.rows[1] = [1, 2, 3];
        check(grid).rows.deepEquals([
          [0, 0, 0],
          [1, 2, 3],
          [0, 0, 0],
        ]);
      });

      test('should throw if the index is out of bounds', () {
        final grid = filled(3, 3, 0);
        check(() => grid.rows[3] = [1, 2, 3]).throws<RangeError>();
      });

      test('should throw if the row has the wrong length', () {
        final grid = filled(3, 3, 0);
        check(() => grid.rows[1] = [1, 2]).throws<ArgumentError>();
      });
    });

    group('<$Rows>.[]', () {
      test('should return the row at the index', () {
        final grid = filled(3, 3, 0);
        check(grid.rows[1]).deepEquals([0, 0, 0]);
      });

      test('should throw if the index is out of bounds', () {
        final grid = filled(3, 3, 0);
        check(() => grid.rows[3]).throws<RangeError>();
      });
    });
  });

  group('<$testing>.columns', () {
    test('should return an iterator of columns', () {
      final grid = filled(3, 3, 0);
      check(grid).columns.deepEquals([
        [0, 0, 0],
        [0, 0, 0],
        [0, 0, 0],
      ]);
    });

    group('<$Columns>.first', () {
      test('should set the first column', () {
        final grid = filled(3, 3, 0);
        grid.columns.first = [1, 2, 3];
        check(grid).rows.deepEquals([
          [1, 0, 0],
          [2, 0, 0],
          [3, 0, 0],
        ]);
      });

      test('should throw if the grid is empty', () {
        final grid = Grid<int>.empty();
        check(() => grid.columns.first = [1, 2, 3]).throws<StateError>();
      });
    });

    group('<$Columns>.last', () {
      test('should set the last column', () {
        final grid = filled(3, 3, 0);
        grid.columns.last = [1, 2, 3];
        check(grid).rows.deepEquals([
          [0, 0, 1],
          [0, 0, 2],
          [0, 0, 3],
        ]);
      });

      test('should throw if the grid is empty', () {
        final grid = Grid<int>.empty();
        check(() => grid.columns.last = [1, 2, 3]).throws<StateError>();
      });
    });

    group('<$Columns>.[]=', () {
      test('should set the column at the index', () {
        final grid = filled(3, 3, 0);
        grid.columns[1] = [1, 2, 3];
        check(grid).rows.deepEquals([
          [0, 1, 0],
          [0, 2, 0],
          [0, 3, 0],
        ]);
      });

      test('should throw if the index is out of bounds', () {
        final grid = filled(3, 3, 0);
        check(() => grid.columns[3] = [1, 2, 3]).throws<RangeError>();
      });

      test('should throw if the column has the wrong length', () {
        final grid = filled(3, 3, 0);
        check(() => grid.columns[1] = [1, 2]).throws<ArgumentError>();
      });

      test('should throw if the grid is empty', () {
        final grid = Grid<int>.empty();
        check(() => grid.columns[0] = [1, 2, 3]).throws<StateError>();
      });
    });

    group('<$Columns>.[]', () {
      test('should return the column at the index', () {
        final grid = filled(3, 3, 0);
        check(grid.columns[1]).deepEquals([0, 0, 0]);
      });

      test('should throw if the index is out of bounds', () {
        final grid = filled(3, 3, 0);
        check(() => grid.columns[3]).throws<RangeError>();
      });
    });
  });

  group('<$testing>.subGrid', () {
    test('should return a sub-grid', () {
      final grid = filled(3, 3, 0);
      final subGrid = grid.subGrid(left: 1, top: 1, width: 2, height: 2);
      check(subGrid).rows.deepEquals([
        [0, 0],
        [0, 0],
      ]);
    });

    test('should have its own width and height', () {
      final grid = filled(3, 3, 0);
      final subGrid = grid.subGrid(left: 1, top: 1, width: 2, height: 2);
      check(subGrid).width.equals(2);
      check(subGrid).height.equals(2);
    });

    test('should throw if the bounds are out of bounds', () {
      final grid = filled(3, 3, 0);
      check(
        () => grid.subGrid(left: 3, top: 3, width: 1, height: 1),
      ).throws<RangeError>();
    });

    test('defaults to the remaining width and height', () {
      final grid = filled(3, 3, 0);
      final subGrid = grid.subGrid(left: 1, top: 1);
      check(subGrid).rows.deepEquals([
        [0, 0],
        [0, 0],
      ]);
    });
  });

  group('<$testing>.asSubGrid', () {
    test('should return a sub-grid view', () {
      final grid = filled(3, 3, 0);
      final subGrid = grid.asSubGrid(left: 1, top: 1, width: 2, height: 2);
      check(subGrid).rows.deepEquals([
        [0, 0],
        [0, 0],
      ]);
    });

    test('should have its own width and height', () {
      final grid = filled(3, 3, 0);
      final subGrid = grid.asSubGrid(left: 1, top: 1, width: 2, height: 2);
      check(subGrid).width.equals(2);
      check(subGrid).height.equals(2);
    });

    test('should throw if the bounds are out of bounds', () {
      final grid = filled(3, 3, 0);
      check(
        () => grid.asSubGrid(left: 3, top: 3, width: 1, height: 1),
      ).throws<RangeError>();
    });

    test('defaults to the remaining width and height', () {
      final grid = filled(3, 3, 0);
      final subGrid = grid.asSubGrid(left: 1, top: 1);
      check(subGrid).rows.deepEquals([
        [0, 0],
        [0, 0],
      ]);
    });

    test('is empty if the area is empty', () {
      final grid = filled(3, 3, 0);
      final subGrid = grid.asSubGrid(left: 1, top: 1, width: 0, height: 0);
      check(subGrid).isEmpty.isTrue();
    });

    test('containsXYWH should be relative to the sub-grid', () {
      final grid = filled(3, 3, 0);
      final subGrid = grid.asSubGrid(left: 1, top: 1, width: 2, height: 2);
      check(subGrid).containsXYWH(0, 0, 1, 1).isTrue();
      check(subGrid).containsXYWH(1, 1, 1, 1).isTrue();
      check(subGrid).containsXYWH(2, 2, 1, 1).isFalse();
    });

    test('set should delegate to the original grid', () {
      final grid = filled(3, 3, 0);
      final subGrid = grid.asSubGrid(left: 1, top: 1, width: 2, height: 2);

      subGrid.set(1, 1, 1);
      check(subGrid).at(1, 1).equals(1);

      check(grid).at(2, 2).equals(1);
    });

    test('columns should be a view of the original grid', () {
      final grid = filled(3, 3, 0);
      final subGrid = grid.asSubGrid(left: 1, top: 1, width: 2, height: 2);
      check(subGrid.columns).deepEquals([
        [0, 0],
        [0, 0],
      ]);
    });

    test('should be able to nest sub-grids', () {
      final grid = filled(3, 3, 0);
      final subGrid = grid.asSubGrid(
        left: 1,
        top: 1,
        width: 2,
        height: 2,
      );
      final subSubGrid = subGrid.asSubGrid(
        left: 1,
        top: 1,
      );
      check(subSubGrid).rows.deepEquals([
        [0],
      ]);
    });

    test('fails when inserting a row', () {
      final grid = filled(3, 3, 0);
      final subGrid = grid.asSubGrid(left: 1, top: 1, width: 2, height: 2);
      check(() => subGrid.rows.insertAt(0, [1, 2])).throws<Error>();
    });

    test('fails when inserting a column', () {
      final grid = filled(3, 3, 0);
      final subGrid = grid.asSubGrid(left: 1, top: 1, width: 2, height: 2);
      check(() => subGrid.columns.insertAt(0, [1, 2])).throws<Error>();
    });

    test('fails when removing a row', () {
      final grid = filled(3, 3, 0);
      final subGrid = grid.asSubGrid(left: 1, top: 1, width: 2, height: 2);
      check(() => subGrid.rows.removeAt(0)).throws<Error>();
    });

    test('fails when removing a column', () {
      final grid = filled(3, 3, 0);
      final subGrid = grid.asSubGrid(left: 1, top: 1, width: 2, height: 2);
      check(() => subGrid.columns.removeAt(0)).throws<Error>();
    });
  });

  group('<$testing>.contains', () {
    test('should return true if the element is in the grid', () {
      final grid = filled(3, 3, 1);
      grid.set(1, 1, 0);
      check(grid).has((g) => g.contains(0), 'contains(0)').isTrue();
    });

    test('should return false if the element is not in the grid', () {
      final grid = filled(3, 3, 1);
      check(grid).has((g) => g.contains(0), 'contains(0)').isFalse();
    });
  });

  test('<$testing>.toString() is cute', () {
    final grid = filled(3, 3, 0);
    check(grid.toString()).equals(
      '┌───────┐\n'
      '│ 0 0 0 │\n'
      '│ 0 0 0 │\n'
      '│ 0 0 0 │\n'
      '└───────┘',
    );
  });
}
