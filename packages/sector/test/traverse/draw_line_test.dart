import '../_prelude.dart';

void main() {
  test('should draw a line from (0, 0) to (2, 2)', () {
    final grid = Grid.fromRows([
      [1, 2, 3],
      [4, 5, 6],
      [7, 8, 9],
    ]);
    check(grid.traverse(drawLine(0, 0, 2, 2))).deepEquals([1, 5, 9]);
  });

  test('should draw a line from (0, 0) to (2, 2) exclusive', () {
    final grid = Grid.fromRows([
      [1, 2, 3],
      [4, 5, 6],
      [7, 8, 9],
    ]);
    check(
      grid.traverse(drawLine(0, 0, 2, 2, inclusive: false)),
    ).deepEquals([1, 5]);
  });

  test('should draw a line from (2, 2) to (0, 0)', () {
    final grid = Grid.fromRows([
      [1, 2, 3],
      [4, 5, 6],
      [7, 8, 9],
    ]);
    check(grid.traverse(drawLine(2, 2, 0, 0))).deepEquals([9, 5, 1]);
  });

  test('should fail to draw a line from (0, 0) to (3, 3)', () {
    final grid = Grid.fromRows([
      [1, 2, 3],
      [4, 5, 6],
      [7, 8, 9],
    ]);
    check(
      () => grid.traverse(drawLine(0, 0, 3, 3)),
    ).throws<Error>();
  });

  test('should fail to draw a line from (0, 0) to (2, 3)', () {
    final grid = Grid.fromRows([
      [1, 2, 3],
      [4, 5, 6],
      [7, 8, 9],
    ]);
    check(
      () => grid.traverse(drawLine(0, 0, 2, 3)),
    ).throws<Error>();
  });

  test('should fail to draw a line from (0, 0) to (3, 2)', () {
    final grid = Grid.fromRows([
      [1, 2, 3],
      [4, 5, 6],
      [7, 8, 9],
    ]);
    check(
      () => grid.traverse(drawLine(0, 0, 3, 2)),
    ).throws<Error>();
  });
}
