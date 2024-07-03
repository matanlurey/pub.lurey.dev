import '../_prelude.dart';

void main() {
  test('breadth first traversal', () {
    final grid = Grid.fromRows([
      [1, 2, 3],
      [4, 5, 6],
      [7, 8, 9],
    ]);
    final results = grid.traverse(breadthFirst(1, 1));
    check(results).deepEquals([
      5, 2, 6, //
      8, 4, 3, //
      1, 9, 7, //
    ]);
  });
}
