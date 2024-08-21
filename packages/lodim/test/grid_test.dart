import 'package:lodim/src/grid.dart';

import '_prelude.dart';

void main() {
  group('GridLike.fromGetSet', () {
    test('should create a GridLike from a get/set function', () {
      final set = <Pos, Pos>{};
      final grid = GridLike<Pos>.fromGetSet(
        (p) => p,
        (p, v) => set[p] = v,
        width: 2,
        height: 2,
      );

      check(grid.get(Pos(0, 0))).equals(Pos(0, 0));
      check(grid.get(Pos(1, 1))).equals(Pos(1, 1));

      grid.set(Pos(0, 0), Pos(1, 1));
      check(set).deepEquals({Pos(0, 0): Pos(1, 1)});
    });

    test('should throw when width or height is less than 0', () {
      check(
        () => GridLike<Pos>.fromGetSet(
          (p) => p,
          (p, v) {},
          width: -1,
          height: 1,
        ),
      ).throws<RangeError>();
      check(
        () => GridLike<Pos>.fromGetSet(
          (p) => p,
          (p, v) {},
          width: 1,
          height: -1,
        ),
      ).throws<RangeError>();
    });

    test('should throw when positions are out of bounds', () {
      final grid = GridLike<Pos>.fromGetSet(
        (p) => p,
        (p, v) {},
        width: 2,
        height: 2,
      );

      check(() => grid.get(Pos(2, 0))).throws<RangeError>();
      check(() => grid.get(Pos(0, 2))).throws<RangeError>();
      check(() => grid.set(Pos(2, 0), Pos(0, 0))).throws<RangeError>();
      check(() => grid.set(Pos(0, 2), Pos(0, 0))).throws<RangeError>();
    });
  });

  group('GridLike.withList', () {
    test('should create a GridLike from a list', () {
      final list = [
        0, 1, 2, //
        3, 4, 5, //
        6, 7, 8, //
      ];
      final grid = GridLike.withList(
        list,
        width: 3,
        height: 3,
      );

      check(grid.get(Pos(0, 0))).equals(0);
      check(grid.get(Pos(1, 1))).equals(4);

      grid.set(Pos(0, 0), 1);
      check(list).deepEquals([
        1, 1, 2, //
        3, 4, 5, //
        6, 7, 8, //
      ]);
    });

    test('should throw when width or height is less than 0', () {
      check(
        () => GridLike.withList(
          [],
          width: -1,
          height: 1,
        ),
      ).throws<RangeError>();
      check(
        () => GridLike.withList(
          [],
          width: 1,
          height: -1,
        ),
      ).throws<RangeError>();
    });

    test('should throw when list is too short', () {
      check(
        () => GridLike.withList(
          [0, 1, 2],
          width: 2,
          height: 2,
        ),
      ).throws<ArgumentError>();
    });

    test('should throw when list is too long', () {
      check(
        () => GridLike.withList(
          [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
          width: 3,
          height: 3,
        ),
      ).throws<ArgumentError>();
    });

    test('should throw when positions are out of bounds', () {
      final grid = GridLike.withList(
        [0, 1, 2, 3, 4, 5, 6, 7, 8],
        width: 3,
        height: 3,
      );

      check(() => grid.get(Pos(3, 0))).throws<RangeError>();
      check(() => grid.get(Pos(0, 3))).throws<RangeError>();
      check(() => grid.set(Pos(3, 0), 0)).throws<RangeError>();
      check(() => grid.set(Pos(0, 3), 0)).throws<RangeError>();
    });
  });

  group('getRect', () {
    test('full grid, naive', () {
      final grid = _NaiveGrid(3, 2, 0);
      grid.set(Pos(0, 0), 1);
      grid.set(Pos(1, 0), 2);
      grid.set(Pos(2, 0), 3);
      grid.set(Pos(0, 1), 4);
      grid.set(Pos(1, 1), 5);
      grid.set(Pos(2, 1), 6);

      check(GridLike.getRect(grid)).deepEquals([
        1, 2, 3, //
        4, 5, 6, //
      ]);
    });

    test('full grid, optimized', () {
      final grid = GridLike.withList(
        [
          1, 2, 3, //
          4, 5, 6, //
        ],
        width: 3,
        height: 2,
      );

      check(GridLike.getRect(grid)).deepEquals([
        1, 2, 3, //
        4, 5, 6, //
      ]);
    });

    test('full grid, explicit, naive', () {
      final grid = _NaiveGrid(3, 2, 0);
      grid.set(Pos(0, 0), 1);
      grid.set(Pos(1, 0), 2);
      grid.set(Pos(2, 0), 3);
      grid.set(Pos(0, 1), 4);
      grid.set(Pos(1, 1), 5);
      grid.set(Pos(2, 1), 6);

      check(GridLike.getRect(grid, bounds: Rect.fromWH(3, 2))).deepEquals([
        1, 2, 3, //
        4, 5, 6, //
      ]);
    });

    test('full grid, explicit, optimized', () {
      final grid = GridLike.withList(
        [
          1, 2, 3, //
          4, 5, 6, //
        ],
        width: 3,
        height: 2,
      );

      check(GridLike.getRect(grid, bounds: Rect.fromWH(3, 2))).deepEquals([
        1, 2, 3, //
        4, 5, 6, //
      ]);
    });

    test('partial grid, explicit, clamped', () {
      final grid = GridLike.withList(
        [
          1, 2, 3, //
          4, 5, 6, //
        ],
        width: 3,
        height: 2,
      );

      check(GridLike.getRect(grid, bounds: Rect.fromWH(3, 4))).deepEquals([
        1, 2, 3, //
        4, 5, 6, //
      ]);
    });

    test('partial grid, explicit, full width, naive', () {
      final grid = _NaiveGrid(3, 2, 0);
      grid.set(Pos(0, 0), 1);
      grid.set(Pos(1, 0), 2);
      grid.set(Pos(2, 0), 3);
      grid.set(Pos(0, 1), 4);
      grid.set(Pos(1, 1), 5);
      grid.set(Pos(2, 1), 6);

      check(GridLike.getRect(grid, bounds: Rect.fromWH(3, 1))).deepEquals([
        1, 2, 3, //
      ]);
    });

    test('partial grid, explicit, full width, optimized', () {
      final grid = GridLike.withList(
        [
          1, 2, 3, //
          4, 5, 6, //
        ],
        width: 3,
        height: 2,
      );

      check(GridLike.getRect(grid, bounds: Rect.fromWH(3, 1))).deepEquals([
        1, 2, 3, //
      ]);
    });

    test('partial grid, explicit, partial width, naive', () {
      final grid = _NaiveGrid(3, 2, 0);
      grid.set(Pos(0, 0), 1);
      grid.set(Pos(1, 0), 2);
      grid.set(Pos(2, 0), 3);
      grid.set(Pos(0, 1), 4);
      grid.set(Pos(1, 1), 5);
      grid.set(Pos(2, 1), 6);

      check(
        GridLike.getRect(grid, bounds: Rect.fromLTWH(1, 0, 2, 1)),
      ).deepEquals([2, 3]);
    });

    test('partial grid, explicit, partial width, optimized', () {
      final grid = GridLike.withList(
        [
          // v  v
          1, 2, 3, //
          4, 5, 6, //
        ],
        width: 3,
        height: 2,
      );

      check(
        GridLike.getRect(grid, bounds: Rect.fromLTWH(1, 0, 2, 1)),
      ).deepEquals([2, 3]);
    });

    test('partial grid, explicit, partial width, tall, optimized', () {
      final grid = GridLike.withList(
        [
          // v  v
          1, 2, 3, //
          4, 5, 6, //
        ],
        width: 3,
        height: 2,
      );

      check(
        GridLike.getRect(grid, bounds: Rect.fromLTWH(1, 0, 1, 2)).toList(),
      ).deepEquals([2, 5]);
    });
  });

  group('fillRect', () {
    test('full grid, naive', () {
      final grid = _NaiveGrid(3, 2, 0);
      GridLike.fillRect(grid, 1);

      check(GridLike.getRect(grid)).deepEquals([
        1, 1, 1, //
        1, 1, 1, //
      ]);
    });

    test('full grid, optimized', () {
      final grid = GridLike.withList(
        [
          0, 0, 0, //
          0, 0, 0, //
        ],
        width: 3,
        height: 2,
      );
      GridLike.fillRect(grid, 1);

      check(GridLike.getRect(grid)).deepEquals([
        1, 1, 1, //
        1, 1, 1, //
      ]);
    });

    test('partial grid, naive', () {
      final grid = _NaiveGrid(3, 2, 0);
      GridLike.fillRect(
        grid,
        1,
        bounds: Rect.fromWH(3, 1),
      );

      check(GridLike.getRect(grid)).deepEquals([
        1, 1, 1, //
        0, 0, 0, //
      ]);
    });

    test('partial grid, optimized', () {
      final grid = GridLike.withList(
        [
          0, 0, 0, //
          0, 0, 0, //
        ],
        width: 3,
        height: 2,
      );
      GridLike.fillRect(
        grid,
        1,
        bounds: Rect.fromWH(3, 1),
      );

      check(GridLike.getRect(grid)).deepEquals([
        1, 1, 1, //
        0, 0, 0, //
      ]);
    });

    test('partial grid, non-full width, optimized', () {
      final grid = GridLike.withList(
        [
          0, 0, 0, //
          0, 0, 0, //
        ],
        width: 3,
        height: 2,
      );
      GridLike.fillRect(
        grid,
        1,
        bounds: Rect.fromLTWH(1, 0, 2, 1),
      );

      check(GridLike.getRect(grid)).deepEquals([
        0, 1, 1, //
        0, 0, 0, //
      ]);
    });
  });

  group('fillRectFrom', () {
    test('full grid, naive', () {
      final grid = _NaiveGrid(3, 2, 0);
      GridLike.fillRectFrom(grid, [1, 2, 3, 4, 5, 6]);

      check(GridLike.getRect(grid)).deepEquals([
        1, 2, 3, //
        4, 5, 6, //
      ]);
    });

    test('full grid, optimized', () {
      final grid = GridLike.withList(
        [
          0, 0, 0, //
          0, 0, 0, //
        ],
        width: 3,
        height: 2,
      );
      GridLike.fillRectFrom(grid, [1, 2, 3, 4, 5, 6]);

      check(GridLike.getRect(grid)).deepEquals([
        1, 2, 3, //
        4, 5, 6, //
      ]);
    });

    test('partial grid, naive', () {
      final grid = _NaiveGrid(3, 2, 0);
      GridLike.fillRectFrom(
        grid,
        [1, 2, 3],
        bounds: Rect.fromWH(3, 1),
      );

      check(GridLike.getRect(grid)).deepEquals([
        1, 2, 3, //
        0, 0, 0, //
      ]);
    });

    test('partial grid, optimized', () {
      final grid = GridLike.withList(
        [
          0, 0, 0, //
          0, 0, 0, //
        ],
        width: 3,
        height: 2,
      );
      GridLike.fillRectFrom(
        grid,
        [1, 2, 3],
        bounds: Rect.fromWH(3, 1),
      );

      check(GridLike.getRect(grid)).deepEquals([
        1, 2, 3, //
        0, 0, 0, //
      ]);
    });

    test('insufficient elements throws', () {
      final grid = GridLike.withList(
        [
          0, 0, 0, //
          0, 0, 0, //
        ],
        width: 3,
        height: 2,
      );

      check(
        () => GridLike.fillRectFrom(
          grid,
          [1, 2, 3, 4, 5],
        ),
      ).throws<ArgumentError>();
    });

    test('too many elements throws', () {
      final grid = GridLike.withList(
        [
          0, 0, 0, //
          0, 0, 0, //
        ],
        width: 3,
        height: 2,
      );

      check(
        () => GridLike.fillRectFrom(
          grid,
          [1, 2, 3, 4, 5, 6, 7],
        ),
      ).throws<ArgumentError>();
    });

    test('full grid, optimized', () {
      final grid = GridLike.withList(
        [
          0, 0, 0, //
          0, 0, 0, //
        ],
        width: 3,
        height: 2,
      );
      GridLike.fillRectFrom(grid, [1, 2, 3, 4, 5, 6]);

      check(GridLike.getRect(grid)).deepEquals([
        1, 2, 3, //
        4, 5, 6, //
      ]);
    });

    test('partial grid, non-full width, optimized', () {
      final grid = GridLike.withList(
        [
          0, 0, 0, //
          0, 0, 0, //
        ],
        width: 3,
        height: 2,
      );
      GridLike.fillRectFrom(
        grid,
        [1, 2],
        bounds: Rect.fromLTWH(1, 0, 2, 1),
      );

      check(GridLike.getRect(grid)).deepEquals([
        0, 1, 2, //
        0, 0, 0, //
      ]);
    });
  });

  group('copyRect', () {
    test('full grid, naive', () {
      final grid = _NaiveGrid(3, 2, 1);
      final copy = _NaiveGrid(3, 2, 0);
      GridLike.copyRect(grid, copy);

      check(GridLike.getRect(copy)).deepEquals([
        1, 1, 1, //
        1, 1, 1, //
      ]);
    });

    test('full grid, optimized', () {
      final grid = GridLike.withList(
        [
          1, 1, 1, //
          1, 1, 1, //
        ],
        width: 3,
        height: 2,
      );
      final copy = GridLike.withList(
        [
          0, 0, 0, //
          0, 0, 0, //
        ],
        width: 3,
        height: 2,
      );
      GridLike.copyRect(grid, copy);

      check(GridLike.getRect(copy)).deepEquals([
        1, 1, 1, //
        1, 1, 1, //
      ]);
    });
  });

  group('copyRectUnsafe', () {
    test('full grid, naive', () {
      final grid = _NaiveGrid(3, 2, 1);
      final copy = _NaiveGrid(3, 2, 0);
      GridLike.copyRectUnsafe(grid, copy);

      check(GridLike.getRect(copy)).deepEquals([
        1, 1, 1, //
        1, 1, 1, //
      ]);
    });

    test('full grid, optimized', () {
      final grid = GridLike.withList(
        [
          1, 1, 1, //
          1, 1, 1, //
        ],
        width: 3,
        height: 2,
      );
      final copy = GridLike.withList(
        [
          0, 0, 0, //
          0, 0, 0, //
        ],
        width: 3,
        height: 2,
      );
      GridLike.copyRectUnsafe(grid, copy);

      check(GridLike.getRect(copy)).deepEquals([
        1, 1, 1, //
        1, 1, 1, //
      ]);
    });

    test('full width, optimized', () {
      final grid = GridLike.withList(
        [
          1, 2, 3, //
          4, 5, 6, //
        ],
        width: 3,
        height: 2,
      );
      final copy = GridLike.withList(
        [
          0, 0, 0, //
          0, 0, 0, //
        ],
        width: 3,
        height: 2,
      );
      GridLike.copyRectUnsafe(
        grid,
        copy,
        source: Rect.fromWH(3, 1),
      );

      check(GridLike.getRect(copy)).deepEquals([
        1, 2, 3, //
        0, 0, 0, //
      ]);
    });

    test('partial width, tall, optimized', () {
      final grid = GridLike.withList(
        [
          01, 02, 03, 04, //
          05, 06, 07, 08, //
          09, 10, 11, 12, //
        ],
        width: 4,
        height: 3,
      );
      final copy = GridLike.withList(
        [
          0, 0, 0, 0, //
          0, 0, 0, 0, //
          0, 0, 0, 0, //
        ],
        width: 4,
        height: 3,
      );

      // Copy {06, 07, 10, 11} of SRC to the bottom right corner of DST.
      GridLike.copyRectUnsafe(
        grid,
        copy,
        source: Rect.fromLTWH(1, 1, 2, 2),
        target: Pos(2, 2),
      );
    });
  });
}

// A grid that does not expose the underlying list.
final class _NaiveGrid<T> with GridLike<T> {
  _NaiveGrid(
    this.width,
    this.height,
    T value,
  ) : _values = List.generate(width * height, (_) => value);
  final List<T> _values;

  @override
  final int width;

  @override
  final int height;

  @override
  T getUnsafe(Pos pos) => _values[pos.y * width + pos.x];

  @override
  void setUnsafe(Pos pos, T value) {
    _values[pos.y * width + pos.x] = value;
  }
}
