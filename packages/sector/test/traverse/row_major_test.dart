import 'package:sector/sector.dart';

import '../_prelude.dart';
import '../custom_grid_test.dart';

void main() {
  group('rowMajor (Slow)', () {
    test('should traverse', () {
      final grid = NaiveListGrid.fromRows([
        [1, 2, 3],
        [4, 5, 6],
      ]);
      check(grid.traverse()).deepEquals([1, 2, 3, 4, 5, 6]);
    });

    test('should traverse with a custom starting point', () {
      final grid = NaiveListGrid.fromRows([
        [1, 2, 3],
        [4, 5, 6],
      ]);
      check(grid.traverse(rowMajor(start: (1, 0)))).deepEquals([
        2,
        3,
        4,
        5,
        6,
      ]);
    });

    test('should support seek', () {
      final grid = NaiveListGrid.fromRows([
        [1, 2, 3],
        [4, 5, 6],
      ]);
      final iterator = rowMajor<int>()(grid).iterator as GridIterator<int>;
      iterator.seek(2);
      check(iterator.current).equals(2);
    });

    test('should support iterable.last', () {
      final grid = NaiveListGrid.fromRows([
        [1, 2, 3],
        [4, 5, 6],
      ]);
      check(grid.traverse()).last.equals(6);
    });

    test('should support position', () {
      final grid = NaiveListGrid.fromRows([
        [1, 2, 3],
        [4, 5, 6],
      ]);
      final iterator = rowMajor<int>()(grid).iterator as GridIterator<int>;
      iterator.moveNext();
      check(iterator.position).equals((0, 0));
    });
  });

  group('rowMajor (Optimized)', () {
    test('should traverse', () {
      final grid = Grid.fromRows([
        [1, 2, 3],
        [4, 5, 6],
      ]);
      check(grid.traverse()).deepEquals([1, 2, 3, 4, 5, 6]);
    });

    test('should traverse with a custom starting point', () {
      final grid = Grid.fromRows([
        [1, 2, 3],
        [4, 5, 6],
      ]);
      check(grid.traverse(rowMajor(start: (1, 0)))).deepEquals([
        2,
        3,
        4,
        5,
        6,
      ]);
    });

    test('should support seek', () {
      final grid = Grid.fromRows([
        [1, 2, 3],
        [4, 5, 6],
      ]);
      final iterator = rowMajor<int>()(grid).iterator as GridIterator<int>;
      iterator.seek(2);
      check(iterator.current).equals(2);
    });

    test('should support iterable.last', () {
      final grid = Grid.fromRows([
        [1, 2, 3],
        [4, 5, 6],
      ]);
      check(grid.traverse()).last.equals(6);
    });

    test('should support position', () {
      final grid = Grid.fromRows([
        [1, 2, 3],
        [4, 5, 6],
      ]);
      final iterator = rowMajor<int>()(grid).iterator as GridIterator<int>;
      iterator.moveNext();
      check(iterator.position).equals((0, 0));
    });
  });
}
