import 'package:meta/meta.dart';

import '_prelude.dart';

void main() {
  group('getRect', () {
    group('full dimensions', () {
      final fixture = GridFixture.from2D([
        [1, 2, 3],
        [4, 5, 6],
      ]);

      test('callbacks', () {
        final grid = fixture.to2D();
        get(Pos p) => grid[p.y][p.x];
        check(getRect(fixture.toBounds(), get)).deepEquals([
          1, 2, 3, //
          4, 5, 6, //
        ]);
      });

      test('linear', () {
        final grid = fixture.to1D();
        check(getRectLinear(grid, width: fixture.width)).deepEquals([
          1, 2, 3, //
          4, 5, 6, //
        ]);
      });
    });

    group('full width, partial height', () {
      final fixture = GridFixture.from2D([
        [1, 2, 3],
        [4, 5, 6],
        [7, 8, 9],
      ]);

      test('callbacks', () {
        final grid = fixture.to2D();
        get(Pos p) => grid[p.y][p.x];
        check(getRect(Rect.fromLTWH(0, 1, 3, 2), get)).deepEquals([
          4, 5, 6, //
          7, 8, 9, //
        ]);
      });

      test('linear', () {
        final grid = fixture.to1D();
        check(
          getRectLinear(
            grid,
            width: fixture.width,
            bounds: Rect.fromLTWH(0, 1, 3, 2),
          ),
        ).deepEquals([
          4, 5, 6, //
          7, 8, 9, //
        ]);
      });
    });

    group('partial width, full height', () {
      final fixture = GridFixture.from2D([
        [1, 2, 3],
        [4, 5, 6],
        [7, 8, 9],
      ]);

      test('callbacks', () {
        final grid = fixture.to2D();
        get(Pos p) => grid[p.y][p.x];
        check(getRect(Rect.fromLTWH(1, 0, 2, 3), get)).deepEquals([
          2, 3, //
          5, 6, //
          8, 9, //
        ]);
      });

      test('linear', () {
        final grid = fixture.to1D();
        check(
          getRectLinear(
            grid,
            width: fixture.width,
            bounds: Rect.fromLTWH(1, 0, 2, 3),
          ),
        ).deepEquals([
          2, 3, //
          5, 6, //
          8, 9, //
        ]);
      });
    });

    group('partial width, partial height', () {
      final fixture = GridFixture.from2D([
        [1, 2, 3],
        [4, 5, 6],
        [7, 8, 9],
      ]);

      test('callbacks', () {
        final grid = fixture.to2D();
        get(Pos p) => grid[p.y][p.x];
        check(getRect(Rect.fromLTWH(1, 1, 2, 2), get)).deepEquals([
          5, 6, //
          8, 9, //
        ]);
      });

      test('linear', () {
        final grid = fixture.to1D();
        check(
          getRectLinear(
            grid,
            width: fixture.width,
            bounds: Rect.fromLTWH(1, 1, 2, 2),
          ),
        ).deepEquals([
          5, 6, //
          8, 9, //
        ]);
      });
    });
  });

  group('fillRect', () {
    group('full dimensions', () {
      final fixture = GridFixture.filled(3, 2, 0);

      test('callbacks', () {
        final grid = fixture.to2D();
        set(Pos p, int value) => grid[p.y][p.x] = value;
        fillRect(fixture.toBounds(), set, 1);
        check(grid).deepEquals([
          [1, 1, 1],
          [1, 1, 1],
        ]);
      });

      test('linear', () {
        final grid = fixture.to1D();
        fillRectLinear(grid, 1, width: fixture.width);
        check(grid).deepEquals([
          1, 1, 1, //
          1, 1, 1, //
        ]);
      });
    });

    group('full width, partial height', () {
      final fixture = GridFixture.filled(3, 3, 0);

      test('callbacks', () {
        final grid = fixture.to2D();
        set(Pos p, int value) => grid[p.y][p.x] = value;
        fillRect(Rect.fromLTWH(0, 1, 3, 2), set, 1);
        check(grid).deepEquals([
          [0, 0, 0],
          [1, 1, 1],
          [1, 1, 1],
        ]);
      });

      test('linear', () {
        final grid = fixture.to1D();
        fillRectLinear(
          grid,
          1,
          width: fixture.width,
          bounds: Rect.fromLTWH(0, 1, 3, 2),
        );
        check(grid).deepEquals([
          0, 0, 0, //
          1, 1, 1, //
          1, 1, 1, //
        ]);
      });
    });

    group('partial width, full height', () {
      final fixture = GridFixture.filled(3, 3, 0);

      test('callbacks', () {
        final grid = fixture.to2D();
        set(Pos p, int value) => grid[p.y][p.x] = value;
        fillRect(Rect.fromLTWH(1, 0, 2, 3), set, 1);
        check(grid).deepEquals([
          [0, 1, 1],
          [0, 1, 1],
          [0, 1, 1],
        ]);
      });

      test('linear', () {
        final grid = fixture.to1D();
        fillRectLinear(
          grid,
          1,
          width: fixture.width,
          bounds: Rect.fromLTWH(1, 0, 2, 3),
        );
        check(grid).deepEquals([
          0, 1, 1, //
          0, 1, 1, //
          0, 1, 1, //
        ]);
      });
    });

    group('partial width, partial height', () {
      final fixture = GridFixture.filled(3, 3, 0);

      test('callbacks', () {
        final grid = fixture.to2D();
        set(Pos p, int value) => grid[p.y][p.x] = value;
        fillRect(Rect.fromLTWH(1, 1, 2, 2), set, 1);
        check(grid).deepEquals([
          [0, 0, 0],
          [0, 1, 1],
          [0, 1, 1],
        ]);
      });

      test('linear', () {
        final grid = fixture.to1D();
        fillRectLinear(
          grid,
          1,
          width: fixture.width,
          bounds: Rect.fromLTWH(1, 1, 2, 2),
        );
        check(grid).deepEquals([
          0, 0, 0, //
          0, 1, 1, //
          0, 1, 1, //
        ]);
      });
    });
  });

  group('fillRectFrom', () {
    group('full dimensions', () {
      final fixture = GridFixture.filled(3, 2, 0);

      test('callbacks', () {
        final grid = fixture.to2D();
        set(Pos p, int value) => grid[p.y][p.x] = value;
        fillRectFrom(fixture.toBounds(), set, [1, 2, 3, 4, 5, 6]);
        check(grid).deepEquals([
          [1, 2, 3],
          [4, 5, 6],
        ]);
      });

      test('linear', () {
        final grid = fixture.to1D();
        fillRectFromLinear(grid, [1, 2, 3, 4, 5, 6], width: fixture.width);
        check(grid).deepEquals([1, 2, 3, 4, 5, 6]);
      });
    });

    group('full width, partial height', () {
      final fixture = GridFixture.filled(3, 3, 0);

      test('callbacks', () {
        final grid = fixture.to2D();
        set(Pos p, int value) => grid[p.y][p.x] = value;
        fillRectFrom(Rect.fromLTWH(0, 1, 3, 2), set, [1, 2, 3, 4, 5, 6]);
        check(grid).deepEquals([
          [0, 0, 0],
          [1, 2, 3],
          [4, 5, 6],
        ]);
      });

      test('linear', () {
        final grid = fixture.to1D();
        fillRectFromLinear(
          grid,
          [1, 2, 3, 4, 5, 6],
          width: fixture.width,
          bounds: Rect.fromLTWH(0, 1, 3, 2),
        );
        check(grid).deepEquals([
          0, 0, 0, //
          1, 2, 3, //
          4, 5, 6, //
        ]);
      });
    });

    group('partial width, full height', () {
      final fixture = GridFixture.filled(3, 3, 0);

      test('callbacks', () {
        final grid = fixture.to2D();
        set(Pos p, int value) => grid[p.y][p.x] = value;
        fillRectFrom(Rect.fromLTWH(1, 0, 2, 3), set, [1, 2, 3, 4, 5, 6]);
        check(grid).deepEquals([
          [0, 1, 2],
          [0, 3, 4],
          [0, 5, 6],
        ]);
      });

      test('linear', () {
        final grid = fixture.to1D();
        fillRectFromLinear(
          grid,
          [1, 2, 3, 4, 5, 6],
          width: fixture.width,
          bounds: Rect.fromLTWH(1, 0, 2, 3),
        );
        check(grid).deepEquals([
          0, 1, 2, //
          0, 3, 4, //
          0, 5, 6, //
        ]);
      });
    });

    group('partial width, partial height', () {
      final fixture = GridFixture.filled(3, 3, 0);

      test('callbacks', () {
        final grid = fixture.to2D();
        set(Pos p, int value) => grid[p.y][p.x] = value;
        fillRectFrom(Rect.fromLTWH(1, 1, 2, 2), set, [1, 2, 3, 4]);
        check(grid).deepEquals([
          [0, 0, 0],
          [0, 1, 2],
          [0, 3, 4],
        ]);
      });

      test('linear', () {
        final grid = fixture.to1D();
        fillRectFromLinear(
          grid,
          [1, 2, 3, 4],
          width: fixture.width,
          bounds: Rect.fromLTWH(1, 1, 2, 2),
        );
        check(grid).deepEquals([
          0, 0, 0, //
          0, 1, 2, //
          0, 3, 4, //
        ]);
      });
    });
  });

  group('copyRect', () {
    group('full dimensions -> full dimensions', () {
      final src = GridFixture.from2D([
        [1, 2, 3],
        [4, 5, 6],
      ]);

      final dst = GridFixture.from2D([
        [0, 0, 0],
        [0, 0, 0],
      ]);

      test('callbacks', () {
        final srcGrid = src.to2D();
        final dstGrid = dst.to2D();
        getSrc(Pos p) => srcGrid[p.y][p.x];
        setDst(Pos p, int value) => dstGrid[p.y][p.x] = value;
        copyRect(src.toBounds(), getSrc, setDst);
        check(dstGrid).deepEquals([
          [1, 2, 3],
          [4, 5, 6],
        ]);
      });

      test('linear', () {
        final srcGrid = src.to1D();
        final dstGrid = dst.to1D();
        copyRectLinear(
          srcGrid,
          dstGrid,
          srcWidth: src.width,
          dstWidth: dst.width,
        );
        check(dstGrid).deepEquals([
          1, 2, 3, //
          4, 5, 6, //
        ]);
      });
    });

    group('full dimensions -> partial dimensions (smaller)', () {
      final src = GridFixture.from2D([
        [1, 2, 3],
        [4, 5, 6],
      ]);

      final dst = GridFixture.from2D([
        [0, 0, 0],
        [0, 0, 0],
        [0, 0, 0],
      ]);

      test('callbacks', () {
        final srcGrid = src.to2D();
        final dstGrid = dst.to2D();
        getSrc(Pos p) => srcGrid[p.y][p.x];
        setDst(Pos p, int value) => dstGrid[p.y][p.x] = value;
        copyRect(src.toBounds(), getSrc, setDst);
        check(dstGrid).deepEquals([
          [1, 2, 3],
          [4, 5, 6],
          [0, 0, 0],
        ]);
      });

      test('linear', () {
        final srcGrid = src.to1D();
        final dstGrid = dst.to1D();
        copyRectLinear(
          srcGrid,
          dstGrid,
          srcWidth: src.width,
          dstWidth: dst.width,
        );
        check(dstGrid).deepEquals([
          1, 2, 3, //
          4, 5, 6, //
          0, 0, 0, //
        ]);
      });
    });

    group('full dimensions -> partial dimensions (smaller + v-offset)', () {
      final src = GridFixture.from2D([
        [1, 2, 3],
        [4, 5, 6],
      ]);

      final dst = GridFixture.from2D([
        [0, 0, 0],
        [0, 0, 0],
        [0, 0, 0],
      ]);

      test('callbacks', () {
        final srcGrid = src.to2D();
        final dstGrid = dst.to2D();
        getSrc(Pos p) => srcGrid[p.y][p.x];
        setDst(Pos p, int value) => dstGrid[p.y][p.x] = value;
        copyRect(
          src.toBounds(),
          getSrc,
          setDst,
          // Skip the first row.
          target: Pos(0, 1),
        );
        check(dstGrid).deepEquals([
          [0, 0, 0],
          [1, 2, 3],
          [4, 5, 6],
        ]);
      });

      test('linear', () {
        final srcGrid = src.to1D();
        final dstGrid = dst.to1D();
        copyRectLinear(
          srcGrid,
          dstGrid,
          srcWidth: src.width,
          dstWidth: dst.width,
          // Skip the first row.
          target: Pos(0, 1),
        );
        check(dstGrid).deepEquals([
          0, 0, 0, //
          1, 2, 3, //
          4, 5, 6, //
        ]);
      });
    });
  });

  group('full dimensions -> partial dimensions (smaller + h-offset)', () {
    final src = GridFixture.from2D([
      [1, 2, 3],
      [4, 5, 6],
    ]);

    final dst = GridFixture.from2D([
      [0, 0, 0, 0],
      [0, 0, 0, 0],
    ]);

    test('callbacks', () {
      final srcGrid = src.to2D();
      final dstGrid = dst.to2D();
      getSrc(Pos p) => srcGrid[p.y][p.x];
      setDst(Pos p, int value) => dstGrid[p.y][p.x] = value;
      copyRect(
        src.toBounds(),
        getSrc,
        setDst,
        // Skip the first column.
        target: Pos(1, 0),
      );
      check(dstGrid).deepEquals([
        [0, 1, 2, 3],
        [0, 4, 5, 6],
      ]);
    });

    test('linear', () {
      final srcGrid = src.to1D();
      final dstGrid = dst.to1D();
      copyRectLinear(
        srcGrid,
        dstGrid,
        srcWidth: src.width,
        dstWidth: dst.width,
        // Skip the first column.
        target: Pos(1, 0),
      );
      check(dstGrid).deepEquals([
        0, 1, 2, 3, //
        0, 4, 5, 6, //
      ]);
    });
  });

  group('partial rect copied into full rect', () {
    final src = GridFixture.from2D([
      [0, 0, 0, 0],
      [0, 0, 1, 2],
      [0, 0, 3, 4],
    ]);

    final dst = GridFixture.from2D([
      [0, 0],
      [0, 0],
    ]);

    test('callbacks', () {
      final srcGrid = src.to2D();
      final dstGrid = dst.to2D();
      getSrc(Pos p) => srcGrid[p.y][p.x];
      setDst(Pos p, int value) => dstGrid[p.y][p.x] = value;
      copyRect(Rect.fromLTWH(2, 1, 2, 2), getSrc, setDst);
      check(dstGrid).deepEquals([
        [1, 2],
        [3, 4],
      ]);
    });

    test('linear', () {
      final srcGrid = src.to1D();
      final dstGrid = dst.to1D();
      copyRectLinear(
        srcGrid,
        dstGrid,
        srcWidth: src.width,
        dstWidth: dst.width,
        source: Rect.fromLTWH(2, 1, 2, 2),
      );
      check(dstGrid).deepEquals([
        1, 2, //
        3, 4, //
      ]);
    });
  });

  group('partial rect copied into partial rect', () {
    final src = GridFixture.from2D([
      [0, 0, 0, 0],
      [0, 0, 1, 2],
      [0, 0, 3, 4],
    ]);

    final dst = GridFixture.from2D([
      [0, 0, 0],
      [0, 0, 0],
      [0, 0, 0],
    ]);

    test('callbacks', () {
      final srcGrid = src.to2D();
      final dstGrid = dst.to2D();
      getSrc(Pos p) => srcGrid[p.y][p.x];
      setDst(Pos p, int value) => dstGrid[p.y][p.x] = value;
      copyRect(Rect.fromLTWH(2, 1, 2, 2), getSrc, setDst, target: Pos(1, 0));
      check(dstGrid).deepEquals([
        [0, 1, 2],
        [0, 3, 4],
        [0, 0, 0],
      ]);
    });

    test('linear', () {
      final srcGrid = src.to1D();
      final dstGrid = dst.to1D();
      copyRectLinear(
        srcGrid,
        dstGrid,
        srcWidth: src.width,
        dstWidth: dst.width,
        source: Rect.fromLTWH(2, 1, 2, 2),
        target: Pos(1, 0),
      );
      check(dstGrid).deepEquals([
        0, 1, 2, //
        0, 3, 4, //
        0, 0, 0, //
      ]);
    });
  });
}

