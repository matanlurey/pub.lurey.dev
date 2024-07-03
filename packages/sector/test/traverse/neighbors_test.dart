import '../_prelude.dart';

void main() {
  test('neighbors returns N, E, S, W neighbors', () {
    final grid = Grid.fromRows([
      [1, 2, 3],
      [4, 5, 6],
      [7, 8, 9],
    ]);
    final results = grid.traverse(neighbors(1, 1));
    check(results).deepEquals([2, 6, 8, 4]);
  });

  test('neighbors omits out-of-bounds neighbors', () {
    final grid = Grid.fromRows([
      [1, 2, 3],
      [4, 5, 6],
      [7, 8, 9],
    ]);
    final results = grid.traverse(neighbors(0, 0));
    check(results).deepEquals([null, 2, 4, null]);
  });

  test('neighbors with diagonals returns more', () {
    final grid = Grid.fromRows([
      [1, 2, 3],
      [4, 5, 6],
      [7, 8, 9],
    ]);
    final results = grid.traverse(neighborsDiagonal(1, 1));
    check(results).deepEquals([2, 3, 6, 9, 8, 7, 4, 1]);
  });

  test('neighbors with diagonals omits out-of-bounds neighbors', () {
    final grid = Grid.fromRows([
      [1, 2, 3],
      [4, 5, 6],
      [7, 8, 9],
    ]);
    final results = grid.traverse(neighborsDiagonal(0, 0));
    check(results).deepEquals([null, null, 2, 5, 4, null, null, null]);
  });
}
