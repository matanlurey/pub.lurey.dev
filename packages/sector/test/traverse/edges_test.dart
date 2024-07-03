import '../_prelude.dart';

void main() {
  test('edges traversal', () {
    final grid = Grid.fromRows([
      [1, 2, 3],
      [4, 5, 6],
      [7, 8, 9],
    ]);
    final results = grid.traverse(edges);
    check(results).deepEquals([
      1, 2, 3, //
      6, 9, 8, //
      7, 4, 1, //
    ]);
  });
}
