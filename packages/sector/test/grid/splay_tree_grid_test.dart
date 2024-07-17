import '../prelude.dart';

void main() {
  test('should create an empty SplayTreeGrid', () {
    final grid = SplayTreeGrid.filled(20, 10, empty: 0);

    check(grid).width.equals(20);
    check(grid).height.equals(10);
    check(grid).isEmpty();
    check(grid).nonEmptyEntries.isEmpty();
  });

  test('should iterate through rows with empty grid', () {
    final grid = SplayTreeGrid.filled(5, 3, empty: 0);

    check(grid).rows.deepEquals([
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
    ]);
  });

  test('should iterate through columns with empty grid', () {
    final grid = SplayTreeGrid.filled(5, 3, empty: 0);

    check(grid).columns.deepEquals([
      [0, 0, 0],
      [0, 0, 0],
      [0, 0, 0],
      [0, 0, 0],
      [0, 0, 0],
    ]);

    check(() => grid.nonEmptyEntries.first).throws<StateError>();
    check(() => grid.nonEmptyEntries.last).throws<StateError>();
    check(grid.nonEmptyEntries.length).equals(0);
  });

  test('should contain non-empty elements', () {
    final grid = SplayTreeGrid.filled(5, 3, empty: 0);
    grid.set(Pos(1, 1), 1);

    check(grid).isNotEmpty();
    check(grid.get(Pos(1, 1))).equals(1);
    check(grid.nonEmptyEntries.first).equals((Pos(1, 1), 1));
    check(grid.nonEmptyEntries.last).equals((Pos(1, 1), 1));
    check(grid.nonEmptyEntries.length).equals(1);
    check(grid).nonEmptyEntries.deepEquals([
      (Pos(1, 1), 1),
    ]);
  });

  test('should iterate through rows with non-empty grid', () {
    final grid = SplayTreeGrid.filled(5, 3, empty: 0);
    grid.set(Pos(1, 1), 1);
    grid.set(Pos(3, 1), 1);
    grid.set(Pos(2, 2), 1);

    check(grid).rows.deepEquals([
      [0, 0, 0, 0, 0],
      [0, 1, 0, 1, 0],
      [0, 0, 1, 0, 0],
    ]);
  });

  test('should iterate through columns with non-empty grid', () {
    final grid = SplayTreeGrid.filled(5, 3, empty: 0);
    grid.set(Pos(1, 1), 1);

    check(grid).columns.deepEquals([
      [0, 0, 0],
      [0, 1, 0],
      [0, 0, 0],
      [0, 0, 0],
      [0, 0, 0],
    ]);
  });

  test('should generate a splay tree grid', () {
    final grid = SplayTreeGrid.generate(
      5,
      3,
      (pos) => pos.x + pos.y,
      empty: 0,
    );
    check(grid).rows.deepEquals([
      [0, 1, 2, 3, 4],
      [1, 2, 3, 4, 5],
      [2, 3, 4, 5, 6],
    ]);

    final copy = SplayTreeGrid.from(grid);
    check(copy).rows.deepEquals([
      [0, 1, 2, 3, 4],
      [1, 2, 3, 4, 5],
      [2, 3, 4, 5, 6],
    ]);
    check(copy.rows.first.length).equals(5);
    check(copy.rows.first.elementAt(0)).equals(grid.rows.first.elementAt(0));
  });

  test('should copy from another grid type', () {
    final other = ListGrid.generate(
      5,
      3,
      (pos) => pos.x + pos.y,
      empty: 0,
    );

    final grid = SplayTreeGrid.from(other);
    check(grid).rows.deepEquals([
      [0, 1, 2, 3, 4],
      [1, 2, 3, 4, 5],
      [2, 3, 4, 5, 6],
    ]);
  });

  test('should grow the width of the grid', () {
    final grid = SplayTreeGrid.filled(5, 3, empty: 0);
    grid.width = 7;

    check(grid).width.equals(7);
    check(grid).height.equals(3);
    check(grid).rows.deepEquals([
      [0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0],
    ]);
  });

  test('should shrink the width of the grid', () {
    final grid = SplayTreeGrid.filled(5, 3, empty: 0);
    grid.width = 3;

    check(grid).width.equals(3);
    check(grid).height.equals(3);
    check(grid).rows.deepEquals([
      [0, 0, 0],
      [0, 0, 0],
      [0, 0, 0],
    ]);
  });

  test('should grow the height of the grid', () {
    final grid = SplayTreeGrid.filled(5, 3, empty: 0);
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

  test('should shrink the height of the grid', () {
    final grid = SplayTreeGrid.filled(5, 3, empty: 0);
    grid.height = 1;

    check(grid).width.equals(5);
    check(grid).height.equals(1);
    check(grid).rows.deepEquals([
      [0, 0, 0, 0, 0],
    ]);
  });
}
