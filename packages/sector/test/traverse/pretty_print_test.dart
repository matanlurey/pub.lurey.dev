import '../_prelude.dart';

void main() {
  test('draws a grid all pretty like', () {
    final grid = Grid.fromRows([
      [1, 2, 3],
      [4, 5, 6],
      [7, 8, 9],
    ]);
    final pretty = grid.traverse(prettyPrint());
    check(pretty).equals(
      '┌───────┐\n'
      '│ 1 2 3 │\n'
      '│ 4 5 6 │\n'
      '│ 7 8 9 │\n'
      '└───────┘',
    );
  });
}
