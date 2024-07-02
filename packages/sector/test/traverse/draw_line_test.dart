import '../_prelude.dart';

void main() {
  group('drawLine', () {
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
  });
}
