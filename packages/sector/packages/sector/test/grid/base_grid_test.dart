import '../prelude.dart';
import '../src/naive_grid.dart';

void main() {
  test('should return the length', () {
    final grid = NaiveGrid(
      [
        [0, 1, 2, 3, 4],
        [1, 2, 3, 4, 5],
        [2, 3, 4, 5, 6],
      ],
      empty: 0,
    );

    check(grid.length).equals(15);
  });

  test('should return rows', () {
    final grid = NaiveGrid(
      [
        [0, 1, 2, 3, 4],
        [1, 2, 3, 4, 5],
        [2, 3, 4, 5, 6],
      ],
      empty: 0,
    );

    check(grid.rows).deepEquals([
      [0, 1, 2, 3, 4],
      [1, 2, 3, 4, 5],
      [2, 3, 4, 5, 6],
    ]);
  });

  test('should return columns', () {
    final grid = NaiveGrid(
      [
        [0, 1, 2, 3, 4],
        [1, 2, 3, 4, 5],
        [2, 3, 4, 5, 6],
      ],
      empty: 0,
    );

    check(grid.columns).deepEquals([
      [0, 1, 2],
      [1, 2, 3],
      [2, 3, 4],
      [3, 4, 5],
      [4, 5, 6],
    ]);
  });

  test('should return toString()', () {
    final grid = NaiveGrid(
      [
        [0, 1, 2, 3, 4],
        [1, 2, 3, 4, 5],
        [2, 3, 4, 5, 6],
      ],
      empty: 0,
    );

    check(grid.toString()).equals(
      '#....\n'
      '.....\n'
      '.....\n',
    );
  });

  test('.rows should have efficient iterable access', () {
    final grid = NaiveGrid(
      [
        [0, 1, 2, 3, 4],
        [1, 2, 3, 4, 5],
        [2, 3, 4, 5, 6],
      ],
      empty: 0,
    );

    final rows = grid.rows;

    final forEach = <int>[];
    rows.forEach(forEach.addAll);
    check(forEach).deepEquals([0, 1, 2, 3, 4, 1, 2, 3, 4, 5, 2, 3, 4, 5, 6]);

    final first = rows.first;
    check(first).deepEquals([0, 1, 2, 3, 4]);

    final last = rows.last;
    check(last).deepEquals([2, 3, 4, 5, 6]);

    check(() => rows.single).throws<StateError>();

    check(rows).every((row) => row.length.equals(5));
    check(rows).any((row) => row.contains(3));
    check(rows.firstWhere((row) => row.contains(3)).contains(3)).isTrue();
    check(
      rows.firstWhere((row) => row.contains(7), orElse: () => [7]),
    ).deepEquals([7]);
    check(rows.lastWhere((row) => row.contains(3)).contains(3)).isTrue();
    check(
      rows.lastWhere((row) => row.contains(7), orElse: () => [7]),
    ).deepEquals([7]);
    check(
      () => rows.singleWhere((row) => row.contains(3)).contains(3),
    ).throws<StateError>();
    check(
      rows.singleWhere((row) => row.contains(7), orElse: () => [7]),
    ).deepEquals([7]);

    check(rows.join()).equals('(0, 1, 2, 3, 4)(1, 2, 3, 4, 5)(2, 3, 4, 5, 6)');

    check(rows.reduce((value, element) => [...value, ...element])).deepEquals(
      [0, 1, 2, 3, 4, 1, 2, 3, 4, 5, 2, 3, 4, 5, 6],
    );

    check(
      rows.fold<int>(
        0,
        (previousValue, element) => previousValue + element.length,
      ),
    ).equals(15);

    check(rows.skip(1)).deepEquals([
      [1, 2, 3, 4, 5],
      [2, 3, 4, 5, 6],
    ]);

    check(rows.skip(5)).isEmpty();

    check(rows.skip(1).skip(1)).deepEquals([
      [2, 3, 4, 5, 6],
    ]);

    check(rows.take(1)).deepEquals([
      [0, 1, 2, 3, 4],
    ]);

    check(rows.take(5)).deepEquals([
      [0, 1, 2, 3, 4],
      [1, 2, 3, 4, 5],
      [2, 3, 4, 5, 6],
    ]);

    check(rows.toList()).deepEquals([
      [0, 1, 2, 3, 4],
      [1, 2, 3, 4, 5],
      [2, 3, 4, 5, 6],
    ]);
  });
}
