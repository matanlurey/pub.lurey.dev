import '../prelude.dart';

void main() {
  test('should create a filled empty grid', () {
    final grid = ListGrid.filled(20, 10, empty: 0);

    check(grid).width.equals(20);
    check(grid).height.equals(10);
    check(grid).isEmpty();
  });

  test('should generate a grid with a function', () {
    final grid = ListGrid.generate(5, 3, (Pos p) => p.x + p.y, empty: 0);

    check(grid).rows.deepEquals([
      [0, 1, 2, 3, 4],
      [1, 2, 3, 4, 5],
      [2, 3, 4, 5, 6],
    ]);

    check(grid).width.equals(5);
    check(grid).height.equals(3);
    check(grid).isNotEmpty();
  });

  test('should copy a ListGrid', () {
    final other = ListGrid.generate(5, 3, (Pos p) => p.x + p.y, empty: 0);

    final grid = ListGrid.from(other);
    check(grid).rows.deepEquals([
      [0, 1, 2, 3, 4],
      [1, 2, 3, 4, 5],
      [2, 3, 4, 5, 6],
    ]);
  });

  test('should copy a SplayTreeGrid', () {
    final other = SplayTreeGrid.generate(5, 3, (Pos p) => p.x + p.y, empty: 0);

    final grid = ListGrid.from(other);
    check(grid).rows.deepEquals([
      [0, 1, 2, 3, 4],
      [1, 2, 3, 4, 5],
      [2, 3, 4, 5, 6],
    ]);
  });

  test('should create a grid fromRows', () {
    final grid = ListGrid.fromRows([
      [0, 1, 2, 3, 4],
      [1, 2, 3, 4, 5],
      [2, 3, 4, 5, 6],
    ]);

    check(grid).rows.deepEquals([
      [0, 1, 2, 3, 4],
      [1, 2, 3, 4, 5],
      [2, 3, 4, 5, 6],
    ]);
  });

  test('should fail fromRows if not same width', () {
    check(
      () => ListGrid.fromRows([
        [0, 1, 2, 3, 4],
        [1, 2, 3, 4],
        [2, 3, 4, 5, 6],
      ]),
    ).throws<ArgumentError>();
  });

  test('should fail if fromRows empty and no empty', () {
    check(
      () => ListGrid<int>.fromRows([[]]),
    ).throws<StateError>();
  });

  test('should create a grid fromCells', () {
    final grid = ListGrid.fromCells(
      [
        0, 1, 2, 3, 4, //
        1, 2, 3, 4, 5, //
        2, 3, 4, 5, 6, //
      ],
      width: 5,
    );

    check(grid).rows.deepEquals([
      [0, 1, 2, 3, 4],
      [1, 2, 3, 4, 5],
      [2, 3, 4, 5, 6],
    ]);
  });

  test('should return an empty grid fromCells', () {
    final grid = ListGrid.fromCells([], width: 0, empty: 0);

    check(grid).isEmpty();
  });

  test('should fail fromCells if not a multiple of width', () {
    check(
      () => ListGrid.fromCells([0, 1, 2, 3, 4], width: 3, empty: 0),
    ).throws<ArgumentError>();
  });

  test('should create a grid withList', () {
    final grid = ListGrid.withList([0, 0, 0, 0], width: 2, empty: 0);

    check(grid).rows.deepEquals([
      [0, 0],
      [0, 0],
    ]);
  });

  test('should fail withList if not a multiple of width', () {
    check(
      () => ListGrid.withList([0, 0, 0, 0], width: 3, empty: 0),
    ).throws<ArgumentError>();
  });

  test('should create a grid fromRows with 0 cells', () {
    final grid = ListGrid.fromRows([], empty: 0);

    check(grid).isEmpty();
  });

  test('should resize the grid by expanding width', () {
    final grid = ListGrid.generate(5, 3, (Pos p) => p.x + p.y, empty: 0);
    grid.width = 7;

    check(grid).width.equals(7);
    check(grid).height.equals(3);
    check(grid).rows.deepEquals([
      [0, 1, 2, 3, 4, 0, 0],
      [1, 2, 3, 4, 5, 0, 0],
      [2, 3, 4, 5, 6, 0, 0],
    ]);
  });

  test('should resize the grid by shrinking width', () {
    final grid = ListGrid.filled(5, 3, empty: 0);
    grid.width = 3;

    check(grid).width.equals(3);
    check(grid).height.equals(3);
    check(grid).rows.deepEquals([
      [0, 0, 0],
      [0, 0, 0],
      [0, 0, 0],
    ]);
  });

  test('should resize the grid by expanding height', () {
    final grid = ListGrid.filled(5, 3, empty: 0);
    grid.height = 5;

    check(grid).width.equals(5);
    check(grid).height.equals(5);
    check(grid).rows.deepEquals([
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
    ]);
  });

  test('should resize the grid by shrinking height', () {
    final grid = ListGrid.filled(5, 3, empty: 0);
    grid.height = 1;

    check(grid).width.equals(5);
    check(grid).height.equals(1);
    check(grid).rows.deepEquals([
      [0, 0, 0, 0, 0],
    ]);
  });

  test('should set the cell at a position', () {
    final grid = ListGrid.filled(5, 3, empty: 0);
    grid[Pos(2, 1)] = 4;

    check(grid).rows.deepEquals([
      [0, 0, 0, 0, 0],
      [0, 0, 4, 0, 0],
      [0, 0, 0, 0, 0],
    ]);
  });

  test('should fail to get a cell out of bounds', () {
    final grid = ListGrid.filled(5, 3, empty: 0);
    check(() => grid[Pos(5, 1)]).throws<RangeError>();
  });

  test('should fail to set a cell out of bounds', () {
    final grid = ListGrid.filled(5, 3, empty: 0);
    check(() => grid[Pos(5, 1)] = 4).throws<RangeError>();
  });

  test('should adapt to a walkable', () {
    final grid = ListGrid<double>.fromRows([
      [1, 2, 3],
      [4, 5, 6],
      [7, 8, 9],
    ]);

    final graph = grid.asWeighted(weight: (a, b, _) => (a - b).abs());
    check(graph.roots.toList()).unorderedEquals([
      Pos(0, 0),
      Pos(1, 0),
      Pos(2, 0),
      Pos(0, 1),
      Pos(1, 1),
      Pos(2, 1),
      Pos(0, 2),
      Pos(1, 2),
      Pos(2, 2),
    ]);

    check(graph.successors(Pos(1, 1)).toList()).unorderedEquals([
      (Pos(1, 0), 3.0),
      (Pos(2, 1), 1.0),
      (Pos(1, 2), 3.0),
      (Pos(0, 1), 1.0),
    ]);
  });

  test('should adapt diagonal to a walkable', () {
    final grid = ListGrid<double>.fromRows(
      [
        [1, 2, 3],
        [4, 5, 6],
        [7, 8, 9],
      ],
      empty: 0,
    );

    final graph = GridWalkable.diagonal(
      grid,
      weight: (a, b, _) => (a - b).abs(),
    );
    check(graph.roots.toList()).unorderedEquals([
      Pos(0, 0),
      Pos(1, 0),
      Pos(2, 0),
      Pos(0, 1),
      Pos(1, 1),
      Pos(2, 1),
      Pos(0, 2),
      Pos(1, 2),
      Pos(2, 2),
    ]);

    check(graph.successors(Pos(1, 1)).toList()).unorderedEquals([
      (Pos(2, 0), 2.0),
      (Pos(2, 2), 4.0),
      (Pos(0, 2), 2.0),
      (Pos(0, 0), 4.0),
    ]);
  });

  test('should adapt all8Positions to a walkable', () {
    final grid = ListGrid<double>.fromRows(
      [
        [1, 2, 3],
        [4, 5, 6],
        [7, 8, 9],
      ],
      empty: 0,
    );

    final graph = GridWalkable.all8Directions(
      grid,
      weight: (a, b, _) => (a - b).abs(),
    );
    check(graph.roots.toList()).unorderedEquals([
      Pos(0, 0),
      Pos(1, 0),
      Pos(2, 0),
      Pos(0, 1),
      Pos(1, 1),
      Pos(2, 1),
      Pos(0, 2),
      Pos(1, 2),
      Pos(2, 2),
    ]);

    check(graph.successors(Pos(1, 1)).toList()).length.equals(8);
    check(graph.successors(Pos(1, 1)).toList()).deepEquals([
      (Pos(1, 0), 3.0),
      (Pos(2, 0), 2.0),
      (Pos(2, 1), 1.0),
      (Pos(2, 2), 4.0),
      (Pos(1, 2), 3.0),
      (Pos(0, 2), 2.0),
      (Pos(0, 1), 1.0),
      (Pos(0, 0), 4.0),
    ]);
  });

  test('should support custom directions', () {
    final grid = ListGrid<double>.fromRows([
      [1, 2, 3],
      [4, 5, 6],
      [7, 8, 9],
    ]);

    final graph = GridWalkable.from(
      grid,
      directions: [
        Pos(1, 0),
        Pos(0, 1),
        Pos(-1, 0),
        Pos(0, -1),
      ],
      weight: (a, b, _) => (a - b).abs(),
    );

    check(graph.roots).unorderedEquals([
      Pos(0, 0),
      Pos(1, 0),
      Pos(2, 0),
      Pos(0, 1),
      Pos(1, 1),
      Pos(2, 1),
      Pos(0, 2),
      Pos(1, 2),
      Pos(2, 2),
    ]);

    check(graph.successors(Pos(1, 1))).unorderedEquals([
      (Pos(2, 1), 1.0),
      (Pos(1, 2), 3.0),
      (Pos(0, 1), 1.0),
      (Pos(1, 0), 3.0),
    ]);
  });
}