/// A test fixture for grid-like operations.
class GridFixture<T> {
  /// Creates a new grid fixture from a 2D list.
  ///
  /// The [grid] must be a 2D list with a consistent width and height.
  GridFixture.from2D(List<List<T>> grid)
    : this._from2D(grid, width: grid[0].length, height: grid.length);

  /// Creates a new grid fixture from a 2D list with a fixed width and height.
  ///
  /// Each element defaults to [fill].
  GridFixture.filled(int width, int height, T fill)
    : this._from2D(
        List.generate(height, (_) => List.filled(width, fill)),
        width: width,
        height: height,
      );

  GridFixture._from2D(this._grid, {required this.width, required this.height}) {
    checkPositive(width, 'width');
    checkPositive(height, 'height');
    if (_grid.length != height) {
      throw ArgumentError.value(_grid, 'grid', 'Invalid height');
    }
    for (final row in _grid) {
      if (row.length != width) {
        throw ArgumentError.value(row, 'grid', 'Invalid width');
      }
    }
  }

  /// The grid to test.
  @protected
  final List<List<T>> _grid;

  /// The width of the grid.
  final int width;

  /// The height of the grid.
  final int height;

  /// Returns a copy of the grid.
  List<List<T>> to2D() {
    return [
      for (final row in _grid) [...row],
    ];
  }

  /// Converts the grid to a linear list.
  List<T> to1D() {
    return [for (final row in _grid) ...row];
  }

  /// Converts the grid to a bounds.
  Rect toBounds() {
    return Rect.fromLTWH(0, 0, width, height);
  }
}
