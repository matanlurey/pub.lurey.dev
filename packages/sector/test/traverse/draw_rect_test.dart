import '../_prelude.dart';

void main() {
  test('should draw a rect from (0, 0) to (2, 2)', () {
    final grid = Grid.fromRows([
      [1, 2, 3],
      [4, 5, 6],
      [7, 8, 9],
    ]);
    check(grid.traverse(drawRect(0, 0, 2, 2))).deepEquals([1, 2, 4, 5]);
    check(grid.traverse(drawRect(0, 0, 2, 2)).positions).deepEquals([
      (0, 0),
      (1, 0),
      (0, 1),
      (1, 1),
    ]);
  });
}
