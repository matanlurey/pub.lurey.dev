import '../../_prelude.dart';

/// Run a test suite that mutates the grid in place without resizing the grid.
void runMutableInPlaceTestSuite(
  Grid<T> Function<T>(Iterable<Iterable<T>>) fromRows,
) {
  test('set should update the cell', () {
    final grid = fromRows([
      [1, 2],
      [3, 4],
    ]);
    grid.set(0, 0, 5);
    check(grid.get(0, 0)).equals(5);
  });

  test('set should throw if the cell is out of bounds', () {
    final grid = fromRows([
      [1, 2],
      [3, 4],
    ]);
    check(() => grid.set(2, 0, 5)).throws<RangeError>();
    check(() => grid.set(0, 2, 5)).throws<RangeError>();
    check(() => grid.set(2, 2, 5)).throws<RangeError>();
    check(grid.rows).deepEquals([
      [1, 2],
      [3, 4],
    ]);
  });
}
